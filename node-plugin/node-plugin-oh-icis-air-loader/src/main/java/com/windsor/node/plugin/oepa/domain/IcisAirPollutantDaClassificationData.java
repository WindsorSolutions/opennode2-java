package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirPollutants;
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
   name = "IcisAirPollutantDaClassificationData"
)
@Table(
   name = "ICA_POLUT_DA_CLASS"
)
@Access(AccessType.PROPERTY)
public class IcisAirPollutantDaClassificationData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirPollutantDaClassificationData.class);
   protected String dbid;
   private String airPollutantDaClassificationCode;
   private String airPollutantDaClassificationStartDate;
   private Date airPollutantDaClassificationStartDateDb;
   private IcisAirPollutants icisAirPollutants;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_POLUT_DA_CLASS_ID"
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

   @XmlInverseReference(
      mappedBy = "icisAirPollutantDAClassificationDataList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_POLUTS_ID",
      nullable = false
   )
   public IcisAirPollutants getIcisAirPollutants() {
      return this.icisAirPollutants;
   }

   public void setIcisAirPollutants(IcisAirPollutants icisAirPollutants) {
      this.icisAirPollutants = icisAirPollutants;
   }

   @XmlPath("AirPollutantDAClassificationCode/text()")
   @Basic
   @Column(
      name = "POLUT_DA_CLASS_CODE"
   )
   public String getAirPollutantDaClassificationCode() {
      return this.airPollutantDaClassificationCode;
   }

   public void setAirPollutantDaClassificationCode(String airPollutantDaClassificationCode) {
      this.airPollutantDaClassificationCode = airPollutantDaClassificationCode;
   }

   @XmlPath("AirPollutantDAClassificationStartDate/text()")
   @Transient
   public String getAirPollutantDaClassificationStartDate() {
      return this.airPollutantDaClassificationStartDate;
   }

   public void setAirPollutantDaClassificationStartDate(String airPollutantDaClassificationStartDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.airPollutantDaClassificationStartDateDb = sdf.parse(airPollutantDaClassificationStartDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + airPollutantDaClassificationStartDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.airPollutantDaClassificationStartDate = airPollutantDaClassificationStartDate;
   }

   @Basic
   @Column(
      name = "POLUT_DA_CLASS_START_DATE"
   )
   public Date getAirPollutantDaClassificationStartDateDb() {
      return this.airPollutantDaClassificationStartDateDb;
   }

   public void setAirPollutantDaClassificationStartDateDb(Date airPollutantDaClassificationStartDateDb) {
      this.airPollutantDaClassificationStartDateDb = airPollutantDaClassificationStartDateDb;
   }
}
