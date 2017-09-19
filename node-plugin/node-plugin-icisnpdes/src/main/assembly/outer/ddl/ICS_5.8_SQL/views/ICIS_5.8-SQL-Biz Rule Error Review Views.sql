IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_BP_BASIC_PRMT_ERRORS') AND type = N'V')
DROP VIEW ICS_V_BP_BASIC_PRMT_ERRORS
GO

/*
Copyright (c) 2012, The Environmental Council of the States (ECOS)
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
CREATE VIEW ICS_V_BP_BASIC_PRMT_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_BP_BASIC_PRMT_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Basic Permit records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 06/13/2017   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_basic_prmt.transaction_type
     , ics_basic_prmt.prmt_ident
     , ics_basic_prmt.prmt_issue_date
     , ics_basic_prmt.prmt_effective_date
     , ics_basic_prmt.prmt_expr_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_basic_prmt as ics_basic_prmt 
  JOIN ics_subm_results as ics_subm_results
  on ics_basic_prmt.prmt_ident = ics_subm_results.prmt_ident 
WHERE ics_subm_results.result_type_code = 'Error'
  AND ics_subm_results.subm_type_name = 'BasicPermitSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_CM_CMPL_MON_ERRORS') AND type = N'V')
DROP VIEW ICS_V_CM_CMPL_MON_ERRORS
GO
CREATE VIEW ICS_V_CM_CMPL_MON_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_CM_CMPL_MON_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Compliance Monitoring records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor     Created 
** 12/09/2014   TConrad     Added cmpl_mon_ident.
***************************************************************************************************/

SELECT ics_cmpl_mon.cmpl_mon_ident
     , ics_cmpl_mon.prmt_ident
     , ics_cmpl_mon.cmpl_mon_catg_code
     , ics_cmpl_mon.cmpl_mon_date
     , result_code
     , result_desc
  FROM ics_cmpl_mon as ics_cmpl_mon
  JOIN ics_subm_results as ics_subm_results 
    ON ics_subm_results.cmpl_mon_ident = ics_cmpl_mon.cmpl_mon_ident
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'ComplianceMonitoringSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_CM_CMPL_MON_LNK_ERRORS') AND type = N'V')
DROP VIEW ICS_V_CM_CMPL_MON_LNK_ERRORS
GO
CREATE VIEW ICS_V_CM_CMPL_MON_LNK_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_CM_CMPL_MON_LNK_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Compliance Monitoring Linkage records that return ICIS business rule
**               violations.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 12/09/2014   Windsor     Created 
** 05/25/2017   TConrad     Added the single event violation code and date.
***************************************************************************************************/

SELECT ics_cmpl_mon_lnk.cmpl_mon_ident
     , ics_cmpl_mon.prmt_ident
     , ics_cmpl_mon.cmpl_mon_catg_code
     , ics_cmpl_mon.cmpl_mon_date
	 , ics_subm_results.sngl_evt_viol_code
	 , ics_subm_results.sngl_evt_viol_date
     , result_code
     , result_desc
  FROM ics_cmpl_mon as ics_cmpl_mon
  JOIN ics_cmpl_mon_lnk as ics_cmpl_mon_lnk
    ON ics_cmpl_mon_lnk.cmpl_mon_ident = ics_cmpl_mon.cmpl_mon_ident
  JOIN ics_subm_results as ics_subm_results 
    ON ics_subm_results.cmpl_mon_ident = ics_cmpl_mon_lnk.cmpl_mon_ident
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'ComplianceMonitoringLinkageSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_CS_CMPL_SCHD_ERRORS') AND type = N'V')
DROP VIEW ICS_V_CS_CMPL_SCHD_ERRORS
GO
CREATE VIEW ICS_V_CS_CMPL_SCHD_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_CS_CMPL_SCHD_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Compliance Schedule records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/

SELECT ics_cmpl_schd.transaction_type
     , ics_cmpl_schd.prmt_ident
     , ics_cmpl_schd.enfrc_actn_ident
     , ics_cmpl_schd.final_order_ident
     , ics_cmpl_schd.cmpl_schd_num
     , ics_cmpl_schd.schd_desc_code
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_cmpl_schd
  JOIN ics_subm_results
    ON ics_cmpl_schd.prmt_ident = ics_subm_results.prmt_ident 
   AND ics_cmpl_schd.enfrc_actn_ident = ics_subm_results.enfrc_actn_ident
   AND ics_cmpl_schd.final_order_ident = ics_subm_results.final_order_ident
   AND ics_cmpl_schd.cmpl_schd_num = ics_subm_results.cmpl_schd_num
   AND ics_cmpl_schd.enfrc_actn_ident = ics_subm_results.enfrc_actn_ident
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'ComplianceScheduleSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_DM_DMR_ERRORS') AND type = N'V')
DROP VIEW ICS_V_DM_DMR_ERRORS
GO
CREATE VIEW ICS_V_DM_DMR_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_DM_DMR_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the DMR records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
** 12/11/2012   Windsor      Add NULL field support when error is on DMR key only (no parameter data)
** 02/07/2013   TK Conrad    Concatenating num_rep_no_dsch_ind + num_cond_qty will always result in
**                           a NULL value since only one of these fields can be populated for a given
**                           num_rep_code. Changed this to an ISNULL(num_rep_no_dsch_ind,num_cond_qty)
**                           instead.
***************************************************************************************************/
SELECT ics_subm_results.result_code
     , ics_subm_results.prmt_ident
     , ics_subm_results.prmt_featr_ident + ics_subm_results.lmt_set_designator limit_set
     , ics_subm_results.mon_period_end_date
     , ics_rep_param.param_code 
     , ics_rep_param.mon_site_desc_code mon_loc
     , ics_rep_param.lmt_season_num season
     , ics_dsch_mon_rep.dmr_no_dsch_ind as NODI
     , (SELECT TOP 1 ISNULL(num_rep_no_dsch_ind, num_cond_qty) FROM ics_num_rep WHERE num_rep_code = 'Q1' AND ics_rep_param_id = ics_rep_param.ics_rep_param_id) Q1
     , (SELECT TOP 1 ISNULL(num_rep_no_dsch_ind, num_cond_qty) FROM ics_num_rep WHERE num_rep_code = 'Q2' AND ics_rep_param_id = ics_rep_param.ics_rep_param_id) Q2
     , qty_num_rep_unit_meas_code QTY_UNIT
     , (SELECT TOP 1 ISNULL(num_rep_no_dsch_ind, num_cond_qty) FROM ics_num_rep WHERE num_rep_code = 'C1' AND ics_rep_param_id = ics_rep_param.ics_rep_param_id) C1
     , (SELECT TOP 1 ISNULL(num_rep_no_dsch_ind, num_cond_qty) FROM ics_num_rep WHERE num_rep_code = 'C2' AND ics_rep_param_id = ics_rep_param.ics_rep_param_id) C2
     , (SELECT TOP 1 ISNULL(num_rep_no_dsch_ind, num_cond_qty) FROM ics_num_rep WHERE num_rep_code = 'C3' AND ics_rep_param_id = ics_rep_param.ics_rep_param_id) C3
     , concen_num_rep_unit_meas_code CNC_UNIT
     , result_desc
  FROM ics_dsch_mon_rep
    JOIN ics_rep_param
    ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
    JOIN ics_subm_results
      ON ics_subm_results.prmt_ident = ics_dsch_mon_rep.prmt_ident
     AND ics_subm_results.prmt_featr_ident = ics_dsch_mon_rep.prmt_featr_ident
     AND ics_subm_results.lmt_set_designator = ics_dsch_mon_rep.lmt_set_designator
     AND ics_subm_results.mon_period_end_date = ics_dsch_mon_rep.mon_period_end_date
     AND ics_subm_results.param_code = ics_rep_param.param_code
     AND ics_subm_results.mon_site_desc_code = ics_rep_param.mon_site_desc_code
     AND ics_subm_results.lmt_season_num = ics_rep_param.lmt_season_num
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'DischargeMonitoringReportSubmission'
 UNION 
 -- This returns errors on the DMR Form key only, such as DMR030. No parameter data is present in this scenario.
 SELECT ics_subm_results.result_code
     , ics_subm_results.prmt_ident
     , ics_subm_results.prmt_featr_ident + ics_subm_results.lmt_set_designator limit_set
     , ics_subm_results.mon_period_end_date
     , NULL as param_code 
     , NULL as mon_loc
     , NULL as season
     , NULL as NODI
     , NULL AS Q1
     , NULL AS Q2
     , NULL AS QTY_UNIT
     , NULL AS C1
     , NULL AS C2
     , NULL AS C3
     , NULL AS CNC_UNIT
     , result_desc
  FROM ics_dsch_mon_rep
    JOIN ics_subm_results
      ON ics_subm_results.prmt_ident = ics_dsch_mon_rep.prmt_ident
     AND ics_subm_results.prmt_featr_ident = ics_dsch_mon_rep.prmt_featr_ident
     AND ics_subm_results.lmt_set_designator = ics_dsch_mon_rep.lmt_set_designator
     AND ics_subm_results.mon_period_end_date = ics_dsch_mon_rep.mon_period_end_date
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'DischargeMonitoringReportSubmission'  
   AND ics_subm_results.param_code IS NULL
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_FA_FRML_ENFRC_ACTN_ERR') AND type = N'V')
DROP VIEW ICS_V_FA_FRML_ENFRC_ACTN_ERR
GO
CREATE VIEW ICS_V_FA_FRML_ENFRC_ACTN_ERR
AS
/*************************************************************************************************
** ObjectName: ICS_V_FA_FRML_ENFRC_ACTN_ERR
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Formal Enforcement Action records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_frml_enfrc_actn.transaction_type
     , ics_frml_enfrc_actn.enfrc_actn_ident
     , ics_frml_enfrc_actn.forum
     , ics_final_order.final_order_ident
     , ics_final_order.final_order_type_code
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_frml_enfrc_actn
  JOIN ics_subm_results 
    ON ics_frml_enfrc_actn.enfrc_actn_ident = ics_subm_results.enfrc_actn_ident
  LEFT JOIN ics_final_order
         ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
WHERE ics_subm_results.result_type_code IN ('Error','Warning')
  AND ics_subm_results.subm_type_name = 'FormalEnforcementActionSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_GP_GNRL_PRMT_ERRORS') AND type = N'V')
DROP VIEW ICS_V_GP_GNRL_PRMT_ERRORS
GO
CREATE VIEW ICS_V_GP_GNRL_PRMT_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_GP_GNRL_PRMT_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the General Permit records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/

SELECT ics_gnrl_prmt.transaction_type
     , ics_gnrl_prmt.prmt_ident
     , ics_gnrl_prmt.prmt_issue_date
     , ics_gnrl_prmt.prmt_effective_date
     , ics_gnrl_prmt.prmt_expr_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_gnrl_prmt 
  JOIN ics_subm_results
    ON ics_gnrl_prmt.prmt_ident = ics_subm_results.prmt_ident 
WHERE ics_subm_results.result_type_code = 'Error'
  AND ics_subm_results.subm_type_name = 'GeneralPermitSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_IA_INF_ENFRC_ACTN') AND type = N'V')
DROP VIEW ICS_V_IA_INF_ENFRC_ACTN
GO
CREATE VIEW ICS_V_IA_INF_ENFRC_ACTN
AS
/*************************************************************************************************
** ObjectName: ICS_V_IA_INF_ENFRC_ACTN
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Informal Enforcement Action records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_infrml_enfrc_actn.transaction_type
     , ics_infrml_enfrc_actn.enfrc_actn_ident
     , ics_infrml_enfrc_actn.enfrc_actn_type_code
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_infrml_enfrc_actn  
  JOIN ics_subm_results 
    ON ics_infrml_enfrc_actn.enfrc_actn_ident = ics_subm_results.enfrc_actn_ident
WHERE ics_subm_results.result_type_code IN ('Error','Warning')
  AND ics_subm_results.subm_type_name = 'InformalEnforcementActionSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_LS_LIMIT_SET_ERRORS') AND type = N'V')
DROP VIEW ICS_V_LS_LIMIT_SET_ERRORS
GO
CREATE VIEW ICS_V_LS_LIMIT_SET_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_LS_LIMIT_SET_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Limit Set records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor     Created 
** 12/24/2012   Windsor     Added report/submission units columns
**
***************************************************************************************************/
SELECT ics_lmt_set.prmt_ident
     , ics_lmt_set.prmt_featr_ident
     , ics_lmt_set.lmt_set_designator
     , ics_lmt_set_schd.NUM_UNITS_REP_PERIOD_INTEGER as report_units
     , ics_lmt_set_schd.NUM_SUBM_UNITS_INTEGER as submission_units
     , ics_lmt_set_schd.initial_mon_date
     , ics_lmt_set_schd.initial_dmr_due_date
     , result_code
     , result_desc
  FROM ics_lmt_set as ics_lmt_set
    JOIN ics_subm_results as ics_subm_results 
      ON ics_subm_results.prmt_ident = ics_lmt_set.prmt_ident
     AND ics_subm_results.prmt_featr_ident = ics_lmt_set.prmt_featr_ident
     AND ics_subm_results.lmt_set_designator = ics_lmt_set.lmt_set_designator
    LEFT JOIN ics_lmt_set_schd as ics_lmt_set_schd
      ON ics_lmt_set_schd.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'LimitSetSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_MGP_MSTR_GNRL_PRMT_ERR') AND type = N'V')
DROP VIEW ICS_V_MGP_MSTR_GNRL_PRMT_ERR
GO
CREATE VIEW ICS_V_MGP_MSTR_GNRL_PRMT_ERR
AS
/*************************************************************************************************
** ObjectName: ICS_V_MGP_MSTR_GNRL_PRMT_ERR
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Master General Permit records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_gnrl_prmt.transaction_type
     , ics_gnrl_prmt.prmt_ident
     , ics_gnrl_prmt.prmt_issue_date
     , ics_gnrl_prmt.prmt_effective_date
     , ics_gnrl_prmt.prmt_expr_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_gnrl_prmt 
  JOIN ics_subm_results
    ON ics_gnrl_prmt.prmt_ident = ics_subm_results.prmt_ident 
WHERE ics_subm_results.result_type_code = 'Error'
  AND ics_subm_results.subm_type_name = 'MasterGeneralPermitSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_NC_NARR_COND_SCHD_ERRORS') AND type = N'V')
DROP VIEW ICS_V_NC_NARR_COND_SCHD_ERRORS
GO
CREATE VIEW ICS_V_NC_NARR_COND_SCHD_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_NC_NARR_COND_SCHD_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Narrative Condition Schedule records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor     Created 
**
***************************************************************************************************/
SELECT ics_narr_cond_schd.prmt_ident
     , ics_narr_cond_schd.narr_cond_num
     , ics_narr_cond_schd.narr_cond_code
     , result_code
     , result_desc
  FROM ics_narr_cond_schd
    JOIN ics_subm_results 
      ON ics_subm_results.prmt_ident = ics_narr_cond_schd.prmt_ident
     AND ics_subm_results.narr_cond_num = ics_narr_cond_schd.narr_cond_num
 WHERE ics_subm_results.result_type_code = 'Error'
   AND ics_subm_results.subm_type_name = 'NarrativeConditionScheduleSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_PF_PRMT_FEATR_ERRORS') AND type = N'V')
DROP VIEW ICS_V_PF_PRMT_FEATR_ERRORS
GO
CREATE VIEW ICS_V_PF_PRMT_FEATR_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_PF_PRMT_FEATR_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Permitted Feature records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/

SELECT ics_prmt_featr.transaction_type
     , ics_prmt_featr.prmt_ident
     , ics_prmt_featr.prmt_featr_ident
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_prmt_featr as ics_prmt_featr 
  JOIN ics_subm_results as ics_subm_results
    ON ics_prmt_featr.prmt_ident = ics_subm_results.prmt_ident 
   AND ics_prmt_featr.prmt_featr_ident = ics_subm_results.prmt_featr_ident
WHERE ics_subm_results.result_type_code = 'Error'
  AND ics_subm_results.subm_type_name = 'PermittedFeatureSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_PL_PARAM_LMT_ERRORS') AND type = N'V')
DROP VIEW ICS_V_PL_PARAM_LMT_ERRORS
GO
CREATE VIEW ICS_V_PL_PARAM_LMT_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_PL_PARAM_LMT_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Parameter Limit records that return ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor     Created 
** 11/01/2012   Windsor     Fix typo in subm_type_name
** 12/03/2012   Windsor     Add display text for limits that are Monitor Only (num_cond_opt_mon_ind = 'Y')
** 12/20/2012   Windsor     Add months column to SELECT list
** 12/26/2012   Windsor     Update get_limit_months function name to match renamed function
**
***************************************************************************************************/

SELECT ics_subm_results.result_code
     , ics_subm_results.prmt_ident
     , ics_subm_results.prmt_featr_ident
     , ics_subm_results.lmt_set_designator
     , ics_subm_results.param_code
     , ics_subm_results.mon_site_desc_code
     , ics_subm_results.lmt_season_num
     , ics_lmt.lmt_start_date
     , ics_lmt.lmt_end_date
     , dbo.get_limit_months(ics_lmt.ics_lmt_id) month_count
     , RTRIM((SELECT CASE WHEN num_cond_opt_mon_ind = 'Y' THEN 'MntrOnly ' ELSE '' END + ISNULL(num_cond_qualifier,'') + ISNULL(num_cond_qty,'') + ' ' + ISNULL(num_cond_stat_base_code,'') FROM ics_num_cond WHERE num_cond_txt = 'Q1' AND ics_lmt_id = ics_lmt.ics_lmt_id)) Q1
     , RTRIM((SELECT CASE WHEN num_cond_opt_mon_ind = 'Y' THEN 'MntrOnly ' ELSE '' END + ISNULL(num_cond_qualifier,'') + ISNULL(num_cond_qty,'') + ' ' + ISNULL(num_cond_stat_base_code,'') FROM ics_num_cond WHERE num_cond_txt = 'Q2' AND ics_lmt_id = ics_lmt.ics_lmt_id)) Q2
     , qty_num_cond_unit_meas_code QTY_UNIT
     , RTRIM((SELECT CASE WHEN num_cond_opt_mon_ind = 'Y' THEN 'MntrOnly ' ELSE '' END + ISNULL(num_cond_qualifier,'') + ISNULL(num_cond_qty,'') + ' ' + ISNULL(num_cond_stat_base_code,'') FROM ics_num_cond WHERE num_cond_txt = 'C1' AND ics_lmt_id = ics_lmt.ics_lmt_id)) C1
     , RTRIM((SELECT CASE WHEN num_cond_opt_mon_ind = 'Y' THEN 'MntrOnly ' ELSE '' END + ISNULL(num_cond_qualifier,'') + ISNULL(num_cond_qty,'') + ' ' + ISNULL(num_cond_stat_base_code,'') FROM ics_num_cond WHERE num_cond_txt = 'C2' AND ics_lmt_id = ics_lmt.ics_lmt_id)) C2
     , RTRIM((SELECT CASE WHEN num_cond_opt_mon_ind = 'Y' THEN 'MntrOnly ' ELSE '' END + ISNULL(num_cond_qualifier,'') + ISNULL(num_cond_qty,'') + ' ' + ISNULL(num_cond_stat_base_code,'') FROM ics_num_cond WHERE num_cond_txt = 'C3' AND ics_lmt_id = ics_lmt.ics_lmt_id)) C3
     , concen_num_cond_unit_meas_code CNC_UNIT
     , result_desc
  FROM ics_param_lmts ics_param_lmts
  JOIN ics_subm_results ics_subm_results
    ON ics_subm_results.prmt_ident = ics_param_lmts.prmt_ident
   AND ics_subm_results.prmt_featr_ident = ics_param_lmts.prmt_featr_ident
   AND ics_subm_results.lmt_set_designator = ics_param_lmts.lmt_set_designator
   AND ics_subm_results.param_code = ics_param_lmts.param_code
   AND ics_subm_results.mon_site_desc_code = ics_param_lmts.mon_site_desc_code
   AND ics_subm_results.lmt_season_num = ics_param_lmts.lmt_season_num
  LEFT JOIN ics_lmt ics_lmt
    ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'ParameterLimitsSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_PT_PRMT_REISSU_ERRORS') AND type = N'V')
DROP VIEW ICS_V_PT_PRMT_REISSU_ERRORS
GO
CREATE VIEW ICS_V_PT_PRMT_REISSU_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_PT_PRMT_REISSU_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Permit Reissuance records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_prmt_reissu.prmt_ident
     , ics_prmt_reissu.prmt_issue_date
     , ics_prmt_reissu.prmt_effective_date
     , ics_prmt_reissu.prmt_expr_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
  FROM ics_prmt_reissu
    JOIN ics_subm_results 
      ON ics_subm_results.prmt_ident = ics_prmt_reissu.prmt_ident
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'PermitReissuanceSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_PT_PRMT_TERM_ERRORS') AND type = N'V')
DROP VIEW ICS_V_PT_PRMT_TERM_ERRORS
GO
CREATE VIEW ICS_V_PT_PRMT_TERM_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_PT_PRMT_TERM_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Permit Termination records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/18/2012   Windsor      Created 
**
***************************************************************************************************/

SELECT ics_prmt_term.prmt_ident
     , ics_prmt_term.prmt_term_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
  FROM ics_prmt_term
    JOIN ics_subm_results 
      ON ics_subm_results.prmt_ident = ics_prmt_term.prmt_ident
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
  AND ics_subm_results.subm_type_name = 'PermitTerminationSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_PT_PRMT_TRACK_EVT_ERRORS') AND type = N'V')
DROP VIEW ICS_V_PT_PRMT_TRACK_EVT_ERRORS
GO
CREATE VIEW ICS_V_PT_PRMT_TRACK_EVT_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_PT_PRMT_TRACK_EVT_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Permit Tracking Event records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/29/2012   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_prmt_track_evt.prmt_ident
     , ics_prmt_track_evt.prmt_track_evt_code
     , ics_prmt_track_evt.prmt_track_evt_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
  FROM ics_prmt_track_evt
  JOIN ics_subm_results 
    ON ics_subm_results.prmt_ident = ics_prmt_track_evt.prmt_ident
   AND ics_subm_results.prmt_track_evt_code = ics_prmt_track_evt.prmt_track_evt_code
   AND ics_subm_results.prmt_track_evt_date = ics_prmt_track_evt.prmt_track_evt_date
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'PermitTrackingEventSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_SEV_SNGL_EVT_VIOL_ERRORS') AND type = N'V')
DROP VIEW ICS_V_SEV_SNGL_EVT_VIOL_ERRORS
GO
CREATE VIEW ICS_V_SEV_SNGL_EVT_VIOL_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_SEV_SNGL_EVT_VIOL_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Single Event Violation records that have ICIS business rule violations
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name         Description
** ------------------------------------------------------------------------------------------------
** 02/12/2013   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_sngl_evt_viol.prmt_ident
     , ics_sngl_evt_viol.sngl_evt_viol_code
     , ics_sngl_evt_viol.sngl_evt_viol_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
  FROM ics_sngl_evt_viol
  JOIN ics_subm_results 
    ON ics_subm_results.prmt_ident = ics_sngl_evt_viol.prmt_ident
   AND ics_subm_results.sngl_evt_viol_code = ics_sngl_evt_viol.sngl_evt_viol_code
   AND ics_subm_results.sngl_evt_viol_date = ics_sngl_evt_viol.sngl_evt_viol_date
 WHERE ics_subm_results.result_type_code IN ('Error','Warning')
   AND ics_subm_results.subm_type_name = 'SingleEventViolationSubmission';
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ics_v_module_count'))
DROP VIEW dbo.ics_v_module_count
GO


/*************************************************************************************************
** ObjectName: ics_v_module_count
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view displays a count of accepted, rejected, and warning records for each module
**               Used in process_accepted_transactions procedure to insert into ics_subm_hist
**
** Revision History:
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 4/5/2012      Windsor     Created 
** 5/15/2012     BRensmith   Added columns for count by transaction type
** 5/25/2012     BRensmith   Added column for accepted_count_total
** 12/10/2012    BRensmith   Rewrote view to eliminate possible duplicates, now driven off of ics_payload
** 6/13/2017     CTyler      Added BiosolidsAnnualProgramReportSubmission into query
**
***************************************************************************************************/
CREATE VIEW dbo.ics_v_module_count

AS

SELECT operation
    , [enabled]
    , CASE 
      WHEN ics_payload.operation = 'BasicPermitSubmission' THEN (SELECT COUNT(1) FROM ics_basic_prmt)
      WHEN ics_payload.operation = 'BiosolidsPermitSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prmt)
      WHEN ics_payload.operation = 'BiosolidsAnnualProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_annul_prog_rep)
      WHEN ics_payload.operation = 'CAFOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_prmt )
      WHEN ics_payload.operation = 'CSOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cso_prmt )
      WHEN ics_payload.operation = 'ComplianceMonitoringSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_mon )
      WHEN ics_payload.operation = 'GeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_gnrl_prmt )
      WHEN ics_payload.operation = 'MasterGeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_master_gnrl_prmt )
      WHEN ics_payload.operation = 'PermitReissuanceSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_reissu )
      WHEN ics_payload.operation = 'PermitTerminationSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_term )
      WHEN ics_payload.operation = 'PermitTrackingEventSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_track_evt )
      WHEN ics_payload.operation = 'POTWPermitSubmission' THEN (SELECT COUNT(1) FROM ics_potw_prmt )
      WHEN ics_payload.operation = 'PretreatmentPermitSubmission' THEN (SELECT COUNT(1) FROM ics_pretr_prmt )
      WHEN ics_payload.operation = 'SWConstructionPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_cnst_prmt )
      WHEN ics_payload.operation = 'SWIndustrialPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_indst_prmt )
      WHEN ics_payload.operation = 'SWMS4LargePermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_large_prmt )
      WHEN ics_payload.operation = 'SWMS4SmallPermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_small_prmt )
      WHEN ics_payload.operation = 'UnpermittedFacilitySubmission' THEN (SELECT COUNT(1) FROM ics_unprmt_fac )
      WHEN ics_payload.operation = 'HistoricalPermitScheduleEventsSubmission' THEN (SELECT COUNT(1) FROM ics_hist_prmt_schd_evts )
      WHEN ics_payload.operation = 'NarrativeConditionScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_narr_cond_schd )
      WHEN ics_payload.operation = 'PermittedFeatureSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_featr )
      WHEN ics_payload.operation = 'LimitSetSubmission' THEN (SELECT COUNT(1) FROM ics_lmt_set )
      WHEN ics_payload.operation = 'LimitsSubmission' THEN (SELECT COUNT(1) FROM ics_lmts )
      WHEN ics_payload.operation = 'ParameterLimitsSubmission' THEN (SELECT COUNT(1) FROM ics_param_lmts )
      WHEN ics_payload.operation = 'DischargeMonitoringReportSubmission' THEN (SELECT COUNT(1) FROM ics_dsch_mon_rep )
      WHEN ics_payload.operation = 'SingleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_sngl_evt_viol )
      WHEN ics_payload.operation = 'ScheduleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_schd_evt_viol )
      WHEN ics_payload.operation = 'ComplianceScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_schd )
      WHEN ics_payload.operation = 'DMRViolationSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_viol )
      WHEN ics_payload.operation = 'ComplianceMonitoringLinkage' THEN (SELECT COUNT(1) FROM ics_cmpl_mon_lnk )
      WHEN ics_payload.operation = 'FinalOrderViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_final_order_viol_lnk )
      WHEN ics_payload.operation = 'EnforcementActionViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_viol_lnk )
      WHEN ics_payload.operation = 'DMRProgramReportLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_prog_rep_lnk )
      WHEN ics_payload.operation = 'EffluentTradePartnerSubmission' THEN (SELECT COUNT(1) FROM ics_efflu_trade_prtner )
      WHEN ics_payload.operation = 'FormalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_frml_enfrc_actn )
      WHEN ics_payload.operation = 'InformalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_infrml_enfrc_actn )
      WHEN ics_payload.operation = 'EnforcementActionMilestoneSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_milestone )
      WHEN ics_payload.operation = 'CSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_cso_evt_rep )
      WHEN ics_payload.operation = 'SWEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sw_evt_rep )
      WHEN ics_payload.operation = 'CAFOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_annul_rep )
      WHEN ics_payload.operation = 'LocalLimitsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_loc_lmts_prog_rep )
      WHEN ics_payload.operation = 'PretreatmentPerformanceSummarySubmission' THEN (SELECT COUNT(1) FROM ics_pretr_perf_summ )
      WHEN ics_payload.operation = 'BiosolidsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prog_rep )
      WHEN ics_payload.operation = 'SSOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_annul_rep )
      WHEN ics_payload.operation = 'SSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_evt_rep )
      WHEN ics_payload.operation = 'SSOMonthlyEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_monthly_evt_rep )
      WHEN ics_payload.operation = 'SWMS4ProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_prog_rep )
    END as trans_count_staged
  , CASE 
      WHEN ics_payload.operation = 'BasicPermitSubmission' THEN (SELECT COUNT(1) FROM ics_basic_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'BiosolidsPermitSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'BiosolidsAnnualProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_annul_prog_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'CAFOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'CSOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cso_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'ComplianceMonitoringSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_mon WHERE transaction_type='N')
      WHEN ics_payload.operation = 'GeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_gnrl_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'MasterGeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_master_gnrl_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PermitReissuanceSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_reissu WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PermitTerminationSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_term WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PermitTrackingEventSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_track_evt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'POTWPermitSubmission' THEN (SELECT COUNT(1) FROM ics_potw_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PretreatmentPermitSubmission' THEN (SELECT COUNT(1) FROM ics_pretr_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWConstructionPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_cnst_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWIndustrialPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_indst_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWMS4LargePermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_large_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWMS4SmallPermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_small_prmt WHERE transaction_type='N')
      WHEN ics_payload.operation = 'UnpermittedFacilitySubmission' THEN (SELECT COUNT(1) FROM ics_unprmt_fac WHERE transaction_type='N')
      WHEN ics_payload.operation = 'HistoricalPermitScheduleEventsSubmission' THEN (SELECT COUNT(1) FROM ics_hist_prmt_schd_evts WHERE transaction_type='N')
      WHEN ics_payload.operation = 'NarrativeConditionScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_narr_cond_schd WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PermittedFeatureSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_featr WHERE transaction_type='N')
      WHEN ics_payload.operation = 'LimitSetSubmission' THEN (SELECT COUNT(1) FROM ics_lmt_set WHERE transaction_type='N')
      WHEN ics_payload.operation = 'LimitsSubmission' THEN (SELECT COUNT(1) FROM ics_lmts WHERE transaction_type='N')
      WHEN ics_payload.operation = 'ParameterLimitsSubmission' THEN (SELECT COUNT(1) FROM ics_param_lmts WHERE transaction_type='N')
      WHEN ics_payload.operation = 'DischargeMonitoringReportSubmission' THEN (SELECT COUNT(1) FROM ics_dsch_mon_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SingleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_sngl_evt_viol WHERE transaction_type='N')
      WHEN ics_payload.operation = 'ScheduleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_schd_evt_viol WHERE transaction_type='N')
      WHEN ics_payload.operation = 'ComplianceScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_schd WHERE transaction_type='N')
      WHEN ics_payload.operation = 'DMRViolationSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_viol WHERE transaction_type='N')
      WHEN ics_payload.operation = 'ComplianceMonitoringLinkage' THEN (SELECT COUNT(1) FROM ics_cmpl_mon_lnk WHERE transaction_type='N')
      WHEN ics_payload.operation = 'FinalOrderViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_final_order_viol_lnk WHERE transaction_type='N')
      WHEN ics_payload.operation = 'EnforcementActionViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_viol_lnk WHERE transaction_type='N')
      WHEN ics_payload.operation = 'DMRProgramReportLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_prog_rep_lnk WHERE transaction_type='N')
      WHEN ics_payload.operation = 'EffluentTradePartnerSubmission' THEN (SELECT COUNT(1) FROM ics_efflu_trade_prtner WHERE transaction_type='N')
      WHEN ics_payload.operation = 'FormalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_frml_enfrc_actn WHERE transaction_type='N')
      WHEN ics_payload.operation = 'InformalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_infrml_enfrc_actn WHERE transaction_type='N')
      WHEN ics_payload.operation = 'EnforcementActionMilestoneSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_milestone WHERE transaction_type='N')
      WHEN ics_payload.operation = 'CSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_cso_evt_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sw_evt_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'CAFOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_annul_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'LocalLimitsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_loc_lmts_prog_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'PretreatmentPerformanceSummarySubmission' THEN (SELECT COUNT(1) FROM ics_pretr_perf_summ WHERE transaction_type='N')
      WHEN ics_payload.operation = 'BiosolidsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prog_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SSOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_annul_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_evt_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SSOMonthlyEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_monthly_evt_rep WHERE transaction_type='N')
      WHEN ics_payload.operation = 'SWMS4ProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_prog_rep WHERE transaction_type='N')
    END as trans_count_new
    , CASE 
      WHEN ics_payload.operation = 'BasicPermitSubmission' THEN (SELECT COUNT(1) FROM ics_basic_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'BiosolidsPermitSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'BiosolidsAnnualProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_annul_prog_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'CAFOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'CSOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cso_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'ComplianceMonitoringSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_mon WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'GeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_gnrl_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'MasterGeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_master_gnrl_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PermitReissuanceSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_reissu WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PermitTerminationSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_term WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PermitTrackingEventSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_track_evt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'POTWPermitSubmission' THEN (SELECT COUNT(1) FROM ics_potw_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PretreatmentPermitSubmission' THEN (SELECT COUNT(1) FROM ics_pretr_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWConstructionPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_cnst_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWIndustrialPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_indst_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWMS4LargePermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_large_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWMS4SmallPermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_small_prmt WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'UnpermittedFacilitySubmission' THEN (SELECT COUNT(1) FROM ics_unprmt_fac WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'HistoricalPermitScheduleEventsSubmission' THEN (SELECT COUNT(1) FROM ics_hist_prmt_schd_evts WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'NarrativeConditionScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_narr_cond_schd WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PermittedFeatureSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_featr WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'LimitSetSubmission' THEN (SELECT COUNT(1) FROM ics_lmt_set WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'LimitsSubmission' THEN (SELECT COUNT(1) FROM ics_lmts WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'ParameterLimitsSubmission' THEN (SELECT COUNT(1) FROM ics_param_lmts WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'DischargeMonitoringReportSubmission' THEN (SELECT COUNT(1) FROM ics_dsch_mon_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SingleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_sngl_evt_viol WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'ScheduleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_schd_evt_viol WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'ComplianceScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_schd WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'DMRViolationSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_viol WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'ComplianceMonitoringLinkage' THEN (SELECT COUNT(1) FROM ics_cmpl_mon_lnk WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'FinalOrderViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_final_order_viol_lnk WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'EnforcementActionViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_viol_lnk WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'DMRProgramReportLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_prog_rep_lnk WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'EffluentTradePartnerSubmission' THEN (SELECT COUNT(1) FROM ics_efflu_trade_prtner WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'FormalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_frml_enfrc_actn WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'InformalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_infrml_enfrc_actn WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'EnforcementActionMilestoneSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_milestone WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'CSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_cso_evt_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sw_evt_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'CAFOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_annul_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'LocalLimitsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_loc_lmts_prog_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'PretreatmentPerformanceSummarySubmission' THEN (SELECT COUNT(1) FROM ics_pretr_perf_summ WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'BiosolidsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prog_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SSOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_annul_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_evt_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SSOMonthlyEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_monthly_evt_rep WHERE transaction_type IN ('C','R'))
      WHEN ics_payload.operation = 'SWMS4ProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_prog_rep WHERE transaction_type IN ('C','R'))
    END as trans_count_chng_repl
      , CASE 
      WHEN ics_payload.operation = 'BasicPermitSubmission' THEN (SELECT COUNT(1) FROM ics_basic_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'BiosolidsPermitSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'BiosolidsAnnualProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_annul_prog_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'CAFOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'CSOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_cso_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'ComplianceMonitoringSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_mon WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'GeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_gnrl_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'MasterGeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_master_gnrl_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PermitReissuanceSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_reissu WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PermitTerminationSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_term WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PermitTrackingEventSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_track_evt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'POTWPermitSubmission' THEN (SELECT COUNT(1) FROM ics_potw_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PretreatmentPermitSubmission' THEN (SELECT COUNT(1) FROM ics_pretr_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWConstructionPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_cnst_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWIndustrialPermitSubmission' THEN (SELECT COUNT(1) FROM ics_sw_indst_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWMS4LargePermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_large_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWMS4SmallPermitSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_small_prmt WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'UnpermittedFacilitySubmission' THEN (SELECT COUNT(1) FROM ics_unprmt_fac WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'HistoricalPermitScheduleEventsSubmission' THEN (SELECT COUNT(1) FROM ics_hist_prmt_schd_evts WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'NarrativeConditionScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_narr_cond_schd WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PermittedFeatureSubmission' THEN (SELECT COUNT(1) FROM ics_prmt_featr WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'LimitSetSubmission' THEN (SELECT COUNT(1) FROM ics_lmt_set WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'LimitsSubmission' THEN (SELECT COUNT(1) FROM ics_lmts WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'ParameterLimitsSubmission' THEN (SELECT COUNT(1) FROM ics_param_lmts WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'DischargeMonitoringReportSubmission' THEN (SELECT COUNT(1) FROM ics_dsch_mon_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SingleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_sngl_evt_viol WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'ScheduleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_schd_evt_viol WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'ComplianceScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_cmpl_schd WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'DMRViolationSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_viol WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'ComplianceMonitoringLinkage' THEN (SELECT COUNT(1) FROM ics_cmpl_mon_lnk WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'FinalOrderViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_final_order_viol_lnk WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'EnforcementActionViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_viol_lnk WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'DMRProgramReportLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_dmr_prog_rep_lnk WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'EffluentTradePartnerSubmission' THEN (SELECT COUNT(1) FROM ics_efflu_trade_prtner WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'FormalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_frml_enfrc_actn WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'InformalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_infrml_enfrc_actn WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'EnforcementActionMilestoneSubmission' THEN (SELECT COUNT(1) FROM ics_enfrc_actn_milestone WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'CSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_cso_evt_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sw_evt_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'CAFOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_cafo_annul_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'LocalLimitsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_loc_lmts_prog_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'PretreatmentPerformanceSummarySubmission' THEN (SELECT COUNT(1) FROM ics_pretr_perf_summ WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'BiosolidsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_bs_prog_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SSOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_annul_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_evt_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SSOMonthlyEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_sso_monthly_evt_rep WHERE transaction_type IN ('D','X'))
      WHEN ics_payload.operation = 'SWMS4ProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_swms_4_prog_rep WHERE transaction_type IN ('D','X'))
    END as trans_count_del_mass_del
  , (  SELECT count(1) 
         FROM ics_subm_results
        WHERE subm_type_name = ics_payload.operation
          AND result_type_code = 'Error') as error_count
  , (  SELECT count(1) 
         FROM ics_subm_results
        WHERE subm_type_name = ics_payload.operation
          AND result_type_code = 'Warning') as warning_count
, (  SELECT count(1) 
         FROM ics_subm_results
        WHERE subm_type_name = ics_payload.operation
          AND result_type_code = 'Accepted') as accepted_count
  , CASE 
      WHEN ics_payload.operation = 'BasicPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_basic_prmt)
      WHEN ics_payload.operation = 'BiosolidsPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_bs_prmt)
      WHEN ics_payload.operation = 'BiosolidsAnnualProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_bs_annul_prog_rep)
      WHEN ics_payload.operation = 'CAFOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cafo_prmt)
      WHEN ics_payload.operation = 'CSOPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cso_prmt)
      WHEN ics_payload.operation = 'ComplianceMonitoringSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cmpl_mon)
      WHEN ics_payload.operation = 'GeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_gnrl_prmt)
      WHEN ics_payload.operation = 'MasterGeneralPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_master_gnrl_prmt)
      WHEN ics_payload.operation = 'PermitReissuanceSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_prmt_reissu)
      WHEN ics_payload.operation = 'PermitTerminationSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_prmt_term)
      WHEN ics_payload.operation = 'PermitTrackingEventSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_prmt_track_evt)
      WHEN ics_payload.operation = 'POTWPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_potw_prmt)
      WHEN ics_payload.operation = 'PretreatmentPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_pretr_prmt)
      WHEN ics_payload.operation = 'SWConstructionPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sw_cnst_prmt)
      WHEN ics_payload.operation = 'SWIndustrialPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sw_indst_prmt)
      WHEN ics_payload.operation = 'SWMS4LargePermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_swms_4_large_prmt)
      WHEN ics_payload.operation = 'SWMS4SmallPermitSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_swms_4_small_prmt)
      WHEN ics_payload.operation = 'UnpermittedFacilitySubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_unprmt_fac)
      WHEN ics_payload.operation = 'HistoricalPermitScheduleEventsSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_hist_prmt_schd_evts)
      WHEN ics_payload.operation = 'NarrativeConditionScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_narr_cond_schd)
      WHEN ics_payload.operation = 'PermittedFeatureSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_prmt_featr)
      WHEN ics_payload.operation = 'LimitSetSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_lmt_set)
      WHEN ics_payload.operation = 'LimitsSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_lmts)
      WHEN ics_payload.operation = 'ParameterLimitsSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_param_lmts)
      WHEN ics_payload.operation = 'DischargeMonitoringReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_dsch_mon_rep)
      WHEN ics_payload.operation = 'SingleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sngl_evt_viol)
      WHEN ics_payload.operation = 'ScheduleEventViolationSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_schd_evt_viol)
      WHEN ics_payload.operation = 'ComplianceScheduleSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cmpl_schd)
      WHEN ics_payload.operation = 'DMRViolationSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_dmr_viol)
      WHEN ics_payload.operation = 'ComplianceMonitoringLinkage' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk)
      WHEN ics_payload.operation = 'FinalOrderViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_final_order_viol_lnk)
      WHEN ics_payload.operation = 'EnforcementActionViolationLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk)
      WHEN ics_payload.operation = 'DMRProgramReportLinkageSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_dmr_prog_rep_lnk)
      WHEN ics_payload.operation = 'EffluentTradePartnerSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_efflu_trade_prtner)
      WHEN ics_payload.operation = 'FormalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_frml_enfrc_actn)
      WHEN ics_payload.operation = 'InformalEnforcementActionSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn)
      WHEN ics_payload.operation = 'EnforcementActionMilestoneSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_enfrc_actn_milestone)
      WHEN ics_payload.operation = 'CSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cso_evt_rep)
      WHEN ics_payload.operation = 'SWEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sw_evt_rep)
      WHEN ics_payload.operation = 'CAFOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_cafo_annul_rep)
      WHEN ics_payload.operation = 'LocalLimitsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep)
      WHEN ics_payload.operation = 'PretreatmentPerformanceSummarySubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_pretr_perf_summ)
      WHEN ics_payload.operation = 'BiosolidsProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_bs_prog_rep)
      WHEN ics_payload.operation = 'SSOAnnualReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sso_annul_rep)
      WHEN ics_payload.operation = 'SSOEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sso_evt_rep)
      WHEN ics_payload.operation = 'SSOMonthlyEventReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_sso_monthly_evt_rep)
      WHEN ics_payload.operation = 'SWMS4ProgramReportSubmission' THEN (SELECT COUNT(1) FROM ics_flow_icis.dbo.ics_swms_4_prog_rep)
    END as accepted_count_total
  FROM dbo.ics_payload

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ics_v_errors_by_error_type'))
DROP VIEW dbo.ics_v_errors_by_error_type
GO

/*************************************************************************************************
** ObjectName: ICS_V_ERRORS_BY_ERROR_TYPE
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view provides a count of errors by error type as returned by ICIS in processing reports
**
** Revision History:
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 05/14/2012   Windsor      Created 
** 12/05/2012   Windsor      Added CountCurrent column to indicate that the error came from the most recent submission 
**                           Added column aliases to be more user friendly
** 12/26/2012   Windsor      Fix CountCurrent for Accepted transactions. Was returning zero rows due to bad join
**
***************************************************************************************************/
CREATE VIEW ics_v_errors_by_error_type

AS

  SELECT   subm_type_name AS [SubmissionType]
         , COUNT(1) AS [CountTotal] 
         , (SELECT COUNT(1)
              FROM ics_subm_results
             WHERE subm_transaction_id = (SELECT TOP 1 subm_transaction_id 
                                            FROM ics_subm_track
                                           WHERE workflow_stat = 'Completed'
                                           ORDER BY subm_date_time DESC)
               AND ISNULL(result_code,'') = ISNULL(rslt.result_code,'')
               AND result_type_code = rslt.result_type_code
               AND subm_type_name = rslt.subm_type_name
           ) AS [CountCurrent]
         , result_type_code AS [ResultType]
         , result_code AS [ResultCode]
         , (SELECT TOP 1 result_desc
              FROM ics_subm_results
             WHERE result_code = rslt.result_code
               AND result_type_code = rslt.result_type_code
               AND subm_type_name = rslt.subm_type_name
           ) AS [FirstResultDescrip]
 FROM ics_subm_results rslt
GROUP BY subm_type_name,
    result_type_code,
    result_code    
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_IA_ENFRC_ACTN_VIOL_LNK') AND type = N'V')
DROP VIEW ICS_V_IA_ENFRC_ACTN_VIOL_LNK
GO
CREATE VIEW ICS_V_IA_ENFRC_ACTN_VIOL_LNK
AS
/*************************************************************************************************
** ObjectName: ICS_V_IA_ENFRC_ACTN_VIOL_LNK
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Formal and Informal Enforcement Action record linkages to Violations
**               that return ICIS business rule violations.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 05/16/2017   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_enfrc_actn_viol_lnk.transaction_type
     , ics_enfrc_actn_viol_lnk.enfrc_actn_ident
     , ics_sngl_evts_viol.prmt_ident
	 , ics_sngl_evts_viol.sngl_evt_viol_code
	 , ics_sngl_evts_viol.sngl_evt_viol_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_enfrc_actn_viol_lnk
  JOIN ics_sngl_evts_viol
    ON ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
  JOIN ics_subm_results 
    ON ics_enfrc_actn_viol_lnk.key_hash = ics_subm_results.key_hash
WHERE ics_subm_results.result_type_code IN ('Error','Warning')
  AND ics_subm_results.subm_type_name = 'EnforcementActionViolationLinkageSubmission';
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_IA_ENFRC_ACTN_MILESTN') AND type = N'V')
DROP VIEW ICS_V_IA_ENFRC_ACTN_MILESTN
GO
CREATE VIEW ICS_V_IA_ENFRC_ACTN_MILESTN
AS
/*************************************************************************************************
** ObjectName: ICS_V_IA_ENFRC_ACTN_MILESTN
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Enforcement Action Milestone records that return ICIS business rule
**               violations.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 05/22/2017   Windsor      Created 
**
***************************************************************************************************/
SELECT ics_enfrc_actn_milestone.transaction_type
     , ics_enfrc_actn_milestone.enfrc_actn_ident
     , ics_prmt_ident.prmt_ident
	 , ics_enfrc_actn_milestone.milestone_type_code
	 , ics_enfrc_actn_milestone.milestone_planned_date
	 , ics_enfrc_actn_milestone.milestone_actul_date
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_enfrc_actn_milestone
  JOIN ics_frml_enfrc_actn
    ON ics_frml_enfrc_actn.enfrc_actn_ident = ics_enfrc_actn_milestone.enfrc_actn_ident
  JOIN ics_prmt_ident
    ON ics_prmt_ident.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
  JOIN ics_subm_results 
    ON ics_enfrc_actn_milestone.key_hash = ics_subm_results.key_hash
WHERE ics_subm_results.result_type_code IN ('Error','Warning')
  AND ics_subm_results.subm_type_name = 'EnforcementActionMilestoneSubmission';
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_V_UF_UNPRMT_FAC_ERRORS') AND type = N'V')
DROP VIEW ICS_V_UF_UNPRMT_FAC_ERRORS
GO
CREATE VIEW ICS_V_UF_UNPRMT_FAC_ERRORS
AS
/*************************************************************************************************
** ObjectName: ICS_V_UF_UNPRMT_FAC_ERRORS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns the Unpermitted Facility records that have ICIS business rule violations.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 05/24/2017   Windsor      Created 
**
***************************************************************************************************/

SELECT ics_unprmt_fac.transaction_type
     , ics_unprmt_fac.prmt_ident
	 , ics_unprmt_fac.fac_site_name
	 , ics_unprmt_fac.loc_addr_txt
	 , ics_unprmt_fac.locality_name
	 , ics_unprmt_fac.loc_st_code
	 , ics_unprmt_fac.loc_zip_code
     , ics_subm_results.result_code
     , ics_subm_results.result_desc
FROM ics_unprmt_fac 
  JOIN ics_subm_results
    ON ics_unprmt_fac.prmt_ident = ics_subm_results.prmt_ident 
WHERE ics_subm_results.result_type_code = 'Error'
  AND ics_subm_results.subm_type_name = 'UnpermittedFacilitySubmission';
GO
