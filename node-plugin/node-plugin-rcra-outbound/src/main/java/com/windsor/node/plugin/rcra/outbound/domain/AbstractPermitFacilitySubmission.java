package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractPermitFacilitySubmission {

    private HazardousWastePermitDataType parent;

    @ManyToOne
    @JoinColumn(name = "PRM_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWastePermitDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWastePermitDataType parent) {
        this.parent = parent;
    }

}
