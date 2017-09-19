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
CREATE OR REPLACE FUNCTION GET_LIMIT_MONTHS (P_ICS_LMT_ID IN VARCHAR2) RETURN VARCHAR2
/*************************************************************************************************
** ObjectName: GET_LIMIT_MONTHS
**
** Author: Windsor
**
** Company Name: Windsor Solutions, Inc
**
** Description:  This function searches the ics_mn_lmt_applies table and returns a 12-character 
**               string representing the 12 months that a limit is in effect (e.g. YYYNNNNNNYYY).
**
** Revision History:
** ------------------------------------------------------------------------------------------------
**  Date        Name        Description
** ------------------------------------------------------------------------------------------------
** 09/10/2014    Windsor    Created from 4.0 baseline.
**
***************************************************************************************************/
AS
  V_YN_LIST VARCHAR2(12);
BEGIN

  SELECT REPLACE(REPLACE(COUNT(CASE WHEN mn_lmt_applies = 'JAN' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'FEB' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'MAR' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'APR' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'MAY' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'JUN' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'JUL' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'AUG' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'SEP' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'OCT' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'NOV' THEN 1 ELSE NULL END)
    || COUNT(CASE WHEN mn_lmt_applies = 'DEC' THEN 1 ELSE NULL END),'1','Y'),'0','N')
  INTO V_YN_LIST
  FROM ics_mn_lmt_applies 
  WHERE ics_lmt_id = P_ICS_LMT_ID;
  
  RETURN V_YN_LIST;
   
END GET_LIMIT_MONTHS;
/