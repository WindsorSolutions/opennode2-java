package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
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
   name = "IcisAirComplianceMonitoringStrategy"
)
@Table(
   name = "ICA_CMPL_MON_STRGY"
)
@Access(AccessType.PROPERTY)
public class IcisAirComplianceMonitoringStrategy extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirComplianceMonitoringStrategy.class);
   protected String dbid;
   private String airFacilityIdentifier;
   private String airCmsSourceCategoryCode;
   private String airCmsMinimumFrequency;
   private String airCmsPlanIndicator;
   private String airRemovedPlanDate;
   private Date airRemovedPlanDateDb;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_CMPL_MON_STRGY_ID"
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

   @XmlPath("AirCMSSourceCategoryCode/text()")
   @Basic
   @Column(
      name = "CMS_SRC_CATG_CODE"
   )
   public String getAirCmsSourceCategoryCode() {
      return this.airCmsSourceCategoryCode;
   }

   public void setAirCmsSourceCategoryCode(String airCmsSourceCategoryCode) {
      this.airCmsSourceCategoryCode = airCmsSourceCategoryCode;
   }

   @XmlPath("AirCMSMinimumFrequency/text()")
   @Basic
   @Column(
      name = "CMS_MIN_FREQ"
   )
   public String getAirCmsMinimumFrequency() {
      return this.airCmsMinimumFrequency;
   }

   public void setAirCmsMinimumFrequency(String airCmsMinimumFrequency) {
      this.airCmsMinimumFrequency = airCmsMinimumFrequency;
   }

   @XmlPath("AirActiveCMSPlanIndicator/text()")
   @Basic
   @Column(
      name = "ACTIVE_CMS_PLAN_IND"
   )
   public String getAirCmsPlanIndicator() {
      return this.airCmsPlanIndicator;
   }

   public void setAirCmsPlanIndicator(String airCmsPlanIndicator) {
      this.airCmsPlanIndicator = airCmsPlanIndicator;
   }

   @XmlPath("AirRemovedPlanDate/text()")
   @Transient
   public String getAirRemovedPlanDate() {
      return this.airRemovedPlanDate;
   }

   public void setAirRemovedPlanDate(String airRemovedPlanDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.airRemovedPlanDateDb = sdf.parse(airRemovedPlanDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + airRemovedPlanDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.airRemovedPlanDate = airRemovedPlanDate;
   }

   @Column(
      name = "RMVD_PLAN_DATE"
   )
   public Date getAirRemovedPlanDateDb() {
      return this.airRemovedPlanDateDb;
   }

   public void setAirRemovedPlanDateDb(Date airRemovedPlanDateDb) {
      this.airRemovedPlanDateDb = airRemovedPlanDateDb;
   }
}
