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
import com.windsor.node.plugin.nysitesspills.domain.ErPetitionFiled;

public class ErPetitionFiledDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_PETITIONS_FILED";

    public static final String PETITIONS_FILED_SEQ = "PETITIONS_FILED_SEQ";
    public static final String SITE_SEQ = "SITE_SEQ";
    public static final String PETITION_SEQ_NBR = "PETITION_SEQ_NBR";
    public static final String PETITION_FILED_1 = "PETITION_FILED_1";
    public static final String PETITIONER_NAME = "PETITIONER_NAME";
    public static final String CONTROL_SEC_SIGN_DATE = "CONTROL_SEC_SIGN_DATE";
    public static final String PAC_TRQ = "PAC_TRQ";
    public static final String REGIONAL_OFFICE_SIGN_DATE = "REGIONAL_OFFICE_SIGN_DATE";
    public static final String CENTRAL_OFFICE_SIGN_DATE = "CENTRAL_OFFICE_SIGN_DATE";
    public static final String DOH_SIGN_DATE = "DOH_SIGN_DATE";
    public static final String DEC_SIGN_DATE = "DEC_SIGN_DATE";
    public static final String DIVISION_APPROV_DATE = "DIVISION_APPROV_DATE";
    public static final String FINALIZATION_DATE = "FINALIZATION_DATE";
    public static final String ON_HOLD_DATE = "ON_HOLD_DATE";
    public static final String COMMENT_ONE = "COMMENT_ONE";
    public static final String COMMENT_TWO = "COMMENT_TWO";
    public static final String SITE_NAME = "SITE_NAME";
    public static final String PETITION_FILED_2 = "PETITION_FILED_2";
    public static final String PETITION_FILED_2A = "PETITION_FILED_2A";
    public static final String PETITION_FILED_3 = "PETITION_FILED_3";
    public static final String COMMENTS = "COMMENTS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + SITE_SEQ + EQUALS_PARAM + ORDER_BY + PETITIONS_FILED_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getErPetitionsFiledForSiteSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getErPetitionsFiledForSiteSeqNum");

        logger.debug("sql: " + SQL_SELECT + ", SiteSeqNum = " + seqNum);

        List petitions = getJdbcTemplate()
                .query(SQL_SELECT, new Object[] { new Integer(seqNum) },
                        new PetitionFiledMapper());

        logger.debug("Found " + petitions.size()
                + " ErPetitionsFiled for SiteSeqNum " + seqNum);

        return petitions;
    }

    private class PetitionFiledMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErPetitionFiled p = new ErPetitionFiled();

            p.setPetitionFiledSequenceNum(getInteger(rs, PETITIONS_FILED_SEQ));
            p.setSiteSequenceNum(getInteger(rs, SITE_SEQ));

            p.setPetitionSeqNbr(trimToXml(rs.getString(PETITION_SEQ_NBR)));
            p.setPetitionFiledOne(trimToXml(rs.getString(PETITION_FILED_1)));
            p.setPetitionerName(trimToXml(rs.getString(PETITIONER_NAME)));
            p.setPacTrq(trimToXml(rs.getString(PAC_TRQ)));
            p.setCommentOne(trimToXml(rs.getString(COMMENT_ONE)));
            p.setCommentTwo(trimToXml(rs.getString(COMMENT_TWO)));
            p.setSiteName(trimToXml(rs.getString(SITE_NAME)));
            p.setPetitionFiledTwo(trimToXml(rs.getString(PETITION_FILED_2)));
            p.setPetitionFiledTwoA(trimToXml(rs.getString(PETITION_FILED_2A)));
            p.setPetitionFiledThree(trimToXml(rs.getString(PETITION_FILED_3)));

            p.setControlSecSignDate(rs.getTimestamp(CONTROL_SEC_SIGN_DATE));
            p.setRegionalOfficeSignDate(rs
                    .getTimestamp(REGIONAL_OFFICE_SIGN_DATE));
            p.setCentralOfficeSignDate(rs
                    .getTimestamp(CENTRAL_OFFICE_SIGN_DATE));
            p.setDohSignDate(rs.getTimestamp(DOH_SIGN_DATE));
            p.setDecSignDate(rs.getTimestamp(DEC_SIGN_DATE));
            p.setDivisionApproveDate(rs.getTimestamp(DIVISION_APPROV_DATE));
            p.setFinalizationDate(rs.getTimestamp(FINALIZATION_DATE));
            p.setOnHoldDate(rs.getTimestamp(ON_HOLD_DATE));

            return p;
        }
    }
}