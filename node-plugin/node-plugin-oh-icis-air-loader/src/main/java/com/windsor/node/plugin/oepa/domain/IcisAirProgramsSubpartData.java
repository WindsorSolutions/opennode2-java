package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirPrograms;
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
   name = "IcisAirProgramsSubpartData"
)
@Table(
   name = "ICA_PROG_SUBPART"
)
@Access(AccessType.PROPERTY)
public class IcisAirProgramsSubpartData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected String dbid;
   private String airProgramsSubpartCode;
   private String airProgramsSubpartStatusIndicator;
   private IcisAirPrograms icisAirPrograms;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_PROG_SUBPART_ID"
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

   @XmlPath("AirProgramSubpartCode/text()")
   @Basic
   @Column(
      name = "PROG_SUBPART_CODE"
   )
   public String getAirProgramsSubpartCode() {
      return this.airProgramsSubpartCode;
   }

   public void setAirProgramsSubpartCode(String airProgramsSubpartCode) {
      this.airProgramsSubpartCode = airProgramsSubpartCode;
   }

   @XmlPath("AirProgramSubpartStatusIndicator/text()")
   @Basic
   @Column(
      name = "PROG_SUBPART_STAT_IND"
   )
   public String getAirProgramsSubpartStatusIndicator() {
      return this.airProgramsSubpartStatusIndicator;
   }

   public void setAirProgramsSubpartStatusIndicator(String airProgramsSubpartStatusIndicator) {
      this.airProgramsSubpartStatusIndicator = airProgramsSubpartStatusIndicator;
   }

   @XmlInverseReference(
      mappedBy = "icisAirProgramsSubpartDataList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_PROGS_ID",
      nullable = false
   )
   public IcisAirPrograms getIcisAirPrograms() {
      return this.icisAirPrograms;
   }

   public void setIcisAirPrograms(IcisAirPrograms icisAirPrograms) {
      this.icisAirPrograms = icisAirPrograms;
   }
}
