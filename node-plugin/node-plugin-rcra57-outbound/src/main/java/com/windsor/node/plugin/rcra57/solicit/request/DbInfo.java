package com.windsor.node.plugin.rcra57.solicit.request;

import com.windsor.node.plugin.rcra57.domain.FinancialAssuranceFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteEmanifestsDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteReportUnivDataType;

import javax.persistence.EntityManager;

public enum DbInfo {

    CA("CA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteCorrectiveActionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    CE("CE", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteCMESubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }
            ),
    FA("FA", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + FinancialAssuranceFacilitySubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    GS("GS", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + GeographicInformationSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    HD("HD", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from "  + HazardousWasteHandlerSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    PM("PM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWastePermitDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    CH("CH", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteReportUnivDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    EM("EM", new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteEmanifestsDataType.class.getName() + " where 1=1").executeUpdate();
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
