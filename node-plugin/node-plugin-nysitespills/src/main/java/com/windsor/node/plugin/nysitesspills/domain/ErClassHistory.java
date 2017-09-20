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

public class ErClassHistory extends BaseSitesSpillsDomainObject {

    private Integer classHistorySequenceNum;
    private Integer siteSequenceNum;

    private String classHistSeqNbr;
    private String siteName;
    private String oldClass;
    private String newClass;
    private String projectManager;
    private String pmAddress;
    private String pmCity;
    private String pmState;
    private String pmZipCode;
    private String pmPhone;
    private String commentType;
    private String comments;
    private String scsComments;

    private Timestamp requestDate;
    private Timestamp changeAddedDate;
    private Timestamp bcpIncompleteAppDate;
    private Timestamp finalizedDate;

    public String getRequestDateString() {

        return getFormattedDateString(getRequestDate());
    }

    public String getChangeAddedDateString() {

        return getFormattedDateString(getChangeAddedDate());
    }

    public String getBcpIncompleteAppDateString() {

        return getFormattedDateString(getBcpIncompleteAppDate());
    }

    public String getFinalizedDateString() {

        return getFormattedDateString(getFinalizedDate());
    }

    public Integer getClassHistorySequenceNum() {
        return classHistorySequenceNum;
    }

    public void setClassHistorySequenceNum(Integer classHistorySequenceNum) {
        this.classHistorySequenceNum = classHistorySequenceNum;
    }

    public Integer getSiteSequenceNum() {
        return siteSequenceNum;
    }

    public void setSiteSequenceNum(Integer siteSequenceNum) {
        this.siteSequenceNum = siteSequenceNum;
    }

    public String getClassHistSeqNbr() {
        return classHistSeqNbr;
    }

    public void setClassHistSeqNbr(String classHistSeqNbr) {
        this.classHistSeqNbr = classHistSeqNbr;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getOldClass() {
        return oldClass;
    }

    public void setOldClass(String oldClass) {
        this.oldClass = oldClass;
    }

    public String getNewClass() {
        return newClass;
    }

    public void setNewClass(String newClass) {
        this.newClass = newClass;
    }

    public String getProjectManager() {
        return projectManager;
    }

    public void setProjectManager(String projectManager) {
        this.projectManager = projectManager;
    }

    public String getPmAddress() {
        return pmAddress;
    }

    public void setPmAddress(String pmAddress) {
        this.pmAddress = pmAddress;
    }

    public String getPmCity() {
        return pmCity;
    }

    public void setPmCity(String pmCity) {
        this.pmCity = pmCity;
    }

    public String getPmState() {
        return pmState;
    }

    public void setPmState(String pmState) {
        this.pmState = pmState;
    }

    public String getPmZipCode() {
        return pmZipCode;
    }

    public void setPmZipCode(String pmZipCode) {
        this.pmZipCode = pmZipCode;
    }

    public String getPmPhone() {
        return pmPhone;
    }

    public void setPmPhone(String pmPhone) {
        this.pmPhone = pmPhone;
    }

    public String getCommentType() {
        return commentType;
    }

    public void setCommentType(String commentType) {
        this.commentType = commentType;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getScsComments() {
        return scsComments;
    }

    public void setScsComments(String scsComments) {
        this.scsComments = scsComments;
    }

    public Timestamp getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Timestamp requestDate) {
        this.requestDate = requestDate;
    }

    public Timestamp getChangeAddedDate() {
        return changeAddedDate;
    }

    public void setChangeAddedDate(Timestamp changeAddedDate) {
        this.changeAddedDate = changeAddedDate;
    }

    public Timestamp getBcpIncompleteAppDate() {
        return bcpIncompleteAppDate;
    }

    public void setBcpIncompleteAppDate(Timestamp bcpIncompleteAppDate) {
        this.bcpIncompleteAppDate = bcpIncompleteAppDate;
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
        result = prime
                * result
                + ((bcpIncompleteAppDate == null) ? 0 : bcpIncompleteAppDate
                        .hashCode());
        result = prime * result
                + ((changeAddedDate == null) ? 0 : changeAddedDate.hashCode());
        result = prime * result
                + ((classHistSeqNbr == null) ? 0 : classHistSeqNbr.hashCode());
        result = prime
                * result
                + ((classHistorySequenceNum == null) ? 0
                        : classHistorySequenceNum.hashCode());
        result = prime * result
                + ((commentType == null) ? 0 : commentType.hashCode());
        result = prime * result
                + ((comments == null) ? 0 : comments.hashCode());
        result = prime * result
                + ((finalizedDate == null) ? 0 : finalizedDate.hashCode());
        result = prime * result
                + ((newClass == null) ? 0 : newClass.hashCode());
        result = prime * result
                + ((oldClass == null) ? 0 : oldClass.hashCode());
        result = prime * result
                + ((pmAddress == null) ? 0 : pmAddress.hashCode());
        result = prime * result + ((pmCity == null) ? 0 : pmCity.hashCode());
        result = prime * result + ((pmPhone == null) ? 0 : pmPhone.hashCode());
        result = prime * result + ((pmState == null) ? 0 : pmState.hashCode());
        result = prime * result
                + ((pmZipCode == null) ? 0 : pmZipCode.hashCode());
        result = prime * result
                + ((projectManager == null) ? 0 : projectManager.hashCode());
        result = prime * result
                + ((requestDate == null) ? 0 : requestDate.hashCode());
        result = prime * result
                + ((scsComments == null) ? 0 : scsComments.hashCode());
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
        ErClassHistory other = (ErClassHistory) obj;
        if (bcpIncompleteAppDate == null) {
            if (other.bcpIncompleteAppDate != null)
                return false;
        } else if (!bcpIncompleteAppDate.equals(other.bcpIncompleteAppDate))
            return false;
        if (changeAddedDate == null) {
            if (other.changeAddedDate != null)
                return false;
        } else if (!changeAddedDate.equals(other.changeAddedDate))
            return false;
        if (classHistSeqNbr == null) {
            if (other.classHistSeqNbr != null)
                return false;
        } else if (!classHistSeqNbr.equals(other.classHistSeqNbr))
            return false;
        if (classHistorySequenceNum == null) {
            if (other.classHistorySequenceNum != null)
                return false;
        } else if (!classHistorySequenceNum
                .equals(other.classHistorySequenceNum))
            return false;
        if (commentType == null) {
            if (other.commentType != null)
                return false;
        } else if (!commentType.equals(other.commentType))
            return false;
        if (comments == null) {
            if (other.comments != null)
                return false;
        } else if (!comments.equals(other.comments))
            return false;
        if (finalizedDate == null) {
            if (other.finalizedDate != null)
                return false;
        } else if (!finalizedDate.equals(other.finalizedDate))
            return false;
        if (newClass == null) {
            if (other.newClass != null)
                return false;
        } else if (!newClass.equals(other.newClass))
            return false;
        if (oldClass == null) {
            if (other.oldClass != null)
                return false;
        } else if (!oldClass.equals(other.oldClass))
            return false;
        if (pmAddress == null) {
            if (other.pmAddress != null)
                return false;
        } else if (!pmAddress.equals(other.pmAddress))
            return false;
        if (pmCity == null) {
            if (other.pmCity != null)
                return false;
        } else if (!pmCity.equals(other.pmCity))
            return false;
        if (pmPhone == null) {
            if (other.pmPhone != null)
                return false;
        } else if (!pmPhone.equals(other.pmPhone))
            return false;
        if (pmState == null) {
            if (other.pmState != null)
                return false;
        } else if (!pmState.equals(other.pmState))
            return false;
        if (pmZipCode == null) {
            if (other.pmZipCode != null)
                return false;
        } else if (!pmZipCode.equals(other.pmZipCode))
            return false;
        if (projectManager == null) {
            if (other.projectManager != null)
                return false;
        } else if (!projectManager.equals(other.projectManager))
            return false;
        if (requestDate == null) {
            if (other.requestDate != null)
                return false;
        } else if (!requestDate.equals(other.requestDate))
            return false;
        if (scsComments == null) {
            if (other.scsComments != null)
                return false;
        } else if (!scsComments.equals(other.scsComments))
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