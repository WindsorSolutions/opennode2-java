package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
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
   name = "AirFacilityIdentifier"
)
@Table(
   name = "ICA_FAC_IDENT"
)
@Access(AccessType.PROPERTY)
public class AirFacilityIdentifier implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airFacilityIdentifier;
   private IcisAirComplianceMonitoringData icisAirComplianceMonitoringData;
   private IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction;
   private IcisAirDaInformalEnforcementAction icisAirDaInformalEnforcementAction;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_FAC_IDENT_ID"
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
      name = "FAC_IDENT"
   )
   public String getAirFacilityIdentifier() {
      return this.airFacilityIdentifier;
   }

   public void setAirFacilityIdentifier(String airFacilityIdentifier) {
      this.airFacilityIdentifier = airFacilityIdentifier;
   }

   @XmlInverseReference(
      mappedBy = "airFacilityIdentifierList"
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
      mappedBy = "airFacilityIdentifierList"
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

   @XmlInverseReference(
      mappedBy = "airFacilityIdentifierList"
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
}
