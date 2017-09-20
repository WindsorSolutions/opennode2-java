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

public class ErRemedy extends BaseSitesSpillsDomainObject {

    private Integer remedySequenceNum;
    private Integer opUnitSequenceNum;
    private Integer parcelsMitigated;
    private Integer maxParcelsMitigated;

    private String remedyCode;
    private String remedyName;
    private String remedyType;
    private String description;
    private String remedyEffective;
    private String remedySizeCode;
    private String remedySizeName;
    private String comments;

    private Timestamp inPlaceDate;
    private Timestamp completionDate;

    public String getInPlaceDateString() {

        return getFormattedDateString(getInPlaceDate());
    }

    public String getCompletionDateString() {

        return getFormattedDateString(getCompletionDate());
    }

    public Integer getRemedySequenceNum() {
        return remedySequenceNum;
    }

    public void setRemedySequenceNum(Integer remedySequenceNum) {
        this.remedySequenceNum = remedySequenceNum;
    }

    public Integer getOpUnitSequenceNum() {
        return opUnitSequenceNum;
    }

    public void setOpUnitSequenceNum(Integer opUnitSequenceNum) {
        this.opUnitSequenceNum = opUnitSequenceNum;
    }

    public Integer getParcelsMitigated() {
        return parcelsMitigated;
    }

    public void setParcelsMitigated(Integer parcelsMitigated) {
        this.parcelsMitigated = parcelsMitigated;
    }

    public Integer getMaxParcelsMitigated() {
        return maxParcelsMitigated;
    }

    public void setMaxParcelsMitigated(Integer maxParcelsMitigated) {
        this.maxParcelsMitigated = maxParcelsMitigated;
    }

    public String getRemedyCode() {
        return remedyCode;
    }

    public void setRemedyCode(String remedyCode) {
        this.remedyCode = remedyCode;
    }

    public String getRemedyName() {
        return remedyName;
    }

    public void setRemedyName(String remedyName) {
        this.remedyName = remedyName;
    }

    public String getRemedyType() {
        return remedyType;
    }

    public void setRemedyType(String remedyType) {
        this.remedyType = remedyType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRemedyEffective() {
        return remedyEffective;
    }

    public void setRemedyEffective(String remedyEffective) {
        this.remedyEffective = remedyEffective;
    }

    public String getRemedySizeCode() {
        return remedySizeCode;
    }

    public void setRemedySizeCode(String remedySizeCode) {
        this.remedySizeCode = remedySizeCode;
    }

    public String getRemedySizeName() {
        return remedySizeName;
    }

    public void setRemedySizeName(String remedySizeName) {
        this.remedySizeName = remedySizeName;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getInPlaceDate() {
        return inPlaceDate;
    }

    public void setInPlaceDate(Timestamp inPlaceDate) {
        this.inPlaceDate = inPlaceDate;
    }

    public Timestamp getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(Timestamp completionDate) {
        this.completionDate = completionDate;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((comments == null) ? 0 : comments.hashCode());
        result = prime * result
                + ((completionDate == null) ? 0 : completionDate.hashCode());
        result = prime * result
                + ((description == null) ? 0 : description.hashCode());
        result = prime * result
                + ((inPlaceDate == null) ? 0 : inPlaceDate.hashCode());
        result = prime
                * result
                + ((maxParcelsMitigated == null) ? 0 : maxParcelsMitigated
                        .hashCode());
        result = prime
                * result
                + ((opUnitSequenceNum == null) ? 0 : opUnitSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((parcelsMitigated == null) ? 0 : parcelsMitigated.hashCode());
        result = prime * result
                + ((remedyCode == null) ? 0 : remedyCode.hashCode());
        result = prime * result
                + ((remedyEffective == null) ? 0 : remedyEffective.hashCode());
        result = prime * result
                + ((remedyName == null) ? 0 : remedyName.hashCode());
        result = prime
                * result
                + ((remedySequenceNum == null) ? 0 : remedySequenceNum
                        .hashCode());
        result = prime * result
                + ((remedySizeCode == null) ? 0 : remedySizeCode.hashCode());
        result = prime * result
                + ((remedySizeName == null) ? 0 : remedySizeName.hashCode());
        result = prime * result
                + ((remedyType == null) ? 0 : remedyType.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ErRemedy other = (ErRemedy) obj;
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
        if (description == null) {
            if (other.description != null)
                return false;
        } else if (!description.equals(other.description))
            return false;
        if (inPlaceDate == null) {
            if (other.inPlaceDate != null)
                return false;
        } else if (!inPlaceDate.equals(other.inPlaceDate))
            return false;
        if (maxParcelsMitigated == null) {
            if (other.maxParcelsMitigated != null)
                return false;
        } else if (!maxParcelsMitigated.equals(other.maxParcelsMitigated))
            return false;
        if (opUnitSequenceNum == null) {
            if (other.opUnitSequenceNum != null)
                return false;
        } else if (!opUnitSequenceNum.equals(other.opUnitSequenceNum))
            return false;
        if (parcelsMitigated == null) {
            if (other.parcelsMitigated != null)
                return false;
        } else if (!parcelsMitigated.equals(other.parcelsMitigated))
            return false;
        if (remedyCode == null) {
            if (other.remedyCode != null)
                return false;
        } else if (!remedyCode.equals(other.remedyCode))
            return false;
        if (remedyEffective == null) {
            if (other.remedyEffective != null)
                return false;
        } else if (!remedyEffective.equals(other.remedyEffective))
            return false;
        if (remedyName == null) {
            if (other.remedyName != null)
                return false;
        } else if (!remedyName.equals(other.remedyName))
            return false;
        if (remedySequenceNum == null) {
            if (other.remedySequenceNum != null)
                return false;
        } else if (!remedySequenceNum.equals(other.remedySequenceNum))
            return false;
        if (remedySizeCode == null) {
            if (other.remedySizeCode != null)
                return false;
        } else if (!remedySizeCode.equals(other.remedySizeCode))
            return false;
        if (remedySizeName == null) {
            if (other.remedySizeName != null)
                return false;
        } else if (!remedySizeName.equals(other.remedySizeName))
            return false;
        if (remedyType == null) {
            if (other.remedyType != null)
                return false;
        } else if (!remedyType.equals(other.remedyType))
            return false;
        return true;
    }

}