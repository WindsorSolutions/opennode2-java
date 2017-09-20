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

package com.windsor.node.plugin.nysitesspills.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import com.windsor.node.plugin.common.dao.BaseJdbcDao;
import com.windsor.node.plugin.nysitesspills.domain.ProgramAffiliation;

public class ProgramAffiliationDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_PROGRAM_AFFILIATION";
    public static final String PROGRAMS_TABLE_NAME = "UIS_PROGRAMS";

    public static final String PROGRAM_AFFILIATION_SEQ = "PROGRAM_AFFILIATION_SEQ";
    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";
    public static final String AFFILIATION_ID = "AFFILIATION_ID";
    public static final String FACILITY_ID = "FACILITY_ID";
    public static final String SITE_ID = "SITE_ID";
    public static final String AFFILIATION_TYPE_CODE = "AFFILIATION_TYPE_CODE";
    public static final String AFFILIATION_TYPE_NAME = "AFFILIATION_TYPE_NAME";
    public static final String AFFILIATION_SUBTYPE_CODE = "AFFILIATION_SUBTYPE_CODE";
    public static final String AFFILIATION_SUBTYPE_NAME = "AFFILIATION_SUBTYPE_NAME";
    public static final String SEQ_NUMBER = "SEQ_NUMBER";
    public static final String START_DATE = "START_DATE";
    public static final String END_DATE = "END_DATE";
    public static final String COMPANY = "COMPANY";
    public static final String FEDERAL_ID = "FEDERAL_ID";
    public static final String CONTACT_TITLE = "CONTACT_TITLE";
    public static final String CONTACT_NAME = "CONTACT_NAME";
    public static final String ADDRESS_ONE = "ADDRESS_ONE";
    public static final String ADDRESS_TWO = "ADDRESS_TWO";
    public static final String CITY = "CITY";
    public static final String STATE = "STATE";
    public static final String ZIP_CODE = "ZIP_CODE";
    public static final String COUNTRY_CODE = "COUNTRY_CODE";
    public static final String PHONE = "PHONE";
    public static final String PHONE_EXT = "PHONE_EXT";
    public static final String EMAIL = "EMAIL";
    public static final String FAX = "FAX";
    public static final String MODIFIED_BY = "MODIFIED_BY";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";

    public static final String SQL_SELECT = "select a.PROGRAM_AFFILIATION_SEQ, a.PROGRAMS_SEQ, a.AFFILIATION_ID, "
            + "a.AFFILIATION_TYPE_CODE, a.AFFILIATION_TYPE_NAME, a.AFFILIATION_SUBTYPE_CODE, a.AFFILIATION_SUBTYPE_NAME, "
            + "a.SEQ_NUMBER, a.START_DATE, a.END_DATE, a.COMPANY, a.FEDERAL_ID, a.CONTACT_TITLE, a.CONTACT_NAME, "
            + "a.ADDRESS_ONE, a.ADDRESS_TWO, a.CITY, a.STATE, a.ZIP_CODE, a.COUNTRY_CODE, a.PHONE,a.PHONE_EXT, a.EMAIL, "
            + "a.FAX, a.MODIFIED_BY, a.LAST_MODIFIED, p.SITE_ID, p.FACILITY_ID "
            + "from UIS_PROGRAM_AFFILIATION a, UIS_PROGRAMS p ";

    public static final String SQL_ORDER_BY = "order by a.PROGRAM_AFFILIATION_SEQ";

    public static final String SQL_PROG_SEQ_EQUALS = "p.PROGRAMS_SEQ = a.PROGRAMS_SEQ ";

    public static final String SQL_SELECT_FOR_PROGRAM_SEQ = SQL_SELECT
            + "where a.PROGRAMS_SEQ = ? " + AND + SQL_PROG_SEQ_EQUALS
            + SQL_ORDER_BY;

    public static final String SQL_SELECT_ALL = SQL_SELECT + WHERE
            + SQL_PROG_SEQ_EQUALS + SQL_ORDER_BY;

    public static final String SQL_SELECT_LIMIT = SQL_SELECT + WHERE
            + SQL_PROG_SEQ_EQUALS + AND + ROWNUM_PARAM + SQL_ORDER_BY;

    protected void checkDaoConfig() {
        super.checkDaoConfig();
    }

    public List getAffiliations() {

        checkDaoConfig();
        logger.debug("getAffiliations");

        List affiliations = null;
        logger.debug("sql: " + SQL_SELECT_ALL);

        affiliations = getJdbcTemplate().query(SQL_SELECT_ALL, new Object[] {},
                new ProgramAffiliationMapper());

        logger.debug("Found " + affiliations.size() + " ProgramAffiliations");

        return affiliations;
    }

    public List getAffiliations(int maxRows) {

        checkDaoConfig();
        logger.debug("getAffiliations(maxRows)");

        List affiliations = null;
        logger.debug("sql: " + SQL_SELECT_LIMIT);

        affiliations = getJdbcTemplate().query(SQL_SELECT_LIMIT,
                new Object[] { new Integer(maxRows) },
                new ProgramAffiliationMapper());

        logger.debug("Asked for " + maxRows + " ProgramAffiliations, found "
                + affiliations.size());

        return affiliations;
    }

    public List getAffiliationsForProgramSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getAffiliationForProgramSeqNum");

        List affiliations = null;
        logger.debug("sql: " + SQL_SELECT_FOR_PROGRAM_SEQ
                + ", DerProgramSeqNum = " + seqNum);

        affiliations = getJdbcTemplate().query(SQL_SELECT_FOR_PROGRAM_SEQ,
                new Object[] { new Integer(seqNum) },
                new ProgramAffiliationMapper());

        logger.debug("Found " + affiliations.size()
                + " ProgramAffiliations for DerProgramSeqNum " + seqNum);

        return affiliations;
    }

    private class ProgramAffiliationMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ProgramAffiliation pa = new ProgramAffiliation();

            pa
                    .setAffiliationSequenceNum(getInteger(rs,
                            PROGRAM_AFFILIATION_SEQ));
            pa.setProgramSequenceNum(getInteger(rs, PROGRAMS_SEQ));
            pa.setAffiliationId(getInteger(rs, AFFILIATION_ID));

            pa.setFacilityId(getInteger(rs, FACILITY_ID));
            pa.setSiteId(getInteger(rs, SITE_ID));

            pa.setStartDate(rs.getTimestamp(START_DATE));
            pa.setEndDate(rs.getTimestamp(END_DATE));
            pa.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            pa.setAffiliationTypeCode(trimToXml(rs
                    .getString(AFFILIATION_TYPE_CODE)));
            pa.setAffiliationTypeName(trimToXml(rs
                    .getString(AFFILIATION_TYPE_NAME)));
            pa.setAffiliationSubTypeCode(trimToXml(rs
                    .getString(AFFILIATION_SUBTYPE_CODE)));
            pa.setAffiliationSubTypeName(trimToXml(rs
                    .getString(AFFILIATION_SUBTYPE_NAME)));
            pa.setSequenceNum(trimToXml(rs.getString(SEQ_NUMBER)));
            pa.setCompany(trimToXml(rs.getString(COMPANY)));
            pa.setFederalId(trimToXml(rs.getString(FEDERAL_ID)));
            pa.setContactTitle(trimToXml(rs.getString(CONTACT_TITLE)));
            pa.setContactName(trimToXml(rs.getString(CONTACT_NAME)));
            pa.setAddressOne(trimToXml(rs.getString(ADDRESS_ONE)));
            pa.setAddressTwo(trimToXml(rs.getString(ADDRESS_TWO)));
            pa.setCity(trimToXml(rs.getString(CITY)));
            pa.setState(trimToXml(rs.getString(STATE)));
            pa.setZipCode(trimToXml(rs.getString(ZIP_CODE)));
            pa.setCountryCode(trimToXml(rs.getString(COUNTRY_CODE)));
            pa.setPhone(trimToXml(rs.getString(PHONE)));
            pa.setPhoneExt(trimToXml(rs.getString(PHONE_EXT)));
            pa.setEmail(trimToXml(rs.getString(EMAIL)));
            pa.setFax(trimToXml(rs.getString(FAX)));
            pa.setModifiedBy(trimToXml(rs.getString(MODIFIED_BY)));

            return pa;
        }
    }

}