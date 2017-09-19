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
CREATE OR REPLACE FUNCTION MD5_HASH (p_string IN VARCHAR2)
  RETURN VARCHAR2
  /************************************************************************************************
** ObjectName: MD5_HASH (Function)
**
** Author: Windsor Solutions, Inc. 
**
** Company Name: Windsor Solutions, Inc
**
** Description:  Returns an MD5 hash for the input string provided
**
**
** Revision History:      
** ----------------------------------------------------------------------------------------------
**  Date         Name        Description
** ----------------------------------------------------------------------------------------------
** 09/10/2014    Windsor    Created from 4.0 baseline.
** 12/11/2014    CTyler     Added Upper, to ensure upper case (varies between servers)
**
*************************************************************************************************/

IS

e_no_input EXCEPTION;
BEGIN
	IF p_string IS NULL
	THEN
		RAISE e_no_input;
	END IF;

	RETURN UPPER(TO_CHAR(DBMS_CRYPTO.HASH(TO_CLOB(p_string),DBMS_CRYPTO.HASH_MD5)));

EXCEPTION
WHEN e_no_input
THEN
	RETURN NULL;
WHEN OTHERS
THEN
	RAISE;
END;
/