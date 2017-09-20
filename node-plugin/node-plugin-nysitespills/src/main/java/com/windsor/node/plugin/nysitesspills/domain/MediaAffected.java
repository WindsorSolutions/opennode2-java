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

public class MediaAffected extends BaseSitesSpillsDomainObject {

    private Integer mediaAffectedSequenceNum;
    private Integer materialSequenceNum;

    private String mediaAffectedCode;
    private String mediaAffectedTargetLevel;

    public Integer getMediaAffectedSequenceNum() {
        return mediaAffectedSequenceNum;
    }

    public void setMediaAffectedSequenceNum(Integer mediaAffectedSequenceNum) {
        this.mediaAffectedSequenceNum = mediaAffectedSequenceNum;
    }

    public Integer getMaterialSequenceNum() {
        return materialSequenceNum;
    }

    public void setMaterialSequenceNum(Integer materialSequenceNum) {
        this.materialSequenceNum = materialSequenceNum;
    }

    public String getMediaAffectedCode() {
        return mediaAffectedCode;
    }

    public void setMediaAffectedCode(String mediaAffectedCode) {
        this.mediaAffectedCode = mediaAffectedCode;
    }

    public String getMediaAffectedTargetLevel() {
        return mediaAffectedTargetLevel;
    }

    public void setMediaAffectedTargetLevel(String mediaAffectedTargetLevel) {
        this.mediaAffectedTargetLevel = mediaAffectedTargetLevel;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((materialSequenceNum == null) ? 0 : materialSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((mediaAffectedCode == null) ? 0 : mediaAffectedCode
                        .hashCode());
        result = prime
                * result
                + ((mediaAffectedSequenceNum == null) ? 0
                        : mediaAffectedSequenceNum.hashCode());
        result = prime
                * result
                + ((mediaAffectedTargetLevel == null) ? 0
                        : mediaAffectedTargetLevel.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        MediaAffected other = (MediaAffected) obj;
        if (materialSequenceNum == null) {
            if (other.materialSequenceNum != null)
                return false;
        } else if (!materialSequenceNum.equals(other.materialSequenceNum))
            return false;
        if (mediaAffectedCode == null) {
            if (other.mediaAffectedCode != null)
                return false;
        } else if (!mediaAffectedCode.equals(other.mediaAffectedCode))
            return false;
        if (mediaAffectedSequenceNum == null) {
            if (other.mediaAffectedSequenceNum != null)
                return false;
        } else if (!mediaAffectedSequenceNum
                .equals(other.mediaAffectedSequenceNum))
            return false;
        if (mediaAffectedTargetLevel == null) {
            if (other.mediaAffectedTargetLevel != null)
                return false;
        } else if (!mediaAffectedTargetLevel
                .equals(other.mediaAffectedTargetLevel))
            return false;
        return true;
    }

}