/*
Copyright (c) 2016, The Environmental Council of the States (ECOS)
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
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE goODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

/*****************************************************************************************************************************
 *
 *  Script Name:  RCRA_5.9_to_5.10-upgrade_SQL-DDL.sql
 *
 *  Company:  Windsor Solutions, Inc.
 *
 *  Purpose:  This script will upgrade RCRA 5.9 schema to support RCRA 5.10.
 *
 *  Maintenance:
 *
 *    Analyst         Date            Comment
 *    ----------      ----------      ------------------------------------------------------------------------------
 *    Windsor         1/14/2021      Created
 *
 ****************************************************************************************************************************
 */

---$ Alter table dbo.RCRA_HD_EPISODIC_EVENT
ALTER TABLE dbo.RCRA_HD_EPISODIC_EVENT
    ALTER COLUMN EVENT_TYPE CHAR(1) NULL
GO

IF EXISTS(SELECT *
          FROM SYS.COLUMNS
          WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_EPISODIC_EVENT')
            AND NAME = 'EVENT_OTHER_DESC')
    BEGIN
        ALTER TABLE dbo.RCRA_HD_EPISODIC_EVENT
            DROP COLUMN EVENT_OTHER_DESC
    END
GO


---$ Alter table dbo.RCRA_HD_HANDLER
IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'LOCATION_LATITUDE')
    BEGIN
        ALTER TABLE dbo.RCRA_HD_HANDLER
            ADD LOCATION_LATITUDE DECIMAL(19, 14) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'LOCATION_LONGITUDE')
    BEGIN
        ALTER TABLE dbo.RCRA_HD_HANDLER
            ADD LOCATION_LONGITUDE DECIMAL(19, 14) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'LOCATION_GIS_PRIM')
    BEGIN
        ALTER TABLE dbo.RCRA_HD_HANDLER
            ADD LOCATION_GIS_PRIM CHAR(1) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'LOCATION_GIS_ORIG')
    BEGIN
        ALTER TABLE dbo.RCRA_HD_HANDLER
            ADD LOCATION_GIS_ORIG CHAR(2) NULL
    END
GO


---$ Alter table dbo.RCRA_RU_REPORT_UNIV
IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_RU_REPORT_UNIV')
                AND NAME = 'LOCATION_LATITUDE')
    BEGIN
        ALTER TABLE dbo.RCRA_RU_REPORT_UNIV
            ADD LOCATION_LATITUDE DECIMAL(19, 14) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_RU_REPORT_UNIV')
                AND NAME = 'LOCATION_LONGITUDE')
    BEGIN
        ALTER TABLE dbo.RCRA_RU_REPORT_UNIV
            ADD LOCATION_LONGITUDE DECIMAL(19, 14) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_RU_REPORT_UNIV')
                AND NAME = 'LOCATION_GIS_PRIM')
    BEGIN
        ALTER TABLE dbo.RCRA_RU_REPORT_UNIV
            ADD LOCATION_GIS_PRIM CHAR(1) NULL
    END
GO

IF NOT EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_RU_REPORT_UNIV')
                AND NAME = 'LOCATION_GIS_ORIG')
    BEGIN
        ALTER TABLE dbo.RCRA_RU_REPORT_UNIV
            ADD LOCATION_GIS_ORIG CHAR(2) NULL
    END
GO


---$ Create table dbo.RCRA_HD_EPISODIC_PRJT
IF OBJECT_ID(N'dbo.RCRA_HD_EPISODIC_PRJT') IS NULL
    BEGIN
        CREATE TABLE dbo.RCRA_HD_EPISODIC_PRJT
        (
            HD_EPISODIC_PRJT_ID  VARCHAR(40)  NOT NULL,
            HD_EPISODIC_EVENT_ID VARCHAR(40)  NOT NULL,
            TRANSACTION_CODE     CHAR(1)      NULL,
            PRJT_CODE_OWNER      CHAR(2)      NOT NULL,
            PRJT_CODE            CHAR(3)      NOT NULL,
            OTHER_PRJT_DESC      VARCHAR(255) NULL
        )
    END
GO


---$ Create Index/PK: IX_HD_EPIS_PRJT_HD_EPIS_EVE_ID, Table : dbo.RCRA_HD_EPISODIC_PRJT
IF NOT EXISTS(SELECT *
              FROM SYS.INDEXES
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_EPISODIC_PRJT')
                AND NAME = 'IX_HD_EPIS_PRJT_HD_EPIS_EVE_ID')
CREATE NONCLUSTERED INDEX IX_HD_EPIS_PRJT_HD_EPIS_EVE_ID
    ON dbo.RCRA_HD_EPISODIC_PRJT (HD_EPISODIC_EVENT_ID)
    WITH (IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = NONE)
GO

---$ Create Index/PK: PK_HD_EPISODIC_PRJT, Table : dbo.RCRA_HD_EPISODIC_PRJT
IF OBJECT_ID(N'dbo.PK_HD_EPISODIC_PRJT') IS NULL
ALTER TABLE dbo.RCRA_HD_EPISODIC_PRJT
    ADD CONSTRAINT PK_HD_EPISODIC_PRJT PRIMARY KEY CLUSTERED (HD_EPISODIC_PRJT_ID)
GO

---$ Create FK : FK_HD_EPISO_PRJT_HD_EPISO_EVEN
IF OBJECT_ID(N'dbo.FK_HD_EPISO_PRJT_HD_EPISO_EVEN') IS NULL
    BEGIN
        ALTER TABLE dbo.RCRA_HD_EPISODIC_PRJT
            ADD CONSTRAINT FK_HD_EPISO_PRJT_HD_EPISO_EVEN
                FOREIGN KEY (HD_EPISODIC_EVENT_ID)
                    REFERENCES dbo.RCRA_HD_EPISODIC_EVENT (HD_EPISODIC_EVENT_ID)
                    ON DELETE CASCADE
                    ON UPDATE NO ACTION
    END
GO

-- rename columns to match the names in the .net plugin

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CA_AREA')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CA_AREA.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CA_AUTHORITY')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CA_AUTHORITY.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CA_EVENT')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CA_EVENT.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_FA_COST_EST')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_FA_COST_EST.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CME_ENFRC_ACT')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CME_ENFRC_ACT.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CME_EVAL')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CME_EVAL.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_GIS_GEO_INFORMATION')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_GIS_GEO_INFORMATION.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'CURR_REC')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_HD_HANDLER.CURR_REC', 'CURRENT_RECORD', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_HD_HANDLER')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_HD_HANDLER.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_FA_MECHANISM_DETAIL')
                AND NAME = 'CURR_MECH_DET_IND')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_FA_MECHANISM_DETAIL.CURR_MECH_DET_IND', 'CURRENT_MECHANISM_DETAIL_IND', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_FA_MECHANISM_DETAIL')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_FA_MECHANISM_DETAIL.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_FA_MECHANISM')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_FA_MECHANISM.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_CME_VIOL')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_CME_VIOL.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_SERIES')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_SERIES.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_EVENT')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_EVENT.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_MOD_EVENT')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_MOD_EVENT.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_MOD_EVENT')
                AND NAME = 'MOD_EVENT_DATA_OWNER_CDE')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_MOD_EVENT.MOD_EVENT_DATA_OWNER_CDE', 'MOD_EVENT_DATA_OWNER_CODE', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
              FROM SYS.COLUMNS
              WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_UNIT')
                AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_UNIT.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

IF EXISTS(SELECT *
          FROM SYS.COLUMNS
          WHERE OBJECT_ID = OBJECT_ID(N'dbo.RCRA_PRM_UNIT_DETAIL')
            AND NAME = 'CREATED_BY_USER_ID')
    BEGIN
        EXEC sp_rename 'dbo.RCRA_PRM_UNIT_DETAIL.CREATED_BY_USER_ID', 'CREATED_BY_USERID', 'COLUMN';
    END
GO

ALTER TABLE RCRA_HD_EPISODIC_WASTE_CODE ALTER COLUMN WASTE_CODE_TEXT VARCHAR (4000)
GO
