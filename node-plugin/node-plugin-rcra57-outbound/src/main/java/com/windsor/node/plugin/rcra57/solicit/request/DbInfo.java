package com.windsor.node.plugin.rcra57.solicit.request;

import com.windsor.node.plugin.rcra57.domain.CMEFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.CorrectiveActionFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.EmanifestDataType;
import com.windsor.node.plugin.rcra57.domain.FacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.FinancialAssuranceFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.GISFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteEmanifestsDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra57.domain.HazardousWasteReportUnivDataType;
import com.windsor.node.plugin.rcra57.domain.PermitFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra57.domain.ReportUnivDataType;
import com.windsor.node.plugin.rcra57.domain.ReportUnivsDataType;

import javax.persistence.EntityManager;

public enum DbInfo {

    CA("CA", "CorrectiveActionFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWasteCorrectiveActionDataType parent = new HazardousWasteCorrectiveActionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    HazardousWasteCorrectiveActionDataType p = (HazardousWasteCorrectiveActionDataType) parent;
                    CorrectiveActionFacilitySubmissionDataType e = (CorrectiveActionFacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteCorrectiveActionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    CE("CE", "CMEFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWasteCMESubmissionDataType parent = new HazardousWasteCMESubmissionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    HazardousWasteCMESubmissionDataType p = (HazardousWasteCMESubmissionDataType) parent;
                    CMEFacilitySubmissionDataType e = (CMEFacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + HazardousWasteCMESubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }
    ),
    FA("FA", "FinancialAssuranceFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    FinancialAssuranceSubmissionDataType parent = new FinancialAssuranceSubmissionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    FinancialAssuranceSubmissionDataType p = (FinancialAssuranceSubmissionDataType) parent;
                    FinancialAssuranceFacilitySubmissionDataType e = (FinancialAssuranceFacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + FinancialAssuranceSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    GS("GS", "GISFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    GeographicInformationSubmissionDataType parent = new GeographicInformationSubmissionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    GeographicInformationSubmissionDataType p = (GeographicInformationSubmissionDataType) parent;
                    GISFacilitySubmissionDataType e = (GISFacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
        @Override
        public void cleanup(EntityManager em) {
            em.createQuery("delete from " + GeographicInformationSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
        }
    }),
    HD("HD", "FacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWasteHandlerSubmissionDataType parent = new HazardousWasteHandlerSubmissionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    HazardousWasteHandlerSubmissionDataType p = (HazardousWasteHandlerSubmissionDataType) parent;
                    FacilitySubmissionDataType e = (FacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteHandlerSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            }),
    PM("PM", "PermitFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWastePermitDataType parent = new HazardousWastePermitDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    HazardousWastePermitDataType p = (HazardousWastePermitDataType) parent;
                    PermitFacilitySubmissionDataType e = (PermitFacilitySubmissionDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWastePermitDataType.class.getName() + " where 1=1").executeUpdate();
                }
            }),
    CH("CH", "ReportUniv",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWasteReportUnivDataType p = new HazardousWasteReportUnivDataType();
                    em.persist(p);
                    ReportUnivsDataType ru = new ReportUnivsDataType();
                    ru.setParent(p);
                    em.persist(ru);
                    return ru;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    ReportUnivsDataType p = (ReportUnivsDataType) parent;
                    ReportUnivDataType e = (ReportUnivDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteReportUnivDataType.class.getName() + " where 1=1").executeUpdate();
                }
            }),
    EM("EM", "Emanifest",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    HazardousWasteEmanifestsDataType parent = new HazardousWasteEmanifestsDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public void prePersist(Object element, Object parent) {
                    HazardousWasteEmanifestsDataType p = (HazardousWasteEmanifestsDataType) parent;
                    EmanifestDataType e = (EmanifestDataType) element;
                    e.setParent(p);
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteEmanifestsDataType.class.getName() + " where 1=1").executeUpdate();
                }
            });

    private String type;
    private String xmlElementName;
    private ParentFactory parentFactory;
    private ElementPrePersistHandler prePersistHandler;
    private CleanupHandler cleanupHandler;

    DbInfo(String type, String xmlElementName, ParentFactory parentFactory,
           ElementPrePersistHandler prePersistHandler, CleanupHandler cleanupHandler) {
        this.type = type;
        this.xmlElementName = xmlElementName;
        this.parentFactory = parentFactory;
        this.prePersistHandler = prePersistHandler;
        this.cleanupHandler = cleanupHandler;
    }

    public String getType() {
        return type;
    }

    public CleanupHandler getCleanupHandler() {
        return cleanupHandler;
    }

    public String getXmlElementName() {
        return xmlElementName;
    }

    public ParentFactory getParentFactory() {
        return parentFactory;
    }

    public ElementPrePersistHandler getPrePersistHandler() {
        return prePersistHandler;
    }
}
