package com.windsor.node.plugin.rcra.inbound.domain;

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
@Table(name = "RCRA_CME_ENFRC_ACT_DEL")
public class EnforcementActionDeleteDataType {

    private String dbid;
    private String enforcementAgencyLocationName;
    private String enforcementActionIdentifier;
    private Date enforcementActionDate;
    private String enforcementAgencyName;
    private String notes;

    @Id
    @Column(name = "CME_ENFRC_ACT_DEL_ID")
    @GeneratedValue(generator = "UUID", strategy = GenerationType.AUTO)
    public String getDbid() {
        return dbid;
    }

    public void setDbid(String value) {
        this.dbid = value;
    }

    @Basic
    @Column(name = "ENFRC_AGN_LOC_NAME", length = 2)
    public String getEnforcementAgencyLocationName() {
        return enforcementAgencyLocationName;
    }

    public void setEnforcementAgencyLocationName(String value) {
        this.enforcementAgencyLocationName = value;
    }

    @Basic
    @Column(name = "ENFRC_ACT_IDEN", length = 3)
    public String getEnforcementActionIdentifier() {
        return enforcementActionIdentifier;
    }

    public void setEnforcementActionIdentifier(String value) {
        this.enforcementActionIdentifier = value;
    }

    @Basic
    @Column(name = "ENFRC_ACT_DATE")
    @Temporal(TemporalType.DATE)
    public Date getEnforcementActionDate() {
        return enforcementActionDate;
    }

    public void setEnforcementActionDate(Date value) {
        this.enforcementActionDate = value;
    }

    @Basic
    @Column(name = "ENFRC_AGN_NAME", length = 1)
    public String getEnforcementAgencyName() {
        return enforcementAgencyName;
    }

    public void setEnforcementAgencyName(String value) {
        this.enforcementAgencyName = value;
    }

    @Basic
    @Column(name = "NOTES", length = 4000)
    public String getNotes() {
        return notes;
    }

    public void setNotes(String value) {
        this.notes = value;
    }

    public static EnforcementActionDeleteDataType convertEnforcementsFromXml(EnforcementActionDataType source) {
        EnforcementActionDeleteDataType dest = new EnforcementActionDeleteDataType();
        dest.setEnforcementAgencyLocationName(source.getEnforcementAgencyLocationName());
        dest.setEnforcementActionIdentifier(source.getEnforcementActionIdentifier());
        dest.setEnforcementActionDate(source.getEnforcementActionDate());
        dest.setEnforcementAgencyName(source.getEnforcementAgencyName());
        dest.setNotes(source.getNotes());
        return dest;
    }

}
