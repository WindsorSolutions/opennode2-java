package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.AirDaFinalOrder;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity(
   name = "FinalOrderAirFacilityIdentifier"
)
@Table(
   name = "ICA_FINAL_ORDER_FAC_IDENT"
)
@Access(AccessType.PROPERTY)
public class FinalOrderAirFacilityIdentifier implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(FinalOrderAirFacilityIdentifier.class);
   protected String dbid;
   private String finalOrderAirFacilityIdentifier;
   private AirDaFinalOrder airDaFinalOrder;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_FINAL_ORDER_FAC_IDENT_ID"
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
      name = "FINAL_ORDER_FAC_IDENT"
   )
   public String getFinalOrderAirFacilityIdentifier() {
      return this.finalOrderAirFacilityIdentifier;
   }

   public void setFinalOrderAirFacilityIdentifier(String finalOrderAirFacilityIdentifier) {
      this.finalOrderAirFacilityIdentifier = finalOrderAirFacilityIdentifier;
   }

   @XmlInverseReference(
      mappedBy = "finalOrderFacilityIdentifierList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_FINAL_ORDER_ID",
      nullable = true
   )
   public AirDaFinalOrder getAirDaFinalOrder() {
      return this.airDaFinalOrder;
   }

   public void setAirDaFinalOrder(AirDaFinalOrder airDaFinalOrder) {
      this.airDaFinalOrder = airDaFinalOrder;
   }
}
