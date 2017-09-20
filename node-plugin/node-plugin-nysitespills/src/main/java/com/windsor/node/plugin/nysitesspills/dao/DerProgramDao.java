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
import com.windsor.node.plugin.nysitesspills.domain.DerProgram;

public class DerProgramDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_PROGRAMS";
    public static final String FACILITY_TABLE_NAME = "UIS_FACILITY";

    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";
    public static final String SITE_ID = "SITE_ID";
    public static final String FACILITY_ID = "FACILITY_ID";
    public static final String PROGRAM_NUMBER = "PROGRAM_NUMBER";
    public static final String PROGRAM_TYPE_CODE = "PROGRAM_TYPE_CODE";
    public static final String PROGRAM_TYPE_NAME = "PROGRAM_TYPE_NAME";
    public static final String FACILITY_NAME = "FACILITY_NAME";
    public static final String START_DATE = "START_DATE";
    public static final String START_QUALIFIER = "START_QUALIFIER";
    public static final String END_DATE = "END_DATE";
    public static final String END_QUALIFIER = "END_QUALIFIER";
    public static final String EDOCS_PATH = "EDOCS_PATH";
    public static final String NEW_EDOCS_PATH = "NEW_EDOCS_PATH";
    public static final String EDOC_NEW = "EDOC_NEW";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";
    public static final String FACILITY_SEQ = "FACILITY_SEQ";
    public static final String ADDRESS_ONE = "ADDRESS_ONE";
    public static final String ADDRESS_TWO = "ADDRESS_TWO";
    public static final String LOCALITY = "LOCALITY";
    public static final String ZIP_CODE = "ZIP_CODE";
    public static final String SWIS_CODE = "SWIS_CODE";

    public static final String SQL_SELECT = "select p.PROGRAMS_SEQ, p.SITE_ID, p.FACILITY_ID, p.PROGRAM_NUMBER, p.PROGRAM_TYPE_CODE, "
            + "p.PROGRAM_TYPE_NAME, p.FACILITY_NAME, p.START_DATE, p.START_QUALIFIER, p.END_DATE, p.END_QUALIFIER, "
            + "p.EDOCS_PATH, p.NEW_EDOCS_PATH, p.EDOC_NEW, p.LAST_MODIFIED, f.FACILITY_SEQ, f.ADDRESS_ONE, f.ADDRESS_TWO, f.LOCALITY, "
            + "f.ZIP_CODE, f.SWIS_CODE "
            + "from UIS_PROGRAMS p, UIS_FACILITY f "
            + "where f.FACILITY_ID = p.FACILITY_ID and f.PROGRAMS_SEQ = p.PROGRAMS_SEQ";

    public static final String SQL_ORDER_BY = ORDER_BY + "p.PROGRAMS_SEQ";

    public static final String SQL_SELECT_ALL = SQL_SELECT + SQL_ORDER_BY;

    public static final String SQL_SELECT_LIMIT = SQL_SELECT + AND
            + ROWNUM_PARAM + SQL_ORDER_BY;

    protected void checkDaoConfig() {
        super.checkDaoConfig();
    }

    public List getDerProgramsAndFacilities(int maxRows) {

        checkDaoConfig();
        logger.debug("getDerProgramsAndFacilities(maxRows)");

        List programs = null;
        logger.debug("sql: " + SQL_SELECT_LIMIT);

        programs = getJdbcTemplate().query(SQL_SELECT_LIMIT,
                new Object[] { new Integer(maxRows) }, new DerProgramMapper());

        logger.debug("Asked for the first " + maxRows + " DerPrograms, found "
                + programs.size());

        return programs;

    }

    public List getDerProgramsAndFacilities() {

        checkDaoConfig();
        logger.debug("getDerProgramsAndFacilities");

        List programs = null;
        logger.debug("sql: " + SQL_SELECT_ALL);

        programs = getJdbcTemplate().query(SQL_SELECT_ALL, new Object[] {},
                new DerProgramMapper());

        logger.debug("Found " + programs.size() + " DerPrograms");

        return programs;

    }

    private class DerProgramMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            DerProgram program = new DerProgram();

            program.setProgramSequenceNum(getInteger(rs, PROGRAMS_SEQ));
            program.setSiteId(getInteger(rs, SITE_ID));
            program.setFacilityId(getInteger(rs, FACILITY_ID));
            program.setFacilitySequenceNum(getInteger(rs, FACILITY_SEQ));

            program.setProgramNum(trimToXml(rs.getString(PROGRAM_NUMBER)));
            program.setProgramTypeCode(trimToXml(rs
                    .getString(PROGRAM_TYPE_CODE)));
            program.setProgramTypeName(trimToXml(rs
                    .getString(PROGRAM_TYPE_NAME)));
            program.setFacilityName(trimToXml(rs.getString(FACILITY_NAME)));
            program.setStartQualifier(trimToXml(rs.getString(START_QUALIFIER)));
            program.setEndQualifier(trimToXml(rs.getString(END_QUALIFIER)));
            program.setEdocsPath(trimToXml(rs.getString(EDOCS_PATH)));
            program.setNewEdocsPath(trimToXml(rs.getString(NEW_EDOCS_PATH)));
            program.setEdocNew(trimToXml(rs.getString(EDOC_NEW)));
            program.setFacilityAddressOne(trimToXml(rs.getString(ADDRESS_ONE)));
            program.setFacilityAddressTwo(trimToXml(rs.getString(ADDRESS_TWO)));
            program.setFacilityLocality(trimToXml(rs.getString(LOCALITY)));
            program.setFacilityZipCode(trimToXml(rs.getString(ZIP_CODE)));
            program.setFacilitySwisCode(trimToXml(rs.getString(SWIS_CODE)));

            program.setStartDate(rs.getTimestamp(START_DATE));

            program.setEndDate(rs.getTimestamp(END_DATE));
            program.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            return program;
        }

    }
}