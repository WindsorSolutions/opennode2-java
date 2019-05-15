package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import java.io.Serializable;
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
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity(
   name = "IcisAirDaCaseFile"
)
@Table(
   name = "ICA_DA_CASE_FILE"
)
@Access(AccessType.PROPERTY)
public class IcisAirDaCaseFile extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirDaCaseFile.class);
   protected String dbid;
   private String airFacilityIdentifier;
   private String caseFileIdentifier;
   private String leadAgencyCode;
   private List caseFileCommentTextList;
   private List programCodeList;
   private List otherPathwayActivityDataList;
   private List airViolationDataList;
   private List airPollutantCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_CASE_FILE_ID"
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

   @XmlPath("CaseFileIdentifier/text()")
   @Basic
   @Column(
      name = "CASE_FILE_IDENT"
   )
   public String getCaseFileIdentifier() {
      return this.caseFileIdentifier;
   }

   public void setCaseFileIdentifier(String caseFileIdentifier) {
      this.caseFileIdentifier = caseFileIdentifier;
   }

   @XmlPath("ProgramCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaCaseFile",
      orphanRemoval = true
   )
   public List getProgramCodeList() {
      return this.programCodeList;
   }

   public void setProgramCodeList(List programCodeList) {
      this.programCodeList = programCodeList;
   }

   @XmlPath("OtherPathwayActivityData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaCaseFile",
      orphanRemoval = true
   )
   public List getOtherPathwayActivityDataList() {
      return this.otherPathwayActivityDataList;
   }

   public void setOtherPathwayActivityDataList(List otherPathwayActivityDataList) {
      this.otherPathwayActivityDataList = otherPathwayActivityDataList;
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

   @XmlPath("CaseFileCommentText")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaCaseFile",
      orphanRemoval = true
   )
   public List getCaseFileCommentTextList() {
      return this.caseFileCommentTextList;
   }

   public void setCaseFileCommentTextList(List caseFileCommentTextList) {
      this.caseFileCommentTextList = caseFileCommentTextList;
   }

   @XmlPath("AirViolationData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaCaseFile",
      orphanRemoval = true
   )
   public List getAirViolationDataList() {
      return this.airViolationDataList;
   }

   public void setAirViolationDataList(List airViolationDataList) {
      this.airViolationDataList = airViolationDataList;
   }

   @XmlPath("AirPollutantCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaCaseFile",
      orphanRemoval = true
   )
   public List getAirPollutantCodeList() {
      return this.airPollutantCodeList;
   }

   public void setAirPollutantCodeList(List airPollutantCodeList) {
      this.airPollutantCodeList = airPollutantCodeList;
   }
}
