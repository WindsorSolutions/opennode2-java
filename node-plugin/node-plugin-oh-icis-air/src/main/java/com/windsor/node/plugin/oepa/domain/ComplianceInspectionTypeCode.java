package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
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
   name = "ComplianceInspectionTypeCode"
)
@Table(
   name = "ICA_CMPL_INSP_TYPE"
)
@Access(AccessType.PROPERTY)
public class ComplianceInspectionTypeCode implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String complianceInspectionTypeCode;
   private IcisAirComplianceMonitoringData icisAirComplianceMonitoringData;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_CMPL_INSP_TYPE_ID"
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
      name = "CMPL_INSP_TYPE_CODE"
   )
   public String getComplianceInspectionTypeCode() {
      return this.complianceInspectionTypeCode;
   }

   public void setComplianceInspectionTypeCode(String complianceInspectionTypeCode) {
      this.complianceInspectionTypeCode = complianceInspectionTypeCode;
   }

   @XmlInverseReference(
      mappedBy = "complianceInspectionTypeCodeList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_CMPL_MON_ID",
      nullable = false
   )
   public IcisAirComplianceMonitoringData getIcisAirComplianceMonitoringData() {
      return this.icisAirComplianceMonitoringData;
   }

   public void setIcisAirComplianceMonitoringData(IcisAirComplianceMonitoringData icisAirComplianceMonitoringData) {
      this.icisAirComplianceMonitoringData = icisAirComplianceMonitoringData;
   }
}
