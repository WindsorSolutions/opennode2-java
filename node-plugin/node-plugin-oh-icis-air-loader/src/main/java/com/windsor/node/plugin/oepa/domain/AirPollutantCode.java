package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirDaInformalEnforcementAction;
import com.windsor.node.plugin.oepa.domain.IcisAirTvaccData;
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
   name = "AirPollutantCode"
)
@Table(
   name = "ICA_POLUT"
)
@Access(AccessType.PROPERTY)
public class AirPollutantCode implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String programCode;
   private IcisAirTvaccData icisAirTvaccData;
   private IcisAirDaCaseFile icisAirDaCaseFile;
   private IcisAirComplianceMonitoringData icisAirComplianceMonitoringData;
   private IcisAirDaInformalEnforcementAction icisAirDaInformalEnforcementAction;
   private IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_POLUT_ID"
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
      name = "POLUT_CODE"
   )
   public String getProgramCode() {
      return this.programCode;
   }

   public void setProgramCode(String programCode) {
      this.programCode = programCode;
   }

   @XmlInverseReference(
      mappedBy = "airPollutantCodeList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_TVACC_ID",
      nullable = true
   )
   public IcisAirTvaccData getIcisAirTvaccData() {
      return this.icisAirTvaccData;
   }

   public void setIcisAirTvaccData(IcisAirTvaccData icisAirTvaccData) {
      this.icisAirTvaccData = icisAirTvaccData;
   }

   @XmlInverseReference(
      mappedBy = "airPollutantCodeList"
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

   @XmlInverseReference(
      mappedBy = "airPollutantCodeList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_CMPL_MON_ID",
      nullable = true
   )
   public IcisAirComplianceMonitoringData getIcisAirComplianceMonitoringData() {
      return this.icisAirComplianceMonitoringData;
   }

   public void setIcisAirComplianceMonitoringData(IcisAirComplianceMonitoringData icisAirComplianceMonitoringData) {
      this.icisAirComplianceMonitoringData = icisAirComplianceMonitoringData;
   }

   @XmlInverseReference(
      mappedBy = "airPollutantCodeList"
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
      mappedBy = "airPollutantCodeList"
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
