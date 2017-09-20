package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.AirDaFinalOrder;
import com.windsor.node.plugin.oepa.domain.AirFacilityIdentifier;
import com.windsor.node.plugin.oepa.domain.AirPollutantCode;
import com.windsor.node.plugin.oepa.domain.EnforcementActionTypeCode;
import com.windsor.node.plugin.oepa.domain.ProgramsViolatedCode;
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

@Entity(
   name = "IcisAirDaFormalEnforcementAction"
)
@Table(
   name = "ICA_DA_FRML_ENFRC_ACTN"
)
@Access(AccessType.PROPERTY)
public class IcisAirDaFormalEnforcementAction extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private List<AirFacilityIdentifier> airFacilityIdentifierList;
   private String airDaEnforcementActionIdentifier;
   private String forum;
   private List<ProgramsViolatedCode> programsViolatedCode;
   private String leadAgencyCode;
   private List<EnforcementActionTypeCode> enforcementActionTypeCodeList;
   private List<AirDaFinalOrder> airDaFinalOrderList;
   private List<AirPollutantCode> airPollutantCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_FRML_ENFRC_ACTN_ID"
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

   @XmlPath("Forum/text()")
   @Basic
   @Column(
      name = "FORUM"
   )
   public String getForum() {
      return this.forum;
   }

   public void setForum(String forum) {
      this.forum = forum;
   }

   @XmlPath("ProgramsViolatedCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaFormalEnforcementAction",
      orphanRemoval = true
   )
   public List<ProgramsViolatedCode> getProgramsViolatedCode() {
      return this.programsViolatedCode;
   }

   public void setProgramsViolatedCode(List<ProgramsViolatedCode> programsViolatedCode) {
      this.programsViolatedCode = programsViolatedCode;
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

   @XmlPath("EnforcementActionTypeCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaFormalEnforcementAction",
      orphanRemoval = true
   )
   public List<EnforcementActionTypeCode> getEnforcementActionTypeCodeList() {
      return this.enforcementActionTypeCodeList;
   }

   public void setEnforcementActionTypeCodeList(List<EnforcementActionTypeCode> enforcementActionTypeCodeList) {
      this.enforcementActionTypeCodeList = enforcementActionTypeCodeList;
   }

   @XmlPath("AirFacilityIdentifier")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaFormalEnforcementAction",
      orphanRemoval = true
   )
   public List<AirFacilityIdentifier> getAirFacilityIdentifierList() {
      return this.airFacilityIdentifierList;
   }

   public void setAirFacilityIdentifierList(List<AirFacilityIdentifier> airFacilityIdentifierList) {
      this.airFacilityIdentifierList = airFacilityIdentifierList;
   }

   @XmlPath("AirDAFinalOrder")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaFormalEnforcementAction",
      orphanRemoval = true
   )
   public List<AirDaFinalOrder> getAirDaFinalOrderList() {
      return this.airDaFinalOrderList;
   }

   public void setAirDaFinalOrderList(List<AirDaFinalOrder> airDaFinalOrderList) {
      this.airDaFinalOrderList = airDaFinalOrderList;
   }

   @XmlPath("AirPollutantCode")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaFormalEnforcementAction",
      orphanRemoval = true
   )
   public List<AirPollutantCode> getAirPollutantCodeList() {
      return this.airPollutantCodeList;
   }

   public void setAirPollutantCodeList(List<AirPollutantCode> airPollutantCodeList) {
      this.airPollutantCodeList = airPollutantCodeList;
   }
}
