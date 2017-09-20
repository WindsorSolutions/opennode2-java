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

public class ProgramAffiliation extends BaseSitesSpillsDomainObject {

    private Integer affiliationSequenceNum;
    private Integer programSequenceNum;
    private Integer affiliationId;
    private Integer facilityId;
    private Integer siteId;

    private String affiliationTypeCode;
    private String affiliationTypeName;
    private String affiliationSubTypeCode;
    private String affiliationSubTypeName;
    private String sequenceNum;
    private String company;
    private String federalId;
    private String contactTitle;
    private String contactName;
    private String addressOne;
    private String addressTwo;
    private String city;
    private String state;
    private String zipCode;
    private String countryCode;
    private String phone;
    private String phoneExt;
    private String email;
    private String fax;
    private String modifiedBy;

    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp lastModified;

    public String getStartDateString() {

        return getFormattedDateString(getStartDate());
    }

    public String getEndDateString() {

        return getFormattedDateString(getEndDate());
    }

    public String getLastModifiedString() {

        return getFormattedDateString(getLastModified());
    }

    public Integer getAffiliationSequenceNum() {
        return affiliationSequenceNum;
    }

    public void setAffiliationSequenceNum(Integer affiliationSequenceNum) {
        this.affiliationSequenceNum = affiliationSequenceNum;
    }

    public Integer getProgramSequenceNum() {
        return programSequenceNum;
    }

    public void setProgramSequenceNum(Integer programSequenceNum) {
        this.programSequenceNum = programSequenceNum;
    }

    public Integer getAffiliationId() {
        return affiliationId;
    }

    public void setAffiliationId(Integer affiliationId) {
        this.affiliationId = affiliationId;
    }

    public Integer getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(Integer facilityId) {
        this.facilityId = facilityId;
    }

    public Integer getSiteId() {
        return siteId;
    }

    public void setSiteId(Integer siteId) {
        this.siteId = siteId;
    }

    public String getAffiliationTypeCode() {
        return affiliationTypeCode;
    }

    public void setAffiliationTypeCode(String affiliationTypeCode) {
        this.affiliationTypeCode = affiliationTypeCode;
    }

    public String getAffiliationTypeName() {
        return affiliationTypeName;
    }

    public void setAffiliationTypeName(String affiliationTypeName) {
        this.affiliationTypeName = affiliationTypeName;
    }

    public String getAffiliationSubTypeCode() {
        return affiliationSubTypeCode;
    }

    public void setAffiliationSubTypeCode(String affiliationSubTypeCode) {
        this.affiliationSubTypeCode = affiliationSubTypeCode;
    }

    public String getAffiliationSubTypeName() {
        return affiliationSubTypeName;
    }

    public void setAffiliationSubTypeName(String affiliationSubTypeName) {
        this.affiliationSubTypeName = affiliationSubTypeName;
    }

    public String getSequenceNum() {
        return sequenceNum;
    }

    public void setSequenceNum(String sequenceNum) {
        this.sequenceNum = sequenceNum;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getFederalId() {
        return federalId;
    }

    public void setFederalId(String federalId) {
        this.federalId = federalId;
    }

    public String getContactTitle() {
        return contactTitle;
    }

    public void setContactTitle(String contactTitle) {
        this.contactTitle = contactTitle;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getAddressOne() {
        return addressOne;
    }

    public void setAddressOne(String addressOne) {
        this.addressOne = addressOne;
    }

    public String getAddressTwo() {
        return addressTwo;
    }

    public void setAddressTwo(String addressTwo) {
        this.addressTwo = addressTwo;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPhoneExt() {
        return phoneExt;
    }

    public void setPhoneExt(String phoneExt) {
        this.phoneExt = phoneExt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
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

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result
                + ((addressOne == null) ? 0 : addressOne.hashCode());
        result = prime * result
                + ((addressTwo == null) ? 0 : addressTwo.hashCode());
        result = prime * result
                + ((affiliationId == null) ? 0 : affiliationId.hashCode());
        result = prime
                * result
                + ((affiliationSequenceNum == null) ? 0
                        : affiliationSequenceNum.hashCode());
        result = prime
                * result
                + ((affiliationSubTypeCode == null) ? 0
                        : affiliationSubTypeCode.hashCode());
        result = prime
                * result
                + ((affiliationSubTypeName == null) ? 0
                        : affiliationSubTypeName.hashCode());
        result = prime
                * result
                + ((affiliationTypeCode == null) ? 0 : affiliationTypeCode
                        .hashCode());
        result = prime
                * result
                + ((affiliationTypeName == null) ? 0 : affiliationTypeName
                        .hashCode());
        result = prime * result + ((city == null) ? 0 : city.hashCode());
        result = prime * result + ((company == null) ? 0 : company.hashCode());
        result = prime * result
                + ((contactName == null) ? 0 : contactName.hashCode());
        result = prime * result
                + ((contactTitle == null) ? 0 : contactTitle.hashCode());
        result = prime * result
                + ((countryCode == null) ? 0 : countryCode.hashCode());
        result = prime * result + ((email == null) ? 0 : email.hashCode());
        result = prime * result + ((endDate == null) ? 0 : endDate.hashCode());
        result = prime * result
                + ((facilityId == null) ? 0 : facilityId.hashCode());
        result = prime * result + ((fax == null) ? 0 : fax.hashCode());
        result = prime * result
                + ((federalId == null) ? 0 : federalId.hashCode());
        result = prime * result
                + ((lastModified == null) ? 0 : lastModified.hashCode());
        result = prime * result
                + ((modifiedBy == null) ? 0 : modifiedBy.hashCode());
        result = prime * result + ((phone == null) ? 0 : phone.hashCode());
        result = prime * result
                + ((phoneExt == null) ? 0 : phoneExt.hashCode());
        result = prime
                * result
                + ((programSequenceNum == null) ? 0 : programSequenceNum
                        .hashCode());
        result = prime * result
                + ((sequenceNum == null) ? 0 : sequenceNum.hashCode());
        result = prime * result + ((siteId == null) ? 0 : siteId.hashCode());
        result = prime * result
                + ((startDate == null) ? 0 : startDate.hashCode());
        result = prime * result + ((state == null) ? 0 : state.hashCode());
        result = prime * result + ((zipCode == null) ? 0 : zipCode.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        ProgramAffiliation other = (ProgramAffiliation) obj;
        if (addressOne == null) {
            if (other.addressOne != null)
                return false;
        } else if (!addressOne.equals(other.addressOne))
            return false;
        if (addressTwo == null) {
            if (other.addressTwo != null)
                return false;
        } else if (!addressTwo.equals(other.addressTwo))
            return false;
        if (affiliationId == null) {
            if (other.affiliationId != null)
                return false;
        } else if (!affiliationId.equals(other.affiliationId))
            return false;
        if (affiliationSequenceNum == null) {
            if (other.affiliationSequenceNum != null)
                return false;
        } else if (!affiliationSequenceNum.equals(other.affiliationSequenceNum))
            return false;
        if (affiliationSubTypeCode == null) {
            if (other.affiliationSubTypeCode != null)
                return false;
        } else if (!affiliationSubTypeCode.equals(other.affiliationSubTypeCode))
            return false;
        if (affiliationSubTypeName == null) {
            if (other.affiliationSubTypeName != null)
                return false;
        } else if (!affiliationSubTypeName.equals(other.affiliationSubTypeName))
            return false;
        if (affiliationTypeCode == null) {
            if (other.affiliationTypeCode != null)
                return false;
        } else if (!affiliationTypeCode.equals(other.affiliationTypeCode))
            return false;
        if (affiliationTypeName == null) {
            if (other.affiliationTypeName != null)
                return false;
        } else if (!affiliationTypeName.equals(other.affiliationTypeName))
            return false;
        if (city == null) {
            if (other.city != null)
                return false;
        } else if (!city.equals(other.city))
            return false;
        if (company == null) {
            if (other.company != null)
                return false;
        } else if (!company.equals(other.company))
            return false;
        if (contactName == null) {
            if (other.contactName != null)
                return false;
        } else if (!contactName.equals(other.contactName))
            return false;
        if (contactTitle == null) {
            if (other.contactTitle != null)
                return false;
        } else if (!contactTitle.equals(other.contactTitle))
            return false;
        if (countryCode == null) {
            if (other.countryCode != null)
                return false;
        } else if (!countryCode.equals(other.countryCode))
            return false;
        if (email == null) {
            if (other.email != null)
                return false;
        } else if (!email.equals(other.email))
            return false;
        if (endDate == null) {
            if (other.endDate != null)
                return false;
        } else if (!endDate.equals(other.endDate))
            return false;
        if (facilityId == null) {
            if (other.facilityId != null)
                return false;
        } else if (!facilityId.equals(other.facilityId))
            return false;
        if (fax == null) {
            if (other.fax != null)
                return false;
        } else if (!fax.equals(other.fax))
            return false;
        if (federalId == null) {
            if (other.federalId != null)
                return false;
        } else if (!federalId.equals(other.federalId))
            return false;
        if (lastModified == null) {
            if (other.lastModified != null)
                return false;
        } else if (!lastModified.equals(other.lastModified))
            return false;
        if (modifiedBy == null) {
            if (other.modifiedBy != null)
                return false;
        } else if (!modifiedBy.equals(other.modifiedBy))
            return false;
        if (phone == null) {
            if (other.phone != null)
                return false;
        } else if (!phone.equals(other.phone))
            return false;
        if (phoneExt == null) {
            if (other.phoneExt != null)
                return false;
        } else if (!phoneExt.equals(other.phoneExt))
            return false;
        if (programSequenceNum == null) {
            if (other.programSequenceNum != null)
                return false;
        } else if (!programSequenceNum.equals(other.programSequenceNum))
            return false;
        if (sequenceNum == null) {
            if (other.sequenceNum != null)
                return false;
        } else if (!sequenceNum.equals(other.sequenceNum))
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
        if (state == null) {
            if (other.state != null)
                return false;
        } else if (!state.equals(other.state))
            return false;
        if (zipCode == null) {
            if (other.zipCode != null)
                return false;
        } else if (!zipCode.equals(other.zipCode))
            return false;
        return true;
    }

}