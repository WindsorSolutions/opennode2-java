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

    @Transient
    public abstract StateWideAssessmentsDataType getStateWideAssessments();

    @Transient
    public abstract void setStateWideAssessments(StateWideAssessmentsDataType value);

    public void nullStateWideAssessmentsDataType() {
        StateWideAssessmentsDataType assessments = getStateWideAssessments();
        if (assessments != null && (assessments.getStateWideAssessment() == null || assessments.getStateWideAssessment().size() == 0)) {
            setStateWideAssessments(null);
        }
    }

    @Transient
    public abstract DelistedWatersDataType getDelistedWaters();

    @Transient
    public abstract void setDelistedWaters(DelistedWatersDataType value);

    public void nullDelistedWaters() {
        DelistedWatersDataType waters = getDelistedWaters();
        if (waters != null && (waters.getDelistedWater() == null || waters.getDelistedWater().size() == 0)) {
            setDelistedWaters(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullDocuments();
        nullReportingCycles();
        nullStateWideAssessmentsDataType();
        nullDelistedWaters();
    }
}
