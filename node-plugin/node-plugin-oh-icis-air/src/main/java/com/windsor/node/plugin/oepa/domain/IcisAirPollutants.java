package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirPollutantDaClassificationData;
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
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "IcisAirPollutants"
)
@Table(
   name = "ICA_POLUTS"
)
@Access(AccessType.PROPERTY)
public class IcisAirPollutants extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airFacilityIdentifier;
   private String airPollutantsCode;
   private List<IcisAirPollutantDaClassificationData> icisAirPollutantDAClassificationDataList;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_POLUTS_ID"
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

   @XmlPath("AirPollutantsCode/text()")
   @Basic
   @Column(
      name = "POLUTS_CODE"
   )
   public String getAirPollutantsCode() {
      return this.airPollutantsCode;
   }

   public void setAirPollutantsCode(String airPollutantsCode) {
      this.airPollutantsCode = airPollutantsCode;
   }

   @XmlPath("AirPollutantDAClassificationData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirPollutants"
   )
   public List<IcisAirPollutantDaClassificationData> getIcisAirPollutantDAClassificationDataList() {
      return this.icisAirPollutantDAClassificationDataList;
   }

   public void setIcisAirPollutantDAClassificationDataList(List<IcisAirPollutantDaClassificationData> icisAirPollutantDAClassificationDataList) {
      this.icisAirPollutantDAClassificationDataList = icisAirPollutantDAClassificationDataList;
   }
}
