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

public class MaterialFamilyCode extends BaseSitesSpillsDomainObject {

    private String materialFamilyCode;
    private String materialFamilyName;
    private String materialFamilyDescription;

    public String getMaterialFamilyCode() {
        return materialFamilyCode;
    }

    public void setMaterialFamilyCode(String materialFamilyCode) {
        this.materialFamilyCode = materialFamilyCode;
    }

    public String getMaterialFamilyName() {
        return materialFamilyName;
    }

    public void setMaterialFamilyName(String materialFamilyName) {
        this.materialFamilyName = materialFamilyName;
    }

    public String getMaterialFamilyDescription() {
        return materialFamilyDescription;
    }

    public void setMaterialFamilyDescription(String materialFamilyDecription) {
        this.materialFamilyDescription = materialFamilyDecription;
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime
                * result
                + ((materialFamilyCode == null) ? 0 : materialFamilyCode
                        .hashCode());
        result = prime
                * result
                + ((materialFamilyDescription == null) ? 0
                        : materialFamilyDescription.hashCode());
        result = prime
                * result
                + ((materialFamilyName == null) ? 0 : materialFamilyName
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
        MaterialFamilyCode other = (MaterialFamilyCode) obj;
        if (materialFamilyCode == null) {
            if (other.materialFamilyCode != null)
                return false;
        } else if (!materialFamilyCode.equals(other.materialFamilyCode))
            return false;
        if (materialFamilyDescription == null) {
            if (other.materialFamilyDescription != null)
                return false;
        } else if (!materialFamilyDescription
                .equals(other.materialFamilyDescription))
            return false;
        if (materialFamilyName == null) {
            if (other.materialFamilyName != null)
                return false;
        } else if (!materialFamilyName.equals(other.materialFamilyName))
            return false;
        return true;
    }

}