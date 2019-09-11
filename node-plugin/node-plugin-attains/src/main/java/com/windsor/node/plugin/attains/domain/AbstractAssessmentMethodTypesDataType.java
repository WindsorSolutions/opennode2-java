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
public abstract class AbstractAssessmentMethodTypesDataType {

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

    @OneToMany(targetEntity = AssessmentMethodTypeDataType.class, cascade = {
            CascadeType.ALL
    })
    @JoinColumn(name = "ATT_ASSESSMNT_METHOD_TYPE_ID")
    public abstract List<AssessmentMethodTypeDataType> getAssessmentMethodType();

    public abstract void setAssessmentMethodType(List<AssessmentMethodTypeDataType> assessmentMethodType);

    public void nullAssessmentMethodType() {
        List<AssessmentMethodTypeDataType> asessments = getAssessmentMethodType();
        if (asessments == null || asessments.size() == 0) {
            setAssessmentMethodType(null);
        }
    }

    @PostLoad
    public void handlePostLoad() {
        nullAssessmentMethodType();
    }
}
