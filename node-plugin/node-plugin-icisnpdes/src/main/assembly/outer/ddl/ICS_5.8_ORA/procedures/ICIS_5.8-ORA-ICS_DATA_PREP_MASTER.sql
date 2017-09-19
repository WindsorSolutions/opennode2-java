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
*//******************************************************************************************************************************
** ProcedureName: ICS_DATA_PREP_MASTER
**
** Author:  Windsor Solutions, Inc.
**
** Description:  This is a template stored procedure was developed for processing ICIS data for exchange via OPENNODE2.  This 
**               stored procedure determines if the system state is ready for ICIS data processing, and if so initiate those
**               processes, otherwise it will skip processing until the state of the system is ready for a new batch of ICIS 
**               data processing.
**
** Revision History:      
** ----------------------------------------------------------------------------------------------------------------------------
**  Date         Name           Description
** ----------------------------------------------------------------------------------------------------------------------------
** 09/08/2014    Windsor        Created from 4.0 baseline.
** 09/09/2014    Windsor        Altered procedure to handle 5.0 schema modifications.
** 09/10/2014    Windsor        Moved the execute grant into this script.  This will be applied once
**                              the procedure compiles successfully.
**
******************************************************************************************************************************/
CREATE OR REPLACE PROCEDURE ICS_DATA_PREP_MASTER (p_ics_subm_track_id OUT VARCHAR)

AS 

/* 
 * Delare the variable to to hold the newly created row in 
 * ics_subm_track associated with the new workflow
 */
 v_ics_subm_track_id VARCHAR(50); 
 v_error_message VARCHAR(2048);
 v_error_number NUMBER;
 v_process VARCHAR(30);
 e_return EXCEPTION;
 
 v_workflow_cntr NUMBER;

BEGIN 

  v_process := 'ICS_DATA_PREP_MASTER';

 /*  
  *  Ensure there are no existing workflows in process. If there are, quit without returning an ID.
  */
  SELECT COUNT(1)
    INTO v_workflow_cntr
    FROM ics_subm_track
   WHERE workflow_stat = 'Pending'; 

  IF (v_workflow_cntr > 0) THEN
    BEGIN
      p_ics_subm_track_id := NULL;
      RETURN;
    END;
  END IF;
  
  
  
 /* Safe to proceed. Create and commit a new workflow record */
  SELECT SYS_GUID()
    INTO v_ics_subm_track_id
    FROM DUAL;

  INSERT INTO ics_subm_track 
       ( ics_subm_track_id
       , workflow_stat
       , workflow_stat_message) 
  VALUES( v_ics_subm_track_id
        , 'Pending'
        , 'ETL begun');
  COMMIT;
     
 /* 
  *  Call the stored procedure to extract ICIS data from source data database.
  *  NOTE:  This stored procedure will need to be independently developed and 
  *         should populate the set of "LOCAL" ICS staging tables.
  */
  v_process := 'ICS_ETL';
  ICS_ETL;

 /* 
  *  Update the workflow record to track completion of ETL date/time.
  */
  UPDATE ics_subm_track 
     SET etl_cmpl_date_time = SYSDATE() 
       , workflow_stat_message = 'ETL Completed | Begin Change Processing'
   WHERE ics_subm_track_id = v_ics_subm_track_id;

 /* 
  *  Call the stored procedure to compare data changes between LOCAL and ICIS and set
  *  transaction codes for bundling and submission to an exchange partner via OPENNODE.
  */
  v_process := 'ICS_CHANGE_DETECTION';
  ICS_CHANGE_DETECTION;

 /* 
  *  Update the workflow record to track completion of change detection date/time.
  */
 UPDATE ics_subm_track 
    SET det_change_cmpl_date_time = SYSDATE() 
       , workflow_stat_message = 'Change Processing Completed'
  WHERE ics_subm_track_id = v_ics_subm_track_id;

 /* 
 *  Return current workflow identifier
 */
 p_ics_subm_track_id := v_ics_subm_track_id;

 /* 
 *  Add any additional SQL logic required after the change detection process completes.
 *  Note this work will still occur within the named transaction and will be subject to
 *  the current transaction processing workflow.  Any runtime failures here will cause
 *  all pending data changes to rollback to the initial data state before this process
 *  was initiated.
 */
 --  Add additional database processing here if needed...

  COMMIT;-- TRANSACTION PROCESS_ICIS_DATA;
  
  /*
   *  Handle any runtime errors
   */
  EXCEPTION WHEN OTHERS THEN
        
    v_error_message := SUBSTR(SQLERRM, 1, 200);
    v_error_number := SQLCODE;

    /* 
     *  First rollback pending data changes from ICIS ETL and change detection processing 
     */
     ROLLBACK;-- TRANSACTION PROCESS_ICIS_DATA;
    
    /*  
     *  Set workflow status to failed.
     */
     UPDATE ics_subm_track 
        SET workflow_stat = 'Failed'
          , workflow_stat_message = v_process || ': ' || v_error_message 
      WHERE ics_subm_track_id = v_ics_subm_track_id;

     COMMIT;

     --Send the error back up to the calling code. If the ETL is being called from the plugin, this will trigger the plugin to log the failure and quit
     p_ics_subm_track_id := 'ICS_DATA_PREP_MASTER Failed:  ' || v_error_number || ' - ' || v_error_message;
     RAISE;

END ICS_DATA_PREP_MASTER;
/

GRANT EXECUTE ON ICS_FLOW_LOCAL.ICS_DATA_PREP_MASTER TO ICS_FLOW_LOCAL_USER;
/