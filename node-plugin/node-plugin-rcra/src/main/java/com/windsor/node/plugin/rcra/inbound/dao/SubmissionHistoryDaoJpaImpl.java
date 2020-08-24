package com.windsor.node.plugin.rcra.inbound.dao;

import javax.persistence.EntityManager;

public class SubmissionHistoryDaoJpaImpl extends AbstractDaoJpaImpl implements SubmissionHistoryDao {

	public SubmissionHistoryDaoJpaImpl(EntityManager entityManager) {
		super(entityManager);
	}
	
}
