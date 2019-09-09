package com.windsor.node.plugin.attains.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import java.util.ArrayList;
import java.util.List;


/**
 * Provides an abstract class that all AssessmentMetadataType classes may extend.
 *
 * Ensures the ID field is mapped to the ID of the parent.
 */
@MappedSuperclass
@XmlAccessorType(XmlAccessType.FIELD)
public abstract class AbstractAssessmentTypesDataType {

    private String Id;
    @XmlElement(name = "AssessmentType", namespace = "http://www.exchangenetwork.net/schema/IR/1", required = true)
    protected List<AssessmentTypeDataType> assessmentType;

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
     * Gets the value of the assessmentType property.
     *
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the assessmentType property.
     *
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAssessmentType().add(newItem);
     * </pre>
     *
     *
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AssessmentTypeDataType }
     *
     *
     */
    @OneToMany(targetEntity = AssessmentTypeDataType.class, cascade = {
            CascadeType.ALL
    })
    @JoinColumn(name = "ATT_ASSESSMNT_TYPE_ID")
    public List<AssessmentTypeDataType> getAssessmentType() {
        if (assessmentType == null) {
            assessmentType = new ArrayList<AssessmentTypeDataType>();
        }
        return this.assessmentType;
    }
}
