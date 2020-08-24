package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.util.Date;

@Entity
@Table(name = "RCRA_CME_EVAL_DEL")
public class EvaluationDeleteDataType {

    private String dbid;
    private String evaluationActivityLocation;
    private String evaluationIdentifier;
    private Date evaluationStartDate;
    private String evaluationResponsibleAgency;
    private String notes;

    @Id
    @Column(name = "CME_EVAL_DEL_ID")
    @GeneratedValue(generator = "UUID", strategy = GenerationType.AUTO)
    public String getDbid() {
        return dbid;
    }

    public void setDbid(String dbid) {
        this.dbid = dbid;
    }

    @Basic
    @Column(name = "EVAL_ACT_LOC", length = 2)
    public String getEvaluationActivityLocation() {
        return evaluationActivityLocation;
    }

    public void setEvaluationActivityLocation(String value) {
        this.evaluationActivityLocation = value;
    }

    @Basic
    @Column(name = "EVAL_IDEN", length = 3)
    public String getEvaluationIdentifier() {
        return evaluationIdentifier;
    }

    public void setEvaluationIdentifier(String value) {
        this.evaluationIdentifier = value;
    }

    @Basic
    @Column(name = "EVAL_START_DATE")
    @Temporal(TemporalType.DATE)
    public Date getEvaluationStartDate() {
        return evaluationStartDate;
    }

    public void setEvaluationStartDate(Date value) {
        this.evaluationStartDate = value;
    }

    @Basic
    @Column(name = "EVAL_RESP_AGN", length = 1)
    public String getEvaluationResponsibleAgency() {
        return evaluationResponsibleAgency;
    }

    public void setEvaluationResponsibleAgency(String value) {
        this.evaluationResponsibleAgency = value;
    }

    @Basic
    @Column(name = "NOTES", length = 4000)
    public String getNotes() {
        return notes;
    }

    public void setNotes(String value) {
        this.notes = value;
    }

    public static EvaluationDeleteDataType convertEvaluationFromXml(EvaluationDataType source) {
        EvaluationDeleteDataType dest = new EvaluationDeleteDataType();
        dest.setEvaluationActivityLocation(source.getEvaluationActivityLocation());
        dest.setEvaluationIdentifier(source.getEvaluationIdentifier());
        dest.setEvaluationResponsibleAgency(source.getEvaluationResponsibleAgency());
        dest.setEvaluationStartDate(source.getEvaluationStartDate());
        dest.setNotes(source.getNotes());
        return dest;
    }

}
