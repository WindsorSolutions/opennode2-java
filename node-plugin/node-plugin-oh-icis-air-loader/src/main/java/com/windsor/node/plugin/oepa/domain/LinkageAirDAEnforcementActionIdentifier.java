package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.CaseFileLinkage;
import com.windsor.node.plugin.oepa.domain.ComplianceMonitoringLinkage;
import com.windsor.node.plugin.oepa.domain.IcisAirDaEnforcementActionLinkage;
import java.io.Serializable;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlInverseReference;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "LinkageAirDAEnforcementActionIdentifier"
)
@Table(
   name = "ICA_LNK_DA_ENFRC_ACTN"
)
@Access(AccessType.PROPERTY)
public class LinkageAirDAEnforcementActionIdentifier implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airDaEnforcementActionIdentifier;
   private IcisAirDaEnforcementActionLinkage icisAirDaEnforcementActionLinkage;
   private ComplianceMonitoringLinkage complianceMonitoringLinkage;
   private CaseFileLinkage caseFileLinkage;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_LNK_DA_ENFRC_ACTN_ID"
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

   @XmlInverseReference(
      mappedBy = "linkageAirDAEnforcementActionIdentifier"
   )
   @OneToOne
   @JoinColumn(
      name = "ICA_DA_ENFRC_ACTN_LNK_ID",
      nullable = true
   )
   public IcisAirDaEnforcementActionLinkage getIcisAirDaEnforcementActionLinkage() {
      return this.icisAirDaEnforcementActionLinkage;
   }

   public void setIcisAirDaEnforcementActionLinkage(IcisAirDaEnforcementActionLinkage icisAirDaEnforcementActionLinkage) {
      this.icisAirDaEnforcementActionLinkage = icisAirDaEnforcementActionLinkage;
   }

   @XmlInverseReference(
      mappedBy = "linkageAirDAEnforcementActionIdentifier"
   )
   @OneToOne
   @JoinColumn(
      name = "ICA_CMPL_MON_LNK_ID",
      nullable = true
   )
   public ComplianceMonitoringLinkage getComplianceMonitoringLinkage() {
      return this.complianceMonitoringLinkage;
   }

   public void setComplianceMonitoringLinkage(ComplianceMonitoringLinkage complianceMonitoringLinkage) {
      this.complianceMonitoringLinkage = complianceMonitoringLinkage;
   }

   @XmlInverseReference(
      mappedBy = "linkageAirDAEnforcementActionIdentifier"
   )
   @OneToOne
   @JoinColumn(
      name = "ICA_CASE_FILE_LNK_ID",
      nullable = true
   )
   public CaseFileLinkage getCaseFileLinkage() {
      return this.caseFileLinkage;
   }

   public void setCaseFileLinkage(CaseFileLinkage caseFileLinkage) {
      this.caseFileLinkage = caseFileLinkage;
   }
}
