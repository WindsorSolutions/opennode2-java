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
 *  Script Name:  RCRA_5.8-to_5.9-upgrade_SQL-DDL.sql
 *
 *  Company:  Windsor Solutions, Inc.
 *
 *  Purpose:  This script will upgrade SQL Server database objects from RCRA v5.8 to v5.9.
 *
 *  Maintenance:
 *
 *    Analyst         Date            Comment
 *    ----------      ----------      ------------------------------------------------------------------------------
 *    Windsor         07/27/2020      Created
 *
 ****************************************************************************************************************************
 */

/*
 * RCRA_CA_AREA: new columns
 */

if COL_LENGTH('dbo.RCRA_CA_AREA','CREATED_BY_USER_ID') IS NULL
begin
    alter table [dbo].[RCRA_CA_AREA] add [CREATED_BY_USER_ID] [varchar](255) null;
    exec sys.sp_addextendedproperty
        @name=N'MS_Description',
        @value=N'User id of record creation (CreatedByUserid)',
        @level0type=N'SCHEMA',
        @level0name=N'dbo',
        @level1type=N'TABLE',
        @level1name=N'RCRA_CA_AREA',
        @level2type=N'COLUMN',
        @level2name=N'CREATED_BY_USER_ID';
end
go

if COL_LENGTH('dbo.RCRA_CA_AREA','A_CREATED_DATE') IS NULL
begin
    alter table [dbo].[RCRA_CA_AREA] add [A_CREATED_DATE] [datetime2] null;
    exec sys.sp_addextendedproperty
         @name=N'MS_Description',
         @value=N'Creation Date (ACreatedDate)',
         @level0type=N'SCHEMA',
         @level0name=N'dbo',
         @level1type=N'TABLE',
         @level1name=N'RCRA_CA_AREA',
         @level2type=N'COLUMN',
         @level2name=N'A_CREATED_DATE';
end
go

if COL_LENGTH('dbo.RCRA_CA_AREA','DATA_ORIG') IS NULL
begin
    alter table [dbo].[RCRA_CA_AREA] add [DATA_ORIG] [char](2) null;
    exec sys.sp_addextendedproperty
         @name=N'MS_Description',
         @value=N'Indicates data origination information (DataOrig)',
         @level0type=N'SCHEMA',
         @level0name=N'dbo',
         @level1type=N'TABLE',
         @level1name=N'RCRA_CA_AREA',
         @level2type=N'COLUMN',
         @level2name=N'DATA_ORIG';
end
go

/*
 * RCRA_CA_AUTHORITY: new columns
 */

if COL_LENGTH('dbo.RCRA_CA_AUTHORITY','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_CA_AUTHORITY] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_AUTHORITY',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_CA_AUTHORITY','A_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_CA_AUTHORITY] add [A_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (ACreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_AUTHORITY',
             @level2type=N'COLUMN',
             @level2name=N'A_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_CA_AUTHORITY','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_CA_AUTHORITY] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_AUTHORITY',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_CA_EVENT: new columns
 */

if COL_LENGTH('dbo.RCRA_CA_EVENT','PUBLIC_SUPP_INFO_TXT') IS NULL
    begin
        alter table [dbo].[RCRA_CA_EVENT] add [PUBLIC_SUPP_INFO_TXT] [varchar](4000) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Public notes providing more information (PublicSupplementalInformationText)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_EVENT',
             @level2type=N'COLUMN',
             @level2name=N'PUBLIC_SUPP_INFO_TXT';
    end
go

if COL_LENGTH('dbo.RCRA_CA_EVENT','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_CA_EVENT] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_EVENT',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_CA_EVENT','A_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_CA_EVENT] add [A_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (ACreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_EVENT',
             @level2type=N'COLUMN',
             @level2name=N'A_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_CA_EVENT','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_CA_EVENT] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CA_EVENT',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_FA_COST_EST: new columns
 */

if COL_LENGTH('dbo.RCRA_FA_COST_EST','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_FA_COST_EST] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_COST_EST',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_FA_COST_EST','F_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_FA_COST_EST] add [F_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (FCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_COST_EST',
             @level2type=N'COLUMN',
             @level2name=N'F_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_FA_COST_EST','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_FA_COST_EST] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_COST_EST',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_CME_ENFRC_ACT: new columns
 */

if COL_LENGTH('dbo.RCRA_CME_ENFRC_ACT','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_CME_ENFRC_ACT] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_ENFRC_ACT',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_CME_ENFRC_ACT','C_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_CME_ENFRC_ACT] add [C_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (CCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_ENFRC_ACT',
             @level2type=N'COLUMN',
             @level2name=N'C_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_CME_ENFRC_ACT','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_CME_ENFRC_ACT] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_ENFRC_ACT',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_CME_EVAL: new columns
 */

if COL_LENGTH('dbo.RCRA_CME_EVAL','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_CME_EVAL] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_EVAL',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_CME_EVAL','C_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_CME_EVAL] add [C_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (CCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_EVAL',
             @level2type=N'COLUMN',
             @level2name=N'C_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_CME_EVAL','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_CME_EVAL] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_EVAL',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_GIS_GEO_INFORMATION: new columns
 */

if COL_LENGTH('dbo.RCRA_GIS_GEO_INFORMATION','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_GIS_GEO_INFORMATION] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_GIS_GEO_INFORMATION',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_GIS_GEO_INFORMATION','G_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_GIS_GEO_INFORMATION] add [G_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (GCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_GIS_GEO_INFORMATION',
             @level2type=N'COLUMN',
             @level2name=N'G_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_GIS_GEO_INFORMATION','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_GIS_GEO_INFORMATION] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_GIS_GEO_INFORMATION',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_HD_HANDLER: new columns
 */
if COL_LENGTH('dbo.RCRA_HD_HANDLER','CURR_REC') IS NULL
    begin
        alter table [dbo].[RCRA_HD_HANDLER] add [CURR_REC] [char](1) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Flag indicating if it is current record (CurrentRecord)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_HD_HANDLER',
             @level2type=N'COLUMN',
             @level2name=N'CURR_REC';
    end
go

if COL_LENGTH('dbo.RCRA_HD_HANDLER','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_HD_HANDLER] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_HD_HANDLER',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_HD_HANDLER','H_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_HD_HANDLER] add [H_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (HCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_HD_HANDLER',
             @level2type=N'COLUMN',
             @level2name=N'H_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_HD_HANDLER','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_HD_HANDLER] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_HD_HANDLER',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_FA_MECHANISM_DETAIL: new columns
 */

if COL_LENGTH('dbo.RCRA_FA_MECHANISM_DETAIL','CURR_MECH_DET_IND') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM_DETAIL] add [CURR_MECH_DET_IND] [char](1) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates if the mechanism detail is current. Possible values are: Y/N (CurrentMechanismDetailIndicator)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM_DETAIL',
             @level2type=N'COLUMN',
             @level2name=N'CURR_MECH_DET_IND';
    end
go

if COL_LENGTH('dbo.RCRA_FA_MECHANISM_DETAIL','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM_DETAIL] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM_DETAIL',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_FA_MECHANISM_DETAIL','F_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM_DETAIL] add [F_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (FCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM_DETAIL',
             @level2type=N'COLUMN',
             @level2name=N'F_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_FA_MECHANISM_DETAIL','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM_DETAIL] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM_DETAIL',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_FA_MECHANISM: new columns
 */

if COL_LENGTH('dbo.RCRA_FA_MECHANISM','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_FA_MECHANISM','C_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM] add [F_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (FCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM',
             @level2type=N'COLUMN',
             @level2name=N'F_CREATED_DATE';
    end
go

if COL_LENGTH('dbo.RCRA_FA_MECHANISM','DATA_ORIG') IS NULL
    begin
        alter table [dbo].[RCRA_FA_MECHANISM] add [DATA_ORIG] [char](2) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Indicates data origination information (DataOrig)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_FA_MECHANISM',
             @level2type=N'COLUMN',
             @level2name=N'DATA_ORIG';
    end
go

/*
 * RCRA_CME_VIOL: new columns
 */

if COL_LENGTH('dbo.RCRA_CME_VIOL','CREATED_BY_USER_ID') IS NULL
    begin
        alter table [dbo].[RCRA_CME_VIOL] add [CREATED_BY_USER_ID] [varchar](255) null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'User id of record creation (CreatedByUserid)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_VIOL',
             @level2type=N'COLUMN',
             @level2name=N'CREATED_BY_USER_ID';
    end
go

if COL_LENGTH('dbo.RCRA_CME_VIOL','C_CREATED_DATE') IS NULL
    begin
        alter table [dbo].[RCRA_CME_VIOL] add [C_CREATED_DATE] [datetime2] null;
        exec sys.sp_addextendedproperty
             @name=N'MS_Description',
             @value=N'Creation Date (CCreatedDate)',
             @level0type=N'SCHEMA',
             @level0name=N'dbo',
             @level1type=N'TABLE',
             @level1name=N'RCRA_CME_VIOL',
             @level2type=N'COLUMN',
             @level2name=N'C_CREATED_DATE';
    end
go
