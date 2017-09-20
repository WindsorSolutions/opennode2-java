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

public class ErClassChange extends BaseSitesSpillsDomainObject {

    private Integer classChangeSequenceNum;
    private Integer siteSequenceNum;
    private Integer classChangeId;

    private String hwCode;
    private String classChangeSeqNbr;
    private String initiatedBy;
    private String section;
    private String actionRequested;
    private String comments;
    private String siteName;
    private String classChangeType;

    private Timestamp dateChangeReceived;
    private Timestamp sectionApproveDate;
    private Timestamp deeApproveDate;
    private Timestamp dohApproveDate;
    private Timestamp remApproveDate;
    private Timestamp bureauApproveDate;
    private Timestamp holdStartDate;
    private Timestamp completionDate;
    private Timestamp regionApproveDate;
    private Timestamp secChiefApproveDate;
    private Timestamp dueDate;
    private Timestamp engineerSignDate;
    private Timestamp asstDivDirDate;
    private Timestamp pkgHoldDate;
    private Timestamp finalizedDate;

    public String getDateChangeReceivedString() {

        return getFormattedDateString(getDateChangeReceived());
    }

    public String getSectionApproveDateString() {

        return getFormattedDateString(getSectionApproveDate());
    }

    public String getDeeApproveDateString() {

        return getFormattedDateString(getDeeApproveDate());
    }

    public String getDohApproveDateString() {

        return getFormattedDateString(getDohApproveDate());
    }

    public String getRemApproveDateString() {

        return getFormattedDateString(getRemApproveDate());
    }

    public String getBureauApproveDateString() {

        return getFormattedDateString(getBureauApproveDate());
    }

    public String getHoldStartDateString() {

        return getFormattedDateString(getHoldStartDate());
    }

    public String getCompletionDateString() {

        return getFormattedDateString(getCompletionDate());
    }

    public String getRegionApproveDateString() {

        return getFormattedDateString(getRegionApproveDate());
    }

    public String getSecChiefApproveDateString() {

        return getFormattedDateString(getSecChiefApproveDate());
    }

    public String getDueDateString() {

        return getFormattedDateString(getDueDate());
    }

    public String getEngineerSignDateString() {

        return getFormattedDateString(getEngineerSignDate());
    }

    public String getAsstDivDirDateString() {

        return getFormattedDateString(getAsstDivDirDate());
    }

    public String getPkgHoldDateString() {

        return getFormattedDateString(getPkgHoldDate());
    }

    public String getFinalizedDateString() {

        return getFormattedDateString(getFinalizedDate());
    }

    public Integer getClassChangeSequenceNum() {
        return classChangeSequenceNum;
    }

    public void setClassChangeSequenceNum(Integer classChangeSequenceNum) {
        this.classChangeSequenceNum = classChangeSequenceNum;
    }

    public Integer getSiteSequenceNum() {
        return siteSequenceNum;
    }

    public void setSiteSequenceNum(Integer siteSequenceNum) {
        this.siteSequenceNum = siteSequenceNum;
    }

    public Integer getClassChangeId() {
        return classChangeId;
    }

    public void setClassChangeId(Integer classChangeId) {
        this.classChangeId = classChangeId;
    }

    public String getHwCode() {
        return hwCode;
    }

    public void setHwCode(String hwCode) {
        this.hwCode = hwCode;
    }

    public String getClassChangeSeqNbr() {
        return classChangeSeqNbr;
    }

    public void setClassChangeSeqNbr(String classChangeSeqNbr) {
        this.classChangeSeqNbr = classChangeSeqNbr;
    }

    public String getInitiatedBy() {
        return initiatedBy;
    }

    public void setInitiatedBy(String initiatedBy) {
        this.initiatedBy = initiatedBy;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public String getActionRequested() {
        return actionRequested;
    }

    public void setActionRequested(String actionRequested) {
        this.actionRequested = actionRequested;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getClassChangeType() {
        return classChangeType;
    }

    public void setClassChangeType(String classChangeType) {
        this.classChangeType = classChangeType;
    }

    public Timestamp getDateChangeReceived() {
        return dateChangeReceived;
    }

    public void setDateChangeReceived(Timestamp dateChangeReceived) {
        this.dateChangeReceived = dateChangeReceived;
    }

    public Timestamp getSectionApproveDate() {
        return sectionApproveDate;
    }

    public void setSectionApproveDate(Timestamp sectionApproveDate) {
        this.sectionApproveDate = sectionApproveDate;
    }

    public Timestamp getDeeApproveDate() {
        return deeApproveDate;
    }

    public void setDeeApproveDate(Timestamp deeApproveDate) {
        this.deeApproveDate = deeApproveDate;
    }

    public Timestamp getDohApproveDate() {
        return dohApproveDate;
    }

    public void setDohApproveDate(Timestamp dohApproveDate) {
        this.dohApproveDate = dohApproveDate;
    }

    public Timestamp getRemApproveDate() {
        return remApproveDate;
    }

    public void setRemApproveDate(Timestamp remApproveDate) {
        this.remApproveDate = remApproveDate;
    }

    public Timestamp getBureauApproveDate() {
        return bureauApproveDate;
    }

    public void setBureauApproveDate(Timestamp bureauApproveDate) {
        this.bureauApproveDate = bureauApproveDate;
    }

    public Timestamp getHoldStartDate() {
        return holdStartDate;
    }

    public void setHoldStartDate(Timestamp holdStartDate) {
        this.holdStartDate = holdStartDate;
    }

    public Timestamp getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(Timestamp completionDate) {
        this.completionDate = completionDate;
    }

    public Timestamp getRegionApproveDate() {
        return regionApproveDate;
    }

    public void setRegionApproveDate(Timestamp regionApproveDate) {
        this.regionApproveDate = regionApproveDate;
    }

    public Timestamp getSecChiefApproveDate() {
        return secChiefApproveDate;
    }

    public void setSecChiefApproveDate(Timestamp secChiefApproveDate) {
        this.secChiefApproveDate = secChiefApproveDate;
    }

    public Timestamp getDueDate() {
        return dueDate;
    }

    public void setDueDate(Timestamp dueDate) {
        this.dueDate = dueDate;
    }

    public Timestamp getEngineerSignDate() {
        return engineerSignDate;
    }

    public void setEngineerSignDate(Timestamp engineerSignDate) {
        this.engineerSignDate = engineerSignDate;
    }

    public Timestamp getAsstDivDirDate() {
        return asstDivDirDate;
    }

    public void setAsstDivDirDate(Timestamp asstDivDirDate) {
        this.asstDivDirDate = asstDivDirDate;
    }

    public Timestamp getPkgHoldDate() {
        return pkgHoldDate;
    }

    public void setPkgHoldDate(Timestamp pkgHoldDate) {
        this.pkgHoldDate = pkgHoldDate;
    }

    public Timestamp getFinalizedDate() {
        return finalizedDate;
    }

    public void setFinalizedDate(Timestamp finalizedDate) {
        this.finalizedDate = finalizedDate;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((actionRequested == null) ? 0 : actionRequested.hashCode());
        result = prime * result
                + ((asstDivDirDate == null) ? 0 : asstDivDirDate.hashCode());
        result = prime
                * result
                + ((bureauApproveDate == null) ? 0 : bureauApproveDate
                        .hashCode());
        result = prime * result
                + ((classChangeId == null) ? 0 : classChangeId.hashCode());
        result = prime
                * result
                + ((classChangeSeqNbr == null) ? 0 : classChangeSeqNbr
                        .hashCode());
        result = prime
                * result
                + ((classChangeSequenceNum == null) ? 0
                        : classChangeSequenceNum.hashCode());
        result = prime * result
                + ((classChangeType == null) ? 0 : classChangeType.hashCode());
        result = prime * result
                + ((comments == null) ? 0 : comments.hashCode());
        result = prime * result
                + ((completionDate == null) ? 0 : completionDate.hashCode());
        result = prime
                * result
                + ((dateChangeReceived == null) ? 0 : dateChangeReceived
                        .hashCode());
        result = prime * result
                + ((deeApproveDate == null) ? 0 : deeApproveDate.hashCode());
        result = prime * result
                + ((dohApproveDate == null) ? 0 : dohApproveDate.hashCode());
        result = prime * result + ((dueDate == null) ? 0 : dueDate.hashCode());
        result = prime
                * result
                + ((engineerSignDate == null) ? 0 : engineerSignDate.hashCode());
        result = prime * result
                + ((finalizedDate == null) ? 0 : finalizedDate.hashCode());
        result = prime * result
                + ((holdStartDate == null) ? 0 : holdStartDate.hashCode());
        result = prime * result + ((hwCode == null) ? 0 : hwCode.hashCode());
        result = prime * result
                + ((initiatedBy == null) ? 0 : initiatedBy.hashCode());
        result = prime * result
                + ((pkgHoldDate == null) ? 0 : pkgHoldDate.hashCode());
        result = prime
                * result
                + ((regionApproveDate == null) ? 0 : regionApproveDate
                        .hashCode());
        result = prime * result
                + ((remApproveDate == null) ? 0 : remApproveDate.hashCode());
        result = prime
                * result
                + ((secChiefApproveDate == null) ? 0 : secChiefApproveDate
                        .hashCode());
        result = prime * result + ((section == null) ? 0 : section.hashCode());
        result = prime
                * result
                + ((sectionApproveDate == null) ? 0 : sectionApproveDate
                        .hashCode());
        result = prime * result
                + ((siteName == null) ? 0 : siteName.hashCode());
        result = prime * result
                + ((siteSequenceNum == null) ? 0 : siteSequenceNum.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ErClassChange other = (ErClassChange) obj;
        if (actionRequested == null) {
            if (other.actionRequested != null)
                return false;
        } else if (!actionRequested.equals(other.actionRequested))
            return false;
        if (asstDivDirDate == null) {
            if (other.asstDivDirDate != null)
                return false;
        } else if (!asstDivDirDate.equals(other.asstDivDirDate))
            return false;
        if (bureauApproveDate == null) {
            if (other.bureauApproveDate != null)
                return false;
        } else if (!bureauApproveDate.equals(other.bureauApproveDate))
            return false;
        if (classChangeId == null) {
            if (other.classChangeId != null)
                return false;
        } else if (!classChangeId.equals(other.classChangeId))
            return false;
        if (classChangeSeqNbr == null) {
            if (other.classChangeSeqNbr != null)
                return false;
        } else if (!classChangeSeqNbr.equals(other.classChangeSeqNbr))
            return false;
        if (classChangeSequenceNum == null) {
            if (other.classChangeSequenceNum != null)
                return false;
        } else if (!classChangeSequenceNum.equals(other.classChangeSequenceNum))
            return false;
        if (classChangeType == null) {
            if (other.classChangeType != null)
                return false;
        } else if (!classChangeType.equals(other.classChangeType))
            return false;
        if (comments == null) {
            if (other.comments != null)
                return false;
        } else if (!comments.equals(other.comments))
            return false;
        if (completionDate == null) {
            if (other.completionDate != null)
                return false;
        } else if (!completionDate.equals(other.completionDate))
            return false;
        if (dateChangeReceived == null) {
            if (other.dateChangeReceived != null)
                return false;
        } else if (!dateChangeReceived.equals(other.dateChangeReceived))
            return false;
        if (deeApproveDate == null) {
            if (other.deeApproveDate != null)
                return false;
        } else if (!deeApproveDate.equals(other.deeApproveDate))
            return false;
        if (dohApproveDate == null) {
            if (other.dohApproveDate != null)
                return false;
        } else if (!dohApproveDate.equals(other.dohApproveDate))
            return false;
        if (dueDate == null) {
            if (other.dueDate != null)
                return false;
        } else if (!dueDate.equals(other.dueDate))
            return false;
        if (engineerSignDate == null) {
            if (other.engineerSignDate != null)
                return false;
        } else if (!engineerSignDate.equals(other.engineerSignDate))
            return false;
        if (finalizedDate == null) {
            if (other.finalizedDate != null)
                return false;
        } else if (!finalizedDate.equals(other.finalizedDate))
            return false;
        if (holdStartDate == null) {
            if (other.holdStartDate != null)
                return false;
        } else if (!holdStartDate.equals(other.holdStartDate))
            return false;
        if (hwCode == null) {
            if (other.hwCode != null)
                return false;
        } else if (!hwCode.equals(other.hwCode))
            return false;
        if (initiatedBy == null) {
            if (other.initiatedBy != null)
                return false;
        } else if (!initiatedBy.equals(other.initiatedBy))
            return false;
        if (pkgHoldDate == null) {
            if (other.pkgHoldDate != null)
                return false;
        } else if (!pkgHoldDate.equals(other.pkgHoldDate))
            return false;
        if (regionApproveDate == null) {
            if (other.regionApproveDate != null)
                return false;
        } else if (!regionApproveDate.equals(other.regionApproveDate))
            return false;
        if (remApproveDate == null) {
            if (other.remApproveDate != null)
                return false;
        } else if (!remApproveDate.equals(other.remApproveDate))
            return false;
        if (secChiefApproveDate == null) {
            if (other.secChiefApproveDate != null)
                return false;
        } else if (!secChiefApproveDate.equals(other.secChiefApproveDate))
            return false;
        if (section == null) {
            if (other.section != null)
                return false;
        } else if (!section.equals(other.section))
            return false;
        if (sectionApproveDate == null) {
            if (other.sectionApproveDate != null)
                return false;
        } else if (!sectionApproveDate.equals(other.sectionApproveDate))
            return false;
        if (siteName == null) {
            if (other.siteName != null)
                return false;
        } else if (!siteName.equals(other.siteName))
            return false;
        if (siteSequenceNum == null) {
            if (other.siteSequenceNum != null)
                return false;
        } else if (!siteSequenceNum.equals(other.siteSequenceNum))
            return false;
        return true;
    }

}