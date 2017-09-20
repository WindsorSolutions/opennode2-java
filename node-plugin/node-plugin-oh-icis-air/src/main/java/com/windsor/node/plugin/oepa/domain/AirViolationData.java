package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirDaCaseFile;
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
   name = "AirViolationData"
)
@Table(
   name = "ICA_VIOL"
)
@Access(AccessType.PROPERTY)
public class AirViolationData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(AirViolationData.class);
   protected String dbid;
   private String airViolationTypeCode;
   private String airViolationProgramCode;
   private String airViolationPollutantCode;
   private String hpvDayZeroDate;
   private Date hpvDayZeroDateDb;
   private String frvDeterminationDate;
   private Date frvDeterminationDateDb;
   private IcisAirDaCaseFile icisAirDaCaseFile;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_VIOL_ID"
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

   @XmlPath("AirViolationTypeCode/text()")
   @Basic
   @Column(
      name = "VIOL_TYPE_CODE"
   )
   public String getAirViolationTypeCode() {
      return this.airViolationTypeCode;
   }

   public void setAirViolationTypeCode(String airViolationTypeCode) {
      this.airViolationTypeCode = airViolationTypeCode;
   }

   @XmlPath("AirViolationProgramCode/text()")
   @Basic
   @Column(
      name = "VIOL_PROG_CODE"
   )
   public String getAirViolationProgramCode() {
      return this.airViolationProgramCode;
   }

   public void setAirViolationProgramCode(String airViolationProgramCode) {
      this.airViolationProgramCode = airViolationProgramCode;
   }

   @XmlPath("AirViolationPollutantCode/text()")
   @Basic
   @Column(
      name = "VIOL_POLUT_CODE"
   )
   public String getAirViolationPollutantCode() {
      return this.airViolationPollutantCode;
   }

   public void setAirViolationPollutantCode(String airViolationPollutantCode) {
      this.airViolationPollutantCode = airViolationPollutantCode;
   }

   @XmlPath("HPVDayZeroDate/text()")
   @Transient
   public String getHpvDayZeroDate() {
      return this.hpvDayZeroDate;
   }

   public void setHpvDayZeroDate(String hpvDayZeroDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.hpvDayZeroDateDb = sdf.parse(hpvDayZeroDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + hpvDayZeroDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.hpvDayZeroDate = hpvDayZeroDate;
   }

   @Column(
      name = "HPV_DAY_ZERO_DATE"
   )
   public Date getHpvDayZeroDateDb() {
      return this.hpvDayZeroDateDb;
   }

   public void setHpvDayZeroDateDb(Date hpvDayZeroDateDb) {
      this.hpvDayZeroDateDb = hpvDayZeroDateDb;
   }


   @XmlPath("FRVDeterminationDate/text()")
   @Transient
   public String getFrvDeterminationDate() {
      return this.frvDeterminationDate;
   }

   public void setFrvDeterminationDate(String frvDeterminationDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.frvDeterminationDateDb = sdf.parse(frvDeterminationDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + frvDeterminationDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.frvDeterminationDate = frvDeterminationDate;
   }

   @Column(
           name = "FRV_DTRMN_DATE"
   )
   public Date getFrvDeterminationDateDb() {
      return this.frvDeterminationDateDb;
   }

   public void setFrvDeterminationDateDb(Date frvDeterminationDateDb) {
      this.frvDeterminationDateDb = frvDeterminationDateDb;
   }


   @XmlInverseReference(
      mappedBy = "airViolationDataList"
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
}
