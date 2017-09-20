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

public class MaterialCode extends BaseSitesSpillsDomainObject {

    private String materialCode;
    private String materialName;
    private String casNumber;
    private String materialFamilyCode;
    private String acuteIndicator;

    private Integer landRepQty;
    private Integer airRepQty;
    private Integer recordCount;

    private Double screeningThreshold;
    private Double specificGravity;

    public String getScreeningThresholdString() {

        return getFormattedDouble(getScreeningThreshold());
    }

    public String getSpecificGravityString() {

        return getFormattedDouble(getSpecificGravity());
    }

    public String getMaterialCode() {
        return materialCode;
    }

    public void setMaterialCode(String materialCode) {
        this.materialCode = materialCode;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getCasNumber() {
        return casNumber;
    }

    public void setCasNumber(String casNumber) {
        this.casNumber = casNumber;
    }

    public String getMaterialFamilyCode() {
        return materialFamilyCode;
    }

    public void setMaterialFamilyCode(String materialFamilyCode) {
        this.materialFamilyCode = materialFamilyCode;
    }

    public String getAcuteIndicator() {
        return acuteIndicator;
    }

    public void setAcuteIndicator(String acuteIndicator) {
        this.acuteIndicator = acuteIndicator;
    }

    public Integer getLandRepQty() {
        return landRepQty;
    }

    public void setLandRepQty(Integer landRepQty) {
        this.landRepQty = landRepQty;
    }

    public Integer getAirRepQty() {
        return airRepQty;
    }

    public void setAirRepQty(Integer airRepQty) {
        this.airRepQty = airRepQty;
    }

    public Integer getRecordCount() {
        return recordCount;
    }

    public void setRecordCount(Integer recordCount) {
        this.recordCount = recordCount;
    }

    public Double getScreeningThreshold() {
        return screeningThreshold;
    }

    public void setScreeningThreshold(Double screeningThreshold) {
        this.screeningThreshold = screeningThreshold;
    }

    public Double getSpecificGravity() {
        return specificGravity;
    }

    public void setSpecificGravity(Double specificGravity) {
        this.specificGravity = specificGravity;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((acuteIndicator == null) ? 0 : acuteIndicator.hashCode());
        result = prime * result
                + ((airRepQty == null) ? 0 : airRepQty.hashCode());
        result = prime * result
                + ((casNumber == null) ? 0 : casNumber.hashCode());
        result = prime * result
                + ((landRepQty == null) ? 0 : landRepQty.hashCode());
        result = prime * result
                + ((materialCode == null) ? 0 : materialCode.hashCode());
        result = prime
                * result
                + ((materialFamilyCode == null) ? 0 : materialFamilyCode
                        .hashCode());
        result = prime * result
                + ((materialName == null) ? 0 : materialName.hashCode());
        result = prime * result
                + ((recordCount == null) ? 0 : recordCount.hashCode());
        result = prime
                * result
                + ((screeningThreshold == null) ? 0 : screeningThreshold
                        .hashCode());
        result = prime * result
                + ((specificGravity == null) ? 0 : specificGravity.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        MaterialCode other = (MaterialCode) obj;
        if (acuteIndicator == null) {
            if (other.acuteIndicator != null)
                return false;
        } else if (!acuteIndicator.equals(other.acuteIndicator))
            return false;
        if (airRepQty == null) {
            if (other.airRepQty != null)
                return false;
        } else if (!airRepQty.equals(other.airRepQty))
            return false;
        if (casNumber == null) {
            if (other.casNumber != null)
                return false;
        } else if (!casNumber.equals(other.casNumber))
            return false;
        if (landRepQty == null) {
            if (other.landRepQty != null)
                return false;
        } else if (!landRepQty.equals(other.landRepQty))
            return false;
        if (materialCode == null) {
            if (other.materialCode != null)
                return false;
        } else if (!materialCode.equals(other.materialCode))
            return false;
        if (materialFamilyCode == null) {
            if (other.materialFamilyCode != null)
                return false;
        } else if (!materialFamilyCode.equals(other.materialFamilyCode))
            return false;
        if (materialName == null) {
            if (other.materialName != null)
                return false;
        } else if (!materialName.equals(other.materialName))
            return false;
        if (recordCount == null) {
            if (other.recordCount != null)
                return false;
        } else if (!recordCount.equals(other.recordCount))
            return false;
        if (screeningThreshold == null) {
            if (other.screeningThreshold != null)
                return false;
        } else if (!screeningThreshold.equals(other.screeningThreshold))
            return false;
        if (specificGravity == null) {
            if (other.specificGravity != null)
                return false;
        } else if (!specificGravity.equals(other.specificGravity))
            return false;
        return true;
    }

}