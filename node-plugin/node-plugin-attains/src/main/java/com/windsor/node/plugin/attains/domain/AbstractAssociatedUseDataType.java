package com.windsor.node.plugin.attains.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.Transient;

@MappedSuperclass
public abstract class AbstractAssociatedUseDataType {

    @Transient
    public abstract SeasonsDataType getSeasons();

    @Transient
    public abstract void setSeasons(SeasonsDataType value);

    public void nullSeasons() {
        SeasonsDataType seasons = getSeasons();
        if (seasons == null || seasons.getSeason() == null || seasons.getSeason().size() == 0) {
            setSeasons(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullSeasons();
    }
}
