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

public class SpTankTest extends BaseSitesSpillsDomainObject {

    private Integer tankSequenceNum;
    private Integer spillSequenceNum;
    private Integer tankId;

    private Double tankSize;
    private Double leakRate;

    private String tankNumber;
    private String material;
    private String epaUstIndicator;
    private String ustIndicator;
    private String causeCode;
    private String causeName;
    private String sourceCode;
    private String sourceName;
    private String testMethodCode;
    private String testMethodName;
    private String grossFailureIndicator;

    private Timestamp lastModified;

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public String getTankSizeString() {

        return getFormattedDouble(getTankSize());
    }

    public String getLeakRateString() {

        return getFormattedDouble(getLeakRate());
    }

    public Integer getTankSequenceNum() {
        return tankSequenceNum;
    }

    public void setTankSequenceNum(Integer tankSequenceNum) {
        this.tankSequenceNum = tankSequenceNum;
    }

    public Integer getSpillSequenceNum() {
        return spillSequenceNum;
    }

    public void setSpillSequenceNum(Integer spillSequenceNum) {
        this.spillSequenceNum = spillSequenceNum;
    }

    public Integer getTankId() {
        return tankId;
    }

    public void setTankId(Integer tankId) {
        this.tankId = tankId;
    }

    public Double getTankSize() {
        return tankSize;
    }

    public void setTankSize(Double tankSize) {
        this.tankSize = tankSize;
    }

    public Double getLeakRate() {
        return leakRate;
    }

    public void setLeakRate(Double leakRate) {
        this.leakRate = leakRate;
    }

    public String getTankNumber() {
        return tankNumber;
    }

    public void setTankNumber(String tankNumber) {
        this.tankNumber = tankNumber;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public String getEpaUstIndicator() {
        return epaUstIndicator;
    }

    public void setEpaUstIndicator(String epaUstIndicator) {
        this.epaUstIndicator = epaUstIndicator;
    }

    public String getUstIndicator() {
        return ustIndicator;
    }

    public void setUstIndicator(String ustIndicator) {
        this.ustIndicator = ustIndicator;
    }

    public String getCauseCode() {
        return causeCode;
    }

    public void setCauseCode(String causeCode) {
        this.causeCode = causeCode;
    }

    public String getCauseName() {
        return causeName;
    }

    public void setCauseName(String causeName) {
        this.causeName = causeName;
    }

    public String getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    public String getSourceName() {
        return sourceName;
    }

    public void setSourceName(String sourceName) {
        this.sourceName = sourceName;
    }

    public String getTestMethodCode() {
        return testMethodCode;
    }

    public void setTestMethodCode(String testMethodCode) {
        this.testMethodCode = testMethodCode;
    }

    public String getTestMethodName() {
        return testMethodName;
    }

    public void setTestMethodName(String testMethodName) {
        this.testMethodName = testMethodName;
    }

    public String getGrossFailureIndicator() {
        return grossFailureIndicator;
    }

    public void setGrossFailureIndicator(String grossFailureIndicator) {
        this.grossFailureIndicator = grossFailureIndicator;
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
                + ((causeCode == null) ? 0 : causeCode.hashCode());
        result = prime * result
                + ((causeName == null) ? 0 : causeName.hashCode());
        result = prime * result
                + ((epaUstIndicator == null) ? 0 : epaUstIndicator.hashCode());
        result = prime
                * result
                + ((grossFailureIndicator == null) ? 0 : grossFailureIndicator
                        .hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((leakRate == null) ? 0 : leakRate.hashCode());
        result = prime * result
                + ((material == null) ? 0 : material.hashCode());
        result = prime * result
                + ((sourceCode == null) ? 0 : sourceCode.hashCode());
        result = prime * result
                + ((sourceName == null) ? 0 : sourceName.hashCode());
        result = prime
                * result
                + ((spillSequenceNum == null) ? 0 : spillSequenceNum.hashCode());
        result = prime * result + ((tankId == null) ? 0 : tankId.hashCode());
        result = prime * result
                + ((tankNumber == null) ? 0 : tankNumber.hashCode());
        result = prime * result
                + ((tankSequenceNum == null) ? 0 : tankSequenceNum.hashCode());
        result = prime * result
                + ((tankSize == null) ? 0 : tankSize.hashCode());
        result = prime * result
                + ((testMethodCode == null) ? 0 : testMethodCode.hashCode());
        result = prime * result
                + ((testMethodName == null) ? 0 : testMethodName.hashCode());
        result = prime * result
                + ((ustIndicator == null) ? 0 : ustIndicator.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        SpTankTest other = (SpTankTest) obj;
        if (causeCode == null) {
            if (other.causeCode != null)
                return false;
        } else if (!causeCode.equals(other.causeCode))
            return false;
        if (causeName == null) {
            if (other.causeName != null)
                return false;
        } else if (!causeName.equals(other.causeName))
            return false;
        if (epaUstIndicator == null) {
            if (other.epaUstIndicator != null)
                return false;
        } else if (!epaUstIndicator.equals(other.epaUstIndicator))
            return false;
        if (grossFailureIndicator == null) {
            if (other.grossFailureIndicator != null)
                return false;
        } else if (!grossFailureIndicator.equals(other.grossFailureIndicator))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (leakRate == null) {
            if (other.leakRate != null)
                return false;
        } else if (!leakRate.equals(other.leakRate))
            return false;
        if (material == null) {
            if (other.material != null)
                return false;
        } else if (!material.equals(other.material))
            return false;
        if (sourceCode == null) {
            if (other.sourceCode != null)
                return false;
        } else if (!sourceCode.equals(other.sourceCode))
            return false;
        if (sourceName == null) {
            if (other.sourceName != null)
                return false;
        } else if (!sourceName.equals(other.sourceName))
            return false;
        if (spillSequenceNum == null) {
            if (other.spillSequenceNum != null)
                return false;
        } else if (!spillSequenceNum.equals(other.spillSequenceNum))
            return false;
        if (tankId == null) {
            if (other.tankId != null)
                return false;
        } else if (!tankId.equals(other.tankId))
            return false;
        if (tankNumber == null) {
            if (other.tankNumber != null)
                return false;
        } else if (!tankNumber.equals(other.tankNumber))
            return false;
        if (tankSequenceNum == null) {
            if (other.tankSequenceNum != null)
                return false;
        } else if (!tankSequenceNum.equals(other.tankSequenceNum))
            return false;
        if (tankSize == null) {
            if (other.tankSize != null)
                return false;
        } else if (!tankSize.equals(other.tankSize))
            return false;
        if (testMethodCode == null) {
            if (other.testMethodCode != null)
                return false;
        } else if (!testMethodCode.equals(other.testMethodCode))
            return false;
        if (testMethodName == null) {
            if (other.testMethodName != null)
                return false;
        } else if (!testMethodName.equals(other.testMethodName))
            return false;
        if (ustIndicator == null) {
            if (other.ustIndicator != null)
                return false;
        } else if (!ustIndicator.equals(other.ustIndicator))
            return false;
        return true;
    }

}