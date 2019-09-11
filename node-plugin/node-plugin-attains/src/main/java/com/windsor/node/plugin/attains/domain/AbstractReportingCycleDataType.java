package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractReportingCycleDataType {

    @Transient
    public abstract DocumentsDataType getDocuments();

    @Transient
    public abstract void setDocuments(DocumentsDataType value);

    public void nullDocuments() {
        DocumentsDataType documents = getDocuments();
        if (documents != null && (documents.getDocument() == null || documents.getDocument().size() == 0)) {
            setDocuments(null);
        }
    }

    @Transient
    public abstract CombinedCyclesDataType getCombinedCycles();

    @Transient
    public abstract void setCombinedCycles(CombinedCyclesDataType value);

    public void nullReportingCycles() {
         CombinedCyclesDataType cycles = getCombinedCycles();
        if (cycles != null && (cycles.getCombinedCycle() == null || cycles.getCombinedCycle().size() == 0)) {
            setCombinedCycles(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullDocuments();
        nullReportingCycles();
    }
}
