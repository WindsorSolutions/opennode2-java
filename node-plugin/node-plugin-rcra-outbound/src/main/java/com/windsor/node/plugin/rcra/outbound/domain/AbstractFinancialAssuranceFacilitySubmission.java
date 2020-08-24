package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractFinancialAssuranceFacilitySubmission {

    private FinancialAssuranceSubmissionDataType parent;

    @ManyToOne
    @JoinColumn(name = "FA_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public FinancialAssuranceSubmissionDataType getParent() {
        return parent;
    }

    public void setParent(FinancialAssuranceSubmissionDataType parent) {
        this.parent = parent;
    }


}
