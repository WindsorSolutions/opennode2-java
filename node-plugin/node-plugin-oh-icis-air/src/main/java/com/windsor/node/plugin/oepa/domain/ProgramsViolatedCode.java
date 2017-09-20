package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirDaInformalEnforcementAction;
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
   name = "ProgramsViolatedCode"
)
@Table(
   name = "ICA_PROGS_VIOL"
)
@Access(AccessType.PROPERTY)
public class ProgramsViolatedCode implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String programsViolatedCode;
   private IcisAirDaInformalEnforcementAction icisAirDaInformalEnforcementAction;
   private IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_PROGS_VIOL_ID"
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
      name = "PROGS_VIOL_CODE"
   )
   public String getProgramsViolatedCode() {
      return this.programsViolatedCode;
   }

   public void setProgramsViolatedCode(String programsViolatedCode) {
      this.programsViolatedCode = programsViolatedCode;
   }

   @XmlInverseReference(
      mappedBy = "programsViolatedCode"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_INFRML_ENFRC_ACTN_ID",
      nullable = true
   )
   public IcisAirDaInformalEnforcementAction getIcisAirDaInformalEnforcementAction() {
      return this.icisAirDaInformalEnforcementAction;
   }

   public void setIcisAirDaInformalEnforcementAction(IcisAirDaInformalEnforcementAction icisAirDaInformalEnforcementAction) {
      this.icisAirDaInformalEnforcementAction = icisAirDaInformalEnforcementAction;
   }

   @XmlInverseReference(
      mappedBy = "programsViolatedCode"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_FRML_ENFRC_ACTN_ID",
      nullable = true
   )
   public IcisAirDaFormalEnforcementAction getIcisAirDaFormalEnforcementAction() {
      return this.icisAirDaFormalEnforcementAction;
   }

   public void setIcisAirDaFormalEnforcementAction(IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction) {
      this.icisAirDaFormalEnforcementAction = icisAirDaFormalEnforcementAction;
   }
}
