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
import com.windsor.node.plugin.nysitesspills.domain.ErAdjacentProperty;

public class ErAdjacentPropertyDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_ADJACENT_PROPERTY";

    public static final String ADJACENT_PROPERTY_SEQ = "ADJACENT_PROPERTY_SEQ";
    public static final String SITE_SEQ = "SITE_SEQ";
    public static final String ADJACENT_PROPERTY_ID = "ADJACENT_PROPERTY_ID";
    public static final String ADJACENT_PROPERTY_IDC = "ADJACENT_PROPERTY_IDC";
    public static final String EA_DISTRICT = "EA_DISTRICT";
    public static final String EA_SECTION = "EA_SECTION";
    public static final String EA_SUB_SECTION = "EA_SUB_SECTION";
    public static final String EA_BLOCK = "EA_BLOCK";
    public static final String EA_LOT = "EA_LOT";
    public static final String EA_SUB_LOT = "EA_SUB_LOT";
    public static final String EA_SUFFIX = "EA_SUFFIX";
    public static final String NY_TRANSMERCATOR_N = "NY_TRANSMERCATOR_N";
    public static final String NY_TRANSMERCATOR_E = "NY_TRANSMERCATOR_E";
    public static final String NY_DISTANCE = "NY_DISTANCE";
    public static final String SECTION_BLOCK_PRINT = "SECTION_BLOCK_PRINT";
    public static final String PARCEL_STREET = "PARCEL_STREET";
    public static final String PARCEL_CITY = "PARCEL_CITY";
    public static final String PARCEL_ZIP_CODE = "PARCEL_ZIP_CODE";
    public static final String PARCEL_SWIS = "PARCEL_SWIS";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + SITE_SEQ + EQUALS_PARAM + ORDER_BY
            + ADJACENT_PROPERTY_SEQ;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getErAdjacentPropertiesForSiteSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getErAdjacentPropertyForSiteSeqNum");

        logger.debug("sql: " + SQL_SELECT + ", SiteSeqNum = " + seqNum);
        List properties = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) },
                new AdjacentPropertyMapper());

        logger.debug("Found " + properties.size()
                + " ErAdjacentProperties for SiteSeqNum " + seqNum);

        return properties;
    }

    private class AdjacentPropertyMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErAdjacentProperty p = new ErAdjacentProperty();

            p.setAdjacentPropertySequenceNum(getInteger(rs,
                    ADJACENT_PROPERTY_SEQ));
            p.setSiteSequenceNum(getInteger(rs, SITE_SEQ));
            p.setAdjacentPropertyId(getInteger(rs, ADJACENT_PROPERTY_ID));
            p.setNyTransmercatorN(getInteger(rs, NY_TRANSMERCATOR_N));

            p.setNyTransmercatorE(getDouble(rs, NY_TRANSMERCATOR_E));

            p.setAdjacentPropertyIdc(trimToXml(rs
                    .getString(ADJACENT_PROPERTY_IDC)));
            p.setEaDistrict(trimToXml(rs.getString(EA_DISTRICT)));
            p.setEaSection(trimToXml(rs.getString(EA_SECTION)));
            p.setEaSubsection(trimToXml(rs.getString(EA_SUB_SECTION)));
            p.setEaBlock(trimToXml(rs.getString(EA_BLOCK)));
            p.setEaLot(trimToXml(rs.getString(EA_LOT)));
            p.setEaSublot(trimToXml(rs.getString(EA_SUB_LOT)));
            p.setEaSuffix(trimToXml(rs.getString(EA_SUFFIX)));
            p.setNyDistance(trimToXml(rs.getString(NY_DISTANCE)));
            p
                    .setSectionBlockPrint(trimToXml(rs
                            .getString(SECTION_BLOCK_PRINT)));
            p.setParcelStreet(trimToXml(rs.getString(PARCEL_STREET)));
            p.setParcelCity(trimToXml(rs.getString(PARCEL_CITY)));
            p.setParcelZipCode(trimToXml(rs.getString(PARCEL_ZIP_CODE)));
            p.setParcelSwis(trimToXml(rs.getString(PARCEL_SWIS)));

            return p;
        }
    }
}