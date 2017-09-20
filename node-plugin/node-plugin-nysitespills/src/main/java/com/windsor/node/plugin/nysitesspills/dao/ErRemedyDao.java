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
import com.windsor.node.plugin.nysitesspills.domain.ErRemedy;

public class ErRemedyDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_REMEDY";
    public static final String REMEDY_SEQ = "REMEDY_SEQ";
    public static final String OPERABLE_UNIT_SEQ = "OPERABLE_UNIT_SEQ";
    public static final String REMEDY_CODE = "REMEDY_CODE";
    public static final String REMEDY_NAME = "REMEDY_NAME";
    public static final String REMEDY_TYPE = "REMEDY_TYPE";
    public static final String DESCRIPTION = "DESCRIPTION";
    public static final String IN_PLACE_DATE = "IN_PLACE_DATE";
    public static final String REMEDY_EFFECTIVE = "REMEDY_EFFECTIVE";
    public static final String PARCELS_MITIGATED = "PARCELS_MITIGATED";
    public static final String MAX_PARCELS_MITIGATED = "MAX_PARCELS_MITIGATED";
    public static final String REMEDY_SIZE_CODE = "REMEDY_SIZE_CODE";
    public static final String REMEDY_SIZE_NAME = "REMEDY_SIZE_NAME";
    public static final String COMPLETION_DATE = "COMPLETION_DATE";
    public static final String COMMENTS = "COMMENTS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + OPERABLE_UNIT_SEQ + EQUALS_PARAM;

    protected void checkDaoConfig() {
        super.checkDaoConfig();
    }

    public List getRemediesForOpUnitSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getRemediesForOpUnitId");

        List remedies = null;
        logger.debug("sql: " + SQL_SELECT + ", OpUnitSeqNum = " + seqNum);

        remedies = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ErRemedyMapper());

        logger.debug("Found " + remedies.size()
                + " ErRemedies for OperableUnitSeqNum " + seqNum);

        return remedies;
    }

    private class ErRemedyMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErRemedy r = new ErRemedy();

            r.setRemedySequenceNum(getInteger(rs, REMEDY_SEQ));
            r.setOpUnitSequenceNum(getInteger(rs, OPERABLE_UNIT_SEQ));
            r.setParcelsMitigated(getInteger(rs, PARCELS_MITIGATED));
            r.setMaxParcelsMitigated(getInteger(rs, MAX_PARCELS_MITIGATED));

            r.setRemedyCode(trimToXml(rs.getString(REMEDY_CODE)));
            r.setRemedyName(trimToXml(rs.getString(REMEDY_NAME)));
            r.setRemedyType(trimToXml(rs.getString(REMEDY_TYPE)));
            r.setDescription(trimToXml(rs.getString(DESCRIPTION)));
            r.setRemedyEffective(trimToXml(rs.getString(REMEDY_EFFECTIVE)));
            r.setRemedySizeCode(trimToXml(rs.getString(REMEDY_SIZE_CODE)));
            r.setRemedySizeName(trimToXml(rs.getString(REMEDY_SIZE_NAME)));
            r.setComments(trimToXml(rs.getString(COMMENTS)));

            r.setInPlaceDate(rs.getTimestamp(IN_PLACE_DATE));
            r.setCompletionDate(rs.getTimestamp(COMPLETION_DATE));

            return r;
        }
    }
}