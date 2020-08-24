package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractFacilitySubmission {

    private HazardousWasteHandlerSubmissionDataType parent;

    @ManyToOne
    @JoinColumn(name = "HD_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWasteHandlerSubmissionDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWasteHandlerSubmissionDataType parent) {
        this.parent = parent;
    }


}
