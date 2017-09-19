IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ICS_PROCESS_ACCEPTED_TRANS') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.ICS_PROCESS_ACCEPTED_TRANS
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

/*************************************************************************************************
** Object Name: ics_process_accepted_trans
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This procedure uses the data in ICS_SUBM_RESULTS table to copy the data for accepted
**               transactions from the LOCAL to ICIS schema/database. It should only be executed by
**               the OpenNode2 plugin as part of the GetICISStatusAndProcessReports service execution
**
** Revision History:
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 06/08/2016    Windsor     Baselined from v5.6 procedure. 
** 07/31/2017    EPerson     Removed deletion of ICS_FLOW_ICIS records for non-DMR payloads.
**
***************************************************************************************************/
CREATE PROCEDURE dbo.ICS_PROCESS_ACCEPTED_TRANS

   @p_transaction_id varchar(50)

AS

-- Stored procedure to move accepted transactions from ICS_FLOW_LOCAL to ICS_FLOW_ICIS.
-- Target Database: SQL Server

--Step 1: Remove processing results from previous submissions
--Step 2: Update key_hash with hashed business key data
--Step 3: Move accepted transactions from LOCAL to ICIS database
--Step 4: Copy business keys where ICIS returnes error that key is already present in ICIS
--Step 5: Record counts into ICS_SUBM_HIST

--Quit procedure if no records are returned relating to the current transaction. ICIS will return an empty processing report
  --if there is a severe error in the ICIS submission processor at EPA
IF (SELECT COUNT(1) FROM ics_subm_results WHERE subm_transaction_id = @p_transaction_id) = 0
   RETURN;

--Step 1: Remove processing results from previous submissions

    --Remove all old Accepted records
    DELETE 
      FROM ics_subm_results 
     WHERE result_type_code = 'Accepted'
       AND subm_transaction_id <> @p_transaction_id;

    --Delete errors if there was at least one accepted transaction for the same submission type in the latest submission 
    DELETE 
      FROM ics_subm_results 
     WHERE result_type_code IN ('Error','Warning')
	   AND subm_type_name   IN (SELECT subm_type_name
	                              FROM ics_subm_results
								 WHERE subm_transaction_id = @p_transaction_id
								   AND subm_type_name <> 'DischargeMonitoringReportSubmission'
								   AND result_type_code = 'Accepted')
       AND subm_transaction_id <> @p_transaction_id;
 
    --Remove previous DMR error transactions where same business key values exist in the most recent submission
	--This will leave previous DMR errors in the results table that have not yet been corrected.
	DELETE
	  FROM ics_subm_results
	 WHERE subm_type_name = 'DischargeMonitoringReportSubmission'
	   AND subm_transaction_id <> @p_transaction_id
	   AND result_type_code = 'Error'
	   AND EXISTS (SELECT 1
					 FROM ics_subm_results r
					WHERE r.subm_type_name = 'DischargeMonitoringReportSubmission'
					  AND r.subm_transaction_id = @p_transaction_id
					  AND r.prmt_ident         = ics_subm_results.prmt_ident
					  AND r.prmt_featr_ident   = ics_subm_results.prmt_featr_ident
					  AND r.lmt_set_designator = ics_subm_results.lmt_set_designator
					  AND r.param_code         = ics_subm_results.param_code
					  AND r.mon_site_desc_code = ics_subm_results.mon_site_desc_code
					  AND r.lmt_season_num     = ics_subm_results.lmt_season_num);

--Step 2: Update key_hash with hashed business key data
UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident)
 WHERE subm_transaction_id = @p_transaction_id
   AND subm_type_name IN ('BasicPermitSubmission'
                         ,'BiosolidsPermitSubmission'
						 ,'CAFOPermitSubmission'
						 ,'CSOPermitSubmission'
						 ,'GeneralPermitSubmission'
						 ,'MasterGeneralPermitSubmission'
						 ,'PermitReissuanceSubmission'
						 ,'PermitTerminationSubmission'
						 ,'POTWPermitSubmission'
						 ,'PretreatmentPermitSubmission'
						 ,'SWConstructionPermitSubmission'
						 ,'SWIndustrialPermitSubmission'
						 ,'SWMS4LargePermitSubmission'
						 ,'SWMS4SmallPermitSubmission'
						 ,'UnpermittedFacilitySubmission'
						 );

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_track_evt_code + CONVERT(varchar(50), prmt_track_evt_date))
 WHERE subm_type_name = 'PermitTrackingEventSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), prmt_effective_date) + CONVERT(varchar(50), narr_cond_num) + schd_evt_code + CONVERT(varchar(50), schd_date) + CONVERT(varchar(50), narr_cond_num) + schd_evt_code + CONVERT(varchar(50), schd_date))
 WHERE subm_type_name = 'HistoricalPermitScheduleEventsSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), narr_cond_num))
 WHERE subm_type_name = 'NarrativeConditionScheduleSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident)
 WHERE subm_type_name = 'PermittedFeatureSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator)
 WHERE subm_type_name = 'LimitSetSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code + CONVERT(varchar(50), lmt_season_num) + CONVERT(varchar(50), lmt_start_date) + CONVERT(varchar(50), lmt_end_date))
 WHERE subm_type_name = 'LimitsSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code + CONVERT(varchar(50), lmt_season_num))
 WHERE subm_type_name = 'ParameterLimitsSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + CONVERT(varchar(50), mon_period_end_date))
 WHERE subm_type_name = 'DischargeMonitoringReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', cmpl_mon_ident)
--   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + cmpl_mon_catg_code + CONVERT(varchar(50), cmpl_mon_date))
 WHERE subm_type_name = 'ComplianceMonitoringSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code + CONVERT(varchar(50), lmt_season_num) + CONVERT(varchar(50), lmt_start_date) + CONVERT(varchar(50), lmt_end_date) + CONVERT(varchar(50), lmt_mod_effective_date) + trade_id)
 WHERE subm_type_name = 'EffluentTradePartnerSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident)
 WHERE subm_type_name = 'FormalEnforcementActionSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident)
 WHERE subm_type_name = 'InformalEnforcementActionSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident + CONVERT(varchar(50), final_order_ident) + prmt_ident + CONVERT(varchar(50), cmpl_schd_num))
 WHERE subm_type_name = 'ComplianceScheduleSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident + milestone_type_code)
 WHERE subm_type_name = 'EnforcementActionMilestoneSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + CONVERT(varchar(50), mon_period_end_date) + param_code + mon_site_desc_code + CONVERT(varchar(50), lmt_season_num) + CONVERT(varchar(50), num_rep_code) + CONVERT(varchar(50), num_rep_viol_code))
 WHERE subm_type_name = 'DMRViolationSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + sngl_evt_viol_code + CONVERT(varchar(50), sngl_evt_viol_date))
 WHERE subm_type_name = 'SingleEventViolationSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), cso_evt_date) + CONVERT(varchar(50), evt_id))
 WHERE subm_type_name = 'CSOEventReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), date_strm_evt_smpl) + CONVERT(varchar(50), evt_id))
 WHERE subm_type_name = 'SWEventReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), prmt_auth_rep_rcvd_date))
 WHERE subm_type_name = 'CAFOAnnualReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), indst_sw_annul_rep_rcvd_date))
 WHERE subm_type_name = 'SWIndustrialAnnualReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), prmt_auth_rep_rcvd_date))
 WHERE subm_type_name = 'LocalLimitsProgramReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), pretr_perf_summ_end_date))
 WHERE subm_type_name = 'PretreatmentPerformanceSummarySubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), rep_coverage_end_date))
 WHERE subm_type_name = 'BiosolidsProgramReportSubmission'
   AND subm_transaction_id = @p_transaction_id;


UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), bs_annul_rep_rcvd_date))
 WHERE subm_type_name = 'BiosolidsAnnualProgramReportSubmission'
   AND subm_transaction_id = @p_transaction_id;
   
UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sso_annul_rep_rcvd_date))
 WHERE subm_type_name = 'SSOAnnualReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sso_evt_date) + CONVERT(varchar(50), evt_id))
 WHERE subm_type_name = 'SSOEventReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sso_monthly_rep_rcvd_date))
 WHERE subm_type_name = 'SSOMonthlyEventReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sw_ms_4_rep_rcvd_date))
 WHERE subm_type_name = 'SWMS4ProgramReportSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1',
   ISNULL(cmpl_mon_ident,'') 
   + ISNULL(prmt_ident_2,'') 
   + ISNULL(sngl_evt_viol_code,'') 
   + ISNULL(CONVERT(varchar(50), sngl_evt_viol_date),'') 
   + ISNULL(enfrc_actn_ident,'') 
   + ISNULL(CONVERT(varchar(50), rep_coverage_end_date),'') 
   + ISNULL(CONVERT(varchar(50), prmt_auth_rep_rcvd_date),'') 
   + ISNULL(CONVERT(varchar(50), cso_evt_date),'') 
   + ISNULL(CONVERT(varchar(50), pretr_perf_summ_end_date),'') 
   + ISNULL(CONVERT(varchar(50), sso_annul_rep_rcvd_date),'') 
   + ISNULL(CONVERT(varchar(50), sso_evt_date),'') 
   + ISNULL(CONVERT(varchar(50), sso_monthly_rep_rcvd_date),'') 
   + ISNULL(CONVERT(varchar(50), date_strm_evt_smpl),'') 
   + ISNULL(CONVERT(varchar(50), sw_ms_4_rep_rcvd_date),'') 
   + ISNULL(cmpl_mon_ident_2,'')
   + ISNULL(CONVERT(varchar(50), evt_id),'')
   )
WHERE subm_type_name = 'ComplianceMonitoringLinkageSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1',
     ISNULL(enfrc_actn_ident,'') 
     + ISNULL(prmt_ident,'') 
      + ISNULL(prmt_ident_2,'')   -- moved these toghether, since only one should be needed  
     + ISNULL(CONVERT(varchar(50), narr_cond_num),'') 
     + ISNULL(schd_evt_code,'') 
     + ISNULL(CONVERT(varchar(50), schd_date),'') 
     + ISNULL(enfrc_actn_ident_2,'') 
     + ISNULL(CONVERT(varchar(50), final_order_ident),'') 

     + ISNULL(CONVERT(varchar(50), cmpl_schd_num),'') 
     + ISNULL(prmt_featr_ident,'') 
     + ISNULL(lmt_set_designator,'') 
     + ISNULL(param_code,'') 
     + ISNULL(mon_site_desc_code,'') 
     + ISNULL(CONVERT(varchar(50), lmt_season_num),'') 
     + ISNULL(CONVERT(varchar(50), mon_period_end_date),'') 
     + ISNULL(sngl_evt_viol_code,'') 
     + ISNULL(CONVERT(varchar(50), sngl_evt_viol_date),'')
     )
WHERE subm_type_name = 'EnforcementActionViolationLinkageSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident
                                 + final_order_ident
                                 + ISNULL(prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), narr_cond_num),'')
                                 + ISNULL(schd_evt_code,'')
                                 + ISNULL(CONVERT(varchar(50), schd_date),'')
                                 + ISNULL(enfrc_actn_ident_2,'')
                                 + ISNULL(CONVERT(varchar(50), final_order_ident_2),'')
                                 + ISNULL(CONVERT(varchar(50), cmpl_schd_num),'')
                                 + ISNULL(prmt_featr_ident,'')
                                 + ISNULL(lmt_set_designator,'')
                                 + ISNULL(CONVERT(varchar(50), mon_period_end_date),'')
                                 + ISNULL(param_code,'')
                                 + ISNULL(mon_site_desc_code,'')
                                 + ISNULL(CONVERT(varchar(50), lmt_season_num),'')
                                 + ISNULL(sngl_evt_viol_code,'')
                                 + ISNULL(sngl_evt_viol_date,'')
                                 )
 WHERE subm_type_name = 'FinalOrderViolationLinkageSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1',
          ISNULL(prmt_ident,'') 
          + ISNULL(prmt_featr_ident,'') 
          + ISNULL(lmt_set_designator,'') 
          + ISNULL(CONVERT(varchar(50), mon_period_end_date),'') 
          + ISNULL(prmt_ident_2,'') 
          + ISNULL(CONVERT(varchar(50), rep_coverage_end_date),'') 
          + ISNULL(CONVERT(varchar(50), date_strm_evt_smpl),'') 
          + ISNULL(CONVERT(varchar(50), evt_id),'')
          )
   --SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + CONVERT(varchar(50), mon_period_end_date) + prmt_ident_2 + CONVERT(varchar(50), rep_coverage_end_date) + CONVERT(varchar(50), date_strm_evt_smpl) + CONVERT(varchar(50), evt_id))
 WHERE subm_type_name = 'DMRProgramReportLinkageSubmission'
   AND subm_transaction_id = @p_transaction_id;

UPDATE ics_subm_results
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ISNULL(prmt_ident,'') + ISNULL(prmt_featr_ident,'') + ISNULL(lmt_set_designator,'') + ISNULL(CONVERT(varchar(50), mon_period_end_date),'') + ISNULL(prmt_ident_2,'') + ISNULL(CONVERT(varchar(50), rep_coverage_end_date),'') + ISNULL(CONVERT(varchar(50), date_strm_evt_smpl),'') + ISNULL(CONVERT(varchar(50), evt_id),''))
   --SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + CONVERT(varchar(50), mon_period_end_date) + prmt_ident_2 + CONVERT(varchar(50), rep_coverage_end_date) + CONVERT(varchar(50), date_strm_evt_smpl) + CONVERT(varchar(50), evt_id))
 WHERE subm_type_name = 'DMRProgramReportLinkageSubmission'
   AND subm_transaction_id = @p_transaction_id;

--Delete errors from previous submissions where here is an error for the same key in the current submission
    DELETE 
      FROM ics_subm_results 
     WHERE result_type_code IN ('Error','Warning')
       AND key_hash IN (SELECT key_hash 
                          FROM ics_subm_results 
                         WHERE subm_transaction_id = @p_transaction_id
                           AND result_type_code IN ('Error','Warning'))
       AND subm_transaction_id <> @p_transaction_id;

 /*
  *  Step 3: Move accepted transactions from LOCAL to ICIS database
  *          FOR EACH PAYLOAD TYPE:
  *          1.  First prune data from the ICS_FLOW_ICIS schema to make room for new data coming across
  *              - Delete for basic permit, general permit, permitted feature, limit set, parameter limit, and limit data
  *                for permits that have been reissued.
  *              - Delete all data for permit that has been terminated 
  *          2.  Second copy accepted data from ICS_FLOW_LOCAL into ICS_FLOW_ICIS.
  */
  
-- Remove any old records for ics_basic_prmt
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_FAC_CLASS
DELETE
  FROM ics_flow_icis.dbo.ics_fac_class
 WHERE ics_fac_class.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_GEO_COORD
DELETE
  FROM ics_flow_icis.dbo.ics_geo_coord
 WHERE ics_geo_coord.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ORIG_PROGS
DELETE
  FROM ics_flow_icis.dbo.ics_orig_progs
 WHERE ics_orig_progs.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_PLCY
DELETE
  FROM ics_flow_icis.dbo.ics_plcy
 WHERE ics_plcy.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_ASSC_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_assc_prmt
 WHERE ics_assc_prmt.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_CMPL_TRACK_STAT
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_track_stat
 WHERE ics_cmpl_track_stat.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_EFFLU_GUIDE
DELETE
  FROM ics_flow_icis.dbo.ics_efflu_guide
 WHERE ics_efflu_guide.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_FAC
DELETE
  FROM ics_flow_icis.dbo.ics_fac
 WHERE ics_fac.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_OTHR_PRMTS
DELETE
  FROM ics_flow_icis.dbo.ics_othr_prmts
 WHERE ics_othr_prmts.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
--  5.6
-- /ICS_BASIC_PRMT/ICS_REP_NON_CMPL_STAT
DELETE
  FROM ics_flow_icis.dbo.ics_rep_non_cmpl_stat
 WHERE ics_rep_non_cmpl_stat.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- 5.8
-- /ICS_BASIC_PRMT/ICS_NPDES_DAT_GRP_NUM
DELETE FROM ics_flow_icis.dbo.ics_npdes_dat_grp_num
 WHERE ics_npdes_dat_grp_num.ics_npdes_dat_grp_num_id IN 
(
SELECT ics_npdes_dat_grp_num_id 
 from ICS_BASIC_PRMT 
 JOIN ICS_NPDES_DAT_GRP_NUM
 ON ICS_NPDES_DAT_GRP_NUM.ICS_BASIC_PRMT_ID = ICS_BASIC_PRMT.ICS_BASIC_PRMT_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_BASIC_PRMT.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_BASIC_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_basic_prmt
 WHERE ics_basic_prmt.ics_basic_prmt_id IN
          (SELECT ics_basic_prmt.ics_basic_prmt_id
             FROM ics_flow_icis.dbo.ics_basic_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_basic_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BasicPermitSubmission')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_basic_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);

-- Add accepted records for ics_basic_prmt
-- /ICS_BASIC_PRMT
INSERT INTO ics_flow_icis.dbo.ics_basic_prmt
     SELECT ics_basic_prmt.*
       FROM ics_basic_prmt
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');
--  5.6
-- /ICS_BASIC_PRMT/ICS_REP_NON_CMPL_STAT
INSERT INTO ics_flow_icis.dbo.ics_rep_non_cmpl_stat
     SELECT ics_rep_non_cmpl_stat.*
       FROM ics_rep_non_cmpl_stat
          JOIN ics_basic_prmt
            ON ics_rep_non_cmpl_stat.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');
-- 5.8
-- /ICS_BASIC_PRMT/ICS_NPDES_DAT_GRP_NUM
INSERT INTO ics_flow_icis.dbo.ics_npdes_dat_grp_num
 SELECT ics_npdes_dat_grp_num.* 
 from ICS_BASIC_PRMT 
 JOIN ICS_NPDES_DAT_GRP_NUM
 ON ICS_NPDES_DAT_GRP_NUM.ICS_BASIC_PRMT_ID = ICS_BASIC_PRMT.ICS_BASIC_PRMT_ID 
  WHERE ics_basic_prmt.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BasicPermitSubmission'));                  

-- /ICS_BASIC_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_basic_prmt
            ON ics_addr.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_basic_prmt
            ON ics_addr.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_ASSC_PRMT
INSERT INTO ics_flow_icis.dbo.ics_assc_prmt
     SELECT ics_assc_prmt.*
       FROM ics_assc_prmt
          JOIN ics_basic_prmt
            ON ics_assc_prmt.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_CMPL_TRACK_STAT
INSERT INTO ics_flow_icis.dbo.ics_cmpl_track_stat
     SELECT ics_cmpl_track_stat.*
       FROM ics_cmpl_track_stat
          JOIN ics_basic_prmt
            ON ics_cmpl_track_stat.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_basic_prmt
            ON ics_contact.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_basic_prmt
            ON ics_contact.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_EFFLU_GUIDE
INSERT INTO ics_flow_icis.dbo.ics_efflu_guide
     SELECT ics_efflu_guide.*
       FROM ics_efflu_guide
          JOIN ics_basic_prmt
            ON ics_efflu_guide.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC
INSERT INTO ics_flow_icis.dbo.ics_fac
     SELECT ics_fac.*
       FROM ics_fac
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_fac
            ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_fac
            ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_fac
            ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_fac
            ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_FAC_CLASS
INSERT INTO ics_flow_icis.dbo.ics_fac_class
     SELECT ics_fac_class.*
       FROM ics_fac_class
          JOIN ics_fac
            ON ics_fac_class.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_GEO_COORD
INSERT INTO ics_flow_icis.dbo.ics_geo_coord
     SELECT ics_geo_coord.*
       FROM ics_geo_coord
          JOIN ics_fac
            ON ics_geo_coord.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_fac
            ON ics_naics_code.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_ORIG_PROGS
INSERT INTO ics_flow_icis.dbo.ics_orig_progs
     SELECT ics_orig_progs.*
       FROM ics_orig_progs
          JOIN ics_fac
            ON ics_orig_progs.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_PLCY
INSERT INTO ics_flow_icis.dbo.ics_plcy
     SELECT ics_plcy.*
       FROM ics_plcy
          JOIN ics_fac
            ON ics_plcy.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_FAC/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_fac
            ON ics_sic_code.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_basic_prmt
            ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_basic_prmt
            ON ics_naics_code.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_OTHR_PRMTS
INSERT INTO ics_flow_icis.dbo.ics_othr_prmts
     SELECT ics_othr_prmts.*
       FROM ics_othr_prmts
          JOIN ics_basic_prmt
            ON ics_othr_prmts.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');

-- /ICS_BASIC_PRMT/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_basic_prmt
            ON ics_sic_code.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
       WHERE ics_basic_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BasicPermitSubmission');


-- Remove any old records for ics_bs_prmt
-- /ICS_BS_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_bs_prmt_id IN
          (SELECT ics_bs_prmt.ics_bs_prmt_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT/ICS_BS_END_USE_DSPL_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_bs_end_use_dspl_type
 WHERE ics_bs_end_use_dspl_type.ics_bs_prmt_id IN
          (SELECT ics_bs_prmt.ics_bs_prmt_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT/ICS_BS_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_bs_type
 WHERE ics_bs_type.ics_bs_prmt_id IN
          (SELECT ics_bs_prmt.ics_bs_prmt_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_bs_prmt_id IN
          (SELECT ics_bs_prmt.ics_bs_prmt_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );
-- /ICS_BS_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_bs_prmt
 WHERE ics_bs_prmt.ics_bs_prmt_id IN
          (SELECT ics_bs_prmt.ics_bs_prmt_id
             FROM ics_flow_icis.dbo.ics_bs_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsPermitSubmission')
               OR ics_bs_prmt.prmt_ident IN (SELECT prmt_ident 
                                               FROM ics_subm_results 
                                              WHERE result_type_code = 'Accepted'
                                                AND (subm_type_name = 'PermitTerminationSubmission'
                                                    OR 
                                                    (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                    )
                                             )
        );

-- Add accepted records for ics_bs_prmt
-- /ICS_BS_PRMT
INSERT INTO ics_flow_icis.dbo.ics_bs_prmt
     SELECT ics_bs_prmt.*
       FROM ics_bs_prmt
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_bs_prmt
            ON ics_addr.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_bs_prmt
            ON ics_addr.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_BS_END_USE_DSPL_TYPE
INSERT INTO ics_flow_icis.dbo.ics_bs_end_use_dspl_type
     SELECT ics_bs_end_use_dspl_type.*
       FROM ics_bs_end_use_dspl_type
          JOIN ics_bs_prmt
            ON ics_bs_end_use_dspl_type.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_BS_TYPE
INSERT INTO ics_flow_icis.dbo.ics_bs_type
     SELECT ics_bs_type.*
       FROM ics_bs_type
          JOIN ics_bs_prmt
            ON ics_bs_type.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_bs_prmt
            ON ics_contact.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');

-- /ICS_BS_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_bs_prmt
            ON ics_contact.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
       WHERE ics_bs_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsPermitSubmission');


-- Remove any old records for ics_cafo_prmt
-- /ICS_CAFO_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_ANML_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_anml_type
 WHERE ics_anml_type.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_CONTAINMENT
DELETE
  FROM ics_flow_icis.dbo.ics_containment
 WHERE ics_containment.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_LAND_APPL_BMP
DELETE
  FROM ics_flow_icis.dbo.ics_land_appl_bmp
 WHERE ics_land_appl_bmp.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT/ICS_MNUR_LTTR_PRCSS_WW_STOR
DELETE
  FROM ics_flow_icis.dbo.ics_mnur_lttr_prcss_ww_stor
 WHERE ics_mnur_lttr_prcss_ww_stor.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CAFO_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_cafo_prmt
 WHERE ics_cafo_prmt.ics_cafo_prmt_id IN
          (SELECT ics_cafo_prmt.ics_cafo_prmt_id
             FROM ics_flow_icis.dbo.ics_cafo_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOPermitSubmission')
               OR ics_cafo_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_cafo_prmt
-- /ICS_CAFO_PRMT
INSERT INTO ics_flow_icis.dbo.ics_cafo_prmt
     SELECT ics_cafo_prmt.*
       FROM ics_cafo_prmt
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_cafo_prmt
            ON ics_addr.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_cafo_prmt
            ON ics_addr.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_ANML_TYPE
INSERT INTO ics_flow_icis.dbo.ics_anml_type
     SELECT ics_anml_type.*
       FROM ics_anml_type
          JOIN ics_cafo_prmt
            ON ics_anml_type.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_cafo_prmt
            ON ics_contact.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_cafo_prmt
            ON ics_contact.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_CONTAINMENT
INSERT INTO ics_flow_icis.dbo.ics_containment
     SELECT ics_containment.*
       FROM ics_containment
          JOIN ics_cafo_prmt
            ON ics_containment.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_LAND_APPL_BMP
INSERT INTO ics_flow_icis.dbo.ics_land_appl_bmp
     SELECT ics_land_appl_bmp.*
       FROM ics_land_appl_bmp
          JOIN ics_cafo_prmt
            ON ics_land_appl_bmp.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');

-- /ICS_CAFO_PRMT/ICS_MNUR_LTTR_PRCSS_WW_STOR
INSERT INTO ics_flow_icis.dbo.ics_mnur_lttr_prcss_ww_stor
     SELECT ics_mnur_lttr_prcss_ww_stor.*
       FROM ics_mnur_lttr_prcss_ww_stor
          JOIN ics_cafo_prmt
            ON ics_mnur_lttr_prcss_ww_stor.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
       WHERE ics_cafo_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOPermitSubmission');


-- Remove any old records for ics_cso_prmt
-- /ICS_CSO_PRMT/ICS_SATL_COLL_SYSTM
DELETE
  FROM ics_flow_icis.dbo.ics_satl_coll_systm
 WHERE ics_satl_coll_systm.ics_cso_prmt_id IN
          (SELECT ics_cso_prmt.ics_cso_prmt_id
             FROM ics_flow_icis.dbo.ics_cso_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cso_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CSOPermitSubmission')
               OR ics_cso_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_CSO_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_cso_prmt
 WHERE ics_cso_prmt.ics_cso_prmt_id IN
          (SELECT ics_cso_prmt.ics_cso_prmt_id
             FROM ics_flow_icis.dbo.ics_cso_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cso_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CSOPermitSubmission')
               OR ics_cso_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_cso_prmt
-- /ICS_CSO_PRMT
INSERT INTO ics_flow_icis.dbo.ics_cso_prmt
     SELECT ics_cso_prmt.*
       FROM ics_cso_prmt
       WHERE ics_cso_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CSOPermitSubmission');

-- /ICS_CSO_PRMT/ICS_SATL_COLL_SYSTM
INSERT INTO ics_flow_icis.dbo.ics_satl_coll_systm
     SELECT ics_satl_coll_systm.*
       FROM ics_satl_coll_systm
          JOIN ics_cso_prmt
            ON ics_satl_coll_systm.ics_cso_prmt_id = ics_cso_prmt.ics_cso_prmt_id
       WHERE ics_cso_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CSOPermitSubmission');


-- Remove any old records for ics_gnrl_prmt
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_FAC_CLASS
DELETE
  FROM ics_flow_icis.dbo.ics_fac_class
 WHERE ics_fac_class.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_GEO_COORD
DELETE
  FROM ics_flow_icis.dbo.ics_geo_coord
 WHERE ics_geo_coord.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ORIG_PROGS
DELETE
  FROM ics_flow_icis.dbo.ics_orig_progs
 WHERE ics_orig_progs.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_PLCY
DELETE
  FROM ics_flow_icis.dbo.ics_plcy
 WHERE ics_plcy.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_fac_id IN
          (SELECT ics_fac.ics_fac_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_fac ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_ASSC_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_assc_prmt
 WHERE ics_assc_prmt.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_CMPL_TRACK_STAT
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_track_stat
 WHERE ics_cmpl_track_stat.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_EFFLU_GUIDE
DELETE
  FROM ics_flow_icis.dbo.ics_efflu_guide
 WHERE ics_efflu_guide.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_FAC
DELETE
  FROM ics_flow_icis.dbo.ics_fac
 WHERE ics_fac.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_OTHR_PRMTS
DELETE
  FROM ics_flow_icis.dbo.ics_othr_prmts
 WHERE ics_othr_prmts.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
-- /ICS_GNRL_PRMT/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);
--  5.6
-- /ICS_GNRL_PRMT/ICS_REP_NON_CMPL_STAT
DELETE
  FROM ics_flow_icis.dbo.ics_rep_non_cmpl_stat
 WHERE ics_rep_non_cmpl_stat.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);

-- /ICS_GNRL_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_gnrl_prmt
 WHERE ics_gnrl_prmt.ics_gnrl_prmt_id IN
          (SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'GeneralPermitSubmission')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
                 OR ics_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitReissuanceSubmission' AND result_code = 'REI030')
);

-- Add accepted records for ics_gnrl_prmt
-- /ICS_GNRL_PRMT
INSERT INTO ics_flow_icis.dbo.ics_gnrl_prmt
     SELECT ics_gnrl_prmt.*
       FROM ics_gnrl_prmt
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_REP_NON_CMPL_STAT
INSERT INTO ics_flow_icis.dbo.ics_rep_non_cmpl_stat
     SELECT ics_rep_non_cmpl_stat.*
       FROM ics_rep_non_cmpl_stat
          JOIN ics_gnrl_prmt
            ON ics_rep_non_cmpl_stat.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_gnrl_prmt
            ON ics_addr.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_gnrl_prmt
            ON ics_addr.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_ASSC_PRMT
INSERT INTO ics_flow_icis.dbo.ics_assc_prmt
     SELECT ics_assc_prmt.*
       FROM ics_assc_prmt
          JOIN ics_gnrl_prmt
            ON ics_assc_prmt.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_CMPL_TRACK_STAT
INSERT INTO ics_flow_icis.dbo.ics_cmpl_track_stat
     SELECT ics_cmpl_track_stat.*
       FROM ics_cmpl_track_stat
          JOIN ics_gnrl_prmt
            ON ics_cmpl_track_stat.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_gnrl_prmt
            ON ics_contact.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_gnrl_prmt
            ON ics_contact.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_EFFLU_GUIDE
INSERT INTO ics_flow_icis.dbo.ics_efflu_guide
     SELECT ics_efflu_guide.*
       FROM ics_efflu_guide
          JOIN ics_gnrl_prmt
            ON ics_efflu_guide.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC
INSERT INTO ics_flow_icis.dbo.ics_fac
     SELECT ics_fac.*
       FROM ics_fac
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_fac
            ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_fac
            ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_fac
            ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_fac
            ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_FAC_CLASS
INSERT INTO ics_flow_icis.dbo.ics_fac_class
     SELECT ics_fac_class.*
       FROM ics_fac_class
          JOIN ics_fac
            ON ics_fac_class.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_GEO_COORD
INSERT INTO ics_flow_icis.dbo.ics_geo_coord
     SELECT ics_geo_coord.*
       FROM ics_geo_coord
          JOIN ics_fac
            ON ics_geo_coord.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_fac
            ON ics_naics_code.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_ORIG_PROGS
INSERT INTO ics_flow_icis.dbo.ics_orig_progs
     SELECT ics_orig_progs.*
       FROM ics_orig_progs
          JOIN ics_fac
            ON ics_orig_progs.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_PLCY
INSERT INTO ics_flow_icis.dbo.ics_plcy
     SELECT ics_plcy.*
       FROM ics_plcy
          JOIN ics_fac
            ON ics_plcy.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_FAC/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_fac
            ON ics_sic_code.ics_fac_id = ics_fac.ics_fac_id
          JOIN ics_gnrl_prmt
            ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_gnrl_prmt
            ON ics_naics_code.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_OTHR_PRMTS
INSERT INTO ics_flow_icis.dbo.ics_othr_prmts
     SELECT ics_othr_prmts.*
       FROM ics_othr_prmts
          JOIN ics_gnrl_prmt
            ON ics_othr_prmts.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');

-- /ICS_GNRL_PRMT/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_gnrl_prmt
            ON ics_sic_code.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
       WHERE ics_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'GeneralPermitSubmission');


-- Remove any old records for ics_master_gnrl_prmt
-- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_ASSC_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_assc_prmt
 WHERE ics_assc_prmt.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_OTHR_PRMTS
DELETE
  FROM ics_flow_icis.dbo.ics_othr_prmts
 WHERE ics_othr_prmts.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_PRMT_COMP_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_comp_type
 WHERE ics_prmt_comp_type.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_MASTER_GNRL_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
 WHERE ics_master_gnrl_prmt.ics_master_gnrl_prmt_id IN
          (SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             FROM ics_flow_icis.dbo.ics_master_gnrl_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_master_gnrl_prmt.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'MasterGeneralPermitSubmission')
                 OR ics_master_gnrl_prmt.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_master_gnrl_prmt
-- /ICS_MASTER_GNRL_PRMT
INSERT INTO ics_flow_icis.dbo.ics_master_gnrl_prmt
     SELECT ics_master_gnrl_prmt.*
       FROM ics_master_gnrl_prmt
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_ASSC_PRMT
INSERT INTO ics_flow_icis.dbo.ics_assc_prmt
     SELECT ics_assc_prmt.*
       FROM ics_assc_prmt
          JOIN ics_master_gnrl_prmt
            ON ics_assc_prmt.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_master_gnrl_prmt
            ON ics_contact.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_master_gnrl_prmt
            ON ics_contact.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_master_gnrl_prmt
            ON ics_naics_code.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_OTHR_PRMTS
INSERT INTO ics_flow_icis.dbo.ics_othr_prmts
     SELECT ics_othr_prmts.*
       FROM ics_othr_prmts
          JOIN ics_master_gnrl_prmt
            ON ics_othr_prmts.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_PRMT_COMP_TYPE
INSERT INTO ics_flow_icis.dbo.ics_prmt_comp_type
     SELECT ics_prmt_comp_type.*
       FROM ics_prmt_comp_type
          JOIN ics_master_gnrl_prmt
            ON ics_prmt_comp_type.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');

-- /ICS_MASTER_GNRL_PRMT/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_master_gnrl_prmt
            ON ics_sic_code.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
       WHERE ics_master_gnrl_prmt.transaction_type != 'D'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'MasterGeneralPermitSubmission');


-- Remove any old records for ics_prmt_reissu
-- /ICS_PRMT_REISSU
DELETE 
  FROM ics_flow_icis.dbo.ics_prmt_reissu 
 WHERE prmt_ident IN (SELECT prmt_ident 
                        FROM ics_subm_results 
                       WHERE result_type_code = 'Accepted'
                         AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                              OR
                             (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission','MasterGeneralPermitSubmission') AND transaction_type = 'D'))
                      );

-- Add accepted records for ics_prmt_reissu
-- /ICS_PRMT_REISSU
INSERT INTO ics_flow_icis.dbo.ics_prmt_reissu
     SELECT ics_prmt_reissu.*
       FROM ics_prmt_reissu
      WHERE key_hash IN (SELECT key_hash
				           FROM ics_subm_results
                          WHERE result_type_code IN ('Accepted','Warning')
                            AND subm_type_name = 'PermitReissuanceSubmission');


-- Remove any old records for ics_prmt_term
-- /ICS_PRMT_TERM
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_term
 WHERE ics_prmt_term.ics_prmt_term_id IN
          (SELECT ics_prmt_term.ics_prmt_term_id
             FROM ics_flow_icis.dbo.ics_prmt_term
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_term.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermitTerminationSubmission')
                 OR ics_prmt_term.prmt_ident IN (SELECT prmt_ident 
                                                   FROM ics_subm_results 
                                                 WHERE subm_type_name = 'PermitTerminationSubmission' 
                                                   AND (result_type_code = 'Accepted'
                                                        OR result_code = 'TRM040'
                                                        OR (result_code = 'REI040' AND UPPER(result_desc) LIKE '%TERMINATED%')
                                                        )
                                                )
           );

-- Add accepted records for ics_prmt_term or if permit is already terminated in ICIS (REI040)
-- /ICS_PRMT_TERM
INSERT INTO ics_flow_icis.dbo.ics_prmt_term
     SELECT ics_prmt_term.*
       FROM ics_prmt_term
       WHERE ics_prmt_term.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE subm_type_name = 'PermitTerminationSubmission' 
                  AND (result_type_code = 'Accepted'
                       OR result_code = 'TRM040'
                       OR (result_code = 'REI040' AND UPPER(result_desc) LIKE '%TERMINATED%')
                       )
              );


-- Remove any old records for ics_prmt_track_evt
-- /ICS_PRMT_TRACK_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_track_evt
 WHERE ics_prmt_track_evt.ics_prmt_track_evt_id IN
          (SELECT ics_prmt_track_evt.ics_prmt_track_evt_id
             FROM ics_flow_icis.dbo.ics_prmt_track_evt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_track_evt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermitTrackingEventSubmission')
               OR ics_prmt_track_evt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_prmt_track_evt
-- /ICS_PRMT_TRACK_EVT
INSERT INTO ics_flow_icis.dbo.ics_prmt_track_evt
     SELECT ics_prmt_track_evt.*
       FROM ics_prmt_track_evt
       WHERE ics_prmt_track_evt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermitTrackingEventSubmission');


-- Remove any old records for ics_potw_prmt
-- /ICS_POTW_PRMT/ICS_SATL_COLL_SYSTM
DELETE
  FROM ics_flow_icis.dbo.ics_satl_coll_systm
 WHERE ics_satl_coll_systm.ics_potw_prmt_id IN
          (SELECT ics_potw_prmt.ics_potw_prmt_id
             FROM ics_flow_icis.dbo.ics_potw_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_potw_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'POTWPermitSubmission')
               OR ics_potw_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_POTW_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_potw_prmt
 WHERE ics_potw_prmt.ics_potw_prmt_id IN
          (SELECT ics_potw_prmt.ics_potw_prmt_id
             FROM ics_flow_icis.dbo.ics_potw_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_potw_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'POTWPermitSubmission')
               OR ics_potw_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_potw_prmt
-- /ICS_POTW_PRMT
INSERT INTO ics_flow_icis.dbo.ics_potw_prmt
     SELECT ics_potw_prmt.*
       FROM ics_potw_prmt
       WHERE ics_potw_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'POTWPermitSubmission');

-- /ICS_POTW_PRMT/ICS_SATL_COLL_SYSTM
INSERT INTO ics_flow_icis.dbo.ics_satl_coll_systm
     SELECT ics_satl_coll_systm.*
       FROM ics_satl_coll_systm
          JOIN ics_potw_prmt
            ON ics_satl_coll_systm.ics_potw_prmt_id = ics_potw_prmt.ics_potw_prmt_id
       WHERE ics_potw_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'POTWPermitSubmission');


-- Remove any old records for ics_pretr_prmt
-- /ICS_PRETR_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_pretr_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPermitSubmission')
               OR ics_pretr_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRETR_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_pretr_prmt_id IN
          (SELECT ics_pretr_prmt.ics_pretr_prmt_id
             FROM ics_flow_icis.dbo.ics_pretr_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPermitSubmission')
               OR ics_pretr_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRETR_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_pretr_prmt
 WHERE ics_pretr_prmt.ics_pretr_prmt_id IN
          (SELECT ics_pretr_prmt.ics_pretr_prmt_id
             FROM ics_flow_icis.dbo.ics_pretr_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPermitSubmission')
               OR ics_pretr_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_pretr_prmt
-- /ICS_PRETR_PRMT
INSERT INTO ics_flow_icis.dbo.ics_pretr_prmt
     SELECT ics_pretr_prmt.*
       FROM ics_pretr_prmt
       WHERE ics_pretr_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPermitSubmission');

-- /ICS_PRETR_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_pretr_prmt
            ON ics_contact.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
       WHERE ics_pretr_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPermitSubmission');

-- /ICS_PRETR_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_pretr_prmt
            ON ics_contact.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
       WHERE ics_pretr_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPermitSubmission');


-- Remove any old records for ics_sw_cnst_prmt
-- /ICS_SW_CNST_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_sw_cnst_prmt_id IN
          (SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_sw_cnst_prmt_id IN
          (SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_notice_of_intent
 WHERE ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id IN
          (SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
DELETE
  FROM ics_flow_icis.dbo.ics_subsctor_code_plus_desc
 WHERE ics_subsctor_code_plus_desc.ics_subsctor_code_plus_desc_id IN
          (SELECT ics_subsctor_code_plus_desc.ics_subsctor_code_plus_desc_id
             FROM ics_flow_icis.dbo.ics_subsctor_code_plus_desc

             JOIN ics_flow_icis.dbo.ics_gpcf_notice_of_intent
               ON ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id = ics_subsctor_code_plus_desc.ICS_GPCF_NOTICE_OF_INTENT_ID
            
             JOIN ics_flow_icis.dbo.ics_sw_cnst_prmt
               ON ics_sw_cnst_prmt.ics_sw_cnst_prmt_id = ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id
             
             LEFT JOIN ics_subm_results 
               ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code IN ('Accepted','Warning') 
              AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                    FROM ics_subm_results 
                                                   WHERE result_type_code = 'Accepted'
                                                     AND (subm_type_name = 'PermitTerminationSubmission'
                                                        OR 
                                                         (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                         )
                                                  )
          );
-- 5.8

-- /ICS_SW_CNST_PRMT/ICS_CNST_SITE
DELETE FROM ics_flow_icis.dbo.ics_cnst_site
 WHERE ics_cnst_site.ics_cnst_site_id IN 
(
SELECT ics_cnst_site_id 
 from ICS_SW_CNST_PRMT 
 JOIN ICS_CNST_SITE
 ON ICS_CNST_SITE.ICS_SW_CNST_PRMT_ID = ICS_SW_CNST_PRMT.ICS_SW_CNST_PRMT_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_SW_CNST_PRMT.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
);
-- 5.8
-- /ICS_SW_CNST_PRMT/ICS_TRTMNT_CHEMS_LIST
DELETE FROM ics_flow_icis.dbo.ics_trtmnt_chems_list
 WHERE ics_trtmnt_chems_list.ics_trtmnt_chems_list_id IN 
(
SELECT ics_trtmnt_chems_list_id 
 from ICS_SW_CNST_PRMT 
 JOIN ICS_TRTMNT_CHEMS_LIST
 ON ICS_TRTMNT_CHEMS_LIST.ICS_SW_CNST_PRMT_ID = ICS_SW_CNST_PRMT.ICS_SW_CNST_PRMT_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_SW_CNST_PRMT.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
);
          
-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_TERM
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_notice_of_term
 WHERE ics_gpcf_notice_of_term.ics_sw_cnst_prmt_id IN
          (SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_CNST_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
 WHERE ics_sw_cnst_prmt.ics_sw_cnst_prmt_id IN
          (SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_cnst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_cnst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_cnst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_sw_cnst_prmt
-- /ICS_SW_CNST_PRMT
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_prmt
     SELECT ics_sw_cnst_prmt.*
       FROM ics_sw_cnst_prmt
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_sw_cnst_prmt
            ON ics_addr.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_sw_cnst_prmt
            ON ics_addr.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_sw_cnst_prmt
            ON ics_contact.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_sw_cnst_prmt
            ON ics_contact.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
INSERT INTO ics_flow_icis.dbo.ics_gpcf_notice_of_intent
     SELECT ics_gpcf_notice_of_intent.*
       FROM ics_gpcf_notice_of_intent
          JOIN ics_sw_cnst_prmt
            ON ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
INSERT INTO ics_flow_icis.dbo.ics_subsctor_code_plus_desc
     SELECT ics_subsctor_code_plus_desc.*
       FROM ics_subsctor_code_plus_desc
       JOIN ics_gpcf_notice_of_intent
         ON ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id = ics_subsctor_code_plus_desc.ics_gpcf_notice_of_intent_id
          JOIN ics_sw_cnst_prmt
            ON ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN (SELECT ics_subm_results.key_hash
                           FROM ics_subm_results
                          WHERE result_type_code IN ('Accepted','Warning')
                            AND subm_type_name = 'SWIndustrialPermitSubmission');
-- 5.8

-- /ICS_SW_CNST_PRMT/ICS_CNST_SITE
INSERT INTO ics_flow_icis.dbo.ics_cnst_site
 SELECT ics_cnst_site.* 
 from ICS_SW_CNST_PRMT 
 JOIN ICS_CNST_SITE
 ON ICS_CNST_SITE.ICS_SW_CNST_PRMT_ID = ICS_SW_CNST_PRMT.ICS_SW_CNST_PRMT_ID 
  WHERE ics_sw_cnst_prmt.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'SWConstructionPermitSubmission'));
-- 5.8
-- /ICS_SW_CNST_PRMT/ICS_TRTMNT_CHEMS_LIST
INSERT INTO ics_flow_icis.dbo.ics_trtmnt_chems_list
 SELECT ics_trtmnt_chems_list.* 
 from ICS_SW_CNST_PRMT 
 JOIN ICS_TRTMNT_CHEMS_LIST
 ON ICS_TRTMNT_CHEMS_LIST.ICS_SW_CNST_PRMT_ID = ICS_SW_CNST_PRMT.ICS_SW_CNST_PRMT_ID 
  WHERE ics_sw_cnst_prmt.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'SWConstructionPermitSubmission'));
                            
-- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_TERM
INSERT INTO ics_flow_icis.dbo.ics_gpcf_notice_of_term
     SELECT ics_gpcf_notice_of_term.*
       FROM ics_gpcf_notice_of_term
          JOIN ics_sw_cnst_prmt
            ON ics_gpcf_notice_of_term.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
       WHERE ics_sw_cnst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWConstructionPermitSubmission');

-- Remove any old records for ics_sw_indst_prmt
-- /ICS_SW_INDST_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NO_EXPOSURE
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_no_exposure
 WHERE ics_gpcf_no_exposure.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_notice_of_intent
 WHERE ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
DELETE
  FROM ics_flow_icis.dbo.ics_subsctor_code_plus_desc
 WHERE ics_subsctor_code_plus_desc.ics_subsctor_code_plus_desc_id IN
          (SELECT ics_subsctor_code_plus_desc.ics_subsctor_code_plus_desc_id
             FROM ics_flow_icis.dbo.ics_subsctor_code_plus_desc
             JOIN ics_flow_icis.dbo.ics_gpcf_notice_of_intent
               ON ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id = ics_subsctor_code_plus_desc.ics_gpcf_notice_of_intent_id
             JOIN ics_flow_icis.dbo.ics_sw_indst_prmt
               ON ics_sw_indst_prmt.ics_sw_indst_prmt_id = ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id
             LEFT JOIN ics_subm_results 
               ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code IN ('Accepted','Warning') 
              AND subm_type_name = 'SWConstructionPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                    FROM ics_subm_results 
                                                   WHERE result_type_code = 'Accepted'
                                                     AND (subm_type_name = 'PermitTerminationSubmission'
                                                        OR 
                                                         (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                         )
                                                  )
          );
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_TERM
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_notice_of_term
 WHERE ics_gpcf_notice_of_term.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SW_INDST_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_sw_indst_prmt
 WHERE ics_sw_indst_prmt.ics_sw_indst_prmt_id IN
          (SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             FROM ics_flow_icis.dbo.ics_sw_indst_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialPermitSubmission')
               OR ics_sw_indst_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_sw_indst_prmt
-- /ICS_SW_INDST_PRMT
INSERT INTO ics_flow_icis.dbo.ics_sw_indst_prmt
     SELECT ics_sw_indst_prmt.*
       FROM ics_sw_indst_prmt
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_sw_indst_prmt
            ON ics_addr.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_sw_indst_prmt
            ON ics_addr.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_sw_indst_prmt
            ON ics_contact.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_sw_indst_prmt
            ON ics_contact.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_GPCF_NO_EXPOSURE
INSERT INTO ics_flow_icis.dbo.ics_gpcf_no_exposure
     SELECT ics_gpcf_no_exposure.*
       FROM ics_gpcf_no_exposure
          JOIN ics_sw_indst_prmt
            ON ics_gpcf_no_exposure.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');

-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
INSERT INTO ics_flow_icis.dbo.ics_gpcf_notice_of_intent
     SELECT ics_gpcf_notice_of_intent.*
       FROM ics_gpcf_notice_of_intent
          JOIN ics_sw_indst_prmt
            ON ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
INSERT INTO ics_flow_icis.dbo.ics_subsctor_code_plus_desc
     SELECT ics_subsctor_code_plus_desc.*
       FROM ics_subsctor_code_plus_desc
       JOIN ics_gpcf_notice_of_intent
         ON ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id = ics_subsctor_code_plus_desc.ics_gpcf_notice_of_intent_id
          JOIN ics_sw_indst_prmt
            ON ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN (SELECT ics_subm_results.key_hash
                           FROM ics_subm_results
                          WHERE result_type_code IN ('Accepted','Warning')
                            AND subm_type_name = 'SWIndustrialPermitSubmission');
-- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_TERM
INSERT INTO ics_flow_icis.dbo.ics_gpcf_notice_of_term
     SELECT ics_gpcf_notice_of_term.*
       FROM ics_gpcf_notice_of_term
          JOIN ics_sw_indst_prmt
            ON ics_gpcf_notice_of_term.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
       WHERE ics_sw_indst_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialPermitSubmission');
-- Remove any old records for ics_swms_4_large_prmt
-- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_large_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4LargePermitSubmission')
               OR ics_swms_4_large_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_large_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4LargePermitSubmission')
               OR ics_swms_4_large_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_swms_4_large_prmt_id IN
          (SELECT ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_large_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4LargePermitSubmission')
               OR ics_swms_4_large_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_swms_4_large_prmt_id IN
          (SELECT ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_large_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4LargePermitSubmission')
               OR ics_swms_4_large_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_LARGE_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
 WHERE ics_swms_4_large_prmt.ics_swms_4_large_prmt_id IN
          (SELECT ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_large_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_large_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4LargePermitSubmission')
               OR ics_swms_4_large_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_swms_4_large_prmt
-- /ICS_SWMS_4_LARGE_PRMT
INSERT INTO ics_flow_icis.dbo.ics_swms_4_large_prmt
     SELECT ics_swms_4_large_prmt.*
       FROM ics_swms_4_large_prmt
       WHERE ics_swms_4_large_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4LargePermitSubmission');

-- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_swms_4_large_prmt
            ON ics_addr.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
       WHERE ics_swms_4_large_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4LargePermitSubmission');

-- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_swms_4_large_prmt
            ON ics_addr.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
       WHERE ics_swms_4_large_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4LargePermitSubmission');

-- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_swms_4_large_prmt
            ON ics_contact.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
       WHERE ics_swms_4_large_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4LargePermitSubmission');

-- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_swms_4_large_prmt
            ON ics_contact.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
       WHERE ics_swms_4_large_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4LargePermitSubmission');


-- Remove any old records for ics_swms_4_small_prmt
-- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_swms_4_small_prmt_id IN
          (SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_swms_4_small_prmt_id IN
          (SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_SMALL_PRMT/ICS_GPCF_CNST_WAIVER
DELETE
  FROM ics_flow_icis.dbo.ics_gpcf_cnst_waiver
 WHERE ics_gpcf_cnst_waiver.ics_swms_4_small_prmt_id IN
          (SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_SWMS_4_SMALL_PRMT
DELETE
  FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
 WHERE ics_swms_4_small_prmt.ics_swms_4_small_prmt_id IN
          (SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             FROM ics_flow_icis.dbo.ics_swms_4_small_prmt
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_small_prmt.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4SmallPermitSubmission')
               OR ics_swms_4_small_prmt.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name = 'PermitTerminationSubmission'
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_swms_4_small_prmt
-- /ICS_SWMS_4_SMALL_PRMT
INSERT INTO ics_flow_icis.dbo.ics_swms_4_small_prmt
     SELECT ics_swms_4_small_prmt.*
       FROM ics_swms_4_small_prmt
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');

-- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_swms_4_small_prmt
            ON ics_addr.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');

-- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_swms_4_small_prmt
            ON ics_addr.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');

-- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_swms_4_small_prmt
            ON ics_contact.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');

-- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_swms_4_small_prmt
            ON ics_contact.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');

-- /ICS_SWMS_4_SMALL_PRMT/ICS_GPCF_CNST_WAIVER
INSERT INTO ics_flow_icis.dbo.ics_gpcf_cnst_waiver
     SELECT ics_gpcf_cnst_waiver.*
       FROM ics_gpcf_cnst_waiver
          JOIN ics_swms_4_small_prmt
            ON ics_gpcf_cnst_waiver.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
       WHERE ics_swms_4_small_prmt.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4SmallPermitSubmission');


-- Remove any old records for ics_unprmt_fac
-- /ICS_UNPRMT_FAC/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_FAC_CLASS
DELETE
  FROM ics_flow_icis.dbo.ics_fac_class
 WHERE ics_fac_class.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_GEO_COORD
DELETE
  FROM ics_flow_icis.dbo.ics_geo_coord
 WHERE ics_geo_coord.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_NAICS_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_naics_code
 WHERE ics_naics_code.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_ORIG_PROGS
DELETE
  FROM ics_flow_icis.dbo.ics_orig_progs
 WHERE ics_orig_progs.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_PLCY
DELETE
  FROM ics_flow_icis.dbo.ics_plcy
 WHERE ics_plcy.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC/ICS_SIC_CODE
DELETE
  FROM ics_flow_icis.dbo.ics_sic_code
 WHERE ics_sic_code.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- 5.6
-- /ICS_UNPRMT_FAC/ICS_PRMT_COMP_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_comp_type
 WHERE ics_prmt_comp_type.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_UNPRMT_FAC
DELETE
  FROM ics_flow_icis.dbo.ics_unprmt_fac
 WHERE ics_unprmt_fac.ics_unprmt_fac_id IN
          (SELECT ics_unprmt_fac.ics_unprmt_fac_id
             FROM ics_flow_icis.dbo.ics_unprmt_fac
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_unprmt_fac.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'UnpermittedFacilitySubmission')
                 OR ics_unprmt_fac.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_unprmt_fac
-- /ICS_UNPRMT_FAC
INSERT INTO ics_flow_icis.dbo.ics_unprmt_fac
     SELECT ics_unprmt_fac.*
       FROM ics_unprmt_fac
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_unprmt_fac
            ON ics_addr.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_unprmt_fac
            ON ics_addr.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_unprmt_fac
            ON ics_contact.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_unprmt_fac
            ON ics_contact.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_FAC_CLASS
INSERT INTO ics_flow_icis.dbo.ics_fac_class
     SELECT ics_fac_class.*
       FROM ics_fac_class
          JOIN ics_unprmt_fac
            ON ics_fac_class.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_GEO_COORD
INSERT INTO ics_flow_icis.dbo.ics_geo_coord
     SELECT ics_geo_coord.*
       FROM ics_geo_coord
          JOIN ics_unprmt_fac
            ON ics_geo_coord.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_NAICS_CODE
INSERT INTO ics_flow_icis.dbo.ics_naics_code
     SELECT ics_naics_code.*
       FROM ics_naics_code
          JOIN ics_unprmt_fac
            ON ics_naics_code.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_ORIG_PROGS
INSERT INTO ics_flow_icis.dbo.ics_orig_progs
     SELECT ics_orig_progs.*
       FROM ics_orig_progs
          JOIN ics_unprmt_fac
            ON ics_orig_progs.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_PLCY
INSERT INTO ics_flow_icis.dbo.ics_plcy
     SELECT ics_plcy.*
       FROM ics_plcy
          JOIN ics_unprmt_fac
            ON ics_plcy.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- /ICS_UNPRMT_FAC/ICS_SIC_CODE
INSERT INTO ics_flow_icis.dbo.ics_sic_code
     SELECT ics_sic_code.*
       FROM ics_sic_code
          JOIN ics_unprmt_fac
            ON ics_sic_code.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');

-- 5.6
-- /ICS_UNPRMT_FAC/ICS_PRMT_COMP_TYPE
INSERT INTO ics_flow_icis.dbo.ics_prmt_comp_type
     SELECT ics_prmt_comp_type.*
       FROM ics_prmt_comp_type
          JOIN ics_unprmt_fac
            ON ics_prmt_comp_type.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
       WHERE ics_unprmt_fac.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'UnpermittedFacilitySubmission');


-- Remove any old records for ics_hist_prmt_schd_evts
-- /ICS_HIST_PRMT_SCHD_EVTS
DELETE
  FROM ics_flow_icis.dbo.ics_hist_prmt_schd_evts
 WHERE ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id IN
          (SELECT ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id
             FROM ics_flow_icis.dbo.ics_hist_prmt_schd_evts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_hist_prmt_schd_evts.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'HistoricalPermitScheduleEventsSubmission')
                 OR ics_hist_prmt_schd_evts.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_hist_prmt_schd_evts
-- /ICS_HIST_PRMT_SCHD_EVTS
INSERT INTO ics_flow_icis.dbo.ics_hist_prmt_schd_evts
     SELECT ics_hist_prmt_schd_evts.*
       FROM ics_hist_prmt_schd_evts
      WHERE key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'HistoricalPermitScheduleEventsSubmission');


-- Remove any old records for ics_narr_cond_schd
-- /ICS_NARR_COND_SCHD/ICS_PRMT_SCHD_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_schd_evt
 WHERE ics_prmt_schd_evt.ics_narr_cond_schd_id IN
          (SELECT ics_narr_cond_schd.ics_narr_cond_schd_id
             FROM ics_flow_icis.dbo.ics_narr_cond_schd
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_narr_cond_schd.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'NarrativeConditionScheduleSubmission')
               OR ics_narr_cond_schd.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_NARR_COND_SCHD
DELETE
  FROM ics_flow_icis.dbo.ics_narr_cond_schd
 WHERE ics_narr_cond_schd.ics_narr_cond_schd_id IN
          (SELECT ics_narr_cond_schd.ics_narr_cond_schd_id
             FROM ics_flow_icis.dbo.ics_narr_cond_schd
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_narr_cond_schd.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'NarrativeConditionScheduleSubmission')
               OR ics_narr_cond_schd.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_narr_cond_schd
-- /ICS_NARR_COND_SCHD
INSERT INTO ics_flow_icis.dbo.ics_narr_cond_schd
     SELECT ics_narr_cond_schd.*
       FROM ics_narr_cond_schd
       WHERE ics_narr_cond_schd.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'NarrativeConditionScheduleSubmission');

-- /ICS_NARR_COND_SCHD/ICS_PRMT_SCHD_EVT
INSERT INTO ics_flow_icis.dbo.ics_prmt_schd_evt
     SELECT ics_prmt_schd_evt.*
       FROM ics_prmt_schd_evt
          JOIN ics_narr_cond_schd
            ON ics_prmt_schd_evt.ics_narr_cond_schd_id = ics_narr_cond_schd.ics_narr_cond_schd_id
       WHERE ics_narr_cond_schd.transaction_type != 'X'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'NarrativeConditionScheduleSubmission');


-- Remove any old records for ics_prmt_featr
-- /ICS_PRMT_FEATR/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR/ICS_GEO_COORD
DELETE
  FROM ics_flow_icis.dbo.ics_geo_coord
 WHERE ics_geo_coord.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
          
-- 5.8
-- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS/ICS_TMDL_POLUT
DELETE FROM ics_flow_icis.dbo.ics_tmdl_polut
 WHERE ics_tmdl_polut.ics_tmdl_polut_id IN 
(
SELECT ics_tmdl_polut_id 
 from ICS_PRMT_FEATR 
 JOIN ICS_TMDL_POLLUTANTS
 ON ICS_TMDL_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
 JOIN ICS_TMDL_POLUT
 ON ICS_TMDL_POLUT.ICS_TMDL_POLLUTANTS_ID = ICS_TMDL_POLLUTANTS.ICS_TMDL_POLLUTANTS_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_PRMT_FEATR.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
);
-- 5.8
-- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS
DELETE FROM ics_flow_icis.dbo.ics_tmdl_pollutants
 WHERE ics_tmdl_pollutants.ics_tmdl_pollutants_id IN 
(
SELECT ics_tmdl_pollutants_id 
 from ICS_PRMT_FEATR 
 JOIN ICS_TMDL_POLLUTANTS
 ON ICS_TMDL_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_PRMT_FEATR.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
);
-- 5.8
-- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS
DELETE FROM ics_flow_icis.dbo.ics_impaired_wtr_pollutants
 WHERE ics_impaired_wtr_pollutants.ics_impaired_wtr_pollutants_id IN 
(
SELECT ics_impaired_wtr_pollutants_id 
 from ICS_PRMT_FEATR 
 JOIN ICS_IMPAIRED_WTR_POLLUTANTS
 ON ICS_IMPAIRED_WTR_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ICS_PRMT_FEATR.key_hash 
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
);          
          
-- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_CHAR
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_featr_char
 WHERE ics_prmt_featr_char.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_TRTMNT_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_featr_trtmnt_type
 WHERE ics_prmt_featr_trtmnt_type.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_PRMT_FEATR
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_featr
 WHERE ics_prmt_featr.ics_prmt_featr_id IN
          (SELECT ics_prmt_featr.ics_prmt_featr_id
             FROM ics_flow_icis.dbo.ics_prmt_featr
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_prmt_featr.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PermittedFeatureSubmission')
               OR ics_prmt_featr.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_prmt_featr
-- /ICS_PRMT_FEATR
INSERT INTO ics_flow_icis.dbo.ics_prmt_featr
     SELECT ics_prmt_featr.*
       FROM ics_prmt_featr
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_prmt_featr
            ON ics_addr.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_prmt_featr
            ON ics_addr.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_prmt_featr
            ON ics_contact.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_prmt_featr
            ON ics_contact.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_GEO_COORD
INSERT INTO ics_flow_icis.dbo.ics_geo_coord
     SELECT ics_geo_coord.*
       FROM ics_geo_coord
          JOIN ics_prmt_featr
            ON ics_geo_coord.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_CHAR
INSERT INTO ics_flow_icis.dbo.ics_prmt_featr_char
     SELECT ics_prmt_featr_char.*
       FROM ics_prmt_featr_char
          JOIN ics_prmt_featr
            ON ics_prmt_featr_char.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');

-- 5.8
-- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS
INSERT INTO ics_flow_icis.dbo.ics_impaired_wtr_pollutants
 SELECT ics_impaired_wtr_pollutants.* 
 from ICS_PRMT_FEATR 
 JOIN ICS_IMPAIRED_WTR_POLLUTANTS
 ON ICS_IMPAIRED_WTR_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
  WHERE ics_prmt_featr.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'PermittedFeatureSubmission'));
-- 5.8
-- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS
INSERT INTO ics_flow_icis.dbo.ics_tmdl_pollutants
 SELECT ics_tmdl_pollutants.* 
 from ICS_PRMT_FEATR 
 JOIN ICS_TMDL_POLLUTANTS
 ON ICS_TMDL_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
  WHERE ics_prmt_featr.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'PermittedFeatureSubmission')); 
-- 5.8
-- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS/ICS_TMDL_POLUT
INSERT INTO ics_flow_icis.dbo.ics_tmdl_polut
 SELECT ics_tmdl_polut.* 
 from ICS_PRMT_FEATR 
 JOIN ICS_TMDL_POLLUTANTS
 ON ICS_TMDL_POLLUTANTS.ICS_PRMT_FEATR_ID = ICS_PRMT_FEATR.ICS_PRMT_FEATR_ID 
 JOIN ICS_TMDL_POLUT
 ON ICS_TMDL_POLUT.ICS_TMDL_POLLUTANTS_ID = ICS_TMDL_POLLUTANTS.ICS_TMDL_POLLUTANTS_ID 
  WHERE ics_prmt_featr.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'PermittedFeatureSubmission')); 
                  
-- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_TRTMNT_TYPE
INSERT INTO ics_flow_icis.dbo.ics_prmt_featr_trtmnt_type
     SELECT ics_prmt_featr_trtmnt_type.*
       FROM ics_prmt_featr_trtmnt_type
          JOIN ics_prmt_featr
            ON ics_prmt_featr_trtmnt_type.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
       WHERE ics_prmt_featr.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PermittedFeatureSubmission');


-- Remove any old records for ics_lmt_set
-- /ICS_LMT_SET/ICS_LMT_SET_MONTHS_APPL
DELETE
  FROM ics_flow_icis.dbo.ics_lmt_set_months_appl
 WHERE ics_lmt_set_months_appl.ics_lmt_set_id IN
          (SELECT ics_lmt_set.ics_lmt_set_id
             FROM ics_flow_icis.dbo.ics_lmt_set
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmt_set.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitSetSubmission')
               OR ics_lmt_set.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_LMT_SET/ICS_LMT_SET_SCHD
DELETE
  FROM ics_flow_icis.dbo.ics_lmt_set_schd
 WHERE ics_lmt_set_schd.ics_lmt_set_id IN
          (SELECT ics_lmt_set.ics_lmt_set_id
             FROM ics_flow_icis.dbo.ics_lmt_set
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmt_set.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitSetSubmission')
               OR ics_lmt_set.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_LMT_SET/ICS_LMT_SET_STAT
DELETE
  FROM ics_flow_icis.dbo.ics_lmt_set_stat
 WHERE ics_lmt_set_stat.ics_lmt_set_id IN
          (SELECT ics_lmt_set.ics_lmt_set_id
             FROM ics_flow_icis.dbo.ics_lmt_set
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmt_set.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitSetSubmission')
               OR ics_lmt_set.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_LMT_SET
DELETE
  FROM ics_flow_icis.dbo.ics_lmt_set
 WHERE ics_lmt_set.ics_lmt_set_id IN
          (SELECT ics_lmt_set.ics_lmt_set_id
             FROM ics_flow_icis.dbo.ics_lmt_set
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmt_set.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitSetSubmission')
               OR ics_lmt_set.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_lmt_set
-- /ICS_LMT_SET
INSERT INTO ics_flow_icis.dbo.ics_lmt_set
     SELECT ics_lmt_set.*
       FROM ics_lmt_set
       WHERE ics_lmt_set.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitSetSubmission');

-- /ICS_LMT_SET/ICS_LMT_SET_MONTHS_APPL
INSERT INTO ics_flow_icis.dbo.ics_lmt_set_months_appl
     SELECT ics_lmt_set_months_appl.*
       FROM ics_lmt_set_months_appl
          JOIN ics_lmt_set
            ON ics_lmt_set_months_appl.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
       WHERE ics_lmt_set.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitSetSubmission');

-- /ICS_LMT_SET/ICS_LMT_SET_SCHD
INSERT INTO ics_flow_icis.dbo.ics_lmt_set_schd
     SELECT ics_lmt_set_schd.*
       FROM ics_lmt_set_schd
          JOIN ics_lmt_set
            ON ics_lmt_set_schd.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
       WHERE ics_lmt_set.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitSetSubmission');

-- /ICS_LMT_SET/ICS_LMT_SET_STAT
INSERT INTO ics_flow_icis.dbo.ics_lmt_set_stat
     SELECT ics_lmt_set_stat.*
       FROM ics_lmt_set_stat
          JOIN ics_lmt_set
            ON ics_lmt_set_stat.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
       WHERE ics_lmt_set.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitSetSubmission');


-- Remove any old records for ics_lmts
-- /ICS_LMTS/ICS_MN_LMT_APPLIES
DELETE
  FROM ics_flow_icis.dbo.ics_mn_lmt_applies
 WHERE ics_mn_lmt_applies.ics_lmts_id IN
          (SELECT ics_lmts.ics_lmts_id
             FROM ics_flow_icis.dbo.ics_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmts.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitsSubmission')
               OR ics_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_LMTS/ICS_NUM_COND
DELETE
  FROM ics_flow_icis.dbo.ics_num_cond
 WHERE ics_num_cond.ics_lmts_id IN
          (SELECT ics_lmts.ics_lmts_id
             FROM ics_flow_icis.dbo.ics_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmts.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitsSubmission')
               OR ics_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );
-- /ICS_LMTS
DELETE
  FROM ics_flow_icis.dbo.ics_lmts
 WHERE ics_lmts.ics_lmts_id IN
          (SELECT ics_lmts.ics_lmts_id
             FROM ics_flow_icis.dbo.ics_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_lmts.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LimitsSubmission')
               OR ics_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
          );

-- Add accepted records for ics_lmts
-- /ICS_LMTS
INSERT INTO ics_flow_icis.dbo.ics_lmts
     SELECT ics_lmts.*
       FROM ics_lmts
       WHERE ics_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitsSubmission');

-- /ICS_LMTS/ICS_MN_LMT_APPLIES
INSERT INTO ics_flow_icis.dbo.ics_mn_lmt_applies
     SELECT ics_mn_lmt_applies.*
       FROM ics_mn_lmt_applies
          JOIN ics_lmts
            ON ics_mn_lmt_applies.ics_lmts_id = ics_lmts.ics_lmts_id
       WHERE ics_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitsSubmission');

-- /ICS_LMTS/ICS_NUM_COND
INSERT INTO ics_flow_icis.dbo.ics_num_cond
     SELECT ics_num_cond.*
       FROM ics_num_cond
          JOIN ics_lmts
            ON ics_num_cond.ics_lmts_id = ics_lmts.ics_lmts_id
       WHERE ics_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LimitsSubmission');


-- Remove any old records for ics_param_lmts
-- /ICS_PARAM_LMTS/ICS_LMT/ICS_MN_LMT_APPLIES
DELETE
  FROM ics_flow_icis.dbo.ics_mn_lmt_applies
 WHERE ics_mn_lmt_applies.ics_lmt_id IN
          (SELECT ics_lmt.ics_lmt_id
             FROM ics_flow_icis.dbo.ics_param_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_param_lmts.key_hash 
                  JOIN ics_flow_icis.dbo.ics_lmt ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ParameterLimitsSubmission')
               OR ics_param_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
               OR ics_param_lmts.key_hash IN (SELECT key_hash FROM ics_subm_results WHERE transaction_type='X' AND result_code = 'PLT070') --Limit doesn't exist in ICIS
          );
-- /ICS_PARAM_LMTS/ICS_LMT/ICS_NUM_COND
DELETE
  FROM ics_flow_icis.dbo.ics_num_cond
 WHERE ics_num_cond.ics_lmt_id IN
          (SELECT ics_lmt.ics_lmt_id
             FROM ics_flow_icis.dbo.ics_param_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_param_lmts.key_hash 
                  JOIN ics_flow_icis.dbo.ics_lmt ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ParameterLimitsSubmission')
               OR ics_param_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
               OR ics_param_lmts.key_hash IN (SELECT key_hash FROM ics_subm_results WHERE transaction_type='X' AND result_code = 'PLT070') --Limit doesn't exist in ICIS
          );
-- /ICS_PARAM_LMTS/ICS_LMT
DELETE
  FROM ics_flow_icis.dbo.ics_lmt
 WHERE ics_lmt.ics_param_lmts_id IN
          (SELECT ics_param_lmts.ics_param_lmts_id
             FROM ics_flow_icis.dbo.ics_param_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_param_lmts.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ParameterLimitsSubmission')
               OR ics_param_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
               OR ics_param_lmts.key_hash IN (SELECT key_hash FROM ics_subm_results WHERE transaction_type='X' AND result_code = 'PLT070') --Limit doesn't exist in ICIS
          );
-- /ICS_PARAM_LMTS
DELETE
  FROM ics_flow_icis.dbo.ics_param_lmts
 WHERE ics_param_lmts.ics_param_lmts_id IN
          (SELECT ics_param_lmts.ics_param_lmts_id
             FROM ics_flow_icis.dbo.ics_param_lmts
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_param_lmts.key_hash 
            WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ParameterLimitsSubmission')
               OR ics_param_lmts.prmt_ident IN (SELECT prmt_ident 
                                                 FROM ics_subm_results 
                                               WHERE result_type_code = 'Accepted'
                                                 AND (subm_type_name IN ('PermitTerminationSubmission','PermitReissuanceSubmission')
                                                     OR 
                                                     (subm_type_name IN ('BasicPermitSubmission','GeneralPermitSubmission') AND transaction_type = 'D')
                                                     )
                                              )
               OR ics_param_lmts.key_hash IN (SELECT key_hash FROM ics_subm_results WHERE transaction_type='X' AND result_code = 'PLT070') --Limit doesn't exist in ICIS
          );

-- Add accepted records for ics_param_lmts
-- /ICS_PARAM_LMTS
INSERT INTO ics_flow_icis.dbo.ics_param_lmts
     SELECT ics_param_lmts.*
       FROM ics_param_lmts
       WHERE ics_param_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ParameterLimitsSubmission');

-- /ICS_PARAM_LMTS/ICS_LMT
INSERT INTO ics_flow_icis.dbo.ics_lmt
     SELECT ics_lmt.*
       FROM ics_lmt
          JOIN ics_param_lmts
            ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
       WHERE ics_param_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ParameterLimitsSubmission');

-- /ICS_PARAM_LMTS/ICS_LMT/ICS_MN_LMT_APPLIES
INSERT INTO ics_flow_icis.dbo.ics_mn_lmt_applies
     SELECT ics_mn_lmt_applies.*
       FROM ics_mn_lmt_applies
          JOIN ics_lmt
            ON ics_mn_lmt_applies.ics_lmt_id = ics_lmt.ics_lmt_id
          JOIN ics_param_lmts
            ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
       WHERE ics_param_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ParameterLimitsSubmission');

-- /ICS_PARAM_LMTS/ICS_LMT/ICS_NUM_COND
INSERT INTO ics_flow_icis.dbo.ics_num_cond
     SELECT ics_num_cond.*
       FROM ics_num_cond
          JOIN ics_lmt
            ON ics_num_cond.ics_lmt_id = ics_lmt.ics_lmt_id
          JOIN ics_param_lmts
            ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
       WHERE ics_param_lmts.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ParameterLimitsSubmission');


-- Remove any old records for ics_dsch_mon_rep
-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_HARVESTED
DELETE
  FROM ics_flow_icis.dbo.ics_crop_types_harvested
 WHERE ics_crop_types_harvested.ics_land_appl_site_id IN
          (SELECT ics_land_appl_site.ics_land_appl_site_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_land_appl_site ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_PLANTED
DELETE
  FROM ics_flow_icis.dbo.ics_crop_types_planted
 WHERE ics_crop_types_planted.ics_land_appl_site_id IN
          (SELECT ics_land_appl_site.ics_land_appl_site_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_land_appl_site ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_REP_PARAM/ICS_NUM_REP
DELETE
  FROM ics_flow_icis.dbo.ics_num_rep
 WHERE ics_num_rep.ics_rep_param_id IN
          (SELECT ics_rep_param.ics_rep_param_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_rep_param ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_CO_DSPL_SITE
DELETE
  FROM ics_flow_icis.dbo.ics_co_dspl_site
 WHERE ics_co_dspl_site.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_INCIN
DELETE
  FROM ics_flow_icis.dbo.ics_incin
 WHERE ics_incin.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE
DELETE
  FROM ics_flow_icis.dbo.ics_land_appl_site
 WHERE ics_land_appl_site.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_REP_PARAM
DELETE
  FROM ics_flow_icis.dbo.ics_rep_param
 WHERE ics_rep_param.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP/ICS_SURF_DSPL_SITE
DELETE
  FROM ics_flow_icis.dbo.ics_surf_dspl_site
 WHERE ics_surf_dspl_site.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_DSCH_MON_REP
DELETE
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep
 WHERE ics_dsch_mon_rep.ics_dsch_mon_rep_id IN
          (SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             FROM ics_flow_icis.dbo.ics_dsch_mon_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dsch_mon_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DischargeMonitoringReportSubmission')
                 OR ics_dsch_mon_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- added 2/20/2013
-- Delete accepted DMRS for Parameter Limits that have been mass deleted
-- This way, if the same parameter key is readded later (with different start/end dates or limits), the flow knows to resend the DMR history
-- This is a typical scenario when ICIS Batch is returning an errors PLT210 (DMRs...will be orphaned) or PLT340 (Limit creates duplicate months across Limit Segments)
--   and the best course of action for the agency is to mass delete and recreate the limit.
DELETE 
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep
 WHERE EXISTS (SELECT 1
                 FROM ics_subm_results
				WHERE ics_subm_results.subm_type_name = 'ParameterLimitsSubmission'
				  AND ics_subm_results.result_type_code = 'Accepted'
				  AND ics_subm_results.transaction_type = 'X'
				  AND ics_subm_results.prmt_ident = ics_flow_icis.dbo.ics_dsch_mon_rep.prmt_ident
				  AND ics_subm_results.prmt_featr_ident = ics_flow_icis.dbo.ics_dsch_mon_rep.prmt_featr_ident
				  AND ics_subm_results.lmt_set_designator = ics_flow_icis.dbo.ics_dsch_mon_rep.lmt_set_designator)
 ;

-- Add accepted records for ics_dsch_mon_rep
-- /ICS_DSCH_MON_REP
INSERT INTO ics_flow_icis.dbo.ics_dsch_mon_rep
     SELECT ics_dsch_mon_rep.*
       FROM ics_dsch_mon_rep
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');


--Update the data_hash to 'PARTIAL' if there are one or more errors for the business key in the latest processing report.
--This will ensure that subsequent runs of change_detection will see the different data_hash between LOCAL and ICIS and flag the DMR for resending
UPDATE ics_flow_icis.dbo.ics_dsch_mon_rep
   SET data_hash = 'PARTIAL'
 WHERE key_hash IN (SELECT key_hash 
                      FROM ics_subm_results
                     WHERE subm_type_name = 'DischargeMonitoringReportSubmission'
                       AND result_type_code = 'Error'
                       AND subm_transaction_id = @p_transaction_id
                    );


-- /ICS_DSCH_MON_REP/ICS_CO_DSPL_SITE
INSERT INTO ics_flow_icis.dbo.ics_co_dspl_site
     SELECT ics_co_dspl_site.*
       FROM ics_co_dspl_site
          JOIN ics_dsch_mon_rep
            ON ics_co_dspl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- /ICS_DSCH_MON_REP/ICS_INCIN
INSERT INTO ics_flow_icis.dbo.ics_incin
     SELECT ics_incin.*
       FROM ics_incin
          JOIN ics_dsch_mon_rep
            ON ics_incin.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE
INSERT INTO ics_flow_icis.dbo.ics_land_appl_site
     SELECT ics_land_appl_site.*
       FROM ics_land_appl_site
          JOIN ics_dsch_mon_rep
            ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_HARVESTED
INSERT INTO ics_flow_icis.dbo.ics_crop_types_harvested
     SELECT ics_crop_types_harvested.*
       FROM ics_crop_types_harvested
          JOIN ics_land_appl_site
            ON ics_crop_types_harvested.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
          JOIN ics_dsch_mon_rep
            ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_PLANTED
INSERT INTO ics_flow_icis.dbo.ics_crop_types_planted
     SELECT ics_crop_types_planted.*
       FROM ics_crop_types_planted
          JOIN ics_land_appl_site
            ON ics_crop_types_planted.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
          JOIN ics_dsch_mon_rep
            ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- /ICS_DSCH_MON_REP/ICS_REP_PARAM
--Only insert parameters that were accepted
INSERT INTO ics_flow_icis.dbo.ics_rep_param
     SELECT DISTINCT ics_rep_param.*
       FROM ics_rep_param
          JOIN ics_dsch_mon_rep
            ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
		  JOIN ics_subm_results
		    ON ics_dsch_mon_rep.key_hash            = ics_subm_results.key_hash
		   AND ics_dsch_mon_rep.prmt_ident          = ics_subm_results.prmt_ident
		   AND ics_dsch_mon_rep.prmt_featr_ident    = ics_subm_results.prmt_featr_ident
		   AND ics_dsch_mon_rep.lmt_set_designator  = ics_subm_results.lmt_set_designator
		   AND ics_dsch_mon_rep.mon_period_end_date = ics_subm_results.mon_period_end_date
		   AND ics_rep_param.param_code             = ics_subm_results.param_code
		   AND ics_rep_param.mon_site_desc_code     = ics_rep_param.mon_site_desc_code
		   AND ics_rep_param.lmt_season_num         = ics_rep_param.lmt_season_num
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
	     AND subm_type_name = 'DischargeMonitoringReportSubmission'
		 AND result_type_code IN ('Accepted','Warning')
		 AND ics_subm_results.subm_transaction_id = @p_transaction_id;

-- /ICS_DSCH_MON_REP/ICS_REP_PARAM/ICS_NUM_REP
INSERT INTO ics_flow_icis.dbo.ics_num_rep
     SELECT DISTINCT ics_num_rep.*
       FROM ics_num_rep
          JOIN ics_rep_param
            ON ics_num_rep.ics_rep_param_id = ics_rep_param.ics_rep_param_id
          JOIN ics_dsch_mon_rep
            ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
		  JOIN ics_subm_results
		    ON ics_dsch_mon_rep.key_hash            = ics_subm_results.key_hash
		   AND ics_dsch_mon_rep.prmt_ident          = ics_subm_results.prmt_ident
		   AND ics_dsch_mon_rep.prmt_featr_ident    = ics_subm_results.prmt_featr_ident
		   AND ics_dsch_mon_rep.lmt_set_designator  = ics_subm_results.lmt_set_designator
		   AND ics_dsch_mon_rep.mon_period_end_date = ics_subm_results.mon_period_end_date
		   AND ics_rep_param.param_code             = ics_subm_results.param_code
		   AND ics_rep_param.mon_site_desc_code     = ics_rep_param.mon_site_desc_code
		   AND ics_rep_param.lmt_season_num         = ics_rep_param.lmt_season_num
       WHERE ics_dsch_mon_rep.transaction_type = 'R'
	     AND subm_type_name = 'DischargeMonitoringReportSubmission'
		 AND result_type_code IN ('Accepted','Warning')
		 AND ics_subm_results.subm_transaction_id = @p_transaction_id;

-- /ICS_DSCH_MON_REP/ICS_SURF_DSPL_SITE
INSERT INTO ics_flow_icis.dbo.ics_surf_dspl_site
     SELECT ics_surf_dspl_site.*
       FROM ics_surf_dspl_site
          JOIN ics_dsch_mon_rep
            ON ics_surf_dspl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
       WHERE ics_dsch_mon_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DischargeMonitoringReportSubmission');

-- Remove any old records for ics_bs_annul_prog_rep
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_ADDR/ICS_TELEPH
DELETE FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_teleph_id IN 
(
SELECT ics_teleph_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_ADDR
 ON ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ICS_TELEPH
 ON ICS_TELEPH.ICS_ADDR_ID = ICS_ADDR.ICS_ADDR_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_CONTACT/ICS_TELEPH
DELETE FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_teleph_id IN 
(
SELECT ics_teleph_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ICS_TELEPH
 ON ICS_TELEPH.ICS_CONTACT_ID = ICS_CONTACT.ICS_CONTACT_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_VECTOR_A_REDUCTION_TYPE
DELETE FROM ics_flow_icis.dbo.ics_vector_a_reduction_type
 WHERE ics_vector_a_reduction_type.ics_vector_a_reduction_type_id IN 
(
SELECT ics_vector_a_reduction_type_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_VECTOR_A_REDUCTION_TYPE
 ON ICS_VECTOR_A_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_PATHOGEN_REDUCTION_TYPE
DELETE FROM ics_flow_icis.dbo.ics_pathogen_reduction_type
 WHERE ics_pathogen_reduction_type.ics_pathogen_reduction_type_id IN 
(
SELECT ics_pathogen_reduction_type_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_PATHOGEN_REDUCTION_TYPE
 ON ICS_PATHOGEN_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_MGMT_PRC_DEFCY_TYPE
DELETE FROM ics_flow_icis.dbo.ics_mgmt_prc_defcy_type
 WHERE ics_mgmt_prc_defcy_type.ics_mgmt_prc_defcy_type_id IN 
(
SELECT ics_mgmt_prc_defcy_type_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_MGMT_PRC_DEFCY_TYPE
 ON ICS_MGMT_PRC_DEFCY_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_CONTACT
DELETE FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_contact_id IN 
(
SELECT ics_contact_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_ADDR
DELETE FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_addr_id IN 
(
SELECT ics_addr_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_ADDR
 ON ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_CONTACT
DELETE FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_contact_id IN 
(
SELECT ics_contact_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_TRTMNT_PRCSS_TYPE
DELETE FROM ics_flow_icis.dbo.ics_trtmnt_prcss_type
 WHERE ics_trtmnt_prcss_type.ics_trtmnt_prcss_type_id IN 
(
SELECT ics_trtmnt_prcss_type_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_TRTMNT_PRCSS_TYPE
 ON ICS_TRTMNT_PRCSS_TYPE.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_REP_OBLGTN_TYPE
DELETE FROM ics_flow_icis.dbo.ics_rep_oblgtn_type
 WHERE ics_rep_oblgtn_type.ics_rep_oblgtn_type_id IN 
(
SELECT ics_rep_oblgtn_type_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_REP_OBLGTN_TYPE
 ON ICS_REP_OBLGTN_TYPE.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_ANLYTCL_METHOD
DELETE FROM ics_flow_icis.dbo.ics_anlytcl_method
 WHERE ics_anlytcl_method.ics_anlytcl_method_id IN 
(
SELECT ics_anlytcl_method_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_ANLYTCL_METHOD
 ON ICS_ANLYTCL_METHOD.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES
DELETE FROM ics_flow_icis.dbo.ics_bs_mgmt_practices
 WHERE ics_bs_mgmt_practices.ics_bs_mgmt_practices_id IN 
(
SELECT ics_bs_mgmt_practices_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);
-- /ICS_BS_ANNUL_PROG_REP
DELETE FROM ics_flow_icis.dbo.ics_bs_annul_prog_rep
 WHERE ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id IN 
(
SELECT ics_bs_annul_prog_rep_id 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_annul_prog_rep.key_hash
WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission')
);

-- INSERT

-- /ICS_BS_ANNUL_PROG_REP
INSERT INTO ics_flow_icis.dbo.ics_bs_annul_prog_rep
 SELECT ics_bs_annul_prog_rep.* 
 from ICS_BS_ANNUL_PROG_REP 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_REP_OBLGTN_TYPE
INSERT INTO ics_flow_icis.dbo.ics_rep_oblgtn_type
 SELECT ics_rep_oblgtn_type.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_REP_OBLGTN_TYPE
 ON ICS_REP_OBLGTN_TYPE.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_ANLYTCL_METHOD
INSERT INTO ics_flow_icis.dbo.ics_anlytcl_method
 SELECT ics_anlytcl_method.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_ANLYTCL_METHOD
 ON ICS_ANLYTCL_METHOD.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES
INSERT INTO ics_flow_icis.dbo.ics_bs_mgmt_practices
 SELECT ics_bs_mgmt_practices.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
 SELECT ics_contact.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_TRTMNT_PRCSS_TYPE
INSERT INTO ics_flow_icis.dbo.ics_trtmnt_prcss_type
 SELECT ics_trtmnt_prcss_type.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_TRTMNT_PRCSS_TYPE
 ON ICS_TRTMNT_PRCSS_TYPE.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_MGMT_PRC_DEFCY_TYPE
INSERT INTO ics_flow_icis.dbo.ics_mgmt_prc_defcy_type
 SELECT ics_mgmt_prc_defcy_type.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_MGMT_PRC_DEFCY_TYPE
 ON ICS_MGMT_PRC_DEFCY_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
 SELECT ics_contact.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
 SELECT ics_addr.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_ADDR
 ON ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_VECTOR_A_REDUCTION_TYPE
INSERT INTO ics_flow_icis.dbo.ics_vector_a_reduction_type
 SELECT ics_vector_a_reduction_type.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_VECTOR_A_REDUCTION_TYPE
 ON ICS_VECTOR_A_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_PATHOGEN_REDUCTION_TYPE
INSERT INTO ics_flow_icis.dbo.ics_pathogen_reduction_type
 SELECT ics_pathogen_reduction_type.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_PATHOGEN_REDUCTION_TYPE
 ON ICS_PATHOGEN_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
 SELECT ics_teleph.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_ADDR
 ON ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ICS_TELEPH
 ON ICS_TELEPH.ICS_ADDR_ID = ICS_ADDR.ICS_ADDR_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));

-- /ICS_BS_ANNUL_PROG_REP/ICS_BS_MGMT_PRACTICES/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
 SELECT ics_teleph.* 
 from ICS_BS_ANNUL_PROG_REP 
 JOIN ICS_BS_MGMT_PRACTICES
 ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID 
 JOIN ICS_CONTACT
 ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID 
 JOIN ICS_TELEPH
 ON ICS_TELEPH.ICS_CONTACT_ID = ICS_CONTACT.ICS_CONTACT_ID 
  WHERE ics_bs_annul_prog_rep.transaction_type NOT IN ('D','X') 
 AND key_hash IN (
( SELECT key_hash FROM ics_subm_results 
 WHERE result_type_code IN ('Accepted','Warning') 
 AND subm_type_name = 'BiosolidsAnnualProgramReportSubmission'));
 
                  
                  
-- Remove any old records for ics_cmpl_mon
-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts_polut
 WHERE ics_loc_lmts_polut.ics_loc_lmts_id IN
          (SELECT ics_loc_lmts.ics_loc_lmts_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_pretr_insp ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                  JOIN ics_flow_icis.dbo.ics_loc_lmts ON ics_loc_lmts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts_polut
 WHERE ics_rmvl_crdts_polut.ics_rmvl_crdts_id IN
          (SELECT ics_rmvl_crdts.ics_rmvl_crdts_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_pretr_insp ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                  JOIN ics_flow_icis.dbo.ics_rmvl_crdts ON ics_rmvl_crdts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_proj_type
 WHERE ics_proj_type.ics_sw_unprmt_cnst_insp_id IN
          (SELECT ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_insp ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                  JOIN ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_proj_type
 WHERE ics_proj_type.ics_sw_unprmt_cnst_insp_id IN
          (SELECT ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_non_cnst_insp ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                  JOIN ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_proj_type
 WHERE ics_proj_type.ics_sw_unprmt_cnst_insp_id IN
          (SELECT ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_non_cnst_insp ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                  JOIN ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp ON ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_ANML_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_anml_type
 WHERE ics_anml_type.ics_cafo_insp_id IN
          (SELECT ics_cafo_insp.ics_cafo_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_cafo_insp ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CAFO_INSP_VIOL_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_cafo_insp_viol_type
 WHERE ics_cafo_insp_viol_type.ics_cafo_insp_id IN
          (SELECT ics_cafo_insp.ics_cafo_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_cafo_insp ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CONTAINMENT
DELETE
  FROM ics_flow_icis.dbo.ics_containment
 WHERE ics_containment.ics_cafo_insp_id IN
          (SELECT ics_cafo_insp.ics_cafo_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_cafo_insp ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_LAND_APPL_BMP
DELETE
  FROM ics_flow_icis.dbo.ics_land_appl_bmp
 WHERE ics_land_appl_bmp.ics_cafo_insp_id IN
          (SELECT ics_cafo_insp.ics_cafo_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_cafo_insp ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_MNUR_LTTR_PRCSS_WW_STOR
DELETE
  FROM ics_flow_icis.dbo.ics_mnur_lttr_prcss_ww_stor
 WHERE ics_mnur_lttr_prcss_ww_stor.ics_cafo_insp_id IN
          (SELECT ics_cafo_insp.ics_cafo_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_cafo_insp ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts
 WHERE ics_loc_lmts.ics_pretr_insp_id IN
          (SELECT ics_pretr_insp.ics_pretr_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_pretr_insp ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts
 WHERE ics_rmvl_crdts.ics_pretr_insp_id IN
          (SELECT ics_pretr_insp.ics_pretr_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_pretr_insp ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_IMPACT_SSO_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_impact_sso_evt
 WHERE ics_impact_sso_evt.ics_sso_insp_id IN
          (SELECT ics_sso_insp.ics_sso_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sso_insp ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_STPS
DELETE
  FROM ics_flow_icis.dbo.ics_sso_stps
 WHERE ics_sso_stps.ics_sso_insp_id IN
          (SELECT ics_sso_insp.ics_sso_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sso_insp ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_SYSTM_COMP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_systm_comp
 WHERE ics_sso_systm_comp.ics_sso_insp_id IN
          (SELECT ics_sso_insp.ics_sso_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sso_insp ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_CNST_INDST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_indst_insp
 WHERE ics_sw_cnst_indst_insp.ics_sw_cnst_insp_id IN
          (SELECT ics_sw_cnst_insp.ics_sw_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_insp ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
 WHERE ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id IN
          (SELECT ics_sw_cnst_insp.ics_sw_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_insp ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_indst_insp
 WHERE ics_sw_cnst_indst_insp.ics_sw_cnst_non_cnst_insp_id IN
          (SELECT ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_non_cnst_insp ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
 WHERE ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id IN
          (SELECT ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_cnst_non_cnst_insp ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_MS_4_INSP/ICS_PROJ_SRCS_FUND
DELETE
  FROM ics_flow_icis.dbo.ics_proj_srcs_fund
 WHERE ics_proj_srcs_fund.ics_sw_ms_4_insp_id IN
          (SELECT ics_sw_ms_4_insp.ics_sw_ms_4_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_ms_4_insp ON ics_sw_ms_4_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_indst_insp
 WHERE ics_sw_cnst_indst_insp.ics_sw_non_cnst_insp_id IN
          (SELECT ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_non_cnst_insp ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
 WHERE ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id IN
          (SELECT ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
                  JOIN ics_flow_icis.dbo.ics_sw_non_cnst_insp ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CAFO_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_cafo_insp
 WHERE ics_cafo_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CMPL_INSP_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_insp_type
 WHERE ics_cmpl_insp_type.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CMPL_MON_ACTN_REASON
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_mon_actn_reason
 WHERE ics_cmpl_mon_actn_reason.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CMPL_MON_AGNCY_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_mon_agncy_type
 WHERE ics_cmpl_mon_agncy_type.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_CSO_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_cso_insp
 WHERE ics_cso_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_NAT_PRIO
DELETE
  FROM ics_flow_icis.dbo.ics_nat_prio
 WHERE ics_nat_prio.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_PRETR_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_pretr_insp
 WHERE ics_pretr_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
--  5.6
-- /ICS_CMPL_MON/ICS_PROG_DEFCY_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_prog_defcy_type
 WHERE ics_prog_defcy_type.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_PROG
DELETE
  FROM ics_flow_icis.dbo.ics_prog
 WHERE ics_prog.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SSO_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_insp
 WHERE ics_sso_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_insp
 WHERE ics_sw_cnst_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_cnst_non_cnst_insp
 WHERE ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_MS_4_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_ms_4_insp
 WHERE ics_sw_ms_4_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_non_cnst_insp
 WHERE ics_sw_non_cnst_insp.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_MON
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_mon
 WHERE ics_cmpl_mon.ics_cmpl_mon_id IN
          (SELECT ics_cmpl_mon.ics_cmpl_mon_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringSubmission')
                 OR ics_cmpl_mon.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_cmpl_mon
-- /ICS_CMPL_MON
INSERT INTO ics_flow_icis.dbo.ics_cmpl_mon
     SELECT ics_cmpl_mon.*
       FROM ics_cmpl_mon
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

--  5.6
-- /ICS_CMPL_MON/ICS_PROG_DEFCY_TYPE
INSERT INTO ics_flow_icis.dbo.ics_prog_defcy_type
     SELECT ics_prog_defcy_type.*
       FROM ics_prog_defcy_type
          JOIN ics_cmpl_mon
            ON ics_prog_defcy_type.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP
INSERT INTO ics_flow_icis.dbo.ics_cafo_insp
     SELECT ics_cafo_insp.*
       FROM ics_cafo_insp
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_ANML_TYPE
INSERT INTO ics_flow_icis.dbo.ics_anml_type
     SELECT ics_anml_type.*
       FROM ics_anml_type
          JOIN ics_cafo_insp
            ON ics_anml_type.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CAFO_INSP_VIOL_TYPE
INSERT INTO ics_flow_icis.dbo.ics_cafo_insp_viol_type
     SELECT ics_cafo_insp_viol_type.*
       FROM ics_cafo_insp_viol_type
          JOIN ics_cafo_insp
            ON ics_cafo_insp_viol_type.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CONTAINMENT
INSERT INTO ics_flow_icis.dbo.ics_containment
     SELECT ics_containment.*
       FROM ics_containment
          JOIN ics_cafo_insp
            ON ics_containment.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_LAND_APPL_BMP
INSERT INTO ics_flow_icis.dbo.ics_land_appl_bmp
     SELECT ics_land_appl_bmp.*
       FROM ics_land_appl_bmp
          JOIN ics_cafo_insp
            ON ics_land_appl_bmp.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_MNUR_LTTR_PRCSS_WW_STOR
INSERT INTO ics_flow_icis.dbo.ics_mnur_lttr_prcss_ww_stor
     SELECT ics_mnur_lttr_prcss_ww_stor.*
       FROM ics_mnur_lttr_prcss_ww_stor
          JOIN ics_cafo_insp
            ON ics_mnur_lttr_prcss_ww_stor.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
          JOIN ics_cmpl_mon
            ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CMPL_INSP_TYPE
INSERT INTO ics_flow_icis.dbo.ics_cmpl_insp_type
     SELECT ics_cmpl_insp_type.*
       FROM ics_cmpl_insp_type
          JOIN ics_cmpl_mon
            ON ics_cmpl_insp_type.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CMPL_MON_ACTN_REASON
INSERT INTO ics_flow_icis.dbo.ics_cmpl_mon_actn_reason
     SELECT ics_cmpl_mon_actn_reason.*
       FROM ics_cmpl_mon_actn_reason
          JOIN ics_cmpl_mon
            ON ics_cmpl_mon_actn_reason.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CMPL_MON_AGNCY_TYPE
INSERT INTO ics_flow_icis.dbo.ics_cmpl_mon_agncy_type
     SELECT ics_cmpl_mon_agncy_type.*
       FROM ics_cmpl_mon_agncy_type
          JOIN ics_cmpl_mon
            ON ics_cmpl_mon_agncy_type.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_cmpl_mon
            ON ics_contact.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_cmpl_mon
            ON ics_contact.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_CSO_INSP
INSERT INTO ics_flow_icis.dbo.ics_cso_insp
     SELECT ics_cso_insp.*
       FROM ics_cso_insp
          JOIN ics_cmpl_mon
            ON ics_cso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_NAT_PRIO
INSERT INTO ics_flow_icis.dbo.ics_nat_prio
     SELECT ics_nat_prio.*
       FROM ics_nat_prio
          JOIN ics_cmpl_mon
            ON ics_nat_prio.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PRETR_INSP
INSERT INTO ics_flow_icis.dbo.ics_pretr_insp
     SELECT ics_pretr_insp.*
       FROM ics_pretr_insp
          JOIN ics_cmpl_mon
            ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts
     SELECT ics_loc_lmts.*
       FROM ics_loc_lmts
          JOIN ics_pretr_insp
            ON ics_loc_lmts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
          JOIN ics_cmpl_mon
            ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts_polut
     SELECT ics_loc_lmts_polut.*
       FROM ics_loc_lmts_polut
          JOIN ics_loc_lmts
            ON ics_loc_lmts_polut.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
          JOIN ics_pretr_insp
            ON ics_loc_lmts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
          JOIN ics_cmpl_mon
            ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts
     SELECT ics_rmvl_crdts.*
       FROM ics_rmvl_crdts
          JOIN ics_pretr_insp
            ON ics_rmvl_crdts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
          JOIN ics_cmpl_mon
            ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts_polut
     SELECT ics_rmvl_crdts_polut.*
       FROM ics_rmvl_crdts_polut
          JOIN ics_rmvl_crdts
            ON ics_rmvl_crdts_polut.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
          JOIN ics_pretr_insp
            ON ics_rmvl_crdts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
          JOIN ics_cmpl_mon
            ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_PROG
INSERT INTO ics_flow_icis.dbo.ics_prog
     SELECT ics_prog.*
       FROM ics_prog
          JOIN ics_cmpl_mon
            ON ics_prog.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SSO_INSP
INSERT INTO ics_flow_icis.dbo.ics_sso_insp
     SELECT ics_sso_insp.*
       FROM ics_sso_insp
          JOIN ics_cmpl_mon
            ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_IMPACT_SSO_EVT
INSERT INTO ics_flow_icis.dbo.ics_impact_sso_evt
     SELECT ics_impact_sso_evt.*
       FROM ics_impact_sso_evt
          JOIN ics_sso_insp
            ON ics_impact_sso_evt.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
          JOIN ics_cmpl_mon
            ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_STPS
INSERT INTO ics_flow_icis.dbo.ics_sso_stps
     SELECT ics_sso_stps.*
       FROM ics_sso_stps
          JOIN ics_sso_insp
            ON ics_sso_stps.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
          JOIN ics_cmpl_mon
            ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_SYSTM_COMP
INSERT INTO ics_flow_icis.dbo.ics_sso_systm_comp
     SELECT ics_sso_systm_comp.*
       FROM ics_sso_systm_comp
          JOIN ics_sso_insp
            ON ics_sso_systm_comp.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
          JOIN ics_cmpl_mon
            ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_insp
     SELECT ics_sw_cnst_insp.*
       FROM ics_sw_cnst_insp
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_CNST_INDST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_indst_insp
     SELECT ics_sw_cnst_indst_insp.*
       FROM ics_sw_cnst_indst_insp
          JOIN ics_sw_cnst_insp
            ON ics_sw_cnst_indst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
     SELECT ics_sw_unprmt_cnst_insp.*
       FROM ics_sw_unprmt_cnst_insp
          JOIN ics_sw_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
INSERT INTO ics_flow_icis.dbo.ics_proj_type
     SELECT ics_proj_type.*
       FROM ics_proj_type
          JOIN ics_sw_unprmt_cnst_insp
            ON ics_proj_type.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
          JOIN ics_sw_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_non_cnst_insp
     SELECT ics_sw_cnst_non_cnst_insp.*
       FROM ics_sw_cnst_non_cnst_insp
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_indst_insp
     SELECT ics_sw_cnst_indst_insp.*
       FROM ics_sw_cnst_indst_insp
          JOIN ics_sw_cnst_non_cnst_insp
            ON ics_sw_cnst_indst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
     SELECT ics_sw_unprmt_cnst_insp.*
       FROM ics_sw_unprmt_cnst_insp
          JOIN ics_sw_cnst_non_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
INSERT INTO ics_flow_icis.dbo.ics_proj_type
     SELECT ics_proj_type.*
       FROM ics_proj_type
          JOIN ics_sw_unprmt_cnst_insp
            ON ics_proj_type.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
          JOIN ics_sw_cnst_non_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_MS_4_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_ms_4_insp
     SELECT ics_sw_ms_4_insp.*
       FROM ics_sw_ms_4_insp
          JOIN ics_cmpl_mon
            ON ics_sw_ms_4_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_MS_4_INSP/ICS_PROJ_SRCS_FUND
INSERT INTO ics_flow_icis.dbo.ics_proj_srcs_fund
     SELECT ics_proj_srcs_fund.*
       FROM ics_proj_srcs_fund
          JOIN ics_sw_ms_4_insp
            ON ics_proj_srcs_fund.ics_sw_ms_4_insp_id = ics_sw_ms_4_insp.ics_sw_ms_4_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_ms_4_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_non_cnst_insp
     SELECT ics_sw_non_cnst_insp.*
       FROM ics_sw_non_cnst_insp
          JOIN ics_cmpl_mon
            ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_indst_insp
     SELECT ics_sw_cnst_indst_insp.*
       FROM ics_sw_cnst_indst_insp
          JOIN ics_sw_non_cnst_insp
            ON ics_sw_cnst_indst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
INSERT INTO ics_flow_icis.dbo.ics_sw_unprmt_cnst_insp
     SELECT ics_sw_unprmt_cnst_insp.*
       FROM ics_sw_unprmt_cnst_insp
          JOIN ics_sw_non_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');

-- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
INSERT INTO ics_flow_icis.dbo.ics_proj_type
     SELECT ics_proj_type.*
       FROM ics_proj_type
          JOIN ics_sw_unprmt_cnst_insp
            ON ics_proj_type.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
          JOIN ics_sw_non_cnst_insp
            ON ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
          JOIN ics_cmpl_mon
            ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
       WHERE ics_cmpl_mon.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringSubmission');


-- Remove any old records for ics_efflu_trade_prtner
-- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_efflu_trade_prtner_addr_id IN
          (SELECT ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_addr_id
             FROM ics_flow_icis.dbo.ics_efflu_trade_prtner
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_efflu_trade_prtner.key_hash 
                  JOIN ics_flow_icis.dbo.ics_efflu_trade_prtner_addr ON ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EffluentTradePartnerSubmission')
                 OR ics_efflu_trade_prtner.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_efflu_trade_prtner_addr
 WHERE ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id IN
          (SELECT ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
             FROM ics_flow_icis.dbo.ics_efflu_trade_prtner
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_efflu_trade_prtner.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EffluentTradePartnerSubmission')
                 OR ics_efflu_trade_prtner.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_EFFLU_TRADE_PRTNER
DELETE
  FROM ics_flow_icis.dbo.ics_efflu_trade_prtner
 WHERE ics_efflu_trade_prtner.ics_efflu_trade_prtner_id IN
          (SELECT ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
             FROM ics_flow_icis.dbo.ics_efflu_trade_prtner
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_efflu_trade_prtner.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EffluentTradePartnerSubmission')
                 OR ics_efflu_trade_prtner.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_efflu_trade_prtner
-- /ICS_EFFLU_TRADE_PRTNER
INSERT INTO ics_flow_icis.dbo.ics_efflu_trade_prtner
     SELECT ics_efflu_trade_prtner.*
       FROM ics_efflu_trade_prtner
       WHERE ics_efflu_trade_prtner.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EffluentTradePartnerSubmission');

-- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR
INSERT INTO ics_flow_icis.dbo.ics_efflu_trade_prtner_addr
     SELECT ics_efflu_trade_prtner_addr.*
       FROM ics_efflu_trade_prtner_addr
          JOIN ics_efflu_trade_prtner
            ON ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
       WHERE ics_efflu_trade_prtner.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EffluentTradePartnerSubmission');

-- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_efflu_trade_prtner_addr
            ON ics_teleph.ics_efflu_trade_prtner_addr_id = ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_addr_id
          JOIN ics_efflu_trade_prtner
            ON ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
       WHERE ics_efflu_trade_prtner.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EffluentTradePartnerSubmission');


-- Remove any old records for ics_frml_enfrc_actn
-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_FINAL_ORDER_PRMT_IDENT
DELETE
  FROM ics_flow_icis.dbo.ics_final_order_prmt_ident
 WHERE ics_final_order_prmt_ident.ics_final_order_id IN
          (SELECT ics_final_order.ics_final_order_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
                  JOIN ics_flow_icis.dbo.ics_final_order ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
--  5.6
-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_SEP
DELETE
  FROM ics_flow_icis.dbo.ics_sep
 WHERE ics_sep.ics_final_order_id IN
          (SELECT ics_final_order.ics_final_order_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
                  JOIN ics_flow_icis.dbo.ics_final_order ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);


-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_actn_gov_contact
 WHERE ics_enfrc_actn_gov_contact.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_actn_type
 WHERE ics_enfrc_actn_type.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_agncy
 WHERE ics_enfrc_agncy.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER
DELETE
  FROM ics_flow_icis.dbo.ics_final_order
 WHERE ics_final_order.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN/ICS_PRMT_IDENT
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_ident
 WHERE ics_prmt_ident.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN/ICS_PROGS_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_progs_viol
 WHERE ics_progs_viol.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);
-- /ICS_FRML_ENFRC_ACTN
DELETE
  FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
 WHERE ics_frml_enfrc_actn.ics_frml_enfrc_actn_id IN
          (SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_frml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_frml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FormalEnforcementActionSubmission')
);

-- Add accepted records for ics_frml_enfrc_actn
-- /ICS_FRML_ENFRC_ACTN
INSERT INTO ics_flow_icis.dbo.ics_frml_enfrc_actn
     SELECT ics_frml_enfrc_actn.*
       FROM ics_frml_enfrc_actn
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_enfrc_actn_gov_contact
     SELECT ics_enfrc_actn_gov_contact.*
       FROM ics_enfrc_actn_gov_contact
          JOIN ics_frml_enfrc_actn
            ON ics_enfrc_actn_gov_contact.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_TYPE
INSERT INTO ics_flow_icis.dbo.ics_enfrc_actn_type
     SELECT ics_enfrc_actn_type.*
       FROM ics_enfrc_actn_type
          JOIN ics_frml_enfrc_actn
            ON ics_enfrc_actn_type.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
INSERT INTO ics_flow_icis.dbo.ics_enfrc_agncy
     SELECT ics_enfrc_agncy.*
       FROM ics_enfrc_agncy
          JOIN ics_frml_enfrc_actn
            ON ics_enfrc_agncy.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER
INSERT INTO ics_flow_icis.dbo.ics_final_order
     SELECT ics_final_order.*
       FROM ics_final_order
          JOIN ics_frml_enfrc_actn
            ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');
--  5.6
-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_SEP
INSERT INTO ics_flow_icis.dbo.ics_sep
     SELECT ics_sep.*
       FROM ics_sep
          JOIN ics_final_order
            ON ics_sep.ics_final_order_id = ics_final_order.ics_final_order_id
          JOIN ics_frml_enfrc_actn
            ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_FINAL_ORDER_PRMT_IDENT
INSERT INTO ics_flow_icis.dbo.ics_final_order_prmt_ident
     SELECT ics_final_order_prmt_ident.*
       FROM ics_final_order_prmt_ident
          JOIN ics_final_order
            ON ics_final_order_prmt_ident.ics_final_order_id = ics_final_order.ics_final_order_id
          JOIN ics_frml_enfrc_actn
            ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_PRMT_IDENT
INSERT INTO ics_flow_icis.dbo.ics_prmt_ident
     SELECT ics_prmt_ident.*
       FROM ics_prmt_ident
          JOIN ics_frml_enfrc_actn
            ON ics_prmt_ident.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');

-- /ICS_FRML_ENFRC_ACTN/ICS_PROGS_VIOL
INSERT INTO ics_flow_icis.dbo.ics_progs_viol
     SELECT ics_progs_viol.*
       FROM ics_progs_viol
          JOIN ics_frml_enfrc_actn
            ON ics_progs_viol.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
       WHERE ics_frml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FormalEnforcementActionSubmission');


-- Remove any old records for ics_infrml_enfrc_actn
-- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_actn_gov_contact
 WHERE ics_enfrc_actn_gov_contact.ics_infrml_enfrc_actn_id IN
          (SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_infrml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'InformalEnforcementActionSubmission')
);
-- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_agncy
 WHERE ics_enfrc_agncy.ics_infrml_enfrc_actn_id IN
          (SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_infrml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'InformalEnforcementActionSubmission')
);
-- /ICS_INFRML_ENFRC_ACTN/ICS_PRMT_IDENT
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_ident
 WHERE ics_prmt_ident.ics_infrml_enfrc_actn_id IN
          (SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_infrml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'InformalEnforcementActionSubmission')
);
-- /ICS_INFRML_ENFRC_ACTN/ICS_PROGS_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_progs_viol
 WHERE ics_progs_viol.ics_infrml_enfrc_actn_id IN
          (SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_infrml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'InformalEnforcementActionSubmission')
);
-- /ICS_INFRML_ENFRC_ACTN
DELETE
  FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
 WHERE ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id IN
          (SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_infrml_enfrc_actn.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'InformalEnforcementActionSubmission')
);

-- Add accepted records for ics_infrml_enfrc_actn
-- /ICS_INFRML_ENFRC_ACTN
INSERT INTO ics_flow_icis.dbo.ics_infrml_enfrc_actn
     SELECT ics_infrml_enfrc_actn.*
       FROM ics_infrml_enfrc_actn
       WHERE ics_infrml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'InformalEnforcementActionSubmission');

-- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_enfrc_actn_gov_contact
     SELECT ics_enfrc_actn_gov_contact.*
       FROM ics_enfrc_actn_gov_contact
          JOIN ics_infrml_enfrc_actn
            ON ics_enfrc_actn_gov_contact.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
       WHERE ics_infrml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'InformalEnforcementActionSubmission');

-- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
INSERT INTO ics_flow_icis.dbo.ics_enfrc_agncy
     SELECT ics_enfrc_agncy.*
       FROM ics_enfrc_agncy
          JOIN ics_infrml_enfrc_actn
            ON ics_enfrc_agncy.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
       WHERE ics_infrml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'InformalEnforcementActionSubmission');

-- /ICS_INFRML_ENFRC_ACTN/ICS_PRMT_IDENT
INSERT INTO ics_flow_icis.dbo.ics_prmt_ident
     SELECT ics_prmt_ident.*
       FROM ics_prmt_ident
          JOIN ics_infrml_enfrc_actn
            ON ics_prmt_ident.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
       WHERE ics_infrml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'InformalEnforcementActionSubmission');

-- /ICS_INFRML_ENFRC_ACTN/ICS_PROGS_VIOL
INSERT INTO ics_flow_icis.dbo.ics_progs_viol
     SELECT ics_progs_viol.*
       FROM ics_progs_viol
          JOIN ics_infrml_enfrc_actn
            ON ics_progs_viol.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
       WHERE ics_infrml_enfrc_actn.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'InformalEnforcementActionSubmission');


-- Remove any old records for ics_cmpl_schd
-- /ICS_CMPL_SCHD/ICS_CMPL_SCHD_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_schd_evt
 WHERE ics_cmpl_schd_evt.ics_cmpl_schd_id IN
          (SELECT ics_cmpl_schd.ics_cmpl_schd_id
             FROM ics_flow_icis.dbo.ics_cmpl_schd
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_schd.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceScheduleSubmission')
                 OR ics_cmpl_schd.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_CMPL_SCHD
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_schd
 WHERE ics_cmpl_schd.ics_cmpl_schd_id IN
          (SELECT ics_cmpl_schd.ics_cmpl_schd_id
             FROM ics_flow_icis.dbo.ics_cmpl_schd
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_schd.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceScheduleSubmission')
                 OR ics_cmpl_schd.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_cmpl_schd
-- /ICS_CMPL_SCHD
INSERT INTO ics_flow_icis.dbo.ics_cmpl_schd
     SELECT ics_cmpl_schd.*
       FROM ics_cmpl_schd
       WHERE ics_cmpl_schd.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceScheduleSubmission');

-- /ICS_CMPL_SCHD/ICS_CMPL_SCHD_EVT
INSERT INTO ics_flow_icis.dbo.ics_cmpl_schd_evt
     SELECT ics_cmpl_schd_evt.*
       FROM ics_cmpl_schd_evt
          JOIN ics_cmpl_schd
            ON ics_cmpl_schd_evt.ics_cmpl_schd_id = ics_cmpl_schd.ics_cmpl_schd_id
       WHERE ics_cmpl_schd.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceScheduleSubmission');


-- Remove any old records for ics_enfrc_actn_milestone
-- /ICS_ENFRC_ACTN_MILESTONE
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_actn_milestone
 WHERE ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id IN
          (SELECT ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_milestone
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_milestone.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionMilestoneSubmission')
);

-- Add accepted records for ics_enfrc_actn_milestone
-- /ICS_ENFRC_ACTN_MILESTONE
INSERT INTO ics_flow_icis.dbo.ics_enfrc_actn_milestone
     SELECT ics_enfrc_actn_milestone.*
       FROM ics_enfrc_actn_milestone
       WHERE ics_enfrc_actn_milestone.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionMilestoneSubmission');


-- Remove any old records for ics_dmr_viol
-- /ICS_DMR_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_dmr_viol
 WHERE ics_dmr_viol.ics_dmr_viol_id IN
          (SELECT ics_dmr_viol.ics_dmr_viol_id
             FROM ics_flow_icis.dbo.ics_dmr_viol
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dmr_viol.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DMRViolationSubmission')
                 OR ics_dmr_viol.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_dmr_viol
-- /ICS_DMR_VIOL
INSERT INTO ics_flow_icis.dbo.ics_dmr_viol
     SELECT ics_dmr_viol.*
       FROM ics_dmr_viol
       WHERE ics_dmr_viol.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DMRViolationSubmission');


-- Remove any old records for ics_sngl_evt_viol
-- /ICS_SNGL_EVT_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_sngl_evt_viol
 WHERE ics_sngl_evt_viol.ics_sngl_evt_viol_id IN
          (SELECT ics_sngl_evt_viol.ics_sngl_evt_viol_id
             FROM ics_flow_icis.dbo.ics_sngl_evt_viol
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sngl_evt_viol.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SingleEventViolationSubmission')
                 OR ics_sngl_evt_viol.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sngl_evt_viol
-- /ICS_SNGL_EVT_VIOL
INSERT INTO ics_flow_icis.dbo.ics_sngl_evt_viol
     SELECT ics_sngl_evt_viol.*
       FROM ics_sngl_evt_viol
       WHERE ics_sngl_evt_viol.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SingleEventViolationSubmission');


-- Remove any old records for ics_cso_evt_rep
-- /ICS_CSO_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_cso_evt_rep
 WHERE ics_cso_evt_rep.ics_cso_evt_rep_id IN
          (SELECT ics_cso_evt_rep.ics_cso_evt_rep_id
             FROM ics_flow_icis.dbo.ics_cso_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cso_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CSOEventReportSubmission')
                 OR ics_cso_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_cso_evt_rep
-- /ICS_CSO_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_cso_evt_rep
     SELECT ics_cso_evt_rep.*
       FROM ics_cso_evt_rep
       WHERE ics_cso_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CSOEventReportSubmission');


-- Remove any old records for ics_sw_evt_rep
-- /ICS_SW_EVT_REP/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_sw_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_evt_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWEventReportSubmission')
                 OR ics_sw_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SW_EVT_REP/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_sw_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_evt_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWEventReportSubmission')
                 OR ics_sw_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SW_EVT_REP/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_sw_evt_rep_id IN
          (SELECT ics_sw_evt_rep.ics_sw_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sw_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWEventReportSubmission')
                 OR ics_sw_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SW_EVT_REP/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_sw_evt_rep_id IN
          (SELECT ics_sw_evt_rep.ics_sw_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sw_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWEventReportSubmission')
                 OR ics_sw_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SW_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_evt_rep
 WHERE ics_sw_evt_rep.ics_sw_evt_rep_id IN
          (SELECT ics_sw_evt_rep.ics_sw_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sw_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWEventReportSubmission')
                 OR ics_sw_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sw_evt_rep
-- /ICS_SW_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_sw_evt_rep
     SELECT ics_sw_evt_rep.*
       FROM ics_sw_evt_rep
       WHERE ics_sw_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWEventReportSubmission');

-- /ICS_SW_EVT_REP/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_sw_evt_rep
            ON ics_addr.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
       WHERE ics_sw_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWEventReportSubmission');

-- /ICS_SW_EVT_REP/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_sw_evt_rep
            ON ics_addr.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
       WHERE ics_sw_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWEventReportSubmission');

-- /ICS_SW_EVT_REP/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_sw_evt_rep
            ON ics_contact.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
       WHERE ics_sw_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWEventReportSubmission');

-- /ICS_SW_EVT_REP/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_sw_evt_rep
            ON ics_contact.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
       WHERE ics_sw_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWEventReportSubmission');


-- Remove any old records for ics_cafo_annul_rep
-- /ICS_CAFO_ANNUL_REP/ICS_REP_ANML_TYPE
DELETE
  FROM ics_flow_icis.dbo.ics_rep_anml_type
 WHERE ics_rep_anml_type.ics_cafo_annul_rep_id IN
          (SELECT ics_cafo_annul_rep.ics_cafo_annul_rep_id
             FROM ics_flow_icis.dbo.ics_cafo_annul_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_annul_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOAnnualReportSubmission')
                 OR ics_cafo_annul_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- /ICS_CAFO_ANNUL_REP
DELETE
  FROM ics_flow_icis.dbo.ics_cafo_annul_rep
 WHERE ics_cafo_annul_rep.ics_cafo_annul_rep_id IN
          (SELECT ics_cafo_annul_rep.ics_cafo_annul_rep_id
             FROM ics_flow_icis.dbo.ics_cafo_annul_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cafo_annul_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'CAFOAnnualReportSubmission')
                 OR ics_cafo_annul_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_cafo_annul_rep
-- /ICS_CAFO_ANNUL_REP
INSERT INTO ics_flow_icis.dbo.ics_cafo_annul_rep
     SELECT ics_cafo_annul_rep.*
       FROM ics_cafo_annul_rep
       WHERE ics_cafo_annul_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOAnnualReportSubmission');

-- /ICS_CAFO_ANNUL_REP/ICS_REP_ANML_TYPE
INSERT INTO ics_flow_icis.dbo.ics_rep_anml_type
     SELECT ics_rep_anml_type.*
       FROM ics_rep_anml_type
          JOIN ics_cafo_annul_rep
            ON ics_rep_anml_type.ics_cafo_annul_rep_id = ics_cafo_annul_rep.ics_cafo_annul_rep_id
       WHERE ics_cafo_annul_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'CAFOAnnualReportSubmission');


-- Remove any old records for ics_sw_indst_annul_rep
-- /ICS_SW_INDST_ANNUL_REP
DELETE
  FROM ics_flow_icis.dbo.ics_sw_indst_annul_rep
 WHERE ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id IN
          (SELECT ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id
             FROM ics_flow_icis.dbo.ics_sw_indst_annul_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sw_indst_annul_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWIndustrialAnnualReportSubmission')
                 OR ics_sw_indst_annul_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sw_indst_annul_rep
-- /ICS_SW_INDST_ANNUL_REP
INSERT INTO ics_flow_icis.dbo.ics_sw_indst_annul_rep
     SELECT ics_sw_indst_annul_rep.*
       FROM ics_sw_indst_annul_rep
       WHERE ics_sw_indst_annul_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWIndustrialAnnualReportSubmission');

-- Remove any old records for ics_loc_lmts_prog_rep
-- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts_polut
 WHERE ics_loc_lmts_polut.ics_loc_lmts_id IN
          (SELECT ics_loc_lmts.ics_loc_lmts_id
             FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_loc_lmts_prog_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_loc_lmts ON ics_loc_lmts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LocalLimitsProgramReportSubmission')
                 OR ics_loc_lmts_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts_polut
 WHERE ics_rmvl_crdts_polut.ics_rmvl_crdts_id IN
          (SELECT ics_rmvl_crdts.ics_rmvl_crdts_id
             FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_loc_lmts_prog_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_rmvl_crdts ON ics_rmvl_crdts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LocalLimitsProgramReportSubmission')
                 OR ics_loc_lmts_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts
 WHERE ics_loc_lmts.ics_loc_lmts_prog_rep_id IN
          (SELECT ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
             FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_loc_lmts_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LocalLimitsProgramReportSubmission')
                 OR ics_loc_lmts_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts
 WHERE ics_rmvl_crdts.ics_loc_lmts_prog_rep_id IN
          (SELECT ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
             FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_loc_lmts_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LocalLimitsProgramReportSubmission')
                 OR ics_loc_lmts_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_LOC_LMTS_PROG_REP
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
 WHERE ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id IN
          (SELECT ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
             FROM ics_flow_icis.dbo.ics_loc_lmts_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_loc_lmts_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'LocalLimitsProgramReportSubmission')
                 OR ics_loc_lmts_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_loc_lmts_prog_rep
-- /ICS_LOC_LMTS_PROG_REP
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts_prog_rep
     SELECT ics_loc_lmts_prog_rep.*
       FROM ics_loc_lmts_prog_rep
       WHERE ics_loc_lmts_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LocalLimitsProgramReportSubmission');

-- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts
     SELECT ics_loc_lmts.*
       FROM ics_loc_lmts
          JOIN ics_loc_lmts_prog_rep
            ON ics_loc_lmts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
       WHERE ics_loc_lmts_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LocalLimitsProgramReportSubmission');

-- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts_polut
     SELECT ics_loc_lmts_polut.*
       FROM ics_loc_lmts_polut
          JOIN ics_loc_lmts
            ON ics_loc_lmts_polut.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
          JOIN ics_loc_lmts_prog_rep
            ON ics_loc_lmts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
       WHERE ics_loc_lmts_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LocalLimitsProgramReportSubmission');

-- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts
     SELECT ics_rmvl_crdts.*
       FROM ics_rmvl_crdts
          JOIN ics_loc_lmts_prog_rep
            ON ics_rmvl_crdts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
       WHERE ics_loc_lmts_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LocalLimitsProgramReportSubmission');

-- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts_polut
     SELECT ics_rmvl_crdts_polut.*
       FROM ics_rmvl_crdts_polut
          JOIN ics_rmvl_crdts
            ON ics_rmvl_crdts_polut.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
          JOIN ics_loc_lmts_prog_rep
            ON ics_rmvl_crdts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
       WHERE ics_loc_lmts_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'LocalLimitsProgramReportSubmission');


-- Remove any old records for ics_pretr_perf_summ
-- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts_polut
 WHERE ics_loc_lmts_polut.ics_loc_lmts_id IN
          (SELECT ics_loc_lmts.ics_loc_lmts_id
             FROM ics_flow_icis.dbo.ics_pretr_perf_summ
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_perf_summ.key_hash 
                  JOIN ics_flow_icis.dbo.ics_loc_lmts ON ics_loc_lmts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPerformanceSummarySubmission')
                 OR ics_pretr_perf_summ.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts_polut
 WHERE ics_rmvl_crdts_polut.ics_rmvl_crdts_id IN
          (SELECT ics_rmvl_crdts.ics_rmvl_crdts_id
             FROM ics_flow_icis.dbo.ics_pretr_perf_summ
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_perf_summ.key_hash 
                  JOIN ics_flow_icis.dbo.ics_rmvl_crdts ON ics_rmvl_crdts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPerformanceSummarySubmission')
                 OR ics_pretr_perf_summ.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS
DELETE
  FROM ics_flow_icis.dbo.ics_loc_lmts
 WHERE ics_loc_lmts.ics_pretr_perf_summ_id IN
          (SELECT ics_pretr_perf_summ.ics_pretr_perf_summ_id
             FROM ics_flow_icis.dbo.ics_pretr_perf_summ
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_perf_summ.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPerformanceSummarySubmission')
                 OR ics_pretr_perf_summ.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS
DELETE
  FROM ics_flow_icis.dbo.ics_rmvl_crdts
 WHERE ics_rmvl_crdts.ics_pretr_perf_summ_id IN
          (SELECT ics_pretr_perf_summ.ics_pretr_perf_summ_id
             FROM ics_flow_icis.dbo.ics_pretr_perf_summ
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_perf_summ.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPerformanceSummarySubmission')
                 OR ics_pretr_perf_summ.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_PRETR_PERF_SUMM
DELETE
  FROM ics_flow_icis.dbo.ics_pretr_perf_summ
 WHERE ics_pretr_perf_summ.ics_pretr_perf_summ_id IN
          (SELECT ics_pretr_perf_summ.ics_pretr_perf_summ_id
             FROM ics_flow_icis.dbo.ics_pretr_perf_summ
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_pretr_perf_summ.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'PretreatmentPerformanceSummarySubmission')
                 OR ics_pretr_perf_summ.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_pretr_perf_summ
-- /ICS_PRETR_PERF_SUMM
INSERT INTO ics_flow_icis.dbo.ics_pretr_perf_summ
     SELECT ics_pretr_perf_summ.*
       FROM ics_pretr_perf_summ
       WHERE ics_pretr_perf_summ.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPerformanceSummarySubmission');

-- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts
     SELECT ics_loc_lmts.*
       FROM ics_loc_lmts
          JOIN ics_pretr_perf_summ
            ON ics_loc_lmts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
       WHERE ics_pretr_perf_summ.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPerformanceSummarySubmission');

-- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_loc_lmts_polut
     SELECT ics_loc_lmts_polut.*
       FROM ics_loc_lmts_polut
          JOIN ics_loc_lmts
            ON ics_loc_lmts_polut.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
          JOIN ics_pretr_perf_summ
            ON ics_loc_lmts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
       WHERE ics_pretr_perf_summ.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPerformanceSummarySubmission');

-- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts
     SELECT ics_rmvl_crdts.*
       FROM ics_rmvl_crdts
          JOIN ics_pretr_perf_summ
            ON ics_rmvl_crdts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
       WHERE ics_pretr_perf_summ.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPerformanceSummarySubmission');

-- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
INSERT INTO ics_flow_icis.dbo.ics_rmvl_crdts_polut
     SELECT ics_rmvl_crdts_polut.*
       FROM ics_rmvl_crdts_polut
          JOIN ics_rmvl_crdts
            ON ics_rmvl_crdts_polut.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
          JOIN ics_pretr_perf_summ
            ON ics_rmvl_crdts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
       WHERE ics_pretr_perf_summ.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'PretreatmentPerformanceSummarySubmission');


-- Remove any old records for ics_bs_prog_rep
-- /ICS_BS_PROG_REP
DELETE
  FROM ics_flow_icis.dbo.ics_bs_prog_rep
 WHERE ics_bs_prog_rep.ics_bs_prog_rep_id IN
          (SELECT ics_bs_prog_rep.ics_bs_prog_rep_id
             FROM ics_flow_icis.dbo.ics_bs_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_bs_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'BiosolidsProgramReportSubmission')
                 OR ics_bs_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_bs_prog_rep
-- /ICS_BS_PROG_REP
INSERT INTO ics_flow_icis.dbo.ics_bs_prog_rep
     SELECT ics_bs_prog_rep.*
       FROM ics_bs_prog_rep
       WHERE ics_bs_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'BiosolidsProgramReportSubmission');


-- Remove any old records for ics_sso_annul_rep
-- /ICS_SSO_ANNUL_REP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_annul_rep
 WHERE ics_sso_annul_rep.ics_sso_annul_rep_id IN
          (SELECT ics_sso_annul_rep.ics_sso_annul_rep_id
             FROM ics_flow_icis.dbo.ics_sso_annul_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_annul_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOAnnualReportSubmission')
                 OR ics_sso_annul_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sso_annul_rep
-- /ICS_SSO_ANNUL_REP
INSERT INTO ics_flow_icis.dbo.ics_sso_annul_rep
     SELECT ics_sso_annul_rep.*
       FROM ics_sso_annul_rep
       WHERE ics_sso_annul_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOAnnualReportSubmission');


-- Remove any old records for ics_sso_evt_rep
-- /ICS_SSO_EVT_REP/ICS_IMPACT_SSO_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_impact_sso_evt
 WHERE ics_impact_sso_evt.ics_sso_evt_rep_id IN
          (SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sso_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOEventReportSubmission')
                 OR ics_sso_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SSO_EVT_REP/ICS_SSO_STPS
DELETE
  FROM ics_flow_icis.dbo.ics_sso_stps
 WHERE ics_sso_stps.ics_sso_evt_rep_id IN
          (SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sso_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOEventReportSubmission')
                 OR ics_sso_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SSO_EVT_REP/ICS_SSO_SYSTM_COMP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_systm_comp
 WHERE ics_sso_systm_comp.ics_sso_evt_rep_id IN
          (SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sso_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOEventReportSubmission')
                 OR ics_sso_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SSO_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_evt_rep
 WHERE ics_sso_evt_rep.ics_sso_evt_rep_id IN
          (SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sso_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOEventReportSubmission')
                 OR ics_sso_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sso_evt_rep
-- /ICS_SSO_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_sso_evt_rep
     SELECT ics_sso_evt_rep.*
       FROM ics_sso_evt_rep
       WHERE ics_sso_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOEventReportSubmission');

-- /ICS_SSO_EVT_REP/ICS_IMPACT_SSO_EVT
INSERT INTO ics_flow_icis.dbo.ics_impact_sso_evt
     SELECT ics_impact_sso_evt.*
       FROM ics_impact_sso_evt
          JOIN ics_sso_evt_rep
            ON ics_impact_sso_evt.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
       WHERE ics_sso_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOEventReportSubmission');

-- /ICS_SSO_EVT_REP/ICS_SSO_STPS
INSERT INTO ics_flow_icis.dbo.ics_sso_stps
     SELECT ics_sso_stps.*
       FROM ics_sso_stps
          JOIN ics_sso_evt_rep
            ON ics_sso_stps.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
       WHERE ics_sso_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOEventReportSubmission');

-- /ICS_SSO_EVT_REP/ICS_SSO_SYSTM_COMP
INSERT INTO ics_flow_icis.dbo.ics_sso_systm_comp
     SELECT ics_sso_systm_comp.*
       FROM ics_sso_systm_comp
          JOIN ics_sso_evt_rep
            ON ics_sso_systm_comp.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
       WHERE ics_sso_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOEventReportSubmission');


-- Remove any old records for ics_sso_monthly_evt_rep
-- /ICS_SSO_MONTHLY_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_sso_monthly_evt_rep
 WHERE ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id IN
          (SELECT ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id
             FROM ics_flow_icis.dbo.ics_sso_monthly_evt_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_sso_monthly_evt_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SSOMonthlyEventReportSubmission')
                 OR ics_sso_monthly_evt_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_sso_monthly_evt_rep
-- /ICS_SSO_MONTHLY_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_sso_monthly_evt_rep
     SELECT ics_sso_monthly_evt_rep.*
       FROM ics_sso_monthly_evt_rep
       WHERE ics_sso_monthly_evt_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SSOMonthlyEventReportSubmission');


-- Remove any old records for ics_swms_4_prog_rep
-- /ICS_SWMS_4_PROG_REP/ICS_ADDR/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_addr_id IN
          (SELECT ics_addr.ics_addr_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_addr ON ics_addr.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SWMS_4_PROG_REP/ICS_CONTACT/ICS_TELEPH
DELETE
  FROM ics_flow_icis.dbo.ics_teleph
 WHERE ics_teleph.ics_contact_id IN
          (SELECT ics_contact.ics_contact_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
                  JOIN ics_flow_icis.dbo.ics_contact ON ics_contact.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SWMS_4_PROG_REP/ICS_ADDR
DELETE
  FROM ics_flow_icis.dbo.ics_addr
 WHERE ics_addr.ics_swms_4_prog_rep_id IN
          (SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SWMS_4_PROG_REP/ICS_CONTACT
DELETE
  FROM ics_flow_icis.dbo.ics_contact
 WHERE ics_contact.ics_swms_4_prog_rep_id IN
          (SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SWMS_4_PROG_REP/ICS_PROJ_SRCS_FUND
DELETE
  FROM ics_flow_icis.dbo.ics_proj_srcs_fund
 WHERE ics_proj_srcs_fund.ics_swms_4_prog_rep_id IN
          (SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);
-- /ICS_SWMS_4_PROG_REP
DELETE
  FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
 WHERE ics_swms_4_prog_rep.ics_swms_4_prog_rep_id IN
          (SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             FROM ics_flow_icis.dbo.ics_swms_4_prog_rep
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_swms_4_prog_rep.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'SWMS4ProgramReportSubmission')
                 OR ics_swms_4_prog_rep.prmt_ident IN (SELECT prmt_ident FROM ics_subm_results WHERE subm_type_name = 'PermitTerminationSubmission' AND result_type_code = 'Accepted')
);

-- Add accepted records for ics_swms_4_prog_rep
-- /ICS_SWMS_4_PROG_REP
INSERT INTO ics_flow_icis.dbo.ics_swms_4_prog_rep
     SELECT ics_swms_4_prog_rep.*
       FROM ics_swms_4_prog_rep
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');

-- /ICS_SWMS_4_PROG_REP/ICS_ADDR
INSERT INTO ics_flow_icis.dbo.ics_addr
     SELECT ics_addr.*
       FROM ics_addr
          JOIN ics_swms_4_prog_rep
            ON ics_addr.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');

-- /ICS_SWMS_4_PROG_REP/ICS_ADDR/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_addr
            ON ics_teleph.ics_addr_id = ics_addr.ics_addr_id
          JOIN ics_swms_4_prog_rep
            ON ics_addr.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');

-- /ICS_SWMS_4_PROG_REP/ICS_CONTACT
INSERT INTO ics_flow_icis.dbo.ics_contact
     SELECT ics_contact.*
       FROM ics_contact
          JOIN ics_swms_4_prog_rep
            ON ics_contact.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');

-- /ICS_SWMS_4_PROG_REP/ICS_CONTACT/ICS_TELEPH
INSERT INTO ics_flow_icis.dbo.ics_teleph
     SELECT ics_teleph.*
       FROM ics_teleph
          JOIN ics_contact
            ON ics_teleph.ics_contact_id = ics_contact.ics_contact_id
          JOIN ics_swms_4_prog_rep
            ON ics_contact.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');

-- /ICS_SWMS_4_PROG_REP/ICS_PROJ_SRCS_FUND
INSERT INTO ics_flow_icis.dbo.ics_proj_srcs_fund
     SELECT ics_proj_srcs_fund.*
       FROM ics_proj_srcs_fund
          JOIN ics_swms_4_prog_rep
            ON ics_proj_srcs_fund.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
       WHERE ics_swms_4_prog_rep.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'SWMS4ProgramReportSubmission');


-- Remove any old records for ics_cmpl_mon_lnk
-- /ICS_CMPL_MON_LNK/ICS_LNK_BS_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_bs_rep
 WHERE ics_lnk_bs_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_CAFO_ANNUL_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_cafo_annul_rep
 WHERE ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_CSO_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_cso_evt_rep
 WHERE ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_ENFRC_ACTN
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_enfrc_actn
 WHERE ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_FEDR_CMPL_MON
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_fedr_cmpl_mon
 WHERE ics_lnk_fedr_cmpl_mon.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_LOC_LMTS_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_loc_lmts_rep
 WHERE ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_PRETR_PERF_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_pretr_perf_rep
 WHERE ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SNGL_EVT
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sngl_evt
 WHERE ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_ANNUL_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sso_annul_rep
 WHERE ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sso_evt_rep
 WHERE ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_MONTHLY_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sso_monthly_evt_rep
 WHERE ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_ST_CMPL_MON
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_st_cmpl_mon
 WHERE ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SW_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sw_evt_rep
 WHERE ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK/ICS_LNK_SWMS_4_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_swms_4_rep
 WHERE ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);
-- /ICS_CMPL_MON_LNK
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
 WHERE ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id IN
          (SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             FROM ics_flow_icis.dbo.ics_cmpl_mon_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_cmpl_mon_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ComplianceMonitoringLinkageSubmission')
);

-- Add accepted records for ics_cmpl_mon_lnk
-- /ICS_CMPL_MON_LNK
INSERT INTO ics_flow_icis.dbo.ics_cmpl_mon_lnk
     SELECT ics_cmpl_mon_lnk.*
       FROM ics_cmpl_mon_lnk
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_BS_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_bs_rep
     SELECT ics_lnk_bs_rep.*
       FROM ics_lnk_bs_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_bs_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_CAFO_ANNUL_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_cafo_annul_rep
     SELECT ics_lnk_cafo_annul_rep.*
       FROM ics_lnk_cafo_annul_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_CSO_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_cso_evt_rep
     SELECT ics_lnk_cso_evt_rep.*
       FROM ics_lnk_cso_evt_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_ENFRC_ACTN
INSERT INTO ics_flow_icis.dbo.ics_lnk_enfrc_actn
     SELECT ics_lnk_enfrc_actn.*
       FROM ics_lnk_enfrc_actn
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_FEDR_CMPL_MON
INSERT INTO ics_flow_icis.dbo.ics_lnk_fedr_cmpl_mon
     SELECT ics_lnk_fedr_cmpl_mon.*
       FROM ics_lnk_fedr_cmpl_mon
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_fedr_cmpl_mon.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_LOC_LMTS_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_loc_lmts_rep
     SELECT ics_lnk_loc_lmts_rep.*
       FROM ics_lnk_loc_lmts_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_PRETR_PERF_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_pretr_perf_rep
     SELECT ics_lnk_pretr_perf_rep.*
       FROM ics_lnk_pretr_perf_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SNGL_EVT
INSERT INTO ics_flow_icis.dbo.ics_lnk_sngl_evt
     SELECT ics_lnk_sngl_evt.*
       FROM ics_lnk_sngl_evt
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_ANNUL_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_sso_annul_rep
     SELECT ics_lnk_sso_annul_rep.*
       FROM ics_lnk_sso_annul_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_sso_evt_rep
     SELECT ics_lnk_sso_evt_rep.*
       FROM ics_lnk_sso_evt_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_MONTHLY_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_sso_monthly_evt_rep
     SELECT ics_lnk_sso_monthly_evt_rep.*
       FROM ics_lnk_sso_monthly_evt_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_ST_CMPL_MON
INSERT INTO ics_flow_icis.dbo.ics_lnk_st_cmpl_mon
     SELECT ics_lnk_st_cmpl_mon.*
       FROM ics_lnk_st_cmpl_mon
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SW_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_sw_evt_rep
     SELECT ics_lnk_sw_evt_rep.*
       FROM ics_lnk_sw_evt_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');

-- /ICS_CMPL_MON_LNK/ICS_LNK_SWMS_4_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_swms_4_rep
     SELECT ics_lnk_swms_4_rep.*
       FROM ics_lnk_swms_4_rep
          JOIN ics_cmpl_mon_lnk
            ON ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
       WHERE ics_cmpl_mon_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ComplianceMonitoringLinkageSubmission');


-- Remove any old records for ics_enfrc_actn_viol_lnk
-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_CMPL_SCHD_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_schd_viol
 WHERE ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);
-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep_param_viol
 WHERE ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);
-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep_viol
 WHERE ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);
-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_PRMT_SCHD_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_schd_viol
 WHERE ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);
-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_SNGL_EVTS_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_sngl_evts_viol
 WHERE ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);
-- /ICS_ENFRC_ACTN_VIOL_LNK
DELETE
  FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
 WHERE ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id IN
          (SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_enfrc_actn_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'EnforcementActionViolationLinkageSubmission')
);

-- Add accepted records for ics_enfrc_actn_viol_lnk
-- /ICS_ENFRC_ACTN_VIOL_LNK
INSERT INTO ics_flow_icis.dbo.ics_enfrc_actn_viol_lnk
     SELECT ics_enfrc_actn_viol_lnk.*
       FROM ics_enfrc_actn_viol_lnk
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');

-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_CMPL_SCHD_VIOL
INSERT INTO ics_flow_icis.dbo.ics_cmpl_schd_viol
     SELECT ics_cmpl_schd_viol.*
       FROM ics_cmpl_schd_viol
          JOIN ics_enfrc_actn_viol_lnk
            ON ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');

-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
INSERT INTO ics_flow_icis.dbo.ics_dsch_mon_rep_param_viol
     SELECT ics_dsch_mon_rep_param_viol.*
       FROM ics_dsch_mon_rep_param_viol
          JOIN ics_enfrc_actn_viol_lnk
            ON ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');

-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
INSERT INTO ics_flow_icis.dbo.ics_dsch_mon_rep_viol
     SELECT ics_dsch_mon_rep_viol.*
       FROM ics_dsch_mon_rep_viol
          JOIN ics_enfrc_actn_viol_lnk
            ON ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');

-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_PRMT_SCHD_VIOL
INSERT INTO ics_flow_icis.dbo.ics_prmt_schd_viol
     SELECT ics_prmt_schd_viol.*
       FROM ics_prmt_schd_viol
          JOIN ics_enfrc_actn_viol_lnk
            ON ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');

-- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_SNGL_EVTS_VIOL
INSERT INTO ics_flow_icis.dbo.ics_sngl_evts_viol
     SELECT ics_sngl_evts_viol.*
       FROM ics_sngl_evts_viol
          JOIN ics_enfrc_actn_viol_lnk
            ON ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       WHERE ics_enfrc_actn_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'EnforcementActionViolationLinkageSubmission');


-- Remove any old records for ics_final_order_viol_lnk
-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_CMPL_SCHD_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_schd_viol
 WHERE ics_cmpl_schd_viol.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);
-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep_param_viol
 WHERE ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);
-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_dsch_mon_rep_viol
 WHERE ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);
-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_PRMT_SCHD_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_schd_viol
 WHERE ics_prmt_schd_viol.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);
-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_SNGL_EVTS_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_sngl_evts_viol
 WHERE ics_sngl_evts_viol.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);
-- /ICS_FINAL_ORDER_VIOL_LNK
DELETE
  FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
 WHERE ics_final_order_viol_lnk.ics_final_order_viol_lnk_id IN
          (SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             FROM ics_flow_icis.dbo.ics_final_order_viol_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_final_order_viol_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'FinalOrderViolationLinkageSubmission')
);

-- Add accepted records for ics_final_order_viol_lnk
-- /ICS_FINAL_ORDER_VIOL_LNK
INSERT INTO ics_flow_icis.dbo.ics_final_order_viol_lnk
     SELECT ics_final_order_viol_lnk.*
       FROM ics_final_order_viol_lnk
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');

-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_CMPL_SCHD_VIOL
INSERT INTO ics_flow_icis.dbo.ics_cmpl_schd_viol
     SELECT ics_cmpl_schd_viol.*
       FROM ics_cmpl_schd_viol
          JOIN ics_final_order_viol_lnk
            ON ics_cmpl_schd_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');

-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
INSERT INTO ics_flow_icis.dbo.ics_dsch_mon_rep_param_viol
     SELECT ics_dsch_mon_rep_param_viol.*
       FROM ics_dsch_mon_rep_param_viol
          JOIN ics_final_order_viol_lnk
            ON ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');

-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
INSERT INTO ics_flow_icis.dbo.ics_dsch_mon_rep_viol
     SELECT ics_dsch_mon_rep_viol.*
       FROM ics_dsch_mon_rep_viol
          JOIN ics_final_order_viol_lnk
            ON ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');

-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_PRMT_SCHD_VIOL
INSERT INTO ics_flow_icis.dbo.ics_prmt_schd_viol
     SELECT ics_prmt_schd_viol.*
       FROM ics_prmt_schd_viol
          JOIN ics_final_order_viol_lnk
            ON ics_prmt_schd_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');

-- /ICS_FINAL_ORDER_VIOL_LNK/ICS_SNGL_EVTS_VIOL
INSERT INTO ics_flow_icis.dbo.ics_sngl_evts_viol
     SELECT ics_sngl_evts_viol.*
       FROM ics_sngl_evts_viol
          JOIN ics_final_order_viol_lnk
            ON ics_sngl_evts_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       WHERE ics_final_order_viol_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'FinalOrderViolationLinkageSubmission');


-- Remove any old records for ics_schd_evt_viol
-- /ICS_SCHD_EVT_VIOL/ICS_CMPL_SCHD_EVT_VIOL_ELEM
DELETE
  FROM ics_flow_icis.dbo.ics_cmpl_schd_evt_viol_elem
 WHERE ics_cmpl_schd_evt_viol_elem.ics_schd_evt_viol_id IN
          (SELECT ics_schd_evt_viol.ics_schd_evt_viol_id
             FROM ics_flow_icis.dbo.ics_schd_evt_viol
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_schd_evt_viol.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ScheduleEventViolationSubmission')
);
-- /ICS_SCHD_EVT_VIOL/ICS_PRMT_SCHD_EVT_VIOL_ELEM
DELETE
  FROM ics_flow_icis.dbo.ics_prmt_schd_evt_viol_elem
 WHERE ics_prmt_schd_evt_viol_elem.ics_schd_evt_viol_id IN
          (SELECT ics_schd_evt_viol.ics_schd_evt_viol_id
             FROM ics_flow_icis.dbo.ics_schd_evt_viol
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_schd_evt_viol.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ScheduleEventViolationSubmission')
);
-- /ICS_SCHD_EVT_VIOL
DELETE
  FROM ics_flow_icis.dbo.ics_schd_evt_viol
 WHERE ics_schd_evt_viol.ics_schd_evt_viol_id IN
          (SELECT ics_schd_evt_viol.ics_schd_evt_viol_id
             FROM ics_flow_icis.dbo.ics_schd_evt_viol
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_schd_evt_viol.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'ScheduleEventViolationSubmission')
);

-- Add accepted records for ics_schd_evt_viol
-- /ICS_SCHD_EVT_VIOL
INSERT INTO ics_flow_icis.dbo.ics_schd_evt_viol
     SELECT ics_schd_evt_viol.*
       FROM ics_schd_evt_viol
       WHERE ics_schd_evt_viol.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ScheduleEventViolationSubmission');

-- /ICS_SCHD_EVT_VIOL/ICS_CMPL_SCHD_EVT_VIOL_ELEM
INSERT INTO ics_flow_icis.dbo.ics_cmpl_schd_evt_viol_elem
     SELECT ics_cmpl_schd_evt_viol_elem.*
       FROM ics_cmpl_schd_evt_viol_elem
          JOIN ics_schd_evt_viol
            ON ics_cmpl_schd_evt_viol_elem.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
       WHERE ics_schd_evt_viol.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ScheduleEventViolationSubmission');

-- /ICS_SCHD_EVT_VIOL/ICS_PRMT_SCHD_EVT_VIOL_ELEM
INSERT INTO ics_flow_icis.dbo.ics_prmt_schd_evt_viol_elem
     SELECT ics_prmt_schd_evt_viol_elem.*
       FROM ics_prmt_schd_evt_viol_elem
          JOIN ics_schd_evt_viol
            ON ics_prmt_schd_evt_viol_elem.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
       WHERE ics_schd_evt_viol.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'ScheduleEventViolationSubmission');


-- Remove any old records for ics_dmr_prog_rep_lnk
-- /ICS_DMR_PROG_REP_LNK/ICS_LNK_BS_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_bs_rep
 WHERE ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id IN
          (SELECT ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
             FROM ics_flow_icis.dbo.ics_dmr_prog_rep_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dmr_prog_rep_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DMRProgramReportLinkageSubmission')
);
-- /ICS_DMR_PROG_REP_LNK/ICS_LNK_SW_EVT_REP
DELETE
  FROM ics_flow_icis.dbo.ics_lnk_sw_evt_rep
 WHERE ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id IN
          (SELECT ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
             FROM ics_flow_icis.dbo.ics_dmr_prog_rep_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dmr_prog_rep_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DMRProgramReportLinkageSubmission')
);
-- /ICS_DMR_PROG_REP_LNK
DELETE
  FROM ics_flow_icis.dbo.ics_dmr_prog_rep_lnk
 WHERE ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id IN
          (SELECT ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
             FROM ics_flow_icis.dbo.ics_dmr_prog_rep_lnk
                 LEFT JOIN ics_subm_results ON ics_subm_results.key_hash = ics_dmr_prog_rep_lnk.key_hash 
              WHERE (result_type_code = 'Accepted' AND subm_type_name = 'DMRProgramReportLinkageSubmission')
);

-- Add accepted records for ics_dmr_prog_rep_lnk
-- /ICS_DMR_PROG_REP_LNK
INSERT INTO ics_flow_icis.dbo.ics_dmr_prog_rep_lnk
     SELECT ics_dmr_prog_rep_lnk.*
       FROM ics_dmr_prog_rep_lnk
       WHERE ics_dmr_prog_rep_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DMRProgramReportLinkageSubmission');

-- /ICS_DMR_PROG_REP_LNK/ICS_LNK_BS_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_bs_rep
     SELECT ics_lnk_bs_rep.*
       FROM ics_lnk_bs_rep
          JOIN ics_dmr_prog_rep_lnk
            ON ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
       WHERE ics_dmr_prog_rep_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DMRProgramReportLinkageSubmission');

-- /ICS_DMR_PROG_REP_LNK/ICS_LNK_SW_EVT_REP
INSERT INTO ics_flow_icis.dbo.ics_lnk_sw_evt_rep
     SELECT ics_lnk_sw_evt_rep.*
       FROM ics_lnk_sw_evt_rep
          JOIN ics_dmr_prog_rep_lnk
            ON ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
       WHERE ics_dmr_prog_rep_lnk.transaction_type NOT IN ('D','X')
        AND key_hash IN 
              (SELECT key_hash
                 FROM ics_subm_results
                WHERE result_type_code IN ('Accepted','Warning')
                  AND subm_type_name = 'DMRProgramReportLinkageSubmission');



--Step 4: Copy business keys where ICIS returnes error that key is already present in ICIS

  -- Add keys that already exist in ICIS for module ics_basic_prmt
  INSERT INTO ics_flow_icis.dbo.ics_basic_prmt (ics_payload_id, ics_basic_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='BasicPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'BP060'
          AND subm_type_name = 'BasicPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_basic_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_bs_prmt
  INSERT INTO ics_flow_icis.dbo.ics_bs_prmt (ics_payload_id, ics_bs_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='BiosolidsPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'BiosolidsPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_bs_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_cafo_prmt
  INSERT INTO ics_flow_icis.dbo.ics_cafo_prmt (ics_payload_id, ics_cafo_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='CAFOPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'CAFOPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_cafo_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_cso_prmt
  INSERT INTO ics_flow_icis.dbo.ics_cso_prmt (ics_payload_id, ics_cso_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='CSOPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'CSOPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_cso_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_gnrl_prmt
  INSERT INTO ics_flow_icis.dbo.ics_gnrl_prmt (ics_payload_id, ics_gnrl_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='GeneralPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'BP060'
          AND subm_type_name = 'GeneralPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_gnrl_prmt)
     GROUP BY prmt_ident, key_hash;
     
  -- Add keys that already exist in ICIS for module ics_master_gnrl_prmt
  INSERT INTO ics_flow_icis.dbo.ics_master_gnrl_prmt (ics_payload_id, ics_master_gnrl_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='MasterGeneralPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'MGP040'
          AND subm_type_name = 'MasterGeneralPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_master_gnrl_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_prmt_track_evt
  INSERT INTO ics_flow_icis.dbo.ics_prmt_track_evt (ics_payload_id, ics_prmt_track_evt_id, prmt_ident,  prmt_track_evt_code,  prmt_track_evt_date, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='PermitTrackingEventSubmission') as payload_id, NEWID(), prmt_ident,  prmt_track_evt_code,  prmt_track_evt_date, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PTE030'
          AND subm_type_name = 'PermitTrackingEventSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_prmt_track_evt)
     GROUP BY prmt_ident,  prmt_track_evt_code,  prmt_track_evt_date, key_hash;

  -- Add keys that already exist in ICIS for module ics_potw_prmt
  INSERT INTO ics_flow_icis.dbo.ics_potw_prmt (ics_payload_id, ics_potw_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='POTWPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'POTWPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_potw_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_pretr_prmt
  INSERT INTO ics_flow_icis.dbo.ics_pretr_prmt (ics_payload_id, ics_pretr_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='PretreatmentPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'PretreatmentPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_pretr_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_sw_cnst_prmt
  INSERT INTO ics_flow_icis.dbo.ics_sw_cnst_prmt (ics_payload_id, ics_sw_cnst_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='SWConstructionPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'SWConstructionPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_sw_cnst_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_sw_indst_prmt
  INSERT INTO ics_flow_icis.dbo.ics_sw_indst_prmt (ics_payload_id, ics_sw_indst_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='SWIndustrialPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'SWIndustrialPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_sw_indst_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_swms_4_large_prmt
  INSERT INTO ics_flow_icis.dbo.ics_swms_4_large_prmt (ics_payload_id, ics_swms_4_large_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='SWMS4LargePermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'SWMS4LargePermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_swms_4_large_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_swms_4_small_prmt
  INSERT INTO ics_flow_icis.dbo.ics_swms_4_small_prmt (ics_payload_id, ics_swms_4_small_prmt_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='SWMS4SmallPermitSubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PC040'
          AND subm_type_name = 'SWMS4SmallPermitSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_swms_4_small_prmt)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_unprmt_fac
  INSERT INTO ics_flow_icis.dbo.ics_unprmt_fac (ics_payload_id, ics_unprmt_fac_id, prmt_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='UnpermittedFacilitySubmission') as payload_id, NEWID(), prmt_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'UPF060'
          AND subm_type_name = 'UnpermittedFacilitySubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_unprmt_fac)
     GROUP BY prmt_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_prmt_featr
  INSERT INTO ics_flow_icis.dbo.ics_prmt_featr (ics_payload_id, ics_prmt_featr_id, prmt_ident,  prmt_featr_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='PermittedFeatureSubmission') as payload_id, NEWID(), prmt_ident,  prmt_featr_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'PF030'
          AND subm_type_name = 'PermittedFeatureSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_prmt_featr)
     GROUP BY prmt_ident,  prmt_featr_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_lmt_set
  INSERT INTO ics_flow_icis.dbo.ics_lmt_set (ics_payload_id, ics_lmt_set_id, prmt_ident,  prmt_featr_ident,  lmt_set_designator, LMT_SET_TYPE, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='LimitSetSubmission') as payload_id, NEWID(), prmt_ident,  prmt_featr_ident,  lmt_set_designator, 'S', key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'LS060'
          AND subm_type_name = 'LimitSetSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_lmt_set)
     GROUP BY prmt_ident,  prmt_featr_ident,  lmt_set_designator, key_hash;

  -- Add keys that already exist in ICIS for module ics_lmts
  INSERT INTO ics_flow_icis.dbo.ics_lmts (ics_payload_id, ics_lmts_id, prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='LimitsSubmission') as payload_id, NEWID(), prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'LTS050'
          AND subm_type_name = 'LimitsSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_lmts)
     GROUP BY prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date, key_hash;

  -- Add keys that already exist in ICIS for module ics_cmpl_mon
  INSERT INTO ics_flow_icis.dbo.ics_cmpl_mon (ics_payload_id, ics_cmpl_mon_id, cmpl_mon_ident, prmt_ident,  cmpl_mon_catg_code,  cmpl_mon_date, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='ComplianceMonitoringSubmission') as payload_id, NEWID(), cmpl_mon_ident, prmt_ident,  cmpl_mon_catg_code,  cmpl_mon_date, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'CM432'
          AND subm_type_name = 'ComplianceMonitoringSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_cmpl_mon)
     GROUP BY cmpl_mon_ident, prmt_ident, cmpl_mon_catg_code, cmpl_mon_date, key_hash;

  -- Add keys that already exist in ICIS for module ics_efflu_trade_prtner
  INSERT INTO ics_flow_icis.dbo.ics_efflu_trade_prtner (ics_payload_id, ics_efflu_trade_prtner_id, prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date,  lmt_mod_effective_date,  trade_id, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='EffluentTradePartnerSubmission') as payload_id, NEWID(), prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date,  lmt_mod_effective_date,  trade_id, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'ETP030'
          AND subm_type_name = 'EffluentTradePartnerSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_efflu_trade_prtner)
     GROUP BY prmt_ident,  prmt_featr_ident,  lmt_set_designator,  param_code,  mon_site_desc_code,  lmt_season_num,  lmt_start_date,  lmt_end_date,  lmt_mod_effective_date,  trade_id, key_hash;

  -- Add keys that already exist in ICIS for module ics_frml_enfrc_actn
  INSERT INTO ics_flow_icis.dbo.ics_frml_enfrc_actn (ics_payload_id, ics_frml_enfrc_actn_id, enfrc_actn_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='FormalEnforcementActionSubmission') as payload_id, NEWID(), enfrc_actn_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'FEA030'
          AND subm_type_name = 'FormalEnforcementActionSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_frml_enfrc_actn)
     GROUP BY enfrc_actn_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_infrml_enfrc_actn
  INSERT INTO ics_flow_icis.dbo.ics_infrml_enfrc_actn (ics_payload_id, ics_infrml_enfrc_actn_id, enfrc_actn_ident, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='InformalEnforcementActionSubmission') as payload_id, NEWID(), enfrc_actn_ident, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code IN ('IEA030','FEA030') --added FEA030 because ICIS returns wrong error code in this case 12/27/2012 BRensmith
          AND subm_type_name = 'InformalEnforcementActionSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_infrml_enfrc_actn)
     GROUP BY enfrc_actn_ident, key_hash;

  -- Add keys that already exist in ICIS for module ics_sngl_evt_viol
  INSERT INTO ics_flow_icis.dbo.ics_sngl_evt_viol (ics_payload_id, ics_sngl_evt_viol_id, prmt_ident,  sngl_evt_viol_code,  sngl_evt_viol_date, key_hash, data_hash)
       SELECT (SELECT ics_payload_id FROM ics_payload WHERE operation='SingleEventViolationSubmission') as payload_id, NEWID(), prmt_ident,  sngl_evt_viol_code,  sngl_evt_viol_date, key_hash, '0' as data_hash
         FROM ics_subm_results
        WHERE result_code = 'SEV030'
          AND subm_type_name = 'SingleEventViolationSubmission'
          AND subm_transaction_id = @p_transaction_id
          AND key_hash NOT IN (SELECT key_hash FROM ics_flow_icis.dbo.ics_sngl_evt_viol)
     GROUP BY prmt_ident,  sngl_evt_viol_code,  sngl_evt_viol_date, key_hash;

--Step 5: Record counts into ICS_SUBM_HIST

INSERT INTO ics_subm_hist (
       ics_subm_hist_id
     , subm_date_time
     , subm_transaction_id
     , subm_type_name
     , trans_count_new
     , trans_count_chng_repl
     , trans_count_del_mass_del
     , error_count
     , warning_count
     , accepted_count
     , accepted_count_total
     , created_date_time)
SELECT NEWID() AS ics_subm_hist_id
     , (SELECT subm_date_time FROM ics_subm_track WHERE subm_transaction_id = @p_transaction_id) as subm_date_time
     , @p_transaction_id 
     , operation
     , ISNULL(trans_count_new, 0)
     , ISNULL(trans_count_chng_repl, 0)
     , ISNULL(trans_count_del_mass_del, 0)
     , error_count
     , warning_count
     , accepted_count
     , ISNULL(accepted_count_total, 0)
     , GETDATE() AS created_date_time
  FROM ics_v_module_count;

GO

