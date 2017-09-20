/*
Copyright (c) 2009, The Environmental Council of the States (ECOS)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 * Neither the name of the ECOS nor the names of its contributors may
   be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
 */

package com.windsor.node.plugin.nysitesspills.domain;

import java.sql.Timestamp;

public class ErSite extends BaseSitesSpillsDomainObject {

    private Integer siteSequenceNum;
    private Integer programSequenceNum;
    private Integer siteId;

    private Double acres;

    private String significantThreat;
    private String siteClassCode;
    private String siteClassName;
    private String siteClassDescription;
    private String description;
    private String landUse;
    private String intendedUseCode;
    private String cleanupTrackCode;
    private String cleanupTrackName;
    private String assessEnv;
    private String assessDoh;
    private String dohAssessFlag;
    private String dohAssessReason;
    private String assessLeg;
    private String periodicReviewFrequencyCode;
    private String periodicReviewFrequencyName;
    private String vaporIntrusionLegacy;
    private String hudsonRiverEstuary;
    private String editReviewComp;
    private String projMgrReviewComp;
    private String siteManagePriority;
    private String modifiedBy;

    private Timestamp dohAssessMod;
    private Timestamp editReviewDate;
    private Timestamp projMgrReviewDate;
    private Timestamp lastModified;

    public String getDohAssessModString() {

        return getFormattedDateString(getDohAssessMod());
    }

    public String getEditReviewDateString() {

        return getFormattedDateString(getEditReviewDate());
    }

    public String getProjMgrReviewDateString() {

        return getFormattedDateString(getProjMgrReviewDate());
    }

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public String getAcresString() {

        return getFormattedDouble(getAcres());
    }

    public Integer getSiteSequenceNum() {
        return siteSequenceNum;
    }

    public void setSiteSequenceNum(Integer siteSequenceNum) {
        this.siteSequenceNum = siteSequenceNum;
    }

    public Integer getProgramSequenceNum() {
        return programSequenceNum;
    }

    public void setProgramSequenceNum(Integer programSequenceNum) {
        this.programSequenceNum = programSequenceNum;
    }

    public Integer getSiteId() {
        return siteId;
    }

    public void setSiteId(Integer siteId) {
        this.siteId = siteId;
    }

    public Double getAcres() {
        return acres;
    }

    public void setAcres(Double acres) {
        this.acres = acres;
    }

    public String getSignificantThreat() {
        return significantThreat;
    }

    public void setSignificantThreat(String significantThreat) {
        this.significantThreat = significantThreat;
    }

    public String getSiteClassCode() {
        return siteClassCode;
    }

    public void setSiteClassCode(String siteClassCode) {
        this.siteClassCode = siteClassCode;
    }

    public String getSiteClassName() {
        return siteClassName;
    }

    public void setSiteClassName(String siteClassName) {
        this.siteClassName = siteClassName;
    }

    public String getSiteClassDescription() {
        return siteClassDescription;
    }

    public void setSiteClassDescription(String siteClassDescription) {
        this.siteClassDescription = siteClassDescription;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLandUse() {
        return landUse;
    }

    public void setLandUse(String landUse) {
        this.landUse = landUse;
    }

    public String getIntendedUseCode() {
        return intendedUseCode;
    }

    public void setIntendedUseCode(String intendedUseCode) {
        this.intendedUseCode = intendedUseCode;
    }

    public String getCleanupTrackCode() {
        return cleanupTrackCode;
    }

    public void setCleanupTrackCode(String cleanupTrackCode) {
        this.cleanupTrackCode = cleanupTrackCode;
    }

    public String getCleanupTrackName() {
        return cleanupTrackName;
    }

    public void setCleanupTrackName(String cleanupTrackName) {
        this.cleanupTrackName = cleanupTrackName;
    }

    public String getAssessEnv() {
        return assessEnv;
    }

    public void setAssessEnv(String assessEnv) {
        this.assessEnv = assessEnv;
    }

    public String getAssessDoh() {
        return assessDoh;
    }

    public void setAssessDoh(String assessDoh) {
        this.assessDoh = assessDoh;
    }

    public String getDohAssessFlag() {
        return dohAssessFlag;
    }

    public void setDohAssessFlag(String dohAssessFlag) {
        this.dohAssessFlag = dohAssessFlag;
    }

    public String getDohAssessReason() {
        return dohAssessReason;
    }

    public void setDohAssessReason(String dohAssessReason) {
        this.dohAssessReason = dohAssessReason;
    }

    public String getAssessLeg() {
        return assessLeg;
    }

    public void setAssessLeg(String assessLeg) {
        this.assessLeg = assessLeg;
    }

    public String getPeriodicReviewFrequencyCode() {
        return periodicReviewFrequencyCode;
    }

    public void setPeriodicReviewFrequencyCode(
            String periodicReviewFrequencyCode) {
        this.periodicReviewFrequencyCode = periodicReviewFrequencyCode;
    }

    public String getPeriodicReviewFrequencyName() {
        return periodicReviewFrequencyName;
    }

    public void setPeriodicReviewFrequencyName(
            String periodicReviewFrequencyName) {
        this.periodicReviewFrequencyName = periodicReviewFrequencyName;
    }

    public String getVaporIntrusionLegacy() {
        return vaporIntrusionLegacy;
    }

    public void setVaporIntrusionLegacy(String vaporIntrusionLegacy) {
        this.vaporIntrusionLegacy = vaporIntrusionLegacy;
    }

    public String getHudsonRiverEstuary() {
        return hudsonRiverEstuary;
    }

    public void setHudsonRiverEstuary(String hudsonRiverEstuary) {
        this.hudsonRiverEstuary = hudsonRiverEstuary;
    }

    public String getEditReviewComp() {
        return editReviewComp;
    }

    public void setEditReviewComp(String editReviewComp) {
        this.editReviewComp = editReviewComp;
    }

    public String getProjMgrReviewComp() {
        return projMgrReviewComp;
    }

    public void setProjMgrReviewComp(String projMgrReviewComp) {
        this.projMgrReviewComp = projMgrReviewComp;
    }

    public String getSiteManagePriority() {
        return siteManagePriority;
    }

    public void setSiteManagePriority(String siteManagePriority) {
        this.siteManagePriority = siteManagePriority;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public Timestamp getDohAssessMod() {
        return dohAssessMod;
    }

    public void setDohAssessMod(Timestamp dohAssessMod) {
        this.dohAssessMod = dohAssessMod;
    }

    public Timestamp getEditReviewDate() {
        return editReviewDate;
    }

    public void setEditReviewDate(Timestamp editReviewDate) {
        this.editReviewDate = editReviewDate;
    }

    public Timestamp getProjMgrReviewDate() {
        return projMgrReviewDate;
    }

    public void setProjMgrReviewDate(Timestamp projMgrReviewDate) {
        this.projMgrReviewDate = projMgrReviewDate;
    }

    public Timestamp getLastModified() {
        return lastModified;
    }

    public void setLastModified(Timestamp lastModified) {
        this.lastModified = lastModified;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((acres == null) ? 0 : acres.hashCode());
        result = prime * result
                + ((assessDoh == null) ? 0 : assessDoh.hashCode());
        result = prime * result
                + ((assessEnv == null) ? 0 : assessEnv.hashCode());
        result = prime * result
                + ((assessLeg == null) ? 0 : assessLeg.hashCode());
        result = prime
                * result
                + ((cleanupTrackCode == null) ? 0 : cleanupTrackCode.hashCode());
        result = prime
                * result
                + ((cleanupTrackName == null) ? 0 : cleanupTrackName.hashCode());
        result = prime * result
                + ((description == null) ? 0 : description.hashCode());
        result = prime * result
                + ((dohAssessFlag == null) ? 0 : dohAssessFlag.hashCode());
        result = prime * result
                + ((dohAssessMod == null) ? 0 : dohAssessMod.hashCode());
        result = prime * result
                + ((dohAssessReason == null) ? 0 : dohAssessReason.hashCode());
        result = prime * result
                + ((editReviewComp == null) ? 0 : editReviewComp.hashCode());
        result = prime * result
                + ((editReviewDate == null) ? 0 : editReviewDate.hashCode());
        result = prime
                * result
                + ((hudsonRiverEstuary == null) ? 0 : hudsonRiverEstuary
                        .hashCode());
        result = prime * result
                + ((intendedUseCode == null) ? 0 : intendedUseCode.hashCode());
        result = prime * result + ((landUse == null) ? 0 : landUse.hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((modifiedBy == null) ? 0 : modifiedBy.hashCode());
        result = prime
                * result
                + ((periodicReviewFrequencyCode == null) ? 0
                        : periodicReviewFrequencyCode.hashCode());
        result = prime
                * result
                + ((periodicReviewFrequencyName == null) ? 0
                        : periodicReviewFrequencyName.hashCode());
        result = prime
                * result
                + ((programSequenceNum == null) ? 0 : programSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((projMgrReviewComp == null) ? 0 : projMgrReviewComp
                        .hashCode());
        result = prime
                * result
                + ((projMgrReviewDate == null) ? 0 : projMgrReviewDate
                        .hashCode());
        result = prime
                * result
                + ((significantThreat == null) ? 0 : significantThreat
                        .hashCode());
        result = prime * result
                + ((siteClassCode == null) ? 0 : siteClassCode.hashCode());
        result = prime
                * result
                + ((siteClassDescription == null) ? 0 : siteClassDescription
                        .hashCode());
        result = prime * result
                + ((siteClassName == null) ? 0 : siteClassName.hashCode());
        result = prime * result + ((siteId == null) ? 0 : siteId.hashCode());
        result = prime
                * result
                + ((siteManagePriority == null) ? 0 : siteManagePriority
                        .hashCode());
        result = prime * result
                + ((siteSequenceNum == null) ? 0 : siteSequenceNum.hashCode());
        result = prime
                * result
                + ((vaporIntrusionLegacy == null) ? 0 : vaporIntrusionLegacy
                        .hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ErSite other = (ErSite) obj;
        if (acres == null) {
            if (other.acres != null)
                return false;
        } else if (!acres.equals(other.acres))
            return false;
        if (assessDoh == null) {
            if (other.assessDoh != null)
                return false;
        } else if (!assessDoh.equals(other.assessDoh))
            return false;
        if (assessEnv == null) {
            if (other.assessEnv != null)
                return false;
        } else if (!assessEnv.equals(other.assessEnv))
            return false;
        if (assessLeg == null) {
            if (other.assessLeg != null)
                return false;
        } else if (!assessLeg.equals(other.assessLeg))
            return false;
        if (cleanupTrackCode == null) {
            if (other.cleanupTrackCode != null)
                return false;
        } else if (!cleanupTrackCode.equals(other.cleanupTrackCode))
            return false;
        if (cleanupTrackName == null) {
            if (other.cleanupTrackName != null)
                return false;
        } else if (!cleanupTrackName.equals(other.cleanupTrackName))
            return false;
        if (description == null) {
            if (other.description != null)
                return false;
        } else if (!description.equals(other.description))
            return false;
        if (dohAssessFlag == null) {
            if (other.dohAssessFlag != null)
                return false;
        } else if (!dohAssessFlag.equals(other.dohAssessFlag))
            return false;
        if (dohAssessMod == null) {
            if (other.dohAssessMod != null)
                return false;
        } else if (!dohAssessMod.equals(other.dohAssessMod))
            return false;
        if (dohAssessReason == null) {
            if (other.dohAssessReason != null)
                return false;
        } else if (!dohAssessReason.equals(other.dohAssessReason))
            return false;
        if (editReviewComp == null) {
            if (other.editReviewComp != null)
                return false;
        } else if (!editReviewComp.equals(other.editReviewComp))
            return false;
        if (editReviewDate == null) {
            if (other.editReviewDate != null)
                return false;
        } else if (!editReviewDate.equals(other.editReviewDate))
            return false;
        if (hudsonRiverEstuary == null) {
            if (other.hudsonRiverEstuary != null)
                return false;
        } else if (!hudsonRiverEstuary.equals(other.hudsonRiverEstuary))
            return false;
        if (intendedUseCode == null) {
            if (other.intendedUseCode != null)
                return false;
        } else if (!intendedUseCode.equals(other.intendedUseCode))
            return false;
        if (landUse == null) {
            if (other.landUse != null)
                return false;
        } else if (!landUse.equals(other.landUse))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (modifiedBy == null) {
            if (other.modifiedBy != null)
                return false;
        } else if (!modifiedBy.equals(other.modifiedBy))
            return false;
        if (periodicReviewFrequencyCode == null) {
            if (other.periodicReviewFrequencyCode != null)
                return false;
        } else if (!periodicReviewFrequencyCode
                .equals(other.periodicReviewFrequencyCode))
            return false;
        if (periodicReviewFrequencyName == null) {
            if (other.periodicReviewFrequencyName != null)
                return false;
        } else if (!periodicReviewFrequencyName
                .equals(other.periodicReviewFrequencyName))
            return false;
        if (programSequenceNum == null) {
            if (other.programSequenceNum != null)
                return false;
        } else if (!programSequenceNum.equals(other.programSequenceNum))
            return false;
        if (projMgrReviewComp == null) {
            if (other.projMgrReviewComp != null)
                return false;
        } else if (!projMgrReviewComp.equals(other.projMgrReviewComp))
            return false;
        if (projMgrReviewDate == null) {
            if (other.projMgrReviewDate != null)
                return false;
        } else if (!projMgrReviewDate.equals(other.projMgrReviewDate))
            return false;
        if (significantThreat == null) {
            if (other.significantThreat != null)
                return false;
        } else if (!significantThreat.equals(other.significantThreat))
            return false;
        if (siteClassCode == null) {
            if (other.siteClassCode != null)
                return false;
        } else if (!siteClassCode.equals(other.siteClassCode))
            return false;
        if (siteClassDescription == null) {
            if (other.siteClassDescription != null)
                return false;
        } else if (!siteClassDescription.equals(other.siteClassDescription))
            return false;
        if (siteClassName == null) {
            if (other.siteClassName != null)
                return false;
        } else if (!siteClassName.equals(other.siteClassName))
            return false;
        if (siteId == null) {
            if (other.siteId != null)
                return false;
        } else if (!siteId.equals(other.siteId))
            return false;
        if (siteManagePriority == null) {
            if (other.siteManagePriority != null)
                return false;
        } else if (!siteManagePriority.equals(other.siteManagePriority))
            return false;
        if (siteSequenceNum == null) {
            if (other.siteSequenceNum != null)
                return false;
        } else if (!siteSequenceNum.equals(other.siteSequenceNum))
            return false;
        if (vaporIntrusionLegacy == null) {
            if (other.vaporIntrusionLegacy != null)
                return false;
        } else if (!vaporIntrusionLegacy.equals(other.vaporIntrusionLegacy))
            return false;
        return true;
    }

}