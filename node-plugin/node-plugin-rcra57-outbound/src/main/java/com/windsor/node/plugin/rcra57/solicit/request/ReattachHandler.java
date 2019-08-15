package com.windsor.node.plugin.rcra57.solicit.request;

import javax.persistence.EntityManager;

public interface ReattachHandler {
    Object reattach(EntityManager em, Object obj);
}
