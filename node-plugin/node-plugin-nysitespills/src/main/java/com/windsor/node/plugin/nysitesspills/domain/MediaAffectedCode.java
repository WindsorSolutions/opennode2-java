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

public class MediaAffectedCode extends BaseSitesSpillsDomainObject {

    private String mediaAffectedCode;
    private String mediaAffectedName;
    private String mediaAffectedDescription;
    private String mediaAffectedType;

    public String getMediaAffectedCode() {
        return mediaAffectedCode;
    }

    public void setMediaAffectedCode(String mediaAffectedCode) {
        this.mediaAffectedCode = mediaAffectedCode;
    }

    public String getMediaAffectedName() {
        return mediaAffectedName;
    }

    public void setMediaAffectedName(String mediaAffectedName) {
        this.mediaAffectedName = mediaAffectedName;
    }

    public String getMediaAffectedDescription() {
        return mediaAffectedDescription;
    }

    public void setMediaAffectedDescription(String mediaAffectedDescription) {
        this.mediaAffectedDescription = mediaAffectedDescription;
    }

    public String getMediaAffectedType() {
        return mediaAffectedType;
    }

    public void setMediaAffectedType(String mediaAffectedType) {
        this.mediaAffectedType = mediaAffectedType;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((mediaAffectedCode == null) ? 0 : mediaAffectedCode
                        .hashCode());
        result = prime
                * result
                + ((mediaAffectedDescription == null) ? 0
                        : mediaAffectedDescription.hashCode());
        result = prime
                * result
                + ((mediaAffectedName == null) ? 0 : mediaAffectedName
                        .hashCode());
        result = prime
                * result
                + ((mediaAffectedType == null) ? 0 : mediaAffectedType
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
        MediaAffectedCode other = (MediaAffectedCode) obj;
        if (mediaAffectedCode == null) {
            if (other.mediaAffectedCode != null)
                return false;
        } else if (!mediaAffectedCode.equals(other.mediaAffectedCode))
            return false;
        if (mediaAffectedDescription == null) {
            if (other.mediaAffectedDescription != null)
                return false;
        } else if (!mediaAffectedDescription
                .equals(other.mediaAffectedDescription))
            return false;
        if (mediaAffectedName == null) {
            if (other.mediaAffectedName != null)
                return false;
        } else if (!mediaAffectedName.equals(other.mediaAffectedName))
            return false;
        if (mediaAffectedType == null) {
            if (other.mediaAffectedType != null)
                return false;
        } else if (!mediaAffectedType.equals(other.mediaAffectedType))
            return false;
        return true;
    }

}