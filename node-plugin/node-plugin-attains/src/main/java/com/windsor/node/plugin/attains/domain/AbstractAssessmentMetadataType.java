package com.windsor.node.plugin.attains.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;


/**
 * Provides an abstract class that all AssessmentMetadataType classes may extend.
 *
 * Ensures the ID field is mapped to the ID of the parent.
 */
@MappedSuperclass
@XmlAccessorType(XmlAccessType.FIELD)
public abstract class AbstractAssessmentMetadataType {

    private String Id;
    @XmlElement(name = "AssessmentTypes", namespace = "http://www.exchangenetwork.net/schema/IR/1")
    protected AssessmentTypesDataType assessmentTypes;
    @XmlElement(name = "AssessmentMethodTypes", namespace = "http://www.exchangenetwork.net/schema/IR/1")
    protected AssessmentMethodTypesDataType assessmentMethodTypes;

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
    @Embedded
    @AssociationOverride(name = "assessmentType", joinColumns = {
            @JoinColumn(name = "ATT_USE_ATTAINMENT_ID")
    })
    public AssessmentTypesDataType getAssessmentTypes() {
        return assessmentTypes;
    }

    /**
     * Gets the value of the assessmentMethodTypes property.
     *
     * @return
     *     possible object is
     *     {@link AssessmentMethodTypesDataType }
     *
     */
    @Embedded
    @AssociationOverride(name = "assessmentMethodType", joinColumns = {
            @JoinColumn(name = "ATT_USE_ATTAINMENT_ID")
    })
    public AssessmentMethodTypesDataType getAssessmentMethodTypes() {
        return assessmentMethodTypes;
    }

}
