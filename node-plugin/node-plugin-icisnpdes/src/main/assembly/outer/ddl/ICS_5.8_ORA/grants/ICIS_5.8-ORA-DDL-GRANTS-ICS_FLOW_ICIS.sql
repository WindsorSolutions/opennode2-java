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
/* ***************************
 *  Grants to ICS_FLOW_ICIS  *
 *  Grants to ICS_FLOW_ICIS  *
 *  Grants to ICS_FLOW_ICIS  *
 *****************************/
 /*****************************************************************************************************************************   
 *
 *  Script Name:  ICIS_5.0-ORA-DDL-GRANTS-ICS_FLOW_ICIS.sql
 *
 *  Company:  Windsor Solutions, Inc.
 *  
 *  Purpose:  This script grants CRUD rights for all the objects owned by ICS_FLOW_LOCAL to ICS_FLOW_LOCAL_USER
 *   
 *  Maintenance:
 *  
 *    Analyst         Date            Comment 
 *    ----------      ----------      ------------------------------------------------------------------------------
 *    Windsor         09/10/2014      Created from 4.0 baseline.
 *    Windsor         09/10/2014      Added grant on new 5.0 object ICS_SW_INDST_ANNUL_REP.
 *    Windsor         10/03/2014      Added grant on new 5.0 object ICS_SUBSCTOR_CODE_PLUS_DESC
 *    KJeffery        09/27/2016      Updates to support the ICIS 5.6 XML schema changes.
 *
 ****************************************************************************************************************************   
 */
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ADDR TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ANML_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ASSC_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_BASIC_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_BS_END_USE_DSPL_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_BS_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_BS_PROG_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_BS_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CAFO_ANNUL_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CAFO_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CAFO_INSP_VIOL_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CAFO_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_INSP_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_MON TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_MON_ACTN_REASON TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_MON_AGNCY_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_MON_LNK TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_SCHD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_SCHD_EVT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_SCHD_EVT_VIOL_ELEM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_SCHD_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CMPL_TRACK_STAT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CONTACT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CONTAINMENT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CO_DSPL_SITE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CROP_TYPES_HARVESTED TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CROP_TYPES_PLANTED TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CSO_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CSO_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_CSO_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_DMR_PROG_REP_LNK TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_DMR_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_DSCH_MON_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_DSCH_MON_REP_PARAM_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_DSCH_MON_REP_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_EFFLU_GUIDE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_EFFLU_TRADE_PRTNER TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_EFFLU_TRADE_PRTNER_ADDR TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ENFRC_ACTN_GOV_CONTACT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ENFRC_ACTN_MILESTONE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ENFRC_ACTN_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ENFRC_ACTN_VIOL_LNK TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ENFRC_AGNCY TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FAC TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FAC_CLASS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FINAL_ORDER TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FINAL_ORDER_PRMT_IDENT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FINAL_ORDER_VIOL_LNK TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_FRML_ENFRC_ACTN TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GEO_COORD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GNRL_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GPCF_CNST_WAIVER TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GPCF_NOTICE_OF_INTENT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GPCF_NOTICE_OF_TERM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_GPCF_NO_EXPOSURE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_HIST_PRMT_SCHD_EVTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_IMPACT_SSO_EVT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_INCIN TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_INFRML_ENFRC_ACTN TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LAND_APPL_BMP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LAND_APPL_SITE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMT_SET TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMT_SET_MONTHS_APPL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMT_SET_SCHD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LMT_SET_STAT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_BS_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_CAFO_ANNUL_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_CSO_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_ENFRC_ACTN TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_FEDR_CMPL_MON TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_LOC_LMTS_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_PRETR_PERF_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SNGL_EVT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SSO_ANNUL_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SSO_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SSO_MONTHLY_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_ST_CMPL_MON TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SWMS_4_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LNK_SW_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LOC_LMTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LOC_LMTS_POLUT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_LOC_LMTS_PROG_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_MASTER_GNRL_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_MNUR_LTTR_PRCSS_WW_STOR TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_MN_LMT_APPLIES TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_NAICS_CODE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_NARR_COND_SCHD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_NAT_PRIO TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_NUM_COND TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_NUM_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_ORIG_PROGS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_OTHR_PRMTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PARAM_LMTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PAYLOAD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PLCY TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_POTW_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRETR_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRETR_PERF_SUMM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRETR_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_COMP_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_FEATR TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_FEATR_CHAR TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_FEATR_TRTMNT_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_IDENT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_REISSU TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_SCHD_EVT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_SCHD_EVT_VIOL_ELEM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_SCHD_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_TERM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PRMT_TRACK_EVT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PROG TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PROGS_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PROJ_SRCS_FUND TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PROJ_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_REP_ANML_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_REP_PARAM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_RMVL_CRDTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_RMVL_CRDTS_POLUT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SATL_COLL_SYSTM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SCHD_EVT_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SIC_CODE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SNGL_EVTS_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SNGL_EVT_VIOL TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_ANNUL_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_MONTHLY_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_STPS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SSO_SYSTM_COMP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SUBM_RESULTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SUBM_TRACK TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SURF_DSPL_SITE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SWMS_4_LARGE_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SWMS_4_PROG_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SWMS_4_SMALL_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_CNST_INDST_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_CNST_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_CNST_NON_CNST_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_CNST_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_EVT_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_INDST_PRMT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_MS_4_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_NON_CNST_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_UNPRMT_CNST_INSP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_TELEPH TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_UNPRMT_FAC TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SW_INDST_ANNUL_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SUBSCTOR_CODE_PLUS_DESC TO ICS_FLOW_LOCAL;
-- 5.6 changes
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_PROG_DEFCY_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_SEP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_FLOW_ICIS.ICS_REP_NON_CMPL_STAT TO ICS_FLOW_LOCAL;
-- 5.8 changes
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_ANLYTCL_METHOD TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_BS_ANNUL_PROG_REP TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_BS_MGMT_PRACTICES TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_CNST_SITE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_IMPAIRED_WTR_POLLUTANTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_MGMT_PRC_DEFCY_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_NPDES_DAT_GRP_NUM TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_PATHOGEN_REDUCTION_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_REP_OBLGTN_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_TMDL_POLLUTANTS TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_TMDL_POLUT TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_TRTMNT_CHEMS_LIST TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_TRTMNT_PRCSS_TYPE TO ICS_FLOW_LOCAL;
GRANT SELECT,INSERT,UPDATE,DELETE ON ICS_VECTOR_A_REDUCTION_TYPE TO ICS_FLOW_LOCAL;
