package com.windsor.node.plugin.oepa.domain;

import com.windsor.node.plugin.oepa.domain.IcisAirComplianceMonitoringData;
import java.io.Serializable;
import java.util.List;
import javax.persistence.Access;
import javax.persistence.AccessType;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
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
   name = "AirStackTestData"
)
@Table(
   name = "ICA_STCK_TST"
)
@Access(AccessType.PROPERTY)
public class AirStackTestData implements Serializable {
   private static final long serialVersionUID = 210L;
   protected Logger logger = LoggerFactory.getLogger(AirStackTestData.class);
   protected String dbid;
   private String stackTestStatusCode;
   private String stackTestConductorTypeCode;
   private String stackIdentifier;
   private List testResultsDataList;
   private IcisAirComplianceMonitoringData icisAirComplianceMonitoringData;

   @XmlTransient
   @Id
   @Column(
      name = "ICA_STCK_TST_ID"
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

   @XmlPath("StackTestStatusCode/text()")
   @Basic
   @Column(
      name = "STCK_TST_STAT_CODE"
   )
   public String getStackTestStatusCode() {
      return this.stackTestStatusCode;
   }

   public void setStackTestStatusCode(String stackTestStatusCode) {
      this.stackTestStatusCode = stackTestStatusCode;
   }

   @XmlPath("StackTestConductorTypeCode/text()")
   @Basic
   @Column(
      name = "STCK_TST_CNDCTR_TYPE_CODE"
   )
   public String getStackTestConductorTypeCode() {
      return this.stackTestConductorTypeCode;
   }

   public void setStackTestConductorTypeCode(String stackTestConductorTypeCode) {
      this.stackTestConductorTypeCode = stackTestConductorTypeCode;
   }

   @XmlPath("StackIdentifier/text()")
   @Basic
   @Column(
      name = "STCK_IDENT"
   )
   public String getStackIdentifier() {
      return this.stackIdentifier;
   }

   public void setStackIdentifier(String stackIdentifier) {
      this.stackIdentifier = stackIdentifier;
   }

   @XmlPath("TestResultsData")
   @OneToMany(
      cascade = {CascadeType.ALL},
      mappedBy = "airStackTestData",
      orphanRemoval = true
   )
   public List getTestResultsDataList() {
      return this.testResultsDataList;
   }

   public void setTestResultsDataList(List testResultsDataList) {
      this.testResultsDataList = testResultsDataList;
   }

   @XmlInverseReference(
      mappedBy = "airStackTestDataList"
   )
   @ManyToOne
   @JoinColumn(
      name = "ICA_DA_CMPL_MON_ID",
      nullable = false
   )
   public IcisAirComplianceMonitoringData getIcisAirComplianceMonitoringData() {
      return this.icisAirComplianceMonitoringData;
   }

   public void setIcisAirComplianceMonitoringData(IcisAirComplianceMonitoringData icisAirComplianceMonitoringData) {
      this.icisAirComplianceMonitoringData = icisAirComplianceMonitoringData;
   }
}
