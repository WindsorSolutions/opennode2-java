package com.windsor.node.plugin.rcra.inbound.domain;

import javax.persistence.CascadeType;
import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import java.util.List;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "Emanifests", namespace = "http://www.exchangenetwork.net/schema/RCRA/5", propOrder = {
        "list"
})
@Embeddable
public class Emanifests {

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "EM_SUBM_ID", updatable = false, nullable = false)
    @XmlElement(name = "Emanifest", namespace = "http://www.exchangenetwork.net/schema/RCRA/5")
    private List<EmanifestDataType> list;

    public Emanifests() {
        super();
    }

    public List<EmanifestDataType> getList() {
        return list;
    }

    public void setList(List<EmanifestDataType> list) {
        this.list = list;
    }
}
