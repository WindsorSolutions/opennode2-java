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
   name = "OtherPathwayActivityData"
)
@Table(
   name = "ICA_OTHR_PATHWAY_ACTY"
)
@Access(AccessType.PROPERTY)
public class OtherPathwayActivityData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(OtherPathwayActivityData.class);
   protected String dbid;
   private String otherPathwayCategoryCode;
   private String otherPathwayTypeCode;
   private String otherPathwayDate;
   private Date otherPathwayDateDb;
   private IcisAirDaCaseFile icisAirDaCaseFile;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_OTHR_PATHWAY_ACTY_ID"
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

   @XmlPath("OtherPathwayCategoryCode/text()")
   @Basic
   @Column(
      name = "OTHR_PATHWAY_CATG_CODE"
   )
   public String getOtherPathwayCategoryCode() {
      return this.otherPathwayCategoryCode;
   }

   public void setOtherPathwayCategoryCode(String otherPathwayCategoryCode) {
      this.otherPathwayCategoryCode = otherPathwayCategoryCode;
   }

   @XmlPath("OtherPathwayTypeCode/text()")
   @Basic
   @Column(
      name = "OTHR_PATHWAY_TYPE_CODE"
   )
   public String getOtherPathwayTypeCode() {
      return this.otherPathwayTypeCode;
   }

   public void setOtherPathwayTypeCode(String otherPathwayTypeCode) {
      this.otherPathwayTypeCode = otherPathwayTypeCode;
   }

   @XmlPath("OtherPathwayDate/text()")
   @Transient
   public String getOtherPathwayDate() {
      return this.otherPathwayDate;
   }

   public void setOtherPathwayDate(String otherPathwayDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.otherPathwayDateDb = sdf.parse(otherPathwayDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + otherPathwayDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.otherPathwayDate = otherPathwayDate;
   }

   @Column(
      name = "OTHR_PATHWAY_DATE"
   )
   public Date getOtherPathwayDateDb() {
      return this.otherPathwayDateDb;
   }

   public void setOtherPathwayDateDb(Date otherPathwayDateDb) {
      this.otherPathwayDateDb = otherPathwayDateDb;
   }

   @XmlInverseReference(
      mappedBy = "otherPathwayActivityDataList"
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
