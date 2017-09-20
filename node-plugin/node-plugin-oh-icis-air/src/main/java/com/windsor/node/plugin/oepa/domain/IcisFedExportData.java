package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.CaseFileLinkage;
import com.windsor.node.plugin.oepa.domain.ComplianceMonitoringLinkage;
import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringStrategy;
import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
import com.windsor.node.plugin.oepa.domain.IcisAirDaEnforcementActionLinkage;
import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirDaInformalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirFacility;
import com.windsor.node.plugin.oepa.domain.IcisAirPollutants;
import com.windsor.node.plugin.oepa.domain.IcisAirPrograms;
import com.windsor.node.plugin.oepa.domain.IcisAirTvaccData;
import java.io.Serializable;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import org.eclipse.persistence.oxm.annotations.XmlPath;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
public class IcisFedExportData implements Serializable {
   private static final long serialVersionUID = 210L;
   @XmlPath("Header/Id/text()")
   private String header;
   @XmlPath("Payload/AirFacilityData/AirFacility")
   private List<IcisAirFacility> icisAirFacilitiesList;
   @XmlPath("Payload/AirPollutantsData/AirPollutants")
   private List<IcisAirPollutants> icisAirPollutantsList;
   @XmlPath("Payload/AirProgramsData/AirPrograms")
   private List<IcisAirPrograms> icisAirProgramsList;
   @XmlPath("Payload/AirDAComplianceMonitoringData/AirDAComplianceMonitoring")
   private List<IcisAirComplianceMonitoringData> icisAirComplianceMonitoringDataList;
   @XmlPath("Payload/AirComplianceMonitoringStrategyData/AirComplianceMonitoringStrategy")
   private List<IcisAirComplianceMonitoringStrategy> icisAirComplianceMonitoringStrategyList;
   @XmlPath("Payload/AirDACaseFileData/AirDACaseFile")
   private List<IcisAirDaCaseFile> airDaCaseFileList;
   @XmlPath("Payload/AirDAFormalEnforcementActionData/AirDAFormalEnforcementAction")
   private List<IcisAirDaFormalEnforcementAction> airDaFormalEnforcementAction;
   @XmlPath("Payload/AirDAEnforcementActionLinkageData/AirDAEnforcementActionLinkage")
   private List<IcisAirDaEnforcementActionLinkage> icisAirDaEnforcementActionLinkage;
   @XmlPath("Payload/ComplianceMonitoringLinkageData/ComplianceMonitoringLinkage")
   private List<ComplianceMonitoringLinkage> complianceMonitoringLinkageList;
   @XmlPath("Payload/CaseFileLinkageData/CaseFileLinkage")
   private List<CaseFileLinkage> caseFileLinkageList;
   @XmlPath("Payload/AirTVACCData/AirTVACC")
   private List<IcisAirTvaccData> icisAirTvaccDataList;
   @XmlPath("Payload/AirDAInformalEnforcementActionData/AirDAInformalEnforcementAction")
   private List<IcisAirDaInformalEnforcementAction> IcisAirDaInformalEnforcementActionList;

   public List<IcisAirDaCaseFile> getAirDaCaseFileList() {
      return this.airDaCaseFileList;
   }

   public void setAirDaCaseFileList(List<IcisAirDaCaseFile> airDaCaseFileList) {
      this.airDaCaseFileList = airDaCaseFileList;
   }

   public List<IcisAirPrograms> getIcisAirProgramsList() {
      return this.icisAirProgramsList;
   }

   public void setIcisAirProgramsList(List<IcisAirPrograms> icisAirProgramsList) {
      this.icisAirProgramsList = icisAirProgramsList;
   }

   public String getHeader() {
      return this.header;
   }

   public void setHeader(String header) {
      this.header = header;
   }

   public List<IcisAirFacility> getIcisAirFacilitiesList() {
      return this.icisAirFacilitiesList;
   }

   public void setIcisAirFacilitiesList(List<IcisAirFacility> icisAirFacilitiesList) {
      this.icisAirFacilitiesList = icisAirFacilitiesList;
   }

   public List<IcisAirPollutants> getIcisAirPollutantsList() {
      return this.icisAirPollutantsList;
   }

   public void setIcisAirPollutantsList(List<IcisAirPollutants> icisAirPollutantsList) {
      this.icisAirPollutantsList = icisAirPollutantsList;
   }

   public List<IcisAirComplianceMonitoringStrategy> getIcisAirComplianceMonitoringStrategyList() {
      return this.icisAirComplianceMonitoringStrategyList;
   }

   public void setIcisAirComplianceMonitoringStrategyList(List<IcisAirComplianceMonitoringStrategy> icisAirComplianceMonitoringStrategyList) {
      this.icisAirComplianceMonitoringStrategyList = icisAirComplianceMonitoringStrategyList;
   }

   public List<IcisAirDaFormalEnforcementAction> getAirDaFormalEnforcementAction() {
      return this.airDaFormalEnforcementAction;
   }

   public void setAirDaFormalEnforcementAction(List<IcisAirDaFormalEnforcementAction> airDaFormalEnforcementAction) {
      this.airDaFormalEnforcementAction = airDaFormalEnforcementAction;
   }

   public List<IcisAirDaEnforcementActionLinkage> getIcisAirDaEnforcementActionLinkage() {
      return this.icisAirDaEnforcementActionLinkage;
   }

   public void setIcisAirDaEnforcementActionLinkage(List<IcisAirDaEnforcementActionLinkage> icisAirDaEnforcementActionLinkage) {
      this.icisAirDaEnforcementActionLinkage = icisAirDaEnforcementActionLinkage;
   }

   public List<ComplianceMonitoringLinkage> getComplianceMonitoringLinkageList() {
      return this.complianceMonitoringLinkageList;
   }

   public void setComplianceMonitoringLinkageList(List<ComplianceMonitoringLinkage> complianceMonitoringLinkageList) {
      this.complianceMonitoringLinkageList = complianceMonitoringLinkageList;
   }

   public List<IcisAirComplianceMonitoringData> getIcisAirComplianceMonitoringDataList() {
      return this.icisAirComplianceMonitoringDataList;
   }

   public void setIcisAirComplianceMonitoringDataList(List<IcisAirComplianceMonitoringData> icisAirComplianceMonitoringDataList) {
      this.icisAirComplianceMonitoringDataList = icisAirComplianceMonitoringDataList;
   }

   public List<IcisAirTvaccData> getIcisAirTvaccDataList() {
      return this.icisAirTvaccDataList;
   }

   public void setIcisAirTvaccDataList(List<IcisAirTvaccData> icisAirTvaccDataList) {
      this.icisAirTvaccDataList = icisAirTvaccDataList;
   }

   public List<IcisAirDaInformalEnforcementAction> getIcisAirDaInformalEnforcementActionList() {
      return this.IcisAirDaInformalEnforcementActionList;
   }

   public void setIcisAirDaInformalEnforcementActionList(List<IcisAirDaInformalEnforcementAction> icisAirDaInformalEnforcementActionList) {
      this.IcisAirDaInformalEnforcementActionList = icisAirDaInformalEnforcementActionList;
   }

   public List<CaseFileLinkage> getCaseFileLinkageList() {
      return this.caseFileLinkageList;
   }

   public void setCaseFileLinkageList(List<CaseFileLinkage> caseFileLinkageList) {
      this.caseFileLinkageList = caseFileLinkageList;
   }
}
