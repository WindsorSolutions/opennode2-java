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
import org.eclipse.persistence.oxm.annotations.XmlPath;
import org.safehaus.uuid.UUID;
import org.safehaus.uuid.UUIDGenerator;

@Entity(
   name = "IcisAirPrograms"
)
@Table(
   name = "ICA_PROGS"
)
@Access(AccessType.PROPERTY)
public class IcisAirPrograms extends SettableIcisAirPayload implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airFacilityIdentifier;
   private String airProgramCode;
   private List icisAirProgramsSubpartDataList;
   private String airProgramsOperatingStatusCode;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_PROGS_ID"
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

   @XmlPath("AirProgramCode/text()")
   @Basic
   @Column(
      name = "PROG_CODE"
   )
   public String getAirProgramCode() {
      return this.airProgramCode;
   }

   public void setAirProgramCode(String airProgramCode) {
      this.airProgramCode = airProgramCode;
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

   @XmlPath("AirProgramOperatingStatusData/AirProgramOperatingStatusCode/text()")
   @Basic
   @Column(
      name = "PROG_OPER_STAT_CODE"
   )
   public String getAirProgramsOperatingStatusCode() {
      return this.airProgramsOperatingStatusCode;
   }

   public void setAirProgramsOperatingStatusCode(String airProgramsOperatingStatusCode) {
      this.airProgramsOperatingStatusCode = airProgramsOperatingStatusCode;
   }

   @XmlPath("AirProgramSubpartData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "icisAirPrograms"
   )
   public List getIcisAirProgramsSubpartDataList() {
      return this.icisAirProgramsSubpartDataList;
   }

   public void setIcisAirProgramsSubpartDataList(List icisAirProgramsSubpartDataList) {
      this.icisAirProgramsSubpartDataList = icisAirProgramsSubpartDataList;
   }
}
