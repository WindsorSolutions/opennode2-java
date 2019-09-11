package com.windsor.node.plugin.attains.domain;

import javax.persistence.*;


/**
 * Provides an abstract class that all AssessmentMetadataType classes may extend.
 *
 * Ensures the ID field is mapped to the ID of the parent.
 */
@MappedSuperclass
public abstract class AbstractAssessmentMetadataType {

    private String Id;

    @Id
    @Basic
    @Column(name = "ATT_USE_ATTAINMENT_ID")
    public String getId() {
        return Id;
    }

    public void setId(String id) {
        Id = id;
    }

    /**
     * Gets the value of the assessmentTypes property.
     *
     * @return
     *     possible object is
     *     {@link AssessmentTypesDataType }
     *
     */
    @Transient
    @Embedded
    @AssociationOverride(name = "assessmentType", joinColumns = {
            @JoinColumn(name = "ATT_USE_ATTAINMENT_ID")
    })
    public abstract AssessmentTypesDataType getAssessmentTypes();

    public abstract void setAssessmentTypes(AssessmentTypesDataType assessmentTypes);

    public void nullAssessmentTypes() {
        AssessmentTypesDataType assessments = getAssessmentTypes();
        if (assessments == null || assessments.getAssessmentType() == null || assessments.getAssessmentType().size() == 0) {
            setAssessmentTypes(null);
        }
    }

    /**
     * Gets the value of the assessmentMethodTypes property.
     *g
     * @return
     *     possible object is
     *     {@link AssessmentMethodTypesDataType }
     *
     */
    @Transient
    @Embedded
    @AssociationOverride(name = "assessmentMethodType", joinColumns = {
            @JoinColumn(name = "ATT_USE_ATTAINMENT_ID")
    })
    public abstract AssessmentMethodTypesDataType getAssessmentMethodTypes();

    public abstract void setAssessmentMethodTypes(AssessmentMethodTypesDataType assessmentMethodTypes);

    public void nullAssessmentMethodTypes() {
        AssessmentMethodTypesDataType assessmentMethods = getAssessmentMethodTypes();
        if (assessmentMethods == null || assessmentMethods.getAssessmentMethodType() == null || assessmentMethods.getAssessmentMethodType().size() == 0) {
            setAssessmentMethodTypes(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullAssessmentTypes();
        nullAssessmentMethodTypes();
    }
}
