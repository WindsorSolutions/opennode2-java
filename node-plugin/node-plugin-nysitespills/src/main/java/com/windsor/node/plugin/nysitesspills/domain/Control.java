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

public class Control extends BaseSitesSpillsDomainObject {

    private Integer controlSequenceNum;
    private Integer adjacentPropertySequenceNum;
    private Integer controlId;

    private String controlCode;
    private String controlName;
    private String controlSeq;
    private String controlsDescription;
    private String auditSummary;
    private String certComments;

    private Timestamp controlInplaceDate;
    private Timestamp controlEndDate;
    private Timestamp certReceivedDate;
    private Timestamp certNoticeSentDate;
    private Timestamp certDueDate;
    private Timestamp certAcceptDate;
    private Timestamp certNextDate;
    private Timestamp followupLetter;
    private Timestamp enfReferralDate;
    private Timestamp auditDate;

    public String getControlInplaceDateString() {

        return getFormattedDateString(getControlInplaceDate());
    }

    public String getControlEndDateString() {

        return getFormattedDateString(getControlEndDate());
    }

    public String getCertReceivedDateString() {

        return getFormattedDateString(getCertReceivedDate());
    }

    public String getCertNoticeSentDateString() {

        return getFormattedDateString(getCertNoticeSentDate());
    }

    public String getCertDueDateString() {

        return getFormattedDateString(getCertDueDate());
    }

    public String getCertAcceptDateString() {

        return getFormattedDateString(getCertAcceptDate());
    }

    public String getCertNextDateString() {

        return getFormattedDateString(getCertNextDate());
    }

    public String getFollowupLetterString() {

        return getFormattedDateString(getFollowupLetter());
    }

    public String getEnfReferralDateString() {

        return getFormattedDateString(getEnfReferralDate());
    }

    public String getAuditDateString() {

        return getFormattedDateString(getAuditDate());
    }

    public Integer getControlSequenceNum() {
        return controlSequenceNum;
    }

    public void setControlSequenceNum(Integer controlSequenceNum) {
        this.controlSequenceNum = controlSequenceNum;
    }

    public Integer getAdjacentPropertySequenceNum() {
        return adjacentPropertySequenceNum;
    }

    public void setAdjacentPropertySequenceNum(
            Integer adjacentPropertySequenceNum) {
        this.adjacentPropertySequenceNum = adjacentPropertySequenceNum;
    }

    public Integer getControlId() {
        return controlId;
    }

    public void setControlId(Integer controlId) {
        this.controlId = controlId;
    }

    public String getControlCode() {
        return controlCode;
    }

    public void setControlCode(String controlCode) {
        this.controlCode = controlCode;
    }

    public String getControlName() {
        return controlName;
    }

    public void setControlName(String controlName) {
        this.controlName = controlName;
    }

    public String getControlSeq() {
        return controlSeq;
    }

    public void setControlSeq(String controlSeq) {
        this.controlSeq = controlSeq;
    }

    public String getControlsDescription() {
        return controlsDescription;
    }

    public void setControlsDescription(String controlsDescription) {
        this.controlsDescription = controlsDescription;
    }

    public String getAuditSummary() {
        return auditSummary;
    }

    public void setAuditSummary(String auditSummary) {
        this.auditSummary = auditSummary;
    }

    public String getCertComments() {
        return certComments;
    }

    public void setCertComments(String certComments) {
        this.certComments = certComments;
    }

    public Timestamp getControlInplaceDate() {
        return controlInplaceDate;
    }

    public void setControlInplaceDate(Timestamp controlInplaceDate) {
        this.controlInplaceDate = controlInplaceDate;
    }

    public Timestamp getControlEndDate() {
        return controlEndDate;
    }

    public void setControlEndDate(Timestamp controlEndDate) {
        this.controlEndDate = controlEndDate;
    }

    public Timestamp getCertReceivedDate() {
        return certReceivedDate;
    }

    public void setCertReceivedDate(Timestamp certReceivedDate) {
        this.certReceivedDate = certReceivedDate;
    }

    public Timestamp getCertNoticeSentDate() {
        return certNoticeSentDate;
    }

    public void setCertNoticeSentDate(Timestamp certNoticeSentDate) {
        this.certNoticeSentDate = certNoticeSentDate;
    }

    public Timestamp getCertDueDate() {
        return certDueDate;
    }

    public void setCertDueDate(Timestamp certDueDate) {
        this.certDueDate = certDueDate;
    }

    public Timestamp getCertAcceptDate() {
        return certAcceptDate;
    }

    public void setCertAcceptDate(Timestamp certAcceptDate) {
        this.certAcceptDate = certAcceptDate;
    }

    public Timestamp getCertNextDate() {
        return certNextDate;
    }

    public void setCertNextDate(Timestamp certNextDate) {
        this.certNextDate = certNextDate;
    }

    public Timestamp getFollowupLetter() {
        return followupLetter;
    }

    public void setFollowupLetter(Timestamp followupLetter) {
        this.followupLetter = followupLetter;
    }

    public Timestamp getEnfReferralDate() {
        return enfReferralDate;
    }

    public void setEnfReferralDate(Timestamp enfReferralDate) {
        this.enfReferralDate = enfReferralDate;
    }

    public Timestamp getAuditDate() {
        return auditDate;
    }

    public void setAuditDate(Timestamp auditDate) {
        this.auditDate = auditDate;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((adjacentPropertySequenceNum == null) ? 0
                        : adjacentPropertySequenceNum.hashCode());
        result = prime * result
                + ((auditDate == null) ? 0 : auditDate.hashCode());
        result = prime * result
                + ((auditSummary == null) ? 0 : auditSummary.hashCode());
        result = prime * result
                + ((certAcceptDate == null) ? 0 : certAcceptDate.hashCode());
        result = prime * result
                + ((certComments == null) ? 0 : certComments.hashCode());
        result = prime * result
                + ((certDueDate == null) ? 0 : certDueDate.hashCode());
        result = prime * result
                + ((certNextDate == null) ? 0 : certNextDate.hashCode());
        result = prime
                * result
                + ((certNoticeSentDate == null) ? 0 : certNoticeSentDate
                        .hashCode());
        result = prime
                * result
                + ((certReceivedDate == null) ? 0 : certReceivedDate.hashCode());
        result = prime * result
                + ((controlCode == null) ? 0 : controlCode.hashCode());
        result = prime * result
                + ((controlEndDate == null) ? 0 : controlEndDate.hashCode());
        result = prime * result
                + ((controlId == null) ? 0 : controlId.hashCode());
        result = prime
                * result
                + ((controlInplaceDate == null) ? 0 : controlInplaceDate
                        .hashCode());
        result = prime * result
                + ((controlName == null) ? 0 : controlName.hashCode());
        result = prime * result
                + ((controlSeq == null) ? 0 : controlSeq.hashCode());
        result = prime
                * result
                + ((controlSequenceNum == null) ? 0 : controlSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((controlsDescription == null) ? 0 : controlsDescription
                        .hashCode());
        result = prime * result
                + ((enfReferralDate == null) ? 0 : enfReferralDate.hashCode());
        result = prime * result
                + ((followupLetter == null) ? 0 : followupLetter.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Control other = (Control) obj;
        if (adjacentPropertySequenceNum == null) {
            if (other.adjacentPropertySequenceNum != null)
                return false;
        } else if (!adjacentPropertySequenceNum
                .equals(other.adjacentPropertySequenceNum))
            return false;
        if (auditDate == null) {
            if (other.auditDate != null)
                return false;
        } else if (!auditDate.equals(other.auditDate))
            return false;
        if (auditSummary == null) {
            if (other.auditSummary != null)
                return false;
        } else if (!auditSummary.equals(other.auditSummary))
            return false;
        if (certAcceptDate == null) {
            if (other.certAcceptDate != null)
                return false;
        } else if (!certAcceptDate.equals(other.certAcceptDate))
            return false;
        if (certComments == null) {
            if (other.certComments != null)
                return false;
        } else if (!certComments.equals(other.certComments))
            return false;
        if (certDueDate == null) {
            if (other.certDueDate != null)
                return false;
        } else if (!certDueDate.equals(other.certDueDate))
            return false;
        if (certNextDate == null) {
            if (other.certNextDate != null)
                return false;
        } else if (!certNextDate.equals(other.certNextDate))
            return false;
        if (certNoticeSentDate == null) {
            if (other.certNoticeSentDate != null)
                return false;
        } else if (!certNoticeSentDate.equals(other.certNoticeSentDate))
            return false;
        if (certReceivedDate == null) {
            if (other.certReceivedDate != null)
                return false;
        } else if (!certReceivedDate.equals(other.certReceivedDate))
            return false;
        if (controlCode == null) {
            if (other.controlCode != null)
                return false;
        } else if (!controlCode.equals(other.controlCode))
            return false;
        if (controlEndDate == null) {
            if (other.controlEndDate != null)
                return false;
        } else if (!controlEndDate.equals(other.controlEndDate))
            return false;
        if (controlId == null) {
            if (other.controlId != null)
                return false;
        } else if (!controlId.equals(other.controlId))
            return false;
        if (controlInplaceDate == null) {
            if (other.controlInplaceDate != null)
                return false;
        } else if (!controlInplaceDate.equals(other.controlInplaceDate))
            return false;
        if (controlName == null) {
            if (other.controlName != null)
                return false;
        } else if (!controlName.equals(other.controlName))
            return false;
        if (controlSeq == null) {
            if (other.controlSeq != null)
                return false;
        } else if (!controlSeq.equals(other.controlSeq))
            return false;
        if (controlSequenceNum == null) {
            if (other.controlSequenceNum != null)
                return false;
        } else if (!controlSequenceNum.equals(other.controlSequenceNum))
            return false;
        if (controlsDescription == null) {
            if (other.controlsDescription != null)
                return false;
        } else if (!controlsDescription.equals(other.controlsDescription))
            return false;
        if (enfReferralDate == null) {
            if (other.enfReferralDate != null)
                return false;
        } else if (!enfReferralDate.equals(other.enfReferralDate))
            return false;
        if (followupLetter == null) {
            if (other.followupLetter != null)
                return false;
        } else if (!followupLetter.equals(other.followupLetter))
            return false;
        return true;
    }

}