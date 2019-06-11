package com.windsor.node.plugin.rcra57.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;
import java.util.List;

@XmlRootElement(name = "HazardousWasteEmanifests",  namespace = "http://www.exchangenetwork.net/schema/RCRA/5")
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "HazardousWasteEmanifests", namespace = "http://www.exchangenetwork.net/schema/RCRA/5", propOrder = {
    "manifests"
})
@Entity
@Table(name = "RCRA_EM_SUBM")
public class HazardousWasteEmanifestsDataType {

    @Id
    @GeneratedValue(generator = "UUID")
    @Column(name = "EM_SUBM_ID")
    @XmlTransient
    private String dbid;

    @XmlTransient
    @OneToMany(mappedBy = "parent")
    private List<EmanifestDataType> emanifests;

    @Transient
    @XmlElement(name = "Emanifests", namespace = "http://www.exchangenetwork.net/schema/RCRA/5")
    private Emanifests manifests = new Emanifests();

    public HazardousWasteEmanifestsDataType() {
        super();
    }

    public String getDbid() {
        return dbid;
    }

    public void setDbid(String dbid) {
        this.dbid = dbid;
    }

    public Emanifests getManifests() {
        return manifests;
    }

    public void setManifests(Emanifests manifests) {
        this.manifests = manifests;
    }
}
