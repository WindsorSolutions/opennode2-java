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
import com.windsor.node.plugin.nysitesspills.domain.ErClassChange;

public class ErClassChangeDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_CLASS_CHANGE";

    public static final String CLASS_CHANGE_SEQ = "CLASS_CHANGE_SEQ";
    public static final String CHANGE_ID = "CHANGE_ID";
    public static final String SITE_SEQ = "SITE_SEQ";
    public static final String HW_CODE = "HW_CODE";
    public static final String CLASS_CHG_SEQ_NBR = "CLASS_CHG_SEQ_NBR";
    public static final String INITIATED_BY = "INITIATED_BY";
    public static final String SECTION = "SECTION";
    public static final String DATE_CHANGE_RCVD = "DATE_CHANGE_RCVD";
    public static final String ACTION_REQUESTED = "ACTION_REQUESTED";
    public static final String SECTION_APPROV_DATE = "SECTION_APPROV_DATE";
    public static final String DEE_APPROV_DATE = "DEE_APPROV_DATE";
    public static final String DOH_APPROV_DATE = "DOH_APPROV_DATE";
    public static final String REM_APPROV_DATE = "REM_APPROV_DATE";
    public static final String BUREAU_APPROV_DATE = "BUREAU_APPROV_DATE";
    public static final String HOLD_START_DATE = "HOLD_START_DATE";
    public static final String SITE_NAME = "SITE_NAME";
    public static final String COMPLETION_DATE = "COMPLETION_DATE";
    public static final String REGION_APPROV_DATE = "REGION_APPROV_DATE";
    public static final String SEC_CHIEF_APPROV_DATE = "SEC_CHIEF_APPROV_DATE";
    public static final String CLASS_CHANGE_TYPE = "CLASS_CHANGE_TYPE";
    public static final String DUE_DATE = "DUE_DATE";
    public static final String ENGINEER_SIGN_DATE = "ENGINEER_SIGN_DATE";
    public static final String ASST_DIV_DIR_DATE = "ASST_DIV_DIR_DATE";
    public static final String PKG_HOLD_DATE = "PKG_HOLD_DATE";
    public static final String FINALIZED_DATE = "FINALIZED_DATE";
    public static final String COMMENTS = "COMMENTS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + SITE_SEQ + EQUALS_PARAM + ORDER_BY + CLASS_CHANGE_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getErClassChangesForSiteSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getErClassChangesForSiteSeqNum");

        logger.debug("sql: " + SQL_SELECT);
        List changes = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ClassChangeMapper());

        logger.debug("Found " + changes.size()
                + " ErClassChanges for SiteSeqNum " + seqNum);
        return changes;
    }

    private class ClassChangeMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErClassChange c = new ErClassChange();

            c.setClassChangeSequenceNum(getInteger(rs, CLASS_CHANGE_SEQ));
            c.setSiteSequenceNum(getInteger(rs, SITE_SEQ));
            c.setClassChangeId(getInteger(rs, CHANGE_ID));

            c.setHwCode(trimToXml(rs.getString(HW_CODE)));
            c.setClassChangeSeqNbr(trimToXml(rs.getString(CLASS_CHG_SEQ_NBR)));
            c.setInitiatedBy(trimToXml(rs.getString(INITIATED_BY)));
            c.setSection(trimToXml(rs.getString(SECTION)));
            c.setActionRequested(trimToXml(rs.getString(ACTION_REQUESTED)));
            c.setComments(trimToXml(rs.getString(COMMENTS)));
            c.setSiteName(trimToXml(rs.getString(SITE_NAME)));
            c.setClassChangeType(trimToXml(rs.getString(CLASS_CHANGE_TYPE)));

            c.setDateChangeReceived(rs.getTimestamp(DATE_CHANGE_RCVD));
            c.setSectionApproveDate(rs.getTimestamp(SECTION_APPROV_DATE));
            c.setDeeApproveDate(rs.getTimestamp(DEE_APPROV_DATE));
            c.setDohApproveDate(rs.getTimestamp(DOH_APPROV_DATE));
            c.setRemApproveDate(rs.getTimestamp(REM_APPROV_DATE));
            c.setBureauApproveDate(rs.getTimestamp(BUREAU_APPROV_DATE));
            c.setHoldStartDate(rs.getTimestamp(HOLD_START_DATE));
            c.setCompletionDate(rs.getTimestamp(COMPLETION_DATE));
            c.setRegionApproveDate(rs.getTimestamp(REGION_APPROV_DATE));
            c.setSecChiefApproveDate(rs.getTimestamp(SEC_CHIEF_APPROV_DATE));
            c.setDueDate(rs.getTimestamp(DUE_DATE));
            c.setEngineerSignDate(rs.getTimestamp(ENGINEER_SIGN_DATE));
            c.setAsstDivDirDate(rs.getTimestamp(ASST_DIV_DIR_DATE));
            c.setPkgHoldDate(rs.getTimestamp(PKG_HOLD_DATE));
            c.setFinalizedDate(rs.getTimestamp(FINALIZED_DATE));

            return c;
        }
    }
}