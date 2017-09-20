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

public class ErProject extends BaseSitesSpillsDomainObject {

    private Integer projectsSequenceNum;
    private Integer operableUnitSequenceNum;
    private Integer projectId;

    private String fundingSourceCode;
    private String fundingSourceDescription;
    private String projectTypeCode;
    private String projectTypeDescription;
    private String sequenceNum;
    private String referName;
    private String startStatus;
    private String endStatus;
    private String revisedStartStatus;
    private String revisedEndStatus;
    private String revisedReason;
    private String currentStartStatus;
    private String currentEndStatus;
    private String projectManager;
    private String leadAgency;
    private String leadDivision;
    private String leadBureau;
    private String leadOffice;
    private String projectDescription;
    private String projectNotes;
    private String currentStatus;

    private Timestamp baseStartDate;
    private Timestamp baseEndDate;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp revisedStartDate;
    private Timestamp revisedEndDate;
    private Timestamp currentStartDate;
    private Timestamp currentEndDate;

    public String getBaseStartDateString() {

        return getFormattedDateString(getBaseStartDate());
    }

    public String getBaseEndDateString() {

        return getFormattedDateString(getBaseEndDate());
    }

    public String getStartDateString() {

        return getFormattedDateString(getStartDate());
    }

    public String getEndDateString() {

        return getFormattedDateString(getEndDate());
    }

    public String getRevisedStartDateString() {

        return getFormattedDateString(getRevisedStartDate());
    }

    public String getRevisedEndDateString() {

        return getFormattedDateString(getRevisedEndDate());
    }

    public String getCurrentStartDateString() {

        return getFormattedDateString(getCurrentStartDate());
    }

    public String getCurrentEndDateString() {

        return getFormattedDateString(getCurrentEndDate());
    }

    public Integer getProjectsSequenceNum() {
        return projectsSequenceNum;
    }

    public void setProjectsSequenceNum(Integer projectsSequenceNum) {
        this.projectsSequenceNum = projectsSequenceNum;
    }

    public Integer getOperableUnitSequenceNum() {
        return operableUnitSequenceNum;
    }

    public void setOperableUnitSequenceNum(Integer operableUnitSequenceNum) {
        this.operableUnitSequenceNum = operableUnitSequenceNum;
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getFundingSourceCode() {
        return fundingSourceCode;
    }

    public void setFundingSourceCode(String fundingSourceCode) {
        this.fundingSourceCode = fundingSourceCode;
    }

    public String getFundingSourceDescription() {
        return fundingSourceDescription;
    }

    public void setFundingSourceDescription(String fundingSourceDescription) {
        this.fundingSourceDescription = fundingSourceDescription;
    }

    public String getProjectTypeCode() {
        return projectTypeCode;
    }

    public void setProjectTypeCode(String projectTypeCode) {
        this.projectTypeCode = projectTypeCode;
    }

    public String getProjectTypeDescription() {
        return projectTypeDescription;
    }

    public void setProjectTypeDescription(String projectTypeDescription) {
        this.projectTypeDescription = projectTypeDescription;
    }

    public String getSequenceNum() {
        return sequenceNum;
    }

    public void setSequenceNum(String sequenceNum) {
        this.sequenceNum = sequenceNum;
    }

    public String getReferName() {
        return referName;
    }

    public void setReferName(String referName) {
        this.referName = referName;
    }

    public String getStartStatus() {
        return startStatus;
    }

    public void setStartStatus(String startStatus) {
        this.startStatus = startStatus;
    }

    public String getEndStatus() {
        return endStatus;
    }

    public void setEndStatus(String endStatus) {
        this.endStatus = endStatus;
    }

    public String getRevisedStartStatus() {
        return revisedStartStatus;
    }

    public void setRevisedStartStatus(String revisedStartStatus) {
        this.revisedStartStatus = revisedStartStatus;
    }

    public String getRevisedEndStatus() {
        return revisedEndStatus;
    }

    public void setRevisedEndStatus(String revisedEndStatus) {
        this.revisedEndStatus = revisedEndStatus;
    }

    public String getRevisedReason() {
        return revisedReason;
    }

    public void setRevisedReason(String revisedReason) {
        this.revisedReason = revisedReason;
    }

    public String getCurrentStartStatus() {
        return currentStartStatus;
    }

    public void setCurrentStartStatus(String currentStartStatus) {
        this.currentStartStatus = currentStartStatus;
    }

    public String getCurrentEndStatus() {
        return currentEndStatus;
    }

    public void setCurrentEndStatus(String currentEndStatus) {
        this.currentEndStatus = currentEndStatus;
    }

    public String getProjectManager() {
        return projectManager;
    }

    public void setProjectManager(String projectManager) {
        this.projectManager = projectManager;
    }

    public String getLeadAgency() {
        return leadAgency;
    }

    public void setLeadAgency(String leadAgency) {
        this.leadAgency = leadAgency;
    }

    public String getLeadDivision() {
        return leadDivision;
    }

    public void setLeadDivision(String leadDivision) {
        this.leadDivision = leadDivision;
    }

    public String getLeadBureau() {
        return leadBureau;
    }

    public void setLeadBureau(String leadBureau) {
        this.leadBureau = leadBureau;
    }

    public String getLeadOffice() {
        return leadOffice;
    }

    public void setLeadOffice(String leadOffice) {
        this.leadOffice = leadOffice;
    }

    public String getProjectDescription() {
        return projectDescription;
    }

    public void setProjectDescription(String projectDescription) {
        this.projectDescription = projectDescription;
    }

    public String getProjectNotes() {
        return projectNotes;
    }

    public void setProjectNotes(String projectNotes) {
        this.projectNotes = projectNotes;
    }

    public String getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(String currentStatus) {
        this.currentStatus = currentStatus;
    }

    public Timestamp getBaseStartDate() {
        return baseStartDate;
    }

    public void setBaseStartDate(Timestamp baseStartDate) {
        this.baseStartDate = baseStartDate;
    }

    public Timestamp getBaseEndDate() {
        return baseEndDate;
    }

    public void setBaseEndDate(Timestamp baseEndDate) {
        this.baseEndDate = baseEndDate;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Timestamp getRevisedStartDate() {
        return revisedStartDate;
    }

    public void setRevisedStartDate(Timestamp revisedStartDate) {
        this.revisedStartDate = revisedStartDate;
    }

    public Timestamp getRevisedEndDate() {
        return revisedEndDate;
    }

    public void setRevisedEndDate(Timestamp revisedEndDate) {
        this.revisedEndDate = revisedEndDate;
    }

    public Timestamp getCurrentStartDate() {
        return currentStartDate;
    }

    public void setCurrentStartDate(Timestamp currentStartDate) {
        this.currentStartDate = currentStartDate;
    }

    public Timestamp getCurrentEndDate() {
        return currentEndDate;
    }

    public void setCurrentEndDate(Timestamp currentEndDate) {
        this.currentEndDate = currentEndDate;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((baseEndDate == null) ? 0 : baseEndDate.hashCode());
        result = prime * result
                + ((baseStartDate == null) ? 0 : baseStartDate.hashCode());
        result = prime * result
                + ((currentEndDate == null) ? 0 : currentEndDate.hashCode());
        result = prime
                * result
                + ((currentEndStatus == null) ? 0 : currentEndStatus.hashCode());
        result = prime
                * result
                + ((currentStartDate == null) ? 0 : currentStartDate.hashCode());
        result = prime
                * result
                + ((currentStartStatus == null) ? 0 : currentStartStatus
                        .hashCode());
        result = prime * result
                + ((currentStatus == null) ? 0 : currentStatus.hashCode());
        result = prime * result + ((endDate == null) ? 0 : endDate.hashCode());
        result = prime * result
                + ((endStatus == null) ? 0 : endStatus.hashCode());
        result = prime
                * result
                + ((fundingSourceCode == null) ? 0 : fundingSourceCode
                        .hashCode());
        result = prime
                * result
                + ((fundingSourceDescription == null) ? 0
                        : fundingSourceDescription.hashCode());
        result = prime * result
                + ((leadAgency == null) ? 0 : leadAgency.hashCode());
        result = prime * result
                + ((leadBureau == null) ? 0 : leadBureau.hashCode());
        result = prime * result
                + ((leadDivision == null) ? 0 : leadDivision.hashCode());
        result = prime * result
                + ((leadOffice == null) ? 0 : leadOffice.hashCode());
        result = prime
                * result
                + ((operableUnitSequenceNum == null) ? 0
                        : operableUnitSequenceNum.hashCode());
        result = prime
                * result
                + ((projectDescription == null) ? 0 : projectDescription
                        .hashCode());
        result = prime * result
                + ((projectId == null) ? 0 : projectId.hashCode());
        result = prime * result
                + ((projectManager == null) ? 0 : projectManager.hashCode());
        result = prime * result
                + ((projectNotes == null) ? 0 : projectNotes.hashCode());
        result = prime * result
                + ((projectTypeCode == null) ? 0 : projectTypeCode.hashCode());
        result = prime
                * result
                + ((projectTypeDescription == null) ? 0
                        : projectTypeDescription.hashCode());
        result = prime
                * result
                + ((projectsSequenceNum == null) ? 0 : projectsSequenceNum
                        .hashCode());
        result = prime * result
                + ((referName == null) ? 0 : referName.hashCode());
        result = prime * result
                + ((revisedEndDate == null) ? 0 : revisedEndDate.hashCode());
        result = prime
                * result
                + ((revisedEndStatus == null) ? 0 : revisedEndStatus.hashCode());
        result = prime * result
                + ((revisedReason == null) ? 0 : revisedReason.hashCode());
        result = prime
                * result
                + ((revisedStartDate == null) ? 0 : revisedStartDate.hashCode());
        result = prime
                * result
                + ((revisedStartStatus == null) ? 0 : revisedStartStatus
                        .hashCode());
        result = prime * result
                + ((sequenceNum == null) ? 0 : sequenceNum.hashCode());
        result = prime * result
                + ((startDate == null) ? 0 : startDate.hashCode());
        result = prime * result
                + ((startStatus == null) ? 0 : startStatus.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ErProject other = (ErProject) obj;
        if (baseEndDate == null) {
            if (other.baseEndDate != null)
                return false;
        } else if (!baseEndDate.equals(other.baseEndDate))
            return false;
        if (baseStartDate == null) {
            if (other.baseStartDate != null)
                return false;
        } else if (!baseStartDate.equals(other.baseStartDate))
            return false;
        if (currentEndDate == null) {
            if (other.currentEndDate != null)
                return false;
        } else if (!currentEndDate.equals(other.currentEndDate))
            return false;
        if (currentEndStatus == null) {
            if (other.currentEndStatus != null)
                return false;
        } else if (!currentEndStatus.equals(other.currentEndStatus))
            return false;
        if (currentStartDate == null) {
            if (other.currentStartDate != null)
                return false;
        } else if (!currentStartDate.equals(other.currentStartDate))
            return false;
        if (currentStartStatus == null) {
            if (other.currentStartStatus != null)
                return false;
        } else if (!currentStartStatus.equals(other.currentStartStatus))
            return false;
        if (currentStatus == null) {
            if (other.currentStatus != null)
                return false;
        } else if (!currentStatus.equals(other.currentStatus))
            return false;
        if (endDate == null) {
            if (other.endDate != null)
                return false;
        } else if (!endDate.equals(other.endDate))
            return false;
        if (endStatus == null) {
            if (other.endStatus != null)
                return false;
        } else if (!endStatus.equals(other.endStatus))
            return false;
        if (fundingSourceCode == null) {
            if (other.fundingSourceCode != null)
                return false;
        } else if (!fundingSourceCode.equals(other.fundingSourceCode))
            return false;
        if (fundingSourceDescription == null) {
            if (other.fundingSourceDescription != null)
                return false;
        } else if (!fundingSourceDescription
                .equals(other.fundingSourceDescription))
            return false;
        if (leadAgency == null) {
            if (other.leadAgency != null)
                return false;
        } else if (!leadAgency.equals(other.leadAgency))
            return false;
        if (leadBureau == null) {
            if (other.leadBureau != null)
                return false;
        } else if (!leadBureau.equals(other.leadBureau))
            return false;
        if (leadDivision == null) {
            if (other.leadDivision != null)
                return false;
        } else if (!leadDivision.equals(other.leadDivision))
            return false;
        if (leadOffice == null) {
            if (other.leadOffice != null)
                return false;
        } else if (!leadOffice.equals(other.leadOffice))
            return false;
        if (operableUnitSequenceNum == null) {
            if (other.operableUnitSequenceNum != null)
                return false;
        } else if (!operableUnitSequenceNum
                .equals(other.operableUnitSequenceNum))
            return false;
        if (projectDescription == null) {
            if (other.projectDescription != null)
                return false;
        } else if (!projectDescription.equals(other.projectDescription))
            return false;
        if (projectId == null) {
            if (other.projectId != null)
                return false;
        } else if (!projectId.equals(other.projectId))
            return false;
        if (projectManager == null) {
            if (other.projectManager != null)
                return false;
        } else if (!projectManager.equals(other.projectManager))
            return false;
        if (projectNotes == null) {
            if (other.projectNotes != null)
                return false;
        } else if (!projectNotes.equals(other.projectNotes))
            return false;
        if (projectTypeCode == null) {
            if (other.projectTypeCode != null)
                return false;
        } else if (!projectTypeCode.equals(other.projectTypeCode))
            return false;
        if (projectTypeDescription == null) {
            if (other.projectTypeDescription != null)
                return false;
        } else if (!projectTypeDescription.equals(other.projectTypeDescription))
            return false;
        if (projectsSequenceNum == null) {
            if (other.projectsSequenceNum != null)
                return false;
        } else if (!projectsSequenceNum.equals(other.projectsSequenceNum))
            return false;
        if (referName == null) {
            if (other.referName != null)
                return false;
        } else if (!referName.equals(other.referName))
            return false;
        if (revisedEndDate == null) {
            if (other.revisedEndDate != null)
                return false;
        } else if (!revisedEndDate.equals(other.revisedEndDate))
            return false;
        if (revisedEndStatus == null) {
            if (other.revisedEndStatus != null)
                return false;
        } else if (!revisedEndStatus.equals(other.revisedEndStatus))
            return false;
        if (revisedReason == null) {
            if (other.revisedReason != null)
                return false;
        } else if (!revisedReason.equals(other.revisedReason))
            return false;
        if (revisedStartDate == null) {
            if (other.revisedStartDate != null)
                return false;
        } else if (!revisedStartDate.equals(other.revisedStartDate))
            return false;
        if (revisedStartStatus == null) {
            if (other.revisedStartStatus != null)
                return false;
        } else if (!revisedStartStatus.equals(other.revisedStartStatus))
            return false;
        if (sequenceNum == null) {
            if (other.sequenceNum != null)
                return false;
        } else if (!sequenceNum.equals(other.sequenceNum))
            return false;
        if (startDate == null) {
            if (other.startDate != null)
                return false;
        } else if (!startDate.equals(other.startDate))
            return false;
        if (startStatus == null) {
            if (other.startStatus != null)
                return false;
        } else if (!startStatus.equals(other.startStatus))
            return false;
        return true;
    }

}