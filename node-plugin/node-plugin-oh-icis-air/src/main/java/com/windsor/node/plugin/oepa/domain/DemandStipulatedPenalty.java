package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.AirDaFinalOrder;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.oxm.annotations.XmlInverseReference;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity(
   name = "DemandStipulatedPenalty"
)
@Table(
   name = "ICA_DEMND_STIPULTD_PNLTY"
)
@Access(AccessType.PROPERTY)
public class DemandStipulatedPenalty implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(DemandStipulatedPenalty.class);
   protected String dbid;
   private Date demandStipulatedPenaltyPaidDateDb;
   private String demandStipulatedPenaltyPaidDate;
   private String demandStipulatedPenaltyAmount;
   private AirDaFinalOrder airDaFinalOrder;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DEMND_STIPULTD_PNLTY_ID"
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

   @Basic
   @Column(
      name = "DEMND_STIPULTD_PNLTY_PAID_DATE"
   )
   public Date getDemandStipulatedPenaltyPaidDateDb() {
      return this.demandStipulatedPenaltyPaidDateDb;
   }

   public void setDemandStipulatedPenaltyPaidDateDb(Date demandStipulatedPenaltyPaidDateDb) {
      this.demandStipulatedPenaltyPaidDateDb = demandStipulatedPenaltyPaidDateDb;
   }

   @XmlPath("DemandStipulatedPenaltyPaidDate/text()")
   @Transient
   public String getDemandStipulatedPenaltyPaidDate() {
      return this.demandStipulatedPenaltyPaidDate;
   }

   public void setDemandStipulatedPenaltyPaidDate(String demandStipulatedPenaltyPaidDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.demandStipulatedPenaltyPaidDateDb = sdf.parse(demandStipulatedPenaltyPaidDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + demandStipulatedPenaltyPaidDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.demandStipulatedPenaltyPaidDate = demandStipulatedPenaltyPaidDate;
   }

   @XmlPath("DemandStipulatedPenaltyAmount/text()")
   @Basic
   @Column(
      name = "DEMND_STIPULTD_PNLTY_AMT"
   )
   public String getDemandStipulatedPenaltyAmount() {
      return this.demandStipulatedPenaltyAmount;
   }

   public void setDemandStipulatedPenaltyAmount(String demandStipulatedPenaltyAmount) {
      this.demandStipulatedPenaltyAmount = demandStipulatedPenaltyAmount;
   }

   @XmlInverseReference(
      mappedBy = "demandStipulatedPenaltyList"
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
