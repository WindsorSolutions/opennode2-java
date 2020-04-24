package com.windsor.node.plugin.rcra57.solicit.request;

import javax.persistence.EntityManager;

public interface CleanupHandler {
    void cleanup(EntityManager em);
}
