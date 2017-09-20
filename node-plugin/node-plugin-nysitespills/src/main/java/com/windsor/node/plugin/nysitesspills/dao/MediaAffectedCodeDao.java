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
import com.windsor.node.plugin.nysitesspills.domain.MediaAffectedCode;

public class MediaAffectedCodeDao extends BaseJdbcDao {

    public static final String TABLE_NAME = "UIS_MEDIA_AFFECTED_CODES";

    public static final String MEDIA_AFFECTED_CODE = "MEDIA_AFFECTED_CODE";
    public static final String MEDIA_AFFECTED_NAME = "MEDIA_AFFECTED_NAME";
    public static final String MEDIA_AFFECTED_DESC = "MEDIA_AFFECTED_DESC";
    public static final String MEDIA_AFFECTED_TYPE = "MEDIA_AFFECTED_TYPE";

    public static final String SQL_SELECT = SELECT_ALL_FROM + TABLE_NAME
            + ORDER_BY + MEDIA_AFFECTED_CODE;

    protected void checkDaoConfig() {

        super.checkDaoConfig();
    }

    public List getMediaAffectedCodes() {

        checkDaoConfig();
        logger.debug("getMediaAffectedCodes");

        logger.debug("sql: " + SQL_SELECT);

        List media = getJdbcTemplate().query(SQL_SELECT, new Object[] {},
                new MediaAffectedMapper());

        logger.debug("Found " + media.size() + " MediaAffectedCodes");

        return media;
    }

    private class MediaAffectedMapper implements RowMapper {

        public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

            MediaAffectedCode m = new MediaAffectedCode();

            m
                    .setMediaAffectedCode(trimToXml(rs
                            .getString(MEDIA_AFFECTED_CODE)));
            m
                    .setMediaAffectedName(trimToXml(rs
                            .getString(MEDIA_AFFECTED_NAME)));
            m.setMediaAffectedDescription(trimToXml(rs
                    .getString(MEDIA_AFFECTED_DESC)));
            m
                    .setMediaAffectedType(trimToXml(rs
                            .getString(MEDIA_AFFECTED_TYPE)));

            return m;
        }
    }
}