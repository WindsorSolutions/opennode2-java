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

public class ErOpUnit extends BaseSitesSpillsDomainObject {

    private Integer opUnitSequenceNum;
    private Integer programSequenceNum;
    private Integer opUnitId;

    private String opUnitCode;
    private String opUnitDescription;
    private String opUnitRecordOfDiscussion;

    public Integer getOpUnitSequenceNum() {
        return opUnitSequenceNum;
    }

    public void setOpUnitSequenceNum(Integer opUnitSequenceNum) {
        this.opUnitSequenceNum = opUnitSequenceNum;
    }

    public Integer getProgramSequenceNum() {
        return programSequenceNum;
    }

    public void setProgramSequenceNum(Integer programSequenceNum) {
        this.programSequenceNum = programSequenceNum;
    }

    public Integer getOpUnitId() {
        return opUnitId;
    }

    public void setOpUnitId(Integer opUnitId) {
        this.opUnitId = opUnitId;
    }

    public String getOpUnitCode() {
        return opUnitCode;
    }

    public void setOpUnitCode(String opUnitCode) {
        this.opUnitCode = opUnitCode;
    }

    public String getOpUnitDescription() {
        return opUnitDescription;
    }

    public void setOpUnitDescription(String opUnitDescription) {
        this.opUnitDescription = opUnitDescription;
    }

    public String getOpUnitRecordOfDiscussion() {
        return opUnitRecordOfDiscussion;
    }

    public void setOpUnitRecordOfDiscussion(String opUnitRecordOfDiscussion) {
        this.opUnitRecordOfDiscussion = opUnitRecordOfDiscussion;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((opUnitCode == null) ? 0 : opUnitCode.hashCode());
        result = prime
                * result
                + ((opUnitDescription == null) ? 0 : opUnitDescription
                        .hashCode());
        result = prime * result
                + ((opUnitId == null) ? 0 : opUnitId.hashCode());
        result = prime
                * result
                + ((opUnitRecordOfDiscussion == null) ? 0
                        : opUnitRecordOfDiscussion.hashCode());
        result = prime
                * result
                + ((opUnitSequenceNum == null) ? 0 : opUnitSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((programSequenceNum == null) ? 0 : programSequenceNum
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
        ErOpUnit other = (ErOpUnit) obj;
        if (opUnitCode == null) {
            if (other.opUnitCode != null)
                return false;
        } else if (!opUnitCode.equals(other.opUnitCode))
            return false;
        if (opUnitDescription == null) {
            if (other.opUnitDescription != null)
                return false;
        } else if (!opUnitDescription.equals(other.opUnitDescription))
            return false;
        if (opUnitId == null) {
            if (other.opUnitId != null)
                return false;
        } else if (!opUnitId.equals(other.opUnitId))
            return false;
        if (opUnitRecordOfDiscussion == null) {
            if (other.opUnitRecordOfDiscussion != null)
                return false;
        } else if (!opUnitRecordOfDiscussion
                .equals(other.opUnitRecordOfDiscussion))
            return false;
        if (opUnitSequenceNum == null) {
            if (other.opUnitSequenceNum != null)
                return false;
        } else if (!opUnitSequenceNum.equals(other.opUnitSequenceNum))
            return false;
        if (programSequenceNum == null) {
            if (other.programSequenceNum != null)
                return false;
        } else if (!programSequenceNum.equals(other.programSequenceNum))
            return false;
        return true;
    }

}