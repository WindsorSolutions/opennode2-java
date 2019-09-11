package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractImpairedWatersDataType {

    @Transient
    public abstract PriorCausesDataType getPriorCauses();

    @Transient
    public abstract void setPriorCauses(PriorCausesDataType value);

    public void nullPriorCauses() {
        PriorCausesDataType priorCauses = getPriorCauses();
        if (priorCauses == null || priorCauses.getPriorCause() == null || priorCauses.getPriorCause().size() == 0) {
            setPriorCauses(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullPriorCauses();
    }
}