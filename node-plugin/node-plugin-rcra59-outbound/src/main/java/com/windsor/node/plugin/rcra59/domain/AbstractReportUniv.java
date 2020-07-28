package com.windsor.node.plugin.rcra59.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

@MappedSuperclass
public class AbstractReportUniv {

    private ReportUnivsDataType parent;

    @ManyToOne
    @JoinColumn(name = "RU_REPORT_UNIV_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public ReportUnivsDataType getParent() {
        return parent;
    }

    public void setParent(ReportUnivsDataType parent) {
        this.parent = parent;
    }

}
