package com.windsor.node.plugin.attains.domain;

import javax.persistence.*;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlTransient;
import java.util.ArrayList;
import java.util.List;


@MappedSuperclass
@XmlAccessorType(XmlAccessType.FIELD)
public class AbstractAssessmentMethodTypesDataType {

    private String Id;
    @XmlElement(name = "AssessmentMethodType", namespace = "http://www.exchangenetwork.net/schema/IR/1", required = true)
    protected List<AssessmentMethodTypeDataType> assessmentMethodType;

    @Id
    @Basic
    @Column(name = "ATT_ASSESSMNT_METHOD_TYPE_ID")
    public String getId() {
        return Id;
    }

    public void setId(String id) {
        Id = id;
    }

    /**
     * Gets the value of the assessmentMethodType property.
     *
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the assessmentMethodType property.
     *
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAssessmentMethodType().add(newItem);
     * </pre>
     *
     *
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link AssessmentMethodTypeDataType }
     *
     *
     */
    @OneToMany(targetEntity = AssessmentMethodTypeDataType.class, cascade = {
            CascadeType.ALL
    })
    @JoinColumn(name = "ATT_ASSESSMNT_METHOD_TYPE_ID")
    public List<AssessmentMethodTypeDataType> getAssessmentMethodType() {
        if (assessmentMethodType == null) {
            assessmentMethodType = new ArrayList<AssessmentMethodTypeDataType>();
        }
        return this.assessmentMethodType;
    }
}
