package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
import java.io.Serializable;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlInverseReference;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "CaseFileCommentText"
)
@Table(
   name = "ICA_CASE_FILE_CMNT_TXT"
)
@Access(AccessType.PROPERTY)
public class CaseFileCommentText implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String caseFileCommentText;
   private IcisAirDaCaseFile icisAirDaCaseFile;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_CASE_FILE_CMNT_TXT_ID"
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

   @XmlPath("text()")
   @Basic
   @Column(
      name = "CASE_FILE_CMNT_TXT"
   )
   public String getCaseFileCommentText() {
      return this.caseFileCommentText;
   }

   public void setCaseFileCommentText(String caseFileCommentText) {
      this.caseFileCommentText = caseFileCommentText;
   }

   @XmlInverseReference(
      mappedBy = "caseFileCommentTextList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_CASE_FILE_ID",
      nullable = true
   )
   public IcisAirDaCaseFile getIcisAirDaCaseFile() {
      return this.icisAirDaCaseFile;
   }

   public void setIcisAirDaCaseFile(IcisAirDaCaseFile icisAirDaCaseFile) {
      this.icisAirDaCaseFile = icisAirDaCaseFile;
   }
}
