package com.windsor.node.plugin.attains.dao;

import javax.persistence.EntityManager;

/**
 * Provides an abstract DAO implementation that concrete DAO implementations may extend
 */
public class AbstractDaoJpaImpl {

    private EntityManager entityManager;

    public AbstractDaoJpaImpl(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    protected EntityManager getEntityManager() {
        return entityManager;
    }
}
