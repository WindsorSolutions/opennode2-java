package com.windsor.node.plugin.rcra.outbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractEmanifest {

    private HazardousWasteEmanifestsDataType parent;

    @Transient
    public abstract RejectionInfoDataType getRejectionInfo();

    public AbstractEmanifest() {
        super();
    }

    @ManyToOne
    @JoinColumn(name = "EM_SUBM_ID", insertable = true, updatable = false, nullable = false)
    public HazardousWasteEmanifestsDataType getParent() {
        return parent;
    }

    public void setParent(HazardousWasteEmanifestsDataType parent) {
        this.parent = parent;
    }
}
