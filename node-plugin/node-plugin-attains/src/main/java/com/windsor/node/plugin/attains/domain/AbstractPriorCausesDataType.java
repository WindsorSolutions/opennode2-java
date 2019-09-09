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
public class AbstractPriorCausesDataType {

    private String Id;
    @XmlElement(name = "PriorCause", namespace = "http://www.exchangenetwork.net/schema/IR/1", required = true)
    protected List<PriorCauseDataType> priorCause;

    @Id
    @Basic
    @Column(name = "ATT_PARAM_ID")
    public String getId() {
        return Id;
    }

    public void setId(String id) {
        Id = id;
    }

    /**
     * Gets the value of the priorCause property.
     *
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the priorCause property.
     *
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getPriorCause().add(newItem);
     * </pre>
     *
     *
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link PriorCauseDataType }
     *
     *
     */
    @OneToMany(targetEntity = PriorCauseDataType.class, cascade = {
            CascadeType.ALL
    })
    @JoinColumn(name = "ATT_PARAM_ID")
    public List<PriorCauseDataType> getPriorCause() {
        if (priorCause == null) {
            priorCause = new ArrayList<PriorCauseDataType>();
        }
        return this.priorCause;
    }
}
