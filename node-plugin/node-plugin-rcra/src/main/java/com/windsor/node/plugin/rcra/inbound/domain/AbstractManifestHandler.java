package com.windsor.node.plugin.rcra.inbound.domain;

import javax.persistence.Column;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.xml.bind.annotation.XmlTransient;

@MappedSuperclass
public abstract class AbstractManifestHandler {

    @XmlTransient
    private ManifestHandlerType manifestHandlerType;

    @XmlTransient
    private EmanifestDataType emanifest;

    public AbstractManifestHandler() {
        super();
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "MANIFEST_HANDLER_TYPE", nullable = false)
    public ManifestHandlerType getManifestHandlerType() {
        return manifestHandlerType;
    }

    public void setManifestHandlerType(ManifestHandlerType manifestHandlerType) {
        this.manifestHandlerType = manifestHandlerType;
    }

    @ManyToOne
    @JoinColumn(name = "EM_EMANIFEST_ID", nullable = false)
    public EmanifestDataType getEmanifest() {
        return emanifest;
    }

    public void setEmanifest(EmanifestDataType emanifest) {
        this.emanifest = emanifest;
    }
}
