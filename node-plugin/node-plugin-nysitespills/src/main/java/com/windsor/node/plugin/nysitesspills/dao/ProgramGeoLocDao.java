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
import com.windsor.node.plugin.nysitesspills.domain.ProgramGeoLoc;

public class ProgramGeoLocDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_GEOGRAPHIC_LOCATION";
    public static final String SITE_TABLE_NAME = "UIS_SITE";

    public static final String GEOGRAPHIC_LOCATION_SEQ = "GEOGRAPHIC_LOCATION_SEQ";
    public static final String SITE_ID = "SITE_ID";
    public static final String GIS_ID = "GIS_ID";
    public static final String COLLECTION_METHOD = "COLLECTION_METHOD";
    public static final String ACCURACY = "ACCURACY";
    public static final String ACCURACY_UNIT = "ACCURACY_UNIT";
    public static final String DATUM = "DATUM";
    public static final String LATITUDE = "LATITUDE";
    public static final String LONGITUDE = "LONGITUDE";
    public static final String MODIFIED_BY = "MODIFIED_BY";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";
    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";

    public static final String SQL_SELECT_BY_PROG_SEQ = "select * from UIS_GEOGRAPHIC_LOCATION "
            + "where UIS_GEOGRAPHIC_LOCATION.PROGRAMS_SEQ = ? "
            + "order by UIS_GEOGRAPHIC_LOCATION.GEOGRAPHIC_LOCATION_SEQ";

    public static final String SQL_SELECT = "select g.GEOGRAPHIC_LOCATION_SEQ, g.PROGRAMS_SEQ, "
            + "g.GIS_ID, g.COLLECTION_METHOD, g.ACCURACY, g.ACCURACY_UNIT, g.DATUM, g.LATITUDE, "
            + "g.LONGITUDE, g.MODIFIED_BY, g.LAST_MODIFIED, p.SITE_ID "
            + "from UIS_GEOGRAPHIC_LOCATION g, UIS_PROGRAMS p "
            + "where p.PROGRAMS_SEQ = g.PROGRAMS_SEQ ";

    public static final String SQL_ORDER_BY = " order by p.SITE_ID";

    public static final String SQL_SELECT_ALL = SQL_SELECT + SQL_ORDER_BY;

    public static final String SQL_SELECT_LIMIT = SQL_SELECT
            + "and rownum <= ? " + SQL_ORDER_BY;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getProgramGeoLocs() {

        checkDaoConfig();
        logger.debug("getProgramGeoLocs");

        logger.debug("sql: " + SQL_SELECT_ALL);
        List locations = getJdbcTemplate().query(SQL_SELECT_ALL,
                new Object[] {}, new GeoLocMapper());

        logger.debug("Found " + locations.size() + " ProgramGeoLocs");
        return locations;
    }

    public List getProgramGeoLocs(int maxRows) {

        checkDaoConfig();
        logger.debug("getProgramGeoLocs(maxRows)");

        logger.debug("sql: " + SQL_SELECT_LIMIT);
        List locations = getJdbcTemplate().query(SQL_SELECT_LIMIT,
                new Object[] { new Integer(maxRows) }, new GeoLocMapper());

        logger.debug("Asked for " + maxRows + " ProgramGeoLocs, found "
                + locations.size());
        return locations;
    }

    public List getProgramGeoLocsForProgramSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getProgramGeoLocsForProgramSeqNum");

        logger.debug("sql: " + SQL_SELECT_BY_PROG_SEQ + ", DerProgramSeqNum = "
                + seqNum);
        List locations = getJdbcTemplate().query(SQL_SELECT_BY_PROG_SEQ,
                new Object[] { new Integer(seqNum) }, new GeoLocMapper());

        logger.debug("Found " + locations.size()
                + " ProgramGeoLocs for DerProgramSeqNum " + seqNum);
        return locations;
    }

    private class GeoLocMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int RowNum) throws SQLException {

            ProgramGeoLoc l = new ProgramGeoLoc();

            l.setGeoLocSequenceNum(getInteger(rs, GEOGRAPHIC_LOCATION_SEQ));
            l.setProgSequenceNum(getInteger(rs, PROGRAMS_SEQ));

            if (containsColumnNamed(rs, SITE_ID)) {

                l.setSiteId(getInteger(rs, SITE_ID));
            }

            l.setGisId(getInteger(rs, GIS_ID));

            l.setLatitude(getDouble(rs, LATITUDE));
            l.setLongitude(getDouble(rs, LONGITUDE));

            l.setCollectionMethod(trimToXml(rs.getString(COLLECTION_METHOD)));
            l.setAccuracy(trimToXml(rs.getString(ACCURACY)));
            l.setAccuracyUnit(trimToXml(rs.getString(ACCURACY_UNIT)));
            l.setDatum(trimToXml(rs.getString(DATUM)));
            l.setModifiedBy(trimToXml(rs.getString(MODIFIED_BY)));

            l.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            return l;
        }
    }

}