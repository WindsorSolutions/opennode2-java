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

public class ErPetitionFiled extends BaseSitesSpillsDomainObject {

    private Integer petitionFiledSequenceNum;
    private Integer siteSequenceNum;

    private String petitionSeqNbr;
    private String petitionFiledOne;
    private String petitionerName;
    private String pacTrq;
    private String commentOne;
    private String commentTwo;
    private String siteName;
    private String petitionFiledTwo;
    private String petitionFiledTwoA;
    private String petitionFiledThree;
    private String comments;

    private Timestamp controlSecSignDate;
    private Timestamp regionalOfficeSignDate;
    private Timestamp centralOfficeSignDate;
    private Timestamp dohSignDate;
    private Timestamp decSignDate;
    private Timestamp divisionApproveDate;
    private Timestamp finalizationDate;
    private Timestamp onHoldDate;

    public String getControlSecSignDateString() {

        return getFormattedDateString(getControlSecSignDate());
    }

    public String getRegionalOfficeSignDateString() {

        return getFormattedDateString(getRegionalOfficeSignDate());
    }

    public String getCentralOfficeSignDateString() {

        return getFormattedDateString(getCentralOfficeSignDate());
    }

    public String getDohSignDateString() {

        return getFormattedDateString(getDohSignDate());
    }

    public String getDecSignDateString() {

        return getFormattedDateString(getDecSignDate());
    }

    public String getDivisionApproveDateString() {

        return getFormattedDateString(getDivisionApproveDate());
    }

    public String getFinalizationDateString() {

        return getFormattedDateString(getFinalizationDate());
    }

    public String getOnHoldDateString() {

        return getFormattedDateString(getOnHoldDate());
    }

    public Integer getPetitionFiledSequenceNum() {
        return petitionFiledSequenceNum;
    }

    public void setPetitionFiledSequenceNum(Integer petitionFiledSequenceNum) {
        this.petitionFiledSequenceNum = petitionFiledSequenceNum;
    }

    public Integer getSiteSequenceNum() {
        return siteSequenceNum;
    }

    public void setSiteSequenceNum(Integer siteSequenceNum) {
        this.siteSequenceNum = siteSequenceNum;
    }

    public String getPetitionSeqNbr() {
        return petitionSeqNbr;
    }

    public void setPetitionSeqNbr(String petitionSeqNbr) {
        this.petitionSeqNbr = petitionSeqNbr;
    }

    public String getPetitionFiledOne() {
        return petitionFiledOne;
    }

    public void setPetitionFiledOne(String petitionFiledOne) {
        this.petitionFiledOne = petitionFiledOne;
    }

    public String getPetitionerName() {
        return petitionerName;
    }

    public void setPetitionerName(String petitionerName) {
        this.petitionerName = petitionerName;
    }

    public String getPacTrq() {
        return pacTrq;
    }

    public void setPacTrq(String pacTrq) {
        this.pacTrq = pacTrq;
    }

    public String getCommentOne() {
        return commentOne;
    }

    public void setCommentOne(String commentOne) {
        this.commentOne = commentOne;
    }

    public String getCommentTwo() {
        return commentTwo;
    }

    public void setCommentTwo(String commentTwo) {
        this.commentTwo = commentTwo;
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public String getPetitionFiledTwo() {
        return petitionFiledTwo;
    }

    public void setPetitionFiledTwo(String petitionFiledTwo) {
        this.petitionFiledTwo = petitionFiledTwo;
    }

    public String getPetitionFiledTwoA() {
        return petitionFiledTwoA;
    }

    public void setPetitionFiledTwoA(String petitionFiledTwoA) {
        this.petitionFiledTwoA = petitionFiledTwoA;
    }

    public String getPetitionFiledThree() {
        return petitionFiledThree;
    }

    public void setPetitionFiledThree(String petitionFiledThree) {
        this.petitionFiledThree = petitionFiledThree;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Timestamp getControlSecSignDate() {
        return controlSecSignDate;
    }

    public void setControlSecSignDate(Timestamp controlSecSignDate) {
        this.controlSecSignDate = controlSecSignDate;
    }

    public Timestamp getRegionalOfficeSignDate() {
        return regionalOfficeSignDate;
    }

    public void setRegionalOfficeSignDate(Timestamp regionalOfficeSignDate) {
        this.regionalOfficeSignDate = regionalOfficeSignDate;
    }

    public Timestamp getCentralOfficeSignDate() {
        return centralOfficeSignDate;
    }

    public void setCentralOfficeSignDate(Timestamp centralOfficeSignDate) {
        this.centralOfficeSignDate = centralOfficeSignDate;
    }

    public Timestamp getDohSignDate() {
        return dohSignDate;
    }

    public void setDohSignDate(Timestamp dohSignDate) {
        this.dohSignDate = dohSignDate;
    }

    public Timestamp getDecSignDate() {
        return decSignDate;
    }

    public void setDecSignDate(Timestamp decSignDate) {
        this.decSignDate = decSignDate;
    }

    public Timestamp getDivisionApproveDate() {
        return divisionApproveDate;
    }

    public void setDivisionApproveDate(Timestamp divisionApproveDate) {
        this.divisionApproveDate = divisionApproveDate;
    }

    public Timestamp getFinalizationDate() {
        return finalizationDate;
    }

    public void setFinalizationDate(Timestamp finalizationDate) {
        this.finalizationDate = finalizationDate;
    }

    public Timestamp getOnHoldDate() {
        return onHoldDate;
    }

    public void setOnHoldDate(Timestamp onHoldDate) {
        this.onHoldDate = onHoldDate;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((centralOfficeSignDate == null) ? 0 : centralOfficeSignDate
                        .hashCode());
        result = prime * result
                + ((commentOne == null) ? 0 : commentOne.hashCode());
        result = prime * result
                + ((commentTwo == null) ? 0 : commentTwo.hashCode());
        result = prime * result
                + ((comments == null) ? 0 : comments.hashCode());
        result = prime
                * result
                + ((controlSecSignDate == null) ? 0 : controlSecSignDate
                        .hashCode());
        result = prime * result
                + ((decSignDate == null) ? 0 : decSignDate.hashCode());
        result = prime
                * result
                + ((divisionApproveDate == null) ? 0 : divisionApproveDate
                        .hashCode());
        result = prime * result
                + ((dohSignDate == null) ? 0 : dohSignDate.hashCode());
        result = prime
                * result
                + ((finalizationDate == null) ? 0 : finalizationDate.hashCode());
        result = prime * result
                + ((onHoldDate == null) ? 0 : onHoldDate.hashCode());
        result = prime * result + ((pacTrq == null) ? 0 : pacTrq.hashCode());
        result = prime
                * result
                + ((petitionFiledOne == null) ? 0 : petitionFiledOne.hashCode());
        result = prime
                * result
                + ((petitionFiledSequenceNum == null) ? 0
                        : petitionFiledSequenceNum.hashCode());
        result = prime
                * result
                + ((petitionFiledThree == null) ? 0 : petitionFiledThree
                        .hashCode());
        result = prime
                * result
                + ((petitionFiledTwo == null) ? 0 : petitionFiledTwo.hashCode());
        result = prime
                * result
                + ((petitionFiledTwoA == null) ? 0 : petitionFiledTwoA
                        .hashCode());
        result = prime * result
                + ((petitionSeqNbr == null) ? 0 : petitionSeqNbr.hashCode());
        result = prime * result
                + ((petitionerName == null) ? 0 : petitionerName.hashCode());
        result = prime
                * result
                + ((regionalOfficeSignDate == null) ? 0
                        : regionalOfficeSignDate.hashCode());
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
        ErPetitionFiled other = (ErPetitionFiled) obj;
        if (centralOfficeSignDate == null) {
            if (other.centralOfficeSignDate != null)
                return false;
        } else if (!centralOfficeSignDate.equals(other.centralOfficeSignDate))
            return false;
        if (commentOne == null) {
            if (other.commentOne != null)
                return false;
        } else if (!commentOne.equals(other.commentOne))
            return false;
        if (commentTwo == null) {
            if (other.commentTwo != null)
                return false;
        } else if (!commentTwo.equals(other.commentTwo))
            return false;
        if (comments == null) {
            if (other.comments != null)
                return false;
        } else if (!comments.equals(other.comments))
            return false;
        if (controlSecSignDate == null) {
            if (other.controlSecSignDate != null)
                return false;
        } else if (!controlSecSignDate.equals(other.controlSecSignDate))
            return false;
        if (decSignDate == null) {
            if (other.decSignDate != null)
                return false;
        } else if (!decSignDate.equals(other.decSignDate))
            return false;
        if (divisionApproveDate == null) {
            if (other.divisionApproveDate != null)
                return false;
        } else if (!divisionApproveDate.equals(other.divisionApproveDate))
            return false;
        if (dohSignDate == null) {
            if (other.dohSignDate != null)
                return false;
        } else if (!dohSignDate.equals(other.dohSignDate))
            return false;
        if (finalizationDate == null) {
            if (other.finalizationDate != null)
                return false;
        } else if (!finalizationDate.equals(other.finalizationDate))
            return false;
        if (onHoldDate == null) {
            if (other.onHoldDate != null)
                return false;
        } else if (!onHoldDate.equals(other.onHoldDate))
            return false;
        if (pacTrq == null) {
            if (other.pacTrq != null)
                return false;
        } else if (!pacTrq.equals(other.pacTrq))
            return false;
        if (petitionFiledOne == null) {
            if (other.petitionFiledOne != null)
                return false;
        } else if (!petitionFiledOne.equals(other.petitionFiledOne))
            return false;
        if (petitionFiledSequenceNum == null) {
            if (other.petitionFiledSequenceNum != null)
                return false;
        } else if (!petitionFiledSequenceNum
                .equals(other.petitionFiledSequenceNum))
            return false;
        if (petitionFiledThree == null) {
            if (other.petitionFiledThree != null)
                return false;
        } else if (!petitionFiledThree.equals(other.petitionFiledThree))
            return false;
        if (petitionFiledTwo == null) {
            if (other.petitionFiledTwo != null)
                return false;
        } else if (!petitionFiledTwo.equals(other.petitionFiledTwo))
            return false;
        if (petitionFiledTwoA == null) {
            if (other.petitionFiledTwoA != null)
                return false;
        } else if (!petitionFiledTwoA.equals(other.petitionFiledTwoA))
            return false;
        if (petitionSeqNbr == null) {
            if (other.petitionSeqNbr != null)
                return false;
        } else if (!petitionSeqNbr.equals(other.petitionSeqNbr))
            return false;
        if (petitionerName == null) {
            if (other.petitionerName != null)
                return false;
        } else if (!petitionerName.equals(other.petitionerName))
            return false;
        if (regionalOfficeSignDate == null) {
            if (other.regionalOfficeSignDate != null)
                return false;
        } else if (!regionalOfficeSignDate.equals(other.regionalOfficeSignDate))
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