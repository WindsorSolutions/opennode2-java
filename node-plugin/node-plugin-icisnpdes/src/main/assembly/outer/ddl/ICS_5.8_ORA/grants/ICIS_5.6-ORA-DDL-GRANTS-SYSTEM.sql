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
/* **********************************
 *  Grants to ICS_FLOW_LOCAL_[USER] *
 *  Grants to ICS_FLOW_LOCAL_[USER] *
 *  Grants to ICS_FLOW_LOCAL_[USER] *
 ************************************/
 
 /*****************************************************************************************************************************   
 *
 *  Script Name:  ICIS_5.0-ORA-DDL-GRANTS-SYSTEM.sql
 *
 *  Company:  Windsor Solutions, Inc.
 *  
 *  Purpose:  This script grants execute rights on the SYS owned package called DBMS_CRYPTO.  This package is critical to the 
 *            ETL processes that hash data during change processing.
 *   
 *  Maintenance:
 *  
 *    Analyst         Date            Comment 
 *    ----------      ----------      ------------------------------------------------------------------------------
 *    Windsor         09/10/2014      Created.
 *    CTyler          06/22/2017      Grant DBMS_CRYTPO to ICS_FLOW_ICIS too
 *
 ****************************************************************************************************************************   
 */
--Grant execute on Oracle's built-in crypto package for use by MD5_HASH function
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO ICS_FLOW_LOCAL;
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO ICS_FLOW_ICIS;
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO ICS_FLOW_LOCAL_USER;
