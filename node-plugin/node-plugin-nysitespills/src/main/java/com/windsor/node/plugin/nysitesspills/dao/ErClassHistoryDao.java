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
import com.windsor.node.plugin.nysitesspills.domain.ErClassHistory;

public class ErClassHistoryDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_CLASS_HISTORY";

    public static final String CLASS_HISTORY_SEQ = "CLASS_HISTORY_SEQ";
    public static final String SITE_SEQ = "SITE_SEQ";
    public static final String CLASS_HIST_SEQ_NBR = "CLASS_HIST_SEQ_NBR";
    public static final String SITE_NAME = "SITE_NAME";
    public static final String OLD_CLASS = "OLD_CLASS";
    public static final String NEW_CLASS = "NEW_CLASS";
    public static final String REQUEST_DATE = "REQUEST_DATE";
    public static final String CHANGE_ADDED_DATE = "CHANGE_ADDED_DATE";
    public static final String PROJECT_MANAGER = "PROJECT_MANAGER";
    public static final String PM_ADDRESS = "PM_ADDRESS";
    public static final String PM_CITY = "PM_CITY";
    public static final String PM_STATE = "PM_STATE";
    public static final String PM_ZIP_CODE = "PM_ZIP_CODE";
    public static final String PM_PHONE = "PM_PHONE";
    public static final String COMMENT_TYPE = "COMMENT_TYPE";
    public static final String COMMENTS = "COMMENTS";
    public static final String BCP_INCOMPLETE_APP_DATE = "BCP_INCOMPLETE_APP_DATE";
    public static final String FINALIZED_DATE = "FINALIZED_DATE";
    public static final String SCS_COMMENTS = "SCS_COMMENTS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + SITE_SEQ + EQUALS_PARAM + ORDER_BY + CLASS_HISTORY_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getErClassHistoriesForSiteSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getErClassHistoriesForSiteSeqNum");

        logger.debug("sql: " + SQL_SELECT + ", SiteSeqNum = " + seqNum);
        List histories = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ClassHistoryMapper());

        logger.debug("Found " + histories.size()
                + " ErClassHistories for SiteSeqNum " + seqNum);
        return histories;
    }

    private class ClassHistoryMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErClassHistory h = new ErClassHistory();

            h.setClassHistorySequenceNum(getInteger(rs, CLASS_HISTORY_SEQ));
            h.setSiteSequenceNum(getInteger(rs, SITE_SEQ));

            h.setClassHistSeqNbr(trimToXml(rs.getString(CLASS_HIST_SEQ_NBR)));
            h.setSiteName(trimToXml(rs.getString(SITE_NAME)));
            h.setOldClass(trimToXml(rs.getString(OLD_CLASS)));
            h.setNewClass(trimToXml(rs.getString(NEW_CLASS)));
            h.setProjectManager(trimToXml(rs.getString(PROJECT_MANAGER)));
            h.setPmAddress(trimToXml(rs.getString(PM_ADDRESS)));
            h.setPmCity(trimToXml(rs.getString(PM_CITY)));
            h.setPmState(trimToXml(rs.getString(PM_STATE)));
            h.setPmZipCode(trimToXml(rs.getString(PM_ZIP_CODE)));
            h.setPmPhone(trimToXml(rs.getString(PM_PHONE)));
            h.setCommentType(trimToXml(rs.getString(COMMENT_TYPE)));
            h.setComments(trimToXml(rs.getString(COMMENTS)));
            h.setScsComments(trimToXml(rs.getString(SCS_COMMENTS)));

            h.setRequestDate(rs.getTimestamp(REQUEST_DATE));
            h.setChangeAddedDate(rs.getTimestamp(CHANGE_ADDED_DATE));
            h.setBcpIncompleteAppDate(rs.getTimestamp(BCP_INCOMPLETE_APP_DATE));
            h.setFinalizedDate(rs.getTimestamp(FINALIZED_DATE));

            return h;
        }
    }
}