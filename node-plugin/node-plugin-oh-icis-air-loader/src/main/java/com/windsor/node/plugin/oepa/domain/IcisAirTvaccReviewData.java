package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirTvaccData;
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
   name = "IcisAirTvaccReviewData"
)
@Table(
   name = "ICA_TVACC_REVIEW"
)
@Access(AccessType.PROPERTY)
public class IcisAirTvaccReviewData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(IcisAirTvaccReviewData.class);
   protected String dbid;
   private String tvaccReviewedDate;
   private Date tvaccReviewedDateDb;
   private String facilityReportDeviationsIndicator;
   private String reviewerAgencyCode;
   private IcisAirTvaccData icisAirTvaccData;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_TVACC_REVIEW_ID"
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
      mappedBy = "icisAirTvaccReviewDataList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_TVACC_ID",
      nullable = false
   )
   public IcisAirTvaccData getIcisAirTvaccData() {
      return this.icisAirTvaccData;
   }

   public void setIcisAirTvaccData(IcisAirTvaccData icisAirTvaccData) {
      this.icisAirTvaccData = icisAirTvaccData;
   }

   @XmlPath("TVACCReviewedDate/text()")
   @Transient
   public String getTvaccReviewedDate() {
      return this.tvaccReviewedDate;
   }

   public void setTvaccReviewedDate(String tvaccReviewedDate) {
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-HH:mm");

      try {
         this.tvaccReviewedDateDb = sdf.parse(tvaccReviewedDate);
      } catch (ParseException var4) {
         this.logger.warn("Could not parse date, String value \"" + tvaccReviewedDate + "\"," + " was expecting \"yyyy-MM-dd-HH:mm\" format.");
      }

      this.tvaccReviewedDate = tvaccReviewedDate;
   }

   @Column(
      name = "TVACC_REVIEWED_DATE"
   )
   public Date getTvaccReviewedDateDb() {
      return this.tvaccReviewedDateDb;
   }

   public void setTvaccReviewedDateDb(Date tvaccReviewedDateDb) {
      this.tvaccReviewedDateDb = tvaccReviewedDateDb;
   }

   @XmlPath("FacilityReportDeviationsIndicator/text()")
   @Basic
   @Column(
      name = "FAC_REP_DEVIATIONS_IND"
   )
   public String getFacilityReportDeviationsIndicator() {
      return this.facilityReportDeviationsIndicator;
   }

   public void setFacilityReportDeviationsIndicator(String facilityReportDeviationsIndicator) {
      this.facilityReportDeviationsIndicator = facilityReportDeviationsIndicator;
   }

   @XmlPath("ReviewerAgencyCode/text()")
   @Basic
   @Column(
      name = "REVIEWER_AGNCY_CODE"
   )
   public String getReviewerAgencyCode() {
      return this.reviewerAgencyCode;
   }

   public void setReviewerAgencyCode(String reviewerAgencyCode) {
      this.reviewerAgencyCode = reviewerAgencyCode;
   }
}
