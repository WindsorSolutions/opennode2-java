package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.LinkageAirDAEnforcementActionIdentifier;
import com.windsor.node.plugin.oepa.domain.LinkageCaseFile;
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
   name = "CaseFileLinkage"
)
@Table(
   name = "ICA_CASE_FILE_LNK"
)
@Access(AccessType.PROPERTY)
public class CaseFileLinkage extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String caseFileIdentifier;
   private LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier;
   private LinkageCaseFile linkageCaseFile;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_CASE_FILE_LNK_ID"
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

   @XmlPath("LinkageAirDAEnforcementAction")
   @OneToOne(
      cascade = {CascadeType.ALL},
      mappedBy = "caseFileLinkage"
   )
   public LinkageAirDAEnforcementActionIdentifier getLinkageAirDAEnforcementActionIdentifier() {
      return this.linkageAirDAEnforcementActionIdentifier;
   }

   public void setLinkageAirDAEnforcementActionIdentifier(LinkageAirDAEnforcementActionIdentifier linkageAirDAEnforcementActionIdentifier) {
      this.linkageAirDAEnforcementActionIdentifier = linkageAirDAEnforcementActionIdentifier;
   }

   @XmlPath("LinkageCaseFile")
   @OneToOne(
      cascade = {CascadeType.ALL},
      mappedBy = "caseFileLinkage"
   )
   public LinkageCaseFile getLinkageCaseFile() {
      return this.linkageCaseFile;
   }

   public void setLinkageCaseFile(LinkageCaseFile linkageCaseFile) {
      this.linkageCaseFile = linkageCaseFile;
   }
}
