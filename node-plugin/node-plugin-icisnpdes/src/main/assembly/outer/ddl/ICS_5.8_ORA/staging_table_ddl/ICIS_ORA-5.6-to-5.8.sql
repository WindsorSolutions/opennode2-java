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
/* ************************************************************************************************
** ObjectName: ICIS_NPDES_Oracle-5.6-5.8.sql
**
** Author: Windsor Solutions, Inc.
**
** Company Name: Windsor Solutions, Inc.
**
** Description:  This script will update an existing ICIS 5.0 database to support the ICIS 5.6
**               XML schema.  This script can be run multiple times without issue.
**
** Revision History:
** ------------------------------------------------------------------------------------------------
** Date          Name        Description
** ------------------------------------------------------------------------------------------------
** 06/27/2017    CTyler      Created
** 08/16/2017    CTyler      Add supporting views for JAVA node for 5.8 
**
************************************************************************************************ */

-- ICS_ANLYTCL_METHOD moved after   ICS_BS_ANNUL_PROG_REP for FK dependancy 
/* ******************************************************************************************************* 

    Create new table ICS_BS_ANNUL_PROG_REP as child of ICS_PAYLOAD

******************************************************************************************************** */

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_BS_ANNUL_PROG_REP exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_BS_ANNUL_PROG_REP';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_BS_ANNUL_PROG_REP already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_BS_ANNUL_PROG_REP
    (
        ICS_BS_ANNUL_PROG_REP_ID VARCHAR2(36) NOT NULL,
        ICS_PAYLOAD_ID VARCHAR2(36) NOT NULL,
        SRC_SYSTM_IDENT VARCHAR2(50) NULL,
        TRANSACTION_TYPE CHAR(1) NULL,
        TRANSACTION_TIMESTAMP DATE NULL,
        PRMT_IDENT CHAR(9) NULL,
        BS_ANNUL_REP_RCVD_DATE DATE NULL,
        ELEC_SUBM_TYPE_CODE VARCHAR2(3) NULL,
        REP_PERIOD_START_DATE DATE NULL,
        REP_PERIOD_END_DATE DATE NULL,
        TRTMNT_PRCSS_OTHR_TXT VARCHAR2(100) NULL,
        TTL_VOL_AMT NUMBER(12,6) NULL,
        BS_ADDL_INFO_CMNT_TXT VARCHAR2(4000) NULL,
        DATA_HASH VARCHAR2(100) NULL,
        KEY_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_BS_ANNUL_PROG_REP was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_BS_ANNUL_PROG_REP" 
 ADD ( CONSTRAINT "PK_BS_ANNUL_PROG_REP" 
 PRIMARY KEY("ICS_BS_ANNUL_PROG_REP_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_BS_ANNUL_PROG_REP  was added.');

      v_sql_statement := 'CREATE INDEX "IX_BS_ANNL_PROG_REP_ICS_PYL_ID" 
   ON "ICS_BS_ANNUL_PROG_REP"("ICS_PAYLOAD_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index  IX_BS_ANNL_PROG_REP_ICS_PYL_ID was added.');
      
      v_sql_statement := 'CREATE UNIQUE INDEX "IX_BS_ANL_REP_PR_ID_RE_CV_DA" 
   ON "ICS_BS_ANNUL_PROG_REP"("PRMT_IDENT","BS_ANNUL_REP_RCVD_DATE")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_BS_ANL_REP_PR_ID_RE_CV_DA  was added.');      

      v_sql_statement := 'ALTER TABLE "ICS_BS_ANNUL_PROG_REP"
                           ADD ( CONSTRAINT "FK_BS_ANNUL_PROG_REP_PAYLOAD"
                           FOREIGN KEY("ICS_PAYLOAD_ID")
                           REFERENCES ICS_PAYLOAD("ICS_PAYLOAD_ID")
                           ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_BS_ANNUL_PROG_REP_PAYLOAD  was added.');

    
     END;  

END;
/

  
/******************************************************************************************************** 

    Create new table ICS_ANLYTCL_METHOD as child of ICS_BS_ANNUL_PROG_REP

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_ANLYTCL_METHOD exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_ANLYTCL_METHOD';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_ANLYTCL_METHOD already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE "ICS_ANLYTCL_METHOD"
    (
        "ICS_ANLYTCL_METHOD_ID" VARCHAR2(36) NOT NULL,
        "ICS_BS_ANNUL_PROG_REP_ID" VARCHAR2(36) NOT NULL,
        "ANLYTCL_METHOD_TYPE_CODE" VARCHAR(3) NOT NULL,
        "ANLYTCL_METHOD_OTHR_TYPE_TXT" VARCHAR(500) NULL,
        "DATA_HASH" VARCHAR(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_ANLYTCL_METHOD was added to the schema!');
      
      v_sql_statement := 'ALTER TABLE "ICS_ANLYTCL_METHOD" 
 ADD ( CONSTRAINT "PK_ANLYTCL_METHOD" 
 PRIMARY KEY("ICS_ANLYTCL_METHOD_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
     EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_ANLYTCL_METHOD  was added.');

      v_sql_statement := 'CREATE INDEX "IX_ANL_MTH_ICS_BS_ANN_PR_RE_ID" ON "ICS_ANLYTCL_METHOD"("ICS_BS_ANNUL_PROG_REP_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index   was added.');

      v_sql_statement := 'ALTER TABLE "ICS_ANLYTCL_METHOD"
 ADD ( CONSTRAINT "FK_ANLYT_MTHD_BS_ANNL_PROG_REP"
 FOREIGN KEY("ICS_BS_ANNUL_PROG_REP_ID")
 REFERENCES ICS_BS_ANNUL_PROG_REP("ICS_BS_ANNUL_PROG_REP_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_ANLYT_MTHD_BS_ANNL_PROG_REP   was added.');

    
     END;  

END;
/
  
   
/******************************************************************************************************** 

    Create new table ICS_BS_MGMT_PRACTICES as child of ICS_BS_ANNUL_PROG_REP

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_BS_MGMT_PRACTICES exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_BS_MGMT_PRACTICES';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_BS_MGMT_PRACTICES already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_BS_MGMT_PRACTICES
    (
        "ICS_BS_MGMT_PRACTICES_ID" VARCHAR2(36) NOT NULL,
        "ICS_BS_ANNUL_PROG_REP_ID" VARCHAR2(36) NOT NULL,
        "SSU_IDENT" VARCHAR2(4) NOT NULL,
        "BS_MGMT_PRC_TYPE_CODE" VARCHAR2(3) NOT NULL,
        "HNDLR_PREPR_TYPE_CODE" VARCHAR2(3) NOT NULL,
        "LAND_APPL_SUB_CATG_CODE" VARCHAR2(50) NULL,
        "OTHR_SUB_CATG_CODE" VARCHAR2(50) NULL,
        "SUB_CATG_OTHR_TXT" VARCHAR2(100) NULL,
        "BS_CNTNR_TYPE_CODE" VARCHAR2(3) NOT NULL,
        "VOL_AMT" NUMBER(12,6) NOT NULL,
        "PATHOGEN_CLASS_TYPE_CODE" VARCHAR2(3) NULL,
        "POLUT_CONCEN_EXCEEDANCE_IND" CHAR(1) NULL,
        "POLUT_LOADING_R_EXCEEDANCE_IND" CHAR(1) NULL,
        "ACTIVE_DSPL_SITE_IND" CHAR(1) NULL,
        "SITE_SPEC_LMT_IND" CHAR(1) NULL,
        "MIN_BNDRY_DIST_IND" CHAR(1) NULL,
        "MIN_BNDRY_DIST_TYPE_CODE" VARCHAR2(3) NULL,
        "ASSC_PRMT_IDENT" CHAR(9) NULL,
        "MGMT_PRC_CMNT_TXT" VARCHAR2(4000) NULL,
        "DATA_HASH" VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_BS_MGMT_PRACTICES was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_BS_MGMT_PRACTICES" 
 ADD ( CONSTRAINT "PK_BS_MGMT_PRACTICES" 
 PRIMARY KEY("ICS_BS_MGMT_PRACTICES_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_BS_MGMT_PRACTICES  was added.');

      v_sql_statement := 'CREATE INDEX "IX_BS_MGM_PR_IC_BS_AN_PR_RE_ID" 
   ON "ICS_BS_MGMT_PRACTICES"("ICS_BS_ANNUL_PROG_REP_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index  IX_BS_MGM_PR_IC_BS_AN_PR_RE_ID was added.');

      v_sql_statement := 'ALTER TABLE "ICS_BS_MGMT_PRACTICES"
 ADD ( CONSTRAINT "FK_BS_MGMT_PRCT_BS_ANN_PRO_REP"
 FOREIGN KEY("ICS_BS_ANNUL_PROG_REP_ID")
 REFERENCES ICS_BS_ANNUL_PROG_REP("ICS_BS_ANNUL_PROG_REP_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK  FK_BS_MGMT_PRCT_BS_ANN_PRO_REP was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_CNST_SITE as child of ICS_SW_CNST_PRMT

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_CNST_SITE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_CNST_SITE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_CNST_SITE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_CNST_SITE
    (
        ICS_CNST_SITE_ID VARCHAR2(36) NOT NULL,
        ICS_SW_CNST_PRMT_ID VARCHAR2(36) NOT NULL,
        CNST_SITE_CODE VARCHAR2(50) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_CNST_SITE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_CNST_SITE" 
 ADD ( CONSTRAINT "PK_CNST_SITE" 
 PRIMARY KEY("ICS_CNST_SITE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_CNST_SITE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_CNST_SITE_ICS_SW_CNS_PRM_ID" 
ON "ICS_CNST_SITE"("ICS_SW_CNST_PRMT_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_CNST_SITE_ICS_SW_CNS_PRM_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_CNST_SITE"
 ADD ( CONSTRAINT "FK_CNST_SITE_SW_CNST_PRMT"
 FOREIGN KEY("ICS_SW_CNST_PRMT_ID")
 REFERENCES ICS_SW_CNST_PRMT("ICS_SW_CNST_PRMT_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_CNST_SITE_SW_CNST_PRMT  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_IMPAIRED_WTR_POLLUTANTS as child of ICS_PRMT_FEATR

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_IMPAIRED_WTR_POLLUTANTS exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_IMPAIRED_WTR_POLLUTANTS';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_IMPAIRED_WTR_POLLUTANTS already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_IMPAIRED_WTR_POLLUTANTS
    (
        ICS_IMPAIRED_WTR_POLLUTANTS_ID VARCHAR2(36) NOT NULL,
        ICS_PRMT_FEATR_ID VARCHAR2(36) NOT NULL,
        IMPAIRED_WTR_POLLUTANTS NUMBER(10,0) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_IMPAIRED_WTR_POLLUTANTS was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_IMPAIRED_WTR_POLLUTANTS" 
 ADD ( CONSTRAINT "PK_IMPAIRED_WTR_POLLUTANTS" 
 PRIMARY KEY("ICS_IMPAIRED_WTR_POLLUTANTS_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_IMPAIRED_WTR_POLLUTANTS  was added.');

      v_sql_statement := 'CREATE INDEX "IX_IMPR_WTR_PLL_ICS_PRM_FET_ID" 
   ON "ICS_IMPAIRED_WTR_POLLUTANTS"("ICS_PRMT_FEATR_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_IMPR_WTR_PLL_ICS_PRM_FET_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_IMPAIRED_WTR_POLLUTANTS"
 ADD ( CONSTRAINT "FK_IMPRD_WTR_PLLTNTS_PRMT_FETR"
 FOREIGN KEY("ICS_PRMT_FEATR_ID")
 REFERENCES ICS_PRMT_FEATR("ICS_PRMT_FEATR_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_IMPRD_WTR_PLLTNTS_PRMT_FETR  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_MGMT_PRC_DEFCY_TYPE as child of ICS_BS_MGMT_PRACTICES

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_MGMT_PRC_DEFCY_TYPE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_MGMT_PRC_DEFCY_TYPE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_MGMT_PRC_DEFCY_TYPE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_MGMT_PRC_DEFCY_TYPE
    (
        ICS_MGMT_PRC_DEFCY_TYPE_ID VARCHAR2(36) NOT NULL,
        ICS_BS_MGMT_PRACTICES_ID VARCHAR2(36) NOT NULL,
        MGMT_PRC_DEFCY_TYPE_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_MGMT_PRC_DEFCY_TYPE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_MGMT_PRC_DEFCY_TYPE" 
 ADD ( CONSTRAINT "PK_MGMT_PRC_DEFCY_TYPE" 
 PRIMARY KEY("ICS_MGMT_PRC_DEFCY_TYPE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_MGMT_PRC_DEFCY_TYPE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_MGM_PR_DF_TY_IC_BS_MG_PR_ID" 
   ON "ICS_MGMT_PRC_DEFCY_TYPE"("ICS_BS_MGMT_PRACTICES_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_MGM_PR_DF_TY_IC_BS_MG_PR_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_MGMT_PRC_DEFCY_TYPE"
 ADD ( CONSTRAINT "FK_MGMT_PRC_DFC_TYP_BS_MGM_PRC"
 FOREIGN KEY("ICS_BS_MGMT_PRACTICES_ID")
 REFERENCES ICS_BS_MGMT_PRACTICES("ICS_BS_MGMT_PRACTICES_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_MGMT_PRC_DFC_TYP_BS_MGM_PRC  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_NPDES_DAT_GRP_NUM as child of ICS_BASIC_PRMT

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_NPDES_DAT_GRP_NUM exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_NPDES_DAT_GRP_NUM';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_NPDES_DAT_GRP_NUM already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_NPDES_DAT_GRP_NUM
    (
        ICS_NPDES_DAT_GRP_NUM_ID VARCHAR2(36) NOT NULL,
        ICS_BASIC_PRMT_ID VARCHAR2(36) NULL,
        ICS_GNRL_PRMT_ID VARCHAR2(36) NULL,
        NPDES_DAT_GRP_NUM_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_NPDES_DAT_GRP_NUM was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_NPDES_DAT_GRP_NUM" 
 ADD ( CONSTRAINT "PK_NPDES_DAT_GRP_NUM" 
 PRIMARY KEY("ICS_NPDES_DAT_GRP_NUM_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_NPDES_DAT_GRP_NUM  was added.');

      v_sql_statement := 'CREATE INDEX "IX_NPD_DAT_GRP_NUM_IC_BS_PR_ID" 
   ON "ICS_NPDES_DAT_GRP_NUM"("ICS_BASIC_PRMT_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index  IX_NPD_DAT_GRP_NUM_IC_BS_PR_ID was added.');

      v_sql_statement := 'ALTER TABLE "ICS_NPDES_DAT_GRP_NUM"
 ADD ( CONSTRAINT "FK_NPDES_DAT_GRP_NUM_BSIC_PRMT"
 FOREIGN KEY("ICS_BASIC_PRMT_ID")
 REFERENCES ICS_BASIC_PRMT("ICS_BASIC_PRMT_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_NPDES_DAT_GRP_NUM_BSIC_PRMT  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_PATHOGEN_REDUCTION_TYPE as child of ICS_BS_MGMT_PRACTICES

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_PATHOGEN_REDUCTION_TYPE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_PATHOGEN_REDUCTION_TYPE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_PATHOGEN_REDUCTION_TYPE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_PATHOGEN_REDUCTION_TYPE
    (
        ICS_PATHOGEN_REDUCTION_TYPE_ID VARCHAR2(36) NOT NULL,
        ICS_BS_MGMT_PRACTICES_ID VARCHAR2(36) NOT NULL,
        PATHOGEN_REDUCTION_TYPE_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_PATHOGEN_REDUCTION_TYPE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_PATHOGEN_REDUCTION_TYPE" 
 ADD ( CONSTRAINT "PK_PATHOGEN_REDUCTION_TYPE" 
 PRIMARY KEY("ICS_PATHOGEN_REDUCTION_TYPE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_PATHOGEN_REDUCTION_TYPE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_PTH_RDC_TYP_ICS_BS_MG_PR_ID" 
   ON "ICS_PATHOGEN_REDUCTION_TYPE"("ICS_BS_MGMT_PRACTICES_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_PTH_RDC_TYP_ICS_BS_MG_PR_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_PATHOGEN_REDUCTION_TYPE"
 ADD ( CONSTRAINT "FK_PTHG_RDCT_TYPE_BS_MGMT_PRCT"
 FOREIGN KEY("ICS_BS_MGMT_PRACTICES_ID")
 REFERENCES ICS_BS_MGMT_PRACTICES("ICS_BS_MGMT_PRACTICES_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_PTHG_RDCT_TYPE_BS_MGMT_PRCT was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_REP_OBLGTN_TYPE as child of ICS_BS_ANNUL_PROG_REP

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_REP_OBLGTN_TYPE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_REP_OBLGTN_TYPE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_REP_OBLGTN_TYPE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_REP_OBLGTN_TYPE
    (
        ICS_REP_OBLGTN_TYPE_ID VARCHAR2(36) NOT NULL,
        ICS_BS_ANNUL_PROG_REP_ID VARCHAR2(36) NOT NULL,
        REP_OBLGTN_TYPE_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_REP_OBLGTN_TYPE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_REP_OBLGTN_TYPE" 
 ADD ( CONSTRAINT "PK_REP_OBLGTN_TYPE" 
 PRIMARY KEY("ICS_REP_OBLGTN_TYPE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_REP_OBLGTN_TYPE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_REP_OB_TY_IC_BS_AN_PR_RE_ID" 
   ON "ICS_REP_OBLGTN_TYPE"("ICS_BS_ANNUL_PROG_REP_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_REP_OB_TY_IC_BS_AN_PR_RE_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_REP_OBLGTN_TYPE"
 ADD ( CONSTRAINT "FK_REP_OBLG_TYP_BS_ANN_PRO_REP"
 FOREIGN KEY("ICS_BS_ANNUL_PROG_REP_ID")
 REFERENCES ICS_BS_ANNUL_PROG_REP("ICS_BS_ANNUL_PROG_REP_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_REP_OBLG_TYP_BS_ANN_PRO_REP   was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_TMDL_POLLUTANTS as child of ICS_PRMT_FEATR

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_TMDL_POLLUTANTS exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_TMDL_POLLUTANTS';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_TMDL_POLLUTANTS already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_TMDL_POLLUTANTS
    (
        ICS_TMDL_POLLUTANTS_ID VARCHAR2(36) NOT NULL,
        ICS_PRMT_FEATR_ID VARCHAR2(36) NOT NULL,
        TMDL_IDENT VARCHAR2(6) NOT NULL,
        TMDL_NAME VARCHAR2(100) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_TMDL_POLLUTANTS was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_TMDL_POLLUTANTS" 
 ADD ( CONSTRAINT "PK_TMDL_POLLUTANTS" 
 PRIMARY KEY("ICS_TMDL_POLLUTANTS_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_TMDL_POLLUTANTS  was added.');

      v_sql_statement := 'CREATE INDEX "IX_TMDL_PLLTN_ICS_PRMT_FETR_ID" 
   ON "ICS_TMDL_POLLUTANTS"("ICS_PRMT_FEATR_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_TMDL_PLLTN_ICS_PRMT_FETR_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_TMDL_POLLUTANTS"
 ADD ( CONSTRAINT "FK_TMDL_POLLUTANTS_PRMT_FEATR"
 FOREIGN KEY("ICS_PRMT_FEATR_ID")
 REFERENCES ICS_PRMT_FEATR("ICS_PRMT_FEATR_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_TMDL_POLLUTANTS_PRMT_FEATR  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_TMDL_POLUT as child of ICS_TMDL_POLLUTANTS

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_TMDL_POLUT exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_TMDL_POLUT';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_TMDL_POLUT already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_TMDL_POLUT
    (
        ICS_TMDL_POLUT_ID VARCHAR2(36) NOT NULL,
        ICS_TMDL_POLLUTANTS_ID VARCHAR2(36) NOT NULL,
        TMDL_POLUT_CODE NUMBER(10,0) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_TMDL_POLUT was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_TMDL_POLUT" 
 ADD ( CONSTRAINT "PK_TMDL_POLUT" 
 PRIMARY KEY("ICS_TMDL_POLUT_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_TMDL_POLUT  was added.');

      v_sql_statement := 'CREATE INDEX "IX_TMDL_PLUT_ICS_TMDL_PLLTN_ID" 
ON "ICS_TMDL_POLUT"("ICS_TMDL_POLLUTANTS_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_TMDL_PLUT_ICS_TMDL_PLLTN_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_TMDL_POLUT"
 ADD ( CONSTRAINT "FK_TMDL_POLUT_TMDL_POLLUTANTS"
 FOREIGN KEY("ICS_TMDL_POLLUTANTS_ID")
 REFERENCES ICS_TMDL_POLLUTANTS("ICS_TMDL_POLLUTANTS_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_TMDL_POLUT_TMDL_POLLUTANTS  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_TRTMNT_CHEMS_LIST as child of ICS_SW_CNST_PRMT

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_TRTMNT_CHEMS_LIST exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_TRTMNT_CHEMS_LIST';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_TRTMNT_CHEMS_LIST already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_TRTMNT_CHEMS_LIST
    (
        ICS_TRTMNT_CHEMS_LIST_ID VARCHAR2(36) NOT NULL,
        ICS_SW_CNST_PRMT_ID VARCHAR2(36) NOT NULL,
        TRTMNT_CHEMS_LIST VARCHAR2(255) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_TRTMNT_CHEMS_LIST was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_TRTMNT_CHEMS_LIST" 
 ADD ( CONSTRAINT "PK_TRTMNT_CHEMS_LIST" 
 PRIMARY KEY("ICS_TRTMNT_CHEMS_LIST_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_TRTMNT_CHEMS_LIST  was added.');

      v_sql_statement := 'CREATE INDEX "IX_TRT_CHM_LIS_ICS_SW_CN_PR_ID" 
   ON "ICS_TRTMNT_CHEMS_LIST"("ICS_SW_CNST_PRMT_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_TRT_CHM_LIS_ICS_SW_CN_PR_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_TRTMNT_CHEMS_LIST"
 ADD ( CONSTRAINT "FK_TRTM_CHMS_LIST_SW_CNST_PRMT"
 FOREIGN KEY("ICS_SW_CNST_PRMT_ID")
 REFERENCES ICS_SW_CNST_PRMT("ICS_SW_CNST_PRMT_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_TRTM_CHMS_LIST_SW_CNST_PRMT  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_TRTMNT_PRCSS_TYPE as child of ICS_BS_ANNUL_PROG_REP

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_TRTMNT_PRCSS_TYPE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_TRTMNT_PRCSS_TYPE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_TRTMNT_PRCSS_TYPE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_TRTMNT_PRCSS_TYPE
    (
        ICS_TRTMNT_PRCSS_TYPE_ID VARCHAR2(36) NOT NULL,
        ICS_BS_ANNUL_PROG_REP_ID VARCHAR2(36) NOT NULL,
        TRTMNT_PRCSS_TYPE_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_TRTMNT_PRCSS_TYPE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_TRTMNT_PRCSS_TYPE" 
 ADD ( CONSTRAINT "PK_TRTMNT_PRCSS_TYPE" 
 PRIMARY KEY("ICS_TRTMNT_PRCSS_TYPE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_TRTMNT_PRCSS_TYPE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_TRT_PR_TY_IC_BS_AN_PR_RE_ID" 
   ON "ICS_TRTMNT_PRCSS_TYPE"("ICS_BS_ANNUL_PROG_REP_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_TRT_PR_TY_IC_BS_AN_PR_RE_ID was added.');

      v_sql_statement := 'ALTER TABLE "ICS_TRTMNT_PRCSS_TYPE"
 ADD ( CONSTRAINT "FK_TRTM_PRC_TYP_BS_ANN_PRO_REP"
 FOREIGN KEY("ICS_BS_ANNUL_PROG_REP_ID")
 REFERENCES ICS_BS_ANNUL_PROG_REP("ICS_BS_ANNUL_PROG_REP_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK  FK_TRTM_PRC_TYP_BS_ANN_PRO_REP  was added.');

    
     END;  

END;
/
 
   
/******************************************************************************************************** 

    Create new table ICS_VECTOR_A_REDUCTION_TYPE as child of ICS_BS_MGMT_PRACTICES

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_VECTOR_A_REDUCTION_TYPE exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_VECTOR_A_REDUCTION_TYPE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_VECTOR_A_REDUCTION_TYPE already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE ICS_VECTOR_A_REDUCTION_TYPE
    (
        ICS_VECTOR_A_REDUCTION_TYPE_ID VARCHAR2(36) NOT NULL,
        ICS_BS_MGMT_PRACTICES_ID VARCHAR2(36) NOT NULL,
        VECTOR_A_REDUCTION_TYPE_CODE VARCHAR2(3) NOT NULL,
        DATA_HASH VARCHAR2(100) NULL
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_VECTOR_A_REDUCTION_TYPE was added to the schema!');

      v_sql_statement := 'ALTER TABLE "ICS_VECTOR_A_REDUCTION_TYPE" 
 ADD ( CONSTRAINT "PK_VECTOR_A_REDUCTION_TYPE" 
 PRIMARY KEY("ICS_VECTOR_A_REDUCTION_TYPE_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_VECTOR_A_REDUCTION_TYPE  was added.');

      v_sql_statement := 'CREATE INDEX "IX_VCT_A_RDC_TY_IC_BS_MG_PR_ID" 
   ON "ICS_VECTOR_A_REDUCTION_TYPE"("ICS_BS_MGMT_PRACTICES_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_VCT_A_RDC_TY_IC_BS_MG_PR_ID  was added.');

      v_sql_statement := 'ALTER TABLE "ICS_VECTOR_A_REDUCTION_TYPE"
 ADD ( CONSTRAINT "FK_VCTR_A_RDCT_TYPE_BS_MGM_PRC"
 FOREIGN KEY("ICS_BS_MGMT_PRACTICES_ID")
 REFERENCES ICS_BS_MGMT_PRACTICES("ICS_BS_MGMT_PRACTICES_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_VCTR_A_RDCT_TYPE_BS_MGM_PRC   was added.');

    
     END;  

END;
/
 

-- -------------------------------------------------------------
-- ADD COLUMNS  
-- -------------------------------------------------------------
/******************************************************************************************************** 

    Add column ICS_BS_MGMT_PRACTICES_ID to table ICS_ADDR .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ICS_BS_MGMT_PRACTICES_ID column exists on the database table ICS_ADDR   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_ADDR'
      AND user_tab_cols.column_name = 'ICS_BS_MGMT_PRACTICES_ID';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_MGMT_PRACTICES_ID already existed on ICS_ADDR , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_ADDR  ADD ICS_BS_MGMT_PRACTICES_ID varchar2(36) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_MGMT_PRACTICES_ID was added to the table ICS_ADDR !');
      
      
      v_sql_statement := 'ALTER TABLE "ICS_ADDR"
	ADD ( CONSTRAINT "FK_ADDR_BS_MGMT_PRACTICES"
	FOREIGN KEY("ICS_BS_MGMT_PRACTICES_ID")
	REFERENCES ICS_BS_MGMT_PRACTICES("ICS_BS_MGMT_PRACTICES_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_ADDR_BS_MGMT_PRACTICES was added to the table ICS_ADDR !');
 
      v_sql_statement := 'CREATE INDEX "IX_ADDR_ICS_BS_MGMT_PRCTICS_ID"   
   ON "ICS_ADDR"("ICS_BS_MGMT_PRACTICES_ID")';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index  IX_ADDR_ICS_BS_MGMT_PRCTICS_ID was added.'); 
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_EFFECTIVE_DATE to table ICS_BASIC_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_EFFECTIVE_DATE column exists on the database table ICS_BASIC_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_BASIC_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_EFFECTIVE_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EFFECTIVE_DATE already existed on ICS_BASIC_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_BASIC_PRMT  ADD ELEC_REP_WAIVER_EFFECTIVE_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EFFECTIVE_DATE was added to the table ICS_BASIC_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_EXPR_DATE to table ICS_BASIC_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_EXPR_DATE column exists on the database table ICS_BASIC_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_BASIC_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_EXPR_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EXPR_DATE already existed on ICS_BASIC_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_BASIC_PRMT  ADD ELEC_REP_WAIVER_EXPR_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EXPR_DATE was added to the table ICS_BASIC_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_TYPE_CODE to table ICS_BASIC_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_TYPE_CODE column exists on the database table ICS_BASIC_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_BASIC_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_TYPE_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_TYPE_CODE already existed on ICS_BASIC_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_BASIC_PRMT  ADD ELEC_REP_WAIVER_TYPE_CODE varchar2(3) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_TYPE_CODE was added to the table ICS_BASIC_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CMPL_MON_PLANNED_END_DATE to table ICS_CMPL_MON .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CMPL_MON_PLANNED_END_DATE column exists on the database table ICS_CMPL_MON   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CMPL_MON'
      AND user_tab_cols.column_name = 'CMPL_MON_PLANNED_END_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_PLANNED_END_DATE already existed on ICS_CMPL_MON , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CMPL_MON  ADD CMPL_MON_PLANNED_END_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_PLANNED_END_DATE was added to the table ICS_CMPL_MON !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CMPL_MON_PLANNED_START_DATE to table ICS_CMPL_MON .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CMPL_MON_PLANNED_START_DATE column exists on the database table ICS_CMPL_MON   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CMPL_MON'
      AND user_tab_cols.column_name = 'CMPL_MON_PLANNED_START_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_PLANNED_START_DATE already existed on ICS_CMPL_MON , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CMPL_MON  ADD CMPL_MON_PLANNED_START_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_PLANNED_START_DATE was added to the table ICS_CMPL_MON !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ICS_BS_ANNUL_PROG_REP_ID to table ICS_CONTACT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ICS_BS_ANNUL_PROG_REP_ID column exists on the database table ICS_CONTACT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CONTACT'
      AND user_tab_cols.column_name = 'ICS_BS_ANNUL_PROG_REP_ID';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_ANNUL_PROG_REP_ID already existed on ICS_CONTACT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CONTACT  ADD ICS_BS_ANNUL_PROG_REP_ID varchar2(36) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_ANNUL_PROG_REP_ID was added to the table ICS_CONTACT !');
      
      v_sql_statement := 'CREATE INDEX "IX_CNTC_ICS_BS_ANNL_PRO_REP_ID"
	ON "ICS_CONTACT"("ICS_BS_ANNUL_PROG_REP_ID")';     
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_CNTC_ICS_BS_ANNL_PRO_REP_ID was added to the table ICS_CONTACT !');
 
 
      v_sql_statement := 'ALTER TABLE "ICS_CONTACT"
	ADD ( CONSTRAINT "FK_CONTACT_BS_ANNUL_PROG_REP"
	FOREIGN KEY("ICS_BS_ANNUL_PROG_REP_ID")
	REFERENCES ICS_BS_ANNUL_PROG_REP("ICS_BS_ANNUL_PROG_REP_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_CONTACT_BS_ANNUL_PROG_REP was added to the table ICS_CONTACT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ICS_BS_MGMT_PRACTICES_ID to table ICS_CONTACT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ICS_BS_MGMT_PRACTICES_ID column exists on the database table ICS_CONTACT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CONTACT'
      AND user_tab_cols.column_name = 'ICS_BS_MGMT_PRACTICES_ID';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_MGMT_PRACTICES_ID already existed on ICS_CONTACT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CONTACT  ADD ICS_BS_MGMT_PRACTICES_ID varchar2(36) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ICS_BS_MGMT_PRACTICES_ID was added to the table ICS_CONTACT !');


      v_sql_statement := 'CREATE INDEX "IX_CNTCT_ICS_BS_MGMT_PRCTCS_ID"
	ON "ICS_CONTACT"("ICS_BS_MGMT_PRACTICES_ID")';      
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The index IX_CNTCT_ICS_BS_MGMT_PRCTCS_ID was added to the table ICS_CONTACT !');
            
      v_sql_statement := 'ALTER TABLE "ICS_CONTACT"
	ADD ( CONSTRAINT "FK_CONTACT_BS_MGMT_PRACTICES"
	FOREIGN KEY("ICS_BS_MGMT_PRACTICES_ID")
	REFERENCES ICS_BS_MGMT_PRACTICES("ICS_BS_MGMT_PRACTICES_ID")
ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE VALIDATE )';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The FK FK_CONTACT_BS_MGMT_PRACTICES was added to the table ICS_CONTACT !');

    
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_SUBM_TYPE_CODE to table ICS_DSCH_MON_REP .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_SUBM_TYPE_CODE column exists on the database table ICS_DSCH_MON_REP   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_DSCH_MON_REP'
      AND user_tab_cols.column_name = 'ELEC_SUBM_TYPE_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_SUBM_TYPE_CODE already existed on ICS_DSCH_MON_REP , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_DSCH_MON_REP  ADD ELEC_SUBM_TYPE_CODE varchar2(3) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_SUBM_TYPE_CODE was added to the table ICS_DSCH_MON_REP !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_EFFECTIVE_DATE to table ICS_GNRL_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_EFFECTIVE_DATE column exists on the database table ICS_GNRL_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_GNRL_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_EFFECTIVE_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EFFECTIVE_DATE already existed on ICS_GNRL_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_GNRL_PRMT  ADD ELEC_REP_WAIVER_EFFECTIVE_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EFFECTIVE_DATE was added to the table ICS_GNRL_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_EXPR_DATE to table ICS_GNRL_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_EXPR_DATE column exists on the database table ICS_GNRL_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_GNRL_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_EXPR_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EXPR_DATE already existed on ICS_GNRL_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_GNRL_PRMT  ADD ELEC_REP_WAIVER_EXPR_DATE date NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_EXPR_DATE was added to the table ICS_GNRL_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_REP_WAIVER_TYPE_CODE to table ICS_GNRL_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_REP_WAIVER_TYPE_CODE column exists on the database table ICS_GNRL_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_GNRL_PRMT'
      AND user_tab_cols.column_name = 'ELEC_REP_WAIVER_TYPE_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_TYPE_CODE already existed on ICS_GNRL_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_GNRL_PRMT  ADD ELEC_REP_WAIVER_TYPE_CODE VARCHAR2(3) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_REP_WAIVER_TYPE_CODE was added to the table ICS_GNRL_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ELEC_SUBM_TYPE_CODE to table ICS_GNRL_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ELEC_SUBM_TYPE_CODE column exists on the database table ICS_GNRL_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_GNRL_PRMT'
      AND user_tab_cols.column_name = 'ELEC_SUBM_TYPE_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ELEC_SUBM_TYPE_CODE already existed on ICS_GNRL_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_GNRL_PRMT  ADD ELEC_SUBM_TYPE_CODE VARCHAR2(3) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ELEC_SUBM_TYPE_CODE was added to the table ICS_GNRL_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column FILE_NUM to table ICS_INFRML_ENFRC_ACTN .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if FILE_NUM column exists on the database table ICS_INFRML_ENFRC_ACTN   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_INFRML_ENFRC_ACTN'
      AND user_tab_cols.column_name = 'FILE_NUM';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column FILE_NUM already existed on ICS_INFRML_ENFRC_ACTN , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_INFRML_ENFRC_ACTN  ADD FILE_NUM VARCHAR2(50) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column FILE_NUM was added to the table ICS_INFRML_ENFRC_ACTN !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column TIER_LEVEL_NAME to table ICS_PRMT_FEATR .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if TIER_LEVEL_NAME column exists on the database table ICS_PRMT_FEATR   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_PRMT_FEATR'
      AND user_tab_cols.column_name = 'TIER_LEVEL_NAME';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column TIER_LEVEL_NAME already existed on ICS_PRMT_FEATR , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_PRMT_FEATR  ADD TIER_LEVEL_NAME VARCHAR2(3) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column TIER_LEVEL_NAME was added to the table ICS_PRMT_FEATR !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ANTIDEG_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ANTIDEG_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'ANTIDEG_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ANTIDEG_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD ANTIDEG_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ANTIDEG_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CATIONIC_CHEMS_AUTH_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CATIONIC_CHEMS_AUTH_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'CATIONIC_CHEMS_AUTH_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CATIONIC_CHEMS_AUTH_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD CATIONIC_CHEMS_AUTH_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CATIONIC_CHEMS_AUTH_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CATIONIC_CHEMS_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CATIONIC_CHEMS_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'CATIONIC_CHEMS_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CATIONIC_CHEMS_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD CATIONIC_CHEMS_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CATIONIC_CHEMS_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CGP_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CGP_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'CGP_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CGP_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD CGP_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CGP_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column CNST_SITE_OTHR_TXT to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CNST_SITE_OTHR_TXT column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'CNST_SITE_OTHR_TXT';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CNST_SITE_OTHR_TXT already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD CNST_SITE_OTHR_TXT VARCHAR2(255) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CNST_SITE_OTHR_TXT was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ERTH_DISTRB_ACTIVITIES_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ERTH_DISTRB_ACTIVITIES_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'ERTH_DISTRB_ACTIVITIES_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ERTH_DISTRB_ACTIVITIES_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD ERTH_DISTRB_ACTIVITIES_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ERTH_DISTRB_ACTIVITIES_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column ERTH_DISTRB_EMRGCY_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ERTH_DISTRB_EMRGCY_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'ERTH_DISTRB_EMRGCY_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ERTH_DISTRB_EMRGCY_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD ERTH_DISTRB_EMRGCY_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ERTH_DISTRB_EMRGCY_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column MS_4_DSCH_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if MS_4_DSCH_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'MS_4_DSCH_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column MS_4_DSCH_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD MS_4_DSCH_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column MS_4_DSCH_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column OTHR_PRMT_IDENT to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if OTHR_PRMT_IDENT column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'OTHR_PRMT_IDENT';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column OTHR_PRMT_IDENT already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD OTHR_PRMT_IDENT VARCHAR2(30) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column OTHR_PRMT_IDENT was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column PREDEV_LAND_USE_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if PREDEV_LAND_USE_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'PREDEV_LAND_USE_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column PREDEV_LAND_USE_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD PREDEV_LAND_USE_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column PREDEV_LAND_USE_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column PREVIOUS_SW_DSCH_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if PREVIOUS_SW_DSCH_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'PREVIOUS_SW_DSCH_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column PREVIOUS_SW_DSCH_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD PREVIOUS_SW_DSCH_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column PREVIOUS_SW_DSCH_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column PRIOR_SURVEYS_EVALS_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if PRIOR_SURVEYS_EVALS_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'PRIOR_SURVEYS_EVALS_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column PRIOR_SURVEYS_EVALS_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD PRIOR_SURVEYS_EVALS_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column PRIOR_SURVEYS_EVALS_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column SBSRFC_ERTH_DSTRBN_CONTROL_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if SBSRFC_ERTH_DSTRBN_CONTROL_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'SBSRFC_ERTH_DSTRBN_CONTROL_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column SBSRFC_ERTH_DSTRBN_CONTROL_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD SBSRFC_ERTH_DSTRBN_CONTROL_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column SBSRFC_ERTH_DSTRBN_CONTROL_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column SBSRFC_ERTH_DSTRBN_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if SBSRFC_ERTH_DSTRBN_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'SBSRFC_ERTH_DSTRBN_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column SBSRFC_ERTH_DSTRBN_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD SBSRFC_ERTH_DSTRBN_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column SBSRFC_ERTH_DSTRBN_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column STRCT_DEMOED_FLOOR_SPACE_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if STRCT_DEMOED_FLOOR_SPACE_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'STRCT_DEMOED_FLOOR_SPACE_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column STRCT_DEMOED_FLOOR_SPACE_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD STRCT_DEMOED_FLOOR_SPACE_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column STRCT_DEMOED_FLOOR_SPACE_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column STRCT_DEMOED_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if STRCT_DEMOED_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'STRCT_DEMOED_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column STRCT_DEMOED_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD STRCT_DEMOED_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column STRCT_DEMOED_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column SWPPP_PREP_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if SWPPP_PREP_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'SWPPP_PREP_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column SWPPP_PREP_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD SWPPP_PREP_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column SWPPP_PREP_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column TRTMNT_CHEMS_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if TRTMNT_CHEMS_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'TRTMNT_CHEMS_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column TRTMNT_CHEMS_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD TRTMNT_CHEMS_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column TRTMNT_CHEMS_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column WTR_PROX_IND to table ICS_SW_CNST_PRMT .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if WTR_PROX_IND column exists on the database table ICS_SW_CNST_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_CNST_PRMT'
      AND user_tab_cols.column_name = 'WTR_PROX_IND';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column WTR_PROX_IND already existed on ICS_SW_CNST_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_CNST_PRMT  ADD WTR_PROX_IND CHAR(1) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column WTR_PROX_IND was added to the table ICS_SW_CNST_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column LOC_ADDR_CITY_CODE to table ICS_UNPRMT_FAC .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if LOC_ADDR_CITY_CODE column exists on the database table ICS_UNPRMT_FAC   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_UNPRMT_FAC'
      AND user_tab_cols.column_name = 'LOC_ADDR_CITY_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_CITY_CODE already existed on ICS_UNPRMT_FAC , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_UNPRMT_FAC  ADD LOC_ADDR_CITY_CODE varchar2(12) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_CITY_CODE was added to the table ICS_UNPRMT_FAC !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    Add column LOC_ADDR_COUNTY_CODE to table ICS_UNPRMT_FAC .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if LOC_ADDR_COUNTY_CODE column exists on the database table ICS_UNPRMT_FAC   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_UNPRMT_FAC'
      AND user_tab_cols.column_name = 'LOC_ADDR_COUNTY_CODE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE already existed on ICS_UNPRMT_FAC , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_UNPRMT_FAC  ADD LOC_ADDR_COUNTY_CODE CHAR(5) NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE was added to the table ICS_UNPRMT_FAC !');
      
     END;  

END;
/ 

/******************************************************************************************************** 

    Add column BS_ANNUL_REP_RCVD_DATE to table ICS_SUBM_RESULTS .
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if BS_ANNUL_REP_RCVD_DATE column exists on the database table ICS_SUBM_RESULTS   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SUBM_RESULTS'
      AND user_tab_cols.column_name = 'BS_ANNUL_REP_RCVD_DATE';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column BS_ANNUL_REP_RCVD_DATE already existed on ICS_SUBM_RESULTS , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SUBM_RESULTS ADD BS_ANNUL_REP_RCVD_DATE DATE NULL';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column BS_ANNUL_REP_RCVD_DATE was added to the table ICS_SUBM_RESULTS !');
      
     END;  

END;
/ 

 
-- ------------------------------------------------------
--  ALTER COLUMNS
-- ------------------------------------------------------


/******************************************************************************************************** 

    MODIFY column ASSC_PRMT_IDENT ON ICS_ASSC_PRMT  to CHAR(9) NULL  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if ASSC_PRMT_IDENT column exists on the database table ICS_ASSC_PRMT   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_ASSC_PRMT'
      AND user_tab_cols.column_name = 'ASSC_PRMT_IDENT'
      AND user_tab_cols.data_type = 'CHAR'
      AND user_tab_cols.data_length = 9
      AND user_tab_cols.nullable = 'Y';

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column ASSC_PRMT_IDENT already has correct type on ICS_ASSC_PRMT , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_ASSC_PRMT  MODIFY ASSC_PRMT_IDENT CHAR(9) NULL ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column ASSC_PRMT_IDENT was modified in table ICS_ASSC_PRMT !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column CMPL_MON_IDENT ON ICS_CMPL_MON_LNK  to VARCHAR(25) NOT NULL  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CMPL_MON_IDENT column exists on the database table ICS_CMPL_MON_LNK   */
  SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CMPL_MON_LNK'
      AND user_tab_cols.column_name = 'CMPL_MON_IDENT'
      AND user_tab_cols.data_type = 'VARCHAR2'
      AND user_tab_cols.data_length = 25
      AND user_tab_cols.nullable = 'N';

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_IDENT already has correct type on ICS_CMPL_MON_LNK , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
      

      -- UPDATE Any NULLs with unique fake IDs
      update ICS_CMPL_MON_LNK SET CMPL_MON_IDENT = SUBSTR('XX' || sys_guid(),0,20)  where CMPL_MON_IDENT  is null;
            
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CMPL_MON_LNK  MODIFY CMPL_MON_IDENT VARCHAR(25) NOT NULL ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_IDENT was modified in table ICS_CMPL_MON_LNK !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column FINAL_ORDER_IDENT ON ICS_CMPL_SCHD_EVT_VIOL_ELEM  to int NULL  (make nullable)
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if FINAL_ORDER_IDENT column exists on the database table ICS_CMPL_SCHD_EVT_VIOL_ELEM   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_CMPL_SCHD_EVT_VIOL_ELEM'
      AND user_tab_cols.column_name = 'FINAL_ORDER_IDENT'
      AND user_tab_cols.data_type = 'NUMBER'
     -- AND user_tab_cols.data_length = XX
      AND user_tab_cols.nullable = 'Y'; 

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column FINAL_ORDER_IDENT already has correct type on ICS_CMPL_SCHD_EVT_VIOL_ELEM , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_CMPL_SCHD_EVT_VIOL_ELEM  MODIFY FINAL_ORDER_IDENT NUMBER(10,0) NULL ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column FINAL_ORDER_IDENT was modified in table ICS_CMPL_SCHD_EVT_VIOL_ELEM !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column LOC_ADDR_COUNTY_CODE ON ICS_FAC  to CHAR(5) NULL  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if LOC_ADDR_COUNTY_CODE column exists on the database table ICS_FAC   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_FAC'
      AND user_tab_cols.column_name = 'LOC_ADDR_COUNTY_CODE'
      AND user_tab_cols.data_type = 'CHAR';
     
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE already has correct type on ICS_FAC , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_FAC  MODIFY LOC_ADDR_COUNTY_CODE CHAR(5) ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE was modified in table ICS_FAC !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column CMPL_MON_IDENT ON ICS_LNK_ST_CMPL_MON  to VARCHAR(25) NOT NULL  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if CMPL_MON_IDENT column exists on the database table ICS_LNK_ST_CMPL_MON   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_LNK_ST_CMPL_MON'
      AND user_tab_cols.column_name = 'CMPL_MON_IDENT'
      AND user_tab_cols.data_type = 'VARCHAR2'
      AND user_tab_cols.data_length = 25
      AND user_tab_cols.nullable = 'N';  

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_IDENT already has correct type on ICS_LNK_ST_CMPL_MON , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
      -- Fill in nulls with fake ID
      update ICS_LNK_ST_CMPL_MON set CMPL_MON_IDENT = SUBSTR('XX' || sys_guid(),0,20) where CMPL_MON_IDENT is null;
   
      
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_LNK_ST_CMPL_MON  MODIFY CMPL_MON_IDENT VARCHAR(25) NOT NULL ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column CMPL_MON_IDENT was modified in table ICS_LNK_ST_CMPL_MON !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column EST_AREA_DISTURBED_ACRES_NUM ON ICS_SW_UNPRMT_CNST_INSP  to DECIMAL(13,2)  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if EST_AREA_DISTURBED_ACRES_NUM column exists on the database table ICS_SW_UNPRMT_CNST_INSP   */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_SW_UNPRMT_CNST_INSP'
      AND user_tab_cols.column_name = 'EST_AREA_DISTURBED_ACRES_NUM'
      AND user_tab_cols.data_type = 'NUMBER'
      AND user_tab_cols.data_precision = 13
      AND user_tab_cols.data_scale = 2;      

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column EST_AREA_DISTURBED_ACRES_NUM already has correct type on ICS_SW_UNPRMT_CNST_INSP , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_SW_UNPRMT_CNST_INSP  MODIFY EST_AREA_DISTURBED_ACRES_NUM DECIMAL(13,2) ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column EST_AREA_DISTURBED_ACRES_NUM was modified in table ICS_SW_UNPRMT_CNST_INSP !');
      
     END;  

END;
/ 
 
   
/******************************************************************************************************** 

    MODIFY column LOC_ADDR_COUNTY_CODE ON ICS_UNPRMT_FAC  to CHAR(5) NULL  
*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if LOC_ADDR_COUNTY_CODE column exists on the database table ICS_UNPRMT_FAC   */
   SELECT 1
     INTO v_object_ind
    FROM user_tables
     JOIN user_tab_cols
       ON user_tab_cols.table_name = user_tables.table_name
    WHERE user_tables.table_name = 'ICS_UNPRMT_FAC'
      AND user_tab_cols.column_name = 'LOC_ADDR_COUNTY_CODE'
      AND user_tab_cols.data_type = 'CHAR';

   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE already has correct type on ICS_UNPRMT_FAC , schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Add new column 
      v_sql_statement := 'ALTER TABLE ICS_UNPRMT_FAC  MODIFY LOC_ADDR_COUNTY_CODE CHAR(5) ';
      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The column LOC_ADDR_COUNTY_CODE was modified in table ICS_UNPRMT_FAC !');
      
     END;  

END;
/ 
 
 
 Insert into ICS_PAYLOAD (ICS_PAYLOAD_ID,OPERATION,ENABLED,AUTO_GEN_DELETES,BASE_TABLE_NAME,ETL_PROCEDURE)
 SELECT 'BiosolidsAnnualProgramReport','BiosolidsAnnualProgramReportSubmission','Y','Y','ICS_BS_ANNUL_PROG_REP',null from dual where not exists (select 1 from ICS_PAYLOAD where ICS_PAYLOAD_ID = 'BiosolidsAnnualReport')
 ; 
 commit;
 
 
 
/******************************************************************************************************** 

    Create new table ICS_ABOUT_DB

*********************************************************************************************************/

DECLARE

  v_object_ind NUMBER(01) := 0;
  v_sql_statement VARCHAR2(4000);

BEGIN 

  /*  Check to see if table ICS_ABOUT_DB exists  */
   SELECT 1
     INTO v_object_ind
     FROM user_tables
    WHERE user_tables.table_name = 'ICS_ABOUT_DB';
   
   /* The column already exists in schema, bypass creation */
    DBMS_OUTPUT.PUT_LINE( 'The table ICS_ABOUT_DB already exists, schema alteration bypassed!');

EXCEPTION

  WHEN NO_DATA_FOUND THEN  
  
    BEGIN
       
      --  Create table
      v_sql_statement := 'CREATE TABLE "ICS_ABOUT_DB"
    (
      ICS_ABOUT_DB_ID VARCHAR2(36) NOT NULL
      ,DATA_KEY VARCHAR2(50) NOT NULL
      ,DATA_VALUE VARCHAR2(4000)
    )';

      EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The table ICS_ABOUT_DB was added to the schema!');
      
      v_sql_statement := 'ALTER TABLE "ICS_ABOUT_DB" 
 ADD ( CONSTRAINT "PK_ABOUT_DB" 
 PRIMARY KEY("ICS_ABOUT_DB_ID") 
 NOT DEFERRABLE INITIALLY IMMEDIATE)';
     EXECUTE IMMEDIATE v_sql_statement;   
      DBMS_OUTPUT.PUT_LINE( 'The prmary key for ICS_ABOUT_DB  was added.');
    
     END;  

END;
/
   
   insert into ICS_ABOUT_DB(ICS_ABOUT_DB_ID,DATA_KEY,DATA_VALUE) VALUES(sys_guid(),'ICIS_NPDES_VERSION','5.8');
   insert into ICS_ABOUT_DB(ICS_ABOUT_DB_ID,DATA_KEY,DATA_VALUE) VALUES(sys_guid(),'UPDATE_DATE',sysdate);
   insert into ICS_ABOUT_DB(ICS_ABOUT_DB_ID,DATA_KEY,DATA_VALUE) VALUES(sys_guid(),'UPDATE_ANALYST','Windsor');
   
commit;
   
   -- Create (or re-create) Java Node Supporting Views for 5.8
   
  CREATE OR REPLACE FORCE  VIEW "ICS_FLOW_LOCAL"."ICS_CERT_PROG_REP_CONTACT" ("ICS_CERT_PROG_REP_CONTACT_ID", "ICS_CONTACT_ID") AS 
  SELECT
    ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID  as ICS_CERT_PROG_REP_CONTACT_ID,
    ICS_CONTACT.ICS_CONTACT_ID
  from ICS_BS_ANNUL_PROG_REP, ICS_CONTACT
  where ICS_BS_ANNUL_PROG_REP.ICS_BS_ANNUL_PROG_REP_ID = ICS_CONTACT.ICS_BS_ANNUL_PROG_REP_ID;
 
  CREATE OR REPLACE FORCE  VIEW "ICS_FLOW_LOCAL"."ICS_THIRD_PTY_PROG_REP_ADDR" ("THIRD_PTY_PROG_REP_ADDR_ID", "ICS_ADDR_ID") AS 
  SELECT
  ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID  as THIRD_PTY_PROG_REP_ADDR_ID,
  ICS_ADDR.ICS_ADDR_ID
from ICS_BS_MGMT_PRACTICES, ICS_ADDR
where ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID = ICS_ADDR.ICS_BS_MGMT_PRACTICES_ID;

  CREATE OR REPLACE FORCE  VIEW "ICS_FLOW_LOCAL"."ICS_THIRD_PTY_PROG_REP_CONTACT" ("THIRD_PTY_PROG_REP_CONTACT_ID", "ICS_CONTACT_ID") AS 
  select
  ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID as THIRD_PTY_PROG_REP_CONTACT_ID,
  ICS_CONTACT.ICS_CONTACT_ID
from ICS_BS_MGMT_PRACTICES, ICS_CONTACT
where ICS_BS_MGMT_PRACTICES.ICS_BS_MGMT_PRACTICES_ID = ICS_CONTACT.ICS_BS_MGMT_PRACTICES_ID;
   
 -- INSERT INTO ICS_PAYLOAD  BiosolidsAnnualProgramReport
INSERT INTO ICS_PAYLOAD (ICS_PAYLOAD_ID,OPERATION,ENABLED,AUTO_GEN_DELETES,BASE_TABLE_NAME)
  SELECT 'BiosolidsAnnualProgramReport','BiosolidsAnnualProgramReportSubmission','N','N','ICS_BS_ANNUL_PROG_REP' 
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM ICS_PAYLOAD WHERE ICS_PAYLOAD_ID = 'BiosolidsAnnualProgramReport');


-- Set BASE_TABLE_NAME in ICS_PAYLOAD

UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_BASIC_PRMT' WHERE ICS_PAYLOAD_ID = 'BasicPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_BS_ANNUL_PROG_REP' WHERE ICS_PAYLOAD_ID = 'BiosolidsAnnualProgramReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_BS_PRMT' WHERE ICS_PAYLOAD_ID = 'BiosolidsPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_BS_PROG_REP' WHERE ICS_PAYLOAD_ID = 'BiosolidsProgramReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CAFO_ANNUL_REP' WHERE ICS_PAYLOAD_ID = 'CAFOAnnualReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CAFO_PRMT' WHERE ICS_PAYLOAD_ID = 'CAFOPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CMPL_MON' WHERE ICS_PAYLOAD_ID = 'ComplianceMonitoring';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CMPL_MON_LNK' WHERE ICS_PAYLOAD_ID = 'ComplianceMonitoringLinkage';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CMPL_SCHD' WHERE ICS_PAYLOAD_ID = 'ComplianceSchedule';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CSO_EVT_REP' WHERE ICS_PAYLOAD_ID = 'CSOEventReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_CSO_PRMT' WHERE ICS_PAYLOAD_ID = 'CSOPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_DSCH_MON_REP' WHERE ICS_PAYLOAD_ID = 'DischargeMonitoringReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_DMR_PROG_REP_LNK' WHERE ICS_PAYLOAD_ID = 'DMRProgramReportLinkage';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_DMR_VIOL' WHERE ICS_PAYLOAD_ID = 'DMRViolation';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_EFFLU_TRADE_PRTNER' WHERE ICS_PAYLOAD_ID = 'EffluentTradePartner';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_ENFRC_ACTN_MILESTONE' WHERE ICS_PAYLOAD_ID = 'EnforcementActionMilestone';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_ENFRC_ACTN_VIOL_LNK' WHERE ICS_PAYLOAD_ID = 'EnforcementActionViolationLinkage';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_FINAL_ORDER_VIOL_LNK' WHERE ICS_PAYLOAD_ID = 'FinalOrderViolationLinkage';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_FRML_ENFRC_ACTN' WHERE ICS_PAYLOAD_ID = 'FormalEnforcementAction';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_GNRL_PRMT' WHERE ICS_PAYLOAD_ID = 'GeneralPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_HIST_PRMT_SCHD_EVTS' WHERE ICS_PAYLOAD_ID = 'HistoricalPermitScheduleEvents';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_INFRML_ENFRC_ACTN' WHERE ICS_PAYLOAD_ID = 'InformalEnforcementAction';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_LMTS' WHERE ICS_PAYLOAD_ID = 'Limits';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_LMT_SET' WHERE ICS_PAYLOAD_ID = 'LimitSet';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_LOC_LMTS_PROG_REP' WHERE ICS_PAYLOAD_ID = 'LocalLimitsProgramReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_MASTER_GNRL_PRMT' WHERE ICS_PAYLOAD_ID = 'MasterGeneralPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_NARR_COND_SCHD' WHERE ICS_PAYLOAD_ID = 'NarrativeConditionSchedule';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PARAM_LMTS' WHERE ICS_PAYLOAD_ID = 'ParameterLimits';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRMT_REISSU' WHERE ICS_PAYLOAD_ID = 'PermitReissuance';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRMT_FEATR' WHERE ICS_PAYLOAD_ID = 'PermittedFeature';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRMT_TERM' WHERE ICS_PAYLOAD_ID = 'PermitTermination';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRMT_TRACK_EVT' WHERE ICS_PAYLOAD_ID = 'PermitTrackingEvent';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_POTW_PRMT' WHERE ICS_PAYLOAD_ID = 'POTWPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRETR_PERF_SUMM' WHERE ICS_PAYLOAD_ID = 'PretreatmentPerformanceSummary';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_PRETR_PRMT' WHERE ICS_PAYLOAD_ID = 'PretreatmentPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SCHD_EVT_VIOL' WHERE ICS_PAYLOAD_ID = 'ScheduleEventViolation';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SNGL_EVT_VIOL' WHERE ICS_PAYLOAD_ID = 'SingleEventViolation';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SSO_ANNUL_REP' WHERE ICS_PAYLOAD_ID = 'SSOAnnualReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SSO_EVT_REP' WHERE ICS_PAYLOAD_ID = 'SSOEventReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SSO_MONTHLY_EVT_REP' WHERE ICS_PAYLOAD_ID = 'SSOMonthlyEventReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SW_CNST_PRMT' WHERE ICS_PAYLOAD_ID = 'SWConstructionPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SW_EVT_REP' WHERE ICS_PAYLOAD_ID = 'SWEventReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SW_INDST_ANNUL_REP' WHERE ICS_PAYLOAD_ID = 'SWIndustrialAnnualReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SW_INDST_PRMT' WHERE ICS_PAYLOAD_ID = 'SWIndustrialPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SWMS_4_LARGE_PRMT' WHERE ICS_PAYLOAD_ID = 'SWMS4LargePermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SWMS_4_PROG_REP' WHERE ICS_PAYLOAD_ID = 'SWMS4ProgramReport';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_SWMS_4_SMALL_PRMT' WHERE ICS_PAYLOAD_ID = 'SWMS4SmallPermit';
UPDATE ICS_PAYLOAD SET BASE_TABLE_NAME = 'ICS_UNPRMT_FAC' WHERE ICS_PAYLOAD_ID = 'UnpermittedFacility';

