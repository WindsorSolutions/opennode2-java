package com.windsor.node.plugin.oepa.domain;

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
   private List icisAirFacilitiesList;
   @XmlPath("Payload/AirPollutantsData/AirPollutants")
   private List icisAirPollutantsList;
   @XmlPath("Payload/AirProgramsData/AirPrograms")
   private List icisAirProgramsList;
   @XmlPath("Payload/AirDAComplianceMonitoringData/AirDAComplianceMonitoring")
   private List icisAirComplianceMonitoringDataList;
   @XmlPath("Payload/AirComplianceMonitoringStrategyData/AirComplianceMonitoringStrategy")
   private List icisAirComplianceMonitoringStrategyList;
   @XmlPath("Payload/AirDACaseFileData/AirDACaseFile")
   private List airDaCaseFileList;
   @XmlPath("Payload/AirDAFormalEnforcementActionData/AirDAFormalEnforcementAction")
   private List airDaFormalEnforcementAction;
   @XmlPath("Payload/AirDAEnforcementActionLinkageData/AirDAEnforcementActionLinkage")
   private List icisAirDaEnforcementActionLinkage;
   @XmlPath("Payload/ComplianceMonitoringLinkageData/ComplianceMonitoringLinkage")
   private List complianceMonitoringLinkageList;
   @XmlPath("Payload/CaseFileLinkageData/CaseFileLinkage")
   private List caseFileLinkageList;
   @XmlPath("Payload/AirTVACCData/AirTVACC")
   private List icisAirTvaccDataList;
   @XmlPath("Payload/AirDAInformalEnforcementActionData/AirDAInformalEnforcementAction")
   private List IcisAirDaInformalEnforcementActionList;

   public List getAirDaCaseFileList() {
      return this.airDaCaseFileList;
   }

   public void setAirDaCaseFileList(List airDaCaseFileList) {
      this.airDaCaseFileList = airDaCaseFileList;
   }

   public List getIcisAirProgramsList() {
      return this.icisAirProgramsList;
   }

   public void setIcisAirProgramsList(List icisAirProgramsList) {
      this.icisAirProgramsList = icisAirProgramsList;
   }

   public String getHeader() {
      return this.header;
   }

   public void setHeader(String header) {
      this.header = header;
   }

   public List getIcisAirFacilitiesList() {
      return this.icisAirFacilitiesList;
   }

   public void setIcisAirFacilitiesList(List icisAirFacilitiesList) {
      this.icisAirFacilitiesList = icisAirFacilitiesList;
   }

   public List getIcisAirPollutantsList() {
      return this.icisAirPollutantsList;
   }

   public void setIcisAirPollutantsList(List icisAirPollutantsList) {
      this.icisAirPollutantsList = icisAirPollutantsList;
   }

   public List getIcisAirComplianceMonitoringStrategyList() {
      return this.icisAirComplianceMonitoringStrategyList;
   }

   public void setIcisAirComplianceMonitoringStrategyList(List icisAirComplianceMonitoringStrategyList) {
      this.icisAirComplianceMonitoringStrategyList = icisAirComplianceMonitoringStrategyList;
   }

   public List getAirDaFormalEnforcementAction() {
      return this.airDaFormalEnforcementAction;
   }

   public void setAirDaFormalEnforcementAction(List airDaFormalEnforcementAction) {
      this.airDaFormalEnforcementAction = airDaFormalEnforcementAction;
   }

   public List getIcisAirDaEnforcementActionLinkage() {
      return this.icisAirDaEnforcementActionLinkage;
   }

   public void setIcisAirDaEnforcementActionLinkage(List icisAirDaEnforcementActionLinkage) {
      this.icisAirDaEnforcementActionLinkage = icisAirDaEnforcementActionLinkage;
   }

   public List getComplianceMonitoringLinkageList() {
      return this.complianceMonitoringLinkageList;
   }

   public void setComplianceMonitoringLinkageList(List complianceMonitoringLinkageList) {
      this.complianceMonitoringLinkageList = complianceMonitoringLinkageList;
   }

   public List getIcisAirComplianceMonitoringDataList() {
      return this.icisAirComplianceMonitoringDataList;
   }

   public void setIcisAirComplianceMonitoringDataList(List icisAirComplianceMonitoringDataList) {
      this.icisAirComplianceMonitoringDataList = icisAirComplianceMonitoringDataList;
   }

   public List getIcisAirTvaccDataList() {
      return this.icisAirTvaccDataList;
   }

   public void setIcisAirTvaccDataList(List icisAirTvaccDataList) {
      this.icisAirTvaccDataList = icisAirTvaccDataList;
   }

   public List getIcisAirDaInformalEnforcementActionList() {
      return this.IcisAirDaInformalEnforcementActionList;
   }

   public void setIcisAirDaInformalEnforcementActionList(List icisAirDaInformalEnforcementActionList) {
      this.IcisAirDaInformalEnforcementActionList = icisAirDaInformalEnforcementActionList;
   }

   public List getCaseFileLinkageList() {
      return this.caseFileLinkageList;
   }

   public void setCaseFileLinkageList(List caseFileLinkageList) {
      this.caseFileLinkageList = caseFileLinkageList;
   }
}
