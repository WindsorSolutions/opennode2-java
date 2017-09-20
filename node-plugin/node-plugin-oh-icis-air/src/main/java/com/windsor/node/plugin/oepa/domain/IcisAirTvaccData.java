package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.AirPollutantCode;
import com.windsor.node.plugin.oepa.domain.IcisAirTvaccReviewData;
import com.windsor.node.plugin.oepa.domain.ProgramCode;
import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity(
   name = "IcisAirTvaccData"
)
@Table(
   name = "ICA_TVACC"
)
@Access(AccessType.PROPERTY)
public class IcisAirTvaccData extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirTvaccData.class);
   protected String dbid;
   private String airFacilityIdentifier;
   private String complianceMonitoringIdentifier;
   private String complianceMonitoringDate;
   private Date complianceMonitoringDateDb;
   private String complianceMonitoringPlannedEndDate;
   private Date complianceMonitoringPlannedEndDateDb;
   private String leadAgencyCode;
   private List<ProgramCode> programCodeList;
   private List<IcisAirTvaccReviewData> icisAirTvaccReviewDataList;
   private List<AirPollutantCode> airPollutantCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_TVACC_ID"
   )
   public String getDbid() {
      if(StringUtils.isBlank(this.dbid)) {
         UUID uuid = UUIDGenerator.getInstance().generateRandomBasedUUID();
         this.dbid = uuid.toString();
      }

      return this.dbid;
   }

   public void setDbid(String dbid) {
      this.dbid = dbid;
   }

   @XmlPath("AirFacilityIdentifier/text()")
   @Basic
   @Column(
      name = "FAC_IDENT"
   )
   public String getAirFacilityIdentifier() {
      return this.airFacilityIdentifier;
   }

   public void setAirFacilityIdentifier(String airFacilityIdentifier) {
      this.airFacilityIdentifier = airFacilityIdentifier;
   }

   @XmlPath("ComplianceMonitoringIdentifier/text()")
   @Basic
   @Column(
      name = "CMPL_MON_IDENT"
   )
   public String getComplianceMonitoringIdentifier() {
      return this.complianceMonitoringIdentifier;
   }

   public void setComplianceMonitoringIdentifier(String complianceMonitoringIdentifier) {
      this.complianceMonitoringIdentifier = complianceMonitoringIdentifier;
   }

   @XmlPath("ComplianceMonitoringDate/text()")
   @Transient
   public String getComplianceMonitoringDate() {
      return this.complianceMonitoringDate;
   }

   public void setComplianceMonitoringDate(String complianceMonitoringDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.complianceMonitoringDateDb = sdf.parse(complianceMonitoringDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + complianceMonitoringDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.complianceMonitoringDate = complianceMonitoringDate;
   }

   @Column(
      name = "CMPL_MON_DATE"
   )
   public Date getComplianceMonitoringDateDb() {
      return this.complianceMonitoringDateDb;
   }

   public void setComplianceMonitoringDateDb(Date complianceMonitoringDateDb) {
      this.complianceMonitoringDateDb = complianceMonitoringDateDb;
   }

   @XmlPath("LeadAgencyCode/text()")
   @Basic
   @Column(
      name = "LEAD_AGNCY_CODE"
   )
   public String getLeadAgencyCode() {
      return this.leadAgencyCode;
   }

   public void setLeadAgencyCode(String leadAgencyCode) {
      this.leadAgencyCode = leadAgencyCode;
   }

   @XmlPath("ProgramCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirTvaccData",
      orphanRemoval = true
   )
   public List<ProgramCode> getProgramCodeList() {
      return this.programCodeList;
   }

   public void setProgramCodeList(List<ProgramCode> programCodeList) {
      this.programCodeList = programCodeList;
   }

   @XmlPath("TVACCReviewData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirTvaccData"
   )
   public List<IcisAirTvaccReviewData> getIcisAirTvaccReviewDataList() {
      return this.icisAirTvaccReviewDataList;
   }

   public void setIcisAirTvaccReviewDataList(List<IcisAirTvaccReviewData> icisAirTvaccReviewDataList) {
      this.icisAirTvaccReviewDataList = icisAirTvaccReviewDataList;
   }

   @XmlPath("ComplianceMonitoringPlannedEndDate/text()")
   @Transient
   public String getComplianceMonitoringPlannedEndDate() {
      return this.complianceMonitoringPlannedEndDate;
   }

   public void setComplianceMonitoringPlannedEndDate(String complianceMonitoringPlannedEndDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.complianceMonitoringPlannedEndDateDb = sdf.parse(complianceMonitoringPlannedEndDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + complianceMonitoringPlannedEndDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.complianceMonitoringPlannedEndDate = complianceMonitoringPlannedEndDate;
   }

   @Column(
      name = "CMPL_MON_PLANNED_END_DATE"
   )
   public Date getComplianceMonitoringPlannedEndDateDb() {
      return this.complianceMonitoringPlannedEndDateDb;
   }

   public void setComplianceMonitoringPlannedEndDateDb(Date complianceMonitoringPlannedEndDateDb) {
      this.complianceMonitoringPlannedEndDateDb = complianceMonitoringPlannedEndDateDb;
   }

   @XmlPath("AirPollutantCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirTvaccData",
      orphanRemoval = true
   )
   public List<AirPollutantCode> getAirPollutantCodeList() {
      return this.airPollutantCodeList;
   }

   public void setAirPollutantCodeList(List<AirPollutantCode> airPollutantCodeList) {
      this.airPollutantCodeList = airPollutantCodeList;
   }
}
