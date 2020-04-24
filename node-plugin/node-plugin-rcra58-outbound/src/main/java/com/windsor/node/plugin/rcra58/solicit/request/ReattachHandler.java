package com.windsor.node.plugin.rcra58.solicit.request;

import javax.persistence.EntityManager;

public interface ReattachHandler {
    Object reattach(EntityManager em, Object obj);
}
