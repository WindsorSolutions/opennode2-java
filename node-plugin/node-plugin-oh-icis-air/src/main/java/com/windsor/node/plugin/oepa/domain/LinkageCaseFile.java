package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.CaseFileLinkage;
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
   name = "LinkageCaseFile"
)
@Table(
   name = "ICA_LNK_CASE_FILE"
)
@Access(AccessType.PROPERTY)
public class LinkageCaseFile implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String caseFileIdentifier;
   private CaseFileLinkage caseFileLinkage;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_LNK_CASE_FILE_ID"
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

   @XmlInverseReference(
      mappedBy = "caseFileLinkage"
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
