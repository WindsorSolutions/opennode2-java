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

public class ProgramGeoLoc extends BaseSitesSpillsDomainObject {

    private Integer geoLocSequenceNum;
    private Integer progSequenceNum;
    private Integer siteId;
    private Integer gisId;

    private Double latitude;
    private Double longitude;

    private String collectionMethod;
    private String accuracy;
    private String accuracyUnit;
    private String datum;
    private String modifiedBy;

    private Timestamp recordAdd;
    private Timestamp lastModified;

    public String getRecordAddString() {

        return getFormattedDateString(getRecordAdd());
    }

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public String getLatitudeString() {

        return getFormattedDouble(getLatitude());
    }

    public String getLongitudeString() {

        return getFormattedDouble(getLongitude());
    }

    public Integer getGeoLocSequenceNum() {
        return geoLocSequenceNum;
    }

    public void setGeoLocSequenceNum(Integer geoLocSequenceNum) {
        this.geoLocSequenceNum = geoLocSequenceNum;
    }

    public Integer getProgSequenceNum() {
        return progSequenceNum;
    }

    public void setProgSequenceNum(Integer siteSequenceNum) {
        this.progSequenceNum = siteSequenceNum;
    }

    public Integer getSiteId() {
        return siteId;
    }

    public void setSiteId(Integer siteId) {
        this.siteId = siteId;
    }

    public Integer getGisId() {
        return gisId;
    }

    public void setGisId(Integer gisId) {
        this.gisId = gisId;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public String getCollectionMethod() {
        return collectionMethod;
    }

    public void setCollectionMethod(String collectionMethod) {
        this.collectionMethod = collectionMethod;
    }

    public String getAccuracy() {
        return accuracy;
    }

    public void setAccuracy(String accuracy) {
        this.accuracy = accuracy;
    }

    public String getAccuracyUnit() {
        return accuracyUnit;
    }

    public void setAccuracyUnit(String accuracyUnit) {
        this.accuracyUnit = accuracyUnit;
    }

    public String getDatum() {
        return datum;
    }

    public void setDatum(String datum) {
        this.datum = datum;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public Timestamp getRecordAdd() {
        return recordAdd;
    }

    public void setRecordAdd(Timestamp recordAdd) {
        this.recordAdd = recordAdd;
    }

    public Timestamp getLastModified() {
        return lastModified;
    }

    public void setLastModified(Timestamp lastModified) {
        this.lastModified = lastModified;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((accuracy == null) ? 0 : accuracy.hashCode());
        result = prime * result
                + ((accuracyUnit == null) ? 0 : accuracyUnit.hashCode());
        result = prime
                * result
                + ((collectionMethod == null) ? 0 : collectionMethod.hashCode());
        result = prime * result + ((datum == null) ? 0 : datum.hashCode());
        result = prime
                * result
                + ((geoLocSequenceNum == null) ? 0 : geoLocSequenceNum
                        .hashCode());
        result = prime * result + ((gisId == null) ? 0 : gisId.hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((latitude == null) ? 0 : latitude.hashCode());
        result = prime * result
                + ((longitude == null) ? 0 : longitude.hashCode());
        result = prime * result
                + ((modifiedBy == null) ? 0 : modifiedBy.hashCode());
        result = prime * result
                + ((recordAdd == null) ? 0 : recordAdd.hashCode());
        result = prime * result + ((siteId == null) ? 0 : siteId.hashCode());
        result = prime * result
                + ((progSequenceNum == null) ? 0 : progSequenceNum.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProgramGeoLoc other = (ProgramGeoLoc) obj;
        if (accuracy == null) {
            if (other.accuracy != null)
                return false;
        } else if (!accuracy.equals(other.accuracy))
            return false;
        if (accuracyUnit == null) {
            if (other.accuracyUnit != null)
                return false;
        } else if (!accuracyUnit.equals(other.accuracyUnit))
            return false;
        if (collectionMethod == null) {
            if (other.collectionMethod != null)
                return false;
        } else if (!collectionMethod.equals(other.collectionMethod))
            return false;
        if (datum == null) {
            if (other.datum != null)
                return false;
        } else if (!datum.equals(other.datum))
            return false;
        if (geoLocSequenceNum == null) {
            if (other.geoLocSequenceNum != null)
                return false;
        } else if (!geoLocSequenceNum.equals(other.geoLocSequenceNum))
            return false;
        if (gisId == null) {
            if (other.gisId != null)
                return false;
        } else if (!gisId.equals(other.gisId))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (latitude == null) {
            if (other.latitude != null)
                return false;
        } else if (!latitude.equals(other.latitude))
            return false;
        if (longitude == null) {
            if (other.longitude != null)
                return false;
        } else if (!longitude.equals(other.longitude))
            return false;
        if (modifiedBy == null) {
            if (other.modifiedBy != null)
                return false;
        } else if (!modifiedBy.equals(other.modifiedBy))
            return false;
        if (recordAdd == null) {
            if (other.recordAdd != null)
                return false;
        } else if (!recordAdd.equals(other.recordAdd))
            return false;
        if (siteId == null) {
            if (other.siteId != null)
                return false;
        } else if (!siteId.equals(other.siteId))
            return false;
        if (progSequenceNum == null) {
            if (other.progSequenceNum != null)
                return false;
        } else if (!progSequenceNum.equals(other.progSequenceNum))
            return false;
        return true;
    }

}