package com.windsor.node.plugin.attains.dao;

import com.windsor.node.data.dao.TransactionDao;
import com.windsor.node.plugin.attains.domain.OrganizationDataType;

import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.StoredProcedureQuery;

public class AttainsDaoImpl extends AbstractDaoJpaImpl implements AttainsDao {

    private TransactionDao transactionDao;

    public AttainsDaoImpl(EntityManager entityManager, TransactionDao transactionDao) {
        super(entityManager);
        this.transactionDao = transactionDao;
    }

    @Override
    public void callStoredProcedure(String storedProcedure) {
        EntityTransaction tx = getEntityManager().getTransaction();
        try {
            tx.begin();
            StoredProcedureQuery query = getEntityManager().createStoredProcedureQuery(storedProcedure);
            query.execute();
            tx.commit();
        } catch (Exception e) {
            tx.rollback();
            throw new RuntimeException("Error calling stored procedure '" + storedProcedure + "'", e);
        }
    }

    @Override
    public OrganizationDataType getRoot() {
        return getEntityManager().createQuery("select x from OrganizationDataType x", OrganizationDataType.class)
                .getSingleResult();
    }
}
