package com.windsor.node.plugin.rcra.outbound.solicit.request;

import javax.persistence.EntityManager;

public interface ParentFactory {
    Object createParent(EntityManager em);
}
