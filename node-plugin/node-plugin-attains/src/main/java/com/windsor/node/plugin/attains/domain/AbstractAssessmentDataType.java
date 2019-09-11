package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractAssessmentDataType {

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
    public abstract ProbableSourcesDataType getProbableSources();

    @Transient
    public abstract void setProbableSources(ProbableSourcesDataType value);

    public void nullProbableSources() {
        ProbableSourcesDataType sources = getProbableSources();
        if (sources != null && (sources.getProbableSource() == null || sources.getProbableSource().size() == 0)) {
            setProbableSources(null);
        }
    }

    @Transient
    public abstract ReviewCommentsDataType getReviewComments();

    @Transient
    public abstract void setReviewComments(ReviewCommentsDataType value);

    public void nullReviewComments() {
        ReviewCommentsDataType comments = getReviewComments();
        if (comments != null && (comments.getReviewComment() == null || comments.getReviewComment().size() == 0)) {
            setReviewComments(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullDocuments();
        nullProbableSources();
        nullReviewComments();
    }
}
