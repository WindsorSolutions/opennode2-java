package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractAssessmentUnitDataType {

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

    @PostLoad
    public void handlePostLoad() {
        nullDocuments();
    }
}
