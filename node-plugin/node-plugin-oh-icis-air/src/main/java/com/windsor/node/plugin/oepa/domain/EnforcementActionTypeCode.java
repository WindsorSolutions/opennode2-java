package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
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
   name = "EnforcementActionTypeCode"
)
@Table(
   name = "ICA_ENFRC_ACTN_TYPE"
)
@Access(AccessType.PROPERTY)
public class EnforcementActionTypeCode implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String enforcementActionTypeCode;
   private IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_ENFRC_ACTN_TYPE_ID"
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
      name = "ENFRC_ACTN_TYPE_CODE"
   )
   public String getEnforcementActionTypeCode() {
      return this.enforcementActionTypeCode;
   }

   public void setEnforcementActionTypeCode(String enforcementActionTypeCode) {
      this.enforcementActionTypeCode = enforcementActionTypeCode;
   }

   @XmlInverseReference(
      mappedBy = "enforcementActionTypeCodeList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_FRML_ENFRC_ACTN_ID",
      nullable = false
   )
   public IcisAirDaFormalEnforcementAction getIcisAirDaFormalEnforcementAction() {
      return this.icisAirDaFormalEnforcementAction;
   }

   public void setIcisAirDaFormalEnforcementAction(IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction) {
      this.icisAirDaFormalEnforcementAction = icisAirDaFormalEnforcementAction;
   }
}
