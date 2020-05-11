package com.windsor.node.plugin.rcra58.solicit.request;

import javax.persistence.EntityManager;

public interface ParentFactory {
    Object createParent(EntityManager em);
}
