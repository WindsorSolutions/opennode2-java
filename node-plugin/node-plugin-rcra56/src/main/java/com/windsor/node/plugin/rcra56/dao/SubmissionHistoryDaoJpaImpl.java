package com.windsor.node.plugin.rcra56.dao;

import javax.persistence.EntityManager;

public class SubmissionHistoryDaoJpaImpl extends AbstractDaoJpaImpl implements SubmissionHistoryDao {

	public SubmissionHistoryDaoJpaImpl(EntityManager entityManager) {
		super(entityManager);
	}
	
}
