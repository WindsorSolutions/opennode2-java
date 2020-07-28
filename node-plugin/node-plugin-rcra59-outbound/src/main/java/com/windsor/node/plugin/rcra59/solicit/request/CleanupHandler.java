package com.windsor.node.plugin.rcra59.solicit.request;

import javax.persistence.EntityManager;

public interface CleanupHandler {
    void cleanup(EntityManager em);
}
