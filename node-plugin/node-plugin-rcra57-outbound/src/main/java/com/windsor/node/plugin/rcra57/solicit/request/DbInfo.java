package com.windsor.node.plugin.rcra57.solicit.request;

import com.windsor.node.plugin.rcra57.domain.HazardousWasteEmanifestsDataType;
import com.windsor.node.plugin.rcra57.domain.ManifestHandlerSiteDataType;

import javax.persistence.EntityManager;
import java.util.List;
import java.util.function.Consumer;

public enum DbInfo {

    CA("CA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from HazardousWasteCorrectiveActionDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    CE("CE", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from HazardousWasteCMESubmissionDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }
            ),
    FA("FA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from FinancialAssuranceFacilitySubmissionDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    GS("GS", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from GeographicInformationSubmissionDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    HD("HD", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from HazardousWasteHandlerSubmissionDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    PM("PM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from HazardousWastePermitDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    CH("CH", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from ReportUnivDataType t where t.id > 0").getResultList();
            em.remove(entities);
        }
    }),
    EM("EM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            List<?> entities = em.createQuery("select t from " + HazardousWasteEmanifestsDataType.class.getName() + " t where t.id > 0").getResultList();
            em.remove(entities);
            entities = em.createQuery("select t from " + ManifestHandlerSiteDataType.class.getName() + " t where t.id > 0").getResultList();
            em.remove(entities);
        }
    });

    private String type;
    private CleanupHandler cleanupHandler;

    DbInfo(String type, CleanupHandler cleanupHandler) {
        this.type = type;
        this.cleanupHandler = cleanupHandler;
    }

    public String getType() {
        return type;
    }

    public CleanupHandler getCleanupHandler() {
        return cleanupHandler;
    }

}
