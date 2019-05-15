package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirDaFormalEnforcementAction;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
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
   name = "AirDaFinalOrder"
)
@Table(
   name = "ICA_DA_FINAL_ORDER"
)
@Access(AccessType.PROPERTY)
public class AirDaFinalOrder implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(AirDaFinalOrder.class);
   protected String dbid;
   private String finalOrderIdentifier;
   private String finalOrderTypeCode;
   private Date finalOrderIssuedEnteredDateDb;
   private String finalOrderIssuedEnteredDate;
   private Date airResolvedDateDb;
   private String airResolvedDate;
   private String cashCivilPenaltyRequiredAmount;
   private String otherComments;
   private List demandStipulatedPenaltyList;
   private List finalOrderFacilityIdentifierList;
   private IcisAirDaFormalEnforcementAction icisAirDaFormalEnforcementAction;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_DA_FINAL_ORDER_ID"
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

   @XmlPath("FinalOrderIdentifier/text()")
   @Basic
   @Column(
      name = "FINAL_ORDER_IDENT"
   )
   public String getFinalOrderIdentifier() {
      return this.finalOrderIdentifier;
   }

   public void setFinalOrderIdentifier(String finalOrderIdentifier) {
      this.finalOrderIdentifier = finalOrderIdentifier;
   }

   @XmlPath("FinalOrderTypeCode/text()")
   @Basic
   @Column(
      name = "FINAL_ORDER_TYPE_CODE"
   )
   public String getFinalOrderTypeCode() {
      return this.finalOrderTypeCode;
   }

   public void setFinalOrderTypeCode(String finalOrderTypeCode) {
      this.finalOrderTypeCode = finalOrderTypeCode;
   }

   @Basic
   @Column(
      name = "FINAL_ORDER_ISSUED_ENTERD_DATE"
   )
   public Date getFinalOrderIssuedEnteredDateDb() {
      return this.finalOrderIssuedEnteredDateDb;
   }

   public void setFinalOrderIssuedEnteredDateDb(Date finalOrderIssuedEnteredDateDb) {
      this.finalOrderIssuedEnteredDateDb = finalOrderIssuedEnteredDateDb;
   }

   @XmlPath("FinalOrderIssuedEnteredDate/text()")
   @Transient
   public String getFinalOrderIssuedEnteredDate() {
      return this.finalOrderIssuedEnteredDate;
   }

   public void setFinalOrderIssuedEnteredDate(String finalOrderIssuedEnteredDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.finalOrderIssuedEnteredDateDb = sdf.parse(finalOrderIssuedEnteredDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + finalOrderIssuedEnteredDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.finalOrderIssuedEnteredDate = finalOrderIssuedEnteredDate;
   }

   @Basic
   @Column(
      name = "RSLVD_DATE"
   )
   public Date getAirResolvedDateDb() {
      return this.airResolvedDateDb;
   }

   public void setAirResolvedDateDb(Date airResolvedDateDb) {
      this.airResolvedDateDb = airResolvedDateDb;
   }

   @XmlPath("AirResolvedDate/text()")
   @Transient
   public String getAirResolvedDate() {
      return this.airResolvedDate;
   }

   public void setAirResolvedDate(String airResolvedDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.airResolvedDateDb = sdf.parse(airResolvedDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + airResolvedDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.airResolvedDate = airResolvedDate;
   }

   @XmlPath("CashCivilPenaltyRequiredAmount/text()")
   @Basic
   @Column(
      name = "CASH_CIVIL_PNLTY_REQD_AMT"
   )
   public String getCashCivilPenaltyRequiredAmount() {
      return this.cashCivilPenaltyRequiredAmount;
   }

   public void setCashCivilPenaltyRequiredAmount(String cashCivilPenaltyRequiredAmount) {
      this.cashCivilPenaltyRequiredAmount = cashCivilPenaltyRequiredAmount;
   }

   @XmlPath("OtherComments/text()")
   @Basic
   @Column(
      name = "OTHR_CMNTS"
   )
   public String getOtherComments() {
      return this.otherComments;
   }

   public void setOtherComments(String otherComments) {
      this.otherComments = otherComments;
   }

   @XmlInverseReference(
      mappedBy = "airDaFinalOrderList"
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

   @XmlPath("DemandStipulatedPenalty")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "airDaFinalOrder",
      orphanRemoval = true
   )
   public List getDemandStipulatedPenaltyList() {
      return this.demandStipulatedPenaltyList;
   }

   public void setDemandStipulatedPenaltyList(List demandStipulatedPenaltyList) {
      this.demandStipulatedPenaltyList = demandStipulatedPenaltyList;
   }

   @XmlPath("FinalOrderAirFacilityIdentifier")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "airDaFinalOrder",
      orphanRemoval = true
   )
   public List getFinalOrderFacilityIdentifierList() {
      return this.finalOrderFacilityIdentifierList;
   }

   public void setFinalOrderFacilityIdentifierList(List finalOrderFacilityIdentifierList) {
      this.finalOrderFacilityIdentifierList = finalOrderFacilityIdentifierList;
   }
}
