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
import com.windsor.node.plugin.nysitesspills.domain.ErSite;

public class ErSiteDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_SITE";

    public static final String SITE_SEQ = "SITE_SEQ";
    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";
    public static final String SITE_ID = "SITE_ID";
    public static final String SIGNIF_THREAT = "SIGNIF_THREAT";
    public static final String SITE_CLASS_CODE = "SITE_CLASS_CODE";
    public static final String SITE_CLASS_NAME = "SITE_CLASS_NAME";
    public static final String SITE_CLASS_DESC = "SITE_CLASS_DESC";
    public static final String DESCRIPTION = "DESCRIPTION";
    public static final String LAND_USE = "LAND_USE";
    public static final String INTENDED_USE_CODE = "INTENDED_USE_CODE";
    public static final String CLEANUP_TRACK_CODE = "CLEANUP_TRACK_CODE";
    public static final String CLEANUP_TRACK_NAME = "CLEANUP_TRACK_NAME";
    public static final String ACRES = "ACRES";
    public static final String ASSESS_ENV = "ASSESS_ENV";
    public static final String ASSESS_DOH = "ASSESS_DOH";
    public static final String DOH_ASSESS_MOD = "DOH_ASSESS_MOD";
    public static final String DOH_ASSESS_FLAG = "DOH_ASSESS_FLAG";
    public static final String DOH_ASSESS_REASON = "DOH_ASSESS_REASON";
    public static final String ASSESS_LEG = "ASSESS_LEG";
    public static final String PERIODIC_REVIEW_FREQ_CODE = "PERIODIC_REVIEW_FREQ_CODE";
    public static final String PERIODIC_REVIEW_FREQ_NAME = "PERIODIC_REVIEW_FREQ_NAME";
    public static final String VAPOR_INTRUSION_LEGACY = "VAPOR_INTRUSION_LEGACY";
    public static final String HUDSON_RIVER_ESTUARY = "HUDSON_RIVER_ESTUARY";
    public static final String EDIT_REVIEW_COMP = "EDIT_REVIEW_COMP";
    public static final String EDIT_REVIEW_DATE = "EDIT_REVIEW_DATE";
    public static final String PROJ_MGR_REVIEW_COMP = "PROJ_MGR_REVIEW_COMP";
    public static final String PROJ_MGR_REVIEW_DATE = "PROJ_MGR_REVIEW_DATE";
    public static final String SITE_MANAGE_PRIORITY = "SITE_MANAGE_PRIORITY";
    public static final String MODIFIED_BY = "MODIFIED_BY";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";

    public static final String SQL_ORDER_BY_SEQ = ORDER_BY + SITE_SEQ;

    public static final String SQL_SELECT_PROG_SEQ = SELECT_ALL_FROM
            + TABLE_NAME + WHERE + PROGRAMS_SEQ + EQUALS_PARAM;

    public static final String SQL_SELECT_ALL = SELECT_ALL_FROM + TABLE_NAME
            + SQL_ORDER_BY_SEQ;

    public static final String SQL_SELECT_LIMIT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + ROWNUM_PARAM + SQL_ORDER_BY_SEQ;

    public static final String SQL_ORDER_BY_ID = ORDER_BY + "p.SITE_ID";

    public static final String SQL_SELECT_MINIMAL = "select s.ASSESS_DOH, s.DOH_ASSESS_MOD, p.SITE_ID "
            + "from UIS_SITE s, UIS_PROGRAMS p where p.PROGRAMS_SEQ = s.PROGRAMS_SEQ ";

    public static final String SQL_SELECT_MINIMAL_ID = "select s.ASSESS_DOH, s.DOH_ASSESS_MOD, p.SITE_ID "
            + "from UIS_SITE s, UIS_PROGRAMS p where p.PROGRAMS_SEQ = s.PROGRAMS_SEQ "
            + SQL_ORDER_BY_ID;

    public static final String SQL_SELECT_MINIMAL_LIMIT = SQL_SELECT_MINIMAL
            + AND + ROWNUM_PARAM + SQL_ORDER_BY_ID;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getErSites() {

        checkDaoConfig();
        logger.debug("getErSites");

        logger.debug("sql: " + SQL_SELECT_ALL);
        List sites = getJdbcTemplate().query(SQL_SELECT_ALL, new Object[] {},
                new ErSiteMapper());

        logger.debug("Found " + sites.size() + " ErSites");

        return sites;
    }

    public List getErSites(int maxRows) {

        checkDaoConfig();
        logger.debug("getErSites(maxRows)");

        logger.debug("sql: " + SQL_SELECT_LIMIT);
        List sites = getJdbcTemplate().query(SQL_SELECT_LIMIT,
                new Object[] { new Integer(maxRows) }, new ErSiteMapper());

        logger
                .debug("Asked for " + maxRows + " ErSites, found "
                        + sites.size());

        return sites;
    }

    public List getMinimalErSitesWithSiteId() {

        checkDaoConfig();
        logger.debug("getErSites");

        logger.debug("sql: " + SQL_SELECT_MINIMAL_ID);
        List sites = getJdbcTemplate().query(SQL_SELECT_MINIMAL_ID,
                new Object[] {}, new ErSiteMapper());

        logger.debug("Found " + sites.size() + " ErSites");

        return sites;
    }

    public List getMinimalErSitesWithSiteId(int maxRows) {

        checkDaoConfig();
        logger.debug("getErSites(maxRows)");

        logger.debug("sql: " + SQL_SELECT_MINIMAL_LIMIT);
        List sites = getJdbcTemplate().query(SQL_SELECT_MINIMAL_LIMIT,
                new Object[] { new Integer(maxRows) }, new ErSiteMapper());

        logger
                .debug("Asked for " + maxRows + " ErSites, found "
                        + sites.size());

        return sites;
    }

    public ErSite getErSiteForProgramSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getErSiteForProgramSeqNum");

        logger.debug("sql: " + SQL_SELECT_PROG_SEQ + ", ProgramSeqNum = "
                + seqNum);

        ErSite site = null;

        List sites = getJdbcTemplate().query(SQL_SELECT_PROG_SEQ,
                new Object[] { new Integer(seqNum) }, new ErSiteMapper());

        if (sites.size() == 1) {

            site = (ErSite) sites.get(0);

        } else if (sites.size() != 0) {

            String mesg = "Expected 0 or 1 results, but found " + sites.size();
            logger.error(mesg);
            throw new RuntimeException(mesg);
        }

        logger.debug("Found ErSite: " + site);

        return site;
    }

    private class ErSiteMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            ErSite s = new ErSite();

            if (containsColumnNamed(rs, SITE_SEQ)) {

                s.setSiteSequenceNum(getInteger(rs, SITE_SEQ));
            }

            if (containsColumnNamed(rs, PROGRAMS_SEQ)) {
                s.setProgramSequenceNum(getInteger(rs, PROGRAMS_SEQ));
            }

            if (containsColumnNamed(rs, SITE_ID)) {

                s.setSiteId(getInteger(rs, SITE_ID));
            }

            if (containsColumnNamed(rs, ACRES)) {

                s.setAcres(getDouble(rs, ACRES));
            }

            if (containsColumnNamed(rs, SIGNIF_THREAT)) {

                s.setSignificantThreat(trimToXml(rs.getString(SIGNIF_THREAT)));
            }

            if (containsColumnNamed(rs, SITE_CLASS_CODE)) {

                s.setSiteClassCode(trimToXml(rs.getString(SITE_CLASS_CODE)));
            }

            if (containsColumnNamed(rs, SITE_CLASS_NAME)) {

                s.setSiteClassName(trimToXml(rs.getString(SITE_CLASS_NAME)));
            }

            if (containsColumnNamed(rs, SITE_CLASS_DESC)) {

                s.setSiteClassDescription(trimToXml(rs
                        .getString(SITE_CLASS_DESC)));
            }

            if (containsColumnNamed(rs, DESCRIPTION)) {

                s.setDescription(trimToXml(rs.getString(DESCRIPTION)));
            }

            if (containsColumnNamed(rs, LAND_USE)) {

                s.setLandUse(trimToXml(rs.getString(LAND_USE)));
            }

            if (containsColumnNamed(rs, INTENDED_USE_CODE)) {

                s
                        .setIntendedUseCode(trimToXml(rs
                                .getString(INTENDED_USE_CODE)));
            }

            if (containsColumnNamed(rs, CLEANUP_TRACK_CODE)) {

                s.setCleanupTrackCode(trimToXml(rs
                        .getString(CLEANUP_TRACK_CODE)));
            }

            if (containsColumnNamed(rs, CLEANUP_TRACK_NAME)) {

                s.setCleanupTrackName(trimToXml(rs
                        .getString(CLEANUP_TRACK_NAME)));
            }

            if (containsColumnNamed(rs, ASSESS_ENV)) {

                s.setAssessEnv(trimToXml(rs.getString(ASSESS_ENV)));
            }

            s.setAssessDoh(trimToXml(rs.getString(ASSESS_DOH)));// both
            // directions

            if (containsColumnNamed(rs, DOH_ASSESS_FLAG)) {

                s.setDohAssessFlag(trimToXml(rs.getString(DOH_ASSESS_FLAG)));
            }

            if (containsColumnNamed(rs, DOH_ASSESS_REASON)) {

                s
                        .setDohAssessReason(trimToXml(rs
                                .getString(DOH_ASSESS_REASON)));
            }

            if (containsColumnNamed(rs, ASSESS_LEG)) {

                s.setAssessLeg(trimToXml(rs.getString(ASSESS_LEG)));
            }

            if (containsColumnNamed(rs, PERIODIC_REVIEW_FREQ_CODE)) {

                s.setPeriodicReviewFrequencyCode(trimToXml(rs
                        .getString(PERIODIC_REVIEW_FREQ_CODE)));
            }

            if (containsColumnNamed(rs, PERIODIC_REVIEW_FREQ_NAME)) {

                s.setPeriodicReviewFrequencyName(trimToXml(rs
                        .getString(PERIODIC_REVIEW_FREQ_NAME)));
            }

            if (containsColumnNamed(rs, VAPOR_INTRUSION_LEGACY)) {

                s.setVaporIntrusionLegacy(trimToXml(rs
                        .getString(VAPOR_INTRUSION_LEGACY)));
            }

            if (containsColumnNamed(rs, HUDSON_RIVER_ESTUARY)) {

                s.setHudsonRiverEstuary(trimToXml(rs
                        .getString(HUDSON_RIVER_ESTUARY)));
            }

            if (containsColumnNamed(rs, EDIT_REVIEW_COMP)) {

                s.setEditReviewComp(trimToXml(rs.getString(EDIT_REVIEW_COMP)));
            }

            if (containsColumnNamed(rs, PROJ_MGR_REVIEW_COMP)) {

                s.setProjMgrReviewComp(trimToXml(rs
                        .getString(PROJ_MGR_REVIEW_COMP)));
            }

            if (containsColumnNamed(rs, SITE_MANAGE_PRIORITY)) {

                s.setSiteManagePriority(trimToXml(rs
                        .getString(SITE_MANAGE_PRIORITY)));
            }

            if (containsColumnNamed(rs, MODIFIED_BY)) {

                s.setModifiedBy(trimToXml(rs.getString(MODIFIED_BY)));
            }

            s.setDohAssessMod(rs.getTimestamp(DOH_ASSESS_MOD));// both
                                                               // directions

            if (containsColumnNamed(rs, EDIT_REVIEW_DATE)) {

                s.setEditReviewDate(rs.getTimestamp(EDIT_REVIEW_DATE));
            }

            if (containsColumnNamed(rs, PROJ_MGR_REVIEW_DATE)) {

                s.setProjMgrReviewDate(rs.getTimestamp(PROJ_MGR_REVIEW_DATE));
            }

            if (containsColumnNamed(rs, LAST_MODIFIED)) {

                s.setLastModified(rs.getTimestamp(LAST_MODIFIED));
            }
            return s;
        }
    }
}