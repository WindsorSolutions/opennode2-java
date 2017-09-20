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

/**
 * Encapsultes a joined row from UIS_PROGRAMS and UIS_FACILITY.
 * 
 * @author jniski
 * 
 */
public class DerProgram extends BaseSitesSpillsDomainObject {

    /* UIS_PROGRAMS */
    private Integer programSequenceNum;
    private Integer siteId;
    private Integer facilityId;

    private String programNum;
    private String programTypeCode;
    private String programTypeName;
    private String facilityName;
    private String startQualifier;
    private String endQualifier;
    private String edocsPath;
    private String newEdocsPath;
    private String edocNew;

    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp lastModified;

    /* UIS_FACILITY */
    private Integer facilitySequenceNum;
    private String facilityAddressOne;
    private String facilityAddressTwo;
    private String facilityLocality;
    private String facilityZipCode;
    private String facilitySwisCode;

    public String getStartDateString() {

        return getFormattedDateString(getStartDate());
    }

    public String getEndDateString() {

        return getFormattedDateString(getEndDate());
    }

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public Integer getProgramSequenceNum() {
        return programSequenceNum;
    }

    public void setProgramSequenceNum(Integer programSequenceNum) {
        this.programSequenceNum = programSequenceNum;
    }

    public Integer getSiteId() {
        return siteId;
    }

    public void setSiteId(Integer siteId) {
        this.siteId = siteId;
    }

    public Integer getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(Integer facilityId) {
        this.facilityId = facilityId;
    }

    public String getProgramNum() {
        return programNum;
    }

    public void setProgramNum(String programNum) {
        this.programNum = programNum;
    }

    public String getProgramTypeCode() {
        return programTypeCode;
    }

    public void setProgramTypeCode(String programTypeCode) {
        this.programTypeCode = programTypeCode;
    }

    public String getProgramTypeName() {
        return programTypeName;
    }

    public void setProgramTypeName(String programTypeName) {
        this.programTypeName = programTypeName;
    }

    public String getFacilityName() {
        return facilityName;
    }

    public void setFacilityName(String facilityName) {
        this.facilityName = facilityName;
    }

    public String getStartQualifier() {
        return startQualifier;
    }

    public void setStartQualifier(String startQualifier) {
        this.startQualifier = startQualifier;
    }

    public String getEndQualifier() {
        return endQualifier;
    }

    public void setEndQualifier(String endQualifier) {
        this.endQualifier = endQualifier;
    }

    public String getEdocsPath() {
        return edocsPath;
    }

    public void setEdocsPath(String edocsPath) {
        this.edocsPath = edocsPath;
    }

    public String getNewEdocsPath() {
        return newEdocsPath;
    }

    public void setNewEdocsPath(String newEdocsPath) {
        this.newEdocsPath = newEdocsPath;
    }

    public String getEdocNew() {
        return edocNew;
    }

    public void setEdocNew(String edocNew) {
        this.edocNew = edocNew;
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

    public Timestamp getLastModified() {
        return lastModified;
    }

    public void setLastModified(Timestamp lastModified) {
        this.lastModified = lastModified;
    }

    public Integer getFacilitySequenceNum() {
        return facilitySequenceNum;
    }

    public void setFacilitySequenceNum(Integer facilitySequenceNum) {
        this.facilitySequenceNum = facilitySequenceNum;
    }

    public String getFacilityAddressOne() {
        return facilityAddressOne;
    }

    public void setFacilityAddressOne(String facilityAddressOne) {
        this.facilityAddressOne = facilityAddressOne;
    }

    public String getFacilityAddressTwo() {
        return facilityAddressTwo;
    }

    public void setFacilityAddressTwo(String facilityAddressTwo) {
        this.facilityAddressTwo = facilityAddressTwo;
    }

    public String getFacilityLocality() {
        return facilityLocality;
    }

    public void setFacilityLocality(String facilityLocality) {
        this.facilityLocality = facilityLocality;
    }

    public String getFacilityZipCode() {
        return facilityZipCode;
    }

    public void setFacilityZipCode(String facilityZipCode) {
        this.facilityZipCode = facilityZipCode;
    }

    public String getFacilitySwisCode() {
        return facilitySwisCode;
    }

    public void setFacilitySwisCode(String facilitySwisCode) {
        this.facilitySwisCode = facilitySwisCode;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((edocNew == null) ? 0 : edocNew.hashCode());
        result = prime * result
                + ((edocsPath == null) ? 0 : edocsPath.hashCode());
        result = prime * result + ((endDate == null) ? 0 : endDate.hashCode());
        result = prime * result
                + ((endQualifier == null) ? 0 : endQualifier.hashCode());
        result = prime
                * result
                + ((facilityAddressOne == null) ? 0 : facilityAddressOne
                        .hashCode());
        result = prime
                * result
                + ((facilityAddressTwo == null) ? 0 : facilityAddressTwo
                        .hashCode());
        result = prime * result
                + ((facilityId == null) ? 0 : facilityId.hashCode());
        result = prime
                * result
                + ((facilityLocality == null) ? 0 : facilityLocality.hashCode());
        result = prime * result
                + ((facilityName == null) ? 0 : facilityName.hashCode());
        result = prime
                * result
                + ((facilitySequenceNum == null) ? 0 : facilitySequenceNum
                        .hashCode());
        result = prime
                * result
                + ((facilitySwisCode == null) ? 0 : facilitySwisCode.hashCode());
        result = prime * result
                + ((facilityZipCode == null) ? 0 : facilityZipCode.hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((newEdocsPath == null) ? 0 : newEdocsPath.hashCode());
        result = prime * result
                + ((programNum == null) ? 0 : programNum.hashCode());
        result = prime
                * result
                + ((programSequenceNum == null) ? 0 : programSequenceNum
                        .hashCode());
        result = prime * result
                + ((programTypeCode == null) ? 0 : programTypeCode.hashCode());
        result = prime * result
                + ((programTypeName == null) ? 0 : programTypeName.hashCode());
        result = prime * result + ((siteId == null) ? 0 : siteId.hashCode());
        result = prime * result
                + ((startDate == null) ? 0 : startDate.hashCode());
        result = prime * result
                + ((startQualifier == null) ? 0 : startQualifier.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        DerProgram other = (DerProgram) obj;
        if (edocNew == null) {
            if (other.edocNew != null)
                return false;
        } else if (!edocNew.equals(other.edocNew))
            return false;
        if (edocsPath == null) {
            if (other.edocsPath != null)
                return false;
        } else if (!edocsPath.equals(other.edocsPath))
            return false;
        if (endDate == null) {
            if (other.endDate != null)
                return false;
        } else if (!endDate.equals(other.endDate))
            return false;
        if (endQualifier == null) {
            if (other.endQualifier != null)
                return false;
        } else if (!endQualifier.equals(other.endQualifier))
            return false;
        if (facilityAddressOne == null) {
            if (other.facilityAddressOne != null)
                return false;
        } else if (!facilityAddressOne.equals(other.facilityAddressOne))
            return false;
        if (facilityAddressTwo == null) {
            if (other.facilityAddressTwo != null)
                return false;
        } else if (!facilityAddressTwo.equals(other.facilityAddressTwo))
            return false;
        if (facilityId == null) {
            if (other.facilityId != null)
                return false;
        } else if (!facilityId.equals(other.facilityId))
            return false;
        if (facilityLocality == null) {
            if (other.facilityLocality != null)
                return false;
        } else if (!facilityLocality.equals(other.facilityLocality))
            return false;
        if (facilityName == null) {
            if (other.facilityName != null)
                return false;
        } else if (!facilityName.equals(other.facilityName))
            return false;
        if (facilitySequenceNum == null) {
            if (other.facilitySequenceNum != null)
                return false;
        } else if (!facilitySequenceNum.equals(other.facilitySequenceNum))
            return false;
        if (facilitySwisCode == null) {
            if (other.facilitySwisCode != null)
                return false;
        } else if (!facilitySwisCode.equals(other.facilitySwisCode))
            return false;
        if (facilityZipCode == null) {
            if (other.facilityZipCode != null)
                return false;
        } else if (!facilityZipCode.equals(other.facilityZipCode))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (newEdocsPath == null) {
            if (other.newEdocsPath != null)
                return false;
        } else if (!newEdocsPath.equals(other.newEdocsPath))
            return false;
        if (programNum == null) {
            if (other.programNum != null)
                return false;
        } else if (!programNum.equals(other.programNum))
            return false;
        if (programSequenceNum == null) {
            if (other.programSequenceNum != null)
                return false;
        } else if (!programSequenceNum.equals(other.programSequenceNum))
            return false;
        if (programTypeCode == null) {
            if (other.programTypeCode != null)
                return false;
        } else if (!programTypeCode.equals(other.programTypeCode))
            return false;
        if (programTypeName == null) {
            if (other.programTypeName != null)
                return false;
        } else if (!programTypeName.equals(other.programTypeName))
            return false;
        if (siteId == null) {
            if (other.siteId != null)
                return false;
        } else if (!siteId.equals(other.siteId))
            return false;
        if (startDate == null) {
            if (other.startDate != null)
                return false;
        } else if (!startDate.equals(other.startDate))
            return false;
        if (startQualifier == null) {
            if (other.startQualifier != null)
                return false;
        } else if (!startQualifier.equals(other.startQualifier))
            return false;
        return true;
    }

}