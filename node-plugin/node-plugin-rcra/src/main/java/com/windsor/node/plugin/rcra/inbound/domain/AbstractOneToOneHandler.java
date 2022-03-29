package com.windsor.node.plugin.rcra.inbound.domain;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.xml.bind.annotation.XmlTransient;

@MappedSuperclass
public abstract class AbstractOneToOneHandler {

    @XmlTransient
    private HandlerDataType handler;

    public AbstractOneToOneHandler() {
        super();
    }

    @ManyToOne
    @JoinColumn(name = "HD_HANDLER_ID", nullable = false)
    public HandlerDataType getHandler() {
        return handler;
    }

    public void setHandler(HandlerDataType handler) {
        this.handler = handler;
    }
}
