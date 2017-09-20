package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
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
   name = "ProgramCode"
)
@Table(
   name = "ICA_PROG"
)
@Access(AccessType.PROPERTY)
public class ProgramCode implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String programCode;
   private IcisAirTvaccData icisAirTvaccData;
   private IcisAirDaCaseFile icisAirDaCaseFile;
   private IcisAirComplianceMonitoringData icisAirComplianceMonitoringData;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_PROG_ID"
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
      name = "PROG_CODE"
   )
   public String getProgramCode() {
      return this.programCode;
   }

   public void setProgramCode(String programCode) {
      this.programCode = programCode;
   }

   @XmlInverseReference(
      mappedBy = "programCodeList"
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
      mappedBy = "programCodeList"
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
      mappedBy = "programCodeList"
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
}
