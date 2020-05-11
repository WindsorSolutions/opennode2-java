/*
Copyright (c) 2020, The Environmental Council of the States (ECOS)
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

/*****************************************************************************************************************************
 *
 *  Script Name:  RCRA_5.7-to_5.8-upgrade_SQL-DDL.sql
 *
 *  Company:  Windsor Solutions, Inc.
 *
 *  Purpose:  This script will upgrade Oracle database objects from RCRA v5.7 to v5.8.
 *
 *  Maintenance:
 *
 *    Analyst         Date            Comment
 *    ----------      ----------      ------------------------------------------------------------------------------
 *    Windsor         04/22/2020      Created
 *
 ****************************************************************************************************************************
 */

/*
 * RCRA_EM_EMANIFEST: column length changes
 */

ALTER TABLE RCRA_EM_EMANIFEST MODIFY IMP_PORT_CITY VARCHAR2(100);

ALTER TABLE RCRA_EM_EMANIFEST MODIFY IMP_GEN_POSTAL_CODE VARCHAR2(50);

/*
 * RCRA_RU_REPORT_UNIV: column added
 */

ALTER TABLE RCRA_RU_REPORT_UNIV ADD SUBPART_P_IND CHAR(1);
COMMENT ON COLUMN RCRA_RU_REPORT_UNIV.SUBPART_P_IND IS 'Subpart P code (SubpartPIndicator)';

/*
 * RCRA_PRM_SERIES: columns added
 */

ALTER TABLE RCRA_PRM_SERIES ADD ACTIVE_SERIES_IND CHAR(1);
COMMENT ON COLUMN RCRA_PRM_SERIES.ACTIVE_SERIES_IND IS
    'Indicates if the permit series is active. Possible values are: Y/N (ActiveSeriesIndicator)';

ALTER TABLE RCRA_PRM_SERIES ADD CREATED_BY_USER_ID VARCHAR2(255);
COMMENT ON COLUMN RCRA_PRM_SERIES.CREATED_BY_USER_ID IS 'User id of record creation (CreatedByUserid)';

ALTER TABLE RCRA_PRM_SERIES ADD P_CREATED_DATE TIMESTAMP (6);
COMMENT ON COLUMN RCRA_PRM_SERIES.P_CREATED_DATE IS 'Creation date (PCreatedDate)';

/*
 * RCRA_PRM_EVENT: columns added
 */

ALTER TABLE RCRA_PRM_EVENT ADD CREATED_BY_USER_ID VARCHAR2(255);
COMMENT ON COLUMN RCRA_PRM_EVENT.CREATED_BY_USER_ID IS 'User id of record creation (CreatedByUserid)';

ALTER TABLE RCRA_PRM_EVENT ADD P_CREATED_DATE TIMESTAMP (6);
COMMENT ON COLUMN RCRA_PRM_EVENT.P_CREATED_DATE IS 'Creation date (PCreatedDate)';

/*
 * RCRA_PRM_MOD_EVENT: new table
 */
CREATE TABLE RCRA_PRM_MOD_EVENT (
    PRM_MOD_EVENT_ID VARCHAR2(40),
    PRM_EVENT_ID VARCHAR2(40) NOT NULL,
    TRANS_CODE CHAR(1),
    MOD_HANDLER_ID VARCHAR2(12) NOT NULL,
    MOD_ACT_LOC_CODE CHAR(2) NOT NULL,
    MOD_SERIES_SEQ_NUM INT NOT NULL,
    MOD_EVENT_SEQ_NUM INT NOT NULL,
    MOD_EVENT_AGN_CODE CHAR(1) NOT NULL,
    MOD_EVENT_DATA_OWNER_CDE CHAR(2) NOT NULL,
    MOD_EVENT_CODE VARCHAR2(7) NOT NULL,
    CONSTRAINT PK_RCRA_PRM_MOD_EVENT PRIMARY KEY (PRM_MOD_EVENT_ID)
);

ALTER TABLE RCRA_PRM_MOD_EVENT
    ADD CONSTRAINT FK_RCRA_PRM_MOD_EVENT_PARENT FOREIGN KEY (PRM_EVENT_ID)
        REFERENCES RCRA_PRM_EVENT (PRM_EVENT_ID) ON DELETE CASCADE;

COMMENT ON TABLE RCRA_PRM_MOD_EVENT IS 'Linking mod event for Permitting Events (PermitModEventDataType)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.PRM_MOD_EVENT_ID IS 'Id of the mod event record (PK)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.PRM_EVENT_ID IS 'Id of the parent PRM_EVENT record (FK)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.TRANS_CODE IS
    'Transaction code used to define the add, update, or delete. (TransactionCode)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_HANDLER_ID IS 'Handler id (ModHandlerId)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_ACT_LOC_CODE IS 'Permit event activity location (ModActivityLocationCode)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_SERIES_SEQ_NUM IS 'Permit series sequence number (ModSeriesSequenceNumber)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_EVENT_SEQ_NUM IS 'Permit event sequence number (ModEventSequenceNumber)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_EVENT_AGN_CODE IS 'Permit event owner (ModEventAgencyCode)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_EVENT_DATA_OWNER_CDE IS 'Permit event owner (ModEventDataOwnerCode)';
COMMENT ON COLUMN RCRA_PRM_MOD_EVENT.MOD_EVENT_CODE IS 'Permit event code (ModEventCode)';

/*
 * RCRA_PRM_UNIT: columns added
 */

ALTER TABLE RCRA_PRM_UNIT ADD ACTIVE_UNIT_IND CHAR(1);
COMMENT ON COLUMN RCRA_PRM_UNIT.ACTIVE_UNIT_IND IS
    'Indicates if the permit unit is active. Possible values are: Y/N (ActiveUnitIndicator)';

ALTER TABLE RCRA_PRM_UNIT ADD CREATED_BY_USER_ID VARCHAR2(255);
COMMENT ON COLUMN RCRA_PRM_UNIT.CREATED_BY_USER_ID IS 'User id of record creation (CreatedByUserid)';

ALTER TABLE RCRA_PRM_UNIT ADD P_CREATED_DATE timestamp(6);
COMMENT ON COLUMN RCRA_PRM_UNIT.P_CREATED_DATE IS 'Creation date (PCreatedDate)';

/*
 * RCRA_PRM_UNIT_DETAIL: columns added
 */

ALTER TABLE RCRA_PRM_UNIT_DETAIL ADD CURRENT_UNIT_DETAIL_IND CHAR(1);
COMMENT ON COLUMN RCRA_PRM_UNIT_DETAIL.CURRENT_UNIT_DETAIL_IND IS
    'Indicates if the unit detail is current. Possible values are: Y/N (CurrentUnitDetailIndicator)';

ALTER TABLE RCRA_PRM_UNIT_DETAIL ADD CREATED_BY_USER_ID VARCHAR2(255);
COMMENT ON COLUMN RCRA_PRM_UNIT_DETAIL.CREATED_BY_USER_ID IS 'User id of record creation (CreatedByUserid)';

ALTER TABLE RCRA_PRM_UNIT_DETAIL ADD P_CREATED_DATE timestamp(6);
COMMENT ON COLUMN RCRA_PRM_UNIT_DETAIL.P_CREATED_DATE IS 'Creation date (PCreatedDate)';
