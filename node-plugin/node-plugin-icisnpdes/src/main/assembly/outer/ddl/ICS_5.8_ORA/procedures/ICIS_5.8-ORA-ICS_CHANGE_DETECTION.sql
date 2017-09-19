CREATE OR REPLACE PROCEDURE ICS_FLOW_LOCAL.ICS_CHANGE_DETECTION 
AS

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
** Description:  This procedure will detect data changes made within the ICIS schema and then sets the transaction type
**               flags so the data can be bundled and submitted to an exchange partner.
**
** Inputs:  -- NA --  
**
**
** Revision History:      
** ----------------------------------------------------------------------------------------------------------------------------
**  Date         Analyst     Description
** ----------------------------------------------------------------------------------------------------------------------------
** 06/21/2017    CTyler      Baseline from 5.6 Procedure
** 06/27/2017    CTyler      Re-ordered linkages HASH calculation for consistency with PAT
**
******************************************************************************************************************************/
  v_sql_statement VARCHAR2(4000);
  v_all_data_hashes VARCHAR2(4000);  
  v_hashed_data_hashes VARCHAR2(32);
  v_ics_cmpl_mon_lnk_id ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id%TYPE;
  v_ics_dmr_prog_rep_lnk_id ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id%TYPE;  
  v_ics_enfrc_actn_viol_lnk_id ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id%TYPE; 
  v_ics_final_order_viol_lnk_id ics_final_order_viol_lnk.ics_final_order_viol_lnk_id%TYPE; 
  v_enabled char(1);
  v_working_data_hash VARCHAR2(4000);

BEGIN

  /*  Initialize working table ICS_KEY_HASH */
  DELETE FROM ics_key_hash;

  /*  Initialize working table ICS_DATA_HASH */
  DELETE FROM ics_data_hash;
  
  /*  
   * Reset transaction_type on all payload tables  
   */
  FOR payload_type IN (SELECT child.table_name
                         FROM user_constraints child
                         LEFT JOIN user_constraints parent
                           ON child.r_constraint_name = parent.constraint_name
                        WHERE child.constraint_type = 'R'
                          AND parent.table_name = 'ICS_PAYLOAD'                           
                        ORDER BY child.table_name) LOOP
       
    /* For each payload type, remove all the transaction codes from the previous run. */
    v_sql_statement := 'UPDATE ' || payload_type.table_name || ' SET TRANSACTION_TYPE = NULL , TRANSACTION_TIMESTAMP = NULL';
    EXECUTE IMMEDIATE v_sql_statement;
  
  END LOOP module_loop;
  
-- -=-=-=-=-=-=- START COPY TO INDICATED SECTION IN ICS_SET_HASHES -=-=-=-=-=-=-=-=-=
 /*********************************************/  
 /* START - Set KEY_HASH and DATA_HASH fields */
 /* START - Set KEY_HASH and DATA_HASH fields */
 /* START - Set KEY_HASH and DATA_HASH fields */
 /*********************************************/  
 
 UPDATE ics_subsctor_code_plus_desc
   SET data_hash = MD5_HASH( subsctor_code_plus_desc );
   
  UPDATE ics_addr
     SET data_hash = MD5_HASH(
      affil_type_txt
    ||org_frml_name
    ||org_duns_num
    ||mailing_addr_txt
    ||suppl_addr_txt
    ||mailing_addr_city_name
    ||mailing_addr_st_code
    ||mailing_addr_zip_code
    ||county_name
    ||mailing_addr_country_code
    ||division_name
    ||loc_province
    ||elec_addr_txt
    ||start_date_of_addr_assc
    ||end_date_of_addr_assc
  );
 -- 5.8
UPDATE ics_anlytcl_method 
   SET data_hash = MD5_HASH(
      anlytcl_method_type_code
      || anlytcl_method_othr_type_txt
   ); 
  
  UPDATE ics_anml_type
     SET data_hash = MD5_HASH(
      anml_type_code
    ||othr_anml_type_name
    ||ttl_num_each_lvstck
    ||open_confinemnt_cnt
    ||housd_undr_roof_confinemnt_cnt
  );
  UPDATE ics_assc_prmt
     SET data_hash = MD5_HASH(
      assc_prmt_ident
    ||assc_prmt_reason_code
  );
  UPDATE ics_basic_prmt
    SET key_hash = MD5_HASH(ics_basic_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_type_code
    ||agncy_type_code
    ||prmt_stat_code
    ||prmt_issue_date
    ||prmt_effective_date
    ||prmt_expr_date
    ||reissu_prio_prmt_ind
    ||backlog_reason_txt
    ||prmt_issuing_org_type_name
    ||prmt_appealed_ind
    ||prmt_usr_dfnd_dat_elm_1_txt
    ||prmt_usr_dfnd_dat_elm_2_txt
    ||prmt_usr_dfnd_dat_elm_3_txt
    ||prmt_usr_dfnd_dat_elm_4_txt
    ||prmt_usr_dfnd_dat_elm_5_txt
    ||prmt_cmnts_txt
    ||major_minor_rating_code
    ||ttl_appl_dsgn_flow_num
    ||ttl_appl_aver_flow_num
    ||appl_rcvd_date
    ||prmt_appl_cmpl_date
    ||new_src_ind
    ||prmt_st_wtr_body_code
    ||prmt_st_wtr_body_name
    ||fedr_grant_ind
    ||dmr_cognznt_ofcl
    ||dmr_cognznt_ofcl_teleph_num
    ||sig_iu_ind
    ||rcvg_prmt_ident
    ||MAJOR_MINOR_STAT_IND
    ||MAJOR_MINOR_STAT_START_DATE
    ||DMR_NON_RCPT_STAT_IND
    ||DMR_NON_RCPT_STAT_START_DATE
    -- 5.8
   ||ELEC_REP_WAIVER_EFFECTIVE_DATE
   ||ELEC_REP_WAIVER_EXPR_DATE
   ||ELEC_REP_WAIVER_TYPE_CODE
    
  );
-- 5.8
UPDATE ICS_BS_ANNUL_PROG_REP
 SET key_hash = MD5_HASH(
 prmt_ident
|| bs_annul_rep_rcvd_date
 )
 ,data_hash = MD5_HASH(
prmt_ident
|| bs_annul_rep_rcvd_date
|| elec_subm_type_code
|| rep_period_start_date
|| rep_period_end_date
|| trtmnt_prcss_othr_txt
|| ttl_vol_amt
|| bs_addl_info_cmnt_txt);

  UPDATE ics_bs_end_use_dspl_type
     SET data_hash = MD5_HASH(
      bs_end_use_dspl_type_code
  );
-- 5.8
UPDATE ICS_BS_MGMT_PRACTICES
 SET data_hash = MD5_HASH(
   ssu_ident
   || bs_mgmt_prc_type_code
   || hndlr_prepr_type_code
   || land_appl_sub_catg_code
   || othr_sub_catg_code
   || sub_catg_othr_txt
   || bs_cntnr_type_code
   || vol_amt
   || pathogen_class_type_code
   || polut_concen_exceedance_ind
   || polut_loading_r_exceedance_ind
   || active_dspl_site_ind
   || site_spec_lmt_ind
   || min_bndry_dist_ind
   || min_bndry_dist_type_code
   || assc_prmt_ident
   || mgmt_prc_cmnt_txt);  
  UPDATE ics_bs_prmt
    SET key_hash = MD5_HASH(ics_bs_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||eq_prod_dist_marketed_amt
    ||land_applied_amt
    ||incinerated_amt
    ||codisposed_in_msw_landfill_amt
    ||surf_dspl_amt
    ||mnged_othr_mthds_amt
    ||rcvd_offsite_srcs_amt
    ||transferred_amt
    ||disposed_out_of_st_amt
    ||benef_used_out_of_st_amt
    ||mnged_othr_mthds_out_of_st_amt
    ||ttl_removed_amt
    ||annul_dry_sldg_prod_num
  );
  UPDATE ics_bs_prog_rep
    SET key_hash = MD5_HASH(ics_bs_prog_rep.prmt_ident || rep_coverage_end_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||rep_coverage_end_date
    ||num_of_rep_units
    ||eq_prod_dist_marketed_amt
    ||land_applied_amt
    ||incinerated_amt
    ||codisposed_in_msw_landfill_amt
    ||surf_dspl_amt
    ||mnged_othr_mthds_amt
    ||rcvd_offsite_srcs_amt
    ||transferred_amt
    ||disposed_out_of_st_amt
    ||benef_used_out_of_st_amt
    ||mnged_othr_mthds_out_of_st_amt
    ||ttl_removed_amt
    ||annul_dry_sldg_prod_num
    ||annul_loading_param_date
    ||annul_loading_bs_gal
    ||annul_loading_bs_dmt
    ||annul_loading_nutr_nitrogen
    ||annul_loading_nutr_phosph
    ||ttl_num_land_appl_viol
    ||ttl_num_incin_viol
    ||ttl_num_dist_marketing_viol
    ||ttl_num_sldg_rlt_mgmt_prc_viol
    ||ttl_num_surf_dspl_viol
    ||ttl_num_othr_sldg_viol
    ||ttl_num_codisposal_viol
    ||bs_rep_cmnts
  );
  UPDATE ics_bs_type
     SET data_hash = MD5_HASH(
      bs_type_code
  );
  UPDATE ics_cafo_annul_rep
    SET key_hash = MD5_HASH(ics_cafo_annul_rep.prmt_ident || prmt_auth_rep_rcvd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_auth_rep_rcvd_date
    ||dsch_drng_year_prod_area_ind
    ||solid_mnur_lttr_gnrtd_amt
    ||liquid_mnur_ww_gnrtd_amt
    ||solid_mnur_lttr_trans_amt
    ||liquid_mnur_ww_trans_amt
    ||nmp_dvlpd_cert_plnr_aprvd_ind
    ||ttl_num_acres_nmp_idntfd
    ||ttl_num_acres_used_land_appl
  );
  UPDATE ics_cafo_insp
     SET data_hash = MD5_HASH(
      cafo_class_code
    ||is_anml_fac_type_cafo_ind
    ||cafo_desgn_date
    ||cafo_desgn_reason_txt
    ||dsch_drng_year_prod_area_ind
    ||num_acres_contrb_drain
    ||appl_meas_avail_land_num
    ||solid_mnur_lttr_gnrtd_amt
    ||liquid_mnur_ww_gnrtd_amt
    ||solid_mnur_lttr_trans_amt
    ||liquid_mnur_ww_trans_amt
    ||nmp_dvlpd_cert_plnr_aprvd_ind
    ||nmp_dvlpd_date
    ||nmp_last_updated_date
    ||envr_mgmt_systm_ind
    ||ems_dvlpd_date
    ||ems_last_updated_date
    ||lvstck_max_cpcty_num
    ||lvstck_cpcty_dtrmn_bs_upon_num
    ||auth_lvstck_cpcty_num
  );
  UPDATE ics_cafo_insp_viol_type
     SET data_hash = MD5_HASH(
      cafo_insp_viol_type_code
  );
  UPDATE ics_cafo_prmt
    SET key_hash = MD5_HASH(ics_cafo_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||cafo_class_code
    ||is_anml_fac_type_cafo_ind
    ||cafo_desgn_date
    ||cafo_desgn_reason_txt
    ||num_acres_contrb_drain
    ||appl_meas_avail_land_num
    ||solid_mnur_lttr_gnrtd_amt
    ||liquid_mnur_ww_gnrtd_amt
    ||solid_mnur_lttr_trans_amt
    ||liquid_mnur_ww_trans_amt
    ||nmp_dvlpd_cert_plnr_aprvd_ind
    ||nmp_dvlpd_date
    ||nmp_last_updated_date
    ||envr_mgmt_systm_ind
    ||ems_dvlpd_date
    ||ems_last_updated_date
    ||lvstck_max_cpcty_num
    ||lvstck_cpcty_dtrmn_bs_upon_num
    ||auth_lvstck_cpcty_num
    ||legal_desc_txt
  );
  UPDATE ics_sw_indst_annul_rep
     SET key_hash = MD5_HASH(ics_sw_indst_annul_rep.prmt_ident||indst_sw_annul_rep_rcvd_date),
         data_hash = MD5_HASH( 
       prmt_ident
     ||indst_sw_annul_rep_rcvd_date
     ||fac_insp_summ_txt
     ||visual_assessment_summ_txt
     ||no_further_reduction_summ_txt
     ||corr_actn_summ_txt
  );
  UPDATE ics_cmpl_insp_type
     SET data_hash = MD5_HASH(
      cmpl_insp_type_code
  );
  UPDATE ics_cmpl_mon
    SET key_hash = MD5_HASH(cmpl_mon_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||cmpl_mon_catg_code
    ||cmpl_mon_date
    ||cmpl_mon_start_date
    ||cmpl_mon_acty_name
    ||biomon_insp_method
    ||cmpl_mon_agncy_code
    ||st_statute_viol_name
    ||epa_assist_ind
    ||st_fedr_joint_ind
    ||joint_insp_reason_code
    ||lead_party
    ||num_days_phys_cond_acty
    ||num_hours_phys_cond_acty
    ||cmpl_mon_actn_outcome_code
    ||insp_rating_code
    ||multimedia_ind
    ||fedr_fac_ind
    ||fedr_fac_ind_cmnt
    ||insp_usr_dfnd_fld_1
    ||insp_usr_dfnd_fld_2
    ||insp_usr_dfnd_fld_3
    ||insp_usr_dfnd_fld_4
    ||insp_usr_dfnd_fld_5
    ||insp_usr_dfnd_fld_6
    ||insp_cmnt_txt
    ||CMPL_MON_ACTY_TYPE_CODE
   ||CMPL_MON_PLANNED_END_DATE
   ||CMPL_MON_PLANNED_START_DATE
    
  );
  UPDATE ics_cmpl_mon_actn_reason
     SET data_hash = MD5_HASH(
      cmpl_mon_actn_reason_code
  );
  UPDATE ics_cmpl_mon_agncy_type
     SET data_hash = MD5_HASH(
      cmpl_mon_agncy_type_code
  );
  UPDATE ics_cmpl_mon_lnk
   -- Root table has conditional key, skipping key_hash creation
     SET data_hash = MD5_HASH(
     cmpl_mon_ident
  );
  UPDATE ics_cmpl_schd
    SET key_hash = MD5_HASH(ics_cmpl_schd.enfrc_actn_ident || final_order_ident || prmt_ident || cmpl_schd_num),
        data_hash = MD5_HASH(
      enfrc_actn_ident
    ||final_order_ident
    ||prmt_ident
    ||cmpl_schd_num
    ||cmpl_schd_cmnts
    ||schd_desc_code
  );
  UPDATE ics_cmpl_schd_evt
     SET data_hash = MD5_HASH(
      schd_evt_code
    ||schd_date
    ||schd_rep_rcvd_date
    ||schd_actul_date
    ||schd_proj_date
    ||schd_usr_dfnd_dat_elm_1
    ||schd_usr_dfnd_dat_elm_2
    ||schd_evt_cmnts
    ||cmpl_schd_pnlty_amt
  );
  UPDATE ics_cmpl_schd_evt_viol_elem
     SET data_hash = MD5_HASH(
      enfrc_actn_ident
    ||final_order_ident
    ||prmt_ident
    ||cmpl_schd_num
    ||schd_evt_code
    ||schd_date
    ||schd_viol_code
  );
  UPDATE ics_cmpl_schd_viol
     SET data_hash = MD5_HASH(
      enfrc_actn_ident
    ||final_order_ident
    ||prmt_ident
    ||cmpl_schd_num
    ||schd_evt_code
    ||schd_date
  );
  UPDATE ics_cmpl_track_stat
     SET data_hash = MD5_HASH(
      stat_code
    ||stat_start_date
    ||stat_reason
  );
  UPDATE ics_co_dspl_site
     SET data_hash = MD5_HASH(
      part_258_cmpl_ind
    ||paint_filter_test_result
    ||tclp_test_result
  );
-- 5.8
UPDATE ICS_CNST_SITE
 SET data_hash = MD5_HASH(
cnst_site_code);
  
  UPDATE ics_contact
     SET data_hash = MD5_HASH(
      affil_type_txt
    ||first_name
    ||middle_name
    ||last_name
    ||indvl_title_txt
    ||org_frml_name
    ||st_code
    ||rgn_code
    ||elec_addr_txt
    ||start_date_of_contact_assc
    ||end_date_of_contact_assc
  );
  UPDATE ics_containment
     SET data_hash = MD5_HASH(
      containment_type_code
    ||othr_containment_type_name
    ||containment_cpcty_num
  );
  UPDATE ics_crop_types_harvested
     SET data_hash = MD5_HASH(
      crop_types_harvested
  );
  UPDATE ics_crop_types_planted
     SET data_hash = MD5_HASH(
      crop_types_planted
  );
  UPDATE ics_cso_evt_rep
    SET key_hash = MD5_HASH(prmt_ident || cso_evt_date|| cso_evt_id),
        data_hash = MD5_HASH(
      dry_or_wet_weather_ind
    ||prmt_featr_ident
    ||lat_meas
    ||long_meas
    ||cso_ovrflw_loc_street
    ||duration_cso_ovrflw_evt
    ||dsch_vol_treated
    ||dsch_vol_untreated
    ||corr_actn_taken_desc_txt
    ||inches_precip
  );
  UPDATE ics_cso_insp
     SET data_hash = MD5_HASH(
      cso_evt_date
    ||dry_or_wet_weather_ind
    ||prmt_featr_ident
    ||lat_meas
    ||long_meas
    ||cso_ovrflw_loc_street
    ||duration_cso_ovrflw_evt
    ||dsch_vol_treated
    ||dsch_vol_untreated
    ||corr_actn_taken_desc_txt
    ||inches_precip
  );
  UPDATE ics_cso_prmt
    SET key_hash = MD5_HASH(ics_cso_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||css_popl_served_num
    ||combined_sewer_systm_length
    ||coll_systm_combined_percent
  );
  UPDATE ics_dmr_prog_rep_lnk
   -- Root table has conditional key, skipping key_hash creation
     SET data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||mon_period_end_date
  );
  UPDATE ics_dmr_viol
    SET key_hash = MD5_HASH(ics_dmr_viol.prmt_ident || prmt_featr_ident || lmt_set_designator || mon_period_end_date || param_code || mon_site_desc_code || lmt_season_num || num_rep_code || num_rep_viol_code),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||mon_period_end_date
    ||param_code
    ||mon_site_desc_code
    ||lmt_season_num
    ||num_rep_code
    ||num_rep_viol_code
    ||rep_non_cmpl_detect_code
    ||rep_non_cmpl_detect_date
    ||rep_non_cmpl_resl_code
    ||rep_non_cmpl_resl_date
  );
  UPDATE ics_dsch_mon_rep
    SET key_hash = MD5_HASH(ics_dsch_mon_rep.prmt_ident || prmt_featr_ident || lmt_set_designator || mon_period_end_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||mon_period_end_date
    ||sign_date
    ||prncpl_exec_offcr_first_name
    ||prncpl_exec_offcr_last_name
    ||prncpl_exec_offcr_title
    ||prncpl_exec_offcr_teleph
    ||sign_first_name
    ||sign_last_name
    ||sign_teleph
    ||rep_cmnt_txt
    ||dmr_no_dsch_ind
    ||dmr_no_dsch_rcvd_date
    ||ELEC_SUBM_TYPE_CODE
  );
  UPDATE ics_dsch_mon_rep_param_viol
     SET data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||mon_period_end_date
    ||param_code
    ||mon_site_desc_code
    ||lmt_season_num
  );
  UPDATE ics_dsch_mon_rep_viol
     SET data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||mon_period_end_date
  );
  UPDATE ics_efflu_guide
     SET data_hash = MD5_HASH(
      efflu_guide_code
  );
  UPDATE ics_efflu_trade_prtner
    SET key_hash = MD5_HASH(ics_efflu_trade_prtner.prmt_ident || prmt_featr_ident || lmt_set_designator || param_code || mon_site_desc_code || lmt_season_num || lmt_start_date || lmt_end_date || lmt_mod_effective_date || trade_id),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||param_code
    ||mon_site_desc_code
    ||lmt_season_num
    ||lmt_start_date
    ||lmt_end_date
    ||lmt_mod_effective_date
    ||trade_prtner_npdesid
    ||trade_prtner_type
    ||trade_prtner_start_date
    ||trade_prtner_end_date
  );
  UPDATE ics_efflu_trade_prtner_addr
     SET data_hash = MD5_HASH(
      org_frml_name
    ||org_duns_num
    ||loc_name
    ||mailing_addr_txt
    ||suppl_addr_txt
    ||mailing_addr_city_name
    ||mailing_addr_country_code
    ||loc_province
    ||mailing_addr_st_code
    ||mailing_addr_zip_code
    ||county_name
    ||division_name
    ||elec_addr_txt
  );
  UPDATE ics_enfrc_actn_gov_contact
     SET data_hash = MD5_HASH(
      affil_type_txt
    ||elec_addr_txt
    ||start_date_of_contact_assc
    ||end_date_of_contact_assc
  );
  UPDATE ics_enfrc_actn_milestone
    SET key_hash = MD5_HASH(ics_enfrc_actn_milestone.enfrc_actn_ident || milestone_type_code),
        data_hash = MD5_HASH(
      enfrc_actn_ident
    ||milestone_type_code
    ||milestone_planned_date
    ||milestone_actul_date
  );
  UPDATE ics_enfrc_actn_type
     SET data_hash = MD5_HASH(
      enfrc_actn_type_code
  );
  UPDATE ics_enfrc_actn_viol_lnk
   -- Root table has conditional key, skipping key_hash creation
     SET data_hash = MD5_HASH(
      enfrc_actn_ident
  );
  UPDATE ics_enfrc_agncy
     SET data_hash = MD5_HASH(
      enfrc_agncy_type_code
    ||agncy_lead_ind
  );
  UPDATE ics_fac
     SET data_hash = MD5_HASH(
      fac_site_name
    ||loc_addr_txt
    ||suppl_loc_txt
    ||locality_name
    ||loc_st_code
    ||loc_zip_code
    ||loc_country_code
    ||org_duns_num
    ||st_fac_ident
    ||st_rgn_code
    ||fac_congr_district_num
    ||fac_type_of_ownership_code
    ||fedr_fac_ident_num
    ||fedr_agncy_code
    ||tribal_land_code
    ||cnst_proj_name
    ||cnst_proj_lat_meas
    ||cnst_proj_long_meas
    ||section_township_rng
    ||fac_cmnts
    ||fac_usr_dfnd_fld_1
    ||fac_usr_dfnd_fld_2
    ||fac_usr_dfnd_fld_3
    ||fac_usr_dfnd_fld_4
    ||fac_usr_dfnd_fld_5
    ||loc_addr_county_code
    ||loc_addr_city_code
  );
  UPDATE ics_fac_class
     SET data_hash = MD5_HASH(
      fac_class
  );
  UPDATE ics_final_order
     SET data_hash = MD5_HASH(
      final_order_ident
    ||final_order_type_code
    ||final_order_issued_enterd_date
    ||npdes_closed_date
    ||final_order_qncr_cmnts
    ||cash_civil_pnlty_reqd_amt
    ||othr_cmnts
  );
  UPDATE ics_final_order_prmt_ident
     SET data_hash = MD5_HASH(
      final_order_prmt_ident
  );
  UPDATE ics_final_order_viol_lnk
    -- Root table has conditional key, skipping key_hash creation
    SET data_hash = MD5_HASH( 
       enfrc_actn_ident
    || CAST(final_order_ident AS VARCHAR2(50))
);
  UPDATE ics_frml_enfrc_actn
    SET key_hash = MD5_HASH(ics_frml_enfrc_actn.enfrc_actn_ident),
        data_hash = MD5_HASH(
      enfrc_actn_ident
    ||enfrc_actn_name
    ||forum
    ||resl_type_code
    ||combined_or_superseded_by_eaid
    ||reason_deleting_record
 --   ||fedr_fac_ind
 --   ||fedr_fac_ind_cmnt
    ||frml_ea_usr_dfnd_fld_1
    ||frml_ea_usr_dfnd_fld_2
    ||frml_ea_usr_dfnd_fld_3
    ||frml_ea_usr_dfnd_fld_4
    ||frml_ea_usr_dfnd_fld_5
    ||frml_ea_usr_dfnd_fld_6
    ||enfrc_agncy_name
  );
  UPDATE ics_geo_coord
     SET data_hash = MD5_HASH(
      lat_meas
    ||long_meas
    ||horz_accuracy_meas
    ||geometric_type_code
    ||horz_coll_method_code
    ||horz_ref_datum_code
    ||ref_point_code
    ||src_map_scale_num
  );
  UPDATE ics_gnrl_prmt
    SET key_hash = MD5_HASH(ics_gnrl_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||assc_master_gnrl_prmt_ident
    ||prmt_type_code
    ||agncy_type_code
    ||prmt_stat_code
    ||prmt_issue_date
    ||prmt_effective_date
    ||prmt_expr_date
    ||reissu_prio_prmt_ind
    ||backlog_reason_txt
    ||prmt_issuing_org_type_name
    ||prmt_appealed_ind
    ||prmt_usr_dfnd_dat_elm_1_txt
    ||prmt_usr_dfnd_dat_elm_2_txt
    ||prmt_usr_dfnd_dat_elm_3_txt
    ||prmt_usr_dfnd_dat_elm_4_txt
    ||prmt_usr_dfnd_dat_elm_5_txt
    ||prmt_cmnts_txt
    ||major_minor_rating_code
    ||ttl_appl_dsgn_flow_num
    ||ttl_appl_aver_flow_num
    ||appl_rcvd_date
    ||prmt_appl_cmpl_date
    ||new_src_ind
    ||prmt_st_wtr_body_code
    ||prmt_st_wtr_body_name
    ||fedr_grant_ind
    ||dmr_cognznt_ofcl
    ||dmr_cognznt_ofcl_teleph_num
    ||MAJOR_MINOR_STAT_IND
    ||MAJOR_MINOR_STAT_START_DATE
    ||DMR_NON_RCPT_STAT_IND
    ||DMR_NON_RCPT_STAT_START_DATE    
   ||ELEC_REP_WAIVER_EFFECTIVE_DATE
   ||ELEC_REP_WAIVER_EXPR_DATE
   ||ELEC_REP_WAIVER_TYPE_CODE
   ||ELEC_SUBM_TYPE_CODE
   
  );
  UPDATE ics_gpcf_cnst_waiver
     SET data_hash = MD5_HASH(
      cnst_waiver_auth_date
    ||cnst_waiver_criteria_met_ind
    ||cnst_waiver_eval_basis_code
    ||cnst_waiver_eval_date
    ||cnst_waiver_postmark_date
    ||proj_isoerodent_value
    ||proj_est_start_date
    ||proj_est_completed_date
  );
  UPDATE ics_gpcf_no_exposure
     SET data_hash = MD5_HASH(
      no_exposure_auth_date
    ||no_exposure_postmark_date
    ||no_exposure_eval_date
    ||no_exposure_eval_basis_code
    ||no_exposure_criteria_met_ind
    ||paved_roof_size
    --||indst_acty_size
  );
  UPDATE ics_gpcf_notice_of_intent
     SET data_hash = MD5_HASH(
      noi_sign_date
    ||noi_postmark_date
    ||noi_rcvd_date
    ||complete_noi_rcvd_date
    ||fedr_cercla_dsch_ind
  );
  UPDATE ics_gpcf_notice_of_term
     SET data_hash = MD5_HASH(
      not_term_date
    ||not_sign_date
    ||not_postmark_date
    ||not_rcvd_date
    --||fedr_cercla_dsch_ind
  );
  UPDATE ics_hist_prmt_schd_evts
    SET key_hash = MD5_HASH(ics_hist_prmt_schd_evts.prmt_ident || prmt_effective_date || narr_cond_num || schd_evt_code || schd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_effective_date
    ||narr_cond_num
    ||schd_evt_code
    ||schd_date
    ||schd_rep_rcvd_date
    ||schd_actul_date
    ||schd_proj_date
    ||schd_usr_dfnd_dat_elm_1
    ||schd_usr_dfnd_dat_elm_2
    ||schd_evt_cmnts
  );
  UPDATE ics_impact_sso_evt
     SET data_hash = MD5_HASH(
      impact_sso_evt
  );
-- 5.8
   UPDATE ICS_IMPAIRED_WTR_POLLUTANTS
    SET data_hash = MD5_HASH(
   impaired_wtr_pollutants);  
   
  UPDATE ics_incin
     SET data_hash = MD5_HASH(
      beryllium_cmpl_ind
    ||mercury_cmpl_ind
  );
  UPDATE ics_infrml_enfrc_actn
    SET key_hash = MD5_HASH(ics_infrml_enfrc_actn.enfrc_actn_ident),
        data_hash = MD5_HASH(
      enfrc_actn_ident
    ||enfrc_actn_type_code
    ||enfrc_actn_name
    ||achieved_date
    ||reason_deleting_record
 --   ||fedr_fac_ind
 --   ||fedr_fac_ind_cmnt
    ||infrml_ea_cmnt_txt
    ||infrml_ea_usr_dfnd_fld_1
    ||infrml_ea_usr_dfnd_fld_2
    ||infrml_ea_usr_dfnd_fld_3
    ||infrml_ea_usr_dfnd_fld_4
    ||infrml_ea_usr_dfnd_fld_5
    ||infrml_ea_usr_dfnd_fld_6
    ||enfrc_agncy_name
    ||FILE_NUM
  );
  UPDATE ics_land_appl_bmp
     SET data_hash = MD5_HASH(
      land_appl_bmp_type_code
    ||othr_land_appl_bmp_type_name
  );
  UPDATE ics_land_appl_site
     SET data_hash = MD5_HASH(
      polut_met_for_land_appl
    ||pathogen_reduction_ind
    ||vector_reduction_ind
    ||agronomic_gal_rate_for_fld
    ||agronomic_dmt_rate_for_fld
    ||class_a_alt_used
    ||class_a_alts_txt
    ||class_b_alt_used
    ||class_b_alts_txt
    ||var_alt_used
    ||var_alts_txt
  );
  UPDATE ics_lmt
     SET data_hash = MD5_HASH(
      lmt_start_date
    ||lmt_end_date
    ||lmt_type_code
    ||smpl_type_txt
    ||freq_of_analysis_code
    ||eligible_for_burden_reduction
    ||lmt_stay_type_code
    ||stay_start_date
    ||stay_end_date
    ||stay_reason_txt
    ||calculate_viol_ind
    ||enfrc_actn_ident
    ||final_order_ident
    ||basis_of_lmt
    ||lmt_mod_type_code
    ||lmt_mod_effective_date
    ||lmts_usr_dfnd_fld_1
    ||lmts_usr_dfnd_fld_2
    ||lmts_usr_dfnd_fld_3
    ||concen_num_cond_unit_meas_code
    ||qty_num_cond_unit_meas_code
    ||LMT_MOD_TYPE_STAY_REASON_TXT
  );
  UPDATE ics_lmt_set
    SET key_hash = MD5_HASH(UPPER(ics_lmt_set.prmt_ident) || UPPER(prmt_featr_ident) || UPPER(lmt_set_designator)),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||lmt_set_type
    ||lmt_set_name_txt
    ||dmr_pre_print_cmnts_txt
    ||agncy_reviewer
    ||lmt_set_usr_dfnd_dat_elm_1_txt
    ||lmt_set_usr_dfnd_dat_elm_2_txt
  );
  UPDATE ics_lmt_set_months_appl
     SET data_hash = MD5_HASH(
      lmt_set_months_appl
  );
  UPDATE ics_lmt_set_schd
     SET data_hash = MD5_HASH(
      num_units_rep_period_integer
    ||num_subm_units_integer
    ||initial_mon_date
    ||initial_dmr_due_date
    ||lmt_set_mod_type_code
    ||lmt_set_mod_effective_date
  );
  UPDATE ics_lmt_set_stat
     SET data_hash = MD5_HASH(
      lmt_set_stat_ind
    ||lmt_set_stat_start_date
    ||lmt_set_stat_reason_txt
  );
  UPDATE ics_lmts
    SET key_hash = MD5_HASH(ics_lmts.prmt_ident || prmt_featr_ident || lmt_set_designator || param_code || mon_site_desc_code || lmt_season_num || lmt_start_date || lmt_end_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||param_code
    ||mon_site_desc_code
    ||lmt_season_num
    ||lmt_start_date
    ||lmt_end_date
    ||lmt_type_code
    ||smpl_type_txt
    ||freq_of_analysis_code
    ||eligible_for_burden_reduction
    ||lmt_stay_type_code
    ||stay_start_date
    ||stay_end_date
    ||stay_reason_txt
    ||calculate_viol_ind
    ||enfrc_actn_ident
    ||final_order_ident
    ||basis_of_lmt
    ||lmt_mod_type_code
    ||lmt_mod_effective_date
    ||lmts_usr_dfnd_fld_1
    ||lmts_usr_dfnd_fld_2
    ||lmts_usr_dfnd_fld_3
    ||concen_num_cond_unit_meas_code
    ||qty_num_cond_unit_meas_code
  );
  UPDATE ics_lnk_bs_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||rep_coverage_end_date
  );
  UPDATE ics_lnk_cafo_annul_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||prmt_auth_rep_rcvd_date
  );
  UPDATE ics_lnk_cso_evt_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||cso_evt_date
    ||cso_evt_id
  );
  UPDATE ics_lnk_enfrc_actn
     SET data_hash = MD5_HASH(
      enfrc_actn_ident
  );
  UPDATE ics_lnk_fedr_cmpl_mon
     SET data_hash = MD5_HASH(
      prog_systm_acronym
    ||prog_systm_ident
    ||fedr_statute_code
    ||cmpl_mon_acty_type_code
    ||cmpl_mon_catg_code
    ||cmpl_mon_date
  );
  UPDATE ics_lnk_loc_lmts_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||prmt_auth_rep_rcvd_date
  );
  UPDATE ics_lnk_pretr_perf_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||pretr_perf_summ_end_date
  );
  UPDATE ics_lnk_sngl_evt
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sngl_evt_viol_code
    ||sngl_evt_viol_date
  );
  UPDATE ics_lnk_sso_annul_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sso_annul_rep_rcvd_date
  );
  UPDATE ics_lnk_sso_evt_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sso_evt_date
    ||sso_evt_id
  );
  UPDATE ics_lnk_sso_monthly_evt_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sso_monthly_rep_rcvd_date
  );
  UPDATE ics_lnk_st_cmpl_mon
     SET data_hash = MD5_HASH(
      cmpl_mon_ident
  );
  UPDATE ics_lnk_sw_evt_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||date_strm_evt_smpl
    ||sw_evt_id
  );
  UPDATE ics_lnk_swms_4_rep
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sw_ms_4_rep_rcvd_date
  );
  UPDATE ics_loc_lmts
     SET data_hash = MD5_HASH(
      mos_rc_date_tech_eval_loc_lmts
    ||mos_rc_date_ad_tc_bs_loc_lmts
  );
  UPDATE ics_loc_lmts_polut
     SET data_hash = MD5_HASH(
      loc_lmts_polut_code
  );
  UPDATE ics_loc_lmts_prog_rep
    SET key_hash = MD5_HASH(ics_loc_lmts_prog_rep.prmt_ident || prmt_auth_rep_rcvd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_auth_rep_rcvd_date
  );
  UPDATE ics_master_gnrl_prmt
    SET key_hash = MD5_HASH(ics_master_gnrl_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_type_code
    ||agncy_type_code
    ||prmt_issue_date
    ||prmt_effective_date
    ||prmt_expr_date
    ||reissu_prio_prmt_ind
    ||backlog_reason_txt
    ||prmt_issuing_org_type_name
    ||prmt_appealed_ind
    ||prmt_usr_dfnd_dat_elm_1_txt
    ||prmt_usr_dfnd_dat_elm_2_txt
    ||prmt_usr_dfnd_dat_elm_3_txt
    ||prmt_usr_dfnd_dat_elm_4_txt
    ||prmt_usr_dfnd_dat_elm_5_txt
    ||prmt_cmnts_txt
    ||gnrl_prmt_indst_catg
    ||prmt_name
  );
   -- 5.8
   UPDATE ICS_MGMT_PRC_DEFCY_TYPE
    SET data_hash = MD5_HASH(
   mgmt_prc_defcy_type_code);
  
  UPDATE ics_mn_lmt_applies
     SET data_hash = MD5_HASH(
      mn_lmt_applies
  );
  UPDATE ics_mnur_lttr_prcss_ww_stor
     SET data_hash = MD5_HASH(
      mnur_lttr_prcss_ww_stor_type
    ||othr_stor_type_name
    ||stor_ttl_cpcty_meas
    ||days_of_stor
  );
  UPDATE ics_naics_code
     SET data_hash = MD5_HASH(
      naics_code
    ||naics_primary_ind_code
  );
  UPDATE ics_narr_cond_schd
    SET key_hash = MD5_HASH(ics_narr_cond_schd.prmt_ident || narr_cond_num),
        data_hash = MD5_HASH(
      prmt_ident
    ||narr_cond_num
    ||narr_cond_code
    ||cmnts
  );
  UPDATE ics_nat_prio
     SET data_hash = MD5_HASH(
      nat_prio_code
  );
   -- 5.8
   UPDATE ICS_NPDES_DAT_GRP_NUM
    SET data_hash = MD5_HASH(
      npdes_dat_grp_num_code);
  
  UPDATE ics_num_cond
     SET data_hash = MD5_HASH(
      num_cond_txt
    ||num_cond_qty
    ||num_cond_stat_base_code
    ||num_cond_qualifier
    ||num_cond_opt_mon_ind
    ||num_cond_stay_value
  );
  UPDATE ics_num_rep
     SET data_hash = MD5_HASH(
      num_rep_code
    ||num_rep_rcvd_date
    ||num_rep_no_dsch_ind
    ||num_cond_qty
    ||num_cond_adjusted_qty
    ||num_cond_qualifier
  );
  UPDATE ics_orig_progs
     SET data_hash = MD5_HASH(
      orig_progs_code
  );
  UPDATE ics_othr_prmts
     SET data_hash = MD5_HASH(
      othr_prmt_ident
    ||othr_org_name
    ||othr_prmt_ident_cntxt_name
  );
  UPDATE ics_param_lmts
    SET key_hash = MD5_HASH(ics_param_lmts.prmt_ident || prmt_featr_ident || lmt_set_designator || param_code || mon_site_desc_code || lmt_season_num),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||lmt_set_designator
    ||param_code
    ||mon_site_desc_code
    ||lmt_season_num
  );
   -- 5.8
   UPDATE ICS_PATHOGEN_REDUCTION_TYPE
    SET data_hash = MD5_HASH(
   pathogen_reduction_type_code); 
 
  UPDATE ics_plcy
     SET data_hash = MD5_HASH(
      plcy_code
  );
  UPDATE ics_potw_prmt
    SET key_hash = MD5_HASH(ics_potw_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||sscs_popl_served_num
    ||combined_sscs_systm_length
  );
  UPDATE ics_pretr_insp
     SET data_hash = MD5_HASH(
      suo_ref
    ||suo_date
    ||acceptance_haz_waste
    ||acceptance_non_haz_indst_waste
    ||acceptance_huled_domstic_wstes
    ||annul_pretr_budget
    ||inadequacy_smpl_insp_ind
    ||adequacy_pretr_resources
    ||dfcnc_idntfd_drng_iu_file_rviw
    ||control_mech_dfcnc
    ||legal_auth_dfcnc
    ||dfcnc_intrprt_appl_pretr_stndr
    ||dfcnc_dat_mgmt_pblc_prticipton
    ||viol_iu_schd_rmd_msr
    ||frml_rspn_viol_iu_schd_rmd_msr
    ||annul_freq_influnt_toxcnt_smpl
    ||annul_freq_efflu_toxcnt_smpl
    ||annul_freq_sldg_toxcnt_smpl
    ||num_si_us
    ||si_us_without_control_mech
    ||si_us_not_inspected
    ||si_us_not_smpl
    ||si_us_on_schd
    ||si_us_snc_with_pretr_stndr
    ||si_us_snc_with_rep_reqs
    ||si_us_snc_with_pretr_schd
    ||si_us_snc_publ_newspaper
    ||viol_notices_issued_si_us
    ||admin_orders_issued_si_us
    ||civil_suts_fild_aginst_si_us
    ||criminl_suts_fild_aginst_si_us
    ||dollar_amt_pnlty_coll
    ||i_us_whc_pnlty_hav_bee_coll
    ||num_ci_us
    ||ci_us_in_snc
    ||pass_through_interference_ind
  );
  UPDATE ics_pretr_perf_summ
    SET key_hash = MD5_HASH(ics_pretr_perf_summ.prmt_ident || pretr_perf_summ_end_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||pretr_perf_summ_end_date
    ||pretr_perf_summ_start_date
    ||suo_ref
    ||suo_date
    ||acceptance_haz_waste
    ||acceptance_non_haz_indst_waste
    ||acceptance_huled_domstic_wstes
    ||annul_pretr_budget_pp
    ||inadequacy_smpl_insp_ind
    ||adequacy_pretr_resources
    ||dfcnc_idntfd_drng_iu_file_rviw
    ||control_mech_dfcnc
    ||legal_auth_dfcnc
    ||dfcnc_intrprt_appl_pretr_stndr
    ||dfcnc_dat_mgmt_pblc_prticipton
    ||viol_iu_schd_rmd_msr
    ||frml_rspn_viol_iu_schd_rmd_msr
    ||annul_freq_influnt_toxcnt_smpl
    ||annul_freq_efflu_toxcnt_smpl
    ||annul_freq_sldg_toxcnt_smpl
    ||num_si_us
    ||si_us_without_control_mech
    ||si_us_not_inspected
    ||si_us_not_smpl
    ||si_us_on_schd
    ||si_us_snc_with_pretr_stndr
    ||si_us_snc_with_rep_reqs
    ||si_us_snc_with_pretr_schd
    ||si_us_snc_publ_newspaper
    ||viol_notices_issued_si_us
    ||admin_orders_issued_si_us
    ||civil_suts_fild_aginst_si_us
    ||criminl_suts_fild_aginst_si_us
    ||dollar_amt_pnlty_coll_pp
    ||i_us_whc_pnlty_hav_bee_coll_pp
    ||num_ci_us
    ||ci_us_in_snc
    ||pass_through_interference_ind
  );
  UPDATE ics_pretr_prmt
    SET key_hash = MD5_HASH(ics_pretr_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||pretr_prog_reqd_ind_code
    ||control_auth_st_agncy_code
    ||control_auth_rgnl_agncy_code
    ||control_auth_npdes_ident
    ||pretr_prog_aprvd_date
  );
  UPDATE ics_prmt_comp_type
     SET data_hash = MD5_HASH(
      prmt_comp_type_code
  );
  UPDATE ics_prmt_featr
    SET key_hash = MD5_HASH(ics_prmt_featr.prmt_ident || prmt_featr_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_featr_ident
    ||prmt_featr_type_code
    ||prmt_featr_desc
    ||prmt_featr_dsgn_flow_num
    ||prmt_featr_actul_aver_flow_num
    ||prmt_featr_st_wtr_body_code
    ||prmt_featr_st_wtr_body_name
    ||prmt_featr_usr_dfnd_dat_elm_1
    ||prmt_featr_usr_dfnd_dat_elm_2
    ||fld_size
    ||is_site_own_by_fac
    ||is_systm_lined_with_leachate
    ||does_unit_hav_daily_cover
    ||prop_boundary_distance
    ||is_reqd_nitrate_ground_wtr
    ||well_num
    ||src_prmt_featr_detail_txt
    ||impaired_wtr_ind
    ||tmdl_completed_ind
   ||TIER_LEVEL_NAME

  );
  UPDATE ics_prmt_featr_char
     SET data_hash = MD5_HASH(
      prmt_featr_char
  );
  UPDATE ics_prmt_featr_trtmnt_type
     SET data_hash = MD5_HASH(
      prmt_featr_trtmnt_type_code
  );
  UPDATE ics_prmt_ident
     SET data_hash = MD5_HASH(
      prmt_ident
  );
  UPDATE ics_prmt_reissu
    SET key_hash = MD5_HASH(ics_prmt_reissu.prmt_ident),
        data_hash = MD5_HASH(ics_prmt_reissu.prmt_effective_date
  );
  UPDATE ics_prmt_schd_evt
     SET data_hash = MD5_HASH(
      schd_evt_code
    ||schd_date
    ||schd_rep_rcvd_date
    ||schd_actul_date
    ||schd_proj_date
    ||schd_usr_dfnd_dat_elm_1
    ||schd_usr_dfnd_dat_elm_2
    ||schd_evt_cmnts
  );
  UPDATE ics_prmt_schd_evt_viol_elem
     SET data_hash = MD5_HASH(
      prmt_ident
    ||narr_cond_num
    ||schd_evt_code
    ||schd_date
    ||schd_viol_code
  );
  UPDATE ics_prmt_schd_viol
     SET data_hash = MD5_HASH(
      prmt_ident
    ||narr_cond_num
    ||schd_evt_code
    ||schd_date
  );
  UPDATE ics_prmt_term
    SET key_hash = MD5_HASH(ics_prmt_term.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_term_date
  );
  UPDATE ics_prmt_track_evt
    SET key_hash = MD5_HASH(ics_prmt_track_evt.prmt_ident || prmt_track_evt_code || prmt_track_evt_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||prmt_track_evt_code
    ||prmt_track_evt_date
    ||prmt_track_cmnts_txt
  );
  UPDATE ics_prog
     SET data_hash = MD5_HASH(
      prog_code
  );
  UPDATE ics_prog_defcy_type
   SET data_hash = MD5_HASH(
      PROG_DEFCY_TYPE_CODE
  );
  UPDATE ics_progs_viol
     SET data_hash = MD5_HASH(
      progs_viol_code
  );
  UPDATE ics_proj_srcs_fund
     SET data_hash = MD5_HASH(
      proj_srcs_fund_code
  );
  UPDATE ics_proj_type
     SET data_hash = MD5_HASH(
      proj_type_code
    ||proj_type_code_othr_desc
  );
  UPDATE ics_rep_anml_type
     SET data_hash = MD5_HASH(
      anml_type_code
    ||othr_anml_type_name
    ||ttl_num_each_lvstck
  );
 -- 5.8
UPDATE ICS_REP_OBLGTN_TYPE
 SET data_hash = MD5_HASH(
rep_oblgtn_type_code);
 
  UPDATE ics_rep_param
     SET data_hash = MD5_HASH(
      param_code
    ||mon_site_desc_code
    ||lmt_season_num
    ||rep_smpl_type_txt
    ||rep_freq_code
    ||rep_num_of_excursions
    ||concen_num_rep_unit_meas_code
    ||qty_num_rep_unit_meas_code
  );
  UPDATE ICS_REP_NON_CMPL_STAT
   SET DATA_HASH = MD5_HASH(
      REP_NON_CMPL_STAT_CODE_YEAR
      || REP_NON_CMPL_STAT_CODE_QUARTER
      || REP_NON_CMPL_MANUAL_STAT_CODE
   );
  UPDATE ics_rmvl_crdts
     SET data_hash = MD5_HASH(
      mos_rc_date_rmvl_crdts_aprvl
    ||rmvl_crdts_appl_stat_code
  );
  UPDATE ics_rmvl_crdts_polut
     SET data_hash = MD5_HASH(
      rmvl_crdts_polut_code
  );
  UPDATE ics_satl_coll_systm
     SET data_hash = MD5_HASH(
      satl_coll_systm_ident
    ||satl_coll_systm_name
  );
  UPDATE ics_sep
      SET data_hash = MD5_HASH(
      SEP_IDENT
      || SEP_DESC
      || SEP_PNLTY_ASSESSMENT_AMT
   );
  UPDATE ics_schd_evt_viol
   -- Root table has conditional key, skipping key_hash creation
     SET data_hash = MD5_HASH(
      rep_non_cmpl_resl_code
    ||rep_non_cmpl_resl_date
  );
  UPDATE ics_sic_code
     SET data_hash = MD5_HASH(
      sic_code
    ||sic_primary_ind_code
  );
  UPDATE ics_sngl_evt_viol
    SET key_hash = MD5_HASH(ics_sngl_evt_viol.prmt_ident || sngl_evt_viol_code || sngl_evt_viol_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||sngl_evt_viol_code
    ||sngl_evt_viol_date
  ---  ||sngl_evt_viol_start_date
    ||sngl_evt_viol_end_date
    ||rep_non_cmpl_detect_code
    ||rep_non_cmpl_detect_date
    ||rep_non_cmpl_resl_code
    ||rep_non_cmpl_resl_date
    ||sngl_evt_usr_dfnd_fld_1
    ||sngl_evt_usr_dfnd_fld_2
    ||sngl_evt_usr_dfnd_fld_3
    ||sngl_evt_usr_dfnd_fld_4
    ||sngl_evt_usr_dfnd_fld_5
    ||sngl_evt_cmnt_txt
  );
  UPDATE ics_sngl_evts_viol
     SET data_hash = MD5_HASH(
      prmt_ident
    ||sngl_evt_viol_code
    ||sngl_evt_viol_date
  );
  UPDATE ics_sso_annul_rep
    SET key_hash = MD5_HASH(ics_sso_annul_rep.prmt_ident || sso_annul_rep_rcvd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||sso_annul_rep_rcvd_date
    ||sso_annul_rep_year
    ||num_sso_evts_per_year
    ||vol_sso_evts_per_year
  );
  UPDATE ics_sso_evt_rep
    SET key_hash = MD5_HASH(prmt_ident || sso_evt_date|| sso_evt_id),
        data_hash = MD5_HASH(
      cause_sso_ovrflw_evt
    ||lat_meas
    ||long_meas
    ||sso_ovrflw_loc_street
    ||duration_sso_ovrflw_evt
    ||sso_vol
    ||name_rcvg_wtr
    ||desc_stps_taken
  );
  UPDATE ics_sso_insp
     SET data_hash = MD5_HASH(
      sso_evt_date
    ||cause_sso_ovrflw_evt
    ||lat_meas
    ||long_meas
    ||sso_ovrflw_loc_street
    ||duration_sso_ovrflw_evt
    ||sso_vol
    ||name_rcvg_wtr
    ||desc_stps_taken
  );
  UPDATE ics_sso_monthly_evt_rep
    SET key_hash = MD5_HASH(ics_sso_monthly_evt_rep.prmt_ident || sso_monthly_rep_rcvd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||sso_monthly_rep_rcvd_date
    ||sso_monthly_evt_mn
    ||sso_monthly_evt_year
    ||num_sso_evts_rec_us_wtr_per_mn
    ||vol_sso_evts_rec_us_wtr_per_mn
  );
  UPDATE ics_sso_stps
     SET data_hash = MD5_HASH(
      stps_rduce_prevnt_mitigte
    ||othr_stps_rduce_prevnt_mitigte
  );
  UPDATE ics_sso_systm_comp
     SET data_hash = MD5_HASH(
      systm_comp
    ||othr_systm_comp
  );
  UPDATE ics_surf_dspl_site
     SET data_hash = MD5_HASH(
      pathogen_reduction_ind
    ||vector_reduction_ind
    ||mgmt_practices_ind
    ||cert_statement_ind
    ||cert_first_name
    ||cert_last_name
    ||class_a_alt_used
    ||class_a_alts_txt
    ||class_b_alt_used
    ||class_b_alts_txt
    ||var_alt_used
    ||var_alts_txt
  );
  UPDATE ics_sw_cnst_indst_insp
     SET data_hash = MD5_HASH(
      swppp_eval_basis_code
    ||swppp_eval_date
    ||swppp_eval_desc_txt
    ||no_exposure_auth_date
  );
  UPDATE ics_sw_cnst_insp
     SET data_hash = MD5_HASH(
  0);
  UPDATE ics_sw_cnst_non_cnst_insp
     SET data_hash = MD5_HASH(
  0);
  UPDATE ics_sw_cnst_prmt
    SET key_hash = MD5_HASH(ics_sw_cnst_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||st_wtr_body_name
    ||rcvg_ms_4_name
    ||impaired_wtr_ind
    ||hist_prop_ind
    ||hist_prop_crit_met_code
    ||species_crit_habitat_ind
    ||species_crit_met_code
    ||proj_type_code
    ||est_start_date
    ||est_complete_date
    ||est_area_disturbed_acres_num
    ||proj_plan_size_code
   ||ANTIDEG_IND
   ||CATIONIC_CHEMS_AUTH_IND
   ||CATIONIC_CHEMS_IND
   ||CGP_IND
   ||CNST_SITE_OTHR_TXT
   ||ERTH_DISTRB_ACTIVITIES_IND
   ||ERTH_DISTRB_EMRGCY_IND
   ||MS_4_DSCH_IND
   ||OTHR_PRMT_IDENT
   ||PREDEV_LAND_USE_IND
   ||PREVIOUS_SW_DSCH_IND
   ||PRIOR_SURVEYS_EVALS_IND
   ||SBSRFC_ERTH_DSTRBN_CONTROL_IND
   ||SBSRFC_ERTH_DSTRBN_IND
   ||STRCT_DEMOED_FLOOR_SPACE_IND
   ||STRCT_DEMOED_IND
   ||SWPPP_PREP_IND
   ||TRTMNT_CHEMS_IND
   ||WTR_PROX_IND
  );
  UPDATE ics_sw_evt_rep
    SET key_hash = MD5_HASH(prmt_ident || date_strm_evt_smpl|| sw_evt_id),
        data_hash = MD5_HASH(
      prmt_featr_ident
    ||rainfall_strm_evt_smpl_num
    ||duration_strm_evt_smpl
    ||vol_dsch_smpl
    ||duration_since_last_strm_evt
    ||smpl_basis_ind
    ||precip_form
    ||smpl_taken_within_timefrme_ind
    ||time_exceedance_rationale_code
    ||essen_identical_outfall_notif
    ||mon_exemption_rationale_ind
    ||polut_mon_basis_code
  );
  UPDATE ics_sw_indst_prmt
    SET key_hash = MD5_HASH(ics_sw_indst_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||st_wtr_body_name
    ||rcvg_ms_4_name
    ||impaired_wtr_ind
    ||hist_prop_ind
    ||hist_prop_crit_met_code
    ||species_crit_habitat_ind
    ||species_crit_met_code
    ||indst_acty_size
    ||web_addr_url
    ||activities_exposed_sw_txt
    ||assc_pollutants_txt
    ||control_msr_txt
    ||schd_control_msr_txt
    ||tier_two_ind
    ||tier_three_ind
  );
  UPDATE ics_sw_ms_4_insp
     SET data_hash = MD5_HASH(
      ms_4_annul_expen_dollars
    ||ms_4_annul_expen_year
    ||ms_4_budget_dollars
    ||ms_4_budget_year
    ||major_outfall_est_meas_ind
    ||major_outfall_num
    ||minor_outfall_est_meas_ind
    ||minor_outfall_num
  );
  UPDATE ics_sw_non_cnst_insp
     SET data_hash = MD5_HASH(
  0);
  UPDATE ics_sw_unprmt_cnst_insp
     SET data_hash = MD5_HASH(
      est_start_date
    ||est_complete_date
    ||est_area_disturbed_acres_num
    ||proj_plan_size_code
  );
  UPDATE ics_swms_4_large_prmt
    SET key_hash = MD5_HASH(ics_swms_4_large_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||st_wtr_body_name
    ||rcvg_ms_4_name
    ||impaired_wtr_ind
    ||hist_prop_ind
    ||hist_prop_crit_met_code
    ||species_crit_habitat_ind
    ||species_crit_met_code
    ||legal_entity_type_code
    ||ms_4_prmt_class_code
    ||ms_4_type_code
    ||ms_4_acreage_covered_num
    ||ms_4_popl_served_num
    ||urbanized_area_incrp_plce_name
    ||ms_4_annul_expen_dollars
    ||ms_4_annul_expen_year
    ||ms_4_budget_dollars
    ||ms_4_budget_year
    ||proj_srcs_of_fund_code
    ||major_outfall_est_meas_ind
    ||major_outfall_num
    ||minor_outfall_est_meas_ind
    ||minor_outfall_num
  );
  UPDATE ics_swms_4_prog_rep
    SET key_hash = MD5_HASH(ics_swms_4_prog_rep.prmt_ident || sw_ms_4_rep_rcvd_date),
        data_hash = MD5_HASH(
      prmt_ident
    ||sw_ms_4_rep_rcvd_date
    ||ms_4_annul_expen_dollars
    ||ms_4_annul_expen_year
    ||ms_4_budget_dollars
    ||ms_4_budget_year
    ||major_outfall_est_meas_ind
    ||major_outfall_num
    ||minor_outfall_est_meas_ind
    ||minor_outfall_num
  );
  UPDATE ics_swms_4_small_prmt
    SET key_hash = MD5_HASH(ics_swms_4_small_prmt.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||st_wtr_body_name
    ||rcvg_ms_4_name
    ||impaired_wtr_ind
    ||hist_prop_ind
    ||hist_prop_crit_met_code
    ||species_crit_habitat_ind
    ||species_crit_met_code
    ||legal_entity_type_code
    ||ms_4_prmt_class_code
    ||ms_4_type_code
    ||ms_4_acreage_covered_num
    ||ms_4_popl_served_num
    ||urbanized_area_incrp_plce_name
    ||ms_4_annul_expen_dollars
    ||ms_4_annul_expen_year
    ||ms_4_budget_dollars
    ||ms_4_budget_year
    ||proj_srcs_of_fund_code
    ||major_outfall_est_meas_ind
    ||major_outfall_num
    ||minor_outfall_est_meas_ind
    ||minor_outfall_num
    ||qual_loc_prog_ind
    ||qual_loc_prog_desc_txt
    ||shared_resp_ind
    ||shared_resp_desc_txt
  );
  UPDATE ics_teleph
     SET data_hash = MD5_HASH(
      teleph_num_type_code
    ||teleph_num
    ||teleph_ext_num
  );
   -- 5.8
   UPDATE ICS_TMDL_POLLUTANTS
    SET data_hash = MD5_HASH(
   tmdl_ident
   || tmdl_name);
   -- 5.8
   UPDATE ICS_TMDL_POLUT
    SET data_hash = MD5_HASH(
   tmdl_polut_code);
   -- 5.8
   UPDATE ICS_TRTMNT_CHEMS_LIST
    SET data_hash = MD5_HASH(
   trtmnt_chems_list);
   -- 5.8
   UPDATE ICS_TRTMNT_PRCSS_TYPE
    SET data_hash = MD5_HASH(
   trtmnt_prcss_type_code);
   -- 5.8
   UPDATE ICS_VECTOR_A_REDUCTION_TYPE
    SET data_hash = MD5_HASH(
   vector_a_reduction_type_code);   
  
  UPDATE ics_unprmt_fac
    SET key_hash = MD5_HASH(ics_unprmt_fac.prmt_ident),
        data_hash = MD5_HASH(
      prmt_ident
    ||fac_site_name
    ||loc_addr_txt
    ||suppl_loc_txt
    ||locality_name
    ||loc_st_code
    ||loc_zip_code
    ||loc_country_code
    ||org_duns_num
    ||st_fac_ident
    ||st_rgn_code
    ||fac_congr_district_num
    ||fac_type_of_ownership_code
    ||fedr_fac_ident_num
    ||fedr_agncy_code
    ||tribal_land_code
    ||cnst_proj_name
    ||cnst_proj_lat_meas
    ||cnst_proj_long_meas
    ||section_township_rng
    ||fac_cmnts
    ||fac_usr_dfnd_fld_1
    ||fac_usr_dfnd_fld_2
    ||fac_usr_dfnd_fld_3
    ||fac_usr_dfnd_fld_4
    ||fac_usr_dfnd_fld_5
    ||prmt_cmnts_txt
   ||LOC_ADDR_CITY_CODE
   ||LOC_ADDR_COUNTY_CODE
    
  );

--Create KEY_HASH for modules with conditional keys (5 data families)
                     
UPDATE ics_cmpl_mon_lnk
   SET key_hash = (SELECT MD5_HASH(
                           ics_cmpl_mon_lnk.cmpl_mon_ident
                           
                         ||ics_lnk_bs_rep.prmt_ident
                         ||ics_lnk_cso_evt_rep.prmt_ident
                         ||ics_lnk_loc_lmts_rep.prmt_ident
                         ||ics_lnk_pretr_perf_rep.prmt_ident
                         ||ics_lnk_cafo_annul_rep.prmt_ident
                         ||ics_lnk_sso_monthly_evt_rep.prmt_ident
                         ||ics_lnk_swms_4_rep.prmt_ident
                         ||ics_lnk_sngl_evt.prmt_ident
                         ||ics_lnk_sso_annul_rep.prmt_ident
                         ||ics_lnk_sw_evt_rep.prmt_ident
                         ||ics_lnk_sso_evt_rep.prmt_ident
                         ||ics_lnk_sngl_evt.sngl_evt_viol_code
                         ||ics_lnk_sngl_evt.sngl_evt_viol_date
                         ||ics_lnk_enfrc_actn.enfrc_actn_ident
                         ||ics_lnk_bs_rep.rep_coverage_end_date
                         ||ics_lnk_loc_lmts_rep.prmt_auth_rep_rcvd_date
                         ||ics_lnk_cafo_annul_rep.prmt_auth_rep_rcvd_date
                         ||ics_lnk_cso_evt_rep.cso_evt_date
                         ||ics_lnk_pretr_perf_rep.pretr_perf_summ_end_date
                         ||ics_lnk_sso_annul_rep.sso_annul_rep_rcvd_date
                         ||ics_lnk_sso_evt_rep.sso_evt_date
                         ||ics_lnk_sso_monthly_evt_rep.sso_monthly_rep_rcvd_date
                         ||ics_lnk_sw_evt_rep.date_strm_evt_smpl
                         ||ics_lnk_swms_4_rep.sw_ms_4_rep_rcvd_date 
                         ||ics_lnk_st_cmpl_mon.cmpl_mon_ident
                         ||ics_lnk_cso_evt_rep.cso_evt_id
                         ||ics_lnk_sso_evt_rep.sso_evt_id
                         ||ics_lnk_sw_evt_rep.sw_evt_id
                         )
                    FROM ics_cmpl_mon_lnk inner_lnk
            LEFT JOIN ics_lnk_bs_rep on ics_lnk_bs_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_cafo_annul_rep on ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_cso_evt_rep on ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_enfrc_actn on ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_loc_lmts_rep on ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_pretr_perf_rep on ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_sngl_evt on ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_sso_annul_rep on ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_sso_evt_rep on ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_sso_monthly_evt_rep on ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_st_cmpl_mon on ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_sw_evt_rep on ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            LEFT JOIN ics_lnk_swms_4_rep on ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
            WHERE ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id = inner_lnk.ics_cmpl_mon_lnk_id
        );

UPDATE ics_schd_evt_viol
SET key_hash = (SELECT MD5_HASH(ics_prmt_schd_evt_viol_elem.prmt_ident
                              ||ics_cmpl_schd_evt_viol_elem.prmt_ident
                              ||ics_prmt_schd_evt_viol_elem.narr_cond_num
                              ||ics_cmpl_schd_evt_viol_elem.schd_evt_code
                              ||ics_prmt_schd_evt_viol_elem.schd_evt_code
                              ||ics_prmt_schd_evt_viol_elem.schd_date
                              ||ics_cmpl_schd_evt_viol_elem.schd_date
                              ||ics_prmt_schd_evt_viol_elem.schd_viol_code
                              ||ics_cmpl_schd_evt_viol_elem.schd_viol_code
                              ||ics_cmpl_schd_evt_viol_elem.enfrc_actn_ident
                              ||ics_cmpl_schd_evt_viol_elem.final_order_ident
                              ||ics_cmpl_schd_evt_viol_elem.cmpl_schd_num
                              )
                  FROM ics_schd_evt_viol inner_viol
                    LEFT JOIN ics_prmt_schd_evt_viol_elem on ics_prmt_schd_evt_viol_elem.ics_schd_evt_viol_id = inner_viol.ics_schd_evt_viol_id
                    LEFT JOIN ics_cmpl_schd_evt_viol_elem on ics_cmpl_schd_evt_viol_elem.ics_schd_evt_viol_id = inner_viol.ics_schd_evt_viol_id
                  WHERE ics_schd_evt_viol.ics_schd_evt_viol_id = inner_viol.ics_schd_evt_viol_id
               );

UPDATE ics_dmr_prog_rep_lnk
   SET key_hash = (SELECT MD5_HASH(ics_dmr_prog_rep_lnk.prmt_ident
                                 ||ics_dmr_prog_rep_lnk.prmt_featr_ident
                                 ||ics_dmr_prog_rep_lnk.lmt_set_designator
                                 ||ics_dmr_prog_rep_lnk.mon_period_end_date
                                 ||ics_lnk_bs_rep.prmt_ident
                                 ||ics_lnk_sw_evt_rep.prmt_ident
                                 ||ics_lnk_bs_rep.rep_coverage_end_date
                                 ||ics_lnk_sw_evt_rep.date_strm_evt_smpl
                                 ||ics_lnk_sw_evt_rep.sw_evt_id)
                     FROM ics_dmr_prog_rep_lnk inner_lnk
                       LEFT JOIN ics_lnk_bs_rep on ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id = inner_lnk.ics_dmr_prog_rep_lnk_id
                       LEFT JOIN ics_lnk_sw_evt_rep on ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id = inner_lnk.ics_dmr_prog_rep_lnk_id
                   WHERE ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id = inner_lnk.ics_dmr_prog_rep_lnk_id
                  );

UPDATE ics_enfrc_actn_viol_lnk
   SET key_hash = (SELECT MD5_HASH(ics_enfrc_actn_viol_lnk.enfrc_actn_ident
                                 ||ics_prmt_schd_viol.prmt_ident
                                 ||ics_prmt_schd_viol.narr_cond_num
                                 ||ics_prmt_schd_viol.schd_evt_code
                                 ||ics_cmpl_schd_viol.schd_evt_code
                                 ||ics_prmt_schd_viol.schd_date
                                 ||ics_cmpl_schd_viol.schd_date
                                 ||ics_cmpl_schd_viol.enfrc_actn_ident
                                 ||ics_cmpl_schd_viol.final_order_ident
                                 ||ics_cmpl_schd_viol.prmt_ident 
                                 ||ics_sngl_evts_viol.prmt_ident
                                 ||ics_dsch_mon_rep_viol.prmt_ident
                                 ||ics_dsch_mon_rep_param_viol.prmt_ident
                                 ||ics_cmpl_schd_viol.cmpl_schd_num
                                 ||ics_dsch_mon_rep_viol.prmt_featr_ident
                                 ||ics_dsch_mon_rep_param_viol.prmt_featr_ident
                                 ||ics_dsch_mon_rep_viol.lmt_set_designator
                                 ||ics_dsch_mon_rep_param_viol.lmt_set_designator
                                 ||ics_dsch_mon_rep_param_viol.param_code
                                 ||ics_dsch_mon_rep_param_viol.mon_site_desc_code
                                 ||ics_dsch_mon_rep_param_viol.lmt_season_num
                                 ||ics_dsch_mon_rep_viol.mon_period_end_date
                                 ||ics_dsch_mon_rep_param_viol.mon_period_end_date
                                 ||ics_sngl_evts_viol.sngl_evt_viol_code
                                 ||ics_sngl_evts_viol.sngl_evt_viol_date)
                     FROM ics_enfrc_actn_viol_lnk inner_lnk
                       LEFT JOIN ics_prmt_schd_viol on ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                       LEFT JOIN ics_cmpl_schd_viol on ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                       LEFT JOIN ics_dsch_mon_rep_viol on ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                       LEFT JOIN ics_dsch_mon_rep_param_viol on ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                       LEFT JOIN ics_sngl_evts_viol on ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                    WHERE ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id = inner_lnk.ics_enfrc_actn_viol_lnk_id
                  );

UPDATE ics_final_order_viol_lnk
   SET key_hash = (SELECT MD5_HASH(ics_final_order_viol_lnk.enfrc_actn_ident
                                 ||ics_final_order_viol_lnk.final_order_ident
                                 ||ics_prmt_schd_viol.prmt_ident
                                 ||ics_cmpl_schd_viol.prmt_ident 
                                 ||ics_dsch_mon_rep_param_viol.prmt_ident
                                 ||ics_sngl_evts_viol.prmt_ident
                                 ||ics_dsch_mon_rep_viol.prmt_ident
                                 ||ics_prmt_schd_viol.narr_cond_num
                                 ||ics_prmt_schd_viol.schd_evt_code
                                 ||ics_cmpl_schd_viol.schd_evt_code
                                 ||ics_prmt_schd_viol.schd_date
                                 ||ics_cmpl_schd_viol.schd_date
                                 ||ics_cmpl_schd_viol.enfrc_actn_ident
                                 ||ics_cmpl_schd_viol.final_order_ident
                                 ||ics_cmpl_schd_viol.cmpl_schd_num
                                 ||ics_dsch_mon_rep_viol.prmt_featr_ident
                                 ||ics_dsch_mon_rep_param_viol.prmt_featr_ident
                                 ||ics_dsch_mon_rep_viol.lmt_set_designator
                                 ||ics_dsch_mon_rep_param_viol.lmt_set_designator
                                 ||ics_dsch_mon_rep_viol.mon_period_end_date
                                 ||ics_dsch_mon_rep_param_viol.mon_period_end_date
                                 ||ics_dsch_mon_rep_param_viol.param_code
                                 ||ics_dsch_mon_rep_param_viol.mon_site_desc_code
                                 ||ics_dsch_mon_rep_param_viol.lmt_season_num
                                 ||ics_sngl_evts_viol.sngl_evt_viol_code
                                 ||ics_sngl_evts_viol.sngl_evt_viol_date)
                     FROM ics_final_order_viol_lnk inner_lnk
                       LEFT JOIN ics_prmt_schd_viol on ics_prmt_schd_viol.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                       LEFT JOIN ics_cmpl_schd_viol on ics_cmpl_schd_viol.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                       LEFT JOIN ics_dsch_mon_rep_viol on ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                       LEFT JOIN ics_dsch_mon_rep_param_viol on ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                       LEFT JOIN ics_sngl_evts_viol on ics_sngl_evts_viol.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                   WHERE ics_final_order_viol_lnk.ics_final_order_viol_lnk_id = inner_lnk.ics_final_order_viol_lnk_id
                  );


 /************************************/  
 /* START - Process DATA_HASH values */
 /* START - Process DATA_HASH values */
 /* START - Process DATA_HASH values */
 /************************************/ 
 
  /* Loop through each payload type, for each loop roll child data_hash values up to the parent payload table */  
  <<module_loop>>
  FOR payload_type IN (SELECT child.table_name
                         FROM user_constraints child
                         LEFT JOIN user_constraints parent
                           ON child.r_constraint_name = parent.constraint_name
                        WHERE child.constraint_type = 'R'
                          AND parent.table_name = 'ICS_PAYLOAD'  
                          /* The tables in this list will not have related child data, change processing can be skipped */
                          AND child.table_name NOT IN ( 'ICS_BS_PROG_REP'
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
                                                      , 'ICS_SSO_MONTHLY_EVT_REP')                  
                        ORDER BY child.table_name
                        ) LOOP

    BEGIN
         
      EXECUTE IMMEDIATE 'SELECT ENABLED FROM ICS_PAYLOAD JOIN ' || payload_type.table_name || 
        ' ON ICS_PAYLOAD.ICS_PAYLOAD_ID = ' || payload_type.table_name || '.ICS_PAYLOAD_ID WHERE ROWNUM = 1' INTO v_enabled;

    EXCEPTION WHEN NO_DATA_FOUND THEN
        
        v_enabled := 'N';
    END;

    /* Flush the prior payload type's key_hash values */
    DELETE FROM ics_key_hash;
    
    IF v_enabled = 'Y' THEN
      BEGIN
          /* Load next key_hash set for current payload type */ 
          v_sql_statement := 'INSERT INTO ics_key_hash SELECT key_hash FROM ' || payload_type.table_name; 
          EXECUTE IMMEDIATE v_sql_statement;
      END;
      
      /* 
       *  Loop through each key in a payload type's key set.  For each key traverse the payload type's data heirarchy
       *  and load the child data_hash values into working table ICS_DATA_HASH for later processing at the end of 
       *  the loop.
       */
      <<key_loop>>
      FOR key_hash IN (SELECT ics_key_hash.key_hash FROM ics_key_hash) LOOP
      
        v_working_data_hash := null;


        IF payload_type.table_name = 'ICS_BASIC_PRMT' AND v_enabled = 'Y' THEN
           --BEGIN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_BASIC_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt child
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_ASSC_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_assc_prmt child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_CMPL_TRACK_STAT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_cmpl_track_stat child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_EFFLU_GUIDE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_efflu_guide child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_FAC_CLASS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_fac_class child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_GEO_COORD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_geo_coord child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_ORIG_PROGS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_orig_progs child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_PLCY
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_plcy child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_FAC/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_NPDES_DAT_GRP_NUM (5.8)
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_basic_prmt
                        JOIN ics_npdes_dat_grp_num child
                          ON child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                      UNION ALL                    
                    -- /ICS_BASIC_PRMT/ICS_OTHR_PRMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_othr_prmts child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_ICS_REP_NON_CMPL_STAT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ICS_REP_NON_CMPL_STAT child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
                    UNION ALL
                    -- /ICS_BASIC_PRMT/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_basic_prmt
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;

          -- 2016-05-17 CRT: To match old one, hash again
          v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
          
          
            UPDATE ICS_FLOW_LOCAL.ics_basic_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_BS_ANNUL_PROG_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                      -- \ICS_BS_ANNUL_PROG_REP
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_bs_annul_prog_rep child
                       UNION ALL
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_REP_OBLGTN_TYPE
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_bs_annul_prog_rep
                        JOIN ics_rep_oblgtn_type child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id      
                       UNION ALL  
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_ANLYTCL_METHOD
                      SELECT key_hash
                           , child.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_ANLYTCL_METHOD child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES
                      SELECT key_hash
                           , child.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES child
                          ON child.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
                      UNION ALL                       
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_ADDR
                      SELECT key_hash
                           , ICS_ADDR.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ics_addr
                          ON ics_addr.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_ADDR\ICS_TELEPH
                      SELECT key_hash
                           , ICS_BS_MGMT_PRACTICES.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ics_addr
                          ON ics_addr.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                        JOIN ics_teleph child
                          ON child.ics_addr_id = ics_addr.ics_addr_id
                      UNION ALL                         
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_MGMT_PRC_DEFCY_TYPE
                      SELECT key_hash
                           , ICS_MGMT_PRC_DEFCY_TYPE.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ICS_MGMT_PRC_DEFCY_TYPE
                          ON ICS_MGMT_PRC_DEFCY_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_CONTACT
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL  
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_CONTACT\ICS_TELEPH
                     SELECT key_hash
                           , child.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                        JOIN ics_teleph child
                          ON child.ICS_CONTACT_id = ICS_CONTACT.ICS_CONTACT_ID
                      UNION ALL
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_VECTOR_A_REDUCTION_TYPE
                      SELECT key_hash
                           , ICS_VECTOR_A_REDUCTION_TYPE.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ICS_VECTOR_A_REDUCTION_TYPE
                          ON ICS_VECTOR_A_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_BS_MGMT_PRACTICES\ICS_PATHOGEN_REDUCTION_TYPE
                      SELECT key_hash
                           , ICS_PATHOGEN_REDUCTION_TYPE.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_BS_MGMT_PRACTICES
                          ON ICS_BS_MGMT_PRACTICES.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                        JOIN ICS_PATHOGEN_REDUCTION_TYPE
                          ON ICS_PATHOGEN_REDUCTION_TYPE.ICS_BS_MGMT_PRACTICES_ID = ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID
                      UNION ALL                        
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_CONTACT
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID
                      UNION ALL                      
                      -- \ICS_BS_ANNUL_PROG_REP\ICS_TRTMNT_PRCSS_TYPE
                      SELECT key_hash
                           , ICS_CONTACT.data_hash
                        FROM ICS_BS_ANNUL_PROG_REP
                        JOIN ICS_CONTACT
                          ON ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID = ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID                               

            ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
          -- 2016-05-17 CRT: To match old one, hash again
          v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
          
            UPDATE ICS_BS_ANNUL_PROG_REP
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;                                
        
        IF payload_type.table_name = 'ICS_BS_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_BS_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt child
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_BS_END_USE_DSPL_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_bs_end_use_dspl_type child
                        ON  child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_BS_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_bs_type child
                        ON  child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                    UNION ALL
                    -- /ICS_BS_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_bs_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
          -- 2016-05-17 CRT: To match old one, hash again
          v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
          
            UPDATE ICS_FLOW_LOCAL.ics_bs_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CAFO_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CAFO_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt child
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_ANML_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_anml_type child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_CONTAINMENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_containment child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_LAND_APPL_BMP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_land_appl_bmp child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
                    UNION ALL
                    -- /ICS_CAFO_PRMT/ICS_MNUR_LTTR_PRCSS_WW_STOR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_prmt
                      JOIN ics_flow_local.ics_mnur_lttr_prcss_ww_stor child
                        ON  child.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
          -- 2016-05-17 CRT: To match old one, hash again
          v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
          
            UPDATE ICS_FLOW_LOCAL.ics_cafo_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CSO_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CSO_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cso_prmt child
                    UNION ALL
                    -- /ICS_CSO_PRMT/ICS_SATL_COLL_SYSTM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cso_prmt
                      JOIN ics_flow_local.ics_satl_coll_systm child
                        ON  child.ics_cso_prmt_id = ics_cso_prmt.ics_cso_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
          -- 2016-05-17 CRT: To match old one, hash again
          v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
          
            UPDATE ICS_FLOW_LOCAL.ics_cso_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_GNRL_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_GNRL_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt child
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_ASSC_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_assc_prmt child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_CMPL_TRACK_STAT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_cmpl_track_stat child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_EFFLU_GUIDE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_efflu_guide child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_fac_id = ics_fac.ics_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_fac_id = ics_fac.ics_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_FAC_CLASS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_fac_class child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_GEO_COORD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_geo_coord child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_ORIG_PROGS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_orig_progs child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_PLCY
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_plcy child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_FAC/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_fac
                        ON ics_fac.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_fac_id = ics_fac.ics_fac_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                      -- /ICS_GNRL_PRMT/ICS_NPDES_DAT_GRP_NUM
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_gnrl_prmt
                        JOIN ICS_NPDES_DAT_GRP_NUM child
                          ON child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                      UNION ALL                    
                    -- /ICS_GNRL_PRMT/ICS_OTHR_PRMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_othr_prmts child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_REP_NON_CMPL_STAT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ICS_REP_NON_CMPL_STAT child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id                 
                    UNION ALL
                    -- /ICS_GNRL_PRMT/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_gnrl_prmt
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_gnrl_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_MASTER_GNRL_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_MASTER_GNRL_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt child
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_ASSC_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_assc_prmt child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_OTHR_PRMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_othr_prmts child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_PRMT_COMP_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_prmt_comp_type child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
                    UNION ALL
                    -- /ICS_MASTER_GNRL_PRMT/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_master_gnrl_prmt
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_master_gnrl_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_POTW_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_POTW_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_potw_prmt child
                    UNION ALL
                    -- /ICS_POTW_PRMT/ICS_SATL_COLL_SYSTM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_potw_prmt
                      JOIN ics_flow_local.ics_satl_coll_systm child
                        ON  child.ics_potw_prmt_id = ics_potw_prmt.ics_potw_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_potw_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_PRETR_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_PRETR_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_prmt child
                    UNION ALL
                    -- /ICS_PRETR_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
                    UNION ALL
                    -- /ICS_PRETR_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_pretr_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SW_CNST_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SW_CNST_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt child
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                      -- /ICS_SW_CNST_PRMT/ICS_CNST_SITE
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_sw_cnst_prmt
                        JOIN ics_cnst_site child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id                      
                      UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_intent child
                        ON  child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_intent
                        ON ics_gpcf_notice_of_intent.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
                      JOIN ics_flow_local.ics_subsctor_code_plus_desc child
                        ON  child.ics_gpcf_notice_of_intent_id = ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id
                    UNION ALL
                    -- /ICS_SW_CNST_PRMT/ICS_GPCF_NOTICE_OF_TERM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_cnst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_term child
                        ON  child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id 
                      UNION ALL 
                      -- /ICS_SW_CNST_PRMT/ICS_TRTMNT_CHEMS_LIST
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_sw_cnst_prmt
                        JOIN ics_trtmnt_chems_list child
                          ON child.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id 
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_sw_cnst_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SW_INDST_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SW_INDST_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt child
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_GPCF_NO_EXPOSURE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_gpcf_no_exposure child
                        ON  child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_intent child
                        ON  child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_INTENT/ICS_SUBSCTOR_CODE_PLUS_DESC
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_intent
                        ON ics_gpcf_notice_of_intent.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
                      JOIN ics_flow_local.ics_subsctor_code_plus_desc child
                        ON  child.ics_gpcf_notice_of_intent_id = ics_gpcf_notice_of_intent.ics_gpcf_notice_of_intent_id
                    UNION ALL
                    -- /ICS_SW_INDST_PRMT/ICS_GPCF_NOTICE_OF_TERM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_indst_prmt
                      JOIN ics_flow_local.ics_gpcf_notice_of_term child
                        ON  child.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_sw_indst_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SWMS_4_LARGE_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SWMS_4_LARGE_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_large_prmt child
                    UNION ALL
                    -- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_large_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                    UNION ALL
                    -- /ICS_SWMS_4_LARGE_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_large_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_large_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                    UNION ALL
                    -- /ICS_SWMS_4_LARGE_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_large_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_swms_4_large_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SWMS_4_SMALL_PRMT' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SWMS_4_SMALL_PRMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt child
                    UNION ALL
                    -- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                    UNION ALL
                    -- /ICS_SWMS_4_SMALL_PRMT/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                    UNION ALL
                    -- /ICS_SWMS_4_SMALL_PRMT/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_SWMS_4_SMALL_PRMT/ICS_GPCF_CNST_WAIVER
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_small_prmt
                      JOIN ics_flow_local.ics_gpcf_cnst_waiver child
                        ON  child.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_swms_4_small_prmt
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_UNPRMT_FAC' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_UNPRMT_FAC
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac child
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_FAC_CLASS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_fac_class child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_GEO_COORD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_geo_coord child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_NAICS_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_naics_code child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_ORIG_PROGS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_orig_progs child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_PLCY
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_plcy child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_PRMT_COMP_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ICS_PRMT_COMP_TYPE child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id                      
                    UNION ALL
                    -- /ICS_UNPRMT_FAC/ICS_SIC_CODE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_unprmt_fac
                      JOIN ics_flow_local.ics_sic_code child
                        ON  child.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_unprmt_fac
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;


        IF payload_type.table_name = 'ICS_NARR_COND_SCHD' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_NARR_COND_SCHD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_narr_cond_schd child
                    UNION ALL
                    -- /ICS_NARR_COND_SCHD/ICS_PRMT_SCHD_EVT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_narr_cond_schd
                      JOIN ics_flow_local.ics_prmt_schd_evt child
                        ON  child.ics_narr_cond_schd_id = ics_narr_cond_schd.ics_narr_cond_schd_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_narr_cond_schd
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_PRMT_FEATR' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_PRMT_FEATR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr child
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_GEO_COORD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_geo_coord child
                        ON  child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_CHAR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_prmt_featr_char child
                        ON  child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                    UNION ALL
                    -- /ICS_PRMT_FEATR/ICS_PRMT_FEATR_TRTMNT_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_prmt_featr
                      JOIN ics_flow_local.ics_prmt_featr_trtmnt_type child
                        ON  child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                      UNION ALL 
                      -- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_prmt_featr
                        JOIN ics_impaired_wtr_pollutants child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id 
                      UNION ALL 
                      -- /ICS_PRMT_FEATR/ICS_TMDL_POLLUTANTS
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_prmt_featr
                        JOIN ICS_TMDL_POLLUTANTS child
                          ON child.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id 
                      UNION ALL                       
                      -- /ICS_PRMT_FEATR/ICS_IMPAIRED_WTR_POLLUTANTS/ICS_TMDL_POLUT
                      SELECT key_hash
                           , child.data_hash
                        FROM ics_prmt_featr
                        JOIN ICS_TMDL_POLLUTANTS 
                          ON ICS_TMDL_POLLUTANTS.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id
                        JOIN ICS_TMDL_POLUT child 
                          ON child.ICS_TMDL_POLLUTANTS_ID = ICS_TMDL_POLLUTANTS.ICS_TMDL_POLLUTANTS_ID
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_prmt_featr
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_LMT_SET' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_LMT_SET
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmt_set child
                    UNION ALL
                    -- /ICS_LMT_SET/ICS_LMT_SET_MONTHS_APPL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmt_set
                      JOIN ics_flow_local.ics_lmt_set_months_appl child
                        ON  child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
                    UNION ALL
                    -- /ICS_LMT_SET/ICS_LMT_SET_SCHD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmt_set
                      JOIN ics_flow_local.ics_lmt_set_schd child
                        ON  child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
                    UNION ALL
                    -- /ICS_LMT_SET/ICS_LMT_SET_STAT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmt_set
                      JOIN ics_flow_local.ics_lmt_set_stat child
                        ON  child.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_lmt_set
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_LMTS' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_LMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmts child
                    UNION ALL
                    -- /ICS_LMTS/ICS_MN_LMT_APPLIES
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmts
                      JOIN ics_flow_local.ics_mn_lmt_applies child
                        ON  child.ics_lmts_id = ics_lmts.ics_lmts_id
                    UNION ALL
                    -- /ICS_LMTS/ICS_NUM_COND
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_lmts
                      JOIN ics_flow_local.ics_num_cond child
                        ON  child.ics_lmts_id = ics_lmts.ics_lmts_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_lmts
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_PARAM_LMTS' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_PARAM_LMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_param_lmts child
                    UNION ALL
                    -- /ICS_PARAM_LMTS/ICS_LMT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_param_lmts
                      JOIN ics_flow_local.ics_lmt child
                        ON  child.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                    UNION ALL
                    -- /ICS_PARAM_LMTS/ICS_LMT/ICS_MN_LMT_APPLIES
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_param_lmts
                      JOIN ics_flow_local.ics_lmt
                        ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                      JOIN ics_flow_local.ics_mn_lmt_applies child
                        ON  child.ics_lmt_id = ics_lmt.ics_lmt_id
                    UNION ALL
                    -- /ICS_PARAM_LMTS/ICS_LMT/ICS_NUM_COND
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_param_lmts
                      JOIN ics_flow_local.ics_lmt
                        ON ics_lmt.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id
                      JOIN ics_flow_local.ics_num_cond child
                        ON  child.ics_lmt_id = ics_lmt.ics_lmt_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_param_lmts
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_DSCH_MON_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_DSCH_MON_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep child
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_CO_DSPL_SITE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_co_dspl_site child
                        ON  child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_INCIN
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_incin child
                        ON  child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_land_appl_site child
                        ON  child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_HARVESTED
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_land_appl_site
                        ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      JOIN ics_flow_local.ics_crop_types_harvested child
                        ON  child.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_LAND_APPL_SITE/ICS_CROP_TYPES_PLANTED
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_land_appl_site
                        ON ics_land_appl_site.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      JOIN ics_flow_local.ics_crop_types_planted child
                        ON  child.ics_land_appl_site_id = ics_land_appl_site.ics_land_appl_site_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_REP_PARAM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_rep_param child
                        ON  child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_REP_PARAM/ICS_NUM_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_rep_param
                        ON ics_rep_param.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
                      JOIN ics_flow_local.ics_num_rep child
                        ON  child.ics_rep_param_id = ics_rep_param.ics_rep_param_id
                    UNION ALL
                    -- /ICS_DSCH_MON_REP/ICS_SURF_DSPL_SITE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dsch_mon_rep
                      JOIN ics_flow_local.ics_surf_dspl_site child
                        ON  child.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_dsch_mon_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CMPL_MON' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CMPL_MON
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon child
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_ANML_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp
                        ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_anml_type child
                        ON  child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CAFO_INSP_VIOL_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp
                        ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_cafo_insp_viol_type child
                        ON  child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_CONTAINMENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp
                        ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_containment child
                        ON  child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_LAND_APPL_BMP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp
                        ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_land_appl_bmp child
                        ON  child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CAFO_INSP/ICS_MNUR_LTTR_PRCSS_WW_STOR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cafo_insp
                        ON ics_cafo_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_mnur_lttr_prcss_ww_stor child
                        ON  child.ics_cafo_insp_id = ics_cafo_insp.ics_cafo_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CMPL_INSP_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cmpl_insp_type child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CMPL_MON_ACTN_REASON
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cmpl_mon_actn_reason child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CMPL_MON_AGNCY_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cmpl_mon_agncy_type child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_CSO_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_cso_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_NAT_PRIO
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_nat_prio child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PRETR_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_pretr_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_pretr_insp
                        ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_loc_lmts child
                        ON  child.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_pretr_insp
                        ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_loc_lmts
                        ON ics_loc_lmts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                      JOIN ics_flow_local.ics_loc_lmts_polut child
                        ON  child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_pretr_insp
                        ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_rmvl_crdts child
                        ON  child.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PRETR_INSP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_pretr_insp
                        ON ics_pretr_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_rmvl_crdts
                        ON ics_rmvl_crdts.ics_pretr_insp_id = ics_pretr_insp.ics_pretr_insp_id
                      JOIN ics_flow_local.ics_rmvl_crdts_polut child
                        ON  child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PROG
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_prog child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_PROG_DEFCY_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ICS_PROG_DEFCY_TYPE child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id                      
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SSO_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sso_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_IMPACT_SSO_EVT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sso_insp
                        ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_impact_sso_evt child
                        ON  child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_STPS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sso_insp
                        ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sso_stps child
                        ON  child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SSO_INSP/ICS_SSO_SYSTM_COMP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sso_insp
                        ON ics_sso_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sso_systm_comp child
                        ON  child.ics_sso_insp_id = ics_sso_insp.ics_sso_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_CNST_INDST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_insp
                        ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_cnst_indst_insp child
                        ON  child.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_insp
                        ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp child
                        ON  child.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_insp
                        ON ics_sw_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp
                        ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_insp_id = ics_sw_cnst_insp.ics_sw_cnst_insp_id
                      JOIN ics_flow_local.ics_proj_type child
                        ON  child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_non_cnst_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_non_cnst_insp
                        ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_cnst_indst_insp child
                        ON  child.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_non_cnst_insp
                        ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp child
                        ON  child.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_CNST_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_cnst_non_cnst_insp
                        ON ics_sw_cnst_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp
                        ON ics_sw_unprmt_cnst_insp.ics_sw_cnst_non_cnst_insp_id = ics_sw_cnst_non_cnst_insp.ics_sw_cnst_non_cnst_insp_id
                      JOIN ics_flow_local.ics_proj_type child
                        ON  child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_MS_4_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_ms_4_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_MS_4_INSP/ICS_PROJ_SRCS_FUND
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_ms_4_insp
                        ON ics_sw_ms_4_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_proj_srcs_fund child
                        ON  child.ics_sw_ms_4_insp_id = ics_sw_ms_4_insp.ics_sw_ms_4_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_non_cnst_insp child
                        ON  child.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_CNST_INDST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_non_cnst_insp
                        ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_cnst_indst_insp child
                        ON  child.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_non_cnst_insp
                        ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp child
                        ON  child.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                    UNION ALL
                    -- /ICS_CMPL_MON/ICS_SW_NON_CNST_INSP/ICS_SW_UNPRMT_CNST_INSP/ICS_PROJ_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon
                      JOIN ics_flow_local.ics_sw_non_cnst_insp
                        ON ics_sw_non_cnst_insp.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id
                      JOIN ics_flow_local.ics_sw_unprmt_cnst_insp
                        ON ics_sw_unprmt_cnst_insp.ics_sw_non_cnst_insp_id = ics_sw_non_cnst_insp.ics_sw_non_cnst_insp_id
                      JOIN ics_flow_local.ics_proj_type child
                        ON  child.ics_sw_unprmt_cnst_insp_id = ics_sw_unprmt_cnst_insp.ics_sw_unprmt_cnst_insp_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_cmpl_mon
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_EFFLU_TRADE_PRTNER' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_EFFLU_TRADE_PRTNER
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_efflu_trade_prtner child
                    UNION ALL
                    -- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_efflu_trade_prtner
                      JOIN ics_flow_local.ics_efflu_trade_prtner_addr child
                        ON  child.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
                    UNION ALL
                    -- /ICS_EFFLU_TRADE_PRTNER/ICS_EFFLU_TRADE_PRTNER_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_efflu_trade_prtner
                      JOIN ics_flow_local.ics_efflu_trade_prtner_addr
                        ON ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_efflu_trade_prtner_addr_id = ics_efflu_trade_prtner_addr.ics_efflu_trade_prtner_addr_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_efflu_trade_prtner
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_FRML_ENFRC_ACTN' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_FRML_ENFRC_ACTN
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn child
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_enfrc_actn_gov_contact child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_ACTN_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_enfrc_actn_type child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_enfrc_agncy child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_final_order child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_FINAL_ORDER_PRMT_IDENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_final_order
                        ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      JOIN ics_flow_local.ics_final_order_prmt_ident child
                        ON  child.ics_final_order_id = ics_final_order.ics_final_order_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_FINAL_ORDER/ICS_SEP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_final_order
                        ON ics_final_order.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                      JOIN ics_flow_local.ICS_SEP child
                        ON  child.ics_final_order_id = ics_final_order.ics_final_order_id                      
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_PRMT_IDENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_prmt_ident child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_FRML_ENFRC_ACTN/ICS_PROGS_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_frml_enfrc_actn
                      JOIN ics_flow_local.ics_progs_viol child
                        ON  child.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_frml_enfrc_actn
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_INFRML_ENFRC_ACTN' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_INFRML_ENFRC_ACTN
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_infrml_enfrc_actn child
                    UNION ALL
                    -- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_ACTN_GOV_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_infrml_enfrc_actn
                      JOIN ics_flow_local.ics_enfrc_actn_gov_contact child
                        ON  child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_INFRML_ENFRC_ACTN/ICS_ENFRC_AGNCY
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_infrml_enfrc_actn
                      JOIN ics_flow_local.ics_enfrc_agncy child
                        ON  child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_INFRML_ENFRC_ACTN/ICS_PRMT_IDENT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_infrml_enfrc_actn
                      JOIN ics_flow_local.ics_prmt_ident child
                        ON  child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
                    UNION ALL
                    -- /ICS_INFRML_ENFRC_ACTN/ICS_PROGS_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_infrml_enfrc_actn
                      JOIN ics_flow_local.ics_progs_viol child
                        ON  child.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_infrml_enfrc_actn
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CMPL_SCHD' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CMPL_SCHD
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_schd child
                    UNION ALL
                    -- /ICS_CMPL_SCHD/ICS_CMPL_SCHD_EVT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_schd
                      JOIN ics_flow_local.ics_cmpl_schd_evt child
                        ON  child.ics_cmpl_schd_id = ics_cmpl_schd.ics_cmpl_schd_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_cmpl_schd
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;


        IF payload_type.table_name = 'ICS_SW_EVT_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SW_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_evt_rep child
                    UNION ALL
                    -- /ICS_SW_EVT_REP/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_evt_rep
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                    UNION ALL
                    -- /ICS_SW_EVT_REP/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_evt_rep
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SW_EVT_REP/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_evt_rep
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                    UNION ALL
                    -- /ICS_SW_EVT_REP/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sw_evt_rep
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_sw_evt_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CAFO_ANNUL_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CAFO_ANNUL_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_annul_rep child
                    UNION ALL
                    -- /ICS_CAFO_ANNUL_REP/ICS_REP_ANML_TYPE
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cafo_annul_rep
                      JOIN ics_flow_local.ics_rep_anml_type child
                        ON  child.ics_cafo_annul_rep_id = ics_cafo_annul_rep.ics_cafo_annul_rep_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_cafo_annul_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_LOC_LMTS_PROG_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_LOC_LMTS_PROG_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_loc_lmts_prog_rep child
                    UNION ALL
                    -- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_loc_lmts_prog_rep
                      JOIN ics_flow_local.ics_loc_lmts child
                        ON  child.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                    UNION ALL
                    -- /ICS_LOC_LMTS_PROG_REP/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_loc_lmts_prog_rep
                      JOIN ics_flow_local.ics_loc_lmts
                        ON ics_loc_lmts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                      JOIN ics_flow_local.ics_loc_lmts_polut child
                        ON  child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                    UNION ALL
                    -- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_loc_lmts_prog_rep
                      JOIN ics_flow_local.ics_rmvl_crdts child
                        ON  child.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                    UNION ALL
                    -- /ICS_LOC_LMTS_PROG_REP/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_loc_lmts_prog_rep
                      JOIN ics_flow_local.ics_rmvl_crdts
                        ON ics_rmvl_crdts.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
                      JOIN ics_flow_local.ics_rmvl_crdts_polut child
                        ON  child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_loc_lmts_prog_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_PRETR_PERF_SUMM' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_PRETR_PERF_SUMM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_perf_summ child
                    UNION ALL
                    -- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_perf_summ
                      JOIN ics_flow_local.ics_loc_lmts child
                        ON  child.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                    UNION ALL
                    -- /ICS_PRETR_PERF_SUMM/ICS_LOC_LMTS/ICS_LOC_LMTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_perf_summ
                      JOIN ics_flow_local.ics_loc_lmts
                        ON ics_loc_lmts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                      JOIN ics_flow_local.ics_loc_lmts_polut child
                        ON  child.ics_loc_lmts_id = ics_loc_lmts.ics_loc_lmts_id
                    UNION ALL
                    -- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_perf_summ
                      JOIN ics_flow_local.ics_rmvl_crdts child
                        ON  child.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                    UNION ALL
                    -- /ICS_PRETR_PERF_SUMM/ICS_RMVL_CRDTS/ICS_RMVL_CRDTS_POLUT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_pretr_perf_summ
                      JOIN ics_flow_local.ics_rmvl_crdts
                        ON ics_rmvl_crdts.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id
                      JOIN ics_flow_local.ics_rmvl_crdts_polut child
                        ON  child.ics_rmvl_crdts_id = ics_rmvl_crdts.ics_rmvl_crdts_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_pretr_perf_summ
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SSO_EVT_REP' AND v_enabled = 'Y' THEN
           --BEGIN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SSO_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sso_evt_rep child
                    UNION ALL
                    -- /ICS_SSO_EVT_REP/ICS_IMPACT_SSO_EVT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sso_evt_rep
                      JOIN ics_flow_local.ics_impact_sso_evt child
                        ON  child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
                    UNION ALL
                    -- /ICS_SSO_EVT_REP/ICS_SSO_STPS
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sso_evt_rep
                      JOIN ics_flow_local.ics_sso_stps child
                        ON  child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
                    UNION ALL
                    -- /ICS_SSO_EVT_REP/ICS_SSO_SYSTM_COMP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_sso_evt_rep
                      JOIN ics_flow_local.ics_sso_systm_comp child
                        ON  child.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_sso_evt_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SWMS_4_PROG_REP' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SWMS_4_PROG_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep child
                    UNION ALL
                    -- /ICS_SWMS_4_PROG_REP/ICS_ADDR
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep
                      JOIN ics_flow_local.ics_addr child
                        ON  child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                    UNION ALL
                    -- /ICS_SWMS_4_PROG_REP/ICS_ADDR/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep
                      JOIN ics_flow_local.ics_addr
                        ON ics_addr.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_addr_id = ics_addr.ics_addr_id
                    UNION ALL
                    -- /ICS_SWMS_4_PROG_REP/ICS_CONTACT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep
                      JOIN ics_flow_local.ics_contact child
                        ON  child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                    UNION ALL
                    -- /ICS_SWMS_4_PROG_REP/ICS_CONTACT/ICS_TELEPH
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep
                      JOIN ics_flow_local.ics_contact
                        ON ics_contact.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
                      JOIN ics_flow_local.ics_teleph child
                        ON  child.ics_contact_id = ics_contact.ics_contact_id
                    UNION ALL
                    -- /ICS_SWMS_4_PROG_REP/ICS_PROJ_SRCS_FUND
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_swms_4_prog_rep
                      JOIN ics_flow_local.ics_proj_srcs_fund child
                        ON  child.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_swms_4_prog_rep
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_CMPL_MON_LNK' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_CMPL_MON_LNK
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk child
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_BS_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_bs_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_CAFO_ANNUL_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_cafo_annul_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_CSO_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_cso_evt_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_ENFRC_ACTN
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_enfrc_actn child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_FEDR_CMPL_MON
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_fedr_cmpl_mon child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_LOC_LMTS_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_loc_lmts_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_PRETR_PERF_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_pretr_perf_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SNGL_EVT
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_sngl_evt child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_ANNUL_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_sso_annul_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_sso_evt_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SSO_MONTHLY_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_sso_monthly_evt_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_ST_CMPL_MON
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_st_cmpl_mon child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SW_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_sw_evt_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
                    UNION ALL
                    -- /ICS_CMPL_MON_LNK/ICS_LNK_SWMS_4_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_cmpl_mon_lnk
                      JOIN ics_flow_local.ics_lnk_swms_4_rep child
                        ON  child.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_cmpl_mon_lnk
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_ENFRC_ACTN_VIOL_LNK' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_ENFRC_ACTN_VIOL_LNK
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk child
                    UNION ALL
                    -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_CMPL_SCHD_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk
                      JOIN ics_flow_local.ics_cmpl_schd_viol child
                        ON  child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                    UNION ALL
                    -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk
                      JOIN ics_flow_local.ics_dsch_mon_rep_param_viol child
                        ON  child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                    UNION ALL
                    -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk
                      JOIN ics_flow_local.ics_dsch_mon_rep_viol child
                        ON  child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                    UNION ALL
                    -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_PRMT_SCHD_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk
                      JOIN ics_flow_local.ics_prmt_schd_viol child
                        ON  child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
                    UNION ALL
                    -- /ICS_ENFRC_ACTN_VIOL_LNK/ICS_SNGL_EVTS_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_enfrc_actn_viol_lnk
                      JOIN ics_flow_local.ics_sngl_evts_viol child
                        ON  child.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_enfrc_actn_viol_lnk
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_SCHD_EVT_VIOL' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_SCHD_EVT_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_schd_evt_viol child
                    UNION ALL
                    -- /ICS_SCHD_EVT_VIOL/ICS_CMPL_SCHD_EVT_VIOL_ELEM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_schd_evt_viol
                      JOIN ics_flow_local.ics_cmpl_schd_evt_viol_elem child
                        ON  child.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
                    UNION ALL
                    -- /ICS_SCHD_EVT_VIOL/ICS_PRMT_SCHD_EVT_VIOL_ELEM
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_schd_evt_viol
                      JOIN ics_flow_local.ics_prmt_schd_evt_viol_elem child
                        ON  child.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_schd_evt_viol
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_DMR_PROG_REP_LNK' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_DMR_PROG_REP_LNK
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dmr_prog_rep_lnk child
                    UNION ALL
                    -- /ICS_DMR_PROG_REP_LNK/ICS_LNK_BS_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dmr_prog_rep_lnk
                      JOIN ics_flow_local.ics_lnk_bs_rep child
                        ON  child.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
                    UNION ALL
                    -- /ICS_DMR_PROG_REP_LNK/ICS_LNK_SW_EVT_REP
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_dmr_prog_rep_lnk
                      JOIN ics_flow_local.ics_lnk_sw_evt_rep child
                        ON  child.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_dmr_prog_rep_lnk
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

        IF payload_type.table_name = 'ICS_FINAL_ORDER_VIOL_LNK' AND v_enabled = 'Y' THEN

           FOR data_hashes IN (SELECT here.key_hash, here.data_hash
                                 FROM (
                    -- /ICS_FINAL_ORDER_VIOL_LNK
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk child
                    UNION ALL
                    -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_CMPL_SCHD_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk
                      JOIN ics_flow_local.ics_cmpl_schd_viol child
                        ON  child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                    UNION ALL
                    -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_PARAM_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk
                      JOIN ics_flow_local.ics_dsch_mon_rep_param_viol child
                        ON  child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                    UNION ALL
                    -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_DSCH_MON_REP_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk
                      JOIN ics_flow_local.ics_dsch_mon_rep_viol child
                        ON  child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                    UNION ALL
                    -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_PRMT_SCHD_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk
                      JOIN ics_flow_local.ics_prmt_schd_viol child
                        ON  child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
                    UNION ALL
                    -- /ICS_FINAL_ORDER_VIOL_LNK/ICS_SNGL_EVTS_VIOL
                    SELECT key_hash
                         , child.data_hash
                      FROM ics_flow_local.ics_final_order_viol_lnk
                      JOIN ics_flow_local.ics_sngl_evts_viol child
                        ON  child.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
           ) here
           WHERE here.key_hash = key_hash.key_hash
           ORDER BY here.data_hash) LOOP

                --  Hash each data hash related to the current payload's key_hash
                v_working_data_hash := MD5_HASH(v_working_data_hash || data_hashes.data_hash);

          END LOOP;
          
             -- 2016-05-17 CRT: To match old one, hash again
             v_working_data_hash := NVL(MD5_HASH(v_working_data_hash),0);
             
            UPDATE ICS_FLOW_LOCAL.ics_final_order_viol_lnk
               SET data_hash = v_working_data_hash
             WHERE key_hash = key_hash.key_hash;
             
        END IF;

      END LOOP key_loop;    
    
    END IF;  --  Check if module is enabled
    
  END LOOP module_loop;
/* -=-=-=-=-=-=- END COPY TO INDICATED SECTION IN ICS_SET_HASHES -=-=-=-=-=-=-=-=-= */   
  /******************************************************************************************************************************
  ** Description:  The following code sets the new, change, replace, etc... ics transaction_type flags throughout the entire ICS 
  **               schema.  Once these flags are set the data will be marked as either new, changed and will allow the OPENNODE2 
  **               plug-in the ability to pull the data, bundle into .xml, and then submit to an exchange partner.
  ******************************************************************************************************************************/
-- ICS_BASIC_PRMT - Set New/Replace Transactions
  UPDATE ics_basic_prmt
     SET ics_basic_prmt.transaction_type = (SELECT CASE cdv_basic_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_basic_prmt
                                               WHERE cdv_basic_prmt.key_hash = ics_basic_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'BasicPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_BS_ANNUL_PROG_REP - Set New/Replace Transactions
  UPDATE ics_bs_annul_prog_rep
     SET transaction_type = (SELECT CASE cdv_bs_annul_prog_rep.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_bs_annul_prog_rep cdv_bs_annul_prog_rep
                                               WHERE cdv_bs_annul_prog_rep.key_hash = ics_bs_annul_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'BiosolidsAnnualProgramReportSubmission' AND enabled = 'Y') = 1);
                                                 
 
  -- ICS_BS_PRMT - Set New/Replace Transactions
  UPDATE ics_bs_prmt
     SET ics_bs_prmt.transaction_type = (SELECT CASE cdv_bs_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_bs_prmt
                                               WHERE cdv_bs_prmt.key_hash = ics_bs_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'BiosolidsPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CAFO_PRMT - Set New/Replace Transactions
  UPDATE ics_cafo_prmt
     SET ics_cafo_prmt.transaction_type = (SELECT CASE cdv_cafo_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cafo_prmt
                                               WHERE cdv_cafo_prmt.key_hash = ics_cafo_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'CAFOPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CSO_PRMT - Set New/Replace Transactions
  UPDATE ics_cso_prmt
     SET ics_cso_prmt.transaction_type = (SELECT CASE cdv_cso_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cso_prmt
                                               WHERE cdv_cso_prmt.key_hash = ics_cso_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'CSOPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_MON - Set New/Replace Transactions
  UPDATE ics_cmpl_mon
     SET ics_cmpl_mon.transaction_type = (SELECT CASE cdv_cmpl_mon.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cmpl_mon
                                               WHERE cdv_cmpl_mon.key_hash = ics_cmpl_mon.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'ComplianceMonitoringSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_GNRL_PRMT - Set New/Replace Transactions
  UPDATE ics_gnrl_prmt
     SET ics_gnrl_prmt.transaction_type = (SELECT CASE cdv_gnrl_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_gnrl_prmt
                                               WHERE cdv_gnrl_prmt.key_hash = ics_gnrl_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'GeneralPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_MASTER_GNRL_PRMT - Set New/Replace Transactions
  UPDATE ics_master_gnrl_prmt
     SET ics_master_gnrl_prmt.transaction_type = (SELECT CASE cdv_master_gnrl_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_master_gnrl_prmt
                                               WHERE cdv_master_gnrl_prmt.key_hash = ics_master_gnrl_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'MasterGeneralPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_REISSU - Set New/Replace Transactions
  UPDATE ics_prmt_reissu
     SET ics_prmt_reissu.transaction_type = (SELECT CASE cdv_prmt_reissu.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_prmt_reissu
                                               WHERE cdv_prmt_reissu.key_hash = ics_prmt_reissu.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PermitReissuanceSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_TERM - Set New/Replace Transactions
  UPDATE ics_prmt_term
     SET ics_prmt_term.transaction_type = (SELECT CASE cdv_prmt_term.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_prmt_term
                                               WHERE cdv_prmt_term.key_hash = ics_prmt_term.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PermitTerminationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_TRACK_EVT - Set New/Replace Transactions
  UPDATE ics_prmt_track_evt
     SET ics_prmt_track_evt.transaction_type = (SELECT CASE cdv_prmt_track_evt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_prmt_track_evt
                                               WHERE cdv_prmt_track_evt.key_hash = ics_prmt_track_evt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PermitTrackingEventSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_POTW_PRMT - Set New/Replace Transactions
  UPDATE ics_potw_prmt
     SET ics_potw_prmt.transaction_type = (SELECT CASE cdv_potw_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_potw_prmt
                                               WHERE cdv_potw_prmt.key_hash = ics_potw_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'POTWPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRETR_PRMT - Set New/Replace Transactions
  UPDATE ics_pretr_prmt
     SET ics_pretr_prmt.transaction_type = (SELECT CASE cdv_pretr_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_pretr_prmt
                                               WHERE cdv_pretr_prmt.key_hash = ics_pretr_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PretreatmentPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_CNST_PRMT - Set New/Replace Transactions
  UPDATE ics_sw_cnst_prmt
     SET ics_sw_cnst_prmt.transaction_type = (SELECT CASE cdv_sw_cnst_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sw_cnst_prmt
                                               WHERE cdv_sw_cnst_prmt.key_hash = ics_sw_cnst_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWConstructionPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_INDST_PRMT - Set New/Replace Transactions
  UPDATE ics_sw_indst_prmt
     SET ics_sw_indst_prmt.transaction_type = (SELECT CASE cdv_sw_indst_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sw_indst_prmt
                                               WHERE cdv_sw_indst_prmt.key_hash = ics_sw_indst_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWIndustrialPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SWMS_4_LARGE_PRMT - Set New/Replace Transactions
  UPDATE ics_swms_4_large_prmt
     SET ics_swms_4_large_prmt.transaction_type = (SELECT CASE cdv_swms_4_large_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_swms_4_large_prmt
                                               WHERE cdv_swms_4_large_prmt.key_hash = ics_swms_4_large_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWMS4LargePermitSubmission' AND enabled = 'Y') = 1);

  -- ICS_SWMS_4_SMALL_PRMT - Set New/Replace Transactions
  UPDATE ics_swms_4_small_prmt
     SET ics_swms_4_small_prmt.transaction_type = (SELECT CASE cdv_swms_4_small_prmt.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_swms_4_small_prmt
                                               WHERE cdv_swms_4_small_prmt.key_hash = ics_swms_4_small_prmt.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWMS4SmallPermitSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_UNPRMT_FAC - Set New/Replace Transactions
  UPDATE ics_unprmt_fac
     SET ics_unprmt_fac.transaction_type = (SELECT CASE cdv_unprmt_fac.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_unprmt_fac
                                               WHERE cdv_unprmt_fac.key_hash = ics_unprmt_fac.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'UnpermittedFacilitySubmission' AND enabled = 'Y') = 1);
  
  -- ICS_HIST_PRMT_SCHD_EVTS - Set New/Replace Transactions
  UPDATE ics_hist_prmt_schd_evts
     SET ics_hist_prmt_schd_evts.transaction_type = (SELECT CASE cdv_hist_prmt_schd_evts.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_hist_prmt_schd_evts
                                               WHERE cdv_hist_prmt_schd_evts.key_hash = ics_hist_prmt_schd_evts.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'HistoricalPermitScheduleEventsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_NARR_COND_SCHD - Set New/Replace Transactions
  UPDATE ics_narr_cond_schd
     SET ics_narr_cond_schd.transaction_type = (SELECT CASE cdv_narr_cond_schd.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_narr_cond_schd
                                               WHERE cdv_narr_cond_schd.key_hash = ics_narr_cond_schd.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'NarrativeConditionScheduleSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRMT_FEATR - Set New/Replace Transactions
  UPDATE ics_prmt_featr
     SET ics_prmt_featr.transaction_type = (SELECT CASE cdv_prmt_featr.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_prmt_featr
                                               WHERE cdv_prmt_featr.key_hash = ics_prmt_featr.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PermittedFeatureSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LMT_SET - Set New/Replace Transactions
  UPDATE ics_lmt_set
     SET ics_lmt_set.transaction_type = (SELECT CASE cdv_lmt_set.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_lmt_set
                                               WHERE cdv_lmt_set.key_hash = ics_lmt_set.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'LimitSetSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LMTS - Set New/Replace Transactions
  UPDATE ics_lmts
     SET ics_lmts.transaction_type = (SELECT CASE cdv_lmts.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_lmts
                                               WHERE cdv_lmts.key_hash = ics_lmts.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'LimitsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PARAM_LMTS - Set New/Replace Transactions
  UPDATE ics_param_lmts
     SET ics_param_lmts.transaction_type = (SELECT CASE cdv_param_lmts.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_param_lmts
                                               WHERE cdv_param_lmts.key_hash = ics_param_lmts.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'ParameterLimitsSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DSCH_MON_REP - Set New/Replace Transactions
  UPDATE ics_dsch_mon_rep
     SET ics_dsch_mon_rep.transaction_type = (SELECT CASE cdv_dsch_mon_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_dsch_mon_rep
                                               WHERE cdv_dsch_mon_rep.key_hash = ics_dsch_mon_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'DischargeMonitoringReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SNGL_EVT_VIOL - Set New/Replace Transactions
  UPDATE ics_sngl_evt_viol
     SET ics_sngl_evt_viol.transaction_type = (SELECT CASE cdv_sngl_evt_viol.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sngl_evt_viol
                                               WHERE cdv_sngl_evt_viol.key_hash = ics_sngl_evt_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SingleEventViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_SCHD - Set New/Replace Transactions
  UPDATE ics_cmpl_schd
     SET ics_cmpl_schd.transaction_type = (SELECT CASE cdv_cmpl_schd.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cmpl_schd
                                               WHERE cdv_cmpl_schd.key_hash = ics_cmpl_schd.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'ComplianceScheduleSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DMR_VIOL - Set New/Replace Transactions
  UPDATE ics_dmr_viol
     SET ics_dmr_viol.transaction_type = (SELECT CASE cdv_dmr_viol.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_dmr_viol
                                               WHERE cdv_dmr_viol.key_hash = ics_dmr_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'DMRViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_EFFLU_TRADE_PRTNER - Set New/Replace Transactions
  UPDATE ics_efflu_trade_prtner
     SET ics_efflu_trade_prtner.transaction_type = (SELECT CASE cdv_efflu_trade_prtner.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_efflu_trade_prtner
                                               WHERE cdv_efflu_trade_prtner.key_hash = ics_efflu_trade_prtner.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'EffluentTradePartnerSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_FRML_ENFRC_ACTN - Set New/Replace Transactions
  UPDATE ics_frml_enfrc_actn
     SET ics_frml_enfrc_actn.transaction_type = (SELECT CASE cdv_frml_enfrc_actn.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_frml_enfrc_actn
                                               WHERE cdv_frml_enfrc_actn.key_hash = ics_frml_enfrc_actn.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'FormalEnforcementActionSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_INFRML_ENFRC_ACTN - Set New/Replace Transactions
  UPDATE ics_infrml_enfrc_actn
     SET ics_infrml_enfrc_actn.transaction_type = (SELECT CASE cdv_infrml_enfrc_actn.action_code
                                                       WHEN 1 THEN 'N'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_infrml_enfrc_actn
                                               WHERE cdv_infrml_enfrc_actn.key_hash = ics_infrml_enfrc_actn.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'InformalEnforcementActionSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_ENFRC_ACTN_MILESTONE - Set New/Replace Transactions
  UPDATE ics_enfrc_actn_milestone
     SET ics_enfrc_actn_milestone.transaction_type = (SELECT CASE cdv_enfrc_actn_milestone.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_enfrc_actn_milestone
                                               WHERE cdv_enfrc_actn_milestone.key_hash = ics_enfrc_actn_milestone.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'EnforcementActionMilestoneSubmission' AND enabled = 'Y') = 1);
                                                 
  -- ICS_FINAL_ORDER_VIOL_LNK - Set New/Replace Transactions
  UPDATE ics_final_order_viol_lnk
     SET ics_final_order_viol_lnk.transaction_type = (SELECT CASE cdv_final_order_viol_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_final_order_viol_lnk
                                               WHERE cdv_final_order_viol_lnk.key_hash = ics_final_order_viol_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'FinalOrderViolationLinkageSubmission' AND enabled = 'Y') = 1);
                                              
  -- ICS_CSO_EVT_REP - Set New/Replace Transactions
  UPDATE ics_cso_evt_rep
     SET ics_cso_evt_rep.transaction_type = (SELECT CASE cdv_cso_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cso_evt_rep
                                               WHERE cdv_cso_evt_rep.key_hash = ics_cso_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'CSOEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SW_EVT_REP - Set New/Replace Transactions
  UPDATE ics_sw_evt_rep
     SET ics_sw_evt_rep.transaction_type = (SELECT CASE cdv_sw_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sw_evt_rep
                                               WHERE cdv_sw_evt_rep.key_hash = ics_sw_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CAFO_ANNUL_REP - Set New/Replace Transactions
  UPDATE ics_cafo_annul_rep
     SET ics_cafo_annul_rep.transaction_type = (SELECT CASE cdv_cafo_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cafo_annul_rep
                                               WHERE cdv_cafo_annul_rep.key_hash = ics_cafo_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'CAFOAnnualReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_LOC_LMTS_PROG_REP - Set New/Replace Transactions
  UPDATE ics_loc_lmts_prog_rep
     SET ics_loc_lmts_prog_rep.transaction_type = (SELECT CASE cdv_loc_lmts_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_loc_lmts_prog_rep
                                               WHERE cdv_loc_lmts_prog_rep.key_hash = ics_loc_lmts_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'LocalLimitsProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_PRETR_PERF_SUMM - Set New/Replace Transactions
  UPDATE ics_pretr_perf_summ
     SET ics_pretr_perf_summ.transaction_type = (SELECT CASE cdv_pretr_perf_summ.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_pretr_perf_summ
                                               WHERE cdv_pretr_perf_summ.key_hash = ics_pretr_perf_summ.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'PretreatmentPerformanceSummarySubmission' AND enabled = 'Y') = 1);
  
  -- ICS_BS_PROG_REP - Set New/Replace Transactions
  UPDATE ics_bs_prog_rep
     SET ics_bs_prog_rep.transaction_type = (SELECT CASE cdv_bs_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_bs_prog_rep
                                               WHERE cdv_bs_prog_rep.key_hash = ics_bs_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'BiosolidsProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_ANNUL_REP - Set New/Replace Transactions
  UPDATE ics_sso_annul_rep
     SET ics_sso_annul_rep.transaction_type = (SELECT CASE cdv_sso_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sso_annul_rep
                                               WHERE cdv_sso_annul_rep.key_hash = ics_sso_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SSOAnnualReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_EVT_REP - Set New/Replace Transactions
  UPDATE ics_sso_evt_rep
     SET ics_sso_evt_rep.transaction_type = (SELECT CASE cdv_sso_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sso_evt_rep
                                               WHERE cdv_sso_evt_rep.key_hash = ics_sso_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SSOEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SSO_MONTHLY_EVT_REP - Set New/Replace Transactions
  UPDATE ics_sso_monthly_evt_rep
     SET ics_sso_monthly_evt_rep.transaction_type = (SELECT CASE cdv_sso_monthly_evt_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sso_monthly_evt_rep
                                               WHERE cdv_sso_monthly_evt_rep.key_hash = ics_sso_monthly_evt_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SSOMonthlyEventReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SWMS_4_PROG_REP - Set New/Replace Transactions
  UPDATE ics_swms_4_prog_rep
     SET ics_swms_4_prog_rep.transaction_type = (SELECT CASE cdv_swms_4_prog_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_swms_4_prog_rep
                                               WHERE cdv_swms_4_prog_rep.key_hash = ics_swms_4_prog_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWMS4ProgramReportSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_SCHD_EVT_VIOL - Set New/Replace Transactions
  UPDATE ics_schd_evt_viol
     SET ics_schd_evt_viol.transaction_type = (SELECT CASE cdv_schd_evt_viol.action_code
                                                       WHEN 1 THEN 'C'
                                                       WHEN 2 THEN 'C'
                                                      END AS transaction_type
                                                FROM cdv_schd_evt_viol
                                               WHERE cdv_schd_evt_viol.key_hash = ics_schd_evt_viol.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'ScheduleEventViolationSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_CMPL_MON_LNK - Set New/Replace Transactions
  UPDATE ics_cmpl_mon_lnk
     SET ics_cmpl_mon_lnk.transaction_type = (SELECT CASE cdv_cmpl_mon_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_cmpl_mon_lnk
                                               WHERE cdv_cmpl_mon_lnk.key_hash = ics_cmpl_mon_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'ComplianceMonitoringLinkageSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_ENFRC_ACTN_VIOL_LNK - Set New/Replace Transactions
  UPDATE ics_enfrc_actn_viol_lnk
     SET ics_enfrc_actn_viol_lnk.transaction_type = (SELECT CASE cdv_enfrc_actn_viol_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_enfrc_actn_viol_lnk
                                               WHERE cdv_enfrc_actn_viol_lnk.key_hash = ics_enfrc_actn_viol_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'EnforcementActionViolationLinkageSubmission' AND enabled = 'Y') = 1);
  
  -- ICS_DMR_PROG_REP_LNK - Set New/Replace Transactions
  UPDATE ics_dmr_prog_rep_lnk
     SET ics_dmr_prog_rep_lnk.transaction_type = (SELECT CASE cdv_dmr_prog_rep_lnk.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_dmr_prog_rep_lnk
                                               WHERE cdv_dmr_prog_rep_lnk.key_hash = ics_dmr_prog_rep_lnk.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'DMRProgramReportLinkageSubmission' AND enabled = 'Y') = 1);
  
  
  -- ICS_SW_INDST_ANNUL_REP - Set New/Replace Transactions
  UPDATE ics_sw_indst_annul_rep
     SET ics_sw_indst_annul_rep.transaction_type = (SELECT CASE cdv_sw_indst_annul_rep.action_code
                                                       WHEN 1 THEN 'R'
                                                       WHEN 2 THEN 'R'
                                                      END AS transaction_type
                                                FROM cdv_sw_indst_annul_rep
                                               WHERE cdv_sw_indst_annul_rep.key_hash = ics_sw_indst_annul_rep.key_hash
                                                 AND (SELECT COUNT(1) FROM ics_payload WHERE operation = 'SWIndustrialAnnualReportSubmission' AND enabled = 'Y') = 1);
 
  
  -- ICS_BASIC_PRMT - Set Delete Transactions
  INSERT INTO ics_basic_prmt
       ( ics_payload_id
       , ics_basic_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_basic_prmt.ics_payload_id
        , SYS_GUID()
        , 'D' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_basic_prmt
    WHERE ics_basic_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'BasicPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_basic_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_basic_prmt
                                       WHERE cdv_basic_prmt.action_type = 'DELETE');
  
  -- ICS_BS_PRMT - Set Delete Transactions
  INSERT INTO ics_bs_prmt
       ( ics_payload_id
       , ics_bs_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_bs_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_bs_prmt
    WHERE ics_bs_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'BiosolidsPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_bs_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_bs_prmt
                                       WHERE cdv_bs_prmt.action_type = 'DELETE');
  
  -- ICS_CAFO_PRMT - Set Delete Transactions
  INSERT INTO ics_cafo_prmt
       ( ics_payload_id
       , ics_cafo_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_cafo_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cafo_prmt
    WHERE ics_cafo_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'CAFOPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cafo_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_cafo_prmt
                                       WHERE cdv_cafo_prmt.action_type = 'DELETE');
  
  -- ICS_CSO_PRMT - Set Delete Transactions
  INSERT INTO ics_cso_prmt
       ( ics_payload_id
       , ics_cso_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_cso_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cso_prmt
    WHERE ics_cso_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'CSOPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cso_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_cso_prmt
                                       WHERE cdv_cso_prmt.action_type = 'DELETE');
  
  -- ICS_CMPL_MON - Set Delete Transactions
  INSERT INTO ics_cmpl_mon
       ( ics_payload_id
       , ics_cmpl_mon_id
       , transaction_type
       , cmpl_mon_ident
       , key_hash
       , data_hash) 
   SELECT ics_cmpl_mon.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , cmpl_mon_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cmpl_mon
    WHERE ics_cmpl_mon.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'ComplianceMonitoringSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_cmpl_mon.key_hash IN (SELECT key_hash
                                        FROM cdv_cmpl_mon
                                       WHERE cdv_cmpl_mon.action_type = 'DELETE');
  
  -- ICS_GNRL_PRMT - Set Delete Transactions
  INSERT INTO ics_gnrl_prmt
       ( ics_payload_id
       , ics_gnrl_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_gnrl_prmt.ics_payload_id
        , SYS_GUID()
        , 'D' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_gnrl_prmt
    WHERE ics_gnrl_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'GeneralPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_gnrl_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_gnrl_prmt
                                       WHERE cdv_gnrl_prmt.action_type = 'DELETE');
  
  -- ICS_MASTER_GNRL_PRMT - Set Delete Transactions
  INSERT INTO ics_master_gnrl_prmt
       ( ics_payload_id
       , ics_master_gnrl_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_master_gnrl_prmt.ics_payload_id
        , SYS_GUID()
        , 'D' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_master_gnrl_prmt
    WHERE ics_master_gnrl_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'MasterGeneralPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_master_gnrl_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_master_gnrl_prmt
                                       WHERE cdv_master_gnrl_prmt.action_type = 'DELETE');
  
  -- ICS_PRMT_REISSU - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_PRMT_TERM - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_PRMT_TRACK_EVT - Set Delete Transactions
  INSERT INTO ics_prmt_track_evt
       ( ics_payload_id
       , ics_prmt_track_evt_id
       , transaction_type
       , prmt_ident, prmt_track_evt_code, prmt_track_evt_date
       , key_hash
       , data_hash) 
   SELECT ics_prmt_track_evt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_track_evt_code, prmt_track_evt_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_prmt_track_evt
    WHERE ics_prmt_track_evt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'PermitTrackingEventSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_prmt_track_evt.key_hash IN (SELECT key_hash
                                        FROM cdv_prmt_track_evt
                                       WHERE cdv_prmt_track_evt.action_type = 'DELETE');
  
  -- ICS_POTW_PRMT - Set Delete Transactions
  INSERT INTO ics_potw_prmt
       ( ics_payload_id
       , ics_potw_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_potw_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_potw_prmt
    WHERE ics_potw_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'POTWPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_potw_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_potw_prmt
                                       WHERE cdv_potw_prmt.action_type = 'DELETE');
  
  -- ICS_PRETR_PRMT - Set Delete Transactions
  INSERT INTO ics_pretr_prmt
       ( ics_payload_id
       , ics_pretr_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_pretr_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_pretr_prmt
    WHERE ics_pretr_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'PretreatmentPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_pretr_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_pretr_prmt
                                       WHERE cdv_pretr_prmt.action_type = 'DELETE');
  
  -- ICS_SW_CNST_PRMT - Set Delete Transactions
  INSERT INTO ics_sw_cnst_prmt
       ( ics_payload_id
       , ics_sw_cnst_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_sw_cnst_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sw_cnst_prmt
    WHERE ics_sw_cnst_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWConstructionPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_cnst_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_sw_cnst_prmt
                                       WHERE cdv_sw_cnst_prmt.action_type = 'DELETE');
  
  -- ICS_SW_INDST_PRMT - Set Delete Transactions
  INSERT INTO ics_sw_indst_prmt
       ( ics_payload_id
       , ics_sw_indst_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_sw_indst_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sw_indst_prmt
    WHERE ics_sw_indst_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWIndustrialPermitSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_sw_indst_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_sw_indst_prmt
                                       WHERE cdv_sw_indst_prmt.action_type = 'DELETE');
  
  -- ICS_SWMS_4_LARGE_PRMT - Set Delete Transactions
  INSERT INTO ics_swms_4_large_prmt
       ( ics_payload_id
       , ics_swms_4_large_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_swms_4_large_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_swms_4_large_prmt
    WHERE ics_swms_4_large_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWMS4LargePermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_large_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_swms_4_large_prmt
                                       WHERE cdv_swms_4_large_prmt.action_type = 'DELETE');
  
  -- ICS_SWMS_4_SMALL_PRMT - Set Delete Transactions
  INSERT INTO ics_swms_4_small_prmt
       ( ics_payload_id
       , ics_swms_4_small_prmt_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_swms_4_small_prmt.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_swms_4_small_prmt
    WHERE ics_swms_4_small_prmt.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWMS4SmallPermitSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_small_prmt.key_hash IN (SELECT key_hash
                                        FROM cdv_swms_4_small_prmt
                                       WHERE cdv_swms_4_small_prmt.action_type = 'DELETE');
  
  -- ICS_UNPRMT_FAC - Set Delete Transactions
  INSERT INTO ics_unprmt_fac
       ( ics_payload_id
       , ics_unprmt_fac_id
       , transaction_type
       , prmt_ident
       , key_hash
       , data_hash) 
   SELECT ics_unprmt_fac.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_unprmt_fac
    WHERE ics_unprmt_fac.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'UnpermittedFacilitySubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_unprmt_fac.key_hash IN (SELECT key_hash
                                        FROM cdv_unprmt_fac
                                       WHERE cdv_unprmt_fac.action_type = 'DELETE');
  
  -- ICS_HIST_PRMT_SCHD_EVTS - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_NARR_COND_SCHD - Set Delete Transactions
  INSERT INTO ics_narr_cond_schd
       ( ics_payload_id
       , ics_narr_cond_schd_id
       , transaction_type
       , prmt_ident, narr_cond_num
       , key_hash
       , data_hash) 
   SELECT ics_narr_cond_schd.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, narr_cond_num
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_narr_cond_schd
    WHERE ics_narr_cond_schd.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'NarrativeConditionScheduleSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_narr_cond_schd.key_hash IN (SELECT key_hash
                                        FROM cdv_narr_cond_schd
                                       WHERE cdv_narr_cond_schd.action_type = 'DELETE');
  
  -- ICS_PRMT_FEATR - Set Delete Transactions
  INSERT INTO ics_prmt_featr
       ( ics_payload_id
       , ics_prmt_featr_id
       , transaction_type
       , prmt_ident, prmt_featr_ident
       , key_hash
       , data_hash) 
   SELECT ics_prmt_featr.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_prmt_featr
    WHERE ics_prmt_featr.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'PermittedFeatureSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_prmt_featr.key_hash IN (SELECT key_hash
                                        FROM cdv_prmt_featr
                                       WHERE cdv_prmt_featr.action_type = 'DELETE');
  
  -- ICS_LMT_SET - Set Delete Transactions
  INSERT INTO ics_lmt_set
       ( ics_payload_id
       , ics_lmt_set_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, lmt_set_type
       , key_hash
       , data_hash) 
   SELECT ics_lmt_set.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, 'S'
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_lmt_set
    WHERE ics_lmt_set.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'LimitSetSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_lmt_set.key_hash IN (SELECT key_hash
                                        FROM cdv_lmt_set
                                       WHERE cdv_lmt_set.action_type = 'DELETE');
  
  -- ICS_LMTS - Set Delete Transactions
  INSERT INTO ics_lmts
       ( ics_payload_id
       , ics_lmts_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date
       , key_hash
       , data_hash) 
   SELECT ics_lmts.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_lmts
    WHERE ics_lmts.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'LimitsSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_lmts.key_hash IN (SELECT key_hash
                                        FROM cdv_lmts
                                       WHERE cdv_lmts.action_type = 'DELETE');
  
  -- ICS_PARAM_LMTS - Set Delete Transactions
  INSERT INTO ics_param_lmts
       ( ics_payload_id
       , ics_param_lmts_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num
       , key_hash
       , data_hash) 
   SELECT ics_param_lmts.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_param_lmts
    WHERE ics_param_lmts.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'ParameterLimitsSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_param_lmts.key_hash IN (SELECT key_hash
                                        FROM cdv_param_lmts
                                       WHERE cdv_param_lmts.action_type = 'DELETE');
  
  -- ICS_DSCH_MON_REP - Set Delete Transactions
  INSERT INTO ics_dsch_mon_rep
       ( ics_payload_id
       , ics_dsch_mon_rep_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, mon_period_end_date
       , key_hash
       , data_hash) 
   SELECT ics_dsch_mon_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, mon_period_end_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_dsch_mon_rep
    WHERE ics_dsch_mon_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'DischargeMonitoringReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_dsch_mon_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_dsch_mon_rep
                                       WHERE cdv_dsch_mon_rep.action_type = 'DELETE');
  
  -- ICS_SNGL_EVT_VIOL - Set Delete Transactions
  INSERT INTO ics_sngl_evt_viol
       ( ics_payload_id
       , ics_sngl_evt_viol_id
       , transaction_type
       , prmt_ident, sngl_evt_viol_code, sngl_evt_viol_date
       , key_hash
       , data_hash) 
   SELECT ics_sngl_evt_viol.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, sngl_evt_viol_code, sngl_evt_viol_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sngl_evt_viol
    WHERE ics_sngl_evt_viol.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SingleEventViolationSubmission'
                            AND auto_gen_deletes = 'Y'
                            AND enabled = 'Y')
      AND ics_sngl_evt_viol.key_hash IN (SELECT key_hash
                                        FROM cdv_sngl_evt_viol
                                       WHERE cdv_sngl_evt_viol.action_type = 'DELETE');
  
  -- ICS_CMPL_SCHD - Set Delete Transactions
  INSERT INTO ics_cmpl_schd
       ( ics_payload_id
       , ics_cmpl_schd_id
       , transaction_type
       , enfrc_actn_ident, final_order_ident, prmt_ident, cmpl_schd_num
       , key_hash
       , data_hash) 
   SELECT ics_cmpl_schd.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , enfrc_actn_ident, final_order_ident, prmt_ident, cmpl_schd_num
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cmpl_schd
    WHERE ics_cmpl_schd.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'ComplianceScheduleSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cmpl_schd.key_hash IN (SELECT key_hash
                                        FROM cdv_cmpl_schd
                                       WHERE cdv_cmpl_schd.action_type = 'DELETE');
  
  -- ICS_DMR_VIOL - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_EFFLU_TRADE_PRTNER - Set Delete Transactions
  INSERT INTO ics_efflu_trade_prtner
       ( ics_payload_id
       , ics_efflu_trade_prtner_id
       , transaction_type
       , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date, lmt_mod_effective_date, trade_id
       , key_hash
       , data_hash) 
   SELECT ics_efflu_trade_prtner.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_featr_ident, lmt_set_designator, param_code, mon_site_desc_code, lmt_season_num, lmt_start_date, lmt_end_date, lmt_mod_effective_date, trade_id
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_efflu_trade_prtner
    WHERE ics_efflu_trade_prtner.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'EffluentTradePartnerSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_efflu_trade_prtner.key_hash IN (SELECT key_hash
                                        FROM cdv_efflu_trade_prtner
                                       WHERE cdv_efflu_trade_prtner.action_type = 'DELETE');
  
  -- ICS_FRML_ENFRC_ACTN - Set Delete Transactions
  INSERT INTO ics_frml_enfrc_actn
       ( ics_payload_id
       , ics_frml_enfrc_actn_id
       , transaction_type
       , enfrc_actn_ident
       , reason_deleting_record
       , key_hash
       , data_hash
       ) 
   SELECT ics_frml_enfrc_actn.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , enfrc_actn_ident
        , 'This formal enforcement action should not have been sent.'
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_frml_enfrc_actn
    WHERE ics_frml_enfrc_actn.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'FormalEnforcementActionSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_frml_enfrc_actn.key_hash IN (SELECT key_hash
                                        FROM cdv_frml_enfrc_actn
                                       WHERE cdv_frml_enfrc_actn.action_type = 'DELETE');
  
  -- ICS_INFRML_ENFRC_ACTN - Set Delete Transactions
  INSERT INTO ics_infrml_enfrc_actn
       ( ics_payload_id
       , ics_infrml_enfrc_actn_id
       , transaction_type
       , enfrc_actn_ident
       , reason_deleting_record
       , key_hash
       , data_hash
       ) 
   SELECT ics_infrml_enfrc_actn.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , enfrc_actn_ident
        , 'This informal enforcement action should not have been sent.'
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_infrml_enfrc_actn
    WHERE ics_infrml_enfrc_actn.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'InformalEnforcementActionSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_infrml_enfrc_actn.key_hash IN (SELECT key_hash
                                        FROM cdv_infrml_enfrc_actn
                                       WHERE cdv_infrml_enfrc_actn.action_type = 'DELETE');
  
  -- ICS_ENFRC_ACTN_MILESTONE - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_FINAL_ORDER_VIOL_LNK - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_CSO_EVT_REP - Set Delete Transactions
  INSERT INTO ics_cso_evt_rep
       ( ics_payload_id
       , ics_cso_evt_rep_id
       , transaction_type
       , prmt_ident, cso_evt_date, cso_evt_id
       , key_hash
       , data_hash) 
   SELECT ics_cso_evt_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, cso_evt_date, cso_evt_id
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cso_evt_rep
    WHERE ics_cso_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'CSOEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cso_evt_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_cso_evt_rep
                                       WHERE cdv_cso_evt_rep.action_type = 'DELETE');
  
  -- ICS_SW_EVT_REP - Set Delete Transactions
  INSERT INTO ics_sw_evt_rep
       ( ics_payload_id
       , ics_sw_evt_rep_id
       , transaction_type
       , prmt_ident, date_strm_evt_smpl, sw_evt_id
       , key_hash
       , data_hash) 
   SELECT ics_sw_evt_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, date_strm_evt_smpl, sw_evt_id
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sw_evt_rep
    WHERE ics_sw_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_evt_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_sw_evt_rep
                                       WHERE cdv_sw_evt_rep.action_type = 'DELETE');
  
  -- ICS_CAFO_ANNUL_REP - Set Delete Transactions
  INSERT INTO ics_cafo_annul_rep
       ( ics_payload_id
       , ics_cafo_annul_rep_id
       , transaction_type
       , prmt_ident, prmt_auth_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_cafo_annul_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_auth_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_cafo_annul_rep
    WHERE ics_cafo_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'CAFOAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_cafo_annul_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_cafo_annul_rep
                                       WHERE cdv_cafo_annul_rep.action_type = 'DELETE');
  
  -- ICS_LOC_LMTS_PROG_REP - Set Delete Transactions
  INSERT INTO ics_loc_lmts_prog_rep
       ( ics_payload_id
       , ics_loc_lmts_prog_rep_id
       , transaction_type
       , prmt_ident, prmt_auth_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_loc_lmts_prog_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, prmt_auth_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_loc_lmts_prog_rep
    WHERE ics_loc_lmts_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'LocalLimitsProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_loc_lmts_prog_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_loc_lmts_prog_rep
                                       WHERE cdv_loc_lmts_prog_rep.action_type = 'DELETE');
  
  -- ICS_PRETR_PERF_SUMM - Set Delete Transactions
  INSERT INTO ics_pretr_perf_summ
       ( ics_payload_id
       , ics_pretr_perf_summ_id
       , transaction_type
       , prmt_ident, pretr_perf_summ_end_date
       , key_hash
       , data_hash) 
   SELECT ics_pretr_perf_summ.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, pretr_perf_summ_end_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_pretr_perf_summ
    WHERE ics_pretr_perf_summ.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'PretreatmentPerformanceSummarySubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_pretr_perf_summ.key_hash IN (SELECT key_hash
                                        FROM cdv_pretr_perf_summ
                                       WHERE cdv_pretr_perf_summ.action_type = 'DELETE');
  
  -- ICS_BS_PROG_REP - Set Delete Transactions
  INSERT INTO ics_bs_prog_rep
       ( ics_payload_id
       , ics_bs_prog_rep_id
       , transaction_type
       , prmt_ident, rep_coverage_end_date
       , key_hash
       , data_hash) 
   SELECT ics_bs_prog_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, rep_coverage_end_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_bs_prog_rep
    WHERE ics_bs_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'BiosolidsProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_bs_prog_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_bs_prog_rep
                                       WHERE cdv_bs_prog_rep.action_type = 'DELETE');
  
  -- ICS_SSO_ANNUL_REP - Set Delete Transactions
  INSERT INTO ics_sso_annul_rep
       ( ics_payload_id
       , ics_sso_annul_rep_id
       , transaction_type
       , prmt_ident, sso_annul_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_sso_annul_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, sso_annul_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sso_annul_rep
    WHERE ics_sso_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SSOAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_annul_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_sso_annul_rep
                                       WHERE cdv_sso_annul_rep.action_type = 'DELETE');
  
  -- ICS_SSO_EVT_REP - Set Delete Transactions
  INSERT INTO ics_sso_evt_rep
       ( ics_payload_id
       , ics_sso_evt_rep_id
       , transaction_type
       , prmt_ident, sso_evt_date, sso_evt_id
       , key_hash
       , data_hash) 
   SELECT ics_sso_evt_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, sso_evt_date, sso_evt_id
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sso_evt_rep
    WHERE ics_sso_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SSOEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_evt_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_sso_evt_rep
                                       WHERE cdv_sso_evt_rep.action_type = 'DELETE');
  
  -- ICS_SSO_MONTHLY_EVT_REP - Set Delete Transactions
  INSERT INTO ics_sso_monthly_evt_rep
       ( ics_payload_id
       , ics_sso_monthly_evt_rep_id
       , transaction_type
       , prmt_ident, sso_monthly_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_sso_monthly_evt_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, sso_monthly_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sso_monthly_evt_rep
    WHERE ics_sso_monthly_evt_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SSOMonthlyEventReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sso_monthly_evt_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_sso_monthly_evt_rep
                                       WHERE cdv_sso_monthly_evt_rep.action_type = 'DELETE');
  
  -- ICS_SWMS_4_PROG_REP - Set Delete Transactions
  INSERT INTO ics_swms_4_prog_rep
       ( ics_payload_id
       , ics_swms_4_prog_rep_id
       , transaction_type
       , prmt_ident, sw_ms_4_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_swms_4_prog_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident, sw_ms_4_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_swms_4_prog_rep
    WHERE ics_swms_4_prog_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWMS4ProgramReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_swms_4_prog_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_swms_4_prog_rep
                                       WHERE cdv_swms_4_prog_rep.action_type = 'DELETE');
  
  -- ICS_SCHD_EVT_VIOL - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  -- ICS_CMPL_MON_LNK - Set Delete Transactions
  /* -----------------------------------------------------------------Conditional biz keys require manual development of SQL for this module!
  INSERT INTO ics_cmpl_mon_lnk
       ( ics_payload_id
       , ics_cmpl_mon_lnk_id
       , transaction_type
       , prmt_ident, cmpl_mon_catg_code, cmpl_mon_date, prmt_ident_2, sngl_evt_viol_code, sngl_evt_viol_date, enfrc_actn_ident, rep_coverage_end_date, prmt_auth_rep_rcvd_date, cso_evt_date, pretr_perf_summ_end_date, sso_annul_rep_rcvd_date, sso_evt_date, sso_monthly_rep_rcvd_date, date_strm_evt_smpl, sw_ms_4_rep_rcvd_date, cmpl_mon_catg_code_2, cmpl_mon_date_2) 
   SELECT ics_cmpl_mon_lnk.ics_payload_id
        , ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
        , 'X' AS transaction_type
        , prmt_ident, cmpl_mon_catg_code, cmpl_mon_date, prmt_ident_2, sngl_evt_viol_code, sngl_evt_viol_date, enfrc_actn_ident, rep_coverage_end_date, prmt_auth_rep_rcvd_date, cso_evt_date, pretr_perf_summ_end_date, sso_annul_rep_rcvd_date, sso_evt_date, sso_monthly_rep_rcvd_date, date_strm_evt_smpl, sw_ms_4_rep_rcvd_date, cmpl_mon_catg_code_2, cmpl_mon_date_2
     FROM ics_flow_icis.ics_cmpl_mon_lnk
    WHERE ics_cmpl_mon_lnk.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'ComplianceMonitoringLinkageSubmission'
                            AND auto_gen_deletes = 'Y' AND enabled = 'Y'))
      AND ics_cmpl_mon_lnk.key_hash IN (SELECT key_hash
                                        FROM cdv_cmpl_mon_lnk
                                       WHERE cdv_cmpl_mon_lnk.action_type = 'DELETE');
  */
  
  -- ICS_ENFRC_ACTN_VIOL_LNK - Set Delete Transactions
  -- Delete transaction not supported by ICIS for this module
  
  

 /* **************************************************
  * ICS_DMR_PROG_REP_LNK:  Set Delete Transactions
  * **************************************************/
  FOR i IN (SELECT DISTINCT 
                   ics_dmr_prog_rep_lnk_id
              FROM ics_flow_icis.ics_dmr_prog_rep_lnk
             WHERE ics_dmr_prog_rep_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                             FROM ics_payload 
                                                            WHERE operation = 'DMRProgramReportLinkageSubmission'
                                                              AND auto_gen_deletes = 'Y' 
                                                              AND enabled = 'Y')
               AND ics_dmr_prog_rep_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                       FROM cdv_dmr_prog_rep_lnk
                                                      WHERE action_type = 'DELETE')) LOOP
                                                      
    SELECT SYS_GUID() AS ics_cmpl_mon_lnk_id
      INTO v_ics_dmr_prog_rep_lnk_id
      FROM DUAL;                                                      
                                                       
      INSERT INTO ics_dmr_prog_rep_lnk
           ( ics_dmr_prog_rep_lnk_id
           , ics_payload_id
           , transaction_type
           , prmt_ident
           , prmt_featr_ident
           , lmt_set_designator
           , mon_period_end_date
           , key_hash
           , data_hash) 
       SELECT v_ics_dmr_prog_rep_lnk_id
            , (SELECT ics_payload_id
                 FROM ics_payload 
                WHERE operation = 'DMRProgramReportLinkageSubmission') AS ics_payload_id
            , 'X' AS transaction_type
            , ics_dmr_prog_rep_lnk.prmt_ident
            , ics_dmr_prog_rep_lnk.prmt_featr_ident
            , ics_dmr_prog_rep_lnk.lmt_set_designator
            , ics_dmr_prog_rep_lnk.mon_period_end_date
            , ics_dmr_prog_rep_lnk.key_hash
            , ics_dmr_prog_rep_lnk.data_hash          
         FROM ics_flow_icis.ics_dmr_prog_rep_lnk
        WHERE ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id = i.ics_dmr_prog_rep_lnk_id;

        
      INSERT INTO ics_lnk_bs_rep
           ( ics_lnk_bs_rep_id
           , ics_dmr_prog_rep_lnk_id
           , ics_cmpl_mon_lnk_id
           , prmt_ident
           , rep_coverage_end_date
           , data_hash)
      SELECT SYS_GUID() AS ics_lnk_bs_rep_id
           , v_ics_dmr_prog_rep_lnk_id AS ics_dmr_prog_rep_lnk_id
           , NULL AS ics_cmpl_mon_lnk_id
           , ics_lnk_bs_rep.prmt_ident
           , ics_lnk_bs_rep.rep_coverage_end_date
           , ics_lnk_bs_rep.data_hash
        FROM ics_flow_icis.ics_lnk_bs_rep
       WHERE ics_lnk_bs_rep.ics_dmr_prog_rep_lnk_id = i.ics_dmr_prog_rep_lnk_id;

      
      INSERT INTO ics_lnk_sw_evt_rep
           ( ICS_LNK_SW_EVT_REP_ID
           , ICS_DMR_PROG_REP_LNK_ID
           , ICS_CMPL_MON_LNK_ID
           , PRMT_IDENT
           , DATE_STRM_EVT_SMPL
           , SW_EVT_ID
           , DATA_HASH)  
      SELECT SYS_GUID() AS ics_lnk_sw_evt_rep_id
           , v_ics_dmr_prog_rep_lnk_id AS ics_dmr_prog_rep_lnk_id
           , NULL AS ics_cmpl_mon_lnk_id
           , ics_lnk_sw_evt_rep.prmt_ident
           , ics_lnk_sw_evt_rep.date_strm_evt_smpl
           , ics_lnk_sw_evt_rep.sw_evt_id
           , ics_lnk_sw_evt_rep.data_hash
        FROM ics_flow_icis.ics_lnk_sw_evt_rep
       WHERE ics_lnk_sw_evt_rep.ics_dmr_prog_rep_lnk_id = i.ics_dmr_prog_rep_lnk_id;
       
      
    END LOOP;    
                                       
 /* **************************************************
  * ICS_CMPL_MON_LNK:  Set Delete Transactions
  * **************************************************/                            
  FOR i IN (SELECT DISTINCT 
                   ics_cmpl_mon_lnk_id
              FROM ics_flow_icis.ics_cmpl_mon_lnk
             WHERE ics_cmpl_mon_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                         FROM ics_payload 
                                                        WHERE operation = 'ComplianceMonitoringLinkageSubmission'
                                                          AND auto_gen_deletes = 'Y' 
                                                          AND enabled = 'Y')
               AND ics_cmpl_mon_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                   FROM cdv_cmpl_mon_lnk
                                                  WHERE cdv_cmpl_mon_lnk.action_type = 'DELETE')) LOOP                     
    
    SELECT SYS_GUID() AS ics_cmpl_mon_lnk_id
      INTO v_ics_cmpl_mon_lnk_id
      FROM DUAL;
                                           
    /*  
     *  ICS_CMPL_MON_LNK 
     */                                      
     INSERT INTO ICS_CMPL_MON_LNK
          ( ICS_CMPL_MON_LNK_ID
          , ICS_PAYLOAD_ID
          , SRC_SYSTM_IDENT
          , CMPL_MON_IDENT
          , TRANSACTION_TYPE
          , TRANSACTION_TIMESTAMP
          , KEY_HASH
          , DATA_HASH)
     SELECT v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , (SELECT ics_payload_id
               FROM ics_payload 
              WHERE operation = 'ComplianceMonitoringLinkageSubmission') AS ics_payload_id
          , ics_cmpl_mon_lnk.src_systm_ident
          , ics_cmpl_mon_lnk.cmpl_mon_ident
          , 'X' AS transaction_type
          , SYSDATE AS transaction_timestamp
          , NULL AS key_hash
          , NULL AS data_hash
       FROM ics_flow_icis.ics_cmpl_mon_lnk
      WHERE ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
      
     
    /*  
     *  ICS_LNK_BS_REP 
     */       
     INSERT INTO ics_lnk_bs_rep
          ( ics_lnk_bs_rep_id
          , ics_dmr_prog_rep_lnk_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , rep_coverage_end_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_bs_rep_id
          , NULL AS ics_dmr_prog_rep_lnk_id
          , v_ics_cmpl_mon_lnk_id
          , prmt_ident
          , rep_coverage_end_date
          , data_hash
       FROM ics_flow_icis.ics_lnk_bs_rep
      WHERE ics_lnk_bs_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
    /*  
     *  ICS_LNK_ST_CMPL_MON 
     */       
     INSERT INTO ics_lnk_st_cmpl_mon
          ( ics_lnk_st_cmpl_mon_id
          , ics_cmpl_mon_lnk_id
          , cmpl_mon_ident
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_st_cmpl_mon_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , cmpl_mon_ident
          , ics_lnk_st_cmpl_mon.data_hash
       FROM ics_flow_icis.ics_lnk_st_cmpl_mon
      WHERE ics_lnk_st_cmpl_mon.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
    /*  
     *  ICS_LNK_SNGL_EVT 
     */  
     INSERT INTO ics_lnk_sngl_evt 
          ( ics_lnk_sngl_evt_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sngl_evt_viol_code
          , sngl_evt_viol_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_sngl_evt_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sngl_evt.prmt_ident
          , ics_lnk_sngl_evt.sngl_evt_viol_code
          , ics_lnk_sngl_evt.sngl_evt_viol_date
          , ics_lnk_sngl_evt.data_hash
       FROM ics_flow_icis.ics_lnk_sngl_evt
      WHERE ics_lnk_sngl_evt.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;


    /*  
     *  ICS_LNK_CSO_EVT_REP 
     */  
     INSERT INTO ics_lnk_cso_evt_rep
          ( ics_lnk_cso_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , cso_evt_date
          , cso_evt_id
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_cso_evt_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_cso_evt_rep.prmt_ident
          , ics_lnk_cso_evt_rep.cso_evt_date
          , ics_lnk_cso_evt_rep.cso_evt_id
          , ics_lnk_cso_evt_rep.data_hash
       FROM ics_flow_icis.ics_lnk_cso_evt_rep
      WHERE ics_lnk_cso_evt_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
      
    /*  
     *  ICS_LNK_ENFRC_ACTN 
     */  
     INSERT INTO ics_lnk_enfrc_actn
          ( ics_lnk_enfrc_actn_id
          , ics_cmpl_mon_lnk_id
          , enfrc_actn_ident
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_enfrc_actn_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_enfrc_actn.enfrc_actn_ident
          , ics_lnk_enfrc_actn.data_hash
       FROM ics_flow_icis.ics_lnk_enfrc_actn
      WHERE ics_lnk_enfrc_actn.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
    /*  
     *  ICS_LNK_LOC_LMTS_REP 
     */  
     INSERT INTO ics_lnk_loc_lmts_rep
          ( ics_lnk_loc_lmts_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , prmt_auth_rep_rcvd_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_loc_lmts_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_loc_lmts_rep.prmt_ident
          , ics_lnk_loc_lmts_rep.prmt_auth_rep_rcvd_date
          , ics_lnk_loc_lmts_rep.data_hash
       FROM ics_flow_icis.ics_lnk_loc_lmts_rep
      WHERE ics_lnk_loc_lmts_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
    /*  
     *  ICS_LNK_SSO_MONTHLY_EVT_REP 
     */  
     INSERT INTO ics_lnk_sso_monthly_evt_rep
          ( ics_lnk_sso_monthly_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_monthly_rep_rcvd_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_sso_monthly_evt_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_monthly_evt_rep.prmt_ident
          , ics_lnk_sso_monthly_evt_rep.sso_monthly_rep_rcvd_date
          , ics_lnk_sso_monthly_evt_rep.data_hash
       FROM ics_flow_icis.ics_lnk_sso_monthly_evt_rep
      WHERE ics_lnk_sso_monthly_evt_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
    
    /*  
     *  ICS_LNK_CAFO_ANNUL_REP 
     */  
     INSERT INTO ics_lnk_cafo_annul_rep
          ( ics_lnk_cafo_annul_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , prmt_auth_rep_rcvd_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_cafo_annul_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_cafo_annul_rep.prmt_ident
          , ics_lnk_cafo_annul_rep.prmt_auth_rep_rcvd_date
          , ics_lnk_cafo_annul_rep.data_hash
       FROM ics_flow_icis.ics_lnk_cafo_annul_rep
      WHERE ics_lnk_cafo_annul_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;



    /*  
     *  ICS_LNK_PRETR_PERF_REP
     */  
     INSERT INTO ics_lnk_pretr_perf_rep
          ( ics_lnk_pretr_perf_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , pretr_perf_summ_end_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_pretr_perf_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_pretr_perf_rep.prmt_ident
          , ics_lnk_pretr_perf_rep.pretr_perf_summ_end_date
          , ics_lnk_pretr_perf_rep.data_hash
       FROM ics_flow_icis.ics_lnk_pretr_perf_rep
      WHERE ics_lnk_pretr_perf_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;


    /*  
     *  ICS_LNK_SSO_EVT_REP
     */  
     INSERT INTO ics_lnk_sso_evt_rep
          ( ics_lnk_sso_evt_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_evt_date
          , sso_evt_id
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_sso_evt_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_evt_rep.prmt_ident
          , ics_lnk_sso_evt_rep.sso_evt_date
          , ics_lnk_sso_evt_rep.sso_evt_id
          , ics_lnk_sso_evt_rep.data_hash
       FROM ics_flow_icis.ics_lnk_sso_evt_rep
      WHERE ics_lnk_sso_evt_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
       
    /*  
     *  ICS_LNK_FEDR_CMPL_MON
     */  
     INSERT INTO ics_lnk_fedr_cmpl_mon
          ( ics_lnk_fedr_cmpl_mon_id
          , ics_cmpl_mon_lnk_id
          , prog_systm_acronym
          , prog_systm_ident
          , fedr_statute_code
          , cmpl_mon_acty_type_code
          , cmpl_mon_catg_code
          , cmpl_mon_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_fedr_cmpl_mon_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_fedr_cmpl_mon.prog_systm_acronym
          , ics_lnk_fedr_cmpl_mon.prog_systm_ident
          , ics_lnk_fedr_cmpl_mon.fedr_statute_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_acty_type_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_catg_code
          , ics_lnk_fedr_cmpl_mon.cmpl_mon_date
          , ics_lnk_fedr_cmpl_mon.data_hash
       FROM ics_flow_icis.ics_lnk_fedr_cmpl_mon
      WHERE ics_lnk_fedr_cmpl_mon.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
       
    /*  
     *  ICS_LNK_SSO_ANNUL_REP
     */  
     INSERT INTO ics_lnk_sso_annul_rep
          ( ics_lnk_sso_annul_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sso_annul_rep_rcvd_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_sso_annul_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sso_annul_rep.prmt_ident
          , sso_annul_rep_rcvd_date
          , data_hash
       FROM ics_flow_icis.ics_lnk_sso_annul_rep
      WHERE ics_lnk_sso_annul_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
       
    /*  
     *  ICS_LNK_SW_EVT_REP
     */  
     INSERT INTO ics_lnk_sw_evt_rep
          ( ics_lnk_sw_evt_rep_id
          , ics_dmr_prog_rep_lnk_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , date_strm_evt_smpl
          , sw_evt_id
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_sw_evt_rep_id
          , NULL AS ics_dmr_prog_rep_lnk_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_sw_evt_rep.prmt_ident
          , ics_lnk_sw_evt_rep.date_strm_evt_smpl
          , ics_lnk_sw_evt_rep.sw_evt_id
          , ics_lnk_sw_evt_rep.data_hash
       FROM ics_flow_icis.ics_lnk_sw_evt_rep
      WHERE ics_lnk_sw_evt_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;
       
       
    /*  
     *  ICS_LNK_SWMS_4_REP
     */  
     INSERT INTO ics_lnk_swms_4_rep
          ( ics_lnk_swms_4_rep_id
          , ics_cmpl_mon_lnk_id
          , prmt_ident
          , sw_ms_4_rep_rcvd_date
          , data_hash)
     SELECT SYS_GUID() AS ics_lnk_swms_4_rep_id
          , v_ics_cmpl_mon_lnk_id AS ics_cmpl_mon_lnk_id
          , ics_lnk_swms_4_rep.prmt_ident
          , ics_lnk_swms_4_rep.sw_ms_4_rep_rcvd_date
          , ics_lnk_swms_4_rep.data_hash
       FROM ics_flow_icis.ics_lnk_swms_4_rep
      WHERE ics_lnk_swms_4_rep.ics_cmpl_mon_lnk_id = i.ics_cmpl_mon_lnk_id;

       

     COMMIT;
     
    END LOOP;
    

 /* **************************************************
  * ICS_ENFRC_ACTN_VIOL_LNK:  Set Delete Transactions
  * **************************************************/
  FOR i IN (SELECT DISTINCT  ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
              FROM ics_flow_icis.ics_enfrc_actn_viol_lnk
             WHERE ics_enfrc_actn_viol_lnk.ics_payload_id in (SELECT ics_payload_id 
                                                                FROM ics_payload 
                                                               WHERE operation = 'EnforcementActionViolationLinkageSubmission'
                                                                 AND auto_gen_deletes = 'Y' 
                                                                 AND enabled = 'Y')
               AND ics_enfrc_actn_viol_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                          FROM cdv_enfrc_actn_viol_lnk
                                                         WHERE cdv_enfrc_actn_viol_lnk.action_type = 'DELETE')) LOOP
    
    SELECT SYS_GUID() AS ics_enfrc_actn_viol_lnk_id
      INTO v_ics_enfrc_actn_viol_lnk_id
      FROM DUAL;
                                  
    /*  
     *  ICS_ENFRC_ACTN_VIOL_LNK
     */                                     
     INSERT INTO ics_enfrc_actn_viol_lnk
          ( ics_enfrc_actn_viol_lnk_id
          , ics_payload_id
          , src_systm_ident
          , transaction_type
          , transaction_timestamp
          , enfrc_actn_ident
          , key_hash
          , data_hash)
     SELECT v_ics_enfrc_actn_viol_lnk_id AS ICS_ENFRC_ACTN_VIOL_LNK_ID
          , (SELECT ics_payload_id
               FROM ics_payload 
              WHERE operation = 'EnforcementActionViolationLinkageSubmission') AS ics_payload_id
          , ics_enfrc_actn_viol_lnk.src_systm_ident AS src_systm_ident
          , 'x' AS transaction_type
          , ics_enfrc_actn_viol_lnk.transaction_timestamp AS transaction_timestamp
          , ics_enfrc_actn_viol_lnk.enfrc_actn_ident AS enfrc_actn_ident
          , NULL AS key_hash
          , NULL AS data_hash
       FROM ics_flow_icis.ics_enfrc_actn_viol_lnk
       WHERE ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;

       /*
        * ICS_PRMT_SCHD_VIOL
        */
        INSERT INTO ics_prmt_schd_viol
            ( ics_prmt_schd_viol_id
            , ics_enfrc_actn_viol_lnk_id
            , ics_final_order_viol_lnk_id
            , prmt_ident
            , narr_cond_num
            , schd_evt_code
            , schd_date
            , data_hash)
       SELECT SYS_GUID() AS ics_prmt_schd_viol_id
            , v_ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
            , NULL AS ics_final_order_viol_lnk_id
            , ics_prmt_schd_viol.prmt_ident AS prmt_ident
            , ics_prmt_schd_viol.narr_cond_num AS narr_cond_num
            , ics_prmt_schd_viol.schd_evt_code AS schd_evt_code
            , ics_prmt_schd_viol.schd_date AS schd_date
            , ics_prmt_schd_viol.data_hash  AS data_hash
        FROM ics_flow_icis.ics_prmt_schd_viol
        WHERE ics_prmt_schd_viol.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;
                    

      /*
       * ICS_CMPL_SCHD_VIOL
       */
       INSERT INTO ics_cmpl_schd_viol
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
       SELECT SYS_GUID() as ics_cmpl_schd_viol_id
            , v_ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
            , NULL AS ics_final_order_viol_lnk_id
            , ics_cmpl_schd_viol.enfrc_actn_ident AS enfrc_actn_ident
            , ics_cmpl_schd_viol.final_order_ident AS final_order_ident
            , ics_cmpl_schd_viol.prmt_ident AS prmt_ident
            , ics_cmpl_schd_viol.cmpl_schd_num AS cmpl_schd_num
            , ics_cmpl_schd_viol.schd_evt_code AS schd_evt_code
            , ics_cmpl_schd_viol.schd_date AS schd_date
            , ics_cmpl_schd_viol.data_hash AS data_hash
        FROM ics_flow_icis.ics_cmpl_schd_viol
        WHERE ics_cmpl_schd_viol.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;


      /*
       * ICS_DSCH_MON_REP_VIOL
       */
       INSERT INTO ics_dsch_mon_rep_viol
           ( ics_dsch_mon_rep_viol_id
           , ics_enfrc_actn_viol_lnk_id
           , ics_final_order_viol_lnk_id
           , prmt_ident
           , prmt_featr_ident
           , lmt_set_designator
           , mon_period_end_date
           , data_hash)
      SELECT SYS_GUID() as ics_dsch_mon_rep_viol_id
           , v_ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
           , NULL AS ics_final_order_viol_lnk_id
           , ics_dsch_mon_rep_viol.prmt_ident AS prmt_ident
           , ics_dsch_mon_rep_viol.prmt_featr_ident AS prmt_featr_ident
           , ics_dsch_mon_rep_viol.lmt_set_designator AS lmt_set_designator
           , ics_dsch_mon_rep_viol.mon_period_end_date AS mon_period_end_date
           , ics_dsch_mon_rep_viol.data_hash AS data_hash
       FROM ics_flow_icis.ics_dsch_mon_rep_viol
       WHERE ics_dsch_mon_rep_viol.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;


     
      /*
       * ICS_DSCH_MON_REP_PARAM_VIOL
       */
       INSERT INTO ics_dsch_mon_rep_param_viol
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
       SELECT SYS_GUID() as ics_dsch_mon_rep_param_viol_id
            , v_ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
            , NULL AS ics_final_order_viol_lnk_id
            , ics_dsch_mon_rep_param_viol.prmt_ident AS prmt_ident
            , ics_dsch_mon_rep_param_viol.prmt_featr_ident AS prmt_featr_ident
            , ics_dsch_mon_rep_param_viol.lmt_set_designator AS lmt_set_designator
            , ics_dsch_mon_rep_param_viol.mon_period_end_date AS mon_period_end_date
            , ics_dsch_mon_rep_param_viol.param_code AS param_code
            , ics_dsch_mon_rep_param_viol.mon_site_desc_code AS mon_site_desc_code
            , ics_dsch_mon_rep_param_viol.lmt_season_num AS lmt_season_num
            , ics_dsch_mon_rep_param_viol.data_hash AS data_hash
        FROM ics_flow_icis.ics_dsch_mon_rep_param_viol
        WHERE ics_dsch_mon_rep_param_viol.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;

      /*
       * ICS_SNGL_EVTS_VIOL 
       */
       INSERT INTO ics_sngl_evts_viol
            ( ics_sngl_evts_viol_id
            , ics_enfrc_actn_viol_lnk_id
            , ics_final_order_viol_lnk_id
            , prmt_ident
            , sngl_evt_viol_code
            , sngl_evt_viol_date
            , data_hash)
       SELECT SYS_GUID() AS ics_sngl_evts_viol_id
            , v_ics_enfrc_actn_viol_lnk_id AS ics_enfrc_actn_viol_lnk_id
            , NULL AS ics_final_order_viol_lnk_id
            , ics_sngl_evts_viol.prmt_ident AS prmt_ident
            , ics_sngl_evts_viol.sngl_evt_viol_code AS sngl_evt_viol_code
            , ics_sngl_evts_viol.sngl_evt_viol_date AS sngl_evt_viol_date
            , ics_sngl_evts_viol.data_hash AS data_hash
        FROM ics_flow_icis.ics_sngl_evts_viol
        WHERE ics_sngl_evts_viol.ics_enfrc_actn_viol_lnk_id = i.ics_enfrc_actn_viol_lnk_id;
      
  END LOOP;
  
  
  
  
  

 /* **************************************************
  * ICS_FINAL_ORDER_VIOL_LNK:  Set Delete Transactions
  * **************************************************/
  FOR i IN (  SELECT DISTINCT ics_final_order_viol_lnk_id AS ics_final_order_viol_lnk_id
                FROM ics_flow_icis.ics_final_order_viol_lnk
               WHERE ics_final_order_viol_lnk.ics_payload_id IN (SELECT ics_payload_id 
                                                                   FROM ics_payload 
                                                                  WHERE operation = 'FinalOrderViolationLinkageSubmission'
                                                                    AND auto_gen_deletes = 'Y' 
                                                                    AND enabled = 'Y')
                 AND ics_final_order_viol_lnk.key_hash IN (SELECT DISTINCT key_hash 
                                                             FROM cdv_final_order_viol_lnk
                                                            WHERE action_type = 'DELETE')) LOOP
    
    SELECT SYS_GUID() AS ics_final_order_viol_lnk_id
      INTO v_ics_final_order_viol_lnk_id
      FROM DUAL;
  

  
--  INSERT INTO @tbl_final_order_viol_lnk_id
--  SELECT DISTINCT 
--         ics_final_order_viol_lnk_id AS icis_final_order_viol_lnk_id
--       , NEWID() AS local_final_order_viol_lnk_id
--    FROM ics_flow_icis.ics_flow_local.ics_final_order_viol_lnk
--   WHERE ics_final_order_viol_lnk.key_hash IN (SELECT DISTINCT key_hash 
--                                                 FROM cdv_final_order_viol_lnk
--                                                 WHERE action_type = 'DELETE');   

  INSERT INTO ics_final_order_viol_lnk
             ( ics_final_order_viol_lnk_id
             , ics_payload_id
             , src_systm_ident
             , transaction_type
             , transaction_timestamp
             , enfrc_actn_ident
             , final_order_ident
             , key_hash
             , data_hash)
      SELECT v_ics_final_order_viol_lnk_id
           , (SELECT ics_payload_id
                FROM ics_payload 
               WHERE operation = 'FinalOrderViolationLinkageSubmission') AS ics_payload_id
             , ics_final_order_viol_lnk.src_systm_ident
             , 'X' AS transaction_type
             , ics_final_order_viol_lnk.transaction_timestamp
             , ics_final_order_viol_lnk.enfrc_actn_ident
             , ics_final_order_viol_lnk.final_order_ident
             , ics_final_order_viol_lnk.key_hash
             , ics_final_order_viol_lnk.data_hash
        FROM ics_flow_icis.ics_final_order_viol_lnk
       WHERE ics_final_order_viol_lnk.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
--        JOIN @tbl_final_order_viol_lnk_id AS v_fovl
--          ON v_fovl.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id;

--    ICS_DSCH_MON_REP_PARAM_VIOL
INSERT INTO ICS_DSCH_MON_REP_PARAM_VIOL
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
      SELECT SYS_GUID() AS ICS_DSCH_MON_REP_PARAM_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_dsch_mon_rep_param_viol.prmt_ident as prmt_ident
           , ics_dsch_mon_rep_param_viol.prmt_featr_ident as prmt_featr_ident
           , ics_dsch_mon_rep_param_viol.lmt_set_designator as lmt_set_designator
           , ics_dsch_mon_rep_param_viol.mon_period_end_date as mon_period_end_date
           , ics_dsch_mon_rep_param_viol.param_code as param_code
           , ics_dsch_mon_rep_param_viol.mon_site_desc_code as mon_site_desc_code
           , ics_dsch_mon_rep_param_viol.lmt_season_num as lmt_season_num
           , ics_dsch_mon_rep_param_viol.data_hash as data_hash
        FROM ics_flow_icis.ics_dsch_mon_rep_param_viol
       WHERE ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
--   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
--     ON v_fovl.ics_final_order_viol_lnk_id = ics_dsch_mon_rep_param_viol.ics_final_order_viol_lnk_id;


--    ICS_DSCH_MON_REP_VIOL
INSERT INTO ICS_DSCH_MON_REP_VIOL
           ( ICS_DSCH_MON_REP_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , PRMT_IDENT
           , PRMT_FEATR_IDENT
           , LMT_SET_DESIGNATOR
           , MON_PERIOD_END_DATE
           , DATA_HASH)
      SELECT SYS_GUID() AS ICS_DSCH_MON_REP_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_dsch_mon_rep_viol.prmt_ident as prmt_ident
           , ics_dsch_mon_rep_viol.prmt_featr_ident as prmt_featr_ident
           , ics_dsch_mon_rep_viol.lmt_set_designator as lmt_set_designator
           , ics_dsch_mon_rep_viol.mon_period_end_date as mon_period_end_date
           , ics_dsch_mon_rep_viol.data_hash as data_hash
        FROM ics_flow_icis.ics_dsch_mon_rep_viol
       WHERE ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
       
--   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
--     ON v_fovl.ics_final_order_viol_lnk_id = ics_dsch_mon_rep_viol.ics_final_order_viol_lnk_id;

--    ICS_PRMT_SCHD_VIOL
INSERT INTO  ICS_PRMT_SCHD_VIOL
           ( ICS_PRMT_SCHD_VIOL_ID
           , ICS_ENFRC_ACTN_VIOL_LNK_ID
           , ICS_FINAL_ORDER_VIOL_LNK_ID
           , PRMT_IDENT
           , NARR_COND_NUM
           , SCHD_EVT_CODE
           , SCHD_DATE
           , DATA_HASH)
      SELECT SYS_GUID() AS ICS_PRMT_SCHD_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_prmt_schd_viol.prmt_ident as prmt_ident
           , ics_prmt_schd_viol.narr_cond_num as narr_cond_num
           , ics_prmt_schd_viol.schd_evt_code as schd_evt_code
           , ics_prmt_schd_viol.schd_date as schd_date
           , ics_prmt_schd_viol.data_hash as data_hash
        FROM ics_flow_icis.ics_prmt_schd_viol
       WHERE ics_prmt_schd_viol.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
--   JOIN @tbl_final_order_viol_lnk_id AS v_fovl
--     ON v_fovl.ics_final_order_viol_lnk_id = ics_prmt_schd_viol.ics_final_order_viol_lnk_id;

--    ICS_SNGL_EVTS_VIOL
INSERT INTO ics_sngl_evts_viol
           (ics_sngl_evts_viol_id
           ,ics_enfrc_actn_viol_lnk_id
           ,ics_final_order_viol_lnk_id
           ,prmt_ident
           ,sngl_evt_viol_code
           ,sngl_evt_viol_date
           ,data_hash)
      SELECT SYS_GUID() as ics_sngl_evts_viol_id
           , NULL as ics_enfrc_actn_viol_lnk_id
           , v_ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_sngl_evts_viol.prmt_ident as prmt_ident
           , ics_sngl_evts_viol.sngl_evt_viol_code as sngl_evt_viol_code
           , ics_sngl_evts_viol.sngl_evt_viol_date as sngl_evt_viol_date
           , ics_sngl_evts_viol.data_hash as data_hash
        FROM ics_flow_icis.ics_sngl_evts_viol
       WHERE ics_sngl_evts_viol.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
--        JOIN @tbl_final_order_viol_lnk_id AS v_fovl
--          ON v_fovl.ics_final_order_viol_lnk_id = ics_sngl_evts_viol.ics_final_order_viol_lnk_id;

--    ICS_CMPL_SCHD_VIOL
      INSERT INTO ICS_CMPL_SCHD_VIOL
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
      SELECT SYS_GUID() AS ICS_CMPL_SCHD_VIOL_ID
           , NULL AS ICS_ENFRC_ACTN_VIOL_LNK_ID
           , v_ics_final_order_viol_lnk_id as ics_final_order_viol_lnk_id
           , ics_cmpl_schd_viol.enfrc_actn_ident as enfrc_actn_ident
           , ics_cmpl_schd_viol.final_order_ident as final_order_ident
           , ics_cmpl_schd_viol.prmt_ident as prmt_ident
           , ics_cmpl_schd_viol.cmpl_schd_num as cmpl_schd_num
           , ics_cmpl_schd_viol.schd_evt_code as schd_evt_code
           , ics_cmpl_schd_viol.schd_date as schd_date
           , ics_cmpl_schd_viol.data_hash as data_hash   
        FROM ics_flow_icis.ics_cmpl_schd_viol
       WHERE ics_cmpl_schd_viol.ics_final_order_viol_lnk_id = i.ics_final_order_viol_lnk_id;
       
       
  END LOOP;
  
  
  
 -- ICS_SW_INDST_ANNUL_REP - Set Delete Transactions
 INSERT INTO ics_sw_indst_annul_rep
       ( ics_payload_id
       , ics_sw_indst_annul_rep_id
       , transaction_type
       , prmt_ident
       , indst_sw_annul_rep_rcvd_date
       , key_hash
       , data_hash) 
   SELECT ics_sw_indst_annul_rep.ics_payload_id
        , SYS_GUID()
        , 'X' AS transaction_type
        , prmt_ident
        , indst_sw_annul_rep_rcvd_date
        , key_hash
        , data_hash
     FROM ics_flow_icis.ics_sw_indst_annul_rep
    WHERE ics_sw_indst_annul_rep.ics_payload_id in (SELECT ics_payload_id 
                           FROM ics_payload 
                          WHERE operation = 'SWIndustrialAnnualReportSubmission'
                            AND auto_gen_deletes = 'Y' 
                            AND enabled = 'Y')
      AND ics_sw_indst_annul_rep.key_hash IN (SELECT key_hash
                                        FROM cdv_sw_indst_annul_rep
                                       WHERE cdv_sw_indst_annul_rep.action_type = 'DELETE');


  
   COMMIT;
   
 EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
     RAISE;
     
 END;
 /