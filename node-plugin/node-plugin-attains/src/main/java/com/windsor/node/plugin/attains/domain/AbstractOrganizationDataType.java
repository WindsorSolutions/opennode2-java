package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractOrganizationDataType {

    @Transient
    public abstract ActionsDataType getActions();

    @Transient
    public abstract void setActions(ActionsDataType value);

    public void nullActions() {
        ActionsDataType actions = getActions();
        if (actions == null || actions.getAction() == null || actions.getAction().size() == 0) {
            setActions(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullActions();
    }
}
