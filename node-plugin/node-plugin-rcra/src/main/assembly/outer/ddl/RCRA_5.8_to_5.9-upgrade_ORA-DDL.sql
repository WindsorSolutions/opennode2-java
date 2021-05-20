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
 *  Purpose:  This script will upgrade Oracle database objects from RCRA v5.8 to v5.9.
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

alter table RCRA_CA_AREA add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CA_AREA.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CA_AREA add A_CREATED_DATE timestamp (6) null;
comment on column RCRA_CA_AREA.A_CREATED_DATE is 'Creation Date (ACreatedDate)';

alter table RCRA_CA_AREA add DATA_ORIG char(2) null;
comment on column RCRA_CA_AREA.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_CA_AUTHORITY: new columns
 */

alter table RCRA_CA_AUTHORITY add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CA_AUTHORITY.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CA_AUTHORITY add A_CREATED_DATE timestamp (6) null;
comment on column RCRA_CA_AUTHORITY.A_CREATED_DATE is 'Creation Date (ACreatedDate)';

alter table RCRA_CA_AUTHORITY add DATA_ORIG char(2) null;
comment on column RCRA_CA_AUTHORITY.DATA_ORIG is 'Indicates data origination information (DataOrig)';


/*
 * RCRA_CA_EVENT: new columns
 */

alter table RCRA_CA_EVENT add PUBLIC_SUPP_INFO_TXT varchar2(4000) null;
comment on column RCRA_CA_EVENT.PUBLIC_SUPP_INFO_TXT is 'Public notes providing more information (PublicSupplementalInformationText)';

alter table RCRA_CA_EVENT add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CA_EVENT.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CA_EVENT add A_CREATED_DATE timestamp (6) null;
comment on column RCRA_CA_EVENT.A_CREATED_DATE is 'Creation Date (ACreatedDate)';

alter table RCRA_CA_EVENT add DATA_ORIG char(2) null;
comment on column RCRA_CA_EVENT.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_FA_COST_EST: new columns
 */

alter table RCRA_FA_COST_EST add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_FA_COST_EST.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_FA_COST_EST add F_CREATED_DATE timestamp (6) null;
comment on column RCRA_FA_COST_EST.F_CREATED_DATE is 'Creation Date (FCreatedDate)';

alter table RCRA_FA_COST_EST add DATA_ORIG char(2) null;
comment on column RCRA_FA_COST_EST.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_CME_ENFRC_ACT: new columns
 */

alter table RCRA_CME_ENFRC_ACT add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CME_ENFRC_ACT.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CME_ENFRC_ACT add C_CREATED_DATE timestamp (6) null;
comment on column RCRA_CME_ENFRC_ACT.C_CREATED_DATE is 'Creation Date (CCreatedDate)';

alter table RCRA_CME_ENFRC_ACT add DATA_ORIG char(2) null;
comment on column RCRA_CME_ENFRC_ACT.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_CME_EVAL: new columns
 */

alter table RCRA_CME_EVAL add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CME_EVAL.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CME_EVAL add C_CREATED_DATE timestamp (6) null;
comment on column RCRA_CME_EVAL.C_CREATED_DATE is 'Creation Date (CCreatedDate)';

alter table RCRA_CME_EVAL add DATA_ORIG char(2) null;
comment on column RCRA_CME_EVAL.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_GIS_GEO_INFORMATION: new columns
 */

alter table RCRA_GIS_GEO_INFORMATION add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_GIS_GEO_INFORMATION.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_GIS_GEO_INFORMATION add G_CREATED_DATE timestamp (6) null;
comment on column RCRA_GIS_GEO_INFORMATION.G_CREATED_DATE is 'Creation Date (GCreatedDate)';

alter table RCRA_GIS_GEO_INFORMATION add DATA_ORIG char(2) null;
comment on column RCRA_GIS_GEO_INFORMATION.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_HD_HANDLER: new columns
 */

alter table RCRA_HD_HANDLER add CURR_REC char(1) null;
comment on column RCRA_HD_HANDLER.CURR_REC is 'Flag indicating if it is current record (CurrentRecord)';

alter table RCRA_HD_HANDLER add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_HD_HANDLER.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_HD_HANDLER add H_CREATED_DATE timestamp (6) null;
comment on column RCRA_HD_HANDLER.H_CREATED_DATE is 'Creation Date (HCreatedDate)';

alter table RCRA_HD_HANDLER add DATA_ORIG char(2) null;
comment on column RCRA_HD_HANDLER.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_FA_MECHANISM_DETAIL: new columns
 */

alter table RCRA_FA_MECHANISM_DETAIL add CURR_MECH_DET_IND char(1) null;
comment on column RCRA_FA_MECHANISM_DETAIL.CURR_MECH_DET_IND is 'Indicates if the mechanism detail is current. Possible values are: Y/N (CurrentMechanismDetailIndicator)';

alter table RCRA_FA_MECHANISM_DETAIL add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_FA_MECHANISM_DETAIL.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_FA_MECHANISM_DETAIL add F_CREATED_DATE timestamp (6) null;
comment on column RCRA_FA_MECHANISM_DETAIL.F_CREATED_DATE is 'Creation Date (FCreatedDate)';

alter table RCRA_FA_MECHANISM_DETAIL add DATA_ORIG char(2) null;
comment on column RCRA_FA_MECHANISM_DETAIL.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_FA_MECHANISM: new columns
 */

alter table RCRA_FA_MECHANISM add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_FA_MECHANISM.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_FA_MECHANISM add F_CREATED_DATE TIMESTAMP (6) null;
comment on column RCRA_FA_MECHANISM.F_CREATED_DATE is 'Creation Date (FCreatedDate)';

alter table RCRA_FA_MECHANISM add DATA_ORIG char(2) null;
comment on column RCRA_FA_MECHANISM.DATA_ORIG is 'Indicates data origination information (DataOrig)';

/*
 * RCRA_CME_VIOL: new columns
 */

alter table RCRA_CME_VIOL add CREATED_BY_USER_ID varchar2(255) null;
comment on column RCRA_CME_VIOL.CREATED_BY_USER_ID is 'User id of record creation (CreatedByUserid)';

alter table RCRA_CME_VIOL add C_CREATED_DATE TIMESTAMP (6) null;
comment on column RCRA_CME_VIOL.C_CREATED_DATE is 'Creation Date (CCreatedDate)';
