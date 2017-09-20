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

public class ErAdjacentProperty extends BaseSitesSpillsDomainObject {

    private Integer adjacentPropertySequenceNum;
    private Integer siteSequenceNum;
    private Integer adjacentPropertyId;
    private Integer nyTransmercatorN;

    private Double nyTransmercatorE;

    private String adjacentPropertyIdc;
    private String eaDistrict;
    private String eaSection;
    private String eaSubsection;
    private String eaBlock;
    private String eaLot;
    private String eaSublot;
    private String eaSuffix;
    private String nyDistance;
    private String sectionBlockPrint;
    private String parcelStreet;
    private String parcelCity;
    private String parcelZipCode;
    private String parcelSwis;

    public String getNyTransmercatorEString() {

        return getFormattedDouble(getNyTransmercatorE());
    }

    public Integer getAdjacentPropertySequenceNum() {
        return adjacentPropertySequenceNum;
    }

    public void setAdjacentPropertySequenceNum(
            Integer adjacentPropertySequenceNum) {
        this.adjacentPropertySequenceNum = adjacentPropertySequenceNum;
    }

    public Integer getSiteSequenceNum() {
        return siteSequenceNum;
    }

    public void setSiteSequenceNum(Integer siteSequenceNum) {
        this.siteSequenceNum = siteSequenceNum;
    }

    public Integer getAdjacentPropertyId() {
        return adjacentPropertyId;
    }

    public void setAdjacentPropertyId(Integer adjacentPropertyId) {
        this.adjacentPropertyId = adjacentPropertyId;
    }

    public Integer getNyTransmercatorN() {
        return nyTransmercatorN;
    }

    public void setNyTransmercatorN(Integer nyTransmercatorN) {
        this.nyTransmercatorN = nyTransmercatorN;
    }

    public Double getNyTransmercatorE() {
        return nyTransmercatorE;
    }

    public void setNyTransmercatorE(Double nyTransmercatorE) {
        this.nyTransmercatorE = nyTransmercatorE;
    }

    public String getAdjacentPropertyIdc() {
        return adjacentPropertyIdc;
    }

    public void setAdjacentPropertyIdc(String adjacentPropertyIdc) {
        this.adjacentPropertyIdc = adjacentPropertyIdc;
    }

    public String getEaDistrict() {
        return eaDistrict;
    }

    public void setEaDistrict(String eaDistrict) {
        this.eaDistrict = eaDistrict;
    }

    public String getEaSection() {
        return eaSection;
    }

    public void setEaSection(String eaSection) {
        this.eaSection = eaSection;
    }

    public String getEaSubsection() {
        return eaSubsection;
    }

    public void setEaSubsection(String eaSubsection) {
        this.eaSubsection = eaSubsection;
    }

    public String getEaBlock() {
        return eaBlock;
    }

    public void setEaBlock(String eaBlock) {
        this.eaBlock = eaBlock;
    }

    public String getEaLot() {
        return eaLot;
    }

    public void setEaLot(String eaLot) {
        this.eaLot = eaLot;
    }

    public String getEaSublot() {
        return eaSublot;
    }

    public void setEaSublot(String eaSublot) {
        this.eaSublot = eaSublot;
    }

    public String getEaSuffix() {
        return eaSuffix;
    }

    public void setEaSuffix(String eaSuffix) {
        this.eaSuffix = eaSuffix;
    }

    public String getNyDistance() {
        return nyDistance;
    }

    public void setNyDistance(String nyDistance) {
        this.nyDistance = nyDistance;
    }

    public String getSectionBlockPrint() {
        return sectionBlockPrint;
    }

    public void setSectionBlockPrint(String sectionBlockPrint) {
        this.sectionBlockPrint = sectionBlockPrint;
    }

    public String getParcelStreet() {
        return parcelStreet;
    }

    public void setParcelStreet(String parcelStreet) {
        this.parcelStreet = parcelStreet;
    }

    public String getParcelCity() {
        return parcelCity;
    }

    public void setParcelCity(String parcelCity) {
        this.parcelCity = parcelCity;
    }

    public String getParcelZipCode() {
        return parcelZipCode;
    }

    public void setParcelZipCode(String parcelZipCode) {
        this.parcelZipCode = parcelZipCode;
    }

    public String getParcelSwis() {
        return parcelSwis;
    }

    public void setParcelSwis(String parcelSwis) {
        this.parcelSwis = parcelSwis;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((adjacentPropertyId == null) ? 0 : adjacentPropertyId
                        .hashCode());
        result = prime
                * result
                + ((adjacentPropertyIdc == null) ? 0 : adjacentPropertyIdc
                        .hashCode());
        result = prime
                * result
                + ((adjacentPropertySequenceNum == null) ? 0
                        : adjacentPropertySequenceNum.hashCode());
        result = prime * result + ((eaBlock == null) ? 0 : eaBlock.hashCode());
        result = prime * result
                + ((eaDistrict == null) ? 0 : eaDistrict.hashCode());
        result = prime * result + ((eaLot == null) ? 0 : eaLot.hashCode());
        result = prime * result
                + ((eaSection == null) ? 0 : eaSection.hashCode());
        result = prime * result
                + ((eaSublot == null) ? 0 : eaSublot.hashCode());
        result = prime * result
                + ((eaSubsection == null) ? 0 : eaSubsection.hashCode());
        result = prime * result
                + ((eaSuffix == null) ? 0 : eaSuffix.hashCode());
        result = prime * result
                + ((nyDistance == null) ? 0 : nyDistance.hashCode());
        result = prime
                * result
                + ((nyTransmercatorE == null) ? 0 : nyTransmercatorE.hashCode());
        result = prime
                * result
                + ((nyTransmercatorN == null) ? 0 : nyTransmercatorN.hashCode());
        result = prime * result
                + ((parcelCity == null) ? 0 : parcelCity.hashCode());
        result = prime * result
                + ((parcelStreet == null) ? 0 : parcelStreet.hashCode());
        result = prime * result
                + ((parcelSwis == null) ? 0 : parcelSwis.hashCode());
        result = prime * result
                + ((parcelZipCode == null) ? 0 : parcelZipCode.hashCode());
        result = prime
                * result
                + ((sectionBlockPrint == null) ? 0 : sectionBlockPrint
                        .hashCode());
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
        ErAdjacentProperty other = (ErAdjacentProperty) obj;
        if (adjacentPropertyId == null) {
            if (other.adjacentPropertyId != null)
                return false;
        } else if (!adjacentPropertyId.equals(other.adjacentPropertyId))
            return false;
        if (adjacentPropertyIdc == null) {
            if (other.adjacentPropertyIdc != null)
                return false;
        } else if (!adjacentPropertyIdc.equals(other.adjacentPropertyIdc))
            return false;
        if (adjacentPropertySequenceNum == null) {
            if (other.adjacentPropertySequenceNum != null)
                return false;
        } else if (!adjacentPropertySequenceNum
                .equals(other.adjacentPropertySequenceNum))
            return false;
        if (eaBlock == null) {
            if (other.eaBlock != null)
                return false;
        } else if (!eaBlock.equals(other.eaBlock))
            return false;
        if (eaDistrict == null) {
            if (other.eaDistrict != null)
                return false;
        } else if (!eaDistrict.equals(other.eaDistrict))
            return false;
        if (eaLot == null) {
            if (other.eaLot != null)
                return false;
        } else if (!eaLot.equals(other.eaLot))
            return false;
        if (eaSection == null) {
            if (other.eaSection != null)
                return false;
        } else if (!eaSection.equals(other.eaSection))
            return false;
        if (eaSublot == null) {
            if (other.eaSublot != null)
                return false;
        } else if (!eaSublot.equals(other.eaSublot))
            return false;
        if (eaSubsection == null) {
            if (other.eaSubsection != null)
                return false;
        } else if (!eaSubsection.equals(other.eaSubsection))
            return false;
        if (eaSuffix == null) {
            if (other.eaSuffix != null)
                return false;
        } else if (!eaSuffix.equals(other.eaSuffix))
            return false;
        if (nyDistance == null) {
            if (other.nyDistance != null)
                return false;
        } else if (!nyDistance.equals(other.nyDistance))
            return false;
        if (nyTransmercatorE == null) {
            if (other.nyTransmercatorE != null)
                return false;
        } else if (!nyTransmercatorE.equals(other.nyTransmercatorE))
            return false;
        if (nyTransmercatorN == null) {
            if (other.nyTransmercatorN != null)
                return false;
        } else if (!nyTransmercatorN.equals(other.nyTransmercatorN))
            return false;
        if (parcelCity == null) {
            if (other.parcelCity != null)
                return false;
        } else if (!parcelCity.equals(other.parcelCity))
            return false;
        if (parcelStreet == null) {
            if (other.parcelStreet != null)
                return false;
        } else if (!parcelStreet.equals(other.parcelStreet))
            return false;
        if (parcelSwis == null) {
            if (other.parcelSwis != null)
                return false;
        } else if (!parcelSwis.equals(other.parcelSwis))
            return false;
        if (parcelZipCode == null) {
            if (other.parcelZipCode != null)
                return false;
        } else if (!parcelZipCode.equals(other.parcelZipCode))
            return false;
        if (sectionBlockPrint == null) {
            if (other.sectionBlockPrint != null)
                return false;
        } else if (!sectionBlockPrint.equals(other.sectionBlockPrint))
            return false;
        if (siteSequenceNum == null) {
            if (other.siteSequenceNum != null)
                return false;
        } else if (!siteSequenceNum.equals(other.siteSequenceNum))
            return false;
        return true;
    }

}