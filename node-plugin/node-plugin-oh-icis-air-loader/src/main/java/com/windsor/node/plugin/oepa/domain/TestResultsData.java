package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.AirStackTestData;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Entity(
   name = "TestResultsData"
)
@Table(
   name = "ICA_TST_RSLTS"
)
@Access(AccessType.PROPERTY)
public class TestResultsData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(TestResultsData.class);
   protected String dbid;
   private String airTestedPollutantCode;
   private AirStackTestData airStackTestData;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_TST_RSLTS_ID"
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

   @XmlPath("AirTestedPollutantCode/text()")
   @Basic
   @Column(
      name = "TESTED_POLUT_CODE"
   )
   public String getAirTestedPollutantCode() {
      return this.airTestedPollutantCode;
   }

   public void setAirTestedPollutantCode(String airTestedPollutantCode) {
      this.airTestedPollutantCode = airTestedPollutantCode;
   }

   @XmlInverseReference(
      mappedBy = "testResultsDataList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_STCK_TST_ID",
      nullable = false
   )
   public AirStackTestData getAirStackTestData() {
      return this.airStackTestData;
   }

   public void setAirStackTestData(AirStackTestData airStackTestData) {
      this.airStackTestData = airStackTestData;
   }
}
