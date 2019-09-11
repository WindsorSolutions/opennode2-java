package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractParameterDataType {

    @Transient
    public abstract AssociatedActionsDataType getAssociatedActions();

    @Transient
    public abstract void setAssociatedActions(AssociatedActionsDataType value);

    public void nullAssociatedActions() {
        AssociatedActionsDataType actions = getAssociatedActions();
        if (actions == null || actions.getAssociatedAction() == null || actions.getAssociatedAction().size() == 0) {
            setAssociatedActions(null);
        }
    }

    @Transient
    public abstract ImpairedWatersInformationDataType getImpairedWatersInformation();

    @Transient
    public abstract void setImpairedWatersInformation(ImpairedWatersInformationDataType value);

    public void nullImpairedWatersInformation() {
        ImpairedWatersInformationDataType waters = getImpairedWatersInformation();
        if (waters != null) {
            if (waters.getPriorCauses() == null || waters.getPriorCauses().getPriorCause() == null
                    || waters.getPriorCauses().getPriorCause().size() == 0) {
                waters.setPriorCauses(null);
            }
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullAssociatedActions();
        nullImpairedWatersInformation();
    }
}