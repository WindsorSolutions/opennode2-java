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
import com.windsor.node.plugin.nysitesspills.domain.ErMaterial;

public class ErMaterialDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_MATERIAL";

    public static final String MATERIAL_SEQ = "MATERIAL_SEQ";
    public static final String OPERABLE_UNIT_SEQ = "OPERABLE_UNIT_SEQ";
    public static final String SITE_ID = "SITE_ID";
    public static final String MATERIAL_ID = "MATERIAL_ID";
    public static final String MED_RECEPT = "MED_RECEPT";
    public static final String MATERIAL_CODE = "MATERIAL_CODE";
    public static final String TARGET_LEVEL = "TARGET_LEVEL";
    public static final String QUANTITY = "QUANTITY";
    public static final String UNITS = "UNITS";
    public static final String RECOVERED = "RECOVERED";
    public static final String PM_CONTAMINANT_COMMENTS = "PM_CONTAMINANT_COMMENTS";
    public static final String MODIFIED_BY = "MODIFIED_BY";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";

    public static final String OPERABLE_UNIT_ID = "OPERABLE_UNIT_ID";

    public static final String SQL_SELECT = "SELECT m.MATERIAL_SEQ, m.OPERABLE_UNIT_SEQ, m.MATERIAL_ID, "
            + "m.MATERIAL_CODE, m.TARGET_LEVEL, m.QUANTITY, m.UNITS, m.RECOVERED, "
            + "m.PM_CONTAMINANT_COMMENTS, m.MODIFIED_BY, m.LAST_MODIFIED, "
            + "u.OPERABLE_UNIT_ID, p.SITE_ID "
            + "FROM UIS_MATERIAL m, UIS_OPERABLE_UNIT u, UIS_PROGRAMS p ";

    public static final String SQL_ORDER_BY = ORDER_BY + "m.MATERIAL_SEQ";

    public static final String SQL_OPUNIT_SEQ_EQUAL = "WHERE u.OPERABLE_UNIT_SEQ = m.OPERABLE_UNIT_SEQ ";

    public static final String SQL_PROG_SEQ_EQUAL = "AND p.PROGRAMS_SEQ = u.PROGRAMS_SEQ ";

    public static final String SQL_SELECT_FOR_OP_UNIT = SQL_SELECT
            + "WHERE m.OPERABLE_UNIT_SEQ = ? AND u.OPERABLE_UNIT_SEQ = ? "
            + SQL_PROG_SEQ_EQUAL + SQL_ORDER_BY;

    public static final String SQL_SELECT_ALL = SQL_SELECT
            + SQL_OPUNIT_SEQ_EQUAL + SQL_PROG_SEQ_EQUAL + SQL_ORDER_BY;

    public static final String SQL_SELECT_LIMIT = SQL_SELECT
            + SQL_OPUNIT_SEQ_EQUAL + SQL_PROG_SEQ_EQUAL + AND + ROWNUM_PARAM
            + SQL_ORDER_BY;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getMaterials() {

        checkDaoConfig();
        logger.debug("getMaterials");

        logger.debug("sql: " + SQL_SELECT_ALL);
        List materials = getJdbcTemplate().query(SQL_SELECT_ALL,
                new Object[] {}, new ErMaterialMapper());

        logger.debug("Found " + materials.size() + " ErMaterials");
        return materials;
    }

    public List getMaterials(int maxRows) {

        checkDaoConfig();
        logger.debug("getMaterials(maxRows)");

        logger.debug("sql: " + SQL_SELECT_LIMIT);
        List materials = getJdbcTemplate().query(SQL_SELECT_LIMIT,
                new Object[] { new Integer(maxRows) }, new ErMaterialMapper());

        logger.debug("Asked for " + maxRows + " EeMaterials, found "
                + materials.size());
        return materials;
    }

    public List getMaterialsForOpUnitSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getMaterialsForOpUnitSeqNum");

        logger.debug("sql: " + SQL_SELECT_FOR_OP_UNIT + ", OpUnitSeqNum = "
                + seqNum);
        List materials = getJdbcTemplate().query(SQL_SELECT_FOR_OP_UNIT,
                new Object[] { new Integer(seqNum), new Integer(seqNum) },
                new ErMaterialMapper());

        logger.debug("Found " + materials.size()
                + " ErMaterials for OpUnitSeqNum " + seqNum);
        return materials;
    }

    private class ErMaterialMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErMaterial m = new ErMaterial();

            m.setMaterialSequenceNum(getInteger(rs, MATERIAL_SEQ));
            m.setOpUnitSequenceNum(getInteger(rs, OPERABLE_UNIT_SEQ));
            m.setOpUnitId(getInteger(rs, OPERABLE_UNIT_ID));
            m.setMaterialId(getInteger(rs, MATERIAL_ID));
            m.setProgramSiteId(getInteger(rs, SITE_ID));

            m.setQuantity(getDouble(rs, QUANTITY));
            m.setRecovered(getDouble(rs, RECOVERED));

            m.setMaterialCode(trimToXml(rs.getString(MATERIAL_CODE)));
            m.setTargetLevel(trimToXml(rs.getString(TARGET_LEVEL)));
            m.setUnits(trimToXml(rs.getString(UNITS)));
            m.setPmContaminantComments(trimToXml(rs
                    .getString(PM_CONTAMINANT_COMMENTS)));
            m.setModifiedBy(trimToXml(rs.getString(MODIFIED_BY)));

            m.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            return m;
        }
    }

}