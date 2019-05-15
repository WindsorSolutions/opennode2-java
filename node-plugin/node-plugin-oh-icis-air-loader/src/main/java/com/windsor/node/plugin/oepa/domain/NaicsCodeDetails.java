package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirFacility;
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

@Entity(
   name = "NaicsCodeDetails"
)
@Table(
   name = "ICA_NAICS_CODE"
)
@Access(AccessType.PROPERTY)
public class NaicsCodeDetails implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String naicsCode;
   private String naicsPrimaryIndicatorCode;
   private IcisAirFacility icisAirFacility;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_NAICS_CODE_ID"
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

   @XmlPath("NAICSCode/text()")
   @Basic
   @Column(
      name = "NAICS_CODE"
   )
   public String getNaicsCode() {
      return this.naicsCode;
   }

   public void setNaicsCode(String naicsCode) {
      this.naicsCode = naicsCode;
   }

   @XmlPath("NAICSPrimaryIndicatorCode/text()")
   @Basic
   @Column(
      name = "NAICS_PRI_IND_CODE"
   )
   public String getNaicsPrimaryIndicatorCode() {
      return this.naicsPrimaryIndicatorCode;
   }

   public void setNaicsPrimaryIndicatorCode(String naicsPrimaryIndicatorCode) {
      this.naicsPrimaryIndicatorCode = naicsPrimaryIndicatorCode;
   }

   @XmlInverseReference(
      mappedBy = "naicsCodeList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_FAC_ID",
      nullable = false
   )
   public IcisAirFacility getIcisAirFacility() {
      return this.icisAirFacility;
   }

   public void setIcisAirFacility(IcisAirFacility icisAirFacility) {
      this.icisAirFacility = icisAirFacility;
   }
}
