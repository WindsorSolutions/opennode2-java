package com.windsor.node.plugin.oepa.domain;

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
   name = "IcisAirDaInformalEnforcementAction"
)
@Table(
   name = "ICA_DA_INFRML_ENFRC_ACTN"
)
@Access(AccessType.PROPERTY)
public class IcisAirDaInformalEnforcementAction extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirDaInformalEnforcementAction.class);
   protected String dbid;
   private List airFacilityIdentifierList;
   private String airDaEnforcementActionIdentifier;
   private String achievedDate;
   private Date achievedDateDb;
   private List programsViolatedCode;
   private String leadAgencyCode;
   private String enforcementActionTypeCode;
   private List airPollutantCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_INFRML_ENFRC_ACTN_ID"
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

   @XmlPath("AirDAEnforcementActionIdentifier/text()")
   @Basic
   @Column(
      name = "DA_ENFRC_ACTN_IDENT"
   )
   public String getAirDaEnforcementActionIdentifier() {
      return this.airDaEnforcementActionIdentifier;
   }

   public void setAirDaEnforcementActionIdentifier(String airDaEnforcementActionIdentifier) {
      this.airDaEnforcementActionIdentifier = airDaEnforcementActionIdentifier;
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

   @XmlPath("AchievedDate/text()")
   @Transient
   public String getAchievedDate() {
      return this.achievedDate;
   }

   public void setAchievedDate(String achievedDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.achievedDateDb = sdf.parse(achievedDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + achievedDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.achievedDate = achievedDate;
   }

   @Basic
   @Column(
      name = "ACHIEVED_DATE"
   )
   public Date getAchievedDateDb() {
      return this.achievedDateDb;
   }

   public void setAchievedDateDb(Date achievedDateDb) {
      this.achievedDateDb = achievedDateDb;
   }

   @XmlPath("ProgramsViolatedCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaInformalEnforcementAction",
      orphanRemoval = true
   )
   public List getProgramsViolatedCode() {
      return this.programsViolatedCode;
   }

   public void setProgramsViolatedCode(List programsViolatedCode) {
      this.programsViolatedCode = programsViolatedCode;
   }

   @XmlPath("EnforcementActionTypeCode/text()")
   @Basic
   @Column(
      name = "ENFRC_ACTN_TYPE_CODE"
   )
   public String getEnforcementActionTypeCode() {
      return this.enforcementActionTypeCode;
   }

   public void setEnforcementActionTypeCode(String enforcementActionTypeCode) {
      this.enforcementActionTypeCode = enforcementActionTypeCode;
   }

   @XmlPath("AirFacilityIdentifier")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaInformalEnforcementAction",
      orphanRemoval = true
   )
   public List getAirFacilityIdentifierList() {
      return this.airFacilityIdentifierList;
   }

   public void setAirFacilityIdentifierList(List airFacilityIdentifierList) {
      this.airFacilityIdentifierList = airFacilityIdentifierList;
   }

   @XmlPath("AirPollutantCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaInformalEnforcementAction",
      orphanRemoval = true
   )
   public List getAirPollutantCodeList() {
      return this.airPollutantCodeList;
   }

   public void setAirPollutantCodeList(List airPollutantCodeList) {
      this.airPollutantCodeList = airPollutantCodeList;
   }
}
