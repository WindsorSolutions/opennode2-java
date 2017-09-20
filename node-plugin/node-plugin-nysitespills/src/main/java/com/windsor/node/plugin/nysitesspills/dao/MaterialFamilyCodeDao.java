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
import com.windsor.node.plugin.nysitesspills.domain.MaterialFamilyCode;

public class MaterialFamilyCodeDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_MATERIAL_FAMILY_CODES";

    public static final String MATERIAL_FAMILY_CODE = "MATERIAL_FAMILY_CODE";
    public static final String MATERIAL_FAMILY_NAME = "MATERIAL_FAMILY_NAME";
    public static final String MATERIAL_FAMILY_DESC = "MATERIAL_FAMILY_DESC";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + ORDER_BY + MATERIAL_FAMILY_CODE;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getMaterialFamilyCodes() {

        checkDaoConfig();
        logger.debug("getMaterialFamilyCodes");

        logger.debug("sql: " + SQL_SELECT);

        List families = getJdbcTemplate().query(SQL_SELECT, new Object[] {},
                new MaterialFamilyMapper());

        logger.debug("Found " + families.size() + " MaterialFamilyCodes");

        return families;
    }

    private class MaterialFamilyMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            MaterialFamilyCode m = new MaterialFamilyCode();

            m.setMaterialFamilyCode(trimToXml(rs
                    .getString(MATERIAL_FAMILY_CODE)));
            m.setMaterialFamilyName(trimToXml(rs
                    .getString(MATERIAL_FAMILY_NAME)));
            m.setMaterialFamilyDescription(trimToXml(rs
                    .getString(MATERIAL_FAMILY_DESC)));

            return m;
        }
    }
}