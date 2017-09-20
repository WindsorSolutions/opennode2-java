package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.LinkageAirDAEnforcementActionIdentifier;
import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import java.io.Serializable;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "ComplianceMonitoringLinkage"
)
@Table(
   name = "ICA_CMPL_MON_LNK"
)
@Access(AccessType.PROPERTY)
public class ComplianceMonitoringLinkage extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String complianceMonitoringIdentifier;
   private LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_CMPL_MON_LNK_ID"
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

   @XmlPath("LinkageAirDAEnforcementAction")
   @OneToOne(
      cascade = {CascadeType.ALL},
      mappedBy = "complianceMonitoringLinkage"
   )
   public LinkageAirDAEnforcementActionIdentifier getLinkageAirDAEnforcementActionIdentifier() {
      return this.linkageAirDAEnforcementActionIdentifier;
   }

   public void setLinkageAirDAEnforcementActionIdentifier(LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier) {
      this.linkageAirDAEnforcementActionIdentifier = linkageAirDAEnforcementActionIdentifier;
   }
}
