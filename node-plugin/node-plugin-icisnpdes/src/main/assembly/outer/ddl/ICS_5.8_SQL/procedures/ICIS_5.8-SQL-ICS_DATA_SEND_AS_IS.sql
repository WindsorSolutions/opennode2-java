IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ICS_DATA_SEND_AS_IS') AND type = N'P')
DROP PROCEDURE dbo.ICS_DATA_SEND_AS_IS
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
** ProcedureName: ICS_SEND_AS_IS
**
** Author:  Windsor Solutions, Inc.
**
** Description:  This procedure sends the data exactly as staged without calling ETL or running change detection
**               It is derived from ICS_DATA_PREP_MASTER with the calls commented out.
**
** Revision History:      
** ----------------------------------------------------------------------------------------------------------------------------
**  Date         Name        Description
** ----------------------------------------------------------------------------------------------------------------------------
** 06/13/2017    Windsor     Created. 
**
******************************************************************************************************************************/
CREATE PROCEDURE ICS_DATA_SEND_AS_IS @p_ics_subm_track_id AS NVARCHAR(2048) OUTPUT

AS 

/* 
 * Delare the variable to to hold the newly created row in 
 * ics_subm_track associated with the new workflow
 */
 DECLARE @v_ics_subm_track_id NVARCHAR(50); 
 DECLARE @v_error_message NVARCHAR(2048);
 DECLARE @v_error_number INT;
 DECLARE @v_error_severity INT;
 DECLARE @v_process NVARCHAR(30);

BEGIN 

  SET @v_process = 'ICS_DATA_PREP_MASTER';

 /*  
  *  Ensure there are no existing workflows in process. If there are, quit without returning an ID.
  */
  IF (SELECT COUNT(1) AS COUNTER FROM ics_subm_track WHERE workflow_stat = 'Pending') > 0
    BEGIN
      SET @p_ics_subm_track_id = NULL;
      RETURN;
    END;
  
 /* Safe to proceed. Create and commit a new workflow record */
  SELECT @v_ics_subm_track_id = NEWID(); 

  INSERT INTO ics_subm_track 
       ( ics_subm_track_id
       , workflow_stat
       , workflow_stat_message) 
  VALUES( @v_ics_subm_track_id
        , 'Pending'
        , 'ETL begun');

BEGIN TRANSACTION PROCESS_ICIS_DATA

  BEGIN TRY 
     
     /* 
      *  Call the stored procedure to extract ICIS data from source data database.
      *  NOTE:  This stored procedure will need to be independently developed and 
      *         should populate the set of "LOCAL" ICS staging tables.
      */
    --  SET @v_process = 'EXTRACT_ICIS_DATA';
    --  EXEC ICS_ETL;

     /* 
      *  Update the workflow record to track completion of ETL date/time.
      */
      UPDATE ics_subm_track 
         SET etl_cmpl_date_time = GETDATE() 
           , workflow_stat_message = 'ETL Completed | Begin Change Processing'
       WHERE ics_subm_track_id = @v_ics_subm_track_id;

     /* 
      *  Call the stored procedure to compare data changes between LOCAL and ICIS and set
      *  transaction codes for bundling and submission to an exchange partner via OPENNODE.
      */
   --   SET @v_process = 'ICS_DETECT_DATA_CHANGES';
   --   EXEC ICS_CHANGE_DETECTION;

     /* 
      *  Update the workflow record to track completion of change detection date/time.
      */
     UPDATE ics_subm_track 
        SET det_change_cmpl_date_time = GETDATE() 
           , workflow_stat_message = 'Change Processing Completed'
      WHERE ics_subm_track_id = @v_ics_subm_track_id;

    /* 
     *  Return current workflow identifier
     */
    SET @p_ics_subm_track_id = @v_ics_subm_track_id;

    /* 
     *  Add any additional SQL logic required after the change detection process completes.
     *  Note this work will still occur within the named transaction and will be subject to
     *  the current transaction processing workflow.  Any runtime failures here will cause
     *  all pending data changes to rollback to the initial data state before this process
     *  was initiated.
     */
     
    /* Commit all data changes */
    COMMIT TRANSACTION PROCESS_ICIS_DATA;
    
     --  Add additional database processing here if needed...

  END TRY 

  /*
   *  Handle any runtime errors
   */
  BEGIN CATCH

    SET @v_error_message = ERROR_MESSAGE();
    SET @v_error_number = ERROR_NUMBER();
    SET @v_error_severity = ERROR_SEVERITY();

    /* 
     *  First rollback pending data changes from ICIS ETL and change detection processing 
     */
     ROLLBACK TRANSACTION PROCESS_ICIS_DATA;
    
    /*  
     *  Set workflow status to failed.
     */
     UPDATE ics_subm_track 
        SET workflow_stat = 'Failed'
          , workflow_stat_message = @v_process + ': ' + @v_error_message 
      WHERE ics_subm_track_id = @v_ics_subm_track_id;

     --Send the error back up to the calling code. If the ETL is being called from the plugin, this will trigger the plugin to log the failure and quit
     SET @p_ics_subm_track_id = @v_error_message;
     RAISERROR (@v_error_message, @v_error_severity, 1);

  END CATCH
  


END ;