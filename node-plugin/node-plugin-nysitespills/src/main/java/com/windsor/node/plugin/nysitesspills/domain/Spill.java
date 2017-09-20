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

public class Spill extends BaseSitesSpillsDomainObject {

    private Integer spillSequenceNum;
    private Integer programSequenceNum;
    private Integer privateWellsAffected;
    private Integer publicWellsAffected;

    private String decLead;
    private String referredTo;
    private String contributingFactorCode;
    private String contributingFactorName;
    private String waterbody;
    private String facilityTypeCode;
    private String facilityTypeName;
    private String reportedBy;
    private String notifierCodeName;
    private String callerRemark;
    private String meetsStandardIndicator;
    private String penaltyIndicator;
    private String ustTrustIndicator;
    private String spillClass;
    private String decRemark;
    private String regionalUse;
    private String afterHoursIndicator;
    private String remedialPhase;

    private Timestamp spillDate;
    private Timestamp spillReceivedDate;
    private Timestamp inspectionDate;
    private Timestamp responseEndDate;
    private Timestamp investigationEndDate;
    private Timestamp remedialDesignDate;
    private Timestamp remedialActionDate;
    private Timestamp siteMgmtEndDate;
    private Timestamp closeDate;
    private Timestamp createDate;
    private Timestamp lastModified;

    public String getSpillDateString() {

        return getFormattedDateString(getSpillDate());
    }

    public String getSpillReceivedDateString() {

        return getFormattedDateString(getSpillReceivedDate());
    }

    public String getInspectionDateString() {

        return getFormattedDateString(getInspectionDate());
    }

    public String getResponseEndDateString() {

        return getFormattedDateString(getResponseEndDate());
    }

    public String getInvestigationEndDateString() {

        return getFormattedDateString(getInvestigationEndDate());
    }

    public String getRemedialDesignDateString() {

        return getFormattedDateString(getRemedialDesignDate());
    }

    public String getRemedialActionDateString() {

        return getFormattedDateString(getRemedialActionDate());
    }

    public String getSiteMgmtEndDateString() {

        return getFormattedDateString(getSiteMgmtEndDate());
    }

    public String getCloseDateString() {

        return getFormattedDateString(getCloseDate());
    }

    public String getCreateDateString() {

        return getFormattedDateString(getCreateDate());
    }

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public Integer getSpillSequenceNum() {
        return spillSequenceNum;
    }

    public void setSpillSequenceNum(Integer spillSequenceNum) {
        this.spillSequenceNum = spillSequenceNum;
    }

    public Integer getProgramSequenceNum() {
        return programSequenceNum;
    }

    public void setProgramSequenceNum(Integer programSequenceNum) {
        this.programSequenceNum = programSequenceNum;
    }

    public Integer getPrivateWellsAffected() {
        return privateWellsAffected;
    }

    public void setPrivateWellsAffected(Integer privateWellsAffected) {
        this.privateWellsAffected = privateWellsAffected;
    }

    public Integer getPublicWellsAffected() {
        return publicWellsAffected;
    }

    public void setPublicWellsAffected(Integer publicWellsAffected) {
        this.publicWellsAffected = publicWellsAffected;
    }

    public String getDecLead() {
        return decLead;
    }

    public void setDecLead(String decLead) {
        this.decLead = decLead;
    }

    public String getReferredTo() {
        return referredTo;
    }

    public void setReferredTo(String referredTo) {
        this.referredTo = referredTo;
    }

    public String getContributingFactorCode() {
        return contributingFactorCode;
    }

    public void setContributingFactorCode(String contributingFactorCode) {
        this.contributingFactorCode = contributingFactorCode;
    }

    public String getContributingFactorName() {
        return contributingFactorName;
    }

    public void setContributingFactorName(String contributingFactorName) {
        this.contributingFactorName = contributingFactorName;
    }

    public String getWaterbody() {
        return waterbody;
    }

    public void setWaterbody(String waterbody) {
        this.waterbody = waterbody;
    }

    public String getFacilityTypeCode() {
        return facilityTypeCode;
    }

    public void setFacilityTypeCode(String facilityTypeCode) {
        this.facilityTypeCode = facilityTypeCode;
    }

    public String getFacilityTypeName() {
        return facilityTypeName;
    }

    public void setFacilityTypeName(String facilityTypeName) {
        this.facilityTypeName = facilityTypeName;
    }

    public String getReportedBy() {
        return reportedBy;
    }

    public void setReportedBy(String reportedBy) {
        this.reportedBy = reportedBy;
    }

    public String getNotifierCodeName() {
        return notifierCodeName;
    }

    public void setNotifierCodeName(String notifierCodeName) {
        this.notifierCodeName = notifierCodeName;
    }

    public String getCallerRemark() {
        return callerRemark;
    }

    public void setCallerRemark(String callerRemark) {
        this.callerRemark = callerRemark;
    }

    public String getMeetsStandardIndicator() {
        return meetsStandardIndicator;
    }

    public void setMeetsStandardIndicator(String meetsStandardIndicator) {
        this.meetsStandardIndicator = meetsStandardIndicator;
    }

    public String getPenaltyIndicator() {
        return penaltyIndicator;
    }

    public void setPenaltyIndicator(String penaltyIndicator) {
        this.penaltyIndicator = penaltyIndicator;
    }

    public String getUstTrustIndicator() {
        return ustTrustIndicator;
    }

    public void setUstTrustIndicator(String ustTrustIndicator) {
        this.ustTrustIndicator = ustTrustIndicator;
    }

    public String getSpillClass() {
        return spillClass;
    }

    public void setSpillClass(String spillClass) {
        this.spillClass = spillClass;
    }

    public String getDecRemark() {
        return decRemark;
    }

    public void setDecRemark(String decRemark) {
        this.decRemark = decRemark;
    }

    public String getRegionalUse() {
        return regionalUse;
    }

    public void setRegionalUse(String regionalUse) {
        this.regionalUse = regionalUse;
    }

    public String getAfterHoursIndicator() {
        return afterHoursIndicator;
    }

    public void setAfterHoursIndicator(String afterHoursIndicator) {
        this.afterHoursIndicator = afterHoursIndicator;
    }

    public String getRemedialPhase() {
        return remedialPhase;
    }

    public void setRemedialPhase(String remedialPhase) {
        this.remedialPhase = remedialPhase;
    }

    public Timestamp getSpillDate() {
        return spillDate;
    }

    public void setSpillDate(Timestamp spillDate) {
        this.spillDate = spillDate;
    }

    public Timestamp getSpillReceivedDate() {
        return spillReceivedDate;
    }

    public void setSpillReceivedDate(Timestamp spillReceivedDate) {
        this.spillReceivedDate = spillReceivedDate;
    }

    public Timestamp getInspectionDate() {
        return inspectionDate;
    }

    public void setInspectionDate(Timestamp inspectionDate) {
        this.inspectionDate = inspectionDate;
    }

    public Timestamp getResponseEndDate() {
        return responseEndDate;
    }

    public void setResponseEndDate(Timestamp responseEndDate) {
        this.responseEndDate = responseEndDate;
    }

    public Timestamp getInvestigationEndDate() {
        return investigationEndDate;
    }

    public void setInvestigationEndDate(Timestamp investigationEndDate) {
        this.investigationEndDate = investigationEndDate;
    }

    public Timestamp getRemedialDesignDate() {
        return remedialDesignDate;
    }

    public void setRemedialDesignDate(Timestamp remedialDesignDate) {
        this.remedialDesignDate = remedialDesignDate;
    }

    public Timestamp getRemedialActionDate() {
        return remedialActionDate;
    }

    public void setRemedialActionDate(Timestamp remedialActionDate) {
        this.remedialActionDate = remedialActionDate;
    }

    public Timestamp getSiteMgmtEndDate() {
        return siteMgmtEndDate;
    }

    public void setSiteMgmtEndDate(Timestamp siteMgmtEndDate) {
        this.siteMgmtEndDate = siteMgmtEndDate;
    }

    public Timestamp getCloseDate() {
        return closeDate;
    }

    public void setCloseDate(Timestamp closeDate) {
        this.closeDate = closeDate;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
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
        result = prime
                * result
                + ((afterHoursIndicator == null) ? 0 : afterHoursIndicator
                        .hashCode());
        result = prime * result
                + ((callerRemark == null) ? 0 : callerRemark.hashCode());
        result = prime * result
                + ((closeDate == null) ? 0 : closeDate.hashCode());
        result = prime
                * result
                + ((contributingFactorCode == null) ? 0
                        : contributingFactorCode.hashCode());
        result = prime
                * result
                + ((contributingFactorName == null) ? 0
                        : contributingFactorName.hashCode());
        result = prime * result
                + ((createDate == null) ? 0 : createDate.hashCode());
        result = prime * result + ((decLead == null) ? 0 : decLead.hashCode());
        result = prime * result
                + ((decRemark == null) ? 0 : decRemark.hashCode());
        result = prime
                * result
                + ((facilityTypeCode == null) ? 0 : facilityTypeCode.hashCode());
        result = prime
                * result
                + ((facilityTypeName == null) ? 0 : facilityTypeName.hashCode());
        result = prime * result
                + ((inspectionDate == null) ? 0 : inspectionDate.hashCode());
        result = prime
                * result
                + ((investigationEndDate == null) ? 0 : investigationEndDate
                        .hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime
                * result
                + ((meetsStandardIndicator == null) ? 0
                        : meetsStandardIndicator.hashCode());
        result = prime
                * result
                + ((notifierCodeName == null) ? 0 : notifierCodeName.hashCode());
        result = prime
                * result
                + ((penaltyIndicator == null) ? 0 : penaltyIndicator.hashCode());
        result = prime
                * result
                + ((privateWellsAffected == null) ? 0 : privateWellsAffected
                        .hashCode());
        result = prime
                * result
                + ((programSequenceNum == null) ? 0 : programSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((publicWellsAffected == null) ? 0 : publicWellsAffected
                        .hashCode());
        result = prime * result
                + ((referredTo == null) ? 0 : referredTo.hashCode());
        result = prime * result
                + ((regionalUse == null) ? 0 : regionalUse.hashCode());
        result = prime
                * result
                + ((remedialActionDate == null) ? 0 : remedialActionDate
                        .hashCode());
        result = prime
                * result
                + ((remedialDesignDate == null) ? 0 : remedialDesignDate
                        .hashCode());
        result = prime * result
                + ((remedialPhase == null) ? 0 : remedialPhase.hashCode());
        result = prime * result
                + ((reportedBy == null) ? 0 : reportedBy.hashCode());
        result = prime * result
                + ((responseEndDate == null) ? 0 : responseEndDate.hashCode());
        result = prime * result
                + ((siteMgmtEndDate == null) ? 0 : siteMgmtEndDate.hashCode());
        result = prime * result
                + ((spillClass == null) ? 0 : spillClass.hashCode());
        result = prime * result
                + ((spillDate == null) ? 0 : spillDate.hashCode());
        result = prime
                * result
                + ((spillReceivedDate == null) ? 0 : spillReceivedDate
                        .hashCode());
        result = prime
                * result
                + ((spillSequenceNum == null) ? 0 : spillSequenceNum.hashCode());
        result = prime
                * result
                + ((ustTrustIndicator == null) ? 0 : ustTrustIndicator
                        .hashCode());
        result = prime * result
                + ((waterbody == null) ? 0 : waterbody.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Spill other = (Spill) obj;
        if (afterHoursIndicator == null) {
            if (other.afterHoursIndicator != null)
                return false;
        } else if (!afterHoursIndicator.equals(other.afterHoursIndicator))
            return false;
        if (callerRemark == null) {
            if (other.callerRemark != null)
                return false;
        } else if (!callerRemark.equals(other.callerRemark))
            return false;
        if (closeDate == null) {
            if (other.closeDate != null)
                return false;
        } else if (!closeDate.equals(other.closeDate))
            return false;
        if (contributingFactorCode == null) {
            if (other.contributingFactorCode != null)
                return false;
        } else if (!contributingFactorCode.equals(other.contributingFactorCode))
            return false;
        if (contributingFactorName == null) {
            if (other.contributingFactorName != null)
                return false;
        } else if (!contributingFactorName.equals(other.contributingFactorName))
            return false;
        if (createDate == null) {
            if (other.createDate != null)
                return false;
        } else if (!createDate.equals(other.createDate))
            return false;
        if (decLead == null) {
            if (other.decLead != null)
                return false;
        } else if (!decLead.equals(other.decLead))
            return false;
        if (decRemark == null) {
            if (other.decRemark != null)
                return false;
        } else if (!decRemark.equals(other.decRemark))
            return false;
        if (facilityTypeCode == null) {
            if (other.facilityTypeCode != null)
                return false;
        } else if (!facilityTypeCode.equals(other.facilityTypeCode))
            return false;
        if (facilityTypeName == null) {
            if (other.facilityTypeName != null)
                return false;
        } else if (!facilityTypeName.equals(other.facilityTypeName))
            return false;
        if (inspectionDate == null) {
            if (other.inspectionDate != null)
                return false;
        } else if (!inspectionDate.equals(other.inspectionDate))
            return false;
        if (investigationEndDate == null) {
            if (other.investigationEndDate != null)
                return false;
        } else if (!investigationEndDate.equals(other.investigationEndDate))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (meetsStandardIndicator == null) {
            if (other.meetsStandardIndicator != null)
                return false;
        } else if (!meetsStandardIndicator.equals(other.meetsStandardIndicator))
            return false;
        if (notifierCodeName == null) {
            if (other.notifierCodeName != null)
                return false;
        } else if (!notifierCodeName.equals(other.notifierCodeName))
            return false;
        if (penaltyIndicator == null) {
            if (other.penaltyIndicator != null)
                return false;
        } else if (!penaltyIndicator.equals(other.penaltyIndicator))
            return false;
        if (privateWellsAffected == null) {
            if (other.privateWellsAffected != null)
                return false;
        } else if (!privateWellsAffected.equals(other.privateWellsAffected))
            return false;
        if (programSequenceNum == null) {
            if (other.programSequenceNum != null)
                return false;
        } else if (!programSequenceNum.equals(other.programSequenceNum))
            return false;
        if (publicWellsAffected == null) {
            if (other.publicWellsAffected != null)
                return false;
        } else if (!publicWellsAffected.equals(other.publicWellsAffected))
            return false;
        if (referredTo == null) {
            if (other.referredTo != null)
                return false;
        } else if (!referredTo.equals(other.referredTo))
            return false;
        if (regionalUse == null) {
            if (other.regionalUse != null)
                return false;
        } else if (!regionalUse.equals(other.regionalUse))
            return false;
        if (remedialActionDate == null) {
            if (other.remedialActionDate != null)
                return false;
        } else if (!remedialActionDate.equals(other.remedialActionDate))
            return false;
        if (remedialDesignDate == null) {
            if (other.remedialDesignDate != null)
                return false;
        } else if (!remedialDesignDate.equals(other.remedialDesignDate))
            return false;
        if (remedialPhase == null) {
            if (other.remedialPhase != null)
                return false;
        } else if (!remedialPhase.equals(other.remedialPhase))
            return false;
        if (reportedBy == null) {
            if (other.reportedBy != null)
                return false;
        } else if (!reportedBy.equals(other.reportedBy))
            return false;
        if (responseEndDate == null) {
            if (other.responseEndDate != null)
                return false;
        } else if (!responseEndDate.equals(other.responseEndDate))
            return false;
        if (siteMgmtEndDate == null) {
            if (other.siteMgmtEndDate != null)
                return false;
        } else if (!siteMgmtEndDate.equals(other.siteMgmtEndDate))
            return false;
        if (spillClass == null) {
            if (other.spillClass != null)
                return false;
        } else if (!spillClass.equals(other.spillClass))
            return false;
        if (spillDate == null) {
            if (other.spillDate != null)
                return false;
        } else if (!spillDate.equals(other.spillDate))
            return false;
        if (spillReceivedDate == null) {
            if (other.spillReceivedDate != null)
                return false;
        } else if (!spillReceivedDate.equals(other.spillReceivedDate))
            return false;
        if (spillSequenceNum == null) {
            if (other.spillSequenceNum != null)
                return false;
        } else if (!spillSequenceNum.equals(other.spillSequenceNum))
            return false;
        if (ustTrustIndicator == null) {
            if (other.ustTrustIndicator != null)
                return false;
        } else if (!ustTrustIndicator.equals(other.ustTrustIndicator))
            return false;
        if (waterbody == null) {
            if (other.waterbody != null)
                return false;
        } else if (!waterbody.equals(other.waterbody))
            return false;
        return true;
    }

}