package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.SettableIcisAirPayload;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlTransient;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.persistence.annotations.CascadeOnDelete;
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "IcisAirFacility"
)
@Table(
   name = "ICA_FAC"
)
@Access(AccessType.PROPERTY)
@CascadeOnDelete
public class IcisAirFacility extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   private String dbid;
   private String airFacilityIdentifier;
   private String facilitySiteName;
   private String locationAddressText;
   private String locationAddressCityCode;
   private String locationStateCode;
   private String locationZipCode;
   private List naicsCodeList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_FAC_ID"
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

   @XmlPath("AirFacilityIdentifier/text()")
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

   @XmlPath("FacilitySiteName/text()")
   @Basic
   @Column(
      name = "FAC_SITE_NAME"
   )
   public String getFacilitySiteName() {
      return this.facilitySiteName;
   }

   public void setFacilitySiteName(String facilitySiteName) {
      this.facilitySiteName = facilitySiteName;
   }

   @XmlPath("LocationAddressText/text()")
   @Basic
   @Column(
      name = "LOC_ADDR_TXT"
   )
   public String getLocationAddressText() {
      return this.locationAddressText;
   }

   public void setLocationAddressText(String locationAddressText) {
      this.locationAddressText = locationAddressText;
   }

   @XmlPath("LocationAddressCityCode/text()")
   @Basic
   @Column(
      name = "LOC_ADDR_CITY_CODE"
   )
   public String getLocationAddressCityCode() {
      return this.locationAddressCityCode;
   }

   public void setLocationAddressCityCode(String locationAddressCityCode) {
      this.locationAddressCityCode = locationAddressCityCode;
   }

   @XmlPath("LocationStateCode/text()")
   @Basic
   @Column(
      name = "LOC_ST_CODE"
   )
   public String getLocationStateCode() {
      return this.locationStateCode;
   }

   public void setLocationStateCode(String locationStateCode) {
      this.locationStateCode = locationStateCode;
   }

   @XmlPath("LocationZipCode/text()")
   @Basic
   @Column(
      name = "LOC_ZIP_CODE"
   )
   public String getLocationZipCode() {
      return this.locationZipCode;
   }

   public void setLocationZipCode(String locationZipCode) {
      this.locationZipCode = locationZipCode;
   }

   @XmlPath("NAICSCodeDetails")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirFacility"
   )
   public List getNaicsCodeList() {
      return this.naicsCodeList;
   }

   public void setNaicsCodeList(List naicsCodeList) {
      this.naicsCodeList = naicsCodeList;
   }
}
