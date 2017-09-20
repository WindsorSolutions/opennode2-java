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
import com.windsor.node.plugin.nysitesspills.domain.Control;

public class ControlDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_CONTROLS";

    public static final String CONTROLS_SEQ = "CONTROLS_SEQ";
    public static final String ADJACENT_PROPERTY_SEQ = "ADJACENT_PROPERTY_SEQ";
    public static final String CONTROL_ID = "CONTROL_ID";
    public static final String CONTROL_CODE = "CONTROL_CODE";
    public static final String CONTROL_NAME = "CONTROL_NAME";
    public static final String CONTROL_SEQ = "CONTROL_SEQ";
    public static final String CONTROL_INPLACE_DATE = "CONTROL_INPLACE_DATE";
    public static final String CONTROL_END_DATE = "CONTROL_END_DATE";
    public static final String CERT_RCVD_DATE = "CERT_RCVD_DATE";
    public static final String CERT_NOTICE_SENT_DATE = "CERT_NOTICE_SENT_DATE";
    public static final String CERT_DUE_DATE = "CERT_DUE_DATE";
    public static final String CERT_ACCEPT_DATE = "CERT_ACCEPT_DATE";
    public static final String CERT_NEXT_DATE = "CERT_NEXT_DATE";
    public static final String FOLLOWUP_LETTER = "FOLLOWUP_LETTER";
    public static final String ENF_REFERAL_DATE = "ENF_REFERAL_DATE";
    public static final String AUDIT_DATE = "AUDIT_DATE";
    public static final String CONTROLS_DESC = "CONTROLS_DESC";
    public static final String AUDIT_SUMMARY = "AUDIT_SUMMARY";
    public static final String CERT_COMMENTS = "CERT_COMMENTS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + ADJACENT_PROPERTY_SEQ + EQUALS_PARAM + ORDER_BY
            + CONTROLS_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getControlsForAdjacentPropertySeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getControlsForAdjacentPropertySeqNum");

        logger.debug("sql: " + SQL_SELECT + ", ErAdjacentProperty seqNum = "
                + seqNum);
        List controls = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ControlMapper());

        logger.debug("Found " + controls.size()
                + " Controls for ErAdjacentProperty seqNum " + seqNum);

        return controls;

    }

    private class ControlMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            Control c = new Control();

            c.setControlSequenceNum(getInteger(rs, CONTROLS_SEQ));
            c.setAdjacentPropertySequenceNum(getInteger(rs,
                    ADJACENT_PROPERTY_SEQ));
            c.setControlId(getInteger(rs, CONTROL_ID));

            c.setControlCode(trimToXml(rs.getString(CONTROL_CODE)));
            c.setControlName(trimToXml(rs.getString(CONTROL_NAME)));
            c.setControlSeq(trimToXml(rs.getString(CONTROL_SEQ)));
            c.setControlsDescription(trimToXml(rs.getString(CONTROLS_DESC)));
            c.setAuditSummary(trimToXml(rs.getString(AUDIT_SUMMARY)));
            c.setCertComments(trimToXml(rs.getString(CERT_COMMENTS)));

            c.setControlInplaceDate(rs.getTimestamp(CONTROL_INPLACE_DATE));
            c.setControlEndDate(rs.getTimestamp(CONTROL_END_DATE));
            c.setCertReceivedDate(rs.getTimestamp(CERT_RCVD_DATE));
            c.setCertNoticeSentDate(rs.getTimestamp(CERT_NOTICE_SENT_DATE));
            c.setCertDueDate(rs.getTimestamp(CERT_DUE_DATE));
            c.setCertAcceptDate(rs.getTimestamp(CERT_ACCEPT_DATE));
            c.setCertNextDate(rs.getTimestamp(CERT_NEXT_DATE));
            c.setFollowupLetter(rs.getTimestamp(FOLLOWUP_LETTER));
            c.setEnfReferralDate(rs.getTimestamp(ENF_REFERAL_DATE));
            c.setAuditDate(rs.getTimestamp(AUDIT_DATE));

            return c;
        }
    }
}