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

public class ErMaterial extends BaseSitesSpillsDomainObject {

    private Integer materialSequenceNum;
    private Integer opUnitSequenceNum;
    private Integer opUnitId;
    private Integer materialId;
    private Integer programSiteId;

    private Double quantity;
    private Double recovered;

    private String materialCode;
    private String targetLevel;
    private String units;
    private String pmContaminantComments;
    private String modifiedBy;

    private Timestamp lastModified;

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public String getQuantityString() {

        return getFormattedDouble(getQuantity());
    }

    public String getRecoveredString() {

        return getFormattedDouble(getRecovered());
    }

    public Integer getMaterialSequenceNum() {
        return materialSequenceNum;
    }

    public void setMaterialSequenceNum(Integer materialSequenceNum) {
        this.materialSequenceNum = materialSequenceNum;
    }

    public Integer getOpUnitSequenceNum() {
        return opUnitSequenceNum;
    }

    public void setOpUnitSequenceNum(Integer opUnitSequenceNum) {
        this.opUnitSequenceNum = opUnitSequenceNum;
    }

    public Integer getOpUnitId() {
        return opUnitId;
    }

    public void setOpUnitId(Integer opUnitId) {
        this.opUnitId = opUnitId;
    }

    public Integer getMaterialId() {
        return materialId;
    }

    public void setMaterialId(Integer materialId) {
        this.materialId = materialId;
    }

    public Integer getProgramSiteId() {
        return programSiteId;
    }

    public void setProgramSiteId(Integer programSiteId) {
        this.programSiteId = programSiteId;
    }

    public Double getQuantity() {
        return quantity;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    public Double getRecovered() {
        return recovered;
    }

    public void setRecovered(Double recovered) {
        this.recovered = recovered;
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public String getTargetLevel() {
        return targetLevel;
    }

    public void setTargetLevel(String targetLevel) {
        this.targetLevel = targetLevel;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getPmContaminantComments() {
        return pmContaminantComments;
    }

    public void setPmContaminantComments(String pmContaminantComments) {
        this.pmContaminantComments = pmContaminantComments;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
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
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((materialCode == null) ? 0 : materialCode.hashCode());
        result = prime * result
                + ((materialId == null) ? 0 : materialId.hashCode());
        result = prime
                * result
                + ((materialSequenceNum == null) ? 0 : materialSequenceNum
                        .hashCode());
        result = prime * result
                + ((modifiedBy == null) ? 0 : modifiedBy.hashCode());
        result = prime * result
                + ((opUnitId == null) ? 0 : opUnitId.hashCode());
        result = prime
                * result
                + ((opUnitSequenceNum == null) ? 0 : opUnitSequenceNum
                        .hashCode());
        result = prime
                * result
                + ((pmContaminantComments == null) ? 0 : pmContaminantComments
                        .hashCode());
        result = prime * result
                + ((programSiteId == null) ? 0 : programSiteId.hashCode());
        result = prime * result
                + ((quantity == null) ? 0 : quantity.hashCode());
        result = prime * result
                + ((recovered == null) ? 0 : recovered.hashCode());
        result = prime * result
                + ((targetLevel == null) ? 0 : targetLevel.hashCode());
        result = prime * result + ((units == null) ? 0 : units.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ErMaterial other = (ErMaterial) obj;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (materialCode == null) {
            if (other.materialCode != null)
                return false;
        } else if (!materialCode.equals(other.materialCode))
            return false;
        if (materialId == null) {
            if (other.materialId != null)
                return false;
        } else if (!materialId.equals(other.materialId))
            return false;
        if (materialSequenceNum == null) {
            if (other.materialSequenceNum != null)
                return false;
        } else if (!materialSequenceNum.equals(other.materialSequenceNum))
            return false;
        if (modifiedBy == null) {
            if (other.modifiedBy != null)
                return false;
        } else if (!modifiedBy.equals(other.modifiedBy))
            return false;
        if (opUnitId == null) {
            if (other.opUnitId != null)
                return false;
        } else if (!opUnitId.equals(other.opUnitId))
            return false;
        if (opUnitSequenceNum == null) {
            if (other.opUnitSequenceNum != null)
                return false;
        } else if (!opUnitSequenceNum.equals(other.opUnitSequenceNum))
            return false;
        if (pmContaminantComments == null) {
            if (other.pmContaminantComments != null)
                return false;
        } else if (!pmContaminantComments.equals(other.pmContaminantComments))
            return false;
        if (programSiteId == null) {
            if (other.programSiteId != null)
                return false;
        } else if (!programSiteId.equals(other.programSiteId))
            return false;
        if (quantity == null) {
            if (other.quantity != null)
                return false;
        } else if (!quantity.equals(other.quantity))
            return false;
        if (recovered == null) {
            if (other.recovered != null)
                return false;
        } else if (!recovered.equals(other.recovered))
            return false;
        if (targetLevel == null) {
            if (other.targetLevel != null)
                return false;
        } else if (!targetLevel.equals(other.targetLevel))
            return false;
        if (units == null) {
            if (other.units != null)
                return false;
        } else if (!units.equals(other.units))
            return false;
        return true;
    }

}