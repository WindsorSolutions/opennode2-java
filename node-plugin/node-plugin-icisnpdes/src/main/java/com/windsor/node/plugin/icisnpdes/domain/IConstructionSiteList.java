package com.windsor.node.plugin.icisnpdes.domain;

import com.windsor.node.plugin.icisnpdes.generated.ConstructionSiteList;

import java.util.List;

/**
 * Defines how to get the list of construction site codes.
 */
public interface IConstructionSiteList {

    /**
     * Returns the list of construction site codes
     * @return list of site codes
     */
    List<String> getConstructionSiteCode();

    void setConstructionSiteOtherText(String value);
}
