package com.windsor.node.plugin.rcra58.domain;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "RCRA_CME_SUBM_DEL")
public class CMEDeleteSubmissionDataType {

    private String dbid;
    private List<CMEFacilitySubmissionDeleteDataType> cmeFacilitySubmissionDeletes;

    @Id
    @Column(name = "CME_SUBM_DEL_ID")
    @GeneratedValue(generator = "UUID", strategy = GenerationType.AUTO)
    public String getDbid() {
        return dbid;
    }

    public void setDbid(String value) {
        this.dbid = value;
    }

    @OneToMany(targetEntity = CMEFacilitySubmissionDeleteDataType.class, cascade =  CascadeType.ALL)
    @JoinColumn(name = "CME_SUBM_DEL_ID", insertable = false, updatable = false)
    public List<CMEFacilitySubmissionDeleteDataType> getCMEFacilitySubmissionDeletes() {
        if (cmeFacilitySubmissionDeletes == null) {
            cmeFacilitySubmissionDeletes = new ArrayList<CMEFacilitySubmissionDeleteDataType>();
        }
        return this.cmeFacilitySubmissionDeletes;
    }

    public void setCMEFacilitySubmissionDeletes(List<CMEFacilitySubmissionDeleteDataType> cmeFacilitySubmission) {
        this.cmeFacilitySubmissionDeletes = cmeFacilitySubmission;
    }

}
