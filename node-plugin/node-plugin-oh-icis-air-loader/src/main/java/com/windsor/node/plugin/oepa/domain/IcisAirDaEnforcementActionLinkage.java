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
   name = "IcisAirDaEnforcementActionLinkage"
)
@Table(
   name = "ICA_DA_ENFRC_ACTN_LNK"
)
@Access(AccessType.PROPERTY)
public class IcisAirDaEnforcementActionLinkage extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airDaEnforcementActionIdentifier;
   private LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_ENFRC_ACTN_LNK_ID"
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

   @XmlPath("LinkageAirDAEnforcementAction")
   @OneToOne(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirDaEnforcementActionLinkage"
   )
   public LinkageAirDAEnforcementActionIdentifier getLinkageAirDAEnforcementActionIdentifier() {
      return this.linkageAirDAEnforcementActionIdentifier;
   }

   public void setLinkageAirDAEnforcementActionIdentifier(LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier) {
      this.linkageAirDAEnforcementActionIdentifier = linkageAirDAEnforcementActionIdentifier;
   }
}
