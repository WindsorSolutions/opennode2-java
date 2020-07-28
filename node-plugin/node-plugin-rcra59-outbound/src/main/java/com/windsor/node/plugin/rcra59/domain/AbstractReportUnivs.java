package com.windsor.node.plugin.rcra59.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractReportUnivs {

    private HazardousWasteReportUnivDataType parent;

    @ManyToOne
    @JoinColumn(name = "RU_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWasteReportUnivDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWasteReportUnivDataType parent) {
        this.parent = parent;
    }

}
