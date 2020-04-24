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
 *  Purpose:  This script will upgrade SQL Server database objects from RCRA v5.7 to v5.8.
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

ALTER TABLE [dbo].[RCRA_EM_EMANIFEST]
    ALTER COLUMN [IMP_PORT_CITY] [VARCHAR](100)
GO

ALTER TABLE [dbo].[RCRA_EM_EMANIFEST]
    ALTER COLUMN [IMP_GEN_POSTAL_CODE] [VARCHAR](50)
GO

/*
 * RCRA_RU_REPORT_UNIV: column added
 */

ALTER TABLE [dbo].[RCRA_RU_REPORT_UNIV]
    ADD [SUBPART_P_IND] [CHAR](1)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Subpart P code (SubpartPIndicator)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_RU_REPORT_UNIV',
    @level2type=N'COLUMN',
    @level2name=N'SUBPART_P_IND'
GO

/*
 * RCRA_PRM_SERIES: columns added
 */

ALTER TABLE [dbo].[RCRA_PRM_SERIES]
    ADD [ACTIVE_SERIES_IND] [CHAR](1)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Indicates if the permit series is active. Possible values are: Y/N (ActiveSeriesIndicator)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_PRM_SERIES',
    @level2type=N'COLUMN',
    @level2name=N'ACTIVE_SERIES_IND'
GO

ALTER TABLE [dbo].[RCRA_PRM_SERIES]
    ADD [CREATED_BY_USER_ID] [VARCHAR](255)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'User id of record creation (CreatedByUserid)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_PRM_SERIES',
    @level2type=N'COLUMN',
    @level2name=N'CREATED_BY_USER_ID'
GO

ALTER TABLE [dbo].[RCRA_PRM_SERIES]
    ADD [P_CREATED_DATE] [datetime2]
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Creation date (PCreatedDate)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_PRM_SERIES',
    @level2type=N'COLUMN',
    @level2name=N'P_CREATED_DATE'
GO

/*
 * RCRA_PRM_EVENT: columns added
 */

ALTER TABLE [dbo].[RCRA_PRM_EVENT]
    ADD [CREATED_BY_USER_ID] [VARCHAR](255)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'User id of record creation (CreatedByUserid)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_PRM_EVENT',
    @level2type=N'COLUMN',
    @level2name=N'CREATED_BY_USER_ID'
GO

ALTER TABLE [dbo].[RCRA_PRM_EVENT]
    ADD [P_CREATED_DATE] [datetime2]
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description',
    @value=N'Creation date (PCreatedDate)',
    @level0type=N'SCHEMA',
    @level0name=N'dbo',
    @level1type=N'TABLE',
    @level1name=N'RCRA_PRM_EVENT',
    @level2type=N'COLUMN',
    @level2name=N'P_CREATED_DATE'
GO

/*
 * RCRA_PRM_MOD_EVENT: new table
 */
CREATE TABLE [dbo].[RCRA_PRM_MOD_EVENT] (
    [PRM_MOD_EVENT_ID] [VARCHAR](40),
    [PRM_EVENT_ID] [VARCHAR](40) NOT NULL,
    [TRANS_CODE] [CHAR](1),
    [MOD_HANDLER_ID] [VARCHAR](12) NOT NULL,
    [MOD_ACT_LOC_CODE] [CHAR](2) NOT NULL,
    [MOD_SERIES_SEQ_NUM] [INT] NOT NULL,
    [MOD_EVENT_SEQ_NUM] [INT] NOT NULL,
    [MOD_EVENT_AGN_CODE] [CHAR](1) NOT NULL,
    [MOD_EVENT_DATA_OWNER_CDE] [CHAR](2) NOT NULL,
    [MOD_EVENT_CODE] [VARCHAR](7) NOT NULL,
    CONSTRAINT [PK_RCRA_PRM_MOD_EVENT] PRIMARY KEY CLUSTERED
        ([PRM_MOD_EVENT_ID] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
GO

ALTER TABLE [dbo].[RCRA_PRM_MOD_EVENT]
    ADD CONSTRAINT [FK_RCRA_PRM_MOD_EVENT_PARENT] FOREIGN KEY ([PRM_EVENT_ID])
        REFERENCES [dbo].[RCRA_PRM_EVENT] ([PRM_EVENT_ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Linking mod event for Permitting Events (PermitModEventDataType)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Id of the mod event record (PK)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'PRM_MOD_EVENT_ID'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Id of the parent PRM_EVENT record (FK)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'PRM_EVENT_ID'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Handler id (ModHandlerId)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'MOD_HANDLER_ID'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit event activity location (ModActivityLocationCode)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'MOD_ACT_LOC_CODE'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit series sequence number (ModSeriesSequenceNumber)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'MOD_SERIES_SEQ_NUM'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit event sequence number (ModEventSequenceNumber)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN',@level2name=N'MOD_EVENT_SEQ_NUM'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit event owner (ModEventAgencyCode)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN',@level2name=N'MOD_EVENT_AGN_CODE'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit event owner (ModEventDataOwnerCode)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN',@level2name=N'MOD_EVENT_DATA_OWNER_CDE'
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Permit event code (ModEventCode)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_MOD_EVENT',
    @level2type=N'COLUMN', @level2name=N'MOD_EVENT_CODE'
GO

/*
 * RCRA_PRM_UNIT: columns added
 */

ALTER TABLE [dbo].[RCRA_PRM_UNIT]
    ADD [ACTIVE_UNIT_IND] [CHAR](1)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Indicates if the permit unit is active. Possible values are: Y/N (ActiveUnitIndicator)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT',
    @level2type=N'COLUMN', @level2name=N'ACTIVE_UNIT_IND'
GO

ALTER TABLE [dbo].[RCRA_PRM_UNIT]
    ADD [CREATED_BY_USER_ID] [VARCHAR](255)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT',
    @level2type=N'COLUMN', @level2name=N'CREATED_BY_USER_ID'
GO

ALTER TABLE [dbo].[RCRA_PRM_UNIT]
    ADD [P_CREATED_DATE] [datetime2]
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Creation date (PCreatedDate)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT',
    @level2type=N'COLUMN',@level2name=N'P_CREATED_DATE'
GO

/*
 * RCRA_PRM_UNIT_DETAIL: columns added
 */

ALTER TABLE [dbo].[RCRA_PRM_UNIT_DETAIL]
    ADD [CURRENT_UNIT_DETAIL_IND] [CHAR](1)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Indicates if the unit detail is current. Possible values are: Y/N (CurrentUnitDetailIndicator)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT_DETAIL',
    @level2type=N'COLUMN', @level2name=N'CURRENT_UNIT_DETAIL_IND'
GO

ALTER TABLE [dbo].[RCRA_PRM_UNIT_DETAIL]
    ADD [CREATED_BY_USER_ID] [VARCHAR](255)
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT_DETAIL',
    @level2type=N'COLUMN', @level2name=N'CREATED_BY_USER_ID'
GO

ALTER TABLE [dbo].[RCRA_PRM_UNIT_DETAIL]
    ADD [P_CREATED_DATE] [datetime2]
GO

EXEC sys.sp_addextendedproperty
    @name=N'MS_Description', @value=N'Creation date (PCreatedDate)',
    @level0type=N'SCHEMA', @level0name=N'dbo',
    @level1type=N'TABLE', @level1name=N'RCRA_PRM_UNIT_DETAIL',
    @level2type=N'COLUMN', @level2name=N'P_CREATED_DATE'
GO
