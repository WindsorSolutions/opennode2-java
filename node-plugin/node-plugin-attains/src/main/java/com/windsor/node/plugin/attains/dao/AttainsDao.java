package com.windsor.node.plugin.attains.dao;

import com.windsor.node.plugin.attains.domain.OrganizationDataType;

/**
 * Provides an interface for the ATTAINS DAO implementation.
 */
public interface AttainsDao {

    void callStoredProcedure(String storedProcedure);

    OrganizationDataType getRoot();
}
