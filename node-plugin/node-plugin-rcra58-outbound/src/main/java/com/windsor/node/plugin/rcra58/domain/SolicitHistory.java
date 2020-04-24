package com.windsor.node.plugin.rcra58.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Models the history for a RCRA Info solicit operation.
 */
@Entity(name = "SolicitHistory")
@Table(name = "RCRA_SUBMISSIONHISTORY")
public class SolicitHistory {

    public enum Status {
        PENDING("PENDING"),
        COMPLETE("COMPLETE"),
        FAILED("FAILED");

        private String name;

        Status(String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }
    }

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Id
    @Column(name = "SUBMISSIONHISTORY_ID")
    @GeneratedValue(generator = "UUID")
    private String dbid;

    @Basic
    @Column(name = "SCHEDULERUNDATE")
    @Temporal(TemporalType.DATE)
    private Date runDate;

    @Basic
    @Column(name = "TRANSACTIONID")
    private String transactionId;

    @Basic
    @Column(name = "PROCESSINGSTATUS")
    private String status;

    @Basic
    @Column(name = "SUBMISSIONTYPE")
    private String solicitType;

    public SolicitHistory() {
        super();
    }

    public SolicitHistory(String transactionId, String solicitType) {
        this.runDate = new Date();
        this.transactionId = transactionId;
        this.solicitType = solicitType;
        this.status = Status.PENDING.getName();
    }

    public String getDbid() {
        return dbid;
    }

    public void setDbid(String dbid) {
        this.dbid = dbid;
    }

    public Date getRunDate() {
        return runDate;
    }

    public String getRunDateFormatted() {
        String result = null;

        if(runDate != null) {
            result = dateFormat.format(runDate);
        }

        return result;
    }

    public void setRunDate(Date runDate) {
        this.runDate = runDate;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setStatus(Status status) {
        this.status = status.getName();
    }

    public String getSolicitType() {
        return solicitType;
    }

    public void setSolicitType(String solicitType) {
        this.solicitType = solicitType;
    }

//    @PrePersist
//    public void setId() {
//        if (id == null) {
//            id = UUID.randomUUID().toString();
//        }
//    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        SolicitHistory that = (SolicitHistory) o;

        if (dbid != null ? !dbid.equals(that.dbid) : that.dbid != null) return false;
        if (runDate != null ? !runDate.equals(that.runDate) : that.runDate != null) return false;
        if (transactionId != null ? !transactionId.equals(that.transactionId) : that.transactionId != null)
            return false;
        if (status != null ? !status.equals(that.status) : that.status != null) return false;
        return solicitType != null ? solicitType.equals(that.solicitType) : that.solicitType == null;

    }

    @Override
    public int hashCode() {
        int result = dbid != null ? dbid.hashCode() : 0;
        result = 31 * result + (runDate != null ? runDate.hashCode() : 0);
        result = 31 * result + (transactionId != null ? transactionId.hashCode() : 0);
        result = 31 * result + (status != null ? status.hashCode() : 0);
        result = 31 * result + (solicitType != null ? solicitType.hashCode() : 0);
        return result;
    }
}
