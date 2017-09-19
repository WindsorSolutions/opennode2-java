IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICS_CHANGE_DETECTION') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.ICS_CHANGE_DETECTION
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
/******************************************************************************************************************************
** ObjectName: ICS_CHANGE_DETECTION
**
** Author: Windsor Solutions, Inc.
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This procedure will detect data changes made within the ICIS 5.8 schema and then sets the transaction type
**               flags so the data can be bundled and submitted to an exchange partner.
**
** Inputs:  -- NA --  
**
**
** Revision History:      
** ----------------------------------------------------------------------------------------------------------------------------
**  Date         Analyst     Description
** ----------------------------------------------------------------------------------------------------------------------------
** 06/12/2017  Windsor      Baselined from v5.6 procedure. 
** 06/30/2017  Chris Tyler  Made key_hash calculation consistent on links
** 07/10/2017  Chris Tyler  Added marker for copy to ICS_SET_DATA_HASH
******************************************************************************************************************************/
CREATE PROCEDURE dbo.ICS_CHANGE_DETECTION AS

SET NOCOUNT ON;

DECLARE @v_sql_statement AS NVARCHAR(4000);
DECLARE @v_sql_param AS NVARCHAR(100);
DECLARE @p_payload_type AS NVARCHAR(50); 

/* Working Hash Variables */
--DECLARE @v_data_hash AS VARCHAR(100);
DECLARE @v_key_hash AS VARCHAR(100);
DECLARE @v_all_data_hashes AS VARCHAR(100);  
DECLARE @v_hashed_data_hashes AS VARCHAR(100); 
DECLARE @v_enabled AS CHAR(1);
DECLARE @v_working_data_hash AS VARCHAR(100);
   
DECLARE payload_type_delete CURSOR 
    FOR SELECT DISTINCT child_table.name child_table_name 
          FROM sys.foreign_key_columns
          JOIN sys.objects child_table
            ON (child_table.object_id = sys.foreign_key_columns.parent_object_id)
          JOIN sys.objects parent_table
            ON (parent_table.object_id = sys.foreign_key_columns.referenced_object_id)
          JOIN sys.schemas
            ON (parent_table.schema_id = sys.schemas.schema_id)    
         WHERE sys.schemas.name = 'dbo'
           AND parent_table.name = 'ICS_PAYLOAD'
         ORDER BY child_table.name;        
         
DECLARE payload_type_process CURSOR 
    FOR SELECT DISTINCT child_table.name child_table_name 
          FROM sys.foreign_key_columns
          JOIN sys.objects child_table
            ON (child_table.object_id = sys.foreign_key_columns.parent_object_id)
          JOIN sys.objects parent_table
            ON (parent_table.object_id = sys.foreign_key_columns.referenced_object_id)
          JOIN sys.schemas
            ON (parent_table.schema_id = sys.schemas.schema_id)    
         WHERE sys.schemas.name = 'dbo'
           AND parent_table.name = 'ICS_PAYLOAD'
           /* The tables in this list will not have related child data, change processing can be skipped */
           AND child_table.name NOT IN ( 'ICS_BS_PROG_REP'
                                       , 'ICS_CSO_EVT_REP'
                                       , 'ICS_DMR_VIOL'
                                       , 'ICS_ENFRC_ACTN_MILESTONE'
                                       , 'ICS_HIST_PRMT_SCHD_EVTS'
                                       , 'ICS_PRMT_REISSU'
                                       , 'ICS_PRMT_TRACK_EVT'
                                       , 'ICS_PRMT_TERM'
                                       , 'ICS_SCHD_EVT_VIOL'
                                       , 'ICS_SNGL_EVT_VIOL'
                                       , 'ICS_SSO_ANNUL_REP'
                                       , 'ICS_SSO_MONTHLY_EVT_REP'
                                       , 'ICS_SW_INDST_ANNUL_REP')
         ORDER BY child_table.name; 
          
                        
DECLARE key_hash CURSOR 
    FOR SELECT key_hash 
          FROM dbo.ics_key_hash;
                        
BEGIN

 /*  Initialize working table ICS_KEY_HASH */
 DELETE FROM dbo.ics_key_hash;
 
 /*  
  * Reset transaction_type on all payload tables  
  */
  OPEN payload_type_delete;
  
  --PRINT 'Change Detection: Begin setting key_hash and data_hash values at ' + CONVERT(VARCHAR(24),GETDATE(),113)

  /*  Fetch 1st payload type record */
  FETCH NEXT FROM payload_type_delete INTO @p_payload_type;
  WHILE @@FETCH_STATUS = 0
    BEGIN

      /* For each payload type, remove all the transaction codes from the previous run. */
      SET @v_sql_statement = 'UPDATE dbo.' + @p_payload_type + ' SET TRANSACTION_TYPE = NULL , TRANSACTION_TIMESTAMP = NULL';
      EXECUTE sp_executesql @v_sql_statement;
    
      -- Get the payload type.
      FETCH NEXT FROM payload_type_delete 
      INTO @p_payload_type;

    END;

   CLOSE payload_type_delete;
   
-- -=-=-=-=-=-=- START COPY TO INDICATED SECTION IN ICS_SET_HASHES -=-=-=-=-=-=-=-=-=
  /*************************************************/  
  /* START - Set all KEY_HASH and DATA_HASH fields */
  /*************************************************/  

UPDATE dbo.ics_subsctor_code_plus_desc
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  subsctor_code_plus_desc
);

UPDATE dbo.ics_addr
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  affil_type_txt
	+ org_frml_name
	+ ISNULL(org_duns_num,'')
	+ mailing_addr_txt
	+ ISNULL(suppl_addr_txt,'')
	+ mailing_addr_city_name
	+ mailing_addr_st_code
	+ mailing_addr_zip_code
	+ ISNULL(county_name,'')
	+ ISNULL(mailing_addr_country_code,'')
	+ ISNULL(division_name,'')
	+ ISNULL(loc_province,'')
	+ ISNULL(elec_addr_txt,'')
	+ ISNULL(CONVERT(varchar(50), start_date_of_addr_assc),'')
	+ ISNULL(CONVERT(varchar(50), end_date_of_addr_assc),'')
);

-- 5.8
UPDATE DBO.ICS_ANLYTCL_METHOD 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
      + ISNULL(ANLYTCL_METHOD_TYPE_CODE,'')
      + ISNULL(ANLYTCL_METHOD_OTHR_TYPE_TXT,'')
   );

UPDATE dbo.ics_anml_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  anml_type_code
	+ ISNULL(othr_anml_type_name,'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_each_lvstck),'')
	+ ISNULL(CONVERT(varchar(50), open_confinemnt_cnt),'')
	+ ISNULL(CONVERT(varchar(50), housd_undr_roof_confinemnt_cnt),'')
);
UPDATE dbo.ics_assc_prmt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  assc_prmt_ident
	+ assc_prmt_reason_code
);
UPDATE dbo.ics_basic_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_basic_prmt.prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(prmt_type_code,'')
	+ ISNULL(agncy_type_code,'')
	+ ISNULL(prmt_stat_code,'')
	+ ISNULL(CONVERT(varchar(50), prmt_issue_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_effective_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_expr_date),'')
	+ ISNULL(reissu_prio_prmt_ind,'')
	+ ISNULL(backlog_reason_txt,'')
	+ ISNULL(prmt_issuing_org_type_name,'')
	+ ISNULL(prmt_appealed_ind,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_1_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_2_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_3_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_4_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_5_txt,'')
	+ ISNULL(prmt_cmnts_txt,'')
	+ ISNULL(CONVERT(varchar(50), major_minor_rating_code),'')
	+ ISNULL(major_minor_stat_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_minor_stat_start_date),'')
	+ ISNULL(CONVERT(varchar(50), ttl_appl_dsgn_flow_num),'')
	+ ISNULL(CONVERT(varchar(50), ttl_appl_aver_flow_num),'')
	+ ISNULL(CONVERT(varchar(50), appl_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_appl_cmpl_date),'')
	+ ISNULL(new_src_ind,'')
	+ ISNULL(prmt_st_wtr_body_code,'')
	+ ISNULL(prmt_st_wtr_body_name,'')
	+ ISNULL(fedr_grant_ind,'')
	+ ISNULL(dmr_cognznt_ofcl,'')
	+ ISNULL(dmr_cognznt_ofcl_teleph_num,'')
	+ ISNULL(dmr_non_rcpt_stat_ind,'')
	+ ISNULL(CONVERT(varchar(50), dmr_non_rcpt_stat_start_date),'')
	+ ISNULL(sig_iu_ind,'')
	+ ISNULL(rcvg_prmt_ident,'')
   -- 5.8
	+ ISNULL(CONVERT(varchar(50), ELEC_REP_WAIVER_EFFECTIVE_DATE),'')
	+ ISNULL(CONVERT(varchar(50), ELEC_REP_WAIVER_EXPR_DATE),'')
	+ ISNULL(ELEC_REP_WAIVER_TYPE_CODE,'')

);
UPDATE dbo.ics_bs_end_use_dspl_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  bs_end_use_dspl_type_code
);

-- 5.8
UPDATE DBO.ICS_BS_ANNUL_PROG_REP 
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1',prmt_ident + ISNULL(CONVERT(varchar(50),BS_ANNUL_REP_RCVD_DATE),''))
   , data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
      + ISNULL(ELEC_SUBM_TYPE_CODE,'')
      + ISNULL(ELEC_SUBM_TYPE_CODE,'')
       + ISNULL(CONVERT(varchar(50),REP_PERIOD_START_DATE),'')
       + ISNULL(CONVERT(varchar(50),REP_PERIOD_END_DATE),'')
       + ISNULL(TRTMNT_PRCSS_OTHR_TXT,'')
       + ISNULL(CONVERT(varchar(50),TTL_VOL_AMT),'')
       + ISNULL(BS_ADDL_INFO_CMNT_TXT,'')
   );

-- 5.8
UPDATE DBO.ICS_BS_MGMT_PRACTICES 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(SSU_IDENT,'')
       +  ISNULL(BS_MGMT_PRC_TYPE_CODE,'')
       +  ISNULL(HNDLR_PREPR_TYPE_CODE,'')
       +  ISNULL(LAND_APPL_SUB_CATG_CODE,'')
       +  ISNULL(OTHR_SUB_CATG_CODE,'')
       +  ISNULL(SUB_CATG_OTHR_TXT,'')
       +  ISNULL(BS_CNTNR_TYPE_CODE,'')
       +  ISNULL(CONVERT(varchar(50),VOL_AMT),'')
       +  ISNULL(PATHOGEN_CLASS_TYPE_CODE,'')
       +  ISNULL(POLUT_CONCEN_EXCEEDANCE_IND,'')
       +  ISNULL(POLUT_LOADING_R_EXCEEDANCE_IND,'')
       +  ISNULL(ACTIVE_DSPL_SITE_IND,'')
       +  ISNULL(SITE_SPEC_LMT_IND,'')
       +  ISNULL(MIN_BNDRY_DIST_IND,'')
       +  ISNULL(MIN_BNDRY_DIST_TYPE_CODE,'')
       +  ISNULL(ASSC_PRMT_IDENT,'')
       +  ISNULL(MGMT_PRC_CMNT_TXT,'')
   );   
   
UPDATE dbo.ics_bs_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_bs_prmt.prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(CONVERT(varchar(50), eq_prod_dist_marketed_amt),'')
	+ ISNULL(CONVERT(varchar(50), land_applied_amt),'')
	+ ISNULL(CONVERT(varchar(50), incinerated_amt),'')
	+ ISNULL(CONVERT(varchar(50), codisposed_in_msw_landfill_amt),'')
	+ ISNULL(CONVERT(varchar(50), surf_dspl_amt),'')
	+ ISNULL(CONVERT(varchar(50), mnged_othr_mthds_amt),'')
	+ ISNULL(CONVERT(varchar(50), rcvd_offsite_srcs_amt),'')
	+ ISNULL(CONVERT(varchar(50), transferred_amt),'')
	+ ISNULL(CONVERT(varchar(50), disposed_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), benef_used_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), mnged_othr_mthds_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), ttl_removed_amt),'')
	+ ISNULL(CONVERT(varchar(50), annul_dry_sldg_prod_num),'')
);
UPDATE dbo.ics_bs_prog_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_bs_prog_rep.prmt_ident +CONVERT(varchar(50), rep_coverage_end_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), rep_coverage_end_date)
	+ ISNULL(CONVERT(varchar(50), num_of_rep_units),'')
	+ ISNULL(CONVERT(varchar(50), eq_prod_dist_marketed_amt),'')
	+ ISNULL(CONVERT(varchar(50), land_applied_amt),'')
	+ ISNULL(CONVERT(varchar(50), incinerated_amt),'')
	+ ISNULL(CONVERT(varchar(50), codisposed_in_msw_landfill_amt),'')
	+ ISNULL(CONVERT(varchar(50), surf_dspl_amt),'')
	+ ISNULL(CONVERT(varchar(50), mnged_othr_mthds_amt),'')
	+ ISNULL(CONVERT(varchar(50), rcvd_offsite_srcs_amt),'')
	+ ISNULL(CONVERT(varchar(50), transferred_amt),'')
	+ ISNULL(CONVERT(varchar(50), disposed_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), benef_used_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), mnged_othr_mthds_out_of_st_amt),'')
	+ ISNULL(CONVERT(varchar(50), ttl_removed_amt),'')
	+ ISNULL(CONVERT(varchar(50), annul_dry_sldg_prod_num),'')
	+ ISNULL(CONVERT(varchar(50), annul_loading_param_date),'')
	+ ISNULL(CONVERT(varchar(50), annul_loading_bs_gal),'')
	+ ISNULL(CONVERT(varchar(50), annul_loading_bs_dmt),'')
	+ ISNULL(CONVERT(varchar(50), annul_loading_nutr_nitrogen),'')
	+ ISNULL(CONVERT(varchar(50), annul_loading_nutr_phosph),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_land_appl_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_incin_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_dist_marketing_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_sldg_rlt_mgmt_prc_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_surf_dspl_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_othr_sldg_viol),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_codisposal_viol),'')
	+ ISNULL(bs_rep_cmnts,'')
);
UPDATE dbo.ics_bs_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  bs_type_code
);

UPDATE dbo.ics_cafo_annul_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_cafo_annul_rep.prmt_ident +CONVERT(varchar(50), prmt_auth_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_auth_rep_rcvd_date)
	+ ISNULL(dsch_drng_year_prod_area_ind,'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_trans_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_trans_amt),'')
	+ ISNULL(nmp_dvlpd_cert_plnr_aprvd_ind,'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_acres_nmp_idntfd),'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_acres_used_land_appl),'')
);
UPDATE dbo.ics_cafo_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(cafo_class_code,'')
	+ ISNULL(is_anml_fac_type_cafo_ind,'')
	+ ISNULL(CONVERT(varchar(50), cafo_desgn_date),'')
	+ ISNULL(cafo_desgn_reason_txt,'')
	+ ISNULL(dsch_drng_year_prod_area_ind,'')
	+ ISNULL(CONVERT(varchar(50), num_acres_contrb_drain),'')
	+ ISNULL(CONVERT(varchar(50), appl_meas_avail_land_num),'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_trans_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_trans_amt),'')
	+ ISNULL(nmp_dvlpd_cert_plnr_aprvd_ind,'')
	+ ISNULL(CONVERT(varchar(50), nmp_dvlpd_date),'')
	+ ISNULL(CONVERT(varchar(50), nmp_last_updated_date),'')
	+ ISNULL(envr_mgmt_systm_ind,'')
	+ ISNULL(CONVERT(varchar(50), ems_dvlpd_date),'')
	+ ISNULL(CONVERT(varchar(50), ems_last_updated_date),'')
	+ ISNULL(CONVERT(varchar(50), lvstck_max_cpcty_num),'')
	+ ISNULL(CONVERT(varchar(50), lvstck_cpcty_dtrmn_bs_upon_num),'')
	+ ISNULL(CONVERT(varchar(50), auth_lvstck_cpcty_num),'')
);
UPDATE dbo.ics_cafo_insp_viol_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  cafo_insp_viol_type_code
);
UPDATE dbo.ics_cafo_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_cafo_prmt.prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(cafo_class_code,'')
	+ ISNULL(is_anml_fac_type_cafo_ind,'')
	+ ISNULL(CONVERT(varchar(50), cafo_desgn_date),'')
	+ ISNULL(cafo_desgn_reason_txt,'')
	+ ISNULL(CONVERT(varchar(50), num_acres_contrb_drain),'')
	+ ISNULL(CONVERT(varchar(50), appl_meas_avail_land_num),'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_gnrtd_amt),'')
	+ ISNULL(CONVERT(varchar(50), solid_mnur_lttr_trans_amt),'')
	+ ISNULL(CONVERT(varchar(50), liquid_mnur_ww_trans_amt),'')
	+ ISNULL(nmp_dvlpd_cert_plnr_aprvd_ind,'')
	+ ISNULL(CONVERT(varchar(50), nmp_dvlpd_date),'')
	+ ISNULL(CONVERT(varchar(50), nmp_last_updated_date),'')
	+ ISNULL(envr_mgmt_systm_ind,'')
	+ ISNULL(CONVERT(varchar(50), ems_dvlpd_date),'')
	+ ISNULL(CONVERT(varchar(50), ems_last_updated_date),'')
	+ ISNULL(CONVERT(varchar(50), lvstck_max_cpcty_num),'')
	+ ISNULL(CONVERT(varchar(50), lvstck_cpcty_dtrmn_bs_upon_num),'')
	+ ISNULL(CONVERT(varchar(50), auth_lvstck_cpcty_num),'')
	+ ISNULL(legal_desc_txt,'')
);
UPDATE dbo.ics_sw_indst_annul_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_sw_indst_annul_rep.prmt_ident +CONVERT(varchar(50), indst_sw_annul_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), indst_sw_annul_rep_rcvd_date)
	+ ISNULL(CONVERT(varchar(50), fac_insp_summ_txt),'')
	+ ISNULL(CONVERT(varchar(50), visual_assessment_summ_txt),'')
	+ ISNULL(CONVERT(varchar(50), no_further_reduction_summ_txt),'')
	+ ISNULL(CONVERT(varchar(50), corr_actn_summ_txt),'')
);
UPDATE dbo.ics_cmpl_insp_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  cmpl_insp_type_code
);
UPDATE dbo.ics_cmpl_mon
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', cmpl_mon_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
   prmt_ident
	+ ISNULL(cmpl_mon_acty_type_code,'')  --  5.6
	+ ISNULL(cmpl_mon_catg_code,'')
	+ CONVERT(varchar(50), cmpl_mon_date)
	+ ISNULL(CONVERT(varchar(50), cmpl_mon_start_date),'')
	+ ISNULL(cmpl_mon_acty_name,'')
	+ ISNULL(biomon_insp_method,'')
	+ ISNULL(CONVERT(varchar(50), cmpl_mon_agncy_code),'')
	+ ISNULL(st_statute_viol_name,'')
	+ ISNULL(epa_assist_ind,'')
	+ ISNULL(st_fedr_joint_ind,'')
	+ ISNULL(joint_insp_reason_code,'')
	+ ISNULL(lead_party,'')
	+ ISNULL(CONVERT(varchar(50), num_days_phys_cond_acty),'')
	+ ISNULL(CONVERT(varchar(50), num_hours_phys_cond_acty),'')
	+ ISNULL(CONVERT(varchar(50), cmpl_mon_actn_outcome_code),'')
	+ ISNULL(insp_rating_code,'')
	+ ISNULL(multimedia_ind,'')
	+ ISNULL(fedr_fac_ind,'')
	+ ISNULL(fedr_fac_ind_cmnt,'')
	+ ISNULL(insp_usr_dfnd_fld_1,'')
	+ ISNULL(insp_usr_dfnd_fld_2,'')
	+ ISNULL(insp_usr_dfnd_fld_3,'')
	+ ISNULL(CONVERT(varchar(50), insp_usr_dfnd_fld_4),'')
	+ ISNULL(CONVERT(varchar(50), insp_usr_dfnd_fld_5),'')
	+ ISNULL(insp_usr_dfnd_fld_6,'')
	+ ISNULL(insp_cmnt_txt,'')
   -- 5.8
	+ ISNULL(CONVERT(varchar(50), CMPL_MON_PLANNED_END_DATE),'')
	+ ISNULL(CONVERT(varchar(50), CMPL_MON_PLANNED_START_DATE),'')
   
);
-- 5.8
UPDATE DBO.ICS_CNST_SITE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
      ISNULL(CNST_SITE_CODE,'')
   );

--  5.6
UPDATE dbo.ics_prog_defcy_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1',
    ISNULL(prog_defcy_type_code,'')
);
UPDATE dbo.ics_cmpl_mon_actn_reason
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  cmpl_mon_actn_reason_code
);
UPDATE dbo.ics_cmpl_mon_agncy_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  cmpl_mon_agncy_type_code
);
UPDATE dbo.ics_cmpl_mon_lnk
 -- Root table has conditional key, skipping key_hash creation here, will do further down though... keep going.
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
     cmpl_mon_ident
	--  prmt_ident
	--+ cmpl_mon_catg_code
	--+ CONVERT(varchar(50), cmpl_mon_date)
);
UPDATE dbo.ics_cmpl_schd
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_cmpl_schd.enfrc_actn_ident +CONVERT(varchar(50), final_order_ident) + prmt_ident +CONVERT(varchar(50), cmpl_schd_num)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ ISNULL(CONVERT(varchar(50), final_order_ident),'')
	+ prmt_ident
	+ CONVERT(varchar(50), cmpl_schd_num)
	+ ISNULL(cmpl_schd_cmnts,'')
	+ ISNULL(schd_desc_code,'')
);
UPDATE dbo.ics_cmpl_schd_evt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  schd_evt_code
	+ CONVERT(varchar(50), schd_date)
	+ ISNULL(CONVERT(varchar(50), schd_rep_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_actul_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_proj_date),'')
	+ ISNULL(schd_usr_dfnd_dat_elm_1,'')
	+ ISNULL(schd_usr_dfnd_dat_elm_2,'')
	+ ISNULL(schd_evt_cmnts,'')
	+ ISNULL(CONVERT(varchar(50), cmpl_schd_pnlty_amt),'')
);
UPDATE dbo.ics_cmpl_schd_evt_viol_elem
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ CONVERT(varchar(50), final_order_ident)
	+ prmt_ident
	+ CONVERT(varchar(50), cmpl_schd_num)
	+ schd_evt_code
	+ CONVERT(varchar(50), schd_date)
	+ schd_viol_code
);
UPDATE dbo.ics_cmpl_schd_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ ISNULL(CONVERT(varchar(50), final_order_ident),'')
	+ prmt_ident
	+ CONVERT(varchar(50), cmpl_schd_num)
	+ schd_evt_code
	+ CONVERT(varchar(50), schd_date)
);
UPDATE dbo.ics_cmpl_track_stat
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(stat_code,'')
	+ ISNULL(CONVERT(varchar(50), stat_start_date),'')
	+ ISNULL(stat_reason,'')
);
UPDATE dbo.ics_co_dspl_site
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(part_258_cmpl_ind,'')
	+ ISNULL(paint_filter_test_result,'')
	+ ISNULL(tclp_test_result,'')
);
UPDATE dbo.ics_contact
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  affil_type_txt
	+ first_name
	+ ISNULL(middle_name,'')
	+ last_name
	+ indvl_title_txt
	+ ISNULL(org_frml_name,'')
	+ ISNULL(st_code,'')
	+ ISNULL(rgn_code,'')
	+ ISNULL(elec_addr_txt,'')
	+ ISNULL(CONVERT(varchar(50), start_date_of_contact_assc),'')
	+ ISNULL(CONVERT(varchar(50), end_date_of_contact_assc),'')
);
UPDATE dbo.ics_containment
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  containment_type_code
	+ ISNULL(othr_containment_type_name,'')
	+ ISNULL(CONVERT(varchar(50), containment_cpcty_num),'')
);
UPDATE dbo.ics_crop_types_harvested
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  crop_types_harvested
);
UPDATE dbo.ics_crop_types_planted
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  crop_types_planted
);
UPDATE dbo.ics_cso_evt_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_cso_evt_rep.prmt_ident +CONVERT(varchar(50), cso_evt_date) + CONVERT(varchar(50), cso_evt_id)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(dry_or_wet_weather_ind,'')
	+ ISNULL(prmt_featr_ident,'')
	+ ISNULL(CONVERT(varchar(50), lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), long_meas),'')
	+ ISNULL(cso_ovrflw_loc_street,'')
	+ ISNULL(CONVERT(varchar(50), duration_cso_ovrflw_evt),'')
	+ ISNULL(CONVERT(varchar(50), dsch_vol_treated),'')
	+ ISNULL(CONVERT(varchar(50), dsch_vol_untreated),'')
	+ ISNULL(corr_actn_taken_desc_txt,'')
	+ ISNULL(CONVERT(varchar(50), inches_precip),'')
);
UPDATE dbo.ics_cso_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), cso_evt_date),'')
	+ ISNULL(dry_or_wet_weather_ind,'')
	+ ISNULL(prmt_featr_ident,'')
	+ ISNULL(CONVERT(varchar(50), lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), long_meas),'')
	+ ISNULL(cso_ovrflw_loc_street,'')
	+ ISNULL(CONVERT(varchar(50), duration_cso_ovrflw_evt),'')
	+ ISNULL(CONVERT(varchar(50), dsch_vol_treated),'')
	+ ISNULL(CONVERT(varchar(50), dsch_vol_untreated),'')
	+ ISNULL(corr_actn_taken_desc_txt,'')
	+ ISNULL(CONVERT(varchar(50), inches_precip),'')
);
UPDATE dbo.ics_cso_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_cso_prmt.prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(CONVERT(varchar(50), css_popl_served_num),'')
	+ ISNULL(combined_sewer_systm_length,'')
	+ ISNULL(CONVERT(varchar(50), coll_systm_combined_percent),'')
);
UPDATE dbo.ics_dmr_prog_rep_lnk
 -- Root table has conditional key, skipping key_hash creation here, will do further down though... keep going.
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ CONVERT(varchar(50), mon_period_end_date)
);
UPDATE dbo.ics_dmr_viol
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_dmr_viol.prmt_ident + prmt_featr_ident + lmt_set_designator +CONVERT(varchar(50), mon_period_end_date) + param_code + mon_site_desc_code +CONVERT(varchar(50), lmt_season_num) +CONVERT(varchar(50), num_rep_code) +CONVERT(varchar(50), num_rep_viol_code)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ CONVERT(varchar(50), mon_period_end_date)
	+ param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
	+ num_rep_code
	+ num_rep_viol_code
	+ ISNULL(rep_non_cmpl_detect_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_non_cmpl_detect_date),'')
	+ ISNULL(rep_non_cmpl_resl_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_non_cmpl_resl_date),'')
);
UPDATE dbo.ics_dsch_mon_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_dsch_mon_rep.prmt_ident + prmt_featr_ident + lmt_set_designator +CONVERT(varchar(50), mon_period_end_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ CONVERT(varchar(50), mon_period_end_date)
	+ ISNULL(CONVERT(varchar(50), sign_date),'')
	+ ISNULL(prncpl_exec_offcr_first_name,'')
	+ ISNULL(prncpl_exec_offcr_last_name,'')
	+ ISNULL(prncpl_exec_offcr_title,'')
	+ ISNULL(prncpl_exec_offcr_teleph,'')
	+ ISNULL(sign_first_name,'')
	+ ISNULL(sign_last_name,'')
	+ ISNULL(sign_teleph,'')
	+ ISNULL(rep_cmnt_txt,'')
	+ ISNULL(dmr_no_dsch_ind,'')
	+ ISNULL(CONVERT(varchar(50), dmr_no_dsch_rcvd_date),'')
	+ ISNULL(ELEC_SUBM_TYPE_CODE,'')
);
UPDATE dbo.ics_dsch_mon_rep_param_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ CONVERT(varchar(50), mon_period_end_date)
	+ param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
);
UPDATE dbo.ics_dsch_mon_rep_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ CONVERT(varchar(50), mon_period_end_date)
);
UPDATE dbo.ics_efflu_guide
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  efflu_guide_code
);
UPDATE dbo.ics_efflu_trade_prtner
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_efflu_trade_prtner.prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code +CONVERT(varchar(50), lmt_season_num) +CONVERT(varchar(50), lmt_start_date) +CONVERT(varchar(50), lmt_end_date) +CONVERT(varchar(50), lmt_mod_effective_date) + trade_id),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
	+ CONVERT(varchar(50), lmt_start_date)
	+ CONVERT(varchar(50), lmt_end_date)
	+ ISNULL(CONVERT(varchar(50), lmt_mod_effective_date),'')
	+ ISNULL(trade_prtner_npdesid,'')
	+ ISNULL(trade_prtner_type,'')
	+ ISNULL(CONVERT(varchar(50), trade_prtner_start_date),'')
	+ ISNULL(CONVERT(varchar(50), trade_prtner_end_date),'')
);
UPDATE dbo.ics_efflu_trade_prtner_addr
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(org_frml_name,'')
	+ ISNULL(org_duns_num,'')
	+ ISNULL(loc_name,'')
	+ ISNULL(mailing_addr_txt,'')
	+ ISNULL(suppl_addr_txt,'')
	+ ISNULL(mailing_addr_city_name,'')
	+ ISNULL(mailing_addr_country_code,'')
	+ ISNULL(loc_province,'')
	+ ISNULL(mailing_addr_st_code,'')
	+ ISNULL(mailing_addr_zip_code,'')
	+ ISNULL(county_name,'')
	+ ISNULL(division_name,'')
	+ ISNULL(elec_addr_txt,'')
);
UPDATE dbo.ics_enfrc_actn_gov_contact
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  affil_type_txt
	+ ISNULL(elec_addr_txt,'')
	+ ISNULL(CONVERT(varchar(50), start_date_of_contact_assc),'')
	+ ISNULL(CONVERT(varchar(50), end_date_of_contact_assc),'')
);
UPDATE dbo.ics_enfrc_actn_milestone
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident + milestone_type_code),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ milestone_type_code
	+ ISNULL(CONVERT(varchar(50), milestone_planned_date),'')
	+ ISNULL(CONVERT(varchar(50), milestone_actul_date),'')
);
UPDATE dbo.ics_enfrc_actn_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_type_code
);
UPDATE dbo.ics_enfrc_actn_viol_lnk
 -- Root table has conditional key, skipping key_hash creation here, will do further down though... keep going.
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
);
UPDATE dbo.ics_enfrc_agncy
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_agncy_type_code
	+ agncy_lead_ind
);
UPDATE dbo.ics_fac
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(fac_site_name,'')
	+ ISNULL(loc_addr_txt,'')
	+ ISNULL(suppl_loc_txt,'')
	+ ISNULL(locality_name,'')
	+ ISNULL(loc_st_code,'')
	+ ISNULL(loc_zip_code,'')
	+ ISNULL(loc_country_code,'')
	+ ISNULL(org_duns_num,'')
	+ ISNULL(st_fac_ident,'')
	+ ISNULL(st_rgn_code,'')
	+ ISNULL(CONVERT(varchar(50), fac_congr_district_num),'')
	+ ISNULL(fac_type_of_ownership_code,'')
	+ ISNULL(fedr_fac_ident_num,'')
	+ ISNULL(fedr_agncy_code,'')
	+ ISNULL(tribal_land_code,'')
	+ ISNULL(cnst_proj_name,'')
	+ ISNULL(CONVERT(varchar(50), cnst_proj_lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), cnst_proj_long_meas),'')
	+ ISNULL(section_township_rng,'')
	+ ISNULL(fac_cmnts,'')
	+ ISNULL(fac_usr_dfnd_fld_1,'')
	+ ISNULL(fac_usr_dfnd_fld_2,'')
	+ ISNULL(fac_usr_dfnd_fld_3,'')
	+ ISNULL(fac_usr_dfnd_fld_4,'')
	+ ISNULL(fac_usr_dfnd_fld_5,'')
	+ ISNULL(loc_addr_county_code,'')
	+ ISNULL(loc_addr_city_code,'')
);
UPDATE dbo.ics_fac_class
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  fac_class
);
UPDATE dbo.ics_final_order
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), final_order_ident),'')
	+ ISNULL(final_order_type_code,'')
	+ ISNULL(CONVERT(varchar(50), final_order_issued_enterd_date),'')
	+ ISNULL(CONVERT(varchar(50), npdes_closed_date),'')
	+ ISNULL(final_order_qncr_cmnts,'')
	+ ISNULL(CONVERT(varchar(50), cash_civil_pnlty_reqd_amt),'')
	+ ISNULL(othr_cmnts,'')
);
UPDATE dbo.ics_final_order_prmt_ident
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  final_order_prmt_ident
);
-- 5.6
UPDATE dbo.ics_sep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), sep_ident)
	+ ISNULL(sep_desc,'')
	+ ISNULL(CONVERT(varchar(50), sep_pnlty_assessment_amt),'')
);
UPDATE dbo.ics_final_order_viol_lnk
 -- Root table has conditional key, skipping key_hash creation here, will do further down though... keep going.
    SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	+ enfrc_actn_ident
	+ CONVERT(varchar(50), final_order_ident)
);
UPDATE dbo.ics_frml_enfrc_actn
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ ISNULL(enfrc_actn_name,'')
	+ ISNULL(forum,'')
	+ ISNULL(resl_type_code,'')
	+ ISNULL(combined_or_superseded_by_eaid,'')
	+ ISNULL(reason_deleting_record,'')
	+ ISNULL(frml_ea_usr_dfnd_fld_1,'')
	+ ISNULL(frml_ea_usr_dfnd_fld_2,'')
	+ ISNULL(frml_ea_usr_dfnd_fld_3,'')
	+ ISNULL(CONVERT(varchar(50), frml_ea_usr_dfnd_fld_4),'')
	+ ISNULL(CONVERT(varchar(50), frml_ea_usr_dfnd_fld_5),'')
	+ ISNULL(frml_ea_usr_dfnd_fld_6,'')
	+ ISNULL(enfrc_agncy_name,'')
);
UPDATE dbo.ics_geo_coord
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), long_meas),'')
	+ ISNULL(CONVERT(varchar(50), horz_accuracy_meas),'')
	+ ISNULL(geometric_type_code,'')
	+ ISNULL(horz_coll_method_code,'')
	+ ISNULL(horz_ref_datum_code,'')
	+ ISNULL(ref_point_code,'')
	+ ISNULL(CONVERT(varchar(50), src_map_scale_num),'')
);
UPDATE dbo.ics_gnrl_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_gnrl_prmt.prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(assc_master_gnrl_prmt_ident,'')
	+ ISNULL(prmt_type_code,'')
	+ ISNULL(agncy_type_code,'')
	+ ISNULL(prmt_stat_code,'')
	+ ISNULL(CONVERT(varchar(50), prmt_issue_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_effective_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_expr_date),'')
	+ ISNULL(reissu_prio_prmt_ind,'')
	+ ISNULL(backlog_reason_txt,'')
	+ ISNULL(prmt_issuing_org_type_name,'')
	+ ISNULL(prmt_appealed_ind,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_1_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_2_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_3_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_4_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_5_txt,'')
	+ ISNULL(prmt_cmnts_txt,'')
	+ ISNULL(CONVERT(varchar(50), major_minor_rating_code),'')
	+ ISNULL(major_minor_stat_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_minor_stat_start_date),'')
	+ ISNULL(CONVERT(varchar(50), ttl_appl_dsgn_flow_num),'')
	+ ISNULL(CONVERT(varchar(50), ttl_appl_aver_flow_num),'')
	+ ISNULL(CONVERT(varchar(50), appl_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_appl_cmpl_date),'')
	+ ISNULL(new_src_ind,'')
	+ ISNULL(prmt_st_wtr_body_code,'')
	+ ISNULL(prmt_st_wtr_body_name,'')
	+ ISNULL(fedr_grant_ind,'')
	+ ISNULL(dmr_cognznt_ofcl,'')
	+ ISNULL(dmr_cognznt_ofcl_teleph_num,'')
	+ ISNULL(dmr_non_rcpt_stat_ind,'')
	+ ISNULL(CONVERT(varchar(50), dmr_non_rcpt_stat_start_date),'')
   -- 5.8
	+ ISNULL(CONVERT(varchar(50), ELEC_REP_WAIVER_EFFECTIVE_DATE),'')
	+ ISNULL(CONVERT(varchar(50), ELEC_REP_WAIVER_EXPR_DATE),'')
	+ ISNULL(ELEC_REP_WAIVER_TYPE_CODE,'')
	+ ISNULL(ELEC_SUBM_TYPE_CODE,'')
   
);
UPDATE dbo.ics_gpcf_cnst_waiver
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), cnst_waiver_auth_date),'')
	+ ISNULL(cnst_waiver_criteria_met_ind,'')
	+ ISNULL(cnst_waiver_eval_basis_code,'')
	+ ISNULL(CONVERT(varchar(50), cnst_waiver_eval_date),'')
	+ ISNULL(CONVERT(varchar(50), cnst_waiver_postmark_date),'')
	+ ISNULL(CONVERT(varchar(50), proj_isoerodent_value),'')
	+ ISNULL(CONVERT(varchar(50), proj_est_start_date),'')
	+ ISNULL(CONVERT(varchar(50), proj_est_completed_date),'')
);
UPDATE dbo.ics_gpcf_no_exposure
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), no_exposure_auth_date),'')
	+ ISNULL(CONVERT(varchar(50), no_exposure_postmark_date),'')
	+ ISNULL(CONVERT(varchar(50), no_exposure_eval_date),'')
	+ ISNULL(no_exposure_eval_basis_code,'')
	+ ISNULL(no_exposure_criteria_met_ind,'')
	+ ISNULL(CONVERT(varchar(50), paved_roof_size),'')
	--+ ISNULL(CONVERT(varchar(50), indst_acty_size),'')
);
UPDATE dbo.ics_gpcf_notice_of_intent
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), noi_sign_date),'')
	+ ISNULL(CONVERT(varchar(50), noi_postmark_date),'')
	+ ISNULL(CONVERT(varchar(50), noi_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), complete_noi_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), fedr_cercla_dsch_ind),'')
);
UPDATE dbo.ics_gpcf_notice_of_term
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), not_term_date),'')
	+ ISNULL(CONVERT(varchar(50), not_sign_date),'')
	+ ISNULL(CONVERT(varchar(50), not_postmark_date),'')
	+ ISNULL(CONVERT(varchar(50), not_rcvd_date),'')
);
UPDATE dbo.ics_hist_prmt_schd_evts
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident +CONVERT(varchar(50), prmt_effective_date) +CONVERT(varchar(50), narr_cond_num) + schd_evt_code +CONVERT(varchar(50), schd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_effective_date)
	+ ISNULL(CONVERT(varchar(50), narr_cond_num),'')
	+ schd_evt_code
	+ CONVERT(varchar(50), schd_date)
	+ ISNULL(CONVERT(varchar(50), schd_rep_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_actul_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_proj_date),'')
	+ ISNULL(schd_usr_dfnd_dat_elm_1,'')
	+ ISNULL(schd_usr_dfnd_dat_elm_2,'')
	+ ISNULL(schd_evt_cmnts,'')
);
UPDATE dbo.ics_impact_sso_evt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  impact_sso_evt
);

-- 5.8
UPDATE DBO.ICS_IMPAIRED_WTR_POLLUTANTS 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(CONVERT(varchar(50),IMPAIRED_WTR_POLLUTANTS),'')
   );

UPDATE dbo.ics_incin
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(beryllium_cmpl_ind,'')
	+ ISNULL(mercury_cmpl_ind,'')
);
UPDATE dbo.ics_infrml_enfrc_actn
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', enfrc_actn_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
	+ ISNULL(enfrc_actn_type_code,'')
	+ ISNULL(enfrc_actn_name,'')
	+ ISNULL(CONVERT(varchar(50), achieved_date),'')
	+ ISNULL(reason_deleting_record,'')
	+ ISNULL(infrml_ea_cmnt_txt,'')
	+ ISNULL(infrml_ea_usr_dfnd_fld_1,'')
	+ ISNULL(infrml_ea_usr_dfnd_fld_2,'')
	+ ISNULL(infrml_ea_usr_dfnd_fld_3,'')
	+ ISNULL(CONVERT(varchar(50), infrml_ea_usr_dfnd_fld_4),'')
	+ ISNULL(CONVERT(varchar(50), infrml_ea_usr_dfnd_fld_5),'')
	+ ISNULL(infrml_ea_usr_dfnd_fld_6,'')
	+ ISNULL(enfrc_agncy_name,'')
   -- 5.8
   + ISNULL(FILE_NUM,'')
);
UPDATE dbo.ics_land_appl_bmp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  land_appl_bmp_type_code
	+ ISNULL(othr_land_appl_bmp_type_name,'')
);
UPDATE dbo.ics_land_appl_site
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), polut_met_for_land_appl),'')
	+ ISNULL(pathogen_reduction_ind,'')
	+ ISNULL(vector_reduction_ind,'')
	+ ISNULL(CONVERT(varchar(50), agronomic_gal_rate_for_fld),'')
	+ ISNULL(CONVERT(varchar(50), agronomic_dmt_rate_for_fld),'')
	+ ISNULL(class_a_alt_used,'')
	+ ISNULL(class_a_alts_txt,'')
	+ ISNULL(class_b_alt_used,'')
	+ ISNULL(class_b_alts_txt,'')
	+ ISNULL(var_alt_used,'')
	+ ISNULL(var_alts_txt,'')
);
UPDATE dbo.ics_lmt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), lmt_start_date)
	+ CONVERT(varchar(50), lmt_end_date)
	+ ISNULL(lmt_type_code,'')
	+ ISNULL(smpl_type_txt,'')
	+ ISNULL(freq_of_analysis_code,'')
	+ ISNULL(eligible_for_burden_reduction,'')
	+ ISNULL(lmt_stay_type_code,'')
	+ ISNULL(CONVERT(varchar(50), stay_start_date),'')
	+ ISNULL(CONVERT(varchar(50), stay_end_date),'')
	+ ISNULL(stay_reason_txt,'')
	+ ISNULL(calculate_viol_ind,'')
	+ ISNULL(enfrc_actn_ident,'')
	+ ISNULL(CONVERT(varchar(50), final_order_ident),'')
	+ ISNULL(basis_of_lmt,'')
	+ ISNULL(lmt_mod_type_code,'')
	+ ISNULL(CONVERT(varchar(50), lmt_mod_effective_date),'')
	+ ISNULL(lmt_mod_type_stay_reason_txt,'')  --  5.6
	+ ISNULL(lmts_usr_dfnd_fld_1,'')
	+ ISNULL(lmts_usr_dfnd_fld_2,'')
	+ ISNULL(lmts_usr_dfnd_fld_3,'')
	+ ISNULL(concen_num_cond_unit_meas_code,'')
	+ ISNULL(qty_num_cond_unit_meas_code,'')
);
UPDATE dbo.ics_lmt_set
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', UPPER(prmt_ident) + UPPER(prmt_featr_ident) + UPPER(lmt_set_designator)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ lmt_set_type
	+ ISNULL(lmt_set_name_txt,'')
	+ ISNULL(dmr_pre_print_cmnts_txt,'')
	+ ISNULL(agncy_reviewer,'')
	+ ISNULL(CONVERT(varchar(50), lmt_set_usr_dfnd_dat_elm_1_txt),'')
	+ ISNULL(lmt_set_usr_dfnd_dat_elm_2_txt,'')
);
UPDATE dbo.ics_lmt_set_months_appl
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  lmt_set_months_appl
);
UPDATE dbo.ics_lmt_set_schd
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), num_units_rep_period_integer)
	+ ISNULL(CONVERT(varchar(50), num_subm_units_integer),'')
	+ ISNULL(CONVERT(varchar(50), initial_mon_date),'')
	+ ISNULL(CONVERT(varchar(50), initial_dmr_due_date),'')
	+ ISNULL(lmt_set_mod_type_code,'')
	+ ISNULL(CONVERT(varchar(50), lmt_set_mod_effective_date),'')
);
UPDATE dbo.ics_lmt_set_stat
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  lmt_set_stat_ind
	+ CONVERT(varchar(50), lmt_set_stat_start_date)
	+ ISNULL(lmt_set_stat_reason_txt,'')
);
UPDATE dbo.ics_lmts
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', ics_lmts.prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code +CONVERT(varchar(50), lmt_season_num) +CONVERT(varchar(50), lmt_start_date) +CONVERT(varchar(50), lmt_end_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
	+ CONVERT(varchar(50), lmt_start_date)
	+ CONVERT(varchar(50), lmt_end_date)
	+ ISNULL(lmt_type_code,'')
	+ ISNULL(smpl_type_txt,'')
	+ ISNULL(freq_of_analysis_code,'')
	+ ISNULL(eligible_for_burden_reduction,'')
	+ ISNULL(lmt_stay_type_code,'')
	+ ISNULL(CONVERT(varchar(50), stay_start_date),'')
	+ ISNULL(CONVERT(varchar(50), stay_end_date),'')
	+ ISNULL(stay_reason_txt,'')
	+ ISNULL(calculate_viol_ind,'')
	+ ISNULL(enfrc_actn_ident,'')
	+ ISNULL(CONVERT(varchar(50), final_order_ident),'')
	+ ISNULL(basis_of_lmt,'')
	+ ISNULL(lmt_mod_type_code,'')
	+ ISNULL(CONVERT(varchar(50), lmt_mod_effective_date),'')
	+ ISNULL(lmts_usr_dfnd_fld_1,'')
	+ ISNULL(lmts_usr_dfnd_fld_2,'')
	+ ISNULL(lmts_usr_dfnd_fld_3,'')
	+ ISNULL(concen_num_cond_unit_meas_code,'')
	+ ISNULL(qty_num_cond_unit_meas_code,'')
);
UPDATE dbo.ics_lnk_bs_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), rep_coverage_end_date)
);
UPDATE dbo.ics_lnk_cafo_annul_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_auth_rep_rcvd_date)
);
UPDATE dbo.ics_lnk_cso_evt_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), cso_evt_date)
	+ CONVERT(varchar(50), cso_evt_id)
);
UPDATE dbo.ics_lnk_enfrc_actn
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  enfrc_actn_ident
);
UPDATE dbo.ics_lnk_fedr_cmpl_mon
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prog_systm_acronym
	+ prog_systm_ident
	+ fedr_statute_code
	+ cmpl_mon_acty_type_code
	+ cmpl_mon_catg_code
	+ CONVERT(varchar(50), cmpl_mon_date)
);
UPDATE dbo.ics_lnk_loc_lmts_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_auth_rep_rcvd_date)
);
UPDATE dbo.ics_lnk_pretr_perf_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), pretr_perf_summ_end_date)
);
UPDATE dbo.ics_lnk_sngl_evt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ sngl_evt_viol_code
	+ CONVERT(varchar(50), sngl_evt_viol_date)
);
UPDATE dbo.ics_lnk_sso_annul_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sso_annul_rep_rcvd_date)
);
UPDATE dbo.ics_lnk_sso_evt_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sso_evt_date)
	+ CONVERT(varchar(50), sso_evt_id)
);
UPDATE dbo.ics_lnk_sso_monthly_evt_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sso_monthly_rep_rcvd_date)
);
UPDATE dbo.ics_lnk_st_cmpl_mon
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1',
   cmpl_mon_ident 
	--  prmt_ident
	--+ cmpl_mon_catg_code
	--+ CONVERT(varchar(50), cmpl_mon_date)
);
UPDATE dbo.ics_lnk_sw_evt_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), date_strm_evt_smpl)
	+ CONVERT(varchar(50), sw_evt_id)
);
UPDATE dbo.ics_lnk_swms_4_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sw_ms_4_rep_rcvd_date)
);
UPDATE dbo.ics_loc_lmts
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), mos_rc_date_tech_eval_loc_lmts),'')
	+ ISNULL(CONVERT(varchar(50), mos_rc_date_ad_tc_bs_loc_lmts),'')
);
UPDATE dbo.ics_loc_lmts_polut
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), loc_lmts_polut_code)
);
UPDATE dbo.ics_loc_lmts_prog_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), prmt_auth_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_auth_rep_rcvd_date)
);

-- 5.8
UPDATE DBO.ICS_MGMT_PRC_DEFCY_TYPE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(MGMT_PRC_DEFCY_TYPE_CODE,'')
   );

UPDATE dbo.ics_master_gnrl_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(prmt_type_code,'')
	+ ISNULL(agncy_type_code,'')
	+ ISNULL(CONVERT(varchar(50), prmt_issue_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_effective_date),'')
	+ ISNULL(CONVERT(varchar(50), prmt_expr_date),'')
	+ ISNULL(reissu_prio_prmt_ind,'')
	+ ISNULL(backlog_reason_txt,'')
	+ ISNULL(prmt_issuing_org_type_name,'')
	+ ISNULL(prmt_appealed_ind,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_1_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_2_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_3_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_4_txt,'')
	+ ISNULL(prmt_usr_dfnd_dat_elm_5_txt,'')
	+ ISNULL(prmt_cmnts_txt,'')
	+ ISNULL(gnrl_prmt_indst_catg,'')
	+ ISNULL(prmt_name,'')
);
UPDATE dbo.ics_mn_lmt_applies
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  mn_lmt_applies
);
UPDATE dbo.ics_mnur_lttr_prcss_ww_stor
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  mnur_lttr_prcss_ww_stor_type
	+ ISNULL(othr_stor_type_name,'')
	+ ISNULL(CONVERT(varchar(50), stor_ttl_cpcty_meas),'')
	+ ISNULL(CONVERT(varchar(50), days_of_stor),'')
);
UPDATE dbo.ics_naics_code
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  naics_code
	+ naics_primary_ind_code
);
UPDATE dbo.ics_narr_cond_schd
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident  + CONVERT(varchar(50), narr_cond_num)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), narr_cond_num)
	+ ISNULL(narr_cond_code,'')
	+ ISNULL(cmnts,'')
);
UPDATE dbo.ics_nat_prio
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), nat_prio_code)
);

-- 5.8
UPDATE DBO.ICS_NPDES_DAT_GRP_NUM 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(NPDES_DAT_GRP_NUM_CODE,'')
   );

UPDATE dbo.ics_num_cond
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  num_cond_txt
	+ ISNULL(num_cond_qty,'')
	+ ISNULL(num_cond_stat_base_code,'')
	+ ISNULL(num_cond_qualifier,'')
	+ ISNULL(num_cond_opt_mon_ind,'')
	+ ISNULL(num_cond_stay_value,'')
);
UPDATE dbo.ics_num_rep
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  num_rep_code
	+ ISNULL(CONVERT(varchar(50), num_rep_rcvd_date),'')
	+ ISNULL(num_rep_no_dsch_ind,'')
	+ ISNULL(num_cond_qty,'')
	+ ISNULL(num_cond_adjusted_qty,'')
	+ ISNULL(num_cond_qualifier,'')
);
UPDATE dbo.ics_orig_progs
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  orig_progs_code
);
UPDATE dbo.ics_othr_prmts
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  othr_prmt_ident
	+ ISNULL(othr_org_name,'')
	+ ISNULL(othr_prmt_ident_cntxt_name,'')
);
UPDATE dbo.ics_param_lmts
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident + lmt_set_designator + param_code + mon_site_desc_code +CONVERT(varchar(50), lmt_season_num)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ lmt_set_designator
	+ param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
);

-- 5.8
UPDATE DBO.ICS_PATHOGEN_REDUCTION_TYPE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(PATHOGEN_REDUCTION_TYPE_CODE,'')
   );

UPDATE dbo.ics_plcy
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  plcy_code
);
UPDATE dbo.ics_potw_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(CONVERT(varchar(50), sscs_popl_served_num),'')
	+ ISNULL(CONVERT(varchar(50), combined_sscs_systm_length),'')
);
UPDATE dbo.ics_pretr_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(suo_ref,'')
	+ ISNULL(CONVERT(varchar(50), suo_date),'')
	+ ISNULL(acceptance_haz_waste,'')
	+ ISNULL(acceptance_non_haz_indst_waste,'')
	+ ISNULL(acceptance_huled_domstic_wstes,'')
	+ ISNULL(annul_pretr_budget,'')
	+ ISNULL(inadequacy_smpl_insp_ind,'')
	+ ISNULL(adequacy_pretr_resources,'')
	+ ISNULL(dfcnc_idntfd_drng_iu_file_rviw,'')
	+ ISNULL(control_mech_dfcnc,'')
	+ ISNULL(legal_auth_dfcnc,'')
	+ ISNULL(dfcnc_intrprt_appl_pretr_stndr,'')
	+ ISNULL(dfcnc_dat_mgmt_pblc_prticipton,'')
	+ ISNULL(viol_iu_schd_rmd_msr,'')
	+ ISNULL(frml_rspn_viol_iu_schd_rmd_msr,'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_influnt_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_efflu_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_sldg_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), num_si_us),'')
	+ ISNULL(CONVERT(varchar(50), si_us_without_control_mech),'')
	+ ISNULL(CONVERT(varchar(50), si_us_not_inspected),'')
	+ ISNULL(CONVERT(varchar(50), si_us_not_smpl),'')
	+ ISNULL(CONVERT(varchar(50), si_us_on_schd),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_pretr_stndr),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_rep_reqs),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_pretr_schd),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_publ_newspaper),'')
	+ ISNULL(CONVERT(varchar(50), viol_notices_issued_si_us),'')
	+ ISNULL(CONVERT(varchar(50), admin_orders_issued_si_us),'')
	+ ISNULL(CONVERT(varchar(50), civil_suts_fild_aginst_si_us),'')
	+ ISNULL(CONVERT(varchar(50), criminl_suts_fild_aginst_si_us),'')
	+ ISNULL(CONVERT(varchar(50), dollar_amt_pnlty_coll),'')
	+ ISNULL(i_us_whc_pnlty_hav_bee_coll,'')
	+ ISNULL(CONVERT(varchar(50), num_ci_us),'')
	+ ISNULL(CONVERT(varchar(50), ci_us_in_snc),'')
	+ ISNULL(pass_through_interference_ind,'')
);
UPDATE dbo.ics_pretr_perf_summ
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), pretr_perf_summ_end_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), pretr_perf_summ_end_date)
	+ ISNULL(CONVERT(varchar(50), pretr_perf_summ_start_date),'')
	+ ISNULL(suo_ref,'')
	+ ISNULL(CONVERT(varchar(50), suo_date),'')
	+ ISNULL(acceptance_haz_waste,'')
	+ ISNULL(acceptance_non_haz_indst_waste,'')
	+ ISNULL(acceptance_huled_domstic_wstes,'')
	+ ISNULL(CONVERT(varchar(50), annul_pretr_budget_pp),'')
	+ ISNULL(inadequacy_smpl_insp_ind,'')
	+ ISNULL(adequacy_pretr_resources,'')
	+ ISNULL(dfcnc_idntfd_drng_iu_file_rviw,'')
	+ ISNULL(control_mech_dfcnc,'')
	+ ISNULL(legal_auth_dfcnc,'')
	+ ISNULL(dfcnc_intrprt_appl_pretr_stndr,'')
	+ ISNULL(dfcnc_dat_mgmt_pblc_prticipton,'')
	+ ISNULL(viol_iu_schd_rmd_msr,'')
	+ ISNULL(frml_rspn_viol_iu_schd_rmd_msr,'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_influnt_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_efflu_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), annul_freq_sldg_toxcnt_smpl),'')
	+ ISNULL(CONVERT(varchar(50), num_si_us),'')
	+ ISNULL(CONVERT(varchar(50), si_us_without_control_mech),'')
	+ ISNULL(CONVERT(varchar(50), si_us_not_inspected),'')
	+ ISNULL(CONVERT(varchar(50), si_us_not_smpl),'')
	+ ISNULL(CONVERT(varchar(50), si_us_on_schd),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_pretr_stndr),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_rep_reqs),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_with_pretr_schd),'')
	+ ISNULL(CONVERT(varchar(50), si_us_snc_publ_newspaper),'')
	+ ISNULL(CONVERT(varchar(50), viol_notices_issued_si_us),'')
	+ ISNULL(CONVERT(varchar(50), admin_orders_issued_si_us),'')
	+ ISNULL(CONVERT(varchar(50), civil_suts_fild_aginst_si_us),'')
	+ ISNULL(CONVERT(varchar(50), criminl_suts_fild_aginst_si_us),'')
	+ ISNULL(CONVERT(varchar(50), dollar_amt_pnlty_coll_pp),'')
	+ ISNULL(CONVERT(varchar(50), i_us_whc_pnlty_hav_bee_coll_pp),'')
	+ ISNULL(CONVERT(varchar(50), num_ci_us),'')
	+ ISNULL(CONVERT(varchar(50), ci_us_in_snc),'')
	+ ISNULL(pass_through_interference_ind,'')
);
UPDATE dbo.ics_pretr_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(pretr_prog_reqd_ind_code,'')
	+ ISNULL(control_auth_st_agncy_code,'')
	+ ISNULL(control_auth_rgnl_agncy_code,'')
	+ ISNULL(control_auth_npdes_ident,'')
	+ ISNULL(CONVERT(varchar(50), pretr_prog_aprvd_date),'')
);
UPDATE dbo.ics_prmt_comp_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_comp_type_code
);
UPDATE dbo.ics_prmt_featr
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_featr_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_featr_ident
	+ ISNULL(prmt_featr_type_code,'')
	+ ISNULL(prmt_featr_desc,'')
	+ ISNULL(CONVERT(varchar(50), prmt_featr_dsgn_flow_num),'')
	+ ISNULL(CONVERT(varchar(50), prmt_featr_actul_aver_flow_num),'')
	+ ISNULL(prmt_featr_st_wtr_body_code,'')
	+ ISNULL(prmt_featr_st_wtr_body_name,'')
	+ ISNULL(prmt_featr_usr_dfnd_dat_elm_1,'')
	+ ISNULL(prmt_featr_usr_dfnd_dat_elm_2,'')
	+ ISNULL(CONVERT(varchar(50), fld_size),'')
	+ ISNULL(is_site_own_by_fac,'')
	+ ISNULL(is_systm_lined_with_leachate,'')
	+ ISNULL(does_unit_hav_daily_cover,'')
	+ ISNULL(CONVERT(varchar(50), prop_boundary_distance),'')
	+ ISNULL(is_reqd_nitrate_ground_wtr,'')
	+ ISNULL(CONVERT(varchar(50), well_num),'')
	+ ISNULL(src_prmt_featr_detail_txt,'')
	+ ISNULL(impaired_wtr_ind,'')
	+ ISNULL(tmdl_completed_ind,'')
   -- 5.8
   + ISNULL(TIER_LEVEL_NAME,'')

);
UPDATE dbo.ics_prmt_featr_char
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_featr_char
);
UPDATE dbo.ics_prmt_featr_trtmnt_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_featr_trtmnt_type_code
);
UPDATE dbo.ics_prmt_ident
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
);
UPDATE dbo.ics_prmt_reissu
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_effective_date
);
UPDATE dbo.ics_prmt_schd_evt
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  schd_evt_code
	+ CONVERT(varchar(50), schd_date)
	+ ISNULL(CONVERT(varchar(50), schd_rep_rcvd_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_actul_date),'')
	+ ISNULL(CONVERT(varchar(50), schd_proj_date),'')
	+ ISNULL(schd_usr_dfnd_dat_elm_1,'')
	+ ISNULL(schd_usr_dfnd_dat_elm_2,'')
	+ ISNULL(schd_evt_cmnts,'')
);
UPDATE dbo.ics_prmt_schd_evt_viol_elem
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), narr_cond_num)
	+ schd_evt_code
	+ CONVERT(varchar(50), schd_date)
	+ schd_viol_code
);
UPDATE dbo.ics_prmt_schd_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), narr_cond_num)
	+ schd_evt_code
	+ CONVERT(varchar(50), schd_date)
);
UPDATE dbo.ics_prmt_term
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), prmt_term_date)
);
UPDATE dbo.ics_prmt_track_evt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + prmt_track_evt_code + CONVERT(varchar(50), prmt_track_evt_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ prmt_track_evt_code
	+ CONVERT(varchar(50), prmt_track_evt_date)
	+ ISNULL(prmt_track_cmnts_txt,'')
);
UPDATE dbo.ics_prog
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prog_code
);
UPDATE dbo.ics_progs_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  progs_viol_code
);
UPDATE dbo.ics_proj_srcs_fund
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  proj_srcs_fund_code
);
UPDATE dbo.ics_proj_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  proj_type_code
	+ ISNULL(proj_type_code_othr_desc,'')
);
UPDATE dbo.ics_rep_anml_type
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  anml_type_code
	+ ISNULL(othr_anml_type_name,'')
	+ ISNULL(CONVERT(varchar(50), ttl_num_each_lvstck),'')
);
--  5.6
UPDATE dbo.ics_rep_non_cmpl_stat
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), REP_NON_CMPL_STAT_CODE_YEAR),'')
	+ ISNULL(CONVERT(varchar(50), REP_NON_CMPL_STAT_CODE_QUARTER),'')
	+ ISNULL(REP_NON_CMPL_MANUAL_STAT_CODE,'')
);

-- 5.8
UPDATE DBO.ICS_REP_OBLGTN_TYPE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(REP_OBLGTN_TYPE_CODE,'')
   );

UPDATE dbo.ics_rep_param
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  param_code
	+ mon_site_desc_code
	+ CONVERT(varchar(50), lmt_season_num)
	+ ISNULL(rep_smpl_type_txt,'')
	+ ISNULL(rep_freq_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_num_of_excursions),'')
	+ ISNULL(concen_num_rep_unit_meas_code,'')
	+ ISNULL(qty_num_rep_unit_meas_code,'')
);
UPDATE dbo.ics_rmvl_crdts
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), mos_rc_date_rmvl_crdts_aprvl),'')
	+ ISNULL(rmvl_crdts_appl_stat_code,'')
);
UPDATE dbo.ics_rmvl_crdts_polut
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  CONVERT(varchar(50), rmvl_crdts_polut_code)
);
UPDATE dbo.ics_satl_coll_systm
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  satl_coll_systm_ident
	+ satl_coll_systm_name
);
UPDATE dbo.ics_schd_evt_viol
 -- Root table has conditional key, skipping key_hash creation
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(rep_non_cmpl_resl_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_non_cmpl_resl_date),'')
);
UPDATE dbo.ics_sic_code
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  sic_code
	+ sic_primary_ind_code
);
UPDATE dbo.ics_sngl_evt_viol
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + sngl_evt_viol_code + CONVERT(varchar(50), sngl_evt_viol_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ sngl_evt_viol_code
	+ CONVERT(varchar(50), sngl_evt_viol_date)
	+ ISNULL(CONVERT(varchar(50), sngl_evt_viol_end_date),'')
	+ ISNULL(rep_non_cmpl_detect_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_non_cmpl_detect_date),'')
	+ ISNULL(rep_non_cmpl_resl_code,'')
	+ ISNULL(CONVERT(varchar(50), rep_non_cmpl_resl_date),'')
	+ ISNULL(sngl_evt_usr_dfnd_fld_1,'')
	+ ISNULL(sngl_evt_usr_dfnd_fld_2,'')
	+ ISNULL(sngl_evt_usr_dfnd_fld_3,'')
	+ ISNULL(sngl_evt_usr_dfnd_fld_4,'')
	+ ISNULL(sngl_evt_usr_dfnd_fld_5,'')
	+ ISNULL(sngl_evt_cmnt_txt,'')
);
UPDATE dbo.ics_sngl_evts_viol
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ sngl_evt_viol_code
	+ CONVERT(varchar(50), sngl_evt_viol_date)
);
UPDATE dbo.ics_sso_annul_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sso_annul_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sso_annul_rep_rcvd_date)
	+ ISNULL(CONVERT(varchar(50), sso_annul_rep_year),'')
	+ ISNULL(CONVERT(varchar(50), num_sso_evts_per_year),'')
	+ ISNULL(CONVERT(varchar(50), vol_sso_evts_per_year),'')
);
UPDATE dbo.ics_sso_evt_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sso_evt_date) + CONVERT(varchar(50), sso_evt_id)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(cause_sso_ovrflw_evt,'')
	+ ISNULL(CONVERT(varchar(50), lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), long_meas),'')
	+ ISNULL(sso_ovrflw_loc_street,'')
	+ ISNULL(CONVERT(varchar(50), duration_sso_ovrflw_evt),'')
	+ ISNULL(CONVERT(varchar(50), sso_vol),'')
	+ ISNULL(name_rcvg_wtr,'')
	+ ISNULL(desc_stps_taken,'')
);
UPDATE dbo.ics_sso_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), sso_evt_date),'')
	+ ISNULL(cause_sso_ovrflw_evt,'')
	+ ISNULL(CONVERT(varchar(50), lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), long_meas),'')
	+ ISNULL(sso_ovrflw_loc_street,'')
	+ ISNULL(CONVERT(varchar(50), duration_sso_ovrflw_evt),'')
	+ ISNULL(CONVERT(varchar(50), sso_vol),'')
	+ ISNULL(name_rcvg_wtr,'')
	+ ISNULL(desc_stps_taken,'')
);
UPDATE dbo.ics_sso_monthly_evt_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident +CONVERT(varchar(50), sso_monthly_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sso_monthly_rep_rcvd_date)
	+ ISNULL(CONVERT(varchar(50), sso_monthly_evt_mn),'')
	+ ISNULL(CONVERT(varchar(50), sso_monthly_evt_year),'')
	+ ISNULL(CONVERT(varchar(50), num_sso_evts_rec_us_wtr_per_mn),'')
	+ ISNULL(CONVERT(varchar(50), vol_sso_evts_rec_us_wtr_per_mn),'')
);
UPDATE dbo.ics_sso_stps
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  stps_rduce_prevnt_mitigte
	+ ISNULL(othr_stps_rduce_prevnt_mitigte,'')
);
UPDATE dbo.ics_sso_systm_comp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  systm_comp
	+ ISNULL(othr_systm_comp,'')
);
UPDATE dbo.ics_surf_dspl_site
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(pathogen_reduction_ind,'')
	+ ISNULL(vector_reduction_ind,'')
	+ ISNULL(mgmt_practices_ind,'')
	+ ISNULL(cert_statement_ind,'')
	+ ISNULL(cert_first_name,'')
	+ ISNULL(cert_last_name,'')
	+ ISNULL(class_a_alt_used,'')
	+ ISNULL(class_a_alts_txt,'')
	+ ISNULL(class_b_alt_used,'')
	+ ISNULL(class_b_alts_txt,'')
	+ ISNULL(var_alt_used,'')
	+ ISNULL(var_alts_txt,'')
);
UPDATE dbo.ics_sw_cnst_indst_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(swppp_eval_basis_code,'')
	+ ISNULL(CONVERT(varchar(50), swppp_eval_date),'')
	+ ISNULL(swppp_eval_desc_txt,'')
	+ ISNULL(CONVERT(varchar(50), no_exposure_auth_date),'')
);
UPDATE dbo.ics_sw_cnst_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
0);
UPDATE dbo.ics_sw_cnst_non_cnst_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
0);
UPDATE dbo.ics_sw_cnst_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(st_wtr_body_name,'')
	+ ISNULL(rcvg_ms_4_name,'')
	+ ISNULL(impaired_wtr_ind,'')
	+ ISNULL(hist_prop_ind,'')
	+ ISNULL(hist_prop_crit_met_code,'')
	+ ISNULL(species_crit_habitat_ind,'')
	+ ISNULL(species_crit_met_code,'')
	+ ISNULL(proj_type_code,'')
	+ ISNULL(CONVERT(varchar(50), est_start_date),'')
	+ ISNULL(CONVERT(varchar(50), est_complete_date),'')
	+ ISNULL(CONVERT(varchar(50), est_area_disturbed_acres_num),'')
	+ ISNULL(proj_plan_size_code,'')
	+ ISNULL(CONVERT(varchar(50), indst_acty_size),'')
   -- 5.8
	+ ISNULL(ANTIDEG_IND,'')
	+ ISNULL(CATIONIC_CHEMS_AUTH_IND,'')
	+ ISNULL(CATIONIC_CHEMS_IND,'')
	+ ISNULL(CGP_IND,'')
	+ ISNULL(CNST_SITE_OTHR_TXT,'')
	+ ISNULL(ERTH_DISTRB_ACTIVITIES_IND,'')
	+ ISNULL(ERTH_DISTRB_EMRGCY_IND,'')
	+ ISNULL(MS_4_DSCH_IND,'')
	+ ISNULL(OTHR_PRMT_IDENT,'')
	+ ISNULL(PREDEV_LAND_USE_IND,'')
	+ ISNULL(PREVIOUS_SW_DSCH_IND,'')
	+ ISNULL(PRIOR_SURVEYS_EVALS_IND,'')
	+ ISNULL(SBSRFC_ERTH_DSTRBN_CONTROL_IND,'')
	+ ISNULL(SBSRFC_ERTH_DSTRBN_IND,'')
	+ ISNULL(STRCT_DEMOED_FLOOR_SPACE_IND,'')
	+ ISNULL(STRCT_DEMOED_IND,'')
	+ ISNULL(SWPPP_PREP_IND,'')
	+ ISNULL(TRTMNT_CHEMS_IND,'')
	+ ISNULL(WTR_PROX_IND,'')

);
UPDATE dbo.ics_sw_evt_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), date_strm_evt_smpl) +CONVERT(varchar(50), sw_evt_id)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(prmt_featr_ident,'')
	+ ISNULL(CONVERT(varchar(50), rainfall_strm_evt_smpl_num),'')
	+ ISNULL(duration_strm_evt_smpl,'')
	+ ISNULL(CONVERT(varchar(50), vol_dsch_smpl),'')
	+ ISNULL(CONVERT(varchar(50), duration_since_last_strm_evt),'')
	+ ISNULL(smpl_basis_ind,'')
	+ ISNULL(precip_form,'')
	+ ISNULL(smpl_taken_within_timefrme_ind,'')
	+ ISNULL(time_exceedance_rationale_code,'')
	+ ISNULL(essen_identical_outfall_notif,'')
	+ ISNULL(mon_exemption_rationale_ind,'')
	+ ISNULL(polut_mon_basis_code,'')
);
UPDATE dbo.ics_sw_indst_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(st_wtr_body_name,'')
	+ ISNULL(rcvg_ms_4_name,'')
	+ ISNULL(impaired_wtr_ind,'')
	+ ISNULL(hist_prop_ind,'')
	+ ISNULL(hist_prop_crit_met_code,'')
	+ ISNULL(species_crit_habitat_ind,'')
	+ ISNULL(species_crit_met_code,'')
	+ ISNULL(CAST(indst_acty_size AS VARCHAR(50)),'')
	+ ISNULL(web_addr_url,'')
	+ ISNULL(activities_exposed_sw_txt,'')
	+ ISNULL(assc_pollutants_txt,'')
	+ ISNULL(control_msr_txt,'')
	+ ISNULL(schd_control_msr_txt,'')
	+ ISNULL(tier_two_ind,'')
	+ ISNULL(tier_three_ind,'')
);
UPDATE dbo.ics_sw_ms_4_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), ms_4_annul_expen_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_year),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_year),'')
	+ ISNULL(major_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_outfall_num),'')
	+ ISNULL(minor_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), minor_outfall_num),'')
);
UPDATE dbo.ics_sw_non_cnst_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
0);
UPDATE dbo.ics_sw_unprmt_cnst_insp
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  ISNULL(CONVERT(varchar(50), est_start_date),'')
	+ ISNULL(CONVERT(varchar(50), est_complete_date),'')
	+ ISNULL(CONVERT(varchar(50), est_area_disturbed_acres_num),'')
	+ ISNULL(proj_plan_size_code,'')
);
UPDATE dbo.ics_swms_4_large_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(st_wtr_body_name,'')
	+ ISNULL(rcvg_ms_4_name,'')
	+ ISNULL(impaired_wtr_ind,'')
	+ ISNULL(hist_prop_ind,'')
	+ ISNULL(hist_prop_crit_met_code,'')
	+ ISNULL(species_crit_habitat_ind,'')
	+ ISNULL(species_crit_met_code,'')
	+ ISNULL(legal_entity_type_code,'')
	+ ISNULL(ms_4_prmt_class_code,'')
	+ ISNULL(ms_4_type_code,'')
	+ ISNULL(CONVERT(varchar(50), ms_4_acreage_covered_num),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_popl_served_num),'')
	+ ISNULL(urbanized_area_incrp_plce_name,'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_year),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_year),'')
	+ ISNULL(proj_srcs_of_fund_code,'')
	+ ISNULL(major_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_outfall_num),'')
	+ ISNULL(minor_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), minor_outfall_num),'')
	+ ISNULL(CONVERT(varchar(50), indst_acty_size),'')
);
UPDATE dbo.ics_swms_4_prog_rep
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident + CONVERT(varchar(50), sw_ms_4_rep_rcvd_date)),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ CONVERT(varchar(50), sw_ms_4_rep_rcvd_date)
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_year),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_year),'')
	+ ISNULL(major_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_outfall_num),'')
	+ ISNULL(minor_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), minor_outfall_num),'')
);
UPDATE dbo.ics_swms_4_small_prmt
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(st_wtr_body_name,'')
	+ ISNULL(rcvg_ms_4_name,'')
	+ ISNULL(impaired_wtr_ind,'')
	+ ISNULL(hist_prop_ind,'')
	+ ISNULL(hist_prop_crit_met_code,'')
	+ ISNULL(species_crit_habitat_ind,'')
	+ ISNULL(species_crit_met_code,'')
	+ ISNULL(legal_entity_type_code,'')
	+ ISNULL(ms_4_prmt_class_code,'')
	+ ISNULL(ms_4_type_code,'')
	+ ISNULL(CONVERT(varchar(50), ms_4_acreage_covered_num),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_popl_served_num),'')
	+ ISNULL(urbanized_area_incrp_plce_name,'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_annul_expen_year),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_dollars),'')
	+ ISNULL(CONVERT(varchar(50), ms_4_budget_year),'')
	+ ISNULL(proj_srcs_of_fund_code,'')
	+ ISNULL(major_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), major_outfall_num),'')
	+ ISNULL(minor_outfall_est_meas_ind,'')
	+ ISNULL(CONVERT(varchar(50), minor_outfall_num),'')
	+ ISNULL(qual_loc_prog_ind,'')
	+ ISNULL(qual_loc_prog_desc_txt,'')
	+ ISNULL(shared_resp_ind,'')
	+ ISNULL(shared_resp_desc_txt,'')
	+ ISNULL(CONVERT(varchar(50), indst_acty_size),'')
);
UPDATE dbo.ics_teleph
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  teleph_num_type_code
	+ ISNULL(teleph_num,'')
	+ ISNULL(teleph_ext_num,'')
);

-- 5.8
UPDATE DBO.ICS_TMDL_POLLUTANTS 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(TMDL_IDENT,'')
       +  ISNULL(TMDL_NAME,'')
   );

-- 5.8
UPDATE DBO.ICS_TMDL_POLUT 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(CONVERT(varchar(50),TMDL_POLUT_CODE),'')
   );   

-- 5.8
UPDATE DBO.ICS_TRTMNT_CHEMS_LIST 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(TRTMNT_CHEMS_LIST,'')
   );   
   
-- 5.8
UPDATE DBO.ICS_TRTMNT_PRCSS_TYPE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
      ISNULL(TRTMNT_PRCSS_TYPE_CODE,'')
   );   

-- 5.8
UPDATE DBO.ICS_VECTOR_A_REDUCTION_TYPE 
   SET data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
       ISNULL(VECTOR_A_REDUCTION_TYPE_CODE,'')
   );   
   
UPDATE dbo.ics_unprmt_fac
  SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', prmt_ident),
      data_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
	  prmt_ident
	+ ISNULL(fac_site_name,'')
	+ ISNULL(loc_addr_txt,'')
	+ ISNULL(suppl_loc_txt,'')
	+ ISNULL(locality_name,'')
	+ ISNULL(loc_st_code,'')
	+ ISNULL(loc_zip_code,'')
	+ ISNULL(loc_country_code,'')
	+ ISNULL(org_duns_num,'')
	+ ISNULL(st_fac_ident,'')
	+ ISNULL(st_rgn_code,'')
	+ ISNULL(CONVERT(varchar(50), fac_congr_district_num),'')
	+ ISNULL(fac_type_of_ownership_code,'')
	+ ISNULL(fedr_fac_ident_num,'')
	+ ISNULL(fedr_agncy_code,'')
	+ ISNULL(tribal_land_code,'')
	+ ISNULL(cnst_proj_name,'')
	+ ISNULL(CONVERT(varchar(50), cnst_proj_lat_meas),'')
	+ ISNULL(CONVERT(varchar(50), cnst_proj_long_meas),'')
	+ ISNULL(section_township_rng,'')
	+ ISNULL(fac_cmnts,'')
	+ ISNULL(fac_usr_dfnd_fld_1,'')
	+ ISNULL(fac_usr_dfnd_fld_2,'')
	+ ISNULL(fac_usr_dfnd_fld_3,'')
	+ ISNULL(fac_usr_dfnd_fld_4,'')
	+ ISNULL(fac_usr_dfnd_fld_5,'')
	+ ISNULL(prmt_cmnts_txt,'')
	+ ISNULL(LOC_ADDR_CITY_CODE,'')
	+ ISNULL(LOC_ADDR_COUNTY_CODE,'')
   
);

--Create KEY_HASH for modules with conditional keys (5 data families)

UPDATE dbo.ics_cmpl_mon_lnk
   SET KEY_HASH = dbo.HASHBYTES_VARCHAR('SHA1',
       ics_cmpl_mon_lnk.cmpl_mon_ident
						 -- ics_cmpl_mon_lnk.prmt_ident
						 -- + ics_cmpl_mon_lnk.cmpl_mon_catg_code
       --                --  + ISNULL(CONVERT(varchar(50), ics_cmpl_mon_lnk.cmpl_mon_date),'')
                         + COALESCE(
                                   ics_lnk_bs_rep.prmt_ident
                                   ,ics_lnk_cafo_annul_rep.prmt_ident
                                   ,ics_lnk_cso_evt_rep.prmt_ident
                                   ,ics_lnk_loc_lmts_rep.prmt_ident
                                   ,ics_lnk_pretr_perf_rep.prmt_ident
                                   ,ics_lnk_sngl_evt.prmt_ident
                                   ,ics_lnk_sso_annul_rep.prmt_ident
                                   ,ics_lnk_sso_evt_rep.prmt_ident
                                   ,ics_lnk_sso_monthly_evt_rep.prmt_ident
                                   ,ics_lnk_sw_evt_rep.prmt_ident
                                   ,ics_lnk_swms_4_rep.prmt_ident
                                   ,''
                                    ) -- prmt_ident2

                         + ISNULL(ics_lnk_sngl_evt.sngl_evt_viol_code,'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_sngl_evt.sngl_evt_viol_date),'')
                         + ISNULL(CONVERT(varchar(50),ics_lnk_enfrc_actn.enfrc_actn_ident),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_bs_rep.rep_coverage_end_date),'')
                         + COALESCE(
                          CONVERT(varchar(50), ics_lnk_cafo_annul_rep.prmt_auth_rep_rcvd_date)
                          ,CONVERT(varchar(50), ics_lnk_loc_lmts_rep.prmt_auth_rep_rcvd_date)
                         ,'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_cso_evt_rep.cso_evt_date),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_pretr_perf_rep.pretr_perf_summ_end_date),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_sso_annul_rep.sso_annul_rep_rcvd_date),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_sso_evt_rep.sso_evt_date),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_sso_monthly_evt_rep.sso_monthly_rep_rcvd_date),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_sw_evt_rep.date_strm_evt_smpl),'')
                         + ISNULL(CONVERT(varchar(50), ics_lnk_swms_4_rep.sw_ms_4_rep_rcvd_date),'')
                         + ISNULL(ics_lnk_st_cmpl_mon.cmpl_mon_ident,'')
                         + COALESCE(
                                      CONVERT(varchar(50), ics_lnk_cso_evt_rep.cso_evt_id)
                                      ,CONVERT(varchar(50), ics_lnk_sso_evt_rep.sso_evt_id)
                                      ,CONVERT(varchar(50), ics_lnk_sw_evt_rep.sw_evt_id)
                                      ,''
                                    )
                         )
	FROM dbo.ics_cmpl_mon_lnk ics_cmpl_mon_lnk
		LEFT JOIN dbo.ics_lnk_bs_rep ics_lnk_bs_rep on ics_lnk_bs_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_cafo_annul_rep ics_lnk_cafo_annul_rep on ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_cso_evt_rep ics_lnk_cso_evt_rep on ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_enfrc_actn ics_lnk_enfrc_actn on ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_loc_lmts_rep ics_lnk_loc_lmts_rep on ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_pretr_perf_rep ics_lnk_pretr_perf_rep on ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_sngl_evt ics_lnk_sngl_evt on ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_sso_annul_rep ics_lnk_sso_annul_rep on ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_sso_evt_rep ics_lnk_sso_evt_rep on ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_sso_monthly_evt_rep ics_lnk_sso_monthly_evt_rep on ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_st_cmpl_mon ics_lnk_st_cmpl_mon on ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_sw_evt_rep ics_lnk_sw_evt_rep on ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
		LEFT JOIN dbo.ics_lnk_swms_4_rep ics_lnk_swms_4_rep on ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id;
		
UPDATE dbo.ics_schd_evt_viol
   SET KEY_HASH = dbo.HASHBYTES_VARCHAR('SHA1',
                              COALESCE(ics_prmt_schd_evt_viol_elem.prmt_ident,ics_cmpl_schd_evt_viol_elem.prmt_ident,'')
                              + ISNULL(CONVERT(varchar(50), ics_prmt_schd_evt_viol_elem.narr_cond_num),'')
                              + COALESCE(ics_prmt_schd_evt_viol_elem.schd_evt_code,ics_cmpl_schd_evt_viol_elem.schd_evt_code,'')
                              + COALESCE(CONVERT(varchar(50), ics_prmt_schd_evt_viol_elem.schd_date),CONVERT(varchar(50), ics_cmpl_schd_evt_viol_elem.schd_date),'')
                              + COALESCE(ics_prmt_schd_evt_viol_elem.schd_viol_code,ics_cmpl_schd_evt_viol_elem.schd_viol_code,'')
                              + ISNULL(ics_cmpl_schd_evt_viol_elem.enfrc_actn_ident,'')
                              + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_evt_viol_elem.final_order_ident),'')
                              -- + ISNULL(ics_cmpl_schd_evt_viol_elem.prmt_ident,'') -- Assuming this goes to prmt_ident not prmt_ident_2
                              + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_evt_viol_elem.cmpl_schd_num),'')
                              -- + ISNULL(ics_cmpl_schd_evt_viol_elem.schd_evt_code,'')
                              -- + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_evt_viol_elem.schd_date),'')
                              -- + ISNULL(ics_cmpl_schd_evt_viol_elem.schd_viol_code,'')
                              )
  FROM dbo.ics_schd_evt_viol ics_schd_evt_viol
            LEFT JOIN dbo.ics_prmt_schd_evt_viol_elem ics_prmt_schd_evt_viol_elem on ics_prmt_schd_evt_viol_elem.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
            LEFT JOIN dbo.ics_cmpl_schd_evt_viol_elem ics_cmpl_schd_evt_viol_elem on ics_cmpl_schd_evt_viol_elem.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id;
            
UPDATE dbo.ics_dmr_prog_rep_lnk
   SET key_hash = dbo.HASHBYTES_VARCHAR('SHA1', 
                                  ics_dmr_prog_rep_lnk.prmt_ident
                                 + ics_dmr_prog_rep_lnk.prmt_featr_ident
                                 + ics_dmr_prog_rep_lnk.lmt_set_designator
                                 + CONVERT(varchar(50), ics_dmr_prog_rep_lnk.mon_period_end_date)
                                 + COALESCE(ics_lnk_bs_rep.prmt_ident,ics_lnk_sw_evt_rep.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_lnk_bs_rep.rep_coverage_end_date),'')
                                 -- + ISNULL(ics_lnk_sw_evt_rep.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_lnk_sw_evt_rep.date_strm_evt_smpl),'')
                                 + ISNULL(CONVERT(varchar(50), ics_lnk_sw_evt_rep.sw_evt_id),'')
                                 )
  FROM dbo.ics_dmr_prog_rep_lnk ics_dmr_prog_rep_lnk
    LEFT JOIN dbo.ics_lnk_bs_rep ics_lnk_bs_rep on ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
    LEFT JOIN dbo.ics_lnk_sw_evt_rep ics_lnk_sw_evt_rep on ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id;

UPDATE dbo.ics_enfrc_actn_viol_lnk
/*
   SET KEY_HASH = dbo.HASHBYTES_VARCHAR('SHA1', ics_enfrc_actn_viol_lnk.enfrc_actn_ident
                                 + ISNULL(ics_prmt_schd_viol.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_prmt_schd_viol.narr_cond_num),'')
                                 + ISNULL(ics_prmt_schd_viol.schd_evt_code,'')
                                 + ISNULL(CONVERT(varchar(50), ics_prmt_schd_viol.schd_date),'')
                                 + ISNULL(ics_cmpl_schd_viol.enfrc_actn_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.final_order_ident),'')
                                 + ISNULL(ics_cmpl_schd_viol.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.cmpl_schd_num),'')
                                 + ISNULL(ics_cmpl_schd_viol.schd_evt_code,'')
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.schd_date),'')
                                 + ISNULL(ics_dsch_mon_rep_viol.prmt_ident,'')
                                 + ISNULL(ics_dsch_mon_rep_viol.prmt_featr_ident,'')
                                 + ISNULL(ics_dsch_mon_rep_viol.lmt_set_designator,'')
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_viol.mon_period_end_date),'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.prmt_ident,'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.prmt_featr_ident,'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.lmt_set_designator,'')
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.mon_period_end_date),'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.param_code,'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.mon_site_desc_code,'')
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.lmt_season_num),'')
                                 + ISNULL(ics_sngl_evts_viol.prmt_ident,'')
                                 + ISNULL(ics_sngl_evts_viol.sngl_evt_viol_code,'')
                                 + ISNULL(CONVERT(varchar(50), ics_sngl_evts_viol.sngl_evt_viol_date),''))
*/
SET KEY_HASH = dbo.HASHBYTES_VARCHAR('SHA1', 
                                 ics_enfrc_actn_viol_lnk.enfrc_actn_ident
                                 + COALESCE(
                                    ics_prmt_schd_viol.prmt_ident
                                    ,ics_cmpl_schd_viol.prmt_ident
                                    ,ics_dsch_mon_rep_viol.prmt_ident
                                    ,ics_dsch_mon_rep_param_viol.prmt_ident
                                    ,ics_sngl_evts_viol.prmt_ident
                                    ,'')
                                 + ISNULL(CONVERT(varchar(50), ics_prmt_schd_viol.narr_cond_num),'') 
                                 + COALESCE(
                                       ics_prmt_schd_viol.schd_evt_code
                                       ,ics_cmpl_schd_viol.schd_evt_code
                                       ,'')                                 
                                 + COALESCE(
                                     CONVERT(varchar(50), ics_prmt_schd_viol.schd_date)
                                    , CONVERT(varchar(50),ics_cmpl_schd_viol.schd_date)
                                    ,'')

                                -- + COALESCE(CONVERT(varchar(50), ics_prmt_schd_viol.schd_date),'')
                                 + ISNULL(ics_cmpl_schd_viol.enfrc_actn_ident,'') -- enfrc_actn_ident_2
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.final_order_ident),'') -- final_order_ident
                               --  + ISNULL(ics_cmpl_schd_viol.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.cmpl_schd_num),'')
                                  + COALESCE(
                                          ics_dsch_mon_rep_viol.prmt_featr_ident
                                          ,ics_dsch_mon_rep_param_viol.prmt_featr_ident
                                  ,'')
                                 + COALESCE(
                                          ics_dsch_mon_rep_viol.lmt_set_designator
                                          ,ics_dsch_mon_rep_param_viol.lmt_set_designator
                                  ,'')                                
                                 + ISNULL(ics_dsch_mon_rep_param_viol.param_code,'')                                 
                                 + ISNULL(ics_dsch_mon_rep_param_viol.mon_site_desc_code,'')                              
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.lmt_season_num),'')                              
                                 + COALESCE(
                                        CONVERT(varchar(50), ics_dsch_mon_rep_viol.mon_period_end_date)
                                        ,CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.mon_period_end_date)
                                        ,'') 
                                 + ISNULL(ics_sngl_evts_viol.sngl_evt_viol_code,'') 
                                 + ISNULL(CONVERT(varchar(50), ics_sngl_evts_viol.sngl_evt_viol_date),'')                                 
                                -- + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.schd_date),'')
                                -- + ISNULL(ics_dsch_mon_rep_viol.prmt_ident,'')


                                 -- + ISNULL(ics_dsch_mon_rep_param_viol.prmt_ident,'')
                                -- + ISNULL(ics_dsch_mon_rep_param_viol.prmt_featr_ident,'')
                                -- + ISNULL(ics_dsch_mon_rep_param_viol.lmt_set_designator,'')
                                -- + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.mon_period_end_date),'')



                                -- + ISNULL(ics_sngl_evts_viol.prmt_ident,'')
                                -- + ISNULL(ics_sngl_evts_viol.sngl_evt_viol_code,'')
                                -- + ISNULL(CONVERT(varchar(50), ics_sngl_evts_viol.sngl_evt_viol_date),'')
                                )
       FROM dbo.ics_enfrc_actn_viol_lnk ics_enfrc_actn_viol_lnk
       LEFT JOIN dbo.ics_prmt_schd_viol ics_prmt_schd_viol on ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       LEFT JOIN dbo.ics_cmpl_schd_viol ics_cmpl_schd_viol on ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       LEFT JOIN dbo.ics_dsch_mon_rep_viol ics_dsch_mon_rep_viol on ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       LEFT JOIN dbo.ics_dsch_mon_rep_param_viol ics_dsch_mon_rep_param_viol on ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
       LEFT JOIN dbo.ics_sngl_evts_viol ics_sngl_evts_viol on ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id;
  
UPDATE dbo.ics_final_order_viol_lnk
   SET KEY_HASH = dbo.HASHBYTES_VARCHAR('SHA1', ics_final_order_viol_lnk.enfrc_actn_ident
                                 + CONVERT(varchar(50), ics_final_order_viol_lnk.final_order_ident)
                                 + COALESCE(
                                          ics_prmt_schd_viol.prmt_ident
                                          ,ics_cmpl_schd_viol.prmt_ident
                                          ,ics_dsch_mon_rep_viol.prmt_ident
                                          ,ics_dsch_mon_rep_param_viol.prmt_ident
                                          ,ics_sngl_evts_viol.prmt_ident
                                          ,'')
                                 + ISNULL(CONVERT(varchar(50), ics_prmt_schd_viol.narr_cond_num),'')
                                 + COALESCE(
                                             ics_prmt_schd_viol.schd_evt_code
                                             ,ics_cmpl_schd_viol.schd_evt_code
                                             ,'')
                                 + COALESCE(
                                           CONVERT(varchar(50), ics_prmt_schd_viol.schd_date)
                                          , CONVERT(varchar(50),ics_cmpl_schd_viol.schd_date),'')
                                -- + ISNULL(CONVERT(varchar(50), ics_prmt_schd_viol.schd_date),'')
                                 + ISNULL(ics_cmpl_schd_viol.enfrc_actn_ident,'') -- enfrc_actn_ident_2
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.final_order_ident),'') -- final_order_ident_2
                                -- + ISNULL(ics_cmpl_schd_viol.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.cmpl_schd_num),'')
                                 + ISNULL(ics_dsch_mon_rep_viol.prmt_featr_ident,'')
                                 + ISNULL(ics_dsch_mon_rep_viol.lmt_set_designator,'')
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_viol.mon_period_end_date),'')
                                -- + ISNULL(ics_dsch_mon_rep_param_viol.prmt_ident,'')
                                -- + ISNULL(ics_dsch_mon_rep_param_viol.prmt_featr_ident,'')
                                -- + ISNULL(ics_dsch_mon_rep_param_viol.lmt_set_designator,'')
                                -- + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.mon_period_end_date),'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.param_code,'')
                                 + ISNULL(ics_dsch_mon_rep_param_viol.mon_site_desc_code,'')
                                 + ISNULL(CONVERT(varchar(50), ics_dsch_mon_rep_param_viol.lmt_season_num),'')
                                 + ISNULL(ics_sngl_evts_viol.sngl_evt_viol_code,'')
                                -- + ISNULL(ics_cmpl_schd_viol.schd_evt_code,'')
                                -- + ISNULL(CONVERT(varchar(50), ics_cmpl_schd_viol.schd_date),'')
                                -- + ISNULL(ics_dsch_mon_rep_viol.prmt_ident,'')
                                -- + ISNULL(ics_sngl_evts_viol.prmt_ident,'')
                                 + ISNULL(CONVERT(varchar(50), ics_sngl_evts_viol.sngl_evt_viol_date),''))
     FROM dbo.ics_final_order_viol_lnk ics_final_order_viol_lnk
       LEFT JOIN dbo.ics_prmt_schd_viol ics_prmt_schd_viol on ics_prmt_schd_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       LEFT JOIN dbo.ics_cmpl_schd_viol ics_cmpl_schd_viol on ics_cmpl_schd_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       LEFT JOIN dbo.ics_dsch_mon_rep_viol ics_dsch_mon_rep_viol on ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       LEFT JOIN dbo.ics_dsch_mon_rep_param_viol ics_dsch_mon_rep_param_viol on ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
       LEFT JOIN dbo.ics_sngl_evts_viol ics_sngl_evts_viol on ics_sngl_evts_viol.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id;
  
  /************************************/  
  /* START - Process DATA_HASH values */
  /* START - Process DATA_HASH values */
  /* START - Process DATA_HASH values */
  /************************************/ 
 
  /* Loop through each payload type, for each loop roll child data_hash values up to the parent payload table */  
  OPEN payload_type_process;

  -- Get 1st payload type
  FETCH NEXT FROM payload_type_process INTO @p_payload_type;
  WHILE @@FETCH_STATUS = 0
    BEGIN

	    --PRINT 'Change Detection: Begin data_hash aggregation for table: ' + @p_payload_type + ' at ' + CONVERT(VARCHAR(24),GETDATE(),113)

      SET @v_sql_statement = 'SELECT TOP 1 @v_enabled_val = [ENABLED] FROM dbo.ICS_PAYLOAD P JOIN dbo.' + @p_payload_type +
        ' CHILD ON P.ICS_PAYLOAD_ID = CHILD.ICS_PAYLOAD_ID'
      SET @v_sql_param = '@v_enabled_val CHAR(1) OUTPUT';

      EXEC sp_executesql @v_sql_statement, @v_sql_param, @v_enabled_val=@v_enabled OUTPUT;
      
      SET @v_enabled = ISNULL(@v_enabled, 'N');
      
      /* Flush the prior payload type's key_hash values */
      DELETE FROM dbo.ics_key_hash;
      
      IF (@v_enabled = 'Y')
      BEGIN
          /* Load next key_hash set for current payload type */ 
          SET @v_sql_statement = 'INSERT INTO dbo.ics_key_hash SELECT key_hash FROM dbo.' + @p_payload_type; 
          EXECUTE sp_executesql @v_sql_statement;
      END

     /* 
      *  Loop through each key in a payload type's key set.  For each key traverse the payload type's data heirarchy
      *  and load the child data_hash values into working table ICS_DATA_HASH for later processing at the end of 
      *  the loop.
      */
      OPEN key_hash;

      /*  Fetch 1st payload type */
      FETCH NEXT FROM key_hash INTO @v_key_hash;
      WHILE @@FETCH_STATUS = 0
        BEGIN    

          --  Reset the working data hash!
          SET @v_working_data_hash = NULL;

          IF @p_payload_type = 'ICS_BASIC_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_BASIC_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt child
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_ASSC_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_assc_prmt child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_CMPL_TRACK_STAT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_cmpl_track_stat child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_EFFLU_GUIDE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_efflu_guide child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_addr child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_contact child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_FAC_CLASS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_fac_class child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_GEO_COORD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_geo_coord child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_naics_code child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ORIG_PROGS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_orig_progs child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_PLCY
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_plcy child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_FAC/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                        JOIN dbo.ics_sic_code child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_naics_code child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_NPDES_DAT_GRP_NUM (5.8)
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ICS_NPDES_DAT_GRP_NUM child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_OTHR_PRMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_othr_prmts child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      --  5.6
                      -- /ICS_BASIC_PRMT/ICS_REP_NON_CMPL_STAT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_rep_non_cmpl_stat child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL
                      -- /ICS_BASIC_PRMT/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_basic_prmt
                        JOIN dbo.ics_sic_code child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_basic_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_BS_ANNUL_PROG_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (             
             
             
                      -- \ICS_BS_ANNUL_PROG_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_annul_prog_rep child
                       UNION ALL
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_REP_OBLGTN_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_annul_prog_rep
                        JOIN dbo.ics_rep_oblgtn_type child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id      
                       UNION ALL  
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_ANLYTCL_METHOD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_ANLYTCL_METHOD child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
                      UNION ALL                       
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_ADDR
                      SELECT key_hash
                           , ICS_ADDR.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ics_addr
                          ON ics_addr.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_ADDR\ICS_TELEPH
                      SELECT key_hash
                           , ICS_BS_MGMT_PRACTICES.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ics_addr
                          ON ics_addr.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL                         
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_MGMT_PRC_DEFCY_TYPE
                      SELECT key_hash
                           , ICS_MGMT_PRC_DEFCY_TYPE.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ICS_MGMT_PRC_DEFCY_TYPE
                          ON ICS_MGMT_PRC_DEFCY_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_CONTACT
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL  
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_CONTACT\ICS_TELEPH
                     SELECT key_hash
                           , child.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                        JOIN dbo.ics_teleph child
                          ON child.ICS_CONTACT_id = ICS_CONTACT.ICS_CONTACT_ID
                      UNION ALL
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_VECTOR_A_REDUCTION_TYPE
                      SELECT key_hash
                           , ICS_VECTOR_A_REDUCTION_TYPE.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ICS_VECTOR_A_REDUCTION_TYPE
                          ON ICS_VECTOR_A_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_PATHOGEN_REDUCTION_TYPE
                      SELECT key_hash
                           , ICS_PATHOGEN_REDUCTION_TYPE.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN dbo.ICS_PATHOGEN_REDUCTION_TYPE
                          ON ICS_PATHOGEN_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_CONTACT
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_TRTMNT_PRCSS_TYPE
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM dbo.ICS_BS_ANNUL_PROG_REP
                        JOIN dbo.ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                                        
             
              ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_bs_annul_prog_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;            
             
          IF @p_payload_type = 'ICS_BS_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_BS_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt child
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_BS_END_USE_DSPL_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_bs_end_use_dspl_type child
                          ON child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_BS_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_bs_type child
                          ON child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      UNION ALL
                      -- /ICS_BS_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_bs_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_bs_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CAFO_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CAFO_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt child
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_ANML_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_anml_type child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_CONTAINMENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_containment child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_LAND_APPL_BMP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_land_appl_bmp child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      UNION ALL
                      -- /ICS_CAFO_PRMT/ICS_MNUR_LTTR_PRCSS_WW_STOR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_prmt
                        JOIN dbo.ics_mnur_lttr_prcss_ww_stor child
                          ON child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cafo_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CSO_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CSO_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cso_prmt child
                      UNION ALL
                      -- /ICS_CSO_PRMT/ICS_SATL_COLL_SYSTM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cso_prmt
                        JOIN dbo.ics_satl_coll_systm child
                          ON child.ics_cso_prmt_id = ics_cso_prmt.ics_cso_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cso_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_GNRL_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_GNRL_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt child
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_ASSC_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_assc_prmt child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_CMPL_TRACK_STAT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_cmpl_track_stat child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_EFFLU_GUIDE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_efflu_guide child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_addr child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_contact child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_FAC_CLASS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_fac_class child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_GEO_COORD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_geo_coord child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_naics_code child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ORIG_PROGS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_orig_progs child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_PLCY
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_plcy child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_FAC/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_fac
                          ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                        JOIN dbo.ics_sic_code child
                          ON child.ics_fac_id = ics_fac.ics_fac_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_naics_code child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_NPDES_DAT_GRP_NUM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ICS_NPDES_DAT_GRP_NUM child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_OTHR_PRMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_othr_prmts child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      --  5.6
                      -- /ICS_GNRL_PRMT/ICS_REP_NON_CMPL_STAT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_rep_non_cmpl_stat child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_gnrl_prmt
                        JOIN dbo.ics_sic_code child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_gnrl_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_MASTER_GNRL_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_MASTER_GNRL_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt child
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_ASSC_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_assc_prmt child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_naics_code child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_OTHR_PRMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_othr_prmts child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_PRMT_COMP_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_prmt_comp_type child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      UNION ALL
                      -- /ICS_MASTER_GNRL_PRMT/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_master_gnrl_prmt
                        JOIN dbo.ics_sic_code child
                          ON child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_master_gnrl_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_POTW_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_POTW_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_potw_prmt child
                      UNION ALL
                      -- /ICS_POTW_PRMT/ICS_SATL_COLL_SYSTM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_potw_prmt
                        JOIN dbo.ics_satl_coll_systm child
                          ON child.ics_potw_prmt_id = ics_potw_prmt.ics_potw_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_potw_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_PRETR_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_PRETR_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_prmt child
                      UNION ALL
                      -- /ICS_PRETR_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
                      UNION ALL
                      -- /ICS_PRETR_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_pretr_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SW_CNST_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SW_CNST_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt child
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_CNST_SITE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_cnst_site child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id                      
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_gpcf_notice_of_intent child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_gpcf_notice_of_intent
                          ON ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                        JOIN dbo.ics_subsctor_code_plus_desc child
                          ON child.ics_gpcf_notice_of_intent_id = ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id
                      UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_TERM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_gpcf_notice_of_term child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id 
                      UNION ALL 
                      -- /ICS_SW_CNST_PRMT/ICS_TRTMNT_CHEMS_LIST
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_cnst_prmt
                        JOIN dbo.ics_trtmnt_chems_list child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id 
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_sw_cnst_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SW_INDST_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SW_INDST_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt child
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_GPCF_NO_EXPOSURE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_gpcf_no_exposure child
                          ON child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_gpcf_notice_of_intent child
                          ON child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_gpcf_notice_of_intent
                          ON ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                        JOIN dbo.ics_subsctor_code_plus_desc child
                          ON child.ics_gpcf_notice_of_intent_id = ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id
                      UNION ALL
                      -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_TERM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_indst_prmt
                        JOIN dbo.ics_gpcf_notice_of_term child
                          ON child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_sw_indst_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SWMS_4_LARGE_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SWMS_4_LARGE_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_large_prmt child
                      UNION ALL
                      -- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_large_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                      UNION ALL
                      -- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_large_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_large_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                      UNION ALL
                      -- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_large_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_swms_4_large_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SWMS_4_SMALL_PRMT' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SWMS_4_SMALL_PRMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt child
                      UNION ALL
                      -- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt
                        JOIN dbo.ics_addr child
                          ON child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                      UNION ALL
                      -- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt
                        JOIN dbo.ics_contact child
                          ON child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                      UNION ALL
                      -- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_SWMS_4_SMALL_PRMT/ICS_GPCF_CNST_WAIVER
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_small_prmt
                        JOIN dbo.ics_gpcf_cnst_waiver child
                          ON child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_swms_4_small_prmt
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_UNPRMT_FAC' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_UNPRMT_FAC
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac child
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_addr child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_contact child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_FAC_CLASS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_fac_class child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_GEO_COORD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_geo_coord child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_NAICS_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_naics_code child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_ORIG_PROGS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_orig_progs child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_PLCY
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_plcy child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      UNION ALL
                      -- /ICS_UNPRMT_FAC/ICS_SIC_CODE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_unprmt_fac
                        JOIN dbo.ics_sic_code child
                          ON child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_unprmt_fac
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_NARR_COND_SCHD' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_NARR_COND_SCHD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_narr_cond_schd child
                      UNION ALL
                      -- /ICS_NARR_COND_SCHD/ICS_PRMT_SCHD_EVT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_narr_cond_schd
                        JOIN dbo.ics_prmt_schd_evt child
                          ON child.ics_narr_cond_schd_id = ics_narr_cond_schd.ics_narr_cond_schd_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_narr_cond_schd
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_PRMT_FEATR' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_PRMT_FEATR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr child
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_addr child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_contact child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_GEO_COORD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_geo_coord child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_CHAR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_prmt_featr_char child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL
                      -- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_TRTMNT_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_prmt_featr_trtmnt_type child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL 
                      -- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ics_impaired_wtr_pollutants child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id 
                      UNION ALL 
                      -- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ICS_TMDL_POLLUTANTS child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id 
                      UNION ALL                       
                      -- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS/ICS_TMDL_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_prmt_featr
                        JOIN dbo.ICS_TMDL_POLLUTANTS 
                          ON ICS_TMDL_POLLUTANTS.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                        JOIN dbo.ICS_TMDL_POLUT child 
                          ON child.ICS_TMDL_POLLUTANTS_ID = ICS_TMDL_POLLUTANTS.ICS_TMDL_POLLUTANTS_ID
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_prmt_featr
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_LMT_SET' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_LMT_SET
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmt_set child
                      UNION ALL
                      -- /ICS_LMT_SET/ICS_LMT_SET_MONTHS_APPL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmt_set
                        JOIN dbo.ics_lmt_set_months_appl child
                          ON child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
                      UNION ALL
                      -- /ICS_LMT_SET/ICS_LMT_SET_SCHD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmt_set
                        JOIN dbo.ics_lmt_set_schd child
                          ON child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
                      UNION ALL
                      -- /ICS_LMT_SET/ICS_LMT_SET_STAT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmt_set
                        JOIN dbo.ics_lmt_set_stat child
                          ON child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_lmt_set
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_LMTS' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_LMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmts child
                      UNION ALL
                      -- /ICS_LMTS/ICS_MN_LMT_APPLIES
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmts
                        JOIN dbo.ics_mn_lmt_applies child
                          ON child.ics_lmts_id = ics_lmts.ics_lmts_id
                      UNION ALL
                      -- /ICS_LMTS/ICS_NUM_COND
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_lmts
                        JOIN dbo.ics_num_cond child
                          ON child.ics_lmts_id = ics_lmts.ics_lmts_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_lmts
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_PARAM_LMTS' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_PARAM_LMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_param_lmts child
                      UNION ALL
                      -- /ICS_PARAM_LMTS/ICS_LMT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_param_lmts
                        JOIN dbo.ics_lmt child
                          ON child.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                      UNION ALL
                      -- /ICS_PARAM_LMTS/ICS_LMT/ICS_MN_LMT_APPLIES
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_param_lmts
                        JOIN dbo.ics_lmt
                          ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                        JOIN dbo.ics_mn_lmt_applies child
                          ON child.ics_lmt_id = ics_lmt.ics_lmt_id
                      UNION ALL
                      -- /ICS_PARAM_LMTS/ICS_LMT/ICS_NUM_COND
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_param_lmts
                        JOIN dbo.ics_lmt
                          ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                        JOIN dbo.ics_num_cond child
                          ON child.ics_lmt_id = ics_lmt.ics_lmt_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)


              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_param_lmts
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_DSCH_MON_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_DSCH_MON_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep child
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_CO_DSPL_SITE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_co_dspl_site child
                          ON child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_INCIN
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_incin child
                          ON child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_land_appl_site child
                          ON child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_HARVESTED
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_land_appl_site
                          ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                        JOIN dbo.ics_crop_types_harvested child
                          ON child.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_PLANTED
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_land_appl_site
                          ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                        JOIN dbo.ics_crop_types_planted child
                          ON child.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_REP_PARAM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_rep_param child
                          ON child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_REP_PARAM/ICS_NUM_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_rep_param
                          ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                        JOIN dbo.ics_num_rep child
                          ON child.ics_rep_param_id = ics_rep_param.ics_rep_param_id
                      UNION ALL
                      -- /ICS_DSCH_MON_REP/ICS_SURF_DSPL_SITE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dsch_mon_rep
                        JOIN dbo.ics_surf_dspl_site child
                          ON child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_dsch_mon_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CMPL_MON' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CMPL_MON
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon child
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_ANML_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp
                          ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_anml_type child
                          ON child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CAFO_INSP_VIOL_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp
                          ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_cafo_insp_viol_type child
                          ON child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CONTAINMENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp
                          ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_containment child
                          ON child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_LAND_APPL_BMP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp
                          ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_land_appl_bmp child
                          ON child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_MNUR_LTTR_PRCSS_WW_STOR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cafo_insp
                          ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_mnur_lttr_prcss_ww_stor child
                          ON child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CMPL_INSP_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cmpl_insp_type child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CMPL_MON_ACTN_REASON
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cmpl_mon_actn_reason child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CMPL_MON_AGNCY_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cmpl_mon_agncy_type child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_contact child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_CSO_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_cso_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_NAT_PRIO
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_nat_prio child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PRETR_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_pretr_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_pretr_insp
                          ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_loc_lmts child
                          ON child.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_pretr_insp
                          ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_loc_lmts
                          ON ics_loc_lmts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                        JOIN dbo.ics_loc_lmts_polut child
                          ON child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_pretr_insp
                          ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_rmvl_crdts child
                          ON child.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_pretr_insp
                          ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_rmvl_crdts
                          ON ics_rmvl_crdts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                        JOIN dbo.ics_rmvl_crdts_polut child
                          ON child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_PROG
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_prog child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      --  5.6
                      -- /ICS_CMPL_MON/ICS_PROG_DEFCY_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_prog_defcy_type child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SSO_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sso_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_IMPACT_SSO_EVT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sso_insp
                          ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_impact_sso_evt child
                          ON child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_STPS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sso_insp
                          ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sso_stps child
                          ON child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_SYSTM_COMP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sso_insp
                          ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sso_systm_comp child
                          ON child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_CNST_INDST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_insp
                          ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_cnst_indst_insp child
                          ON child.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_insp
                          ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp child
                          ON child.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_insp
                          ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp
                          ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                        JOIN dbo.ics_proj_type child
                          ON child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_non_cnst_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_non_cnst_insp
                          ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_cnst_indst_insp child
                          ON child.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_non_cnst_insp
                          ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp child
                          ON child.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_cnst_non_cnst_insp
                          ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp
                          ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                        JOIN dbo.ics_proj_type child
                          ON child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_MS_4_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_ms_4_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_MS_4_INSP/ICS_PROJ_SRCS_FUND
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_ms_4_insp
                          ON ics_sw_ms_4_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_proj_srcs_fund child
                          ON child.ics_sw_ms_4_insp_id = ics_sw_ms_4_insp.ics_sw_ms_4_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_non_cnst_insp child
                          ON child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_non_cnst_insp
                          ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_cnst_indst_insp child
                          ON child.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_non_cnst_insp
                          ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp child
                          ON child.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                      UNION ALL
                      -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon
                        JOIN dbo.ics_sw_non_cnst_insp
                          ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                        JOIN dbo.ics_sw_unprmt_cnst_insp
                          ON ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                        JOIN dbo.ics_proj_type child
                          ON child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cmpl_mon
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_EFFLU_TRADE_PRTNER' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_EFFLU_TRADE_PRTNER
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_efflu_trade_prtner child
                      UNION ALL
                      -- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_efflu_trade_prtner
                        JOIN dbo.ics_efflu_trade_prtner_addr child
                          ON child.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
                      UNION ALL
                      -- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_efflu_trade_prtner
                        JOIN dbo.ics_efflu_trade_prtner_addr
                          ON ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_efflu_trade_prtner_addr_id = ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_addr_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_efflu_trade_prtner
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_FRML_ENFRC_ACTN' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_FRML_ENFRC_ACTN
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn child
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_enfrc_actn_gov_contact child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_enfrc_actn_type child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_enfrc_agncy child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_final_order child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_FINAL_ORDER_PRMT_IDENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_final_order
                          ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                        JOIN dbo.ics_final_order_prmt_ident child
                          ON child.ics_final_order_id = ics_final_order.ics_final_order_id
                      UNION ALL
                      --  5.6
                      -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_SEP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_final_order
                          ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                        JOIN dbo.ics_sep child
                          ON child.ics_final_order_id = ics_final_order.ics_final_order_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_PRMT_IDENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_prmt_ident child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_FRML_ENFRC_ACTN/ICS_PROGS_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_frml_enfrc_actn
                        JOIN dbo.ics_progs_viol child
                          ON child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_frml_enfrc_actn
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_INFRML_ENFRC_ACTN' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_INFRML_ENFRC_ACTN
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_infrml_enfrc_actn child
                      UNION ALL
                      -- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_infrml_enfrc_actn
                        JOIN dbo.ics_enfrc_actn_gov_contact child
                          ON child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_infrml_enfrc_actn
                        JOIN dbo.ics_enfrc_agncy child
                          ON child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_INFRML_ENFRC_ACTN/ICS_PRMT_IDENT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_infrml_enfrc_actn
                        JOIN dbo.ics_prmt_ident child
                          ON child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                      UNION ALL
                      -- /ICS_INFRML_ENFRC_ACTN/ICS_PROGS_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_infrml_enfrc_actn
                        JOIN dbo.ics_progs_viol child
                          ON child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_infrml_enfrc_actn
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CMPL_SCHD' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CMPL_SCHD
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_schd child
                      UNION ALL
                      -- /ICS_CMPL_SCHD/ICS_CMPL_SCHD_EVT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_schd
                        JOIN dbo.ics_cmpl_schd_evt child
                          ON child.ics_cmpl_schd_id = ics_cmpl_schd.ics_cmpl_schd_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cmpl_schd
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SW_EVT_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SW_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_evt_rep child
                      UNION ALL
                      -- /ICS_SW_EVT_REP/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_evt_rep
                        JOIN dbo.ics_addr child
                          ON child.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                      UNION ALL
                      -- /ICS_SW_EVT_REP/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_evt_rep
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SW_EVT_REP/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_evt_rep
                        JOIN dbo.ics_contact child
                          ON child.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                      UNION ALL
                      -- /ICS_SW_EVT_REP/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sw_evt_rep
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_sw_evt_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CAFO_ANNUL_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CAFO_ANNUL_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_annul_rep child
                      UNION ALL
                      -- /ICS_CAFO_ANNUL_REP/ICS_REP_ANML_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cafo_annul_rep
                        JOIN dbo.ics_rep_anml_type child
                          ON child.ics_cafo_annul_rep_id = ics_cafo_annul_rep.ics_cafo_annul_rep_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cafo_annul_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_LOC_LMTS_PROG_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_LOC_LMTS_PROG_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_loc_lmts_prog_rep child
                      UNION ALL
                      -- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_loc_lmts_prog_rep
                        JOIN dbo.ics_loc_lmts child
                          ON child.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                      UNION ALL
                      -- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_loc_lmts_prog_rep
                        JOIN dbo.ics_loc_lmts
                          ON ics_loc_lmts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                        JOIN dbo.ics_loc_lmts_polut child
                          ON child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                      UNION ALL
                      -- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_loc_lmts_prog_rep
                        JOIN dbo.ics_rmvl_crdts child
                          ON child.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                      UNION ALL
                      -- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_loc_lmts_prog_rep
                        JOIN dbo.ics_rmvl_crdts
                          ON ics_rmvl_crdts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                        JOIN dbo.ics_rmvl_crdts_polut child
                          ON child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_loc_lmts_prog_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_PRETR_PERF_SUMM' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_PRETR_PERF_SUMM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_perf_summ child
                      UNION ALL
                      -- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_perf_summ
                        JOIN dbo.ics_loc_lmts child
                          ON child.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                      UNION ALL
                      -- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_perf_summ
                        JOIN dbo.ics_loc_lmts
                          ON ics_loc_lmts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                        JOIN dbo.ics_loc_lmts_polut child
                          ON child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                      UNION ALL
                      -- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_perf_summ
                        JOIN dbo.ics_rmvl_crdts child
                          ON child.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                      UNION ALL
                      -- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_pretr_perf_summ
                        JOIN dbo.ics_rmvl_crdts
                          ON ics_rmvl_crdts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                        JOIN dbo.ics_rmvl_crdts_polut child
                          ON child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_pretr_perf_summ
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SSO_EVT_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SSO_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sso_evt_rep child
                      UNION ALL
                      -- /ICS_SSO_EVT_REP/ICS_IMPACT_SSO_EVT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sso_evt_rep
                        JOIN dbo.ics_impact_sso_evt child
                          ON child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
                      UNION ALL
                      -- /ICS_SSO_EVT_REP/ICS_SSO_STPS
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sso_evt_rep
                        JOIN dbo.ics_sso_stps child
                          ON child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
                      UNION ALL
                      -- /ICS_SSO_EVT_REP/ICS_SSO_SYSTM_COMP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_sso_evt_rep
                        JOIN dbo.ics_sso_systm_comp child
                          ON child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_sso_evt_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SWMS_4_PROG_REP' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SWMS_4_PROG_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep child
                      UNION ALL
                      -- /ICS_SWMS_4_PROG_REP/ICS_ADDR
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep
                        JOIN dbo.ics_addr child
                          ON child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                      UNION ALL
                      -- /ICS_SWMS_4_PROG_REP/ICS_ADDR/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep
                        JOIN dbo.ics_addr
                          ON ics_addr.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL
                      -- /ICS_SWMS_4_PROG_REP/ICS_CONTACT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep
                        JOIN dbo.ics_contact child
                          ON child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                      UNION ALL
                      -- /ICS_SWMS_4_PROG_REP/ICS_CONTACT/ICS_TELEPH
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep
                        JOIN dbo.ics_contact
                          ON ics_contact.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                        JOIN dbo.ics_teleph child
                          ON child.ics_contact_id = ics_contact.ics_contact_id
                      UNION ALL
                      -- /ICS_SWMS_4_PROG_REP/ICS_PROJ_SRCS_FUND
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_swms_4_prog_rep
                        JOIN dbo.ics_proj_srcs_fund child
                          ON child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_swms_4_prog_rep
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_CMPL_MON_LNK' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_CMPL_MON_LNK
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk child
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_BS_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_bs_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_CAFO_ANNUL_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_cafo_annul_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_CSO_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_cso_evt_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_ENFRC_ACTN
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_enfrc_actn child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_FEDR_CMPL_MON
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_fedr_cmpl_mon child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_LOC_LMTS_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_loc_lmts_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_PRETR_PERF_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_pretr_perf_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SNGL_EVT
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_sngl_evt child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_ANNUL_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_sso_annul_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_sso_evt_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_MONTHLY_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_sso_monthly_evt_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_ST_CMPL_MON
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_st_cmpl_mon child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SW_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_sw_evt_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                      UNION ALL
                      -- /ICS_CMPL_MON_LNK/ICS_LNK_SWMS_4_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_cmpl_mon_lnk
                        JOIN dbo.ics_lnk_swms_4_rep child
                          ON child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_cmpl_mon_lnk
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_ENFRC_ACTN_VIOL_LNK' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_ENFRC_ACTN_VIOL_LNK
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk child
                      UNION ALL
                      -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_CMPL_SCHD_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk
                        JOIN dbo.ics_cmpl_schd_viol child
                          ON child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                      UNION ALL
                      -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk
                        JOIN dbo.ics_dsch_mon_rep_param_viol child
                          ON child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                      UNION ALL
                      -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk
                        JOIN dbo.ics_dsch_mon_rep_viol child
                          ON child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                      UNION ALL
                      -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_PRMT_SCHD_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk
                        JOIN dbo.ics_prmt_schd_viol child
                          ON child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                      UNION ALL
                      -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_SNGL_EVTS_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_enfrc_actn_viol_lnk
                        JOIN dbo.ics_sngl_evts_viol child
                          ON child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_enfrc_actn_viol_lnk
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_SCHD_EVT_VIOL' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_SCHD_EVT_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_schd_evt_viol child
                      UNION ALL
                      -- /ICS_SCHD_EVT_VIOL/ICS_CMPL_SCHD_EVT_VIOL_ELEM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_schd_evt_viol
                        JOIN dbo.ics_cmpl_schd_evt_viol_elem child
                          ON child.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
                      UNION ALL
                      -- /ICS_SCHD_EVT_VIOL/ICS_PRMT_SCHD_EVT_VIOL_ELEM
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_schd_evt_viol
                        JOIN dbo.ics_prmt_schd_evt_viol_elem child
                          ON child.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_schd_evt_viol
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_DMR_PROG_REP_LNK' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_DMR_PROG_REP_LNK
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dmr_prog_rep_lnk child
                      UNION ALL
                      -- /ICS_DMR_PROG_REP_LNK/ICS_LNK_BS_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dmr_prog_rep_lnk
                        JOIN dbo.ics_lnk_bs_rep child
                          ON child.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
                      UNION ALL
                      -- /ICS_DMR_PROG_REP_LNK/ICS_LNK_SW_EVT_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_dmr_prog_rep_lnk
                        JOIN dbo.ics_lnk_sw_evt_rep child
                          ON child.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_dmr_prog_rep_lnk
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;

          IF @p_payload_type = 'ICS_FINAL_ORDER_VIOL_LNK' and @v_enabled = 'Y'
             BEGIN

             WITH tmp (key_hash, data_hash) AS
             ( SELECT TOP 100 PERCENT here.key_hash, here.data_hash
             FROM (
                      -- /ICS_FINAL_ORDER_VIOL_LNK
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk child
                      UNION ALL
                      -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_CMPL_SCHD_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk
                        JOIN dbo.ics_cmpl_schd_viol child
                          ON child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                      UNION ALL
                      -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk
                        JOIN dbo.ics_dsch_mon_rep_param_viol child
                          ON child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                      UNION ALL
                      -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk
                        JOIN dbo.ics_dsch_mon_rep_viol child
                          ON child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                      UNION ALL
                      -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_PRMT_SCHD_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk
                        JOIN dbo.ics_prmt_schd_viol child
                          ON child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                      UNION ALL
                      -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_SNGL_EVTS_VIOL
                      SELECT key_hash
                           , child.data_hash
                        FROM dbo.ics_final_order_viol_lnk
                        JOIN dbo.ics_sngl_evts_viol child
                          ON child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             ) here
             WHERE here.key_hash = @v_key_hash
             ORDER BY here.data_hash)

              SELECT @v_working_data_hash = ics_flow_local.dbo.hashbytes_varchar('SHA1', COALESCE(@v_working_data_hash,'#') + data_hash)
                FROM tmp
               WHERE tmp.key_hash = @v_key_hash
               ORDER BY data_hash

              UPDATE dbo.ics_final_order_viol_lnk
                 SET data_hash = @v_working_data_hash
               WHERE key_hash = @v_key_hash
             END;
          
          /* Get next key_hash value...  */
          FETCH NEXT FROM key_hash INTO @v_key_hash;
                  
        END; -- key_loop   
       
      /*  Close the key_hash cursor */
      CLOSE key_hash;

      /*  Get the next payload type. */
      FETCH NEXT FROM payload_type_process 
      INTO @p_payload_type;
      
    END; -- payload_t--END LOOP module_loop;

  /*  Close payload type cursor */
  CLOSE payload_type_process;
  
  /*  Destroy the payload type cursor */
 
  DEALLOCATE payload_type_process;  
  DEALLOCATE key_hash;  
 
/* -=-=-=-=-=-=- END COPY TO INDICATED SECTION IN ICS_SET_HASHES -=-=-=-=-=-=-=-=-= */    
  
  DEALLOCATE payload_type_delete;   
   --PRINT 'Change Detection: Begin setting transaction_type at ' + CONVERT(VARCHAR(24),GETDATE(),113)

  /******************************************************************************************************************************
  ** Description:  The following code sets the new, change, replace, etc... ics transaction_type flags throughout the entire ICS 
  **               schema.  Once these flags are set the data will be marked as either new, changed and will allow the OPENNODE2 
  **               plug-in the ability to pull the data, bundle into .xml, and then submit to an exchange partner.
  ******************************************************************************************************************************/
  -- Generates SQL INSERT and UPDATE Statements to set TransactionCode values based on changes to staged data
-- Date Generated: Monday, July 09, 2012


  UPDATE dbo.ics_basic_prmt
     SET transaction_type = (SELECT CASE cdv_basic_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_basic_prmt cdv_basic_prmt
                                               WHERE cdv_basic_prmt.key_hash = ics_basic_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'BasicPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_BS_ANNUL_PROG_REP - Set New/Replace Transactions
  UPDATE dbo.ics_bs_annul_prog_rep
     SET transaction_type = (SELECT CASE cdv_bs_annul_prog_rep.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_bs_annul_prog_rep cdv_bs_annul_prog_rep
                                               WHERE cdv_bs_annul_prog_rep.key_hash = ics_bs_annul_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'BiosolidsAnnualProgramReportSubmission' AND enabled = 'Y') = 1);
                                                 
  -- ICS_BS_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_bs_prmt
     SET transaction_type = (SELECT CASE cdv_bs_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_bs_prmt cdv_bs_prmt
                                               WHERE cdv_bs_prmt.key_hash = ics_bs_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'BiosolidsPermitSubmission' AND enabled = 'Y') = 1);
    
  -- ICS_CAFO_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_cafo_prmt
     SET transaction_type = (SELECT CASE cdv_cafo_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cafo_prmt cdv_cafo_prmt
                                               WHERE cdv_cafo_prmt.key_hash = ics_cafo_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'CAFOPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CSO_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_cso_prmt
     SET transaction_type = (SELECT CASE cdv_cso_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cso_prmt cdv_cso_prmt
                                               WHERE cdv_cso_prmt.key_hash = ics_cso_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'CSOPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_MON - Set New/Replace Transactions
  UPDATE dbo.ics_cmpl_mon
     SET transaction_type = (SELECT CASE cdv_cmpl_mon.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cmpl_mon cdv_cmpl_mon
                                               WHERE cdv_cmpl_mon.key_hash = ics_cmpl_mon.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'ComplianceMonitoringSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_GNRL_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_gnrl_prmt
     SET transaction_type = (SELECT CASE cdv_gnrl_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_gnrl_prmt cdv_gnrl_prmt
                                               WHERE cdv_gnrl_prmt.key_hash = ics_gnrl_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'GeneralPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_MASTER_GNRL_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_master_gnrl_prmt
     SET transaction_type = (SELECT CASE cdv_master_gnrl_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_master_gnrl_prmt cdv_master_gnrl_prmt
                                               WHERE cdv_master_gnrl_prmt.key_hash = ics_master_gnrl_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'MasterGeneralPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_REISSU - Set New/Replace Transactions
  UPDATE dbo.ics_prmt_reissu
     SET transaction_type = (SELECT CASE cdv_prmt_reissu.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_prmt_reissu cdv_prmt_reissu
                                               WHERE cdv_prmt_reissu.key_hash = ics_prmt_reissu.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PermitReissuanceSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_TERM - Set New/Replace Transactions
  UPDATE dbo.ics_prmt_term
     SET transaction_type = (SELECT CASE cdv_prmt_term.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_prmt_term cdv_prmt_term
                                               WHERE cdv_prmt_term.key_hash = ics_prmt_term.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PermitTerminationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_TRACK_EVT - Set New/Replace Transactions
  UPDATE dbo.ics_prmt_track_evt
     SET transaction_type = (SELECT CASE cdv_prmt_track_evt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_prmt_track_evt cdv_prmt_track_evt
                                               WHERE cdv_prmt_track_evt.key_hash = ics_prmt_track_evt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PermitTrackingEventSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_POTW_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_potw_prmt
     SET transaction_type = (SELECT CASE cdv_potw_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_potw_prmt cdv_potw_prmt
                                               WHERE cdv_potw_prmt.key_hash = ics_potw_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'POTWPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRETR_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_pretr_prmt
     SET transaction_type = (SELECT CASE cdv_pretr_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_pretr_prmt cdv_pretr_prmt
                                               WHERE cdv_pretr_prmt.key_hash = ics_pretr_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PretreatmentPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_CNST_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_sw_cnst_prmt
     SET transaction_type = (SELECT CASE cdv_sw_cnst_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sw_cnst_prmt cdv_sw_cnst_prmt
                                               WHERE cdv_sw_cnst_prmt.key_hash = ics_sw_cnst_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWConstructionPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_INDST_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_sw_indst_prmt
     SET transaction_type = (SELECT CASE cdv_sw_indst_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sw_indst_prmt cdv_sw_indst_prmt
                                               WHERE cdv_sw_indst_prmt.key_hash = ics_sw_indst_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWIndustrialPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SWMS_4_LARGE_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_swms_4_large_prmt
     SET transaction_type = (SELECT CASE cdv_swms_4_large_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_swms_4_large_prmt cdv_swms_4_large_prmt
                                               WHERE cdv_swms_4_large_prmt.key_hash = ics_swms_4_large_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWMS4LargePermitSubmission' AND enabled = 'Y') = 1);

  -- ICS_SWMS_4_SMALL_PRMT - Set New/Replace Transactions
  UPDATE dbo.ics_swms_4_small_prmt
     SET transaction_type = (SELECT CASE cdv_swms_4_small_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_swms_4_small_prmt cdv_swms_4_small_prmt
                                               WHERE cdv_swms_4_small_prmt.key_hash = ics_swms_4_small_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWMS4SmallPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_UNPRMT_FAC - Set New/Replace Transactions
  UPDATE dbo.ics_unprmt_fac
     SET transaction_type = (SELECT CASE cdv_unprmt_fac.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_unprmt_fac cdv_unprmt_fac
                                               WHERE cdv_unprmt_fac.key_hash = ics_unprmt_fac.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'UnpermittedFacilitySubmission' AND enabled = 'Y') = 1);
  
  -- ICS_HIST_PRMT_SCHD_EVTS - Set New/Replace Transactions
  UPDATE dbo.ics_hist_prmt_schd_evts
     SET transaction_type = (SELECT CASE cdv_hist_prmt_schd_evts.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_hist_prmt_schd_evts cdv_hist_prmt_schd_evts
                                               WHERE cdv_hist_prmt_schd_evts.key_hash = ics_hist_prmt_schd_evts.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'HistoricalPermitScheduleEventsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_NARR_COND_SCHD - Set New/Replace Transactions
  UPDATE dbo.ics_narr_cond_schd
     SET transaction_type = (SELECT CASE cdv_narr_cond_schd.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_narr_cond_schd cdv_narr_cond_schd
                                               WHERE cdv_narr_cond_schd.key_hash = ics_narr_cond_schd.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'NarrativeConditionScheduleSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_FEATR - Set New/Replace Transactions
  UPDATE dbo.ics_prmt_featr
     SET transaction_type = (SELECT CASE cdv_prmt_featr.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_prmt_featr cdv_prmt_featr
                                               WHERE cdv_prmt_featr.key_hash = ics_prmt_featr.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PermittedFeatureSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LMT_SET - Set New/Replace Transactions
  UPDATE dbo.ics_lmt_set
     SET transaction_type = (SELECT CASE cdv_lmt_set.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_lmt_set cdv_lmt_set
                                               WHERE cdv_lmt_set.key_hash = ics_lmt_set.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'LimitSetSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LMTS - Set New/Replace Transactions
  UPDATE dbo.ics_lmts
     SET transaction_type = (SELECT CASE cdv_lmts.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_lmts cdv_lmts
                                               WHERE cdv_lmts.key_hash = ics_lmts.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'LimitsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PARAM_LMTS - Set New/Replace Transactions
  UPDATE dbo.ics_param_lmts
     SET transaction_type = (SELECT CASE cdv_param_lmts.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_param_lmts cdv_param_lmts
                                               WHERE cdv_param_lmts.key_hash = ics_param_lmts.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'ParameterLimitsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DSCH_MON_REP - Set New/Replace Transactions
  UPDATE dbo.ics_dsch_mon_rep
     SET transaction_type = (SELECT CASE cdv_dsch_mon_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_dsch_mon_rep cdv_dsch_mon_rep
                                               WHERE cdv_dsch_mon_rep.key_hash = ics_dsch_mon_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'DischargeMonitoringReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SNGL_EVT_VIOL - Set New/Replace Transactions
  UPDATE dbo.ics_sngl_evt_viol
     SET transaction_type = (SELECT CASE cdv_sngl_evt_viol.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sngl_evt_viol cdv_sngl_evt_viol
                                               WHERE cdv_sngl_evt_viol.key_hash = ics_sngl_evt_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SingleEventViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_SCHD - Set New/Replace Transactions
  UPDATE dbo.ics_cmpl_schd
     SET transaction_type = (SELECT CASE cdv_cmpl_schd.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cmpl_schd cdv_cmpl_schd
                                               WHERE cdv_cmpl_schd.key_hash = ics_cmpl_schd.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'ComplianceScheduleSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DMR_VIOL - Set New/Replace Transactions
  UPDATE dbo.ics_dmr_viol
     SET transaction_type = (SELECT CASE cdv_dmr_viol.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_dmr_viol cdv_dmr_viol
                                               WHERE cdv_dmr_viol.key_hash = ics_dmr_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'DMRViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_EFFLU_TRADE_PRTNER - Set New/Replace Transactions
  UPDATE dbo.ics_efflu_trade_prtner
     SET transaction_type = (SELECT CASE cdv_efflu_trade_prtner.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_efflu_trade_prtner cdv_efflu_trade_prtner
                                               WHERE cdv_efflu_trade_prtner.key_hash = ics_efflu_trade_prtner.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'EffluentTradePartnerSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_FRML_ENFRC_ACTN - Set New/Replace Transactions
  UPDATE dbo.ics_frml_enfrc_actn
     SET transaction_type = (SELECT CASE cdv_frml_enfrc_actn.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_frml_enfrc_actn cdv_frml_enfrc_actn
                                               WHERE cdv_frml_enfrc_actn.key_hash = ics_frml_enfrc_actn.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'FormalEnforcementActionSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_INFRML_ENFRC_ACTN - Set New/Replace Transactions
  UPDATE dbo.ics_infrml_enfrc_actn
     SET transaction_type = (SELECT CASE cdv_infrml_enfrc_actn.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_infrml_enfrc_actn cdv_infrml_enfrc_actn
                                               WHERE cdv_infrml_enfrc_actn.key_hash = ics_infrml_enfrc_actn.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'InformalEnforcementActionSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_ENFRC_ACTN_MILESTONE - Set New/Replace Transactions
  UPDATE dbo.ics_enfrc_actn_milestone
     SET transaction_type = (SELECT CASE cdv_enfrc_actn_milestone.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_enfrc_actn_milestone cdv_enfrc_actn_milestone
                                               WHERE cdv_enfrc_actn_milestone.key_hash = ics_enfrc_actn_milestone.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'EnforcementActionMilestoneSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_FINAL_ORDER_VIOL_LNK - Set New/Replace Transactions
  UPDATE dbo.ics_final_order_viol_lnk
     SET transaction_type = (SELECT CASE cdv_final_order_viol_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_final_order_viol_lnk cdv_final_order_viol_lnk
                                               WHERE cdv_final_order_viol_lnk.key_hash = ics_final_order_viol_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'FinalOrderViolationLinkageSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CSO_EVT_REP - Set New/Replace Transactions
  UPDATE dbo.ics_cso_evt_rep
     SET transaction_type = (SELECT CASE cdv_cso_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cso_evt_rep cdv_cso_evt_rep
                                               WHERE cdv_cso_evt_rep.key_hash = ics_cso_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'CSOEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_EVT_REP - Set New/Replace Transactions
  UPDATE dbo.ics_sw_evt_rep
     SET transaction_type = (SELECT CASE cdv_sw_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sw_evt_rep cdv_sw_evt_rep
                                               WHERE cdv_sw_evt_rep.key_hash = ics_sw_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CAFO_ANNUL_REP - Set New/Replace Transactions
  UPDATE dbo.ics_cafo_annul_rep
     SET transaction_type = (SELECT CASE cdv_cafo_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cafo_annul_rep cdv_cafo_annul_rep
                                               WHERE cdv_cafo_annul_rep.key_hash = ics_cafo_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'CAFOAnnualReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LOC_LMTS_PROG_REP - Set New/Replace Transactions
  UPDATE dbo.ics_loc_lmts_prog_rep
     SET transaction_type = (SELECT CASE cdv_loc_lmts_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_loc_lmts_prog_rep cdv_loc_lmts_prog_rep
                                               WHERE cdv_loc_lmts_prog_rep.key_hash = ics_loc_lmts_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'LocalLimitsProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRETR_PERF_SUMM - Set New/Replace Transactions
  UPDATE dbo.ics_pretr_perf_summ
     SET transaction_type = (SELECT CASE cdv_pretr_perf_summ.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_pretr_perf_summ cdv_pretr_perf_summ
                                               WHERE cdv_pretr_perf_summ.key_hash = ics_pretr_perf_summ.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'PretreatmentPerformanceSummarySubmission' AND enabled = 'Y') = 1);
  
  -- ICS_BS_PROG_REP - Set New/Replace Transactions
  UPDATE dbo.ics_bs_prog_rep
     SET transaction_type = (SELECT CASE cdv_bs_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_bs_prog_rep cdv_bs_prog_rep
                                               WHERE cdv_bs_prog_rep.key_hash = ics_bs_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'BiosolidsProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_ANNUL_REP - Set New/Replace Transactions
  UPDATE dbo.ics_sso_annul_rep
     SET transaction_type = (SELECT CASE cdv_sso_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sso_annul_rep cdv_sso_annul_rep
                                               WHERE cdv_sso_annul_rep.key_hash = ics_sso_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SSOAnnualReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_EVT_REP - Set New/Replace Transactions
  UPDATE dbo.ics_sso_evt_rep
     SET transaction_type = (SELECT CASE cdv_sso_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sso_evt_rep cdv_sso_evt_rep
                                               WHERE cdv_sso_evt_rep.key_hash = ics_sso_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SSOEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_MONTHLY_EVT_REP - Set New/Replace Transactions
  UPDATE dbo.ics_sso_monthly_evt_rep
     SET transaction_type = (SELECT CASE cdv_sso_monthly_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sso_monthly_evt_rep cdv_sso_monthly_evt_rep
                                               WHERE cdv_sso_monthly_evt_rep.key_hash = ics_sso_monthly_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SSOMonthlyEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SWMS_4_PROG_REP - Set New/Replace Transactions
  UPDATE dbo.ics_swms_4_prog_rep
     SET transaction_type = (SELECT CASE cdv_swms_4_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_swms_4_prog_rep cdv_swms_4_prog_rep
                                               WHERE cdv_swms_4_prog_rep.key_hash = ics_swms_4_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWMS4ProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SCHD_EVT_VIOL - Set New/Replace Transactions
  UPDATE dbo.ics_schd_evt_viol
     SET transaction_type = (SELECT CASE cdv_schd_evt_viol.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM dbo.cdv_schd_evt_viol cdv_schd_evt_viol
                                               WHERE cdv_schd_evt_viol.key_hash = ics_schd_evt_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'ScheduleEventViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_MON_LNK - Set New/Replace Transactions
  UPDATE dbo.ics_cmpl_mon_lnk
     SET transaction_type = (SELECT CASE cdv_cmpl_mon_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_cmpl_mon_lnk cdv_cmpl_mon_lnk
                                               WHERE cdv_cmpl_mon_lnk.key_hash = ics_cmpl_mon_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'ComplianceMonitoringLinkageSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_ENFRC_ACTN_VIOL_LNK - Set New/Replace Transactions
  UPDATE dbo.ics_enfrc_actn_viol_lnk
     SET transaction_type = (SELECT CASE cdv_enfrc_actn_viol_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_enfrc_actn_viol_lnk cdv_enfrc_actn_viol_lnk
                                               WHERE cdv_enfrc_actn_viol_lnk.key_hash = ics_enfrc_actn_viol_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'EnforcementActionViolationLinkageSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DMR_PROG_REP_LNK - Set New/Replace Transactions
  UPDATE dbo.ics_dmr_prog_rep_lnk
     SET transaction_type = (SELECT CASE cdv_dmr_prog_rep_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_dmr_prog_rep_lnk cdv_dmr_prog_rep_lnk
                                               WHERE cdv_dmr_prog_rep_lnk.key_hash = ics_dmr_prog_rep_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'DMRProgramReportLinkageSubmission' AND enabled = 'Y') = 1);

  -- ICS_SW_INDST_ANNUL_REP - Set New/Replace Transactions
  UPDATE dbo.ics_sw_indst_annul_rep
     SET transaction_type = (SELECT CASE cdv_sw_indst_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM dbo.cdv_sw_indst_annul_rep cdv_sw_indst_annul_rep
                                               WHERE cdv_sw_indst_annul_rep.key_hash = ics_sw_indst_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM dbo.ics_payload WHERE operation = 'SWIndustrialAnnualReportSubmission' AND enabled = 'Y') = 1);
 
  --PRINT 'Change Detection: Begin setting delete transactions at ' + CONVERT(VARCHAR(24),GETDATE(),113)

	-- ICS_BASIC_PRMT - Set Delete Transactions
	INSERT INTO dbo.ics_basic_prmt
       ( ics_payload_id
       , ics_basic_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_basic_prmt.ics_payload_id
        , ics_basic_prmt.ics_basic_prmt_id
        , 'D' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_basic_prmt ics_basic_prmt
    WHERE ics_basic_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'BasicPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_basic_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_basic_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_BS_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_bs_prmt
       ( ics_payload_id
       , ics_bs_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_bs_prmt.ics_payload_id
        , ics_bs_prmt.ics_bs_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_bs_prmt ics_bs_prmt
    WHERE ics_bs_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'BiosolidsPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_bs_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_bs_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_CAFO_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_cafo_prmt
       ( ics_payload_id
       , ics_cafo_prmt_id
       , transaction_type
       , prmt_ident
	   , key_hash
       , data_hash) 
   SELECT ics_cafo_prmt.ics_payload_id
        , ics_cafo_prmt.ics_cafo_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cafo_prmt ics_cafo_prmt
    WHERE ics_cafo_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'CAFOPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cafo_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cafo_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_CSO_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_cso_prmt
       ( ics_payload_id
       , ics_cso_prmt_id
       , transaction_type
       , prmt_ident
	   , key_hash
       , data_hash) 
   SELECT ics_cso_prmt.ics_payload_id
        , ics_cso_prmt.ics_cso_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cso_prmt ics_cso_prmt
    WHERE ics_cso_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'CSOPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cso_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cso_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_CMPL_MON - Set Delete Transactions
  INSERT INTO dbo.ics_cmpl_mon
       ( ics_payload_id
       , ics_cmpl_mon_id
       , transaction_type
       , cmpl_mon_ident
       , key_hash
       , data_hash) 
   SELECT ics_cmpl_mon.ics_payload_id
        , ics_cmpl_mon.ics_cmpl_mon_id
        , 'X' AS transaction_type
        , cmpl_mon_ident
        , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_mon ics_cmpl_mon
    WHERE ics_cmpl_mon.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'ComplianceMonitoringSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_cmpl_mon.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cmpl_mon
                                       WHERE action_type = 'DELETE');
  
  -- ICS_GNRL_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_gnrl_prmt
       ( ics_payload_id
       , ics_gnrl_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_gnrl_prmt.ics_payload_id
        , ics_gnrl_prmt.ics_gnrl_prmt_id
        , 'D' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash 
     FROM [ICS_FLOW_ICIS].dbo.ics_gnrl_prmt ics_gnrl_prmt
    WHERE ics_gnrl_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'GeneralPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_gnrl_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_gnrl_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_MASTER_GNRL_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_master_gnrl_prmt
       ( ics_payload_id
       , ics_master_gnrl_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_master_gnrl_prmt.ics_payload_id
        , ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
        , 'D' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_master_gnrl_prmt ics_master_gnrl_prmt
    WHERE ics_master_gnrl_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'MasterGeneralPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_master_gnrl_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_master_gnrl_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_PRMT_REISSU - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_PRMT_TERM - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_PRMT_TRACK_EVT - Set Delete Transactions
  INSERT INTO dbo.ics_prmt_track_evt
       ( ics_payload_id
       , ics_prmt_track_evt_id
       , transaction_type
       , prmt_ident, prmt_track_evt_code, prmt_track_evt_date
	     , key_hash
       , data_hash) 
   SELECT ics_prmt_track_evt.ics_payload_id
        , ics_prmt_track_evt.ics_prmt_track_evt_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_track_evt_code, prmt_track_evt_date
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_prmt_track_evt ics_prmt_track_evt
    WHERE ics_prmt_track_evt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'PermitTrackingEventSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_prmt_track_evt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_prmt_track_evt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_POTW_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_potw_prmt
       ( ics_payload_id
       , ics_potw_prmt_id
       , transaction_type
       , prmt_ident
	   , key_hash
       , data_hash) 
   SELECT ics_potw_prmt.ics_payload_id
        , ics_potw_prmt.ics_potw_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_potw_prmt ics_potw_prmt
    WHERE ics_potw_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'POTWPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_potw_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_potw_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_PRETR_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_pretr_prmt
       ( ics_payload_id
       , ics_pretr_prmt_id
       , transaction_type
       , prmt_ident
	   , key_hash
       , data_hash) 
   SELECT ics_pretr_prmt.ics_payload_id
        , ics_pretr_prmt.ics_pretr_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_pretr_prmt ics_pretr_prmt
    WHERE ics_pretr_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'PretreatmentPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_pretr_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_pretr_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SW_CNST_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_sw_cnst_prmt
       ( ics_payload_id
       , ics_sw_cnst_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_sw_cnst_prmt.ics_payload_id
        , ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sw_cnst_prmt ics_sw_cnst_prmt
    WHERE ics_sw_cnst_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWConstructionPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_cnst_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sw_cnst_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SW_INDST_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_sw_indst_prmt
       ( ics_payload_id
       , ics_sw_indst_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_sw_indst_prmt.ics_payload_id
        , ics_sw_indst_prmt.ics_sw_indst_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sw_indst_prmt ics_sw_indst_prmt
    WHERE ics_sw_indst_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWIndustrialPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_sw_indst_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sw_indst_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SWMS_4_LARGE_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_swms_4_large_prmt
       ( ics_payload_id
       , ics_swms_4_large_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_swms_4_large_prmt.ics_payload_id
        , ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_swms_4_large_prmt ics_swms_4_large_prmt
    WHERE ics_swms_4_large_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWMS4LargePermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_large_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_swms_4_large_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SWMS_4_SMALL_PRMT - Set Delete Transactions
  INSERT INTO dbo.ics_swms_4_small_prmt
       ( ics_payload_id
       , ics_swms_4_small_prmt_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_swms_4_small_prmt.ics_payload_id
        , ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
        , 'X' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash 
     FROM [ICS_FLOW_ICIS].dbo.ics_swms_4_small_prmt ics_swms_4_small_prmt
    WHERE ics_swms_4_small_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWMS4SmallPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_small_prmt.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_swms_4_small_prmt
                                       WHERE action_type = 'DELETE');
  
  -- ICS_UNPRMT_FAC - Set Delete Transactions
  INSERT INTO dbo.ics_unprmt_fac
       ( ics_payload_id
       , ics_unprmt_fac_id
       , transaction_type
       , prmt_ident
	     , key_hash
       , data_hash) 
   SELECT ics_unprmt_fac.ics_payload_id
        , ics_unprmt_fac.ics_unprmt_fac_id
        , 'X' AS transaction_type
        , prmt_ident
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_unprmt_fac ics_unprmt_fac
    WHERE ics_unprmt_fac.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'UnpermittedFacilitySubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_unprmt_fac.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_unprmt_fac
                                       WHERE action_type = 'DELETE');
  
  -- ICS_HIST_PRMT_SCHD_EVTS - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_NARR_COND_SCHD - Set Delete Transactions
  INSERT INTO dbo.ics_narr_cond_schd
       ( ics_payload_id
       , ics_narr_cond_schd_id
       , transaction_type
       , prmt_ident, narr_cond_num
	   , key_hash
       , data_hash) 
   SELECT ics_narr_cond_schd.ics_payload_id
        , ics_narr_cond_schd.ics_narr_cond_schd_id
        , 'X' AS transaction_type
        , prmt_ident, narr_cond_num
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_narr_cond_schd ics_narr_cond_schd
    WHERE ics_narr_cond_schd.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'NarrativeConditionScheduleSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_narr_cond_schd.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_narr_cond_schd
                                       WHERE action_type = 'DELETE');
  
  -- ICS_PRMT_FEATR - Set Delete Transactions
  INSERT INTO dbo.ics_prmt_featr
       ( ics_payload_id
       , ics_prmt_featr_id
       , transaction_type
       , prmt_ident, prmt_featr_ident
	   , key_hash
       , data_hash) 
   SELECT ics_prmt_featr.ics_payload_id
        , ics_prmt_featr.ics_prmt_featr_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident
		    , key_hash
        , data_hash 
     FROM [ICS_FLOW_ICIS].dbo.ics_prmt_featr ics_prmt_featr
    WHERE ics_prmt_featr.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'PermittedFeatureSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_prmt_featr.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_prmt_featr
                                       WHERE action_type = 'DELETE');
  
  -- ICS_LMT_SET - Set Delete Transactions
  INSERT INTO dbo.ics_lmt_set
       ( ics_payload_id
       , ics_lmt_set_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, lmt_set_type
	     , key_hash
       , data_hash) 
   SELECT ics_lmt_set.ics_payload_id
        , ics_lmt_set.ics_lmt_set_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, 'S'
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_lmt_set ics_lmt_set
    WHERE ics_lmt_set.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'LimitSetSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_lmt_set.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_lmt_set
                                       WHERE action_type = 'DELETE');
  
  -- ICS_LMTS - Set Delete Transactions
  INSERT INTO dbo.ics_lmts
       ( ics_payload_id
       , ics_lmts_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date
	     , key_hash
       , data_hash) 
   SELECT ics_lmts.ics_payload_id
        , ics_lmts.ics_lmts_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_lmts ics_lmts
    WHERE ics_lmts.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'LimitsSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_lmts.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_lmts
                                       WHERE action_type = 'DELETE');
  
  -- ICS_PARAM_LMTS - Set Delete Transactions
  INSERT INTO dbo.ics_param_lmts
       ( ics_payload_id
       , ics_param_lmts_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num
	   , key_hash
       , data_hash) 
   SELECT ics_param_lmts.ics_payload_id
        , ics_param_lmts.ics_param_lmts_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_param_lmts ics_param_lmts
    WHERE ics_param_lmts.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'ParameterLimitsSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_param_lmts.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_param_lmts
                                       WHERE action_type = 'DELETE');
  
  -- ICS_DSCH_MON_REP - Set Delete Transactions
  INSERT INTO dbo.ics_dsch_mon_rep
       ( ics_payload_id
       , ics_dsch_mon_rep_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, mon_period_end_date
	   , key_hash
       , data_hash) 
   SELECT ics_dsch_mon_rep.ics_payload_id
        , ics_dsch_mon_rep.ics_dsch_mon_rep_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, mon_period_end_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_dsch_mon_rep ics_dsch_mon_rep
    WHERE ics_dsch_mon_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'DischargeMonitoringReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_dsch_mon_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_dsch_mon_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SNGL_EVT_VIOL - Set Delete Transactions
  INSERT INTO dbo.ics_sngl_evt_viol
       ( ics_payload_id
       , ics_sngl_evt_viol_id
       , transaction_type
       , prmt_ident
       , sngl_evt_viol_code
       , sngl_evt_viol_date
	     , key_hash
       , data_hash) 
   SELECT ics_sngl_evt_viol.ics_payload_id
        , ics_sngl_evt_viol.ics_sngl_evt_viol_id
        , 'X' AS transaction_type
        , prmt_ident
        , sngl_evt_viol_code
        , sngl_evt_viol_date
		    , key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sngl_evt_viol ics_sngl_evt_viol
    WHERE ics_sngl_evt_viol.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SingleEventViolationSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_sngl_evt_viol.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sngl_evt_viol
                                       WHERE action_type = 'DELETE');
  
  -- ICS_CMPL_SCHD - Set Delete Transactions
  INSERT INTO dbo.ics_cmpl_schd
       ( ics_payload_id
       , ics_cmpl_schd_id
       , transaction_type
       , enfrc_actn_ident, final_order_ident, prmt_ident, cmpl_schd_num
	   , key_hash
       , data_hash) 
   SELECT ics_cmpl_schd.ics_payload_id
        , ics_cmpl_schd.ics_cmpl_schd_id
        , 'X' AS transaction_type
        , enfrc_actn_ident, final_order_ident, prmt_ident, cmpl_schd_num
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_schd ics_cmpl_schd
    WHERE ics_cmpl_schd.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'ComplianceScheduleSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cmpl_schd.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cmpl_schd
                                       WHERE action_type = 'DELETE');
  
  -- ICS_DMR_VIOL - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_EFFLU_TRADE_PRTNER - Set Delete Transactions
  INSERT INTO dbo.ics_efflu_trade_prtner
       ( ics_payload_id
       , ics_efflu_trade_prtner_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date, lmt_mod_effective_date, trade_id
	   , key_hash
       , data_hash) 
   SELECT ics_efflu_trade_prtner.ics_payload_id
        , ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date, lmt_mod_effective_date, trade_id
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_efflu_trade_prtner ics_efflu_trade_prtner
    WHERE ics_efflu_trade_prtner.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'EffluentTradePartnerSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_efflu_trade_prtner.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_efflu_trade_prtner
                                       WHERE action_type = 'DELETE');
  
  -- ICS_FRML_ENFRC_ACTN - Set Delete Transactions
  INSERT INTO dbo.ics_frml_enfrc_actn
       ( ics_payload_id
       , ics_frml_enfrc_actn_id
       , transaction_type
       , enfrc_actn_ident
       , reason_deleting_record
	   , key_hash
       , data_hash
       ) 
   SELECT ics_frml_enfrc_actn.ics_payload_id
        , ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
        , 'X' AS transaction_type
        , enfrc_actn_ident
        , 'This formal enforcement action should not have been sent.'
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_frml_enfrc_actn ics_frml_enfrc_actn
    WHERE ics_frml_enfrc_actn.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'FormalEnforcementActionSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_frml_enfrc_actn.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_frml_enfrc_actn
                                       WHERE action_type = 'DELETE');
  
  -- ICS_INFRML_ENFRC_ACTN - Set Delete Transactions
  INSERT INTO dbo.ics_infrml_enfrc_actn
       ( ics_payload_id
       , ics_infrml_enfrc_actn_id
       , transaction_type
       , enfrc_actn_ident
       , reason_deleting_record
	   , key_hash
       , data_hash) 
   SELECT ics_infrml_enfrc_actn.ics_payload_id
        , ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
        , 'X' AS transaction_type
        , enfrc_actn_ident
        , 'This informal enforcement action should not have been sent.'
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_infrml_enfrc_actn ics_infrml_enfrc_actn
    WHERE ics_infrml_enfrc_actn.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'InformalEnforcementActionSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_infrml_enfrc_actn.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_infrml_enfrc_actn
                                       WHERE action_type = 'DELETE');
  
  -- ICS_ENFRC_ACTN_MILESTONE - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_FINAL_ORDER_VIOL_LNK - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module

  -- ICS_CSO_EVT_REP - Set Delete Transactions
  INSERT INTO dbo.ics_cso_evt_rep
       ( ics_payload_id
       , ics_cso_evt_rep_id
       , transaction_type
       , prmt_ident, cso_evt_date
	   , key_hash
       , data_hash) 
   SELECT ics_cso_evt_rep.ics_payload_id
        , ics_cso_evt_rep.ics_cso_evt_rep_id
        , 'X' AS transaction_type
        , prmt_ident, cso_evt_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cso_evt_rep ics_cso_evt_rep
    WHERE ics_cso_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'CSOEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cso_evt_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cso_evt_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SW_EVT_REP - Set Delete Transactions
  INSERT INTO dbo.ics_sw_evt_rep
       ( ics_payload_id
       , ics_sw_evt_rep_id
       , transaction_type
       , prmt_ident, date_strm_evt_smpl
	   , key_hash
       , data_hash) 
   SELECT ics_sw_evt_rep.ics_payload_id
        , ics_sw_evt_rep.ics_sw_evt_rep_id
        , 'X' AS transaction_type
        , prmt_ident, date_strm_evt_smpl
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sw_evt_rep ics_sw_evt_rep
    WHERE ics_sw_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_evt_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sw_evt_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_CAFO_ANNUL_REP - Set Delete Transactions
  INSERT INTO dbo.ics_cafo_annul_rep
       ( ics_payload_id
       , ics_cafo_annul_rep_id
       , transaction_type
       , prmt_ident, prmt_auth_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_cafo_annul_rep.ics_payload_id
        , ics_cafo_annul_rep.ics_cafo_annul_rep_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_auth_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_cafo_annul_rep ics_cafo_annul_rep
    WHERE ics_cafo_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'CAFOAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cafo_annul_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_cafo_annul_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_LOC_LMTS_PROG_REP - Set Delete Transactions
  INSERT INTO dbo.ics_loc_lmts_prog_rep
       ( ics_payload_id
       , ics_loc_lmts_prog_rep_id
       , transaction_type
       , prmt_ident, prmt_auth_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_loc_lmts_prog_rep.ics_payload_id
        , ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
        , 'X' AS transaction_type
        , prmt_ident, prmt_auth_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_loc_lmts_prog_rep ics_loc_lmts_prog_rep
    WHERE ics_loc_lmts_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'LocalLimitsProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_loc_lmts_prog_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_loc_lmts_prog_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_PRETR_PERF_SUMM - Set Delete Transactions
  INSERT INTO dbo.ics_pretr_perf_summ
       ( ics_payload_id
       , ics_pretr_perf_summ_id
       , transaction_type
       , prmt_ident, pretr_perf_summ_end_date
	   , key_hash
       , data_hash) 
   SELECT ics_pretr_perf_summ.ics_payload_id
        , ics_pretr_perf_summ.ics_pretr_perf_summ_id
        , 'X' AS transaction_type
        , prmt_ident, pretr_perf_summ_end_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_pretr_perf_summ ics_pretr_perf_summ
    WHERE ics_pretr_perf_summ.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'PretreatmentPerformanceSummarySubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_pretr_perf_summ.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_pretr_perf_summ
                                       WHERE action_type = 'DELETE');
  
  -- ICS_BS_PROG_REP - Set Delete Transactions
  INSERT INTO dbo.ics_bs_prog_rep
       ( ics_payload_id
       , ics_bs_prog_rep_id
       , transaction_type
       , prmt_ident, rep_coverage_end_date
	   , key_hash
       , data_hash) 
   SELECT ics_bs_prog_rep.ics_payload_id
        , ics_bs_prog_rep.ics_bs_prog_rep_id
        , 'X' AS transaction_type
        , prmt_ident, rep_coverage_end_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_bs_prog_rep ics_bs_prog_rep
    WHERE ics_bs_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'BiosolidsProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_bs_prog_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_bs_prog_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SSO_ANNUL_REP - Set Delete Transactions
  INSERT INTO dbo.ics_sso_annul_rep
       ( ics_payload_id
       , ics_sso_annul_rep_id
       , transaction_type
       , prmt_ident, sso_annul_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_sso_annul_rep.ics_payload_id
        , ics_sso_annul_rep.ics_sso_annul_rep_id
        , 'X' AS transaction_type
        , prmt_ident, sso_annul_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sso_annul_rep ics_sso_annul_rep
    WHERE ics_sso_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SSOAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_annul_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sso_annul_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SSO_EVT_REP - Set Delete Transactions
  INSERT INTO dbo.ics_sso_evt_rep
       ( ics_payload_id
       , ics_sso_evt_rep_id
       , transaction_type
       , prmt_ident, sso_evt_date
	   , key_hash
       , data_hash) 
   SELECT ics_sso_evt_rep.ics_payload_id
        , ics_sso_evt_rep.ics_sso_evt_rep_id
        , 'X' AS transaction_type
        , prmt_ident, sso_evt_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sso_evt_rep ics_sso_evt_rep
    WHERE ics_sso_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SSOEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_evt_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sso_evt_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SSO_MONTHLY_EVT_REP - Set Delete Transactions
  INSERT INTO dbo.ics_sso_monthly_evt_rep
       ( ics_payload_id
       , ics_sso_monthly_evt_rep_id
       , transaction_type
       , prmt_ident, sso_monthly_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_sso_monthly_evt_rep.ics_payload_id
        , ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id
        , 'X' AS transaction_type
        , prmt_ident, sso_monthly_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sso_monthly_evt_rep ics_sso_monthly_evt_rep
    WHERE ics_sso_monthly_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SSOMonthlyEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_monthly_evt_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sso_monthly_evt_rep
                                       WHERE action_type = 'DELETE');
  
  -- ICS_SWMS_4_PROG_REP - Set Delete Transactions
  INSERT INTO dbo.ics_swms_4_prog_rep
       ( ics_payload_id
       , ics_swms_4_prog_rep_id
       , transaction_type
       , prmt_ident, sw_ms_4_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_swms_4_prog_rep.ics_payload_id
        , ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
        , 'X' AS transaction_type
        , prmt_ident, sw_ms_4_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_swms_4_prog_rep ics_swms_4_prog_rep
    WHERE ics_swms_4_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWMS4ProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_prog_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_swms_4_prog_rep
                                       WHERE action_type = 'DELETE');

	-- ICS_SCHD_EVT_VIOL - Set Delete Transactions
	-- Delete transaction not supported by ICIS for this module


 /* **************************************************
  * ICS_DMR_PROG_REP_LNK:  Set Delete Transactions
  * **************************************************/
	 DECLARE @tbl_dmr_prog_rep_lnk_id TABLE ( ics_dmr_prog_rep_lnk_id uniqueidentifier
	                                        , local_dmr_prog_rep_lnk_id uniqueidentifier);
	 
	 INSERT INTO @tbl_dmr_prog_rep_lnk_id
   SELECT DISTINCT 
          ics_dmr_prog_rep_lnk_id AS icis_dmr_prog_rep_lnk_id
        , NEWID() AS local_dmr_prog_rep_lnk_id
     FROM [ICS_FLOW_ICIS].dbo.ics_dmr_prog_rep_lnk ics_dmr_prog_rep_lnk
     WHERE ics_dmr_prog_rep_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                     FROM dbo.ics_payload 
                                                    WHERE operation = 'DMRProgramReportLinkageSubmission'
                                                      AND auto_gen_deletes = 'Y' 
                                                      AND enabled = 'Y')
       AND ics_dmr_prog_rep_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                               FROM dbo.cdv_dmr_prog_rep_lnk
                                              WHERE action_type = 'DELETE');
                                            
                                                                                                        
   INSERT INTO dbo.ics_dmr_prog_rep_lnk
        ( ics_dmr_prog_rep_lnk_id
        , ics_payload_id
        , transaction_type
        , prmt_ident
        , prmt_featr_ident
        , lmt_set_designator
        , mon_period_end_date
        , key_hash
        , data_hash) 
    SELECT v_dprl.local_dmr_prog_rep_lnk_id
         , (SELECT ics_payload_id
              FROM dbo.ics_payload 
             WHERE operation = 'DMRProgramReportLinkageSubmission') AS ics_payload_id
         , 'X' AS transaction_type
         , ics_dmr_prog_rep_lnk.prmt_ident
         , ics_dmr_prog_rep_lnk.prmt_featr_ident
         , ics_dmr_prog_rep_lnk.lmt_set_designator
         , ics_dmr_prog_rep_lnk.mon_period_end_date
         , ics_dmr_prog_rep_lnk.key_hash
         , ics_dmr_prog_rep_lnk.data_hash          
      FROM [ICS_FLOW_ICIS].dbo.ics_dmr_prog_rep_lnk ics_dmr_prog_rep_lnk
      JOIN @tbl_dmr_prog_rep_lnk_id AS v_dprl
        ON v_dprl.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id;
        
   INSERT INTO dbo.ics_lnk_bs_rep
        ( ics_lnk_bs_rep_id
        , ics_dmr_prog_rep_lnk_id
        , ics_cmpl_mon_lnk_id
        , prmt_ident
        , rep_coverage_end_date
        , data_hash)
   SELECT NEWID() AS ics_lnk_bs_rep_id
        , v_dprl.local_dmr_prog_rep_lnk_id AS ics_dmr_prog_rep_lnk_id
        , NULL AS ics_cmpl_mon_lnk_id
        , ics_lnk_bs_rep.prmt_ident
        , ics_lnk_bs_rep.rep_coverage_end_date
        , ics_lnk_bs_rep.data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_lnk_bs_rep ics_lnk_bs_rep
     JOIN @tbl_dmr_prog_rep_lnk_id AS v_dprl
       ON v_dprl.ics_dmr_prog_rep_lnk_id = ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id;
       
   INSERT INTO dbo.ics_lnk_sw_evt_rep
        ( ICS_LNK_SW_EVT_REP_ID
        , ICS_DMR_PROG_REP_LNK_ID
        , ICS_CMPL_MON_LNK_ID
        , PRMT_IDENT
        , DATE_STRM_EVT_SMPL
        , SW_EVT_ID
        , DATA_HASH)  
   SELECT NEWID() AS ics_lnk_sw_evt_rep_id
        , local_dmr_prog_rep_lnk_id AS ics_dmr_prog_rep_lnk_id
        , NULL AS ics_cmpl_mon_lnk_id
        , ics_lnk_sw_evt_rep.prmt_ident
        , ics_lnk_sw_evt_rep.date_strm_evt_smpl
        , ics_lnk_sw_evt_rep.sw_evt_id
        , ics_lnk_sw_evt_rep.data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sw_evt_rep ics_lnk_sw_evt_rep
     JOIN @tbl_dmr_prog_rep_lnk_id AS v_dprl
       ON v_dprl.ics_dmr_prog_rep_lnk_id = ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id;


/* **************************************************
  * ICS_CMPL_MON_LNK:  Set Delete Transactions
  * **************************************************/    
	 DECLARE @tbl_cmpl_mon_lnk TABLE ( ics_cmpl_mon_lnk_id uniqueidentifier
	                                 , local_cmpl_mon_lnk_id uniqueidentifier);  
	                                 
	 INSERT INTO @tbl_cmpl_mon_lnk
	      ( ics_cmpl_mon_lnk_id
	      , local_cmpl_mon_lnk_id)
	 SELECT DISTINCT 
         ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
       , NEWID() AS local_cmpl_mon_lnk_id
    FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_mon_lnk ics_cmpl_mon_lnk
   WHERE ics_cmpl_mon_lnk.ics_payload_id in (SELECT ics_payload_id 
                                               FROM dbo.ics_payload 
                                              WHERE operation = 'ComplianceMonitoringLinkageSubmission'
                                                AND auto_gen_deletes = 'Y' 
                                                AND enabled = 'Y')
     AND ics_cmpl_mon_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                         FROM dbo.cdv_cmpl_mon_lnk
                                        WHERE action_type = 'DELETE');
    
                                          
    /*  
     *  ICS_CMPL_MON_LNK 
     */                                      
     INSERT INTO dbo.ics_cmpl_mon_lnk
          ( ics_cmpl_mon_lnk_id
          , ics_payload_id
          , src_systm_ident
          , cmpl_mon_ident
          , transaction_type
          , key_hash
          , data_hash)
     SELECT v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , (SELECT ics_payload_id
               FROM dbo.ics_payload 
              WHERE operation = 'ComplianceMonitoringLinkageSubmission') AS ics_payload_id
          , ics_cmpl_mon_lnk.src_systm_ident
          , ics_cmpl_mon_lnk.cmpl_mon_ident
          , 'X' AS transaction_type
          , NULL AS key_hash
          , NULL AS data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_mon_lnk ics_cmpl_mon_lnk
       JOIN @tbl_cmpl_mon_lnk as v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id;
      
     
    /*  
     *  ICS_LNK_BS_REP 
     */       
     INSERT INTO dbo.ics_lnk_bs_rep
          ( ics_lnk_bs_rep_id
          , ics_dmr_prog_rep_lnk_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , rep_coverage_end_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_bs_rep_id
          , NULL AS ics_dmr_prog_rep_lnk_id
          , v_cml.local_cmpl_mon_lnk_id
          , prmt_ident
          , rep_coverage_end_date
          , data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_bs_rep ics_lnk_bs_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_bs_rep.ics_cmpl_mon_lnk_id;

       
    /*  
     *  ICS_LNK_ST_CMPL_MON 
     */       
     INSERT INTO dbo.ics_lnk_st_cmpl_mon
          ( ics_lnk_st_cmpl_mon_id
          , ics_cmpl_mon_lnk_id
          , cmpl_mon_ident
          , data_hash)
     SELECT NEWID() AS ics_lnk_st_cmpl_mon_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_st_cmpl_mon.cmpl_mon_ident AS cmpl_mon_ident
          , ics_lnk_st_cmpl_mon.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_st_cmpl_mon ics_lnk_st_cmpl_mon
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id;

       
    /*  
     *  ICS_LNK_SNGL_EVT 
     */  
     INSERT INTO dbo.ics_lnk_sngl_evt 
          ( ics_lnk_sngl_evt_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sngl_evt_viol_code
          , sngl_evt_viol_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_sngl_evt_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sngl_evt.prmt_ident
          , ics_lnk_sngl_evt.sngl_evt_viol_code
          , ics_lnk_sngl_evt.sngl_evt_viol_date
          , ics_lnk_sngl_evt.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sngl_evt ics_lnk_sngl_evt
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id;


    /*  
     *  ICS_LNK_CSO_EVT_REP 
     */  
     INSERT INTO dbo.ics_lnk_cso_evt_rep
          ( ics_lnk_cso_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , cso_evt_date
          , cso_evt_id
          , data_hash)
     SELECT NEWID() AS ics_lnk_cso_evt_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_cso_evt_rep.prmt_ident
          , ics_lnk_cso_evt_rep.cso_evt_date
          , ics_lnk_cso_evt_rep.cso_evt_id
          , ics_lnk_cso_evt_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_cso_evt_rep ics_lnk_cso_evt_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id;

      
    /*  
     *  ICS_LNK_ENFRC_ACTN 
     */  
     INSERT INTO dbo.ics_lnk_enfrc_actn
          ( ics_lnk_enfrc_actn_id
          , ics_cmpl_mon_lnk_id
          , enfrc_actn_ident
          , data_hash)
     SELECT NEWID() AS ics_lnk_enfrc_actn_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_enfrc_actn.enfrc_actn_ident
          , ics_lnk_enfrc_actn.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_enfrc_actn ics_lnk_enfrc_actn
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id;

       
    /*  
     *  ICS_LNK_LOC_LMTS_REP 
     */  
     INSERT INTO dbo.ics_lnk_loc_lmts_rep
          ( ics_lnk_loc_lmts_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , prmt_auth_rep_rcvd_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_loc_lmts_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_loc_lmts_rep.prmt_ident
          , ics_lnk_loc_lmts_rep.prmt_auth_rep_rcvd_date
          , ics_lnk_loc_lmts_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_loc_lmts_rep ics_lnk_loc_lmts_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id;

       
    /*  
     *  ICS_LNK_SSO_MONTHLY_EVT_REP 
     */  
     INSERT INTO dbo.ics_lnk_sso_monthly_evt_rep
          ( ics_lnk_sso_monthly_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_monthly_rep_rcvd_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_sso_monthly_evt_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_monthly_evt_rep.prmt_ident
          , ics_lnk_sso_monthly_evt_rep.sso_monthly_rep_rcvd_date
          , ics_lnk_sso_monthly_evt_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sso_monthly_evt_rep ics_lnk_sso_monthly_evt_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id;

    
    /*  
     *  ICS_LNK_CAFO_ANNUL_REP 
     */  
     INSERT INTO dbo.ics_lnk_cafo_annul_rep
          ( ics_lnk_cafo_annul_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , prmt_auth_rep_rcvd_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_cafo_annul_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_cafo_annul_rep.prmt_ident
          , ics_lnk_cafo_annul_rep.prmt_auth_rep_rcvd_date
          , ics_lnk_cafo_annul_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_cafo_annul_rep ics_lnk_cafo_annul_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id;


    /*  
     *  ICS_LNK_PRETR_PERF_REP
     */  
     INSERT INTO dbo.ics_lnk_pretr_perf_rep
          ( ics_lnk_pretr_perf_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , pretr_perf_summ_end_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_pretr_perf_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_pretr_perf_rep.prmt_ident
          , ics_lnk_pretr_perf_rep.pretr_perf_summ_end_date
          , ics_lnk_pretr_perf_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_pretr_perf_rep ics_lnk_pretr_perf_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id;


    /*  
     *  ICS_LNK_SSO_EVT_REP
     */  
     INSERT INTO dbo.ics_lnk_sso_evt_rep
          ( ics_lnk_sso_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_evt_date
          , sso_evt_id
          , data_hash)
     SELECT NEWID() AS ics_lnk_sso_evt_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_evt_rep.prmt_ident
          , ics_lnk_sso_evt_rep.sso_evt_date
          , ics_lnk_sso_evt_rep.sso_evt_id
          , ics_lnk_sso_evt_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sso_evt_rep ics_lnk_sso_evt_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id;

       
       
    /*  
     *  ICS_LNK_FEDR_CMPL_MON
     */  
     INSERT INTO dbo.ics_lnk_fedr_cmpl_mon
          ( ics_lnk_fedr_cmpl_mon_id
          , ics_cmpl_mon_lnk_id
          , prog_systm_acronym
          , prog_systm_ident
          , fedr_statute_code
          , cmpl_mon_acty_type_code
          , cmpl_mon_catg_code
          , cmpl_mon_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_fedr_cmpl_mon_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_fedr_cmpl_mon.prog_systm_acronym
          , ics_lnk_fedr_cmpl_mon.prog_systm_ident
          , ics_lnk_fedr_cmpl_mon.fedr_statute_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_acty_type_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_catg_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_date
          , ics_lnk_fedr_cmpl_mon.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_fedr_cmpl_mon ics_lnk_fedr_cmpl_mon
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_fedr_cmpl_mon.ics_cmpl_mon_lnk_id;

       
       
    /*  
     *  ICS_LNK_SSO_ANNUL_REP
     */  
     INSERT INTO dbo.ics_lnk_sso_annul_rep
          ( ics_lnk_sso_annul_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_annul_rep_rcvd_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_sso_annul_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_annul_rep.prmt_ident
          , sso_annul_rep_rcvd_date
          , data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sso_annul_rep ics_lnk_sso_annul_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id;

       
       
    /*  
     *  ICS_LNK_SW_EVT_REP
     */  
     INSERT INTO dbo.ics_lnk_sw_evt_rep
          ( ics_lnk_sw_evt_rep_id
          , ics_dmr_prog_rep_lnk_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , date_strm_evt_smpl
          , sw_evt_id
          , data_hash)
     SELECT NEWID() AS ics_lnk_sw_evt_rep_id
          , NULL AS ics_dmr_prog_rep_lnk_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sw_evt_rep.prmt_ident
          , ics_lnk_sw_evt_rep.date_strm_evt_smpl
          , ics_lnk_sw_evt_rep.sw_evt_id
          , ics_lnk_sw_evt_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_sw_evt_rep ics_lnk_sw_evt_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id;

       
       
    /*  
     *  ICS_LNK_SWMS_4_REP
     */  
     INSERT INTO dbo.ics_lnk_swms_4_rep
          ( ics_lnk_swms_4_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sw_ms_4_rep_rcvd_date
          , data_hash)
     SELECT NEWID() AS ics_lnk_swms_4_rep_id
          , v_cml.local_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_swms_4_rep.prmt_ident
          , ics_lnk_swms_4_rep.sw_ms_4_rep_rcvd_date
          , ics_lnk_swms_4_rep.data_hash
       FROM [ICS_FLOW_ICIS].dbo.ics_lnk_swms_4_rep ics_lnk_swms_4_rep
       JOIN @tbl_cmpl_mon_lnk AS v_cml
         ON v_cml.ics_cmpl_mon_lnk_id = ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id;
         

/* **************************************************
  * ICS_ENFRC_ACTN_VIOL_LNK:  Set Delete Transactions
  * **************************************************/
	 DECLARE @tbl_enfrc_actn_viol_lnk TABLE ( ics_enfrc_actn_viol_lnk_id uniqueidentifier
	                                        , local_enfrc_actn_viol_lnk_id uniqueidentifier);  
	                                 
	 INSERT INTO @tbl_enfrc_actn_viol_lnk
	      ( ics_enfrc_actn_viol_lnk_id
	      , local_enfrc_actn_viol_lnk_id)
	 SELECT DISTINCT 
         ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
       , NEWID() AS local_enfrc_actn_viol_lnk_id
    FROM [ICS_FLOW_ICIS].dbo.ics_enfrc_actn_viol_lnk ics_enfrc_actn_viol_lnk
   WHERE ics_enfrc_actn_viol_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                      FROM dbo.ics_payload 
                                                     WHERE operation = 'EnforcementActionViolationLinkageSubmission'
                                                       AND auto_gen_deletes = 'Y' 
                                                       AND enabled = 'Y')
     AND ics_enfrc_actn_viol_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                FROM dbo.cdv_enfrc_actn_viol_lnk
                                               WHERE action_type = 'DELETE');

                                               
/*  
 *  ICS_ENFRC_ACTN_VIOL_LNK
 */                                     
 INSERT INTO dbo.ics_enfrc_actn_viol_lnk
      ( ics_enfrc_actn_viol_lnk_id
      , ics_payload_id
      , src_systm_ident
      , transaction_type
      , transaction_timestamp
      , enfrc_actn_ident
      , key_hash
      , data_hash)
 SELECT v_eavl.ics_enfrc_actn_viol_lnk_id AS ICS_ENFRC_ACTN_VIOL_LNK_ID
      , (SELECT ics_payload_id
           FROM dbo.ics_payload 
          WHERE operation = 'EnforcementActionViolationLinkageSubmission') AS ics_payload_id
      , ics_enfrc_actn_viol_lnk.src_systm_ident AS src_systm_ident
      , 'x' AS transaction_type
      , ics_enfrc_actn_viol_lnk.transaction_timestamp AS transaction_timestamp
      , ics_enfrc_actn_viol_lnk.enfrc_actn_ident AS enfrc_actn_ident
      , NULL AS key_hash
      , NULL AS data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_enfrc_actn_viol_lnk ics_enfrc_actn_viol_lnk
   JOIN @tbl_enfrc_actn_viol_lnk as v_eavl
     ON v_eavl.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id;

   /*
   * ICS_PRMT_SCHD_VIOL
   */
   INSERT INTO dbo.ics_prmt_schd_viol
       ( ics_prmt_schd_viol_id
       , ics_enfrc_actn_viol_lnk_id
       , ics_final_order_viol_lnk_id
       , prmt_ident
       , narr_cond_num
       , schd_evt_code
       , schd_date
       , data_hash)
  SELECT NEWID() AS ics_prmt_schd_viol_id
       , v_eavl.ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
       , NULL AS ics_final_order_viol_lnk_id
       , ics_prmt_schd_viol.prmt_ident AS prmt_ident
       , ics_prmt_schd_viol.narr_cond_num AS narr_cond_num
       , ics_prmt_schd_viol.schd_evt_code AS schd_evt_code
       , ics_prmt_schd_viol.schd_date AS schd_date
       , ics_prmt_schd_viol.data_hash  AS data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_prmt_schd_viol ics_prmt_schd_viol
   JOIN @tbl_enfrc_actn_viol_lnk AS v_eavl
     ON v_eavl.ics_enfrc_actn_viol_lnk_id = ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id;
                  

  /*
   * ICS_CMPL_SCHD_VIOL
   */
   INSERT INTO dbo.ics_cmpl_schd_viol
        ( ics_cmpl_schd_viol_id
        , ics_enfrc_actn_viol_lnk_id
        , ics_final_order_viol_lnk_id
        , enfrc_actn_ident
        , final_order_ident
        , prmt_ident
        , cmpl_schd_num
        , schd_evt_code
        , schd_date
        , data_hash)
   SELECT NEWID() as ics_cmpl_schd_viol_id
        , v_csv.ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
        , NULL AS ics_final_order_viol_lnk_id
        , ics_cmpl_schd_viol.enfrc_actn_ident AS enfrc_actn_ident
        , ics_cmpl_schd_viol.final_order_ident AS final_order_ident
        , ics_cmpl_schd_viol.prmt_ident AS prmt_ident
        , ics_cmpl_schd_viol.cmpl_schd_num AS cmpl_schd_num
        , ics_cmpl_schd_viol.schd_evt_code AS schd_evt_code
        , ics_cmpl_schd_viol.schd_date AS schd_date
        , ics_cmpl_schd_viol.data_hash AS data_hash
    FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_schd_viol ics_cmpl_schd_viol
    JOIN @tbl_enfrc_actn_viol_lnk AS v_csv
      ON v_csv.ics_enfrc_actn_viol_lnk_id = ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id;


  /*
   * ICS_DSCH_MON_REP_VIOL
   */
   INSERT INTO dbo.ics_dsch_mon_rep_viol
       ( ics_dsch_mon_rep_viol_id
       , ics_enfrc_actn_viol_lnk_id
       , ics_final_order_viol_lnk_id
       , prmt_ident
       , prmt_featr_ident
       , lmt_set_designator
       , mon_period_end_date
       , data_hash)
  SELECT NEWID() as ics_dsch_mon_rep_viol_id
       , v_dmrv.ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
       , NULL AS ics_final_order_viol_lnk_id
       , ics_dsch_mon_rep_viol.prmt_ident AS prmt_ident
       , ics_dsch_mon_rep_viol.prmt_featr_ident AS prmt_featr_ident
       , ics_dsch_mon_rep_viol.lmt_set_designator AS lmt_set_designator
       , ics_dsch_mon_rep_viol.mon_period_end_date AS mon_period_end_date
       , ics_dsch_mon_rep_viol.data_hash AS data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_dsch_mon_rep_viol ics_dsch_mon_rep_viol
   JOIN @tbl_enfrc_actn_viol_lnk AS v_dmrv
     ON v_dmrv.ics_enfrc_actn_viol_lnk_id = ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id;


   
  /*
   * ICS_DSCH_MON_REP_PARAM_VIOL
   */
   INSERT INTO dbo.ics_dsch_mon_rep_param_viol
        ( ics_dsch_mon_rep_param_viol_id
        , ics_enfrc_actn_viol_lnk_id
        , ics_final_order_viol_lnk_id
        , prmt_ident
        , prmt_featr_ident
        , lmt_set_designator
        , mon_period_end_date
        , param_code
        , mon_site_desc_code
        , lmt_season_num
        , data_hash)
   SELECT NEWID() as ics_dsch_mon_rep_param_viol_id
        , v_dmrmv.ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
        , NULL AS ics_final_order_viol_lnk_id
        , ics_dsch_mon_rep_param_viol.prmt_ident AS prmt_ident
        , ics_dsch_mon_rep_param_viol.prmt_featr_ident AS prmt_featr_ident
        , ics_dsch_mon_rep_param_viol.lmt_set_designator AS lmt_set_designator
        , ics_dsch_mon_rep_param_viol.mon_period_end_date AS mon_period_end_date
        , ics_dsch_mon_rep_param_viol.param_code AS param_code
        , ics_dsch_mon_rep_param_viol.mon_site_desc_code AS mon_site_desc_code
        , ics_dsch_mon_rep_param_viol.lmt_season_num AS lmt_season_num
        , ics_dsch_mon_rep_param_viol.data_hash AS data_hash
    FROM [ICS_FLOW_ICIS].dbo.ics_dsch_mon_rep_param_viol ics_dsch_mon_rep_param_viol
    JOIN @tbl_enfrc_actn_viol_lnk AS v_dmrmv
      ON v_dmrmv.ics_enfrc_actn_viol_lnk_id = ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id;

  /*
   * ICS_SNGL_EVTS_VIOL 
   */
   INSERT INTO dbo.ics_sngl_evts_viol
        ( ics_sngl_evts_viol_id
        , ics_enfrc_actn_viol_lnk_id
        , ics_final_order_viol_lnk_id
        , prmt_ident
        , sngl_evt_viol_code
        , sngl_evt_viol_date
        , data_hash)
   SELECT NEWID() AS ics_sngl_evts_viol_id
        , v_sev.ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
        , NULL AS ics_final_order_viol_lnk_id
        , ics_sngl_evts_viol.prmt_ident AS prmt_ident
        , ics_sngl_evts_viol.sngl_evt_viol_code AS sngl_evt_viol_code
        , ics_sngl_evts_viol.sngl_evt_viol_date AS sngl_evt_viol_date
        , ics_sngl_evts_viol.data_hash AS data_hash
    FROM [ICS_FLOW_ICIS].dbo.ics_sngl_evts_viol ics_sngl_evts_viol
    JOIN @tbl_enfrc_actn_viol_lnk AS v_sev
      ON v_sev.ics_enfrc_actn_viol_lnk_id = ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id;    



 /* **************************************************
  * ICS_FINAL_ORDER_VIOL_LNK:  Set Delete Transactions
  * **************************************************/
	 DECLARE @tbl_final_order_viol_lnk_id TABLE ( ics_final_order_viol_lnk_id uniqueidentifier
	                                            , local_final_order_viol_lnk_id uniqueidentifier);
	 
	 INSERT INTO @tbl_final_order_viol_lnk_id
   SELECT DISTINCT 
          ics_final_order_viol_lnk_id AS icis_final_order_viol_lnk_id
        , NEWID() AS local_final_order_viol_lnk_id
     FROM [ICS_FLOW_ICIS].dbo.ics_final_order_viol_lnk ics_final_order_viol_lnk
    WHERE ics_final_order_viol_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                        FROM dbo.ics_payload 
                                                       WHERE operation = 'FinalOrderViolationLinkageSubmission'
                                                         AND auto_gen_deletes = 'Y' 
                                                         AND enabled = 'Y')
      AND ics_final_order_viol_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                  FROM dbo.cdv_final_order_viol_lnk
                                                  WHERE action_type = 'DELETE');   

  INSERT INTO  dbo.ics_final_order_viol_lnk
             ( ics_final_order_viol_lnk_id
             , ics_payload_id
             , src_systm_ident
             , transaction_type
             , transaction_timestamp
             , enfrc_actn_ident
             , final_order_ident
             , key_hash
             , data_hash)
      SELECT v_fovl.local_final_order_viol_lnk_id
           , (SELECT ics_payload_id
                FROM dbo.ics_payload 
               WHERE operation = 'FinalOrderViolationLinkageSubmission') AS ics_payload_id
             , ics_final_order_viol_lnk.src_systm_ident
             , 'X' AS transaction_type
             , ics_final_order_viol_lnk.transaction_timestamp
             , ics_final_order_viol_lnk.enfrc_actn_ident
             , ics_final_order_viol_lnk.final_order_ident
             , ics_final_order_viol_lnk.key_hash
             , ics_final_order_viol_lnk.data_hash
        FROM [ICS_FLOW_ICIS].dbo.ics_final_order_viol_lnk ics_final_order_viol_lnk
        JOIN @tbl_final_order_viol_lnk_id AS v_fovl
          ON v_fovl.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id;

--    ICS_DSCH_MON_REP_PARAM_VIOL
INSERT INTO  dbo.ICS_DSCH_MON_REP_PARAM_VIOL
           ( ICS_DSCH_MON_REP_PARAM_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , PRMT_IDENT
           , PRMT_FEATR_IDENT
           , LMT_SET_DESIGNATOR
           , MON_PERIOD_END_DATE
           , PARAM_CODE
           , MON_SITE_DESC_CODE
           , LMT_SEASON_NUM
           , DATA_HASH)
      SELECT NEWID() AS ICS_DSCH_MON_REP_PARAM_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_fovl.ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_dsch_mon_rep_param_viol.prmt_ident as prmt_ident
           , ics_dsch_mon_rep_param_viol.prmt_featr_ident as prmt_featr_ident
           , ics_dsch_mon_rep_param_viol.lmt_set_designator as lmt_set_designator
           , ics_dsch_mon_rep_param_viol.mon_period_end_date as mon_period_end_date
           , ics_dsch_mon_rep_param_viol.param_code as param_code
           , ics_dsch_mon_rep_param_viol.mon_site_desc_code as mon_site_desc_code
           , ics_dsch_mon_rep_param_viol.lmt_season_num as lmt_season_num
           , ics_dsch_mon_rep_param_viol.data_hash as data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_dsch_mon_rep_param_viol ics_dsch_mon_rep_param_viol
   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
     ON v_fovl.ics_final_order_viol_lnk_id = ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id;


--    ICS_DSCH_MON_REP_VIOL
INSERT INTO  dbo.ICS_DSCH_MON_REP_VIOL
           ( ICS_DSCH_MON_REP_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , PRMT_IDENT
           , PRMT_FEATR_IDENT
           , LMT_SET_DESIGNATOR
           , MON_PERIOD_END_DATE
           , DATA_HASH)
      SELECT NEWID() AS ICS_DSCH_MON_REP_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_fovl.ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_dsch_mon_rep_viol.prmt_ident as prmt_ident
           , ics_dsch_mon_rep_viol.prmt_featr_ident as prmt_featr_ident
           , ics_dsch_mon_rep_viol.lmt_set_designator as lmt_set_designator
           , ics_dsch_mon_rep_viol.mon_period_end_date as mon_period_end_date
           , ics_dsch_mon_rep_viol.data_hash as data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_dsch_mon_rep_viol ics_dsch_mon_rep_viol
   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
     ON v_fovl.ics_final_order_viol_lnk_id = ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id;

--    ICS_PRMT_SCHD_VIOL
INSERT INTO  dbo.ICS_PRMT_SCHD_VIOL
           ( ICS_PRMT_SCHD_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , PRMT_IDENT
           , NARR_COND_NUM
           , SCHD_EVT_CODE
           , SCHD_DATE
           , DATA_HASH)
      SELECT NEWID() AS ICS_PRMT_SCHD_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_fovl.ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_prmt_schd_viol.prmt_ident as prmt_ident
           , ics_prmt_schd_viol.narr_cond_num as narr_cond_num
           , ics_prmt_schd_viol.schd_evt_code as schd_evt_code
           , ics_prmt_schd_viol.schd_date as schd_date
           , ics_prmt_schd_viol.data_hash as data_hash
   FROM [ICS_FLOW_ICIS].dbo.ics_prmt_schd_viol ics_prmt_schd_viol
   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
     ON v_fovl.ics_final_order_viol_lnk_id = ics_prmt_schd_viol.ics_final_order_viol_lnk_id;

--    ICS_SNGL_EVTS_VIOL
INSERT INTO dbo.ics_sngl_evts_viol
           (ics_sngl_evts_viol_id
           ,ics_enfrc_actn_viol_lnk_id
           ,ics_final_order_viol_lnk_id
           ,prmt_ident
           ,sngl_evt_viol_code
           ,sngl_evt_viol_date
           ,data_hash)
      SELECT NEWID() as ics_sngl_evts_viol_id
           , NULL as ics_enfrc_actn_viol_lnk_id
           , v_fovl.ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_sngl_evts_viol.prmt_ident as prmt_ident
           , ics_sngl_evts_viol.sngl_evt_viol_code as sngl_evt_viol_code
           , ics_sngl_evts_viol.sngl_evt_viol_date as sngl_evt_viol_date
           , ics_sngl_evts_viol.data_hash as data_hash
        FROM [ICS_FLOW_ICIS].dbo.ics_sngl_evts_viol ics_sngl_evts_viol
        JOIN @tbl_final_order_viol_lnk_id AS v_fovl
          ON v_fovl.ics_final_order_viol_lnk_id = ics_sngl_evts_viol.ics_final_order_viol_lnk_id;

--    ICS_CMPL_SCHD_VIOL
      INSERT INTO dbo.ICS_CMPL_SCHD_VIOL
           ( ICS_CMPL_SCHD_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , ENFRC_ACTN_IDENT
           , FINAL_ORDER_IDENT
           , PRMT_IDENT
           , CMPL_SCHD_NUM
           , SCHD_EVT_CODE
           , SCHD_DATE
           , DATA_HASH)
      SELECT NEWID() AS ICS_CMPL_SCHD_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_fovl.ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_cmpl_schd_viol.enfrc_actn_ident as enfrc_actn_ident
           , ics_cmpl_schd_viol.final_order_ident as final_order_ident
           , ics_cmpl_schd_viol.prmt_ident as prmt_ident
           , ics_cmpl_schd_viol.cmpl_schd_num as cmpl_schd_num
           , ics_cmpl_schd_viol.schd_evt_code as schd_evt_code
           , ics_cmpl_schd_viol.schd_date as schd_date
           , ics_cmpl_schd_viol.data_hash as data_hash   
        FROM [ICS_FLOW_ICIS].dbo.ics_cmpl_schd_viol ics_cmpl_schd_viol
   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
     ON v_fovl.ics_final_order_viol_lnk_id = ics_cmpl_schd_viol.ics_final_order_viol_lnk_id;


	-- ICS_SW_INDST_ANNUL_REP - Set Delete Transactions
	INSERT INTO dbo.ics_sw_indst_annul_rep
       ( ics_payload_id
       , ics_sw_indst_annul_rep_id
       , transaction_type
       , prmt_ident
	   , indst_sw_annul_rep_rcvd_date
	   , key_hash
       , data_hash) 
   SELECT ics_sw_indst_annul_rep.ics_payload_id
        , ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id
        , 'X' AS transaction_type
        , prmt_ident
		, indst_sw_annul_rep_rcvd_date
		, key_hash
        , data_hash
     FROM [ICS_FLOW_ICIS].dbo.ics_sw_indst_annul_rep ics_sw_indst_annul_rep
    WHERE ics_sw_indst_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM dbo.ics_payload 
                          WHERE operation = 'SWIndustrialAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_indst_annul_rep.key_hash IN (SELECT key_hash
                                        FROM dbo.cdv_sw_indst_annul_rep
                                       WHERE action_type = 'DELETE');

     --PRINT 'Change Detection: Completed at ' + CONVERT(VARCHAR(24),GETDATE(),113)

END;
