package com.windsor.node.plugin.rcra59.solicit.request;

import javax.persistence.EntityManager;

public interface ParentFactory {
    Object createParent(EntityManager em);
}
