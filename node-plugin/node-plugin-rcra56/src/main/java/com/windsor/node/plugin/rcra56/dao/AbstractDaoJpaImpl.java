package com.windsor.node.plugin.rcra56.dao;

import javax.persistence.EntityManager;

public abstract class AbstractDaoJpaImpl {

	private EntityManager entityManager;
	
	public AbstractDaoJpaImpl(EntityManager entityManager) {
		this.entityManager = entityManager;
	}

	protected EntityManager getEntityManager() {
		return entityManager;
	}
	
}
