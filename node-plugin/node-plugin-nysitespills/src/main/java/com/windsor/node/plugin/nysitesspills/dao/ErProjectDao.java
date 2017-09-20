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
import com.windsor.node.plugin.nysitesspills.domain.ErProject;

public class ErProjectDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_PROJECTS";

    public static final String PROJECTS_SEQ = "PROJECTS_SEQ";
    public static final String OPERABLE_UNIT_SEQ = "OPERABLE_UNIT_SEQ";
    public static final String PROJECT_ID = "PROJECT_ID";
    public static final String FUNDING_SOURCE_CODE = "FUNDING_SOURCE_CODE";
    public static final String FUNDING_SOURCE_DESC = "FUNDING_SOURCE_DESC";
    public static final String PROJECT_TYPE_CODE = "PROJECT_TYPE_CODE";
    public static final String PROJECT_TYPE_DESC = "PROJECT_TYPE_DESC";
    public static final String SEQ_NBR = "SEQ_NBR";
    public static final String REFER_NAME = "REFER_NAME";
    public static final String BASE_START_DATE = "BASE_START_DATE";
    public static final String BASE_END_DATE = "BASE_END_DATE";
    public static final String START_DATE = "START_DATE";
    public static final String START_STATUS = "START_STATUS";
    public static final String END_DATE = "END_DATE";
    public static final String END_STATUS = "END_STATUS";
    public static final String REVISED_START_DATE = "REVISED_START_DATE";
    public static final String REVISED_START_STATUS = "REVISED_START_STATUS";
    public static final String REVISED_END_DATE = "REVISED_END_DATE";
    public static final String REVISED_END_STATUS = "REVISED_END_STATUS";
    public static final String REVISED_REASON = "REVISED_REASON";
    public static final String CUR_START_DATE = "CUR_START_DATE";
    public static final String CUR_START_STATUS = "CUR_START_STATUS";
    public static final String CUR_END_DATE = "CUR_END_DATE";
    public static final String CUR_END_STATUS = "CUR_END_STATUS";
    public static final String PROJECT_MANAGER = "PROJECT_MANAGER";
    public static final String LEAD_AGENCY = "LEAD_AGENCY";
    public static final String LEAD_DIVISION = "LEAD_DIVISION";
    public static final String LEAD_BUREAU = "LEAD_BUREAU";
    public static final String LEAD_OFFICE = "LEAD_OFFICE";
    public static final String PROJECT_DESC = "PROJECT_DESC";
    public static final String PROJECT_NOTES = "PROJECT_NOTES";
    public static final String CURRENT_STATUS = "CURRENT_STATUS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + OPERABLE_UNIT_SEQ + EQUALS_PARAM;

    protected void checkDaoConfig() {
        super.checkDaoConfig();
    }

    public List getProjectsForOpUnitSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getProjectsForOpUnitSeqNum");

        List projects = null;
        logger.debug("sql: " + SQL_SELECT + ", OpUnitSeqNum = " + seqNum);

        projects = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ErProjectMapper());
        logger.debug("Found " + projects.size()
                + " ErProjects for OpUnitSeqNum " + seqNum);

        return projects;

    }

    private class ErProjectMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErProject p = new ErProject();

            p.setProjectsSequenceNum(getInteger(rs, PROJECTS_SEQ));
            p.setOperableUnitSequenceNum(getInteger(rs, OPERABLE_UNIT_SEQ));
            p.setProjectId(getInteger(rs, PROJECT_ID));

            p
                    .setFundingSourceCode(trimToXml(rs
                            .getString(FUNDING_SOURCE_CODE)));
            p.setFundingSourceDescription(trimToXml(rs
                    .getString(FUNDING_SOURCE_DESC)));
            p.setProjectTypeCode(trimToXml(rs.getString(PROJECT_TYPE_CODE)));
            p.setProjectTypeDescription(trimToXml(rs
                    .getString(PROJECT_TYPE_DESC)));
            p.setSequenceNum(trimToXml(rs.getString(SEQ_NBR)));
            p.setReferName(trimToXml(rs.getString(REFER_NAME)));
            p.setStartStatus(trimToXml(rs.getString(START_STATUS)));
            p.setEndStatus(trimToXml(rs.getString(END_STATUS)));
            p.setRevisedStartStatus(trimToXml(rs
                    .getString(REVISED_START_STATUS)));
            p.setRevisedEndStatus(trimToXml(rs.getString(REVISED_END_STATUS)));
            p.setRevisedReason(trimToXml(rs.getString(REVISED_REASON)));
            p.setCurrentStartStatus(trimToXml(rs.getString(CUR_START_STATUS)));
            p.setCurrentEndStatus(trimToXml(rs.getString(CUR_END_STATUS)));
            p.setProjectManager(trimToXml(rs.getString(PROJECT_MANAGER)));
            p.setLeadAgency(trimToXml(rs.getString(LEAD_AGENCY)));
            p.setLeadDivision(trimToXml(rs.getString(LEAD_DIVISION)));
            p.setLeadBureau(trimToXml(rs.getString(LEAD_BUREAU)));
            p.setLeadOffice(trimToXml(rs.getString(LEAD_OFFICE)));
            p.setProjectDescription(trimToXml(rs.getString(PROJECT_DESC)));
            p.setProjectNotes(trimToXml(rs.getString(PROJECT_NOTES)));
            p.setCurrentStatus(trimToXml(rs.getString(CURRENT_STATUS)));

            p.setBaseStartDate(rs.getTimestamp(BASE_START_DATE));
            p.setBaseEndDate(rs.getTimestamp(BASE_END_DATE));
            p.setStartDate(rs.getTimestamp(START_DATE));
            p.setEndDate(rs.getTimestamp(END_DATE));
            p.setRevisedStartDate(rs.getTimestamp(REVISED_START_DATE));
            p.setRevisedEndDate(rs.getTimestamp(REVISED_END_DATE));
            p.setCurrentStartDate(rs.getTimestamp(CUR_START_DATE));
            p.setCurrentEndDate(rs.getTimestamp(CUR_END_DATE));

            return p;
        }
    }
}