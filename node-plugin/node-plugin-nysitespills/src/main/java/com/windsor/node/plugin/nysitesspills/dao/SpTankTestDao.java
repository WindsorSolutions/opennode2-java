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
import com.windsor.node.plugin.nysitesspills.domain.SpTankTest;

public class SpTankTestDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_TANKS";

    public static final String TANK_SEQ = "TANK_SEQ";
    public static final String SPILLS_SEQ = "SPILLS_SEQ";
    public static final String TANK_ID = "TANK_ID";
    public static final String TANK_NBR = "TANK_NBR";
    public static final String TANK_SIZE = "TANK_SIZE";
    public static final String MATERIAL = "MATERIAL";
    public static final String EPA_UST_IND = "EPA_UST_IND";
    public static final String UST_IND = "UST_IND";
    public static final String CAUSE_CODE = "CAUSE_CODE";
    public static final String CAUSE_NAME = "CAUSE_NAME";
    public static final String SOURCE_CODE = "SOURCE_CODE";
    public static final String SOURCE_NAME = "SOURCE_NAME";
    public static final String TEST_METHOD_CODE = "TEST_METHOD_CODE";
    public static final String TEST_METHOD_NAME = "TEST_METHOD_NAME";
    public static final String LEAK_RATE = "LEAK_RATE";
    public static final String GROSS_FAILURE_IND = "GROSS_FAILURE_IND";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + SPILLS_SEQ + EQUALS_PARAM + ORDER_BY + TANK_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getSpTankTestsForSpillSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getSpTankTestsForSpillSeqNum");

        logger.debug("sql: " + SQL_SELECT + ", SpillSeqNum = " + seqNum);

        List tanks = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new TankTestMapper());

        logger.debug("Found " + tanks.size() + " SpTankTests for SpillSeqNum "
                + seqNum);

        return tanks;

    }

    private class TankTestMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            SpTankTest t = new SpTankTest();

            t.setTankSequenceNum(getInteger(rs, TANK_SEQ));
            t.setSpillSequenceNum(getInteger(rs, SPILLS_SEQ));
            t.setTankId(getInteger(rs, TANK_ID));

            t.setTankSize(getDouble(rs, TANK_SIZE));
            t.setLeakRate(getDouble(rs, LEAK_RATE));

            t.setTankNumber(trimToXml(rs.getString(TANK_NBR)));
            t.setMaterial(trimToXml(rs.getString(MATERIAL)));
            t.setEpaUstIndicator(trimToXml(rs.getString(EPA_UST_IND)));
            t.setUstIndicator(trimToXml(rs.getString(UST_IND)));
            t.setCauseCode(trimToXml(rs.getString(CAUSE_CODE)));
            t.setCauseName(trimToXml(rs.getString(CAUSE_NAME)));
            t.setSourceCode(trimToXml(rs.getString(SOURCE_CODE)));
            t.setSourceName(trimToXml(rs.getString(SOURCE_NAME)));
            t.setTestMethodCode(trimToXml(rs.getString(TEST_METHOD_CODE)));
            t.setTestMethodName(trimToXml(rs.getString(TEST_METHOD_NAME)));
            t.setGrossFailureIndicator(trimToXml(rs
                    .getString(GROSS_FAILURE_IND)));

            t.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            return t;

        }
    }
}