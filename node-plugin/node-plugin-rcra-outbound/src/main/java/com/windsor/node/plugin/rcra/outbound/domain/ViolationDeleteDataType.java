package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigInteger;

@Entity
@Table(name = "RCRA_CME_VIOL_DEL")
public class ViolationDeleteDataType {

    private String dbid;
    private String violationActivityLocation;
    private BigInteger violationSequenceNumber;
    private String agencyWhichDeterminedViolation;
    private String notes;

    @Id
    @Column(name = "CME_VIOL_DEL_ID")
    @GeneratedValue(generator = "UUID", strategy = GenerationType.AUTO)
    public String getDbid() {
        return dbid;
    }

    public void setDbid(String value) {
        this.dbid = value;
    }

    @Basic
    @Column(name = "VIOL_ACT_LOC", length = 2)
    public String getViolationActivityLocation() {
        return violationActivityLocation;
    }

    public void setViolationActivityLocation(String value) {
        this.violationActivityLocation = value;
    }

    @Basic
    @Column(name = "VIOL_SEQ_NUM", precision = 4, scale = 0)
    public BigInteger getViolationSequenceNumber() {
        return violationSequenceNumber;
    }

    public void setViolationSequenceNumber(BigInteger value) {
        this.violationSequenceNumber = value;
    }

    @Basic
    @Column(name = "AGN_WHICH_DTRM_VIOL", length = 1)
    public String getAgencyWhichDeterminedViolation() {
        return agencyWhichDeterminedViolation;
    }

    public void setAgencyWhichDeterminedViolation(String value) {
        this.agencyWhichDeterminedViolation = value;
    }

    @Basic
    @Column(name = "NOTES", length = 4000)
    public String getNotes() {
        return notes;
    }

    public void setNotes(String value) {
        this.notes = value;
    }

    public static ViolationDeleteDataType convertViolationFromXml(ViolationDataType source) {
        ViolationDeleteDataType dest = new ViolationDeleteDataType();
        dest.setViolationActivityLocation(source.getViolationActivityLocation());
        dest.setViolationSequenceNumber(source.getViolationSequenceNumber());
        dest.setAgencyWhichDeterminedViolation(source.getAgencyWhichDeterminedViolation());
        dest.setNotes(source.getNotes());
        return dest;
    }

}
