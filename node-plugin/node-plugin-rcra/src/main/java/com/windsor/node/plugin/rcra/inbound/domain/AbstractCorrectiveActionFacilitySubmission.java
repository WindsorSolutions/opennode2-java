package com.windsor.node.plugin.rcra.inbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractCorrectiveActionFacilitySubmission {

    private HazardousWasteCorrectiveActionDataType parent;

    @ManyToOne
    @JoinColumn(name = "CA_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWasteCorrectiveActionDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWasteCorrectiveActionDataType parent) {
        this.parent = parent;
    }


}
