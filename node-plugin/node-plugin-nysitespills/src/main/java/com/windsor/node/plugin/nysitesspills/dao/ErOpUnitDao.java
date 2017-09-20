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
import com.windsor.node.plugin.nysitesspills.domain.ErOpUnit;

public class ErOpUnitDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_OPERABLE_UNIT";
    public static final String OPERABLE_UNIT_SEQ = "OPERABLE_UNIT_SEQ";
    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";
    public static final String OPERABLE_UNIT_ID = "OPERABLE_UNIT_ID";
    public static final String OPERABLE_UNIT_CODE = "OPERABLE_UNIT_CODE";
    public static final String OPERABLE_UNIT_DESC = "OPERABLE_UNIT_DESC";
    public static final String RECORD_OF_DISCUSSION = "RECORD_OF_DISCUSSION";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + PROGRAMS_SEQ + EQUALS_PARAM + ORDER_BY
            + OPERABLE_UNIT_SEQ;

    protected void checkDaoConfig() {
        super.checkDaoConfig();
    }

    public List getOpUnitsForProgramSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getOpUnitsForProgramSeqNum");

        List units = null;
        logger.debug("sql: " + SQL_SELECT + ", DerProgramSeqNum = " + seqNum);

        units = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new ErOpUnitMapper());

        logger.debug("Found " + units.size()
                + " ErOpUnits for DerProgramSeqNum " + seqNum);

        return units;
    }

    private class ErOpUnitMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErOpUnit unit = new ErOpUnit();

            unit.setOpUnitSequenceNum(getInteger(rs, OPERABLE_UNIT_SEQ));
            unit.setProgramSequenceNum(getInteger(rs, PROGRAMS_SEQ));
            unit.setOpUnitId(getInteger(rs, OPERABLE_UNIT_ID));

            unit.setOpUnitCode(trimToXml(rs.getString(OPERABLE_UNIT_CODE)));
            unit.setOpUnitDescription(trimToXml(rs
                    .getString(OPERABLE_UNIT_DESC)));
            unit.setOpUnitRecordOfDiscussion(trimToXml(rs
                    .getString(RECORD_OF_DISCUSSION)));

            return unit;
        }
    }
}