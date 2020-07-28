package com.windsor.node.plugin.rcra59.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractCMEFacilitySubmission {

    private HazardousWasteCMESubmissionDataType parent;

    @ManyToOne
    @JoinColumn(name = "CME_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWasteCMESubmissionDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWasteCMESubmissionDataType parent) {
        this.parent = parent;
    }


}
