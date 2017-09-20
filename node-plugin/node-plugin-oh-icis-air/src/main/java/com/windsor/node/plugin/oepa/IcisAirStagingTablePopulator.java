package com.windsor.node.plugin.oepa;

import com.windsor.node.common.domain.CommonTransactionStatusCode;
import com.windsor.node.common.domain.DataServiceRequestParameter;
import com.windsor.node.common.domain.NamedSystemConfigItem;
import com.windsor.node.common.domain.NodeTransaction;
import com.windsor.node.common.domain.PluginServiceImplementorDescriptor;
import com.windsor.node.common.domain.ProcessContentResult;
import com.windsor.node.common.domain.ServiceType;
import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.plugin.BaseWnosPlugin;
import com.windsor.node.plugin.oepa.domain.CaseFileLinkage;
import com.windsor.node.plugin.oepa.domain.ComplianceMonitoringLinkage;
import com.windsor.node.plugin.oepa.domain.HasComplianceMonitoringIdentifier;
import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringStrategy;
import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
import com.windsor.node.plugin.oepa.domain.IcisAirDaEnforcementActionLinkage;
import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirDaInformalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirFacility;
import com.windsor.node.plugin.oepa.domain.IcisAirPayload;
import com.windsor.node.plugin.oepa.domain.IcisAirPollutants;
import com.windsor.node.plugin.oepa.domain.IcisAirPrograms;
import com.windsor.node.plugin.oepa.domain.IcisAirTvaccData;
import com.windsor.node.plugin.oepa.domain.IcisFedExportData;
import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import com.windsor.node.service.helper.IdGenerator;
import com.windsor.node.service.helper.settings.SettingServiceProvider;
import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.persistence.spi.PersistenceUnitTransactionType;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class IcisAirStagingTablePopulator extends BaseWnosPlugin {
   public static final PluginServiceParameterDescriptor DATA_DAEMON_DIRECTORY;
   private SettingServiceProvider settingService;
   private IdGenerator idGenerator;
   protected Logger logger = LoggerFactory.getLogger(IcisAirStagingTablePopulator.class);
   private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;

   public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
      return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
   }

   public IcisAirStagingTablePopulator() {
      this.getConfigurationArguments().put(DATA_DAEMON_DIRECTORY.getName(), "");
      this.getDataSources().put("Target Data Provider", null);
      this.getSupportedPluginTypes().add(ServiceType.TASK);
   }

   public List<PluginServiceParameterDescriptor> getParameters() {
      ArrayList params = new ArrayList();
      return params;
   }

   public ProcessContentResult process(NodeTransaction transaction) {
      this.debug("Processing transaction...");
      ProcessContentResult result = new ProcessContentResult();
      result.setSuccess(false);
      result.setStatus(CommonTransactionStatusCode.Failed);
      this.validateTransaction(transaction);
      this.logger.debug("Transaction is valid.");

      try {
         String e = "incoming";
         String archivedDirectory = "archived";
         String workingDirectory = "working";
         String rootPath = this.getDataDaemonDirectory(transaction);
         File incomingPath = new File(rootPath + File.separatorChar + e);
         File archivedPath = new File(rootPath + File.separatorChar + archivedDirectory);
         File workingPath = new File(rootPath + File.separatorChar + workingDirectory);
         FileFilter xmlFileFilter = new FileFilter() {
            public boolean accept(File pathname) {
               return pathname != null && StringUtils.isNotBlank(pathname.getName()) && pathname.getName().endsWith(".xml");
            }
         };
         File[] deadFiles = workingPath.listFiles(xmlFileFilter);

         for(int incomingFiles = 0; deadFiles != null && incomingFiles < deadFiles.length; ++incomingFiles) {
            this.logger.warn("Dead file exists in " + workingPath.getCanonicalPath() + ", file name is " + deadFiles[incomingFiles] + ", removing.");
            result.getAuditEntries().add(this.makeEntry("WARNING:  Dead file exists, removing file name \"" + deadFiles[incomingFiles].getName() + "\""));
            FileUtils.deleteQuietly(deadFiles[incomingFiles]);
         }

         File[] var18 = incomingPath.listFiles(xmlFileFilter);

         for(int workingFiles = 0; var18 != null && workingFiles < var18.length; ++workingFiles) {
            if(workingFiles == 0) {
               result.getAuditEntries().add(this.makeEntry("Incoming files exist, count:  " + var18.length));
            }

            File previousData = var18[workingFiles];
            FileUtils.moveFileToDirectory(previousData, workingPath, Boolean.TRUE.booleanValue());
            if(workingFiles == var18.length - 1) {
               result.getAuditEntries().add(this.makeEntry("Moved incoming files to the working directory."));
            }
         }

         File[] var19 = workingPath.listFiles(xmlFileFilter);
         IcisFedExportData var20 = null;

         int i;
         File currentFile;
         for(i = 0; var19 != null && i < var19.length; ++i) {
            if(i == 0) {
               result.getAuditEntries().add(this.makeEntry("Processing working files, count:  " + var19.length));
            }

            result.getAuditEntries().add(this.makeEntry("Processing file name \"" + var19[i].getName() + "\""));
            currentFile = var19[i];
            var20 = this.processFile(currentFile, var20, Boolean.valueOf(i == var19.length - 1), result);
            if(i == var18.length - 1) {
               result.getAuditEntries().add(this.makeEntry("All working files processed."));
            }
         }

         var19 = workingPath.listFiles(xmlFileFilter);

         for(i = 0; var19 != null && i < var19.length; ++i) {
            if(i == 0) {
               result.getAuditEntries().add(this.makeEntry("Moving processed working files to archived, count:  " + var19.length));
            }

            currentFile = var19[i];
            FileUtils.moveFileToDirectory(currentFile, archivedPath, Boolean.TRUE.booleanValue());
            if(i == var18.length - 1) {
               result.getAuditEntries().add(this.makeEntry("All working files moved to archived."));
            }
         }
      } catch (Exception var17) {
         result.getAuditEntries().add(this.makeEntry("Exception occured: \n" + var17.getMessage()));
         result.getAuditEntries().add(this.makeEntry("Plugin processing failed."));
         return result;
      }

      result.getAuditEntries().add(this.makeEntry("Plugin processing finished successfully."));
      result.setSuccess(true);
      result.setStatus(CommonTransactionStatusCode.Completed);
      return result;
   }

   private IcisFedExportData processFile(File xmlFile, IcisFedExportData data, Boolean finalFile, ProcessContentResult result) throws JAXBException {
      JAXBContext context = JAXBContext.newInstance("com.windsor.node.plugin.oepa.domain", IcisFedExportData.class.getClassLoader());
      Unmarshaller unmarshaller = context.createUnmarshaller();
      IcisFedExportData facilities = (IcisFedExportData)unmarshaller.unmarshal(xmlFile);
      if(data != null && data.getIcisAirComplianceMonitoringDataList() != null) {
         if(facilities.getIcisAirComplianceMonitoringDataList() == null) {
            facilities.setIcisAirComplianceMonitoringDataList(new ArrayList());
         }

         facilities.getIcisAirComplianceMonitoringDataList().addAll(data.getIcisAirComplianceMonitoringDataList());
      }

      this.logger.info("XML file succesfully loaded into memory:  " + xmlFile.getName());
      if(facilities != null) {
         if(facilities.getIcisAirFacilitiesList() != null) {
            this.logger.info(facilities.getIcisAirFacilitiesList().size() + " IcisAirFacility records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirFacilitiesList(), "AirFacilitySubmission", new Class[]{IcisAirFacility.class});
            this.logger.info("All IcisAirFacility persisted.");
         }

         if(facilities.getIcisAirPollutantsList() != null) {
            this.logger.info(facilities.getIcisAirPollutantsList().size() + " IcisAirPollutants records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirPollutantsList(), "AirPollutantsSubmission", new Class[]{IcisAirPollutants.class});
            this.logger.info("All IcisAirPollutants persisted.");
         }

         if(facilities.getIcisAirProgramsList() != null) {
            this.logger.info(facilities.getIcisAirProgramsList().size() + " IcisAirPrograms records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirProgramsList(), "AirProgramsSubmission", new Class[]{IcisAirPrograms.class});
            this.logger.info("All IcisAirPrograms persisted.");
         }

         if(facilities.getIcisAirComplianceMonitoringDataList() != null) {
            this.logger.info(facilities.getIcisAirComplianceMonitoringDataList().size() + " IcisAirComplianceMonitoringData records were loaded.");
            if(finalFile.booleanValue()) {
               this.checkComplianceMonitoringIdentifierDupes(result, facilities.getIcisAirComplianceMonitoringDataList());
               this.logger.info("Persisting.");
               this.loadStagingData(facilities.getIcisAirComplianceMonitoringDataList(), "AirDAComplianceMonitoringSubmission", new Class[]{IcisAirComplianceMonitoringData.class});
            }

            this.logger.info("All IcisAirComplianceMonitoringData persisted.");
         }

         if(facilities.getIcisAirComplianceMonitoringStrategyList() != null) {
            this.logger.info(facilities.getIcisAirComplianceMonitoringStrategyList().size() + " IcisAirComplianceMonitoringStrategy records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirComplianceMonitoringStrategyList(), "AirComplianceMonitoringStrategySubmission", new Class[]{IcisAirComplianceMonitoringStrategy.class});
            this.logger.info("All IcisAirComplianceMonitoringStrategy persisted.");
         }

         if(facilities.getAirDaCaseFileList() != null) {
            this.logger.info(facilities.getAirDaCaseFileList().size() + " IcisAirDaCaseFile records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getAirDaCaseFileList(), "AirDACaseFileSubmission", new Class[]{IcisAirDaCaseFile.class});
            this.logger.info("All IcisAirDaCaseFile persisted.");
         }

         if(facilities.getAirDaFormalEnforcementAction() != null) {
            this.logger.info(facilities.getAirDaFormalEnforcementAction().size() + " IcisAirDaFormalEnforcementAction records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getAirDaFormalEnforcementAction(), "AirDAFormalEnforcementActionSubmission", new Class[]{IcisAirDaFormalEnforcementAction.class});
            this.logger.info("All IcisAirDaFormalEnforcementAction persisted.");
         }

         if(facilities.getIcisAirDaInformalEnforcementActionList() != null) {
            this.logger.info(facilities.getIcisAirDaInformalEnforcementActionList().size() + " IcisAirDaInformalEnforcementAction records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirDaInformalEnforcementActionList(), "AirDAInformalEnforcementActionSubmission", new Class[]{IcisAirDaInformalEnforcementAction.class});
            this.logger.info("All IcisAirDaInformalEnforcementAction persisted.");
         }

         if(facilities.getIcisAirTvaccDataList() != null) {
            this.logger.info(facilities.getIcisAirTvaccDataList().size() + " AirTVACCData records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirTvaccDataList(), "AirTVACCSubmission", new Class[]{IcisAirTvaccData.class});
            this.logger.info("All AirTVACCData persisted.");
         }

         if(facilities.getIcisAirDaEnforcementActionLinkage() != null) {
            this.logger.info(facilities.getIcisAirDaEnforcementActionLinkage().size() + " IcisAirDaEnforcementActionLinkage records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getIcisAirDaEnforcementActionLinkage(), "AirDAEnforcementActionLinkageSubmission", new Class[]{IcisAirDaEnforcementActionLinkage.class});
            this.logger.info("All IcisAirDaEnforcementActionLinkage persisted.");
         }

         if(facilities.getComplianceMonitoringLinkageList() != null) {
            this.logger.info(facilities.getComplianceMonitoringLinkageList().size() + " ComplianceMonitoringLinkage records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getComplianceMonitoringLinkageList(), "ComplianceMonitoringLinkageSubmission", new Class[]{ComplianceMonitoringLinkage.class});
            this.logger.info("All ComplianceMonitoringLinkage persisted.");
         }

         if(facilities.getCaseFileLinkageList() != null) {
            this.logger.info(facilities.getCaseFileLinkageList().size() + " CaseFileLinkage records were loaded.");
            this.logger.info("Persisting.");
            this.loadStagingData(facilities.getCaseFileLinkageList(), "CaseFileLinkageSubmission", new Class[]{CaseFileLinkage.class});
            this.logger.info("All CaseFileLinkage persisted.");
         }
      }

      return facilities;
   }

   private void checkComplianceMonitoringIdentifierDupes(ProcessContentResult result, List<?> list) {
      HashSet complianceMonitoringIdentifiers = new HashSet();
      HashMap dupes = new HashMap();

      String currentIdentifier;
      for(int dupeKeys = 0; dupeKeys < list.size(); ++dupeKeys) {
         currentIdentifier = ((HasComplianceMonitoringIdentifier)list.get(dupeKeys)).getComplianceMonitoringIdentifier();
         if(complianceMonitoringIdentifiers.contains(currentIdentifier)) {
            if(dupes.containsKey(currentIdentifier)) {
               dupes.put(currentIdentifier, new Integer(((Integer)dupes.get(currentIdentifier)).intValue() + 1));
            } else {
               dupes.put(currentIdentifier, new Integer(2));
            }
         } else {
            complianceMonitoringIdentifiers.add(currentIdentifier);
         }
      }

      Iterator var7 = dupes.keySet().iterator();

      while(var7.hasNext()) {
         currentIdentifier = (String)var7.next();
         result.getAuditEntries().add(this.makeEntry("IcisAirComplianceMonitoringData record has a duplicate ComplianceMonitoringIdentifier:  \"" + currentIdentifier + "\" which appears " + dupes.get(currentIdentifier) + " time(s)."));
      }

   }

   private void loadStagingData(List<?> dataList, String payloadName, Class... dataClass) {
      EntityManager em = this.getEntityManager();
      if(!em.getTransaction().isActive()) {
         em.getTransaction().begin();
      }

      CriteriaBuilder builder = em.getCriteriaBuilder();
      CriteriaQuery query = builder.createQuery(IcisAirPayload.class);
      Root root = query.from(IcisAirPayload.class);
      query.where(builder.equal(root.get("operation"), payloadName));
      TypedQuery typedQuery = em.createQuery(query);
      typedQuery.setParameter("operation", payloadName);
      IcisAirPayload payload = (IcisAirPayload)typedQuery.getSingleResult();
      this.loadAndDelete(em, dataClass[dataClass.length - 1]);

      for(int i = 0; i < dataList.size(); ++i) {
         ((SettableIcisAirPayload)dataList.get(i)).setIcisAirPayload(payload);
         em.persist(dataList.get(i));
      }

      em.getTransaction().commit();
      em.close();
   }

   private void loadAndDelete(EntityManager em, Class<?> dataClass) {
      TypedQuery query = em.createQuery("SELECT t FROM " + dataClass.getName() + " t", dataClass);
      List results = query.getResultList();

      for(int i = 0; results != null && i < results.size(); ++i) {
         em.remove(results.get(i));
      }

      em.flush();
   }

   private EntityManager getEntityManager() {
      HashMap properties = new HashMap();
      properties.put("javax.persistence.nonJtaDataSource", this.getDataSources().get("Target Data Provider"));
      properties.put("javax.persistence.transactionType", PersistenceUnitTransactionType.RESOURCE_LOCAL.name());
      properties.put("eclipselink.classloader", IcisAirStagingTablePopulator.class.getClassLoader());
      EntityManagerFactory emf = Persistence.createEntityManagerFactory("icis-air", properties);
      EntityManager em = emf.createEntityManager();
      return em;
   }

   private String getDataDaemonDirectory(NodeTransaction transaction) {
      if(transaction == null) {
         throw new IllegalStateException("NodeTransaction transaction cannot be null.");
      } else if(transaction.getRequest() == null) {
         throw new IllegalStateException("NodeTransaction transaction.getRequest() cannot be null.");
      } else if(transaction.getRequest().getParameters() == null) {
         throw new IllegalStateException("NodeTransaction transaction.getParameters() cannot be null.");
      } else {
         String directory = null;
         List args = transaction.getRequest().getService().getArgs();

         for(int i = 0; args != null && i < args.size(); ++i) {
            if(DATA_DAEMON_DIRECTORY.getName().equalsIgnoreCase(((NamedSystemConfigItem)args.get(i)).getKey())) {
               directory = ((NamedSystemConfigItem)args.get(i)).getValue();
            }
         }

         return StringUtils.isBlank(directory)?null:StringUtils.stripToEmpty(directory);
      }
   }

   public List<DataServiceRequestParameter> getServiceRequestParamSpecs(String serviceName) {
      return null;
   }

   public void afterPropertiesSet() {
      super.afterPropertiesSet();
      if(this.getDataSources() == null) {
         throw new RuntimeException("Data sources not set");
      } else if(!this.getDataSources().containsKey("Target Data Provider")) {
         throw new RuntimeException("Target datasource not set");
      } else {
         this.idGenerator = (IdGenerator)this.getServiceFactory().makeService(IdGenerator.class);
         if(this.idGenerator == null) {
            throw new RuntimeException("Unable to obtain IdGenerator");
         } else {
            this.settingService = (SettingServiceProvider)this.getServiceFactory().makeService(SettingServiceProvider.class);
            if(this.settingService == null) {
               throw new RuntimeException("Unable to obtain SettingServiceProvider");
            }
         }
      }
   }

   static {
      DATA_DAEMON_DIRECTORY = new PluginServiceParameterDescriptor("data-daemon Directory Location", "java.lang.String", Boolean.TRUE, "The root data-daemon directory location where ICIS-AIR files are stored after retrieval.");
      PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR = new PluginServiceImplementorDescriptor();
      PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName(IcisAirStagingTablePopulator.class.getName());
      PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Migrates OEPA data files into staging.");
      PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(IcisAirStagingTablePopulator.class.getCanonicalName());
   }
}
