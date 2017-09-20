package com.windsor.node.plugin.gagapdesgeos.domain;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

/**
 * Provides a data object that models a GAPDES storm water submission.
 */
@Entity
@Table(name = "GAPDES_SW_SUBMISSION")
public class GeosSwSubmission {

    @Id
    @Column(name = "submission_id")
    public Integer submissionId;

    @Column(name = "application_rid")
    public String applicationRid;

    @Column(name = "application_type")
    public String applicationType;

    @Column(name = "application_name")
    public String applicationName;

//    @Column(name = "application_status")
//    public String applicationStatus;

    @Column(name = "submission_status")
    public String submissionStatus;

    @Column(name = "submitted_date")
    public Date submittedDate;

    @Column(name = "facility_id")
    public String facilityId;

    @Column(name = "facility_name")
    public String facilityName;

    @Column(name = "sub_system_original_id")
    public String subSystemOriginalId;

    @Column(name = "dept_rid")
    public String deptRid;

    @Column(name = "assign_to")
    public String assignTo;

    @Column(name = "charge_amount")
    public String chargeAmount;

//    @Column(name = "permit_id")
//    public String permitId;

    @Column(name = "permit_number")
    public String permitNumber;

    @Column(name = "permit_type")
    public String permitType;

    @Column(name = "permit_status")
    public String permitStatus;

    @Column(name = "issued_date")
    public Date issuedDate;

    @Column(name = "effective_date")
    public Date effectiveDate;

    @Column(name = "expiration_date")
    public Date expirationDate;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "geosSwSubmission")
    public List<Milestone> milestones;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "geosSwSubmission")
    public List<FormData> formData;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "geosSwSubmission")
    public List<FormList> formLists;

    public Integer getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(Integer submissionId) {
        this.submissionId = submissionId;
    }

    public String getApplicationRid() {
        return applicationRid;
    }

    public void setApplicationRid(String applicationRid) {
        this.applicationRid = applicationRid;
    }

    public String getApplicationType() {
        return applicationType;
    }

    public void setApplicationType(String applicationType) {
        this.applicationType = applicationType;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public String getSubmissionStatus() {
        return submissionStatus;
    }

    public void setSubmissionStatus(String submissionStatus) {
        this.submissionStatus = submissionStatus;
    }

    public Date getSubmittedDate() {
        return submittedDate;
    }

    public void setSubmittedDate(Date submittedDate) {
        this.submittedDate = submittedDate;
    }

    public String getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(String facilityId) {
        this.facilityId = facilityId;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

    public String getSubSystemOriginalId() {
        return subSystemOriginalId;
    }

    public void setSubSystemOriginalId(String subSystemOriginalId) {
        this.subSystemOriginalId = subSystemOriginalId;
    }

    public String getDeptRid() {
        return deptRid;
    }

    public void setDeptRid(String deptRid) {
        this.deptRid = deptRid;
    }

    public String getAssignTo() {
        return assignTo;
    }

    public void setAssignTo(String assignTo) {
        this.assignTo = assignTo;
    }

    public String getChargeAmount() {
        return chargeAmount;
    }

    public void setChargeAmount(String chargeAmount) {
        this.chargeAmount = chargeAmount;
    }

    public String getPermitNumber() {
        return permitNumber;
    }

    public void setPermitNumber(String permitNumber) {
        this.permitNumber = permitNumber;
    }

    public String getPermitType() {
        return permitType;
    }

    public void setPermitType(String permitType) {
        this.permitType = permitType;
    }

    public String getPermitStatus() {
        return permitStatus;
    }

    public void setPermitStatus(String permitStatus) {
        this.permitStatus = permitStatus;
    }

    public Date getIssuedDate() {
        return issuedDate;
    }

    public void setIssuedDate(Date issuedDate) {
        this.issuedDate = issuedDate;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public List<Milestone> getMilestones() {
        return milestones;
    }

    public void setMilestones(List<Milestone> milestones) {
        this.milestones = milestones;
    }

    public List<FormData> getFormData() {
        return formData;
    }

    public void setFormData(List<FormData> formData) {
        this.formData = formData;
    }

    public List<FormList> getFormLists() {
        return formLists;
    }

    public void setFormLists(List<FormList> formLists) {
        this.formLists = formLists;
    }

    @Override
    public String toString() {
        return "GeosSwSubmission{" +
                "submissionId=" + submissionId +
                ", applicationRid='" + applicationRid + '\'' +
                ", applicationType='" + applicationType + '\'' +
                ", applicationName='" + applicationName + '\'' +
                ", submissionStatus='" + submissionStatus + '\'' +
                ", submittedDate=" + submittedDate +
                ", facilityId='" + facilityId + '\'' +
                ", facilityName='" + facilityName + '\'' +
                ", subSystemOriginalId='" + subSystemOriginalId + '\'' +
                ", deptRid='" + deptRid + '\'' +
                ", assignTo='" + assignTo + '\'' +
                ", chargeAmount='" + chargeAmount + '\'' +
                ", permitNumber='" + permitNumber + '\'' +
                ", permitType='" + permitType + '\'' +
                ", permitStatus='" + permitStatus + '\'' +
                ", issuedDate=" + issuedDate +
                ", effectiveDate=" + effectiveDate +
                ", expirationDate=" + expirationDate +
                ", milestones=" + milestones +
                ", formData=" + formData +
                ", formLists=" + formLists +
                '}';
    }
}