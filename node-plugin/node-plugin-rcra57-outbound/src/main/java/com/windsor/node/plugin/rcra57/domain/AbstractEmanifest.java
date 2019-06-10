package com.windsor.node.plugin.rcra57.domain;

import javax.persistence.MappedSuperclass;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;
import java.util.List;

@MappedSuperclass
public abstract class AbstractEmanifest {

    @Transient
    public abstract ManifestHandlerSiteDataType getGenerator();
    @Transient
    public abstract ManifestHandlerSiteDataType getDesignatedFacility();
    @Transient
    public abstract List<ManifestHandlerSiteDataType> getTransporter();
    @Transient
    public abstract RejectionInfoDataType getRejectionInfo();

    public AbstractEmanifest() {
        super();
    }

    @PrePersist
    @PreUpdate
    public void handlePrePersist() {
        ManifestHandlerSiteDataType generator = getGenerator();
        if (generator != null) {
            generator.setManifestHandlerType(ManifestHandlerType.Generator);
            generator.setEmanifest((EmanifestDataType)this);
        }
        ManifestHandlerSiteDataType designatedFacility = getDesignatedFacility();
        if (designatedFacility != null) {
            designatedFacility.setManifestHandlerType(ManifestHandlerType.DesignatedFacility);
            designatedFacility.setEmanifest((EmanifestDataType)this);
        }
        List<ManifestHandlerSiteDataType> transporters = getTransporter();
        if (transporters != null) {
            for(ManifestHandlerSiteDataType handler : transporters) {
                handler.setManifestHandlerType(ManifestHandlerType.Transporter);
                handler.setEmanifest((EmanifestDataType)this);
            }
        }
        RejectionInfoDataType rejectionInfo = getRejectionInfo();
        if (rejectionInfo != null) {
            ManifestHandlerSiteDataType alternateDesignatedFacility = rejectionInfo.getAlternateDesignatedFacility();
            if (alternateDesignatedFacility != null) {
                alternateDesignatedFacility.setManifestHandlerType(ManifestHandlerType.AlternateDesignateFacility);
                alternateDesignatedFacility.setEmanifest((EmanifestDataType)this);
            }
        }
    }

}
