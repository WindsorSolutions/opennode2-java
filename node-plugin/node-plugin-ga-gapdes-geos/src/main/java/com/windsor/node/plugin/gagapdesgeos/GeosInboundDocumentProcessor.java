package com.windsor.node.plugin.gagapdesgeos;

import com.google.gson.Gson;
import com.windsor.node.common.domain.*;
import com.windsor.node.data.dao.PluginServiceParameterDescriptor;
import com.windsor.node.data.dao.jdbc.JdbcTransactionDao;
import com.windsor.node.plugin.BaseWnosPlugin;
import com.windsor.node.plugin.common.persistence.PluginPersistenceConfig;
import com.windsor.node.plugin.gagapdesgeos.domain.FormData;
import com.windsor.node.plugin.gagapdesgeos.domain.FormList;
import com.windsor.node.plugin.gagapdesgeos.domain.GeosSwSubmission;
import com.windsor.node.plugin.gagapdesgeos.domain.Milestone;
import com.windsor.node.service.helper.CompressionService;
import com.windsor.node.service.helper.zip.ZipCompressionService;
import org.apache.commons.lang3.StringUtils;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.sql.DataSource;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import static java.lang.String.format;

/**
 * Provides a document processor for handling inboud GEOS submissions.
 */
public class GeosInboundDocumentProcessor extends BaseWnosPlugin {

    /**
     * Name of our service.
     */
    public static final String SERVICE_NAME = "GeosInboundDocumentProcessor";

    /**
     * Service descriptor for our plugin.
     */
    private static final PluginServiceImplementorDescriptor PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR =
            new PluginServiceImplementorDescriptor();

    static {
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setName(SERVICE_NAME);
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setDescription("Handles GEOS data submission and extracts into GAPDES staging tables");
        PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR.setClassName(GeosInboundDocumentProcessor.class.getCanonicalName());
    }

    /**
     * Stored procedure to call after the data has been staged.
     */
    private static final String ARG_STORED_PROCEDURE = "Stored Procedure";

    /**
     * Number of seconds before the stored procedure will time out.
     */
    private static final String ARG_STORED_PROCEDURE_TIMEOUT = "Stored Procedure Time Out";

    /**
     * Number of errors encountered during processing.
     */
    private Integer errors = 0;

    /**
     * Compression Service for handling ZIP archives.
     */
    private CompressionService zipCompressionService;

    /**
     * Database transaction data access object.
     */
    private JdbcTransactionDao transactionDao;

    /**
     * Hibernate entity manager.
     */
    private EntityManager targetEntityManager;

    /**
     * Classloader for getting a handle on plugin-specific resources.
     */
    private ClassLoader classLoader;

    /**
     * Creates a new instance.
     */
    public GeosInboundDocumentProcessor() {
        super();

        // only valid for exchange network 2.1
        setPublishForEN11(false);
        setPublishForEN20(false);

        // we only need a data target data source
        getDataSources().put(ARG_DS_TARGET, (DataSource) null);

        // stored procedure to call after loading data
        getConfigurationArguments().put(ARG_STORED_PROCEDURE, "");

        // service types supported by this service
        getSupportedPluginTypes().add(ServiceType.SUBMIT);

        debug("GeosInboundDocumentProcessor instantiated.");
    }

    @Override
    public PluginServiceImplementorDescriptor getPluginServiceImplementorDescription() {
        return PLUGIN_SERVICE_IMPLEMENTOR_DESCRIPTOR;
    }

    @Override
    public List<PluginServiceParameterDescriptor> getParameters() {
        List<PluginServiceParameterDescriptor> parameters = new ArrayList<>();
        return parameters;
    }

    @Override
    public ProcessContentResult process(NodeTransaction transaction) {

        // counter for tracking errors during processing
        errors = 0;

        logger.info("Processing transaction...");

        // setup our transaction
        transaction.setOperation("GEOS Inbound Document");
        transaction.setStatus(new TransactionStatus(CommonTransactionStatusCode.Pending));
        getTransactionDao().save(transaction);

        // setup our result
        final ProcessContentResult result = new ProcessContentResult();
        result.setSuccess(false);
        result.setStatus(CommonTransactionStatusCode.Processed);

        // start our database transaction
        getTargetEntityManager().getTransaction().begin();

        // process all incoming documents
        for(Document document : transaction.getDocuments()) {

            result.getAuditEntries().add(
                    new ActivityEntry("Recieved document: " + document.getDocumentId() + ", " +
                            document.getDocumentName()));
            logger.info("  Recieved document: " + document.getDocumentId() + ", " + document.getDocumentName());
            logger.info("    with status " + document.getDocumentStatus() + ", " + document.getDocumentStatusDetail());

            try {

                // unpack document to a temporary directory
                Path tempPath = unpackDocumentArchive(document);
                logger.info("    Will unpack document to " + tempPath.toAbsolutePath());

                // iterate through the documents in the unpacked ZIP archive
                Files.walkFileTree(tempPath, new SimpleFileVisitor<Path>() {

                    final Gson gson = new Gson();

                    @Override
                    public FileVisitResult visitFile(Path path, BasicFileAttributes attrs) throws IOException {
                        logger.info("    Inspecting " + path.toAbsolutePath());
                        if(path.toFile().isFile()) {

                            // process the file
                            logger.info("    Processing the file " + path.getFileName());
                            result.getAuditEntries().add(
                                    new ActivityEntry("Processing the file " + path.getFileName()));

                            // read data
                            String submissionData = new String(Files.readAllBytes(path));

                            // parse the JSON
                            GeosSwSubmission submission = null;
                            try {
                                submission = gson.fromJson(submissionData, GeosSwSubmission.class);
                                logger.debug("      Processing submission: " + submission);

                            } catch (Exception exception) {
                                errors++;
                                logger.warn("      Could not parse JSON data for file \"" + path.getFileName() + "\": " +
                                        exception.getMessage(), exception);
                                result.getAuditEntries().add(
                                        new ActivityEntry("Could not parse the JSON data: " +
                                                exception.getMessage()));
                            }

                            // save the submission
                            if(submission != null && errors == 0) {

                                try {

                                    if(submission.getMilestones() != null) {
                                        for (Milestone milestone : submission.getMilestones()) {
                                            milestone.setGeosSwSubmission(submission);
                                            logger.debug("  Milestone linked to submission " + milestone.getGeosSwSubmission().getSubmissionId());
                                        }
                                    }

                                    if(submission.getFormData() != null) {
                                        for (FormData formData : submission.getFormData()) {
                                            formData.setGeosSwSubmission(submission);
                                            logger.debug("  FormData linked to submission " + formData.getGeosSwSubmission().getSubmissionId());
                                        }
                                    }

                                    if(submission.getFormLists() != null) {
                                        for (FormList formList : submission.getFormLists()) {
                                            formList.setGeosSwSubmission(submission);

                                            logger.debug("  FormList linked to submission " + formList.getGeosSwSubmission().getSubmissionId());
                                        }
                                    }

                                    persistData(submission);
                                    logger.info("      Submission saved to the database");
                                } catch (Exception exception) {
                                    errors++;
                                    logger.warn("      Could not save the submission to the database: " +
                                            exception.getMessage(), exception);
                                    result.getAuditEntries().add(
                                            new ActivityEntry("Could not save the submission to the database: " +
                                                    exception.getMessage()));
                                }
                            } else {
                                result.getAuditEntries().add(
                                        new ActivityEntry("Did not save the submission to the database"));
                            }
                        }

                        return FileVisitResult.CONTINUE;
                    }
                });

                if(errors == 0) {

                    String storedProcedure = getConfigValueAsStringNoFail(ARG_STORED_PROCEDURE);
                    if(StringUtils.isNotBlank(storedProcedure)) {
                        result.getAuditEntries().add(new ActivityEntry("Calling stored procedure \""
                                + storedProcedure + "\" to process the data"));
                        try {
                            calledStoredProcedure(storedProcedure);
                            result.getAuditEntries().add(new ActivityEntry("Stored procedure completed"));
                        } catch(Exception exception) {
                            errors++;
                            result.getAuditEntries().add(
                                    new ActivityEntry("Couldn't call the stored procedure " + storedProcedure + ": " +
                                            exception.getMessage()));
                            logger.warn("Couldn't call the stored procedure " + storedProcedure + ": " +
                                    exception.getMessage(), exception);
                        }
                    }
                }
            } catch (IOException exception) {
                errors++;
                logger.warn("Could not unpack ZIP archive " + document.getDocumentName() + ": " +
                                exception.getMessage(), exception);
            }
        }

        if(errors > 0) {
            result.setSuccess(false);
            result.setStatus(CommonTransactionStatusCode.Failed);
            transaction.setStatus(new TransactionStatus(CommonTransactionStatusCode.Failed));

            // rollback the database transaction
            getTargetEntityManager().getTransaction().rollback();
            logger.info("Database transaction rolled back");
            result.getAuditEntries().add(new ActivityEntry("Database transaction rolled back"));
        } else {

            result.setSuccess(true);
            result.setStatus(CommonTransactionStatusCode.Completed);
            transaction.setStatus(new TransactionStatus(CommonTransactionStatusCode.Completed));

            // commit the database transaction
            getTargetEntityManager().getTransaction().commit();
            logger.info("Database transaction committed");
            result.getAuditEntries().add(new ActivityEntry("Database transaction committed"));
        }

        logger.info("Processing transaction complete");
        result.getAuditEntries().add(new ActivityEntry("Processing transaction complete"));

        // save our transaction
        getTransactionDao().save(transaction);

        return result;
    }

    /**
     * Persist a data object to the database.
     * @param submission
     */
    public void persistData(GeosSwSubmission submission) {
        getTargetEntityManager().persist(submission);
    }

    /**
     * Unzips the provided ZIP archive and returns a path to the folder containing the ZIP archive contents.
     * @param document Document to unzip
     * @return Path to the unpacked ZIP archive
     * @throws IOException On any issue reading or writing the ZIP archive or its contents
     */
    private Path unpackDocumentArchive(Document document) throws IOException {

        Path pathTempDirectory = Files.createTempDirectory("gapdes-geos-");
        zipCompressionService.unzip(document.getContent(), pathTempDirectory.toAbsolutePath().toString());
        return pathTempDirectory;
    }

    /**
     * Calls a stored procedure to operate on the data in the staging tables
     * adter they have been loaded.
     *
     * @param storedProcedure The name of the stored procedure
     * @throws Exception On any issue executing the stored procedure
     */
    public void calledStoredProcedure(String storedProcedure) throws Exception {

        Query query = getTargetEntityManager()
                .createNativeQuery(format("call %s()", storedProcedure));
        logger.info("Calling stored procedure: " + query.toString());
        query.executeUpdate();
    }

    /**
     * Returns the configuration value for the given key or null if it has not been specified.
     * @param key The configuration key
     * @return The assigned value or null if it has not been set
     */
    private String getConfigValueAsStringNoFail(String key) {

        if(StringUtils.isBlank(key)) {
            return null;
        }

        if(!getConfigurationArguments().containsKey(key)) {
            return null;
        }

        String value = getConfigurationArguments().get(key);
        if(StringUtils.isBlank(value)) {
            return null;
        }

        return value;
    }

    @Override
    public List<DataServiceRequestParameter> getServiceRequestParamSpecs(String serviceName) {
        return null;
    }

    @Override
    public void afterPropertiesSet() {
        super.afterPropertiesSet();

        transactionDao = (JdbcTransactionDao) getServiceFactory().makeService(
                JdbcTransactionDao.class);

        if (transactionDao == null) {
            throw new RuntimeException("Unable to obtain transactionDao");
        }

        zipCompressionService = (CompressionService) getServiceFactory().makeService(ZipCompressionService.class);

        if(getDataSources().get(ARG_DS_TARGET) == null) {
            throw new RuntimeException("No data source was provided for this operation!");
        }

        Connection connection = null;
        try {
            connection = getDataSources().get(ARG_DS_TARGET).getConnection();
        } catch (Exception exception) {
            error("Could not connect to the provided data source: " + exception.getMessage(), exception);
            throw new RuntimeException("Could not connect to the provided data source: " + exception.getMessage(), exception);
        } finally {
            try {
                connection.close();
            } catch(Exception exception) {
                // fail silently
            }
        }

        info("Using data source " + getDataSources().get(ARG_DS_TARGET));
        GeosGapdesHibernatePersistenceProvider provider = new GeosGapdesHibernatePersistenceProvider();
        EntityManagerFactory emf = provider.createEntityManagerFactory(
                getDataSources().get(ARG_DS_TARGET),
                new PluginPersistenceConfig()
                        .classLoader(GeosSwSubmission.class.getClassLoader())
                        .debugSql(Boolean.TRUE)
                        .rootEntityPackage("com.windsor.node.plugin.gagapdesgeos.domain")
                        .setBatchFetchSize(1000));
        info("Entity manager factory created successfully");

        EntityManager entityManager = null;
        try {
            entityManager = emf.createEntityManager();
        } catch(Exception exception) {
            error("Couldn't create entity manager: " + exception.getMessage(), exception);
            throw new RuntimeException("The data source is not configured correctly! I received the following error " +
                    "when I tried to setup the data source: " + exception.getMessage(), exception);
        }

        info("Setting entity manager instance");
        setTargetEntityManager(entityManager);
    }

    public static String getArgStoredProcedure() {
        return ARG_STORED_PROCEDURE;
    }

    public static String getArgStoredProcedureTimeout() {
        return ARG_STORED_PROCEDURE_TIMEOUT;
    }

    public JdbcTransactionDao getTransactionDao() {
        return transactionDao;
    }

    public void setTransactionDao(JdbcTransactionDao transactionDao) {
        this.transactionDao = transactionDao;
    }

    public EntityManager getTargetEntityManager() {
        return targetEntityManager;
    }

    public void setTargetEntityManager(EntityManager targetEntityManager) {
        this.targetEntityManager = targetEntityManager;
    }

    public ClassLoader getClassLoader() {

        if(classLoader == null) {
            classLoader = this.getClass().getClassLoader();
        }

        return classLoader;
    }
}
