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
** ObjectName: cdv_basic_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
** 10/11/2014    TConrad     Added cdv_sw_indst_annul_rep.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_basic_prmt AS 
SELECT DISTINCT ics_module
, ics_basic_prmt.key_hash
     , CASE ics_basic_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_basic_prmt tbl
                  WHERE tbl.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_basic_prmt tbl
                  WHERE tbl.ics_basic_prmt_id = ics_basic_prmt.ics_basic_prmt_id)
       END AS module_ident
     , ics_basic_prmt.action_type
     , ics_basic_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_basic_prmt.ics_basic_prmt_id
			 , ics_basic_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_BASIC_PRMT' as ics_module
          FROM ics_basic_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_basic_prmt tbl
                            WHERE tbl.key_hash = ics_basic_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_basic_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_BASIC_PRMT' as ics_module
          FROM ics_basic_prmt local
          JOIN ics_flow_icis.ics_basic_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_basic_prmt.ics_basic_prmt_id
             , ics_basic_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_BASIC_PRMT' as ics_module
          FROM ics_flow_icis.ics_basic_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_basic_prmt tbl
                            WHERE tbl.key_hash = ics_basic_prmt.key_hash)) ics_basic_prmt;
                 
/*************************************************************************************************
** ObjectName: cdv_bs_annul_prog_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 06/21/2017   Windsor      Created for v5.8
**
***************************************************************************************************/                  
CREATE VIEW cdv_bs_annul_prog_rep AS 
SELECT DISTINCT ics_module
, ics_bs_annul_prog_rep.key_hash
     , CASE ics_bs_annul_prog_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_bs_annul_prog_rep tbl
                  WHERE tbl.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_bs_annul_prog_rep tbl
                  WHERE tbl.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id)
       END AS module_ident
     , ics_bs_annul_prog_rep.action_type
     , ics_bs_annul_prog_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
			 , ics_bs_annul_prog_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_bs_annul_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_bs_annul_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_annul_prog_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_bs_annul_prog_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_bs_annul_prog_rep local
          JOIN ics_flow_icis.ics_bs_annul_prog_rep icis
            ON (icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
             , ics_bs_annul_prog_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_flow_icis.ics_bs_annul_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_bs_annul_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_annul_prog_rep.key_hash)) ics_bs_annul_prog_rep;
    
/*************************************************************************************************
** ObjectName: cdv_bs_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_bs_prmt AS 
SELECT DISTINCT ics_module
, ics_bs_prmt.key_hash
     , CASE ics_bs_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_bs_prmt tbl
                  WHERE tbl.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_bs_prmt tbl
                  WHERE tbl.ics_bs_prmt_id = ics_bs_prmt.ics_bs_prmt_id)
       END AS module_ident
     , ics_bs_prmt.action_type
     , ics_bs_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_bs_prmt.ics_bs_prmt_id
			 , ics_bs_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_BS_PRMT' as ics_module
          FROM ics_bs_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_bs_prmt tbl
                            WHERE tbl.key_hash = ics_bs_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_bs_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_BS_PRMT' as ics_module
          FROM ics_bs_prmt local
          JOIN ics_flow_icis.ics_bs_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_bs_prmt.ics_bs_prmt_id
             , ics_bs_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_BS_PRMT' as ics_module
          FROM ics_flow_icis.ics_bs_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_bs_prmt tbl
                            WHERE tbl.key_hash = ics_bs_prmt.key_hash)) ics_bs_prmt;


/*************************************************************************************************
** ObjectName: cdv_cafo_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cafo_prmt AS 
SELECT DISTINCT ics_module
, ics_cafo_prmt.key_hash
     , CASE ics_cafo_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cafo_prmt tbl
                  WHERE tbl.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_cafo_prmt tbl
                  WHERE tbl.ics_cafo_prmt_id = ics_cafo_prmt.ics_cafo_prmt_id)
       END AS module_ident
     , ics_cafo_prmt.action_type
     , ics_cafo_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cafo_prmt.ics_cafo_prmt_id
			 , ics_cafo_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CAFO_PRMT' as ics_module
          FROM ics_cafo_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cafo_prmt tbl
                            WHERE tbl.key_hash = ics_cafo_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cafo_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CAFO_PRMT' as ics_module
          FROM ics_cafo_prmt local
          JOIN ics_flow_icis.ics_cafo_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_cafo_prmt.ics_cafo_prmt_id
             , ics_cafo_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CAFO_PRMT' as ics_module
          FROM ics_flow_icis.ics_cafo_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cafo_prmt tbl
                            WHERE tbl.key_hash = ics_cafo_prmt.key_hash)) ics_cafo_prmt;


/*************************************************************************************************
** ObjectName: cdv_cso_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cso_prmt AS 
SELECT DISTINCT ics_module
, ics_cso_prmt.key_hash
     , CASE ics_cso_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cso_prmt tbl
                  WHERE tbl.ics_cso_prmt_id = ics_cso_prmt.ics_cso_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_cso_prmt tbl
                  WHERE tbl.ics_cso_prmt_id = ics_cso_prmt.ics_cso_prmt_id)
       END AS module_ident
     , ics_cso_prmt.action_type
     , ics_cso_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cso_prmt.ics_cso_prmt_id
			 , ics_cso_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CSO_PRMT' as ics_module
          FROM ics_cso_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cso_prmt tbl
                            WHERE tbl.key_hash = ics_cso_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cso_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CSO_PRMT' as ics_module
          FROM ics_cso_prmt local
          JOIN ics_flow_icis.ics_cso_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_cso_prmt.ics_cso_prmt_id
             , ics_cso_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CSO_PRMT' as ics_module
          FROM ics_flow_icis.ics_cso_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cso_prmt tbl
                            WHERE tbl.key_hash = ics_cso_prmt.key_hash)) ics_cso_prmt;


/*************************************************************************************************
** ObjectName: cdv_cmpl_mon
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cmpl_mon AS 
SELECT DISTINCT ics_module
, ics_cmpl_mon.key_hash
     , CASE ics_cmpl_mon.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cmpl_mon tbl
                  WHERE tbl.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id)
           ELSE (SELECT key_hash 
                   FROM ics_cmpl_mon tbl
                  WHERE tbl.ics_cmpl_mon_id = ics_cmpl_mon.ics_cmpl_mon_id)
       END AS module_ident
     , ics_cmpl_mon.action_type
     , ics_cmpl_mon.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cmpl_mon.ics_cmpl_mon_id
			 , ics_cmpl_mon.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CMPL_MON' as ics_module
          FROM ics_cmpl_mon
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cmpl_mon tbl
                            WHERE tbl.key_hash = ics_cmpl_mon.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cmpl_mon_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CMPL_MON' as ics_module
          FROM ics_cmpl_mon local
          JOIN ics_flow_icis.ics_cmpl_mon icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_cmpl_mon.ics_cmpl_mon_id
             , ics_cmpl_mon.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CMPL_MON' as ics_module
          FROM ics_flow_icis.ics_cmpl_mon
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cmpl_mon tbl
                            WHERE tbl.key_hash = ics_cmpl_mon.key_hash)) ics_cmpl_mon;


/*************************************************************************************************
** ObjectName: cdv_gnrl_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_gnrl_prmt AS 
SELECT DISTINCT ics_module
, ics_gnrl_prmt.key_hash
     , CASE ics_gnrl_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_gnrl_prmt tbl
                  WHERE tbl.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_gnrl_prmt tbl
                  WHERE tbl.ics_gnrl_prmt_id = ics_gnrl_prmt.ics_gnrl_prmt_id)
       END AS module_ident
     , ics_gnrl_prmt.action_type
     , ics_gnrl_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
			 , ics_gnrl_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_GNRL_PRMT' as ics_module
          FROM ics_gnrl_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_gnrl_prmt tbl
                            WHERE tbl.key_hash = ics_gnrl_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_gnrl_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_GNRL_PRMT' as ics_module
          FROM ics_gnrl_prmt local
          JOIN ics_flow_icis.ics_gnrl_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_gnrl_prmt.ics_gnrl_prmt_id
             , ics_gnrl_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_GNRL_PRMT' as ics_module
          FROM ics_flow_icis.ics_gnrl_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_gnrl_prmt tbl
                            WHERE tbl.key_hash = ics_gnrl_prmt.key_hash)) ics_gnrl_prmt;


/*************************************************************************************************
** ObjectName: cdv_master_gnrl_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_master_gnrl_prmt AS 
SELECT DISTINCT ics_module
, ics_master_gnrl_prmt.key_hash
     , CASE ics_master_gnrl_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_master_gnrl_prmt tbl
                  WHERE tbl.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_master_gnrl_prmt tbl
                  WHERE tbl.ics_master_gnrl_prmt_id = ics_master_gnrl_prmt.ics_master_gnrl_prmt_id)
       END AS module_ident
     , ics_master_gnrl_prmt.action_type
     , ics_master_gnrl_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
			 , ics_master_gnrl_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_MASTER_GNRL_PRMT' as ics_module
          FROM ics_master_gnrl_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_master_gnrl_prmt tbl
                            WHERE tbl.key_hash = ics_master_gnrl_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_master_gnrl_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_MASTER_GNRL_PRMT' as ics_module
          FROM ics_master_gnrl_prmt local
          JOIN ics_flow_icis.ics_master_gnrl_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_master_gnrl_prmt.ics_master_gnrl_prmt_id
             , ics_master_gnrl_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_MASTER_GNRL_PRMT' as ics_module
          FROM ics_flow_icis.ics_master_gnrl_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_master_gnrl_prmt tbl
                            WHERE tbl.key_hash = ics_master_gnrl_prmt.key_hash)) ics_master_gnrl_prmt;


/*************************************************************************************************
** ObjectName: cdv_prmt_reissu
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_prmt_reissu AS 
SELECT DISTINCT ics_module
, ics_prmt_reissu.key_hash
     , CASE ics_prmt_reissu.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_prmt_reissu tbl
                  WHERE tbl.ics_prmt_reissu_id = ics_prmt_reissu.ics_prmt_reissu_id)
           ELSE (SELECT key_hash 
                   FROM ics_prmt_reissu tbl
                  WHERE tbl.ics_prmt_reissu_id = ics_prmt_reissu.ics_prmt_reissu_id)
       END AS module_ident
     , ics_prmt_reissu.action_type
     , ics_prmt_reissu.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_prmt_reissu.ics_prmt_reissu_id
			 , ics_prmt_reissu.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRMT_REISSU' as ics_module
          FROM ics_prmt_reissu
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_prmt_reissu tbl
                            WHERE tbl.key_hash = ics_prmt_reissu.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_prmt_reissu_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRMT_REISSU' as ics_module
          FROM ics_prmt_reissu local
          JOIN ics_flow_icis.ics_prmt_reissu icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_prmt_reissu.ics_prmt_reissu_id
             , ics_prmt_reissu.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRMT_REISSU' as ics_module
          FROM ics_flow_icis.ics_prmt_reissu
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_prmt_reissu tbl
                            WHERE tbl.key_hash = ics_prmt_reissu.key_hash)) ics_prmt_reissu;


/*************************************************************************************************
** ObjectName: cdv_prmt_term
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_prmt_term AS 
SELECT DISTINCT ics_module
, ics_prmt_term.key_hash
     , CASE ics_prmt_term.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_prmt_term tbl
                  WHERE tbl.ics_prmt_term_id = ics_prmt_term.ics_prmt_term_id)
           ELSE (SELECT key_hash 
                   FROM ics_prmt_term tbl
                  WHERE tbl.ics_prmt_term_id = ics_prmt_term.ics_prmt_term_id)
       END AS module_ident
     , ics_prmt_term.action_type
     , ics_prmt_term.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_prmt_term.ics_prmt_term_id
			 , ics_prmt_term.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRMT_TERM' as ics_module
          FROM ics_prmt_term
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_prmt_term tbl
                            WHERE tbl.key_hash = ics_prmt_term.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_prmt_term_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRMT_TERM' as ics_module
          FROM ics_prmt_term local
          JOIN ics_flow_icis.ics_prmt_term icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_prmt_term.ics_prmt_term_id
             , ics_prmt_term.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRMT_TERM' as ics_module
          FROM ics_flow_icis.ics_prmt_term
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_prmt_term tbl
                            WHERE tbl.key_hash = ics_prmt_term.key_hash)) ics_prmt_term;


/*************************************************************************************************
** ObjectName: cdv_prmt_track_evt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_prmt_track_evt AS 
SELECT DISTINCT ics_module
, ics_prmt_track_evt.key_hash
     , CASE ics_prmt_track_evt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_prmt_track_evt tbl
                  WHERE tbl.ics_prmt_track_evt_id = ics_prmt_track_evt.ics_prmt_track_evt_id)
           ELSE (SELECT key_hash 
                   FROM ics_prmt_track_evt tbl
                  WHERE tbl.ics_prmt_track_evt_id = ics_prmt_track_evt.ics_prmt_track_evt_id)
       END AS module_ident
     , ics_prmt_track_evt.action_type
     , ics_prmt_track_evt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_prmt_track_evt.ics_prmt_track_evt_id
			 , ics_prmt_track_evt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRMT_TRACK_EVT' as ics_module
          FROM ics_prmt_track_evt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_prmt_track_evt tbl
                            WHERE tbl.key_hash = ics_prmt_track_evt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_prmt_track_evt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRMT_TRACK_EVT' as ics_module
          FROM ics_prmt_track_evt local
          JOIN ics_flow_icis.ics_prmt_track_evt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_prmt_track_evt.ics_prmt_track_evt_id
             , ics_prmt_track_evt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRMT_TRACK_EVT' as ics_module
          FROM ics_flow_icis.ics_prmt_track_evt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_prmt_track_evt tbl
                            WHERE tbl.key_hash = ics_prmt_track_evt.key_hash)) ics_prmt_track_evt;


/*************************************************************************************************
** ObjectName: cdv_potw_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_potw_prmt AS 
SELECT DISTINCT ics_module
, ics_potw_prmt.key_hash
     , CASE ics_potw_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_potw_prmt tbl
                  WHERE tbl.ics_potw_prmt_id = ics_potw_prmt.ics_potw_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_potw_prmt tbl
                  WHERE tbl.ics_potw_prmt_id = ics_potw_prmt.ics_potw_prmt_id)
       END AS module_ident
     , ics_potw_prmt.action_type
     , ics_potw_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_potw_prmt.ics_potw_prmt_id
			 , ics_potw_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_POTW_PRMT' as ics_module
          FROM ics_potw_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_potw_prmt tbl
                            WHERE tbl.key_hash = ics_potw_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_potw_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_POTW_PRMT' as ics_module
          FROM ics_potw_prmt local
          JOIN ics_flow_icis.ics_potw_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_potw_prmt.ics_potw_prmt_id
             , ics_potw_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_POTW_PRMT' as ics_module
          FROM ics_flow_icis.ics_potw_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_potw_prmt tbl
                            WHERE tbl.key_hash = ics_potw_prmt.key_hash)) ics_potw_prmt;


/*************************************************************************************************
** ObjectName: cdv_pretr_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_pretr_prmt AS 
SELECT DISTINCT ics_module
, ics_pretr_prmt.key_hash
     , CASE ics_pretr_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_pretr_prmt tbl
                  WHERE tbl.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_pretr_prmt tbl
                  WHERE tbl.ics_pretr_prmt_id = ics_pretr_prmt.ics_pretr_prmt_id)
       END AS module_ident
     , ics_pretr_prmt.action_type
     , ics_pretr_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_pretr_prmt.ics_pretr_prmt_id
			 , ics_pretr_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRETR_PRMT' as ics_module
          FROM ics_pretr_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_pretr_prmt tbl
                            WHERE tbl.key_hash = ics_pretr_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_pretr_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRETR_PRMT' as ics_module
          FROM ics_pretr_prmt local
          JOIN ics_flow_icis.ics_pretr_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_pretr_prmt.ics_pretr_prmt_id
             , ics_pretr_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRETR_PRMT' as ics_module
          FROM ics_flow_icis.ics_pretr_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_pretr_prmt tbl
                            WHERE tbl.key_hash = ics_pretr_prmt.key_hash)) ics_pretr_prmt;


/*************************************************************************************************
** ObjectName: cdv_sw_cnst_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sw_cnst_prmt AS 
SELECT DISTINCT ics_module
, ics_sw_cnst_prmt.key_hash
     , CASE ics_sw_cnst_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sw_cnst_prmt tbl
                  WHERE tbl.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_sw_cnst_prmt tbl
                  WHERE tbl.ics_sw_cnst_prmt_id = ics_sw_cnst_prmt.ics_sw_cnst_prmt_id)
       END AS module_ident
     , ics_sw_cnst_prmt.action_type
     , ics_sw_cnst_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
			 , ics_sw_cnst_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SW_CNST_PRMT' as ics_module
          FROM ics_sw_cnst_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sw_cnst_prmt tbl
                            WHERE tbl.key_hash = ics_sw_cnst_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sw_cnst_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SW_CNST_PRMT' as ics_module
          FROM ics_sw_cnst_prmt local
          JOIN ics_flow_icis.ics_sw_cnst_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_sw_cnst_prmt.ics_sw_cnst_prmt_id
             , ics_sw_cnst_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SW_CNST_PRMT' as ics_module
          FROM ics_flow_icis.ics_sw_cnst_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sw_cnst_prmt tbl
                            WHERE tbl.key_hash = ics_sw_cnst_prmt.key_hash)) ics_sw_cnst_prmt;


/*************************************************************************************************
** ObjectName: cdv_sw_indst_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sw_indst_prmt AS 
SELECT DISTINCT ics_module
, ics_sw_indst_prmt.key_hash
     , CASE ics_sw_indst_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sw_indst_prmt tbl
                  WHERE tbl.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_sw_indst_prmt tbl
                  WHERE tbl.ics_sw_indst_prmt_id = ics_sw_indst_prmt.ics_sw_indst_prmt_id)
       END AS module_ident
     , ics_sw_indst_prmt.action_type
     , ics_sw_indst_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
			 , ics_sw_indst_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SW_INDST_PRMT' as ics_module
          FROM ics_sw_indst_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sw_indst_prmt tbl
                            WHERE tbl.key_hash = ics_sw_indst_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sw_indst_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SW_INDST_PRMT' as ics_module
          FROM ics_sw_indst_prmt local
          JOIN ics_flow_icis.ics_sw_indst_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_sw_indst_prmt.ics_sw_indst_prmt_id
             , ics_sw_indst_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SW_INDST_PRMT' as ics_module
          FROM ics_flow_icis.ics_sw_indst_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sw_indst_prmt tbl
                            WHERE tbl.key_hash = ics_sw_indst_prmt.key_hash)) ics_sw_indst_prmt;


/*************************************************************************************************
** ObjectName: cdv_swms_4_large_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_swms_4_large_prmt AS 
SELECT DISTINCT ics_module
, ics_swms_4_large_prmt.key_hash
     , CASE ics_swms_4_large_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_swms_4_large_prmt tbl
                  WHERE tbl.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_swms_4_large_prmt tbl
                  WHERE tbl.ics_swms_4_large_prmt_id = ics_swms_4_large_prmt.ics_swms_4_large_prmt_id)
       END AS module_ident
     , ics_swms_4_large_prmt.action_type
     , ics_swms_4_large_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
			 , ics_swms_4_large_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SWMS_4_LARGE_PRMT' as ics_module
          FROM ics_swms_4_large_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_swms_4_large_prmt tbl
                            WHERE tbl.key_hash = ics_swms_4_large_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_swms_4_large_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SWMS_4_LARGE_PRMT' as ics_module
          FROM ics_swms_4_large_prmt local
          JOIN ics_flow_icis.ics_swms_4_large_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_swms_4_large_prmt.ics_swms_4_large_prmt_id
             , ics_swms_4_large_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SWMS_4_LARGE_PRMT' as ics_module
          FROM ics_flow_icis.ics_swms_4_large_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_swms_4_large_prmt tbl
                            WHERE tbl.key_hash = ics_swms_4_large_prmt.key_hash)) ics_swms_4_large_prmt;


/*************************************************************************************************
** ObjectName: cdv_swms_4_small_prmt
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_swms_4_small_prmt AS 
SELECT DISTINCT ics_module
, ics_swms_4_small_prmt.key_hash
     , CASE ics_swms_4_small_prmt.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_swms_4_small_prmt tbl
                  WHERE tbl.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id)
           ELSE (SELECT key_hash 
                   FROM ics_swms_4_small_prmt tbl
                  WHERE tbl.ics_swms_4_small_prmt_id = ics_swms_4_small_prmt.ics_swms_4_small_prmt_id)
       END AS module_ident
     , ics_swms_4_small_prmt.action_type
     , ics_swms_4_small_prmt.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
			 , ics_swms_4_small_prmt.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SWMS_4_SMALL_PRMT' as ics_module
          FROM ics_swms_4_small_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_swms_4_small_prmt tbl
                            WHERE tbl.key_hash = ics_swms_4_small_prmt.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_swms_4_small_prmt_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SWMS_4_SMALL_PRMT' as ics_module
          FROM ics_swms_4_small_prmt local
          JOIN ics_flow_icis.ics_swms_4_small_prmt icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_swms_4_small_prmt.ics_swms_4_small_prmt_id
             , ics_swms_4_small_prmt.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SWMS_4_SMALL_PRMT' as ics_module
          FROM ics_flow_icis.ics_swms_4_small_prmt
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_swms_4_small_prmt tbl
                            WHERE tbl.key_hash = ics_swms_4_small_prmt.key_hash)) ics_swms_4_small_prmt;


/*************************************************************************************************
** ObjectName: cdv_unprmt_fac
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_unprmt_fac AS 
SELECT DISTINCT ics_module
, ics_unprmt_fac.key_hash
     , CASE ics_unprmt_fac.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_unprmt_fac tbl
                  WHERE tbl.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id)
           ELSE (SELECT key_hash 
                   FROM ics_unprmt_fac tbl
                  WHERE tbl.ics_unprmt_fac_id = ics_unprmt_fac.ics_unprmt_fac_id)
       END AS module_ident
     , ics_unprmt_fac.action_type
     , ics_unprmt_fac.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_unprmt_fac.ics_unprmt_fac_id
			 , ics_unprmt_fac.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_UNPRMT_FAC' as ics_module
          FROM ics_unprmt_fac
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_unprmt_fac tbl
                            WHERE tbl.key_hash = ics_unprmt_fac.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_unprmt_fac_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_UNPRMT_FAC' as ics_module
          FROM ics_unprmt_fac local
          JOIN ics_flow_icis.ics_unprmt_fac icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_unprmt_fac.ics_unprmt_fac_id
             , ics_unprmt_fac.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_UNPRMT_FAC' as ics_module
          FROM ics_flow_icis.ics_unprmt_fac
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_unprmt_fac tbl
                            WHERE tbl.key_hash = ics_unprmt_fac.key_hash)) ics_unprmt_fac;


/*************************************************************************************************
** ObjectName: cdv_hist_prmt_schd_evts
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_hist_prmt_schd_evts AS 
SELECT DISTINCT ics_module
, ics_hist_prmt_schd_evts.key_hash
     , CASE ics_hist_prmt_schd_evts.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_hist_prmt_schd_evts tbl
                  WHERE tbl.ics_hist_prmt_schd_evts_id = ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id)
           ELSE (SELECT key_hash 
                   FROM ics_hist_prmt_schd_evts tbl
                  WHERE tbl.ics_hist_prmt_schd_evts_id = ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id)
       END AS module_ident
     , ics_hist_prmt_schd_evts.action_type
     , ics_hist_prmt_schd_evts.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id
			 , ics_hist_prmt_schd_evts.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_HIST_PRMT_SCHD_EVTS' as ics_module
          FROM ics_hist_prmt_schd_evts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_hist_prmt_schd_evts tbl
                            WHERE tbl.key_hash = ics_hist_prmt_schd_evts.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_hist_prmt_schd_evts_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_HIST_PRMT_SCHD_EVTS' as ics_module
          FROM ics_hist_prmt_schd_evts local
          JOIN ics_flow_icis.ics_hist_prmt_schd_evts icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_hist_prmt_schd_evts.ics_hist_prmt_schd_evts_id
             , ics_hist_prmt_schd_evts.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_HIST_PRMT_SCHD_EVTS' as ics_module
          FROM ics_flow_icis.ics_hist_prmt_schd_evts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_hist_prmt_schd_evts tbl
                            WHERE tbl.key_hash = ics_hist_prmt_schd_evts.key_hash)) ics_hist_prmt_schd_evts;


/*************************************************************************************************
** ObjectName: cdv_narr_cond_schd
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_narr_cond_schd AS 
SELECT DISTINCT ics_module
, ics_narr_cond_schd.key_hash
     , CASE ics_narr_cond_schd.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_narr_cond_schd tbl
                  WHERE tbl.ics_narr_cond_schd_id = ics_narr_cond_schd.ics_narr_cond_schd_id)
           ELSE (SELECT key_hash 
                   FROM ics_narr_cond_schd tbl
                  WHERE tbl.ics_narr_cond_schd_id = ics_narr_cond_schd.ics_narr_cond_schd_id)
       END AS module_ident
     , ics_narr_cond_schd.action_type
     , ics_narr_cond_schd.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_narr_cond_schd.ics_narr_cond_schd_id
			 , ics_narr_cond_schd.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_NARR_COND_SCHD' as ics_module
          FROM ics_narr_cond_schd
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_narr_cond_schd tbl
                            WHERE tbl.key_hash = ics_narr_cond_schd.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_narr_cond_schd_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_NARR_COND_SCHD' as ics_module
          FROM ics_narr_cond_schd local
          JOIN ics_flow_icis.ics_narr_cond_schd icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_narr_cond_schd.ics_narr_cond_schd_id
             , ics_narr_cond_schd.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_NARR_COND_SCHD' as ics_module
          FROM ics_flow_icis.ics_narr_cond_schd
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_narr_cond_schd tbl
                            WHERE tbl.key_hash = ics_narr_cond_schd.key_hash)) ics_narr_cond_schd;


/*************************************************************************************************
** ObjectName: cdv_prmt_featr
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_prmt_featr AS 
SELECT DISTINCT ics_module
, ics_prmt_featr.key_hash
     , CASE ics_prmt_featr.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_prmt_featr tbl
                  WHERE tbl.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id)
           ELSE (SELECT key_hash 
                   FROM ics_prmt_featr tbl
                  WHERE tbl.ics_prmt_featr_id = ics_prmt_featr.ics_prmt_featr_id)
       END AS module_ident
     , ics_prmt_featr.action_type
     , ics_prmt_featr.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_prmt_featr.ics_prmt_featr_id
			 , ics_prmt_featr.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRMT_FEATR' as ics_module
          FROM ics_prmt_featr
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_prmt_featr tbl
                            WHERE tbl.key_hash = ics_prmt_featr.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_prmt_featr_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRMT_FEATR' as ics_module
          FROM ics_prmt_featr local
          JOIN ics_flow_icis.ics_prmt_featr icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_prmt_featr.ics_prmt_featr_id
             , ics_prmt_featr.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRMT_FEATR' as ics_module
          FROM ics_flow_icis.ics_prmt_featr
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_prmt_featr tbl
                            WHERE tbl.key_hash = ics_prmt_featr.key_hash)) ics_prmt_featr;


/*************************************************************************************************
** ObjectName: cdv_lmt_set
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_lmt_set AS 
SELECT DISTINCT ics_module
, ics_lmt_set.key_hash
     , CASE ics_lmt_set.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_lmt_set tbl
                  WHERE tbl.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id)
           ELSE (SELECT key_hash 
                   FROM ics_lmt_set tbl
                  WHERE tbl.ics_lmt_set_id = ics_lmt_set.ics_lmt_set_id)
       END AS module_ident
     , ics_lmt_set.action_type
     , ics_lmt_set.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_lmt_set.ics_lmt_set_id
			 , ics_lmt_set.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_LMT_SET' as ics_module
          FROM ics_lmt_set
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_lmt_set tbl
                            WHERE tbl.key_hash = ics_lmt_set.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_lmt_set_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_LMT_SET' as ics_module
          FROM ics_lmt_set local
          JOIN ics_flow_icis.ics_lmt_set icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_lmt_set.ics_lmt_set_id
             , ics_lmt_set.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_LMT_SET' as ics_module
          FROM ics_flow_icis.ics_lmt_set
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_lmt_set tbl
                            WHERE tbl.key_hash = ics_lmt_set.key_hash)) ics_lmt_set;


/*************************************************************************************************
** ObjectName: cdv_lmts
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_lmts AS 
SELECT DISTINCT ics_module
, ics_lmts.key_hash
     , CASE ics_lmts.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_lmts tbl
                  WHERE tbl.ics_lmts_id = ics_lmts.ics_lmts_id)
           ELSE (SELECT key_hash 
                   FROM ics_lmts tbl
                  WHERE tbl.ics_lmts_id = ics_lmts.ics_lmts_id)
       END AS module_ident
     , ics_lmts.action_type
     , ics_lmts.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_lmts.ics_lmts_id
			 , ics_lmts.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_LMTS' as ics_module
          FROM ics_lmts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_lmts tbl
                            WHERE tbl.key_hash = ics_lmts.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_lmts_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_LMTS' as ics_module
          FROM ics_lmts local
          JOIN ics_flow_icis.ics_lmts icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_lmts.ics_lmts_id
             , ics_lmts.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_LMTS' as ics_module
          FROM ics_flow_icis.ics_lmts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_lmts tbl
                            WHERE tbl.key_hash = ics_lmts.key_hash)) ics_lmts;


/*************************************************************************************************
** ObjectName: cdv_param_lmts
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_param_lmts AS 
SELECT DISTINCT ics_module
, ics_param_lmts.key_hash
     , CASE ics_param_lmts.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_param_lmts tbl
                  WHERE tbl.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id)
           ELSE (SELECT key_hash 
                   FROM ics_param_lmts tbl
                  WHERE tbl.ics_param_lmts_id = ics_param_lmts.ics_param_lmts_id)
       END AS module_ident
     , ics_param_lmts.action_type
     , ics_param_lmts.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_param_lmts.ics_param_lmts_id
			 , ics_param_lmts.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PARAM_LMTS' as ics_module
          FROM ics_param_lmts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_param_lmts tbl
                            WHERE tbl.key_hash = ics_param_lmts.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_param_lmts_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PARAM_LMTS' as ics_module
          FROM ics_param_lmts local
          JOIN ics_flow_icis.ics_param_lmts icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_param_lmts.ics_param_lmts_id
             , ics_param_lmts.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PARAM_LMTS' as ics_module
          FROM ics_flow_icis.ics_param_lmts
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_param_lmts tbl
                            WHERE tbl.key_hash = ics_param_lmts.key_hash)) ics_param_lmts;


/*************************************************************************************************
** ObjectName: cdv_dsch_mon_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_dsch_mon_rep AS 
SELECT DISTINCT ics_module
, ics_dsch_mon_rep.key_hash
     , CASE ics_dsch_mon_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_dsch_mon_rep tbl
                  WHERE tbl.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_dsch_mon_rep tbl
                  WHERE tbl.ics_dsch_mon_rep_id = ics_dsch_mon_rep.ics_dsch_mon_rep_id)
       END AS module_ident
     , ics_dsch_mon_rep.action_type
     , ics_dsch_mon_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
			 , ics_dsch_mon_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_DSCH_MON_REP' as ics_module
          FROM ics_dsch_mon_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_dsch_mon_rep tbl
                            WHERE tbl.key_hash = ics_dsch_mon_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_dsch_mon_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_DSCH_MON_REP' as ics_module
          FROM ics_dsch_mon_rep local
          JOIN ics_flow_icis.ics_dsch_mon_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_dsch_mon_rep.ics_dsch_mon_rep_id
             , ics_dsch_mon_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_DSCH_MON_REP' as ics_module
          FROM ics_flow_icis.ics_dsch_mon_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_dsch_mon_rep tbl
                            WHERE tbl.key_hash = ics_dsch_mon_rep.key_hash)) ics_dsch_mon_rep;


/*************************************************************************************************
** ObjectName: cdv_sngl_evt_viol
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sngl_evt_viol AS 
SELECT DISTINCT ics_module
, ics_sngl_evt_viol.key_hash
     , CASE ics_sngl_evt_viol.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sngl_evt_viol tbl
                  WHERE tbl.ics_sngl_evt_viol_id = ics_sngl_evt_viol.ics_sngl_evt_viol_id)
           ELSE (SELECT key_hash 
                   FROM ics_sngl_evt_viol tbl
                  WHERE tbl.ics_sngl_evt_viol_id = ics_sngl_evt_viol.ics_sngl_evt_viol_id)
       END AS module_ident
     , ics_sngl_evt_viol.action_type
     , ics_sngl_evt_viol.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sngl_evt_viol.ics_sngl_evt_viol_id
			 , ics_sngl_evt_viol.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SNGL_EVT_VIOL' as ics_module
          FROM ics_sngl_evt_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sngl_evt_viol tbl
                            WHERE tbl.key_hash = ics_sngl_evt_viol.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sngl_evt_viol_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SNGL_EVT_VIOL' as ics_module
          FROM ics_sngl_evt_viol local
          JOIN ics_flow_icis.ics_sngl_evt_viol icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_sngl_evt_viol.ics_sngl_evt_viol_id
             , ics_sngl_evt_viol.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SNGL_EVT_VIOL' as ics_module
          FROM ics_flow_icis.ics_sngl_evt_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sngl_evt_viol tbl
                            WHERE tbl.key_hash = ics_sngl_evt_viol.key_hash)) ics_sngl_evt_viol;


/*************************************************************************************************
** ObjectName: cdv_cmpl_schd
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cmpl_schd AS 
SELECT DISTINCT ics_module
, ics_cmpl_schd.key_hash
     , CASE ics_cmpl_schd.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cmpl_schd tbl
                  WHERE tbl.ics_cmpl_schd_id = ics_cmpl_schd.ics_cmpl_schd_id)
           ELSE (SELECT key_hash 
                   FROM ics_cmpl_schd tbl
                  WHERE tbl.ics_cmpl_schd_id = ics_cmpl_schd.ics_cmpl_schd_id)
       END AS module_ident
     , ics_cmpl_schd.action_type
     , ics_cmpl_schd.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cmpl_schd.ics_cmpl_schd_id
			 , ics_cmpl_schd.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CMPL_SCHD' as ics_module
          FROM ics_cmpl_schd
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cmpl_schd tbl
                            WHERE tbl.key_hash = ics_cmpl_schd.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cmpl_schd_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CMPL_SCHD' as ics_module
          FROM ics_cmpl_schd local
          JOIN ics_flow_icis.ics_cmpl_schd icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_cmpl_schd.ics_cmpl_schd_id
             , ics_cmpl_schd.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CMPL_SCHD' as ics_module
          FROM ics_flow_icis.ics_cmpl_schd
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cmpl_schd tbl
                            WHERE tbl.key_hash = ics_cmpl_schd.key_hash)) ics_cmpl_schd;


/*************************************************************************************************
** ObjectName: cdv_dmr_viol
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_dmr_viol AS 
SELECT DISTINCT ics_module
, ics_dmr_viol.key_hash
     , CASE ics_dmr_viol.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_dmr_viol tbl
                  WHERE tbl.ics_dmr_viol_id = ics_dmr_viol.ics_dmr_viol_id)
           ELSE (SELECT key_hash 
                   FROM ics_dmr_viol tbl
                  WHERE tbl.ics_dmr_viol_id = ics_dmr_viol.ics_dmr_viol_id)
       END AS module_ident
     , ics_dmr_viol.action_type
     , ics_dmr_viol.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_dmr_viol.ics_dmr_viol_id
			 , ics_dmr_viol.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_DMR_VIOL' as ics_module
          FROM ics_dmr_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_dmr_viol tbl
                            WHERE tbl.key_hash = ics_dmr_viol.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_dmr_viol_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_DMR_VIOL' as ics_module
          FROM ics_dmr_viol local
          JOIN ics_flow_icis.ics_dmr_viol icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_dmr_viol.ics_dmr_viol_id
             , ics_dmr_viol.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_DMR_VIOL' as ics_module
          FROM ics_flow_icis.ics_dmr_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_dmr_viol tbl
                            WHERE tbl.key_hash = ics_dmr_viol.key_hash)) ics_dmr_viol;


/*************************************************************************************************
** ObjectName: cdv_efflu_trade_prtner
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_efflu_trade_prtner AS 
SELECT DISTINCT ics_module
, ics_efflu_trade_prtner.key_hash
     , CASE ics_efflu_trade_prtner.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_efflu_trade_prtner tbl
                  WHERE tbl.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id)
           ELSE (SELECT key_hash 
                   FROM ics_efflu_trade_prtner tbl
                  WHERE tbl.ics_efflu_trade_prtner_id = ics_efflu_trade_prtner.ics_efflu_trade_prtner_id)
       END AS module_ident
     , ics_efflu_trade_prtner.action_type
     , ics_efflu_trade_prtner.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
			 , ics_efflu_trade_prtner.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_EFFLU_TRADE_PRTNER' as ics_module
          FROM ics_efflu_trade_prtner
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_efflu_trade_prtner tbl
                            WHERE tbl.key_hash = ics_efflu_trade_prtner.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_efflu_trade_prtner_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_EFFLU_TRADE_PRTNER' as ics_module
          FROM ics_efflu_trade_prtner local
          JOIN ics_flow_icis.ics_efflu_trade_prtner icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_efflu_trade_prtner.ics_efflu_trade_prtner_id
             , ics_efflu_trade_prtner.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_EFFLU_TRADE_PRTNER' as ics_module
          FROM ics_flow_icis.ics_efflu_trade_prtner
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_efflu_trade_prtner tbl
                            WHERE tbl.key_hash = ics_efflu_trade_prtner.key_hash)) ics_efflu_trade_prtner;


/*************************************************************************************************
** ObjectName: cdv_frml_enfrc_actn
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_frml_enfrc_actn AS 
SELECT DISTINCT ics_module
, ics_frml_enfrc_actn.key_hash
     , CASE ics_frml_enfrc_actn.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_frml_enfrc_actn tbl
                  WHERE tbl.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id)
           ELSE (SELECT key_hash 
                   FROM ics_frml_enfrc_actn tbl
                  WHERE tbl.ics_frml_enfrc_actn_id = ics_frml_enfrc_actn.ics_frml_enfrc_actn_id)
       END AS module_ident
     , ics_frml_enfrc_actn.action_type
     , ics_frml_enfrc_actn.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
			 , ics_frml_enfrc_actn.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_FRML_ENFRC_ACTN' as ics_module
          FROM ics_frml_enfrc_actn
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_frml_enfrc_actn tbl
                            WHERE tbl.key_hash = ics_frml_enfrc_actn.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_frml_enfrc_actn_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_FRML_ENFRC_ACTN' as ics_module
          FROM ics_frml_enfrc_actn local
          JOIN ics_flow_icis.ics_frml_enfrc_actn icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_frml_enfrc_actn.ics_frml_enfrc_actn_id
             , ics_frml_enfrc_actn.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_FRML_ENFRC_ACTN' as ics_module
          FROM ics_flow_icis.ics_frml_enfrc_actn
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_frml_enfrc_actn tbl
                            WHERE tbl.key_hash = ics_frml_enfrc_actn.key_hash)) ics_frml_enfrc_actn;


/*************************************************************************************************
** ObjectName: cdv_infrml_enfrc_actn
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_infrml_enfrc_actn AS 
SELECT DISTINCT ics_module
, ics_infrml_enfrc_actn.key_hash
     , CASE ics_infrml_enfrc_actn.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_infrml_enfrc_actn tbl
                  WHERE tbl.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id)
           ELSE (SELECT key_hash 
                   FROM ics_infrml_enfrc_actn tbl
                  WHERE tbl.ics_infrml_enfrc_actn_id = ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id)
       END AS module_ident
     , ics_infrml_enfrc_actn.action_type
     , ics_infrml_enfrc_actn.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
			 , ics_infrml_enfrc_actn.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_INFRML_ENFRC_ACTN' as ics_module
          FROM ics_infrml_enfrc_actn
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_infrml_enfrc_actn tbl
                            WHERE tbl.key_hash = ics_infrml_enfrc_actn.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_infrml_enfrc_actn_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_INFRML_ENFRC_ACTN' as ics_module
          FROM ics_infrml_enfrc_actn local
          JOIN ics_flow_icis.ics_infrml_enfrc_actn icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_infrml_enfrc_actn.ics_infrml_enfrc_actn_id
             , ics_infrml_enfrc_actn.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_INFRML_ENFRC_ACTN' as ics_module
          FROM ics_flow_icis.ics_infrml_enfrc_actn
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_infrml_enfrc_actn tbl
                            WHERE tbl.key_hash = ics_infrml_enfrc_actn.key_hash)) ics_infrml_enfrc_actn;


/*************************************************************************************************
** ObjectName: cdv_enfrc_actn_milestone
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_enfrc_actn_milestone AS 
SELECT DISTINCT ics_module
, ics_enfrc_actn_milestone.key_hash
     , CASE ics_enfrc_actn_milestone.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_enfrc_actn_milestone tbl
                  WHERE tbl.ics_enfrc_actn_milestone_id = ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id)
           ELSE (SELECT key_hash 
                   FROM ics_enfrc_actn_milestone tbl
                  WHERE tbl.ics_enfrc_actn_milestone_id = ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id)
       END AS module_ident
     , ics_enfrc_actn_milestone.action_type
     , ics_enfrc_actn_milestone.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id
			 , ics_enfrc_actn_milestone.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_ENFRC_ACTN_MILESTONE' as ics_module
          FROM ics_enfrc_actn_milestone
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_enfrc_actn_milestone tbl
                            WHERE tbl.key_hash = ics_enfrc_actn_milestone.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_enfrc_actn_milestone_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_ENFRC_ACTN_MILESTONE' as ics_module
          FROM ics_enfrc_actn_milestone local
          JOIN ics_flow_icis.ics_enfrc_actn_milestone icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_enfrc_actn_milestone.ics_enfrc_actn_milestone_id
             , ics_enfrc_actn_milestone.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_ENFRC_ACTN_MILESTONE' as ics_module
          FROM ics_flow_icis.ics_enfrc_actn_milestone
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_enfrc_actn_milestone tbl
                            WHERE tbl.key_hash = ics_enfrc_actn_milestone.key_hash)) ics_enfrc_actn_milestone;


/*************************************************************************************************
** ObjectName: cdv_cso_evt_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cso_evt_rep AS 
SELECT DISTINCT ics_module
, ics_cso_evt_rep.key_hash
     , CASE ics_cso_evt_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cso_evt_rep tbl
                  WHERE tbl.ics_cso_evt_rep_id = ics_cso_evt_rep.ics_cso_evt_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_cso_evt_rep tbl
                  WHERE tbl.ics_cso_evt_rep_id = ics_cso_evt_rep.ics_cso_evt_rep_id)
       END AS module_ident
     , ics_cso_evt_rep.action_type
     , ics_cso_evt_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cso_evt_rep.ics_cso_evt_rep_id
			 , ics_cso_evt_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CSO_EVT_REP' as ics_module
          FROM ics_cso_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cso_evt_rep tbl
                            WHERE tbl.key_hash = ics_cso_evt_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cso_evt_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CSO_EVT_REP' as ics_module
          FROM ics_cso_evt_rep local
          JOIN ics_flow_icis.ics_cso_evt_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)  
        UNION
        /*  3 - DELETE  */
        SELECT ics_cso_evt_rep.ics_cso_evt_rep_id
             , ics_cso_evt_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CSO_EVT_REP' as ics_module
          FROM ics_flow_icis.ics_cso_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cso_evt_rep tbl
                            WHERE tbl.key_hash = ics_cso_evt_rep.key_hash)) ics_cso_evt_rep;


/*************************************************************************************************
** ObjectName: cdv_sw_evt_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sw_evt_rep AS 
SELECT DISTINCT ics_module
, ics_sw_evt_rep.key_hash
     , CASE ics_sw_evt_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sw_evt_rep tbl
                  WHERE tbl.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_sw_evt_rep tbl
                  WHERE tbl.ics_sw_evt_rep_id = ics_sw_evt_rep.ics_sw_evt_rep_id)
       END AS module_ident
     , ics_sw_evt_rep.action_type
     , ics_sw_evt_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sw_evt_rep.ics_sw_evt_rep_id
			 , ics_sw_evt_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SW_EVT_REP' as ics_module
          FROM ics_sw_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sw_evt_rep tbl
                            WHERE tbl.key_hash = ics_sw_evt_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sw_evt_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SW_EVT_REP' as ics_module
          FROM ics_sw_evt_rep local
          JOIN ics_flow_icis.ics_sw_evt_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_sw_evt_rep.ics_sw_evt_rep_id
             , ics_sw_evt_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SW_EVT_REP' as ics_module
          FROM ics_flow_icis.ics_sw_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sw_evt_rep tbl
                            WHERE tbl.key_hash = ics_sw_evt_rep.key_hash)) ics_sw_evt_rep;


/*************************************************************************************************
** ObjectName: cdv_cafo_annul_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cafo_annul_rep AS 
SELECT DISTINCT ics_module
, ics_cafo_annul_rep.key_hash
     , CASE ics_cafo_annul_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cafo_annul_rep tbl
                  WHERE tbl.ics_cafo_annul_rep_id = ics_cafo_annul_rep.ics_cafo_annul_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_cafo_annul_rep tbl
                  WHERE tbl.ics_cafo_annul_rep_id = ics_cafo_annul_rep.ics_cafo_annul_rep_id)
       END AS module_ident
     , ics_cafo_annul_rep.action_type
     , ics_cafo_annul_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cafo_annul_rep.ics_cafo_annul_rep_id
			 , ics_cafo_annul_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CAFO_ANNUL_REP' as ics_module
          FROM ics_cafo_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cafo_annul_rep tbl
                            WHERE tbl.key_hash = ics_cafo_annul_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cafo_annul_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CAFO_ANNUL_REP' as ics_module
          FROM ics_cafo_annul_rep local
          JOIN ics_flow_icis.ics_cafo_annul_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_cafo_annul_rep.ics_cafo_annul_rep_id
             , ics_cafo_annul_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CAFO_ANNUL_REP' as ics_module
          FROM ics_flow_icis.ics_cafo_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cafo_annul_rep tbl
                            WHERE tbl.key_hash = ics_cafo_annul_rep.key_hash)) ics_cafo_annul_rep;


/*************************************************************************************************
** ObjectName: cdv_loc_lmts_prog_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_loc_lmts_prog_rep AS 
SELECT DISTINCT ics_module
, ics_loc_lmts_prog_rep.key_hash
     , CASE ics_loc_lmts_prog_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_loc_lmts_prog_rep tbl
                  WHERE tbl.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_loc_lmts_prog_rep tbl
                  WHERE tbl.ics_loc_lmts_prog_rep_id = ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id)
       END AS module_ident
     , ics_loc_lmts_prog_rep.action_type
     , ics_loc_lmts_prog_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
			 , ics_loc_lmts_prog_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_LOC_LMTS_PROG_REP' as ics_module
          FROM ics_loc_lmts_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_loc_lmts_prog_rep tbl
                            WHERE tbl.key_hash = ics_loc_lmts_prog_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_loc_lmts_prog_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_LOC_LMTS_PROG_REP' as ics_module
          FROM ics_loc_lmts_prog_rep local
          JOIN ics_flow_icis.ics_loc_lmts_prog_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_loc_lmts_prog_rep.ics_loc_lmts_prog_rep_id
             , ics_loc_lmts_prog_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_LOC_LMTS_PROG_REP' as ics_module
          FROM ics_flow_icis.ics_loc_lmts_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_loc_lmts_prog_rep tbl
                            WHERE tbl.key_hash = ics_loc_lmts_prog_rep.key_hash)) ics_loc_lmts_prog_rep;


/*************************************************************************************************
** ObjectName: cdv_pretr_perf_summ
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_pretr_perf_summ AS 
SELECT DISTINCT ics_module
, ics_pretr_perf_summ.key_hash
     , CASE ics_pretr_perf_summ.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_pretr_perf_summ tbl
                  WHERE tbl.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id)
           ELSE (SELECT key_hash 
                   FROM ics_pretr_perf_summ tbl
                  WHERE tbl.ics_pretr_perf_summ_id = ics_pretr_perf_summ.ics_pretr_perf_summ_id)
       END AS module_ident
     , ics_pretr_perf_summ.action_type
     , ics_pretr_perf_summ.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_pretr_perf_summ.ics_pretr_perf_summ_id
			 , ics_pretr_perf_summ.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_PRETR_PERF_SUMM' as ics_module
          FROM ics_pretr_perf_summ
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_pretr_perf_summ tbl
                            WHERE tbl.key_hash = ics_pretr_perf_summ.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_pretr_perf_summ_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_PRETR_PERF_SUMM' as ics_module
          FROM ics_pretr_perf_summ local
          JOIN ics_flow_icis.ics_pretr_perf_summ icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_pretr_perf_summ.ics_pretr_perf_summ_id
             , ics_pretr_perf_summ.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_PRETR_PERF_SUMM' as ics_module
          FROM ics_flow_icis.ics_pretr_perf_summ
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_pretr_perf_summ tbl
                            WHERE tbl.key_hash = ics_pretr_perf_summ.key_hash)) ics_pretr_perf_summ;


/*************************************************************************************************
** ObjectName: cdv_bs_prog_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_bs_prog_rep AS 
SELECT DISTINCT ics_module
, ics_bs_prog_rep.key_hash
     , CASE ics_bs_prog_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_bs_prog_rep tbl
                  WHERE tbl.ics_bs_prog_rep_id = ics_bs_prog_rep.ics_bs_prog_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_bs_prog_rep tbl
                  WHERE tbl.ics_bs_prog_rep_id = ics_bs_prog_rep.ics_bs_prog_rep_id)
       END AS module_ident
     , ics_bs_prog_rep.action_type
     , ics_bs_prog_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_bs_prog_rep.ics_bs_prog_rep_id
			 , ics_bs_prog_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_BS_PROG_REP' as ics_module
          FROM ics_bs_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_bs_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_prog_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_bs_prog_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_BS_PROG_REP' as ics_module
          FROM ics_bs_prog_rep local
          JOIN ics_flow_icis.ics_bs_prog_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_bs_prog_rep.ics_bs_prog_rep_id
             , ics_bs_prog_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_BS_PROG_REP' as ics_module
          FROM ics_flow_icis.ics_bs_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_bs_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_prog_rep.key_hash)) ics_bs_prog_rep;


/*************************************************************************************************
** ObjectName: cdv_sso_annul_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sso_annul_rep AS 
SELECT DISTINCT ics_module
, ics_sso_annul_rep.key_hash
     , CASE ics_sso_annul_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sso_annul_rep tbl
                  WHERE tbl.ics_sso_annul_rep_id = ics_sso_annul_rep.ics_sso_annul_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_sso_annul_rep tbl
                  WHERE tbl.ics_sso_annul_rep_id = ics_sso_annul_rep.ics_sso_annul_rep_id)
       END AS module_ident
     , ics_sso_annul_rep.action_type
     , ics_sso_annul_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sso_annul_rep.ics_sso_annul_rep_id
			 , ics_sso_annul_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SSO_ANNUL_REP' as ics_module
          FROM ics_sso_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sso_annul_rep tbl
                            WHERE tbl.key_hash = ics_sso_annul_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sso_annul_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SSO_ANNUL_REP' as ics_module
          FROM ics_sso_annul_rep local
          JOIN ics_flow_icis.ics_sso_annul_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_sso_annul_rep.ics_sso_annul_rep_id
             , ics_sso_annul_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SSO_ANNUL_REP' as ics_module
          FROM ics_flow_icis.ics_sso_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sso_annul_rep tbl
                            WHERE tbl.key_hash = ics_sso_annul_rep.key_hash)) ics_sso_annul_rep;


/*************************************************************************************************
** ObjectName: cdv_sso_evt_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sso_evt_rep AS 
SELECT DISTINCT ics_module
, ics_sso_evt_rep.key_hash
     , CASE ics_sso_evt_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sso_evt_rep tbl
                  WHERE tbl.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_sso_evt_rep tbl
                  WHERE tbl.ics_sso_evt_rep_id = ics_sso_evt_rep.ics_sso_evt_rep_id)
       END AS module_ident
     , ics_sso_evt_rep.action_type
     , ics_sso_evt_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
			 , ics_sso_evt_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SSO_EVT_REP' as ics_module
          FROM ics_sso_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sso_evt_rep tbl
                            WHERE tbl.key_hash = ics_sso_evt_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sso_evt_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SSO_EVT_REP' as ics_module
          FROM ics_sso_evt_rep local
          JOIN ics_flow_icis.ics_sso_evt_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_sso_evt_rep.ics_sso_evt_rep_id
             , ics_sso_evt_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SSO_EVT_REP' as ics_module
          FROM ics_flow_icis.ics_sso_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sso_evt_rep tbl
                            WHERE tbl.key_hash = ics_sso_evt_rep.key_hash)) ics_sso_evt_rep;


/*************************************************************************************************
** ObjectName: cdv_sso_monthly_evt_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sso_monthly_evt_rep AS 
SELECT DISTINCT ics_module
, ics_sso_monthly_evt_rep.key_hash
     , CASE ics_sso_monthly_evt_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sso_monthly_evt_rep tbl
                  WHERE tbl.ics_sso_monthly_evt_rep_id = ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_sso_monthly_evt_rep tbl
                  WHERE tbl.ics_sso_monthly_evt_rep_id = ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id)
       END AS module_ident
     , ics_sso_monthly_evt_rep.action_type
     , ics_sso_monthly_evt_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id
			 , ics_sso_monthly_evt_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SSO_MONTHLY_EVT_REP' as ics_module
          FROM ics_sso_monthly_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sso_monthly_evt_rep tbl
                            WHERE tbl.key_hash = ics_sso_monthly_evt_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sso_monthly_evt_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SSO_MONTHLY_EVT_REP' as ics_module
          FROM ics_sso_monthly_evt_rep local
          JOIN ics_flow_icis.ics_sso_monthly_evt_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_sso_monthly_evt_rep.ics_sso_monthly_evt_rep_id
             , ics_sso_monthly_evt_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SSO_MONTHLY_EVT_REP' as ics_module
          FROM ics_flow_icis.ics_sso_monthly_evt_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sso_monthly_evt_rep tbl
                            WHERE tbl.key_hash = ics_sso_monthly_evt_rep.key_hash)) ics_sso_monthly_evt_rep;


/*************************************************************************************************
** ObjectName: cdv_swms_4_prog_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_swms_4_prog_rep AS 
SELECT DISTINCT ics_module
, ics_swms_4_prog_rep.key_hash
     , CASE ics_swms_4_prog_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_swms_4_prog_rep tbl
                  WHERE tbl.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_swms_4_prog_rep tbl
                  WHERE tbl.ics_swms_4_prog_rep_id = ics_swms_4_prog_rep.ics_swms_4_prog_rep_id)
       END AS module_ident
     , ics_swms_4_prog_rep.action_type
     , ics_swms_4_prog_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
			 , ics_swms_4_prog_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SWMS_4_PROG_REP' as ics_module
          FROM ics_swms_4_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_swms_4_prog_rep tbl
                            WHERE tbl.key_hash = ics_swms_4_prog_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_swms_4_prog_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SWMS_4_PROG_REP' as ics_module
          FROM ics_swms_4_prog_rep local
          JOIN ics_flow_icis.ics_swms_4_prog_rep icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_swms_4_prog_rep.ics_swms_4_prog_rep_id
             , ics_swms_4_prog_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SWMS_4_PROG_REP' as ics_module
          FROM ics_flow_icis.ics_swms_4_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_swms_4_prog_rep tbl
                            WHERE tbl.key_hash = ics_swms_4_prog_rep.key_hash)) ics_swms_4_prog_rep;


/*************************************************************************************************
** ObjectName: cdv_schd_evt_viol
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_schd_evt_viol AS 
SELECT DISTINCT ics_module
, ics_schd_evt_viol.key_hash
     , CASE ics_schd_evt_viol.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_schd_evt_viol tbl
                  WHERE tbl.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id)
           ELSE (SELECT key_hash 
                   FROM ics_schd_evt_viol tbl
                  WHERE tbl.ics_schd_evt_viol_id = ics_schd_evt_viol.ics_schd_evt_viol_id)
       END AS module_ident
     , ics_schd_evt_viol.action_type
     , ics_schd_evt_viol.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_schd_evt_viol.ics_schd_evt_viol_id
			 , ics_schd_evt_viol.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SCHD_EVT_VIOL' as ics_module
          FROM ics_schd_evt_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_schd_evt_viol tbl
                            WHERE tbl.key_hash = ics_schd_evt_viol.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_schd_evt_viol_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SCHD_EVT_VIOL' as ics_module
          FROM ics_schd_evt_viol local
          JOIN ics_flow_icis.ics_schd_evt_viol icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_schd_evt_viol.ics_schd_evt_viol_id
             , ics_schd_evt_viol.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SCHD_EVT_VIOL' as ics_module
          FROM ics_flow_icis.ics_schd_evt_viol
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_schd_evt_viol tbl
                            WHERE tbl.key_hash = ics_schd_evt_viol.key_hash)) ics_schd_evt_viol;


/*************************************************************************************************
** ObjectName: cdv_cmpl_mon_lnk
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_cmpl_mon_lnk AS 
SELECT DISTINCT ics_module
, ics_cmpl_mon_lnk.key_hash
     , CASE ics_cmpl_mon_lnk.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_cmpl_mon_lnk tbl
                  WHERE tbl.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id)
           ELSE (SELECT key_hash 
                   FROM ics_cmpl_mon_lnk tbl
                  WHERE tbl.ics_cmpl_mon_lnk_id = ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id)
       END AS module_ident
     , ics_cmpl_mon_lnk.action_type
     , ics_cmpl_mon_lnk.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
			 , ics_cmpl_mon_lnk.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_CMPL_MON_LNK' as ics_module
          FROM ics_cmpl_mon_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_cmpl_mon_lnk tbl
                            WHERE tbl.key_hash = ics_cmpl_mon_lnk.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_cmpl_mon_lnk_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_CMPL_MON_LNK' as ics_module
          FROM ics_cmpl_mon_lnk local
          JOIN ics_flow_icis.ics_cmpl_mon_lnk icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_cmpl_mon_lnk.ics_cmpl_mon_lnk_id
             , ics_cmpl_mon_lnk.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_CMPL_MON_LNK' as ics_module
          FROM ics_flow_icis.ics_cmpl_mon_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_cmpl_mon_lnk tbl
                            WHERE tbl.key_hash = ics_cmpl_mon_lnk.key_hash)) ics_cmpl_mon_lnk;


/*************************************************************************************************
** ObjectName: cdv_enfrc_actn_viol_lnk
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_enfrc_actn_viol_lnk AS 
SELECT DISTINCT ics_module
, ics_enfrc_actn_viol_lnk.key_hash
     , CASE ics_enfrc_actn_viol_lnk.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_enfrc_actn_viol_lnk tbl
                  WHERE tbl.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id)
           ELSE (SELECT key_hash 
                   FROM ics_enfrc_actn_viol_lnk tbl
                  WHERE tbl.ics_enfrc_actn_viol_lnk_id = ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id)
       END AS module_ident
     , ics_enfrc_actn_viol_lnk.action_type
     , ics_enfrc_actn_viol_lnk.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
			 , ics_enfrc_actn_viol_lnk.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_ENFRC_ACTN_VIOL_LNK' as ics_module
          FROM ics_enfrc_actn_viol_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_enfrc_actn_viol_lnk tbl
                            WHERE tbl.key_hash = ics_enfrc_actn_viol_lnk.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_enfrc_actn_viol_lnk_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_ENFRC_ACTN_VIOL_LNK' as ics_module
          FROM ics_enfrc_actn_viol_lnk local
          JOIN ics_flow_icis.ics_enfrc_actn_viol_lnk icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_enfrc_actn_viol_lnk.ics_enfrc_actn_viol_lnk_id
             , ics_enfrc_actn_viol_lnk.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_ENFRC_ACTN_VIOL_LNK' as ics_module
          FROM ics_flow_icis.ics_enfrc_actn_viol_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_enfrc_actn_viol_lnk tbl
                            WHERE tbl.key_hash = ics_enfrc_actn_viol_lnk.key_hash)) ics_enfrc_actn_viol_lnk;


/*************************************************************************************************
** ObjectName: cdv_dmr_prog_rep_lnk
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 09/09/2014   Windsor      Created from 4.0 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_dmr_prog_rep_lnk AS 
SELECT DISTINCT ics_module
, ics_dmr_prog_rep_lnk.key_hash
     , CASE ics_dmr_prog_rep_lnk.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_dmr_prog_rep_lnk tbl
                  WHERE tbl.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id)
           ELSE (SELECT key_hash 
                   FROM ics_dmr_prog_rep_lnk tbl
                  WHERE tbl.ics_dmr_prog_rep_lnk_id = ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id)
       END AS module_ident
     , ics_dmr_prog_rep_lnk.action_type
     , ics_dmr_prog_rep_lnk.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
			 , ics_dmr_prog_rep_lnk.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_DMR_PROG_REP_LNK' as ics_module
          FROM ics_dmr_prog_rep_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_dmr_prog_rep_lnk tbl
                            WHERE tbl.key_hash = ics_dmr_prog_rep_lnk.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_dmr_prog_rep_lnk_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_DMR_PROG_REP_LNK' as ics_module
          FROM ics_dmr_prog_rep_lnk local
          JOIN ics_flow_icis.ics_dmr_prog_rep_lnk icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_dmr_prog_rep_lnk.ics_dmr_prog_rep_lnk_id
             , ics_dmr_prog_rep_lnk.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_DMR_PROG_REP_LNK' as ics_module
          FROM ics_flow_icis.ics_dmr_prog_rep_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_dmr_prog_rep_lnk tbl
                            WHERE tbl.key_hash = ics_dmr_prog_rep_lnk.key_hash)) ics_dmr_prog_rep_lnk;


/*************************************************************************************************
** ObjectName: cdv_final_order_viol_lnk
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 9/27/2012    Windsor      Created 
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_final_order_viol_lnk AS 
SELECT DISTINCT ics_module
     , ics_final_order_viol_lnk.key_hash
     , CASE ics_final_order_viol_lnk.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_final_order_viol_lnk tbl
                  WHERE tbl.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id)
           ELSE (SELECT key_hash 
                   FROM ics_final_order_viol_lnk tbl
                  WHERE tbl.ics_final_order_viol_lnk_id = ics_final_order_viol_lnk.ics_final_order_viol_lnk_id)
       END AS module_ident
     , ics_final_order_viol_lnk.action_type
     , ics_final_order_viol_lnk.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             , ics_final_order_viol_lnk.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_FINAL_ORDER_VIOL_LNK' as ics_module
          FROM ics_final_order_viol_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_final_order_viol_lnk tbl
                            WHERE tbl.key_hash = ics_final_order_viol_lnk.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_final_order_viol_lnk_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_FINAL_ORDER_VIOL_LNK' as ics_module
          FROM ics_final_order_viol_lnk local
          JOIN ics_flow_icis.ics_final_order_viol_lnk icis
            ON (    icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_final_order_viol_lnk.ics_final_order_viol_lnk_id
             , ics_final_order_viol_lnk.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_FINAL_ORDER_VIOL_LNK' as ics_module
          FROM ics_flow_icis.ics_final_order_viol_lnk
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_final_order_viol_lnk tbl
                            WHERE tbl.key_hash = ics_final_order_viol_lnk.key_hash)) ics_final_order_viol_lnk;
                            
/*************************************************************************************************
** ObjectName: cdv_sw_indst_annul_rep
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This view identifies data changes within an ICIS module.  This view
**               then drives the database process that sets the appropriate transaction types
**               for each module's key.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 10/10/2014    Windsor     Created from 4.1 baseline.
**
***************************************************************************************************/
CREATE OR REPLACE VIEW cdv_sw_indst_annul_rep AS 
SELECT DISTINCT ics_module
, ics_sw_indst_annul_rep.key_hash
     , CASE ics_sw_indst_annul_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_sw_indst_annul_rep tbl
                  WHERE tbl.ics_sw_indst_annul_rep_id = ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_sw_indst_annul_rep tbl
                  WHERE tbl.ics_sw_indst_annul_rep_id = ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id)
       END AS module_ident
     , ics_sw_indst_annul_rep.action_type
     , ics_sw_indst_annul_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id
    , ics_sw_indst_annul_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_SW_INDST_ANNUL_REP' as ics_module
          FROM ics_sw_indst_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_sw_indst_annul_rep tbl
                            WHERE tbl.key_hash = ics_sw_indst_annul_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_sw_indst_annul_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_SW_INDST_ANNUL_REP' as ics_module
          FROM ics_sw_indst_annul_rep local
          JOIN ics_flow_icis.ics_sw_indst_annul_rep icis
            ON (icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash)
        UNION
        /*  3 - DELETE  */
        SELECT ics_sw_indst_annul_rep.ics_sw_indst_annul_rep_id
             , ics_sw_indst_annul_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_SW_INDST_ANNUL_REP' as ics_module
          FROM ics_flow_icis.ics_sw_indst_annul_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_sw_indst_annul_rep tbl
                            WHERE tbl.key_hash = ics_sw_indst_annul_rep.key_hash)) ics_sw_indst_annul_rep;
                            
                            
--------------------------------------------------------
--  DDL for View CDV_BS_ANNUL_PROG_REP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ICS_FLOW_LOCAL"."CDV_BS_ANNUL_PROG_REP" ("ICS_MODULE", "KEY_HASH", "MODULE_IDENT", "ACTION_TYPE", "ACTION_CODE") AS 
  SELECT DISTINCT ics_module
, ics_bs_annul_prog_rep.key_hash
     , CASE ics_bs_annul_prog_rep.action_type
         WHEN 'DELETE'
           THEN (SELECT key_hash
                   FROM ics_flow_icis.ics_bs_annul_prog_rep tbl
                  WHERE tbl.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id)
           ELSE (SELECT key_hash 
                   FROM ics_bs_annul_prog_rep tbl
                  WHERE tbl.ics_bs_annul_prog_rep_id = ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id)
       END AS module_ident
     , ics_bs_annul_prog_rep.action_type
     , ics_bs_annul_prog_rep.action_code
  FROM (/*  1 - NEW  */
        SELECT ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
			 , ics_bs_annul_prog_rep.key_hash
             , 'NEW' AS action_type
             , 1 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_bs_annul_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_flow_icis.ics_bs_annul_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_annul_prog_rep.key_hash)
        UNION
        /*  2 - CHANGE  */
        SELECT local.ics_bs_annul_prog_rep_id
             , local.key_hash
             , 'CHANGE' AS action_type
             , 2 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_bs_annul_prog_rep local
          JOIN ics_flow_icis.ics_bs_annul_prog_rep icis
            ON (icis.key_hash = local.key_hash
                AND icis.data_hash <> local.data_hash) 
        UNION
        /*  3 - DELETE  */
        SELECT ics_bs_annul_prog_rep.ics_bs_annul_prog_rep_id
             , ics_bs_annul_prog_rep.key_hash
             , 'DELETE' AS action
             , 3 AS action_code
             , 'ICS_bs_annul_prog_rep' as ics_module
          FROM ics_flow_icis.ics_bs_annul_prog_rep
         WHERE NOT EXISTS (SELECT 'x'
                             FROM ics_bs_annul_prog_rep tbl
                            WHERE tbl.key_hash = ics_bs_annul_prog_rep.key_hash)) ics_bs_annul_prog_rep;
                            