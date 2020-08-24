package com.windsor.node.plugin.rcra.inbound.dao;

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
