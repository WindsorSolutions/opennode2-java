package com.windsor.node.plugin.rcra59.domain;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.List;

import static com.windsor.node.plugin.rcra59.domain.EnforcementActionDeleteDataType.convertEnforcementsFromXml;
import static com.windsor.node.plugin.rcra59.domain.EvaluationDeleteDataType.convertEvaluationFromXml;
import static com.windsor.node.plugin.rcra59.domain.ViolationDeleteDataType.convertViolationFromXml;

@Entity
@Table(name = "RCRA_CME_FAC_SUBM_DEL")
public class CMEFacilitySubmissionDeleteDataType {

    private String dbid;
    private CMEDeleteSubmissionDataType parent;
    private String epaHandlerID;
    private List<EnforcementActionDeleteDataType> enforcementAction;
    private List<EvaluationDeleteDataType> evaluation;
    private List<ViolationDeleteDataType> violation;

    @Id
    @Column(name = "CME_FAC_SUBM_DEL_ID")
    @GeneratedValue(generator = "UUID", strategy = GenerationType.AUTO)
    public String getDbid() {
        return dbid;
    }

    public void setDbid(String value) {
        this.dbid = value;
    }

    @ManyToOne
    @JoinColumn(name = "CME_SUBM_DEL_ID", insertable = true, updatable = false, nullable = false)
    public CMEDeleteSubmissionDataType getParent() {
        return parent;
    }

    public void setParent(CMEDeleteSubmissionDataType parent) {
        this.parent = parent;
    }

    @Basic
    @Column(name = "EPA_HDLR_ID", length = 12)
    public String getEPAHandlerID() {
        return epaHandlerID;
    }

    public void setEPAHandlerID(String value) {
        this.epaHandlerID = value;
    }

    @OneToMany(targetEntity = EnforcementActionDeleteDataType.class, cascade = CascadeType.ALL)
    @JoinColumn(name = "CME_FAC_SUBM_DEL_ID", nullable = false, insertable = true, updatable = false)
    public List<EnforcementActionDeleteDataType> getEnforcementAction() {
        if (enforcementAction == null) {
            enforcementAction = new ArrayList<EnforcementActionDeleteDataType>();
        }
        return this.enforcementAction;
    }

    public void setEnforcementAction(List<EnforcementActionDeleteDataType> enforcementAction) {
        this.enforcementAction = enforcementAction;
    }

    @OneToMany(targetEntity = EvaluationDeleteDataType.class, cascade = CascadeType.ALL)
    @JoinColumn(name = "CME_FAC_SUBM_DEL_ID", nullable = false, insertable = true, updatable = false)
    public List<EvaluationDeleteDataType> getEvaluation() {
        if (evaluation == null) {
            evaluation = new ArrayList<EvaluationDeleteDataType>();
        }
        return this.evaluation;
    }

    public void setEvaluation(List<EvaluationDeleteDataType> evaluation) {
        this.evaluation = evaluation;
    }

    @OneToMany(targetEntity = ViolationDeleteDataType.class, cascade = CascadeType.ALL)
    @JoinColumn(name = "CME_FAC_SUBM_DEL_ID", nullable = false, insertable = true, updatable = false)
    public List<ViolationDeleteDataType> getViolation() {
        if (violation == null) {
            violation = new ArrayList<ViolationDeleteDataType>();
        }
        return this.violation;
    }

    public void setViolation(List<ViolationDeleteDataType> violation) {
        this.violation = violation;
    }

    public static CMEFacilitySubmissionDeleteDataType convertFromXml(CMEFacilitySubmissionDataType source, CMEDeleteSubmissionDataType parent) {
        CMEFacilitySubmissionDeleteDataType dest = new CMEFacilitySubmissionDeleteDataType();
        dest.setParent(parent);
        dest.setEPAHandlerID(source.getEPAHandlerID());
        dest.setEnforcementAction(convertEnforcementActions(source));
        dest.setViolation(convertViolations(source));
        dest.setEvaluation(convertEvaluations(source));
        return dest;
    }

    private static List<EnforcementActionDeleteDataType> convertEnforcementActions(CMEFacilitySubmissionDataType source) {
        List<EnforcementActionDeleteDataType> deletes = null;
        List<EnforcementActionDataType> enforcements = source.getEnforcementAction();
        if (enforcements != null && (!enforcements.isEmpty())) {
            deletes = new ArrayList<>();
            for (EnforcementActionDataType e : enforcements) {
                deletes.add(convertEnforcementsFromXml(e));
            }
        }
        return deletes;
    }

    private static List<ViolationDeleteDataType> convertViolations(CMEFacilitySubmissionDataType source) {
        List<ViolationDeleteDataType> deletes = null;
        List<ViolationDataType> violations = source.getViolation();
        if (violations != null && (!violations.isEmpty())) {
            deletes = new ArrayList<>();
            for (ViolationDataType v : violations) {
                deletes.add(convertViolationFromXml(v));
            }
        }
        return deletes;
    }

    private static List<EvaluationDeleteDataType> convertEvaluations(CMEFacilitySubmissionDataType source) {
        List<EvaluationDeleteDataType> deletes = null;
        List<EvaluationDataType> evaluations = source.getEvaluation();
        if (evaluations != null && (!evaluations.isEmpty())) {
            deletes = new ArrayList<>();
            for (EvaluationDataType e : evaluations) {
                deletes.add(convertEvaluationFromXml(e));
            }
        }
        return deletes;
    }

}
