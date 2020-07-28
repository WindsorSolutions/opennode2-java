package com.windsor.node.plugin.rcra59.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractGISFacilitySubmission {

    private GeographicInformationSubmissionDataType parent;

    @ManyToOne
    @JoinColumn(name = "GIS_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public GeographicInformationSubmissionDataType getParent() {
        return parent;
    }

    public void setParent(GeographicInformationSubmissionDataType parent) {
        this.parent = parent;
    }


}
