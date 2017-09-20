package com.windsor.node.plugin.gagapdesgeos.domain;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "GAPDES_SW_SUB_FORM")
public class FormData {

    @Id
    @GeneratedValue
    public Integer id;

    @ManyToOne
    @JoinColumn(name = "submission_id",  nullable = false)
    public GeosSwSubmission geosSwSubmission;

    @Column(name = "form")
    public String formName;

    @Column(name = "xml_id")
    public String xmlId;

    @Column(name = "xml_value")
    public String xmlValue;

    @Column(name = "xml_tag")
    public String xmlTag;

    @Column(name = "xml_visible")
    public Boolean xmlVisible;

    @Column(name = "xml_history")
    public String xmlHistory;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public GeosSwSubmission getGeosSwSubmission() {
        return geosSwSubmission;
    }

    public void setGeosSwSubmission(GeosSwSubmission geosSwSubmission) {
        this.geosSwSubmission = geosSwSubmission;
    }

    public String getFormName() {
        return formName;
    }

    public void setFormName(String formName) {
        this.formName = formName;
    }

    public String getXmlId() {
        return xmlId;
    }

    public void setXmlId(String xmlId) {
        this.xmlId = xmlId;
    }

    public String getXmlValue() {
        return xmlValue;
    }

    public void setXmlValue(String xmlValue) {
        this.xmlValue = xmlValue;
    }

    public String getXmlTag() {
        return xmlTag;
    }

    public void setXmlTag(String xmlTag) {
        this.xmlTag = xmlTag;
    }

    public Boolean getXmlVisible() {
        return xmlVisible;
    }

    public void setXmlVisible(Boolean xmlVisible) {
        this.xmlVisible = xmlVisible;
    }

    public String getXmlHistory() {
        return xmlHistory;
    }

    public void setXmlHistory(String xmlHistory) {
        this.xmlHistory = xmlHistory;
    }

    @Override
    public String toString() {
        return "FormData{" +
                "formName='" + formName + '\'' +
                ", xmlId='" + xmlId + '\'' +
                ", xmlValue='" + xmlValue + '\'' +
                ", xmlTag='" + xmlTag + '\'' +
                ", xmlVisible=" + xmlVisible +
                ", xmlHistory='" + xmlHistory + '\'' +
                '}';
    }
}