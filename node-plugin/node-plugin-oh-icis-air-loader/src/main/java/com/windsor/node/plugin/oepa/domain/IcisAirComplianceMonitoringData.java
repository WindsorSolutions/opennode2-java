package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.HasComplianceMonitoringIdentifier;
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
   name = "IcisAirComplianceMonitoringData"
)
@Table(
   name = "ICA_DA_CMPL_MON"
)
@Access(AccessType.PROPERTY)
public class IcisAirComplianceMonitoringData extends SettableIcisAirPayload implements Serializable, HasComplianceMonitoringIdentifier {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirComplianceMonitoringData.class);
   protected String dbid;
   private String complianceMonitoringIdentifier;
   private String complianceMonitoringActivityTypeCode;
   private String complianceMonitoringDate;
   private Date complianceMonitoringDateDb;
   private String leadAgencyCode;
   private List complianceInspectionTypeCodeList;
   private List airFacilityIdentifierList;
   private List programCodeList;
   private List airStackTestDataList;
   private List airPollutantCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_CMPL_MON_ID"
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

   @XmlPath("AirFacilityIdentifier")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirComplianceMonitoringData",
      orphanRemoval = true
   )
   public List getAirFacilityIdentifierList() {
      return this.airFacilityIdentifierList;
   }

   public void setAirFacilityIdentifierList(List airFacilityIdentifierList) {
      this.airFacilityIdentifierList = airFacilityIdentifierList;
   }

   @XmlPath("ComplianceInspectionTypeCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirComplianceMonitoringData",
      orphanRemoval = true
   )
   public List getComplianceInspectionTypeCodeList() {
      return this.complianceInspectionTypeCodeList;
   }

   public void setComplianceInspectionTypeCodeList(List complianceInspectionTypeCodeList) {
      this.complianceInspectionTypeCodeList = complianceInspectionTypeCodeList;
   }

   @XmlPath("ProgramCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirComplianceMonitoringData",
      orphanRemoval = true
   )
   public List getProgramCodeList() {
      return this.programCodeList;
   }

   public void setProgramCodeList(List programCodeList) {
      this.programCodeList = programCodeList;
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

   @XmlPath("ComplianceMonitoringActivityTypeCode/text()")
   @Basic
   @Column(
      name = "CMPL_MON_ACTY_TYPE_CODE"
   )
   public String getComplianceMonitoringActivityTypeCode() {
      return this.complianceMonitoringActivityTypeCode;
   }

   public void setComplianceMonitoringActivityTypeCode(String complianceMonitoringActivityTypeCode) {
      this.complianceMonitoringActivityTypeCode = complianceMonitoringActivityTypeCode;
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

   @Basic
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

   @XmlPath("AirStackTestData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirComplianceMonitoringData",
      orphanRemoval = true
   )
   public List getAirStackTestDataList() {
      return this.airStackTestDataList;
   }

   public void setAirStackTestDataList(List airStackTestDataList) {
      this.airStackTestDataList = airStackTestDataList;
   }

   @XmlPath("AirPollutantCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirComplianceMonitoringData",
      orphanRemoval = true
   )
   public List getAirPollutantCodeList() {
      return this.airPollutantCodeList;
   }

   public void setAirPollutantCodeList(List airPollutantCodeList) {
      this.airPollutantCodeList = airPollutantCodeList;
   }
}
