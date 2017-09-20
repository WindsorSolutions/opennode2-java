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
import com.windsor.node.plugin.nysitesspills.domain.Spill;

public class SpillDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_SPILLS";

    public static final String SPILLS_SEQ = "SPILLS_SEQ";
    public static final String PROGRAMS_SEQ = "PROGRAMS_SEQ";
    public static final String DEC_LEAD = "DEC_LEAD";
    public static final String REFERRED_TO = "REFERRED_TO";
    public static final String SPILL_DATE = "SPILL_DATE";
    public static final String SPILL_RCVD_DATE = "SPILL_RCVD_DATE";
    public static final String CONTRIBUTING_FACTOR_CODE = "CONTRIBUTING_FACTOR_CODE";
    public static final String CONTRIBUTING_FACTOR_NAME = "CONTRIBUTING_FACTOR_NAME";
    public static final String WATERBODY = "WATERBODY";
    public static final String FACILITY_TYPE_CODE = "FACILITY_TYPE_CODE";
    public static final String FACILITY_TYPE_NAME = "FACILITY_TYPE_NAME";
    public static final String REPORTED_BY = "REPORTED_BY";
    public static final String NOTIFIER_CODE_NAME = "NOTIFIER_CODE_NAME";
    public static final String CALLER_REMARK = "CALLER_REMARK";
    public static final String MEETS_STANDARD_IND = "MEETS_STANDARD_IND";
    public static final String INSPECTION_DATE = "INSPECTION_DATE";
    public static final String PENALTY_IND = "PENALTY_IND";
    public static final String UST_TRUST_IND = "UST_TRUST_IND";
    public static final String SPILL_CLASS = "SPILL_CLASS";
    public static final String RESPONSE_END_DATE = "RESPONSE_END_DATE";
    public static final String INVESTIGATION_END_DATE = "INVESTIGATION_END_DATE";
    public static final String REMEDIAL_DESIGN_DATE = "REMEDIAL_DESIGN_DATE";
    public static final String REMEDIAL_ACTION_DATE = "REMEDIAL_ACTION_DATE";
    public static final String SITE_MGMT_END_DATE = "SITE_MGMT_END_DATE";
    public static final String CLOSE_DATE = "CLOSE_DATE";
    public static final String DEC_REMARK = "DEC_REMARK";
    public static final String CREATE_DATE = "CREATE_DATE";
    public static final String PRIVATE_WELLS_AFFECTED = "PRIVATE_WELLS_AFFECTED";
    public static final String PUBLIC_WELLS_AFFECTED = "PUBLIC_WELLS_AFFECTED";
    public static final String REGIONAL_USE = "REGIONAL_USE";
    public static final String AFTER_HOURS_IND = "AFTER_HOURS_IND";
    public static final String REMEDIAL_PHASE = "REMEDEDIAL_PHASE";
    public static final String LAST_MODIFIED = "LAST_MODIFIED";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + WHERE + PROGRAMS_SEQ + EQUALS_PARAM;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public Spill getSpillForProgramSeqNum(int seqNum) {

        checkDaoConfig();
        logger.debug("getSpillsForProgramSeqNum");

        logger.debug("sql: " + SQL_SELECT + ", ProgramSeqNum = " + seqNum);

        Spill spill = null;

        List spills = getJdbcTemplate().query(SQL_SELECT,
                new Object[] { new Integer(seqNum) }, new SpillMapper());

        if (spills.size() == 1) {

            spill = (Spill) spills.get(0);

        } else if (spills.size() != 0) {

            String mesg = "Expected 0 or 1 results, but found " + spills.size();
            logger.error(mesg);
            throw new RuntimeException(mesg);
        }

        logger.debug("Found spill: " + spill);

        return spill;
    }

    private class SpillMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            Spill s = new Spill();

            s.setSpillSequenceNum(getInteger(rs, SPILLS_SEQ));
            s.setProgramSequenceNum(getInteger(rs, PROGRAMS_SEQ));
            s.setPrivateWellsAffected(getInteger(rs, PRIVATE_WELLS_AFFECTED));
            s.setPublicWellsAffected(getInteger(rs, PUBLIC_WELLS_AFFECTED));

            s.setDecLead(trimToXml(rs.getString(DEC_LEAD)));
            s.setReferredTo(trimToXml(rs.getString(REFERRED_TO)));
            s.setContributingFactorCode(trimToXml(rs
                    .getString(CONTRIBUTING_FACTOR_CODE)));
            s.setContributingFactorName(trimToXml(rs
                    .getString(CONTRIBUTING_FACTOR_NAME)));
            s.setWaterbody(trimToXml(rs.getString(WATERBODY)));
            s.setFacilityTypeCode(trimToXml(rs.getString(FACILITY_TYPE_CODE)));
            s.setFacilityTypeName(trimToXml(rs.getString(FACILITY_TYPE_NAME)));
            s.setReportedBy(trimToXml(rs.getString(REPORTED_BY)));
            s.setNotifierCodeName(trimToXml(rs.getString(NOTIFIER_CODE_NAME)));
            s.setCallerRemark(trimToXml(rs.getString(CALLER_REMARK)));
            s.setMeetsStandardIndicator(trimToXml(rs
                    .getString(MEETS_STANDARD_IND)));
            s.setPenaltyIndicator(trimToXml(rs.getString(PENALTY_IND)));
            s.setUstTrustIndicator(trimToXml(rs.getString(UST_TRUST_IND)));
            s.setSpillClass(trimToXml(rs.getString(SPILL_CLASS)));
            s.setDecRemark(trimToXml(rs.getString(DEC_REMARK)));
            s.setRegionalUse(trimToXml(rs.getString(REGIONAL_USE)));
            s.setAfterHoursIndicator(trimToXml(rs.getString(AFTER_HOURS_IND)));
            s.setRemedialPhase(trimToXml(rs.getString(REMEDIAL_PHASE)));

            s.setSpillDate(rs.getTimestamp(SPILL_DATE));
            s.setSpillReceivedDate(rs.getTimestamp(SPILL_RCVD_DATE));
            s.setInspectionDate(rs.getTimestamp(INSPECTION_DATE));
            s.setResponseEndDate(rs.getTimestamp(RESPONSE_END_DATE));
            s.setInvestigationEndDate(rs.getTimestamp(INVESTIGATION_END_DATE));
            s.setRemedialDesignDate(rs.getTimestamp(REMEDIAL_DESIGN_DATE));
            s.setRemedialActionDate(rs.getTimestamp(REMEDIAL_ACTION_DATE));
            s.setSiteMgmtEndDate(rs.getTimestamp(SITE_MGMT_END_DATE));
            s.setCloseDate(rs.getTimestamp(CLOSE_DATE));
            s.setLastModified(rs.getTimestamp(LAST_MODIFIED));

            return s;
        }
    }
}