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

public class ControlElement extends BaseSitesSpillsDomainObject {

    private Integer controlElementSequenceNum;
    private Integer controlSequenceNum;

    private String controlElementCode;
    private String controlElementName;

    public Integer getControlElementSequenceNum() {
        return controlElementSequenceNum;
    }

    public void setControlElementSequenceNum(Integer controlElementSequenceNum) {
        this.controlElementSequenceNum = controlElementSequenceNum;
    }

    public Integer getControlSequenceNum() {
        return controlSequenceNum;
    }

    public void setControlSequenceNum(Integer controlSequenceNum) {
        this.controlSequenceNum = controlSequenceNum;
    }

    public String getControlElementCode() {
        return controlElementCode;
    }

    public void setControlElementCode(String controlElementCode) {
        this.controlElementCode = controlElementCode;
    }

    public String getControlElementName() {
        return controlElementName;
    }

    public void setControlElementName(String controlElementName) {
        this.controlElementName = controlElementName;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((controlElementCode == null) ? 0 : controlElementCode
                        .hashCode());
        result = prime
                * result
                + ((controlElementName == null) ? 0 : controlElementName
                        .hashCode());
        result = prime
                * result
                + ((controlElementSequenceNum == null) ? 0
                        : controlElementSequenceNum.hashCode());
        result = prime
                * result
                + ((controlSequenceNum == null) ? 0 : controlSequenceNum
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
        ControlElement other = (ControlElement) obj;
        if (controlElementCode == null) {
            if (other.controlElementCode != null)
                return false;
        } else if (!controlElementCode.equals(other.controlElementCode))
            return false;
        if (controlElementName == null) {
            if (other.controlElementName != null)
                return false;
        } else if (!controlElementName.equals(other.controlElementName))
            return false;
        if (controlElementSequenceNum == null) {
            if (other.controlElementSequenceNum != null)
                return false;
        } else if (!controlElementSequenceNum
                .equals(other.controlElementSequenceNum))
            return false;
        if (controlSequenceNum == null) {
            if (other.controlSequenceNum != null)
                return false;
        } else if (!controlSequenceNum.equals(other.controlSequenceNum))
            return false;
        return true;
    }

}