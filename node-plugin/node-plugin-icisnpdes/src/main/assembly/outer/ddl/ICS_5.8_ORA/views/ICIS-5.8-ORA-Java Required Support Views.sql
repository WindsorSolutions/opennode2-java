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
** JAva Required Support Views
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  These views are required by the Java ICIS-NPDES plugin for proper serialization of
**               staging table data to XML via the Hibernate framework. They are not needed for
**               .NET OpenNode2 implementations.
**
** Revision History:      
** ------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ------------------------------------------------------------------------------------------------
** 9/16/2017     Windsor     Created
**
***************************************************************************************************/
CREATE OR REPLACE VIEW ics_v_anml_type_hib 
AS 
SELECT ICS_ANML_TYPE_ID as ICS_REP_ANML_TYPE_ID
  , null as ICS_CAFO_ANNUL_REP_ID
  , ICS_CAFO_PRMT_ID
  , ICS_CAFO_INSP_ID
  , ANML_TYPE_CODE
  , OTHR_ANML_TYPE_NAME
  , TTL_NUM_EACH_LVSTCK
  , OPEN_CONFINEMNT_CNT
  , HOUSD_UNDR_ROOF_CONFINEMNT_CNT
  , DATA_HASH
FROM ICS_ANML_TYPE;
-- These views are required to support from 5.8 onwards
  CREATE OR REPLACE FORCE VIEW "ICS_FLOW_LOCAL"."ICS_CERT_PROG_REP_CONTACT" ("ICS_CERT_PROG_REP_CONTACT_ID", "ICS_CONTACT_ID") AS 
  SELECT
    ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID  as ICS_CERT_PROG_REP_CONTACT_ID,
    ICS_CONTACT.ICS_CONTACT_ID
  from ICS_BS_ANNUL_PROG_REP, ICS_CONTACT
  where ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID = ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID;
 
  CREATE OR REPLACE FORCE VIEW "ICS_FLOW_LOCAL"."ICS_THIRD_PTY_PROG_REP_ADDR" ("THIRD_PTY_PROG_REP_ADDR_ID", "ICS_ADDR_ID") AS 
  SELECT
  ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID  as THIRD_PTY_PROG_REP_ADDR_ID,
  ICS_ADDR.ICS_ADDR_ID
from ICS_BS_MGMT_PRACTICES, ICS_ADDR
where ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID = ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID;

  CREATE OR REPLACE FORCE VIEW "ICS_FLOW_LOCAL"."ICS_THIRD_PTY_PROG_REP_CONTACT" ("THIRD_PTY_PROG_REP_CONTACT_ID", "ICS_CONTACT_ID") AS 
  select
  ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID as THIRD_PTY_PROG_REP_CONTACT_ID,
  ICS_CONTACT.ICS_CONTACT_ID
from ICS_BS_MGMT_PRACTICES, ICS_CONTACT
where ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID = ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID;
