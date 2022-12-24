package com.windsor.node.plugin.rcra.outbound.solicit.request;

import com.windsor.node.plugin.rcra.outbound.domain.HazardousWasteCMESubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.HazardousWasteCorrectiveActionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.HazardousWasteEmanifestsDataType;
import com.windsor.node.plugin.rcra.outbound.domain.HazardousWasteHandlerSubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.HazardousWastePermitDataType;
import com.windsor.node.plugin.rcra.outbound.domain.HazardousWasteReportUnivDataType;
import com.windsor.node.plugin.rcra.outbound.domain.PermitFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.ReportUnivDataType;
import com.windsor.node.plugin.rcra.outbound.domain.ReportUnivsDataType;
import com.windsor.node.plugin.rcra.outbound.domain.CMEFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.CorrectiveActionFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.EmanifestDataType;
import com.windsor.node.plugin.rcra.outbound.domain.FacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.FinancialAssuranceFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.FinancialAssuranceSubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.GISFacilitySubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.GeographicInformationSubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.CMEDeleteSubmissionDataType;
import com.windsor.node.plugin.rcra.outbound.domain.CMEFacilitySubmissionDeleteDataType;

import javax.persistence.EntityManager;
import java.util.List;

import static java.util.Arrays.asList;

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
                public Object prePersist(Object element, Object parent) {
                    HazardousWasteCorrectiveActionDataType p = (HazardousWasteCorrectiveActionDataType) parent;
                    CorrectiveActionFacilitySubmissionDataType e = (CorrectiveActionFacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteCorrectiveActionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    HazardousWasteCorrectiveActionDataType x = (HazardousWasteCorrectiveActionDataType) obj;
                    return em.find(HazardousWasteCorrectiveActionDataType.class, x.getDbid());
                }
            },
            asList("RCRA_CA_AREA", "RCRA_CA_AREA_REL_EVENT", "RCRA_CA_AUTH_REL_EVENT", "RCRA_CA_AUTHORITY",
                    "RCRA_CA_EVENT", "RCRA_CA_EVENT_COMMITMENT", "RCRA_CA_FAC_SUBM", "RCRA_CA_REL_PERMIT_UNIT",
                    "RCRA_CA_STATUTORY_CITATION", "RCRA_CA_SUBM")
    ),
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
                public Object prePersist(Object element, Object parent) {
                    HazardousWasteCMESubmissionDataType p = (HazardousWasteCMESubmissionDataType) parent;
                    CMEFacilitySubmissionDataType e = (CMEFacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteCMESubmissionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    HazardousWasteCMESubmissionDataType x = (HazardousWasteCMESubmissionDataType) obj;
                    return em.find(HazardousWasteCMESubmissionDataType.class, x.getDbid());
                }
            },
            asList("RCRA_CME_CITATION", "RCRA_CME_CSNY_DATE", "RCRA_CME_ENFRC_ACT", "RCRA_CME_EVAL",
                    "RCRA_CME_EVAL_COMMIT", "RCRA_CME_EVAL_VIOL", "RCRA_CME_FAC_SUBM", "RCRA_CME_MEDIA",
                    "RCRA_CME_MILESTONE", "RCRA_CME_PNLTY", "RCRA_CME_PYMT", "RCRA_CME_RQST", "RCRA_CME_SUBM",
                    "RCRA_CME_SUPP_ENVR_PRJT", "RCRA_CME_VIOL", "RCRA_CME_VIOL_ENFRC")
    ),
    CE_DELETE("CD", "CMEFacilitySubmission",
            new ParentFactory() {
                @Override
                public Object createParent(EntityManager em) {
                    CMEDeleteSubmissionDataType parent = new CMEDeleteSubmissionDataType();
                    em.persist(parent);
                    return parent;
                }
            },
            new ElementPrePersistHandler() {
                @Override
                public Object prePersist(Object element, Object parent) {
                    CMEDeleteSubmissionDataType p = (CMEDeleteSubmissionDataType) parent;
                    CMEFacilitySubmissionDataType e = (CMEFacilitySubmissionDataType) element;
                    CMEFacilitySubmissionDeleteDataType delete = CMEFacilitySubmissionDeleteDataType
                            .convertFromXml(e, p);
                    delete.setParent(p);
                    return delete;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + CMEFacilitySubmissionDeleteDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    CMEFacilitySubmissionDeleteDataType x = (CMEFacilitySubmissionDeleteDataType) obj;
                    return em.find(CMEFacilitySubmissionDeleteDataType.class, x.getDbid());
                }
            },
            asList("RCRA_CME_ENFRC_ACT_DEL", "RCRA_CME_EVAL_DEL", "RCRA_CME_FAC_SUBM_DEL", "RCRA_CME_VIOL_DEL",
                    "RCRA_CME_SUBM_DEL")
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
                public Object prePersist(Object element, Object parent) {
                    FinancialAssuranceSubmissionDataType p = (FinancialAssuranceSubmissionDataType) parent;
                    FinancialAssuranceFacilitySubmissionDataType e = (FinancialAssuranceFacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + FinancialAssuranceSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    FinancialAssuranceSubmissionDataType x = (FinancialAssuranceSubmissionDataType) obj;
                    return em.find(FinancialAssuranceSubmissionDataType.class, x.getDbid());
                }
            },
            asList("RCRA_FA_COST_EST", "RCRA_FA_COST_EST_REL_MECHANISM", "RCRA_FA_FAC_SUBM", "RCRA_FA_MECHANISM",
                    "RCRA_FA_MECHANISM_DETAIL", "RCRA_FA_SUBM")
    ),
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
                public Object prePersist(Object element, Object parent) {
                    GeographicInformationSubmissionDataType p = (GeographicInformationSubmissionDataType) parent;
                    GISFacilitySubmissionDataType e = (GISFacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + GeographicInformationSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    GeographicInformationSubmissionDataType x = (GeographicInformationSubmissionDataType) obj;
                    return em.find(GeographicInformationSubmissionDataType.class, x.getDbid());
                }
            },
            asList("RCRA_GIS_FAC_SUBM", "RCRA_GIS_GEO_INFORMATION", "RCRA_GIS_SUBM")
    ),
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
                public Object prePersist(Object element, Object parent) {
                    HazardousWasteHandlerSubmissionDataType p = (HazardousWasteHandlerSubmissionDataType) parent;
                    FacilitySubmissionDataType e = (FacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteHandlerSubmissionDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    HazardousWasteHandlerSubmissionDataType x = (HazardousWasteHandlerSubmissionDataType) obj;
                    return em.find(HazardousWasteHandlerSubmissionDataType.class, x.getDbid());
                }
            },
            asList("RCRA_HD_CERTIFICATION", "RCRA_HD_ENV_PERMIT", "RCRA_HD_EPISODIC_EVENT", "RCRA_HD_EPISODIC_PRJT",
                    "RCRA_HD_EPISODIC_WASTE", "RCRA_HD_EPISODIC_WASTE_CODE", "RCRA_HD_HANDLER", "RCRA_HD_HBASIC",
                    "RCRA_HD_LQG_CLOSURE","RCRA_HD_LQG_CONSOLIDATION", "RCRA_HD_NAICS", "RCRA_HD_OTHER_ID",
                    "RCRA_HD_OWNEROP", "RCRA_HD_SEC_MATERIAL_ACTIVITY", "RCRA_HD_SEC_WASTE_CODE",
                    "RCRA_HD_STATE_ACTIVITY", "RCRA_HD_SUBM", "RCRA_HD_UNIVERSAL_WASTE", "RCRA_HD_WASTE_CODE")),
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
                public Object prePersist(Object element, Object parent) {
                    HazardousWastePermitDataType p = (HazardousWastePermitDataType) parent;
                    PermitFacilitySubmissionDataType e = (PermitFacilitySubmissionDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWastePermitDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    HazardousWastePermitDataType x = (HazardousWastePermitDataType) obj;
                    return em.find(HazardousWastePermitDataType.class, x.getDbid());
                }
            },
            asList("RCRA_PRM_EVENT", "RCRA_PRM_EVENT_COMMITMENT", "RCRA_PRM_FAC_SUBM", "RCRA_PRM_RELATED_EVENT",
                    "RCRA_PRM_SERIES", "RCRA_PRM_SUBM", "RCRA_PRM_MOD_EVENT", "RCRA_PRM_UNIT", "RCRA_PRM_UNIT_DETAIL",
                    "RCRA_PRM_WASTE_CODE")),
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
                public Object prePersist(Object element, Object parent) {
                    ReportUnivsDataType p = (ReportUnivsDataType) parent;
                    ReportUnivDataType e = (ReportUnivDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteReportUnivDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    ReportUnivsDataType x = (ReportUnivsDataType) obj;
                    return em.find(ReportUnivsDataType.class, x.getDbid());
                }
            },
            asList("RCRA_RU_REPORT_UNIV", "RCRA_RU_REPORT_UNIV_SUBM", "RCRA_RU_SUBM")),
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
                public Object prePersist(Object element, Object parent) {
                    HazardousWasteEmanifestsDataType p = (HazardousWasteEmanifestsDataType) parent;
                    EmanifestDataType e = (EmanifestDataType) element;
                    e.setParent(p);
                    return e;
                }
            },
            new CleanupHandler() {
                @Override
                public void cleanup(EntityManager em) {
                    em.createQuery("delete from " + HazardousWasteEmanifestsDataType.class.getName() + " where 1=1").executeUpdate();
                }
            },
            new ReattachHandler() {
                @Override
                public Object reattach(EntityManager em, Object obj) {
                    HazardousWasteEmanifestsDataType x = (HazardousWasteEmanifestsDataType) obj;
                    return em.find(HazardousWasteEmanifestsDataType.class, x.getDbid());
                }
            },
            asList("RCRA_EM_EMANIFEST", "RCRA_EM_EMANIFEST_COMMENT",
                    "RCRA_EM_FED_WASTE_CODE_DESC", "RCRA_EM_STATE_WASTE_CODE_DESC",
                    "RCRA_EM_SUBM", "RCRA_EM_TRANSPORTER", "RCRA_EM_WASTE",
                    "RCRA_EM_WASTE_CD_TRANS", "RCRA_EM_WASTE_COMMENT", "RCRA_EM_WASTE_PCB")
    );

    private String type;
    private String xmlElementName;
    private ParentFactory parentFactory;
    private ElementPrePersistHandler prePersistHandler;
    private CleanupHandler cleanupHandler;
    private ReattachHandler reattachHandler;
    private List<String> tableNames;

    DbInfo(String type, String xmlElementName, ParentFactory parentFactory,
           ElementPrePersistHandler prePersistHandler, CleanupHandler cleanupHandler, ReattachHandler reattachHandler,
           List<String> tableNames) {
        this.type = type;
        this.xmlElementName = xmlElementName;
        this.parentFactory = parentFactory;
        this.prePersistHandler = prePersistHandler;
        this.cleanupHandler = cleanupHandler;
        this.reattachHandler = reattachHandler;
        this.tableNames = tableNames;
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

    public ReattachHandler getReattachHandler() {
        return reattachHandler;
    }

    public List<String> getTableNames() {
        return tableNames;
    }
}
