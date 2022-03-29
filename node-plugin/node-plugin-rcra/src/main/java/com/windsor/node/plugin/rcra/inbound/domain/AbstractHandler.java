package com.windsor.node.plugin.rcra.inbound.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractHandler {

    private HazardousWasteEmanifestsDataType parent;

    @Transient
    public abstract HandlerEpisodicEventDataType getHandlerEpisodicEvent();
    @Transient
    public abstract HandlerLqgClosureDataType getHandlerLqgClosure();

    public AbstractHandler() {
        super();
    }

    @PrePersist
    @PreUpdate
    public void handlePrePersist() {
        HandlerEpisodicEventDataType episodicEvent = getHandlerEpisodicEvent();
        if (episodicEvent != null) {
            episodicEvent.setHandler((HandlerDataType) this);
        }
        HandlerLqgClosureDataType lqgClosure = getHandlerLqgClosure();
        if (lqgClosure != null) {
            lqgClosure.setHandler((HandlerDataType)this);
        }
    }
}
