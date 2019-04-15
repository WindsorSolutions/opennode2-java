package com.windsor.node.plugin.rcra57.solicit.request;

import com.windsor.node.plugin.rcra57.domain.HazardousWasteEmanifestsDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteReportUnivDataType;
import com.windsor.node.plugin.rcra57.domain.ManifestHandlerSiteDataType;

import javax.persistence.EntityManager;

public enum DbInfo {

    CA("CA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from HazardousWasteCorrectiveActionDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    CE("CE", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from HazardousWasteCMESubmissionDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }
            ),
    FA("FA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from FinancialAssuranceFacilitySubmissionDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    GS("GS", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from GeographicInformationSubmissionDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    HD("HD", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from HazardousWasteHandlerSubmissionDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    PM("PM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from HazardousWastePermitDataType t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    CH("CH", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from " + HazardousWasteReportUnivDataType.class.getName() + " t where 1=1").getResultList()) {
                em.remove(x);
            }
        }
    }),
    EM("EM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            for (Object x : em.createQuery("select t from " + HazardousWasteEmanifestsDataType.class.getName() + " t where 1=1").getResultList()) {
                em.remove(x);
            }
            for (Object x : em.createQuery("select t from " + ManifestHandlerSiteDataType.class.getName() + " t where 1=1").getResultList()) {
                em.remove(x);
            }
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
