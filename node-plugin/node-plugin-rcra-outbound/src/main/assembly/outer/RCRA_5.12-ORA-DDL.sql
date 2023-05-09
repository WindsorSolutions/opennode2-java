create table RCRA_CA_SUBM
(
    CA_SUBM_ID VARCHAR2(40) not null
        constraint PK_CA_SUBM
            primary key
)
/

create table RCRA_CA_FAC_SUBM
(
    CA_FAC_SUBM_ID VARCHAR2(40) not null
        constraint PK_CA_FAC_SUBM
            primary key,
    CA_SUBM_ID     VARCHAR2(40) not null
        constraint FK_CA_FAC_SUBM_CA_SUBM
            references RCRA_CA_SUBM
                on delete cascade,
    HANDLER_ID     VARCHAR2(12) not null
)
/

create table RCRA_CA_AREA
(
    CA_AREA_ID                     VARCHAR2(40) not null
        constraint PK_CA_AREA
            primary key,
    CA_FAC_SUBM_ID                 VARCHAR2(40) not null
        constraint FK_CA_AREA_CA_FAC_SUBM
            references RCRA_CA_FAC_SUBM
                on delete cascade,
    TRANS_CODE                     CHAR,
    AREA_SEQ_NUM                   NUMBER(10),
    FAC_WIDE_IND                   CHAR,
    AREA_NAME                      VARCHAR2(40),
    AIR_REL_IND                    CHAR,
    GROUNDWATER_REL_IND            CHAR,
    SOIL_REL_IND                   CHAR,
    SURFACE_WATER_REL_IND          CHAR,
    REGULATED_UNIT_IND             CHAR,
    EPA_RESP_PERSON_DATA_OWNER_CDE CHAR(2),
    EPA_RESP_PERSON_ID             VARCHAR2(5),
    STA_RESP_PERSON_DATA_OWNER_CDE CHAR(2),
    STA_RESP_PERSON_ID             VARCHAR2(5),
    SUPP_INFO_TXT                  VARCHAR2(2000),
    CREATED_BY_USERID              VARCHAR2(255),
    A_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE
)
/

create index IX_CA_AREA_CA_FAC_SUBM_ID
    on RCRA_CA_AREA (CA_FAC_SUBM_ID)
/

create table RCRA_CA_AREA_REL_EVENT
(
    CA_AREA_REL_EVENT_ID           VARCHAR2(40) not null
        constraint PK_CA_AREA_REL_EVENT
            primary key,
    CA_AREA_ID                     VARCHAR2(40) not null
        constraint FK_CA_AREA_REL_EVENT_CA_AREA
            references RCRA_CA_AREA
                on delete cascade,
    TRANS_CODE                     CHAR,
    ACT_LOC_CODE                   CHAR(2)      not null,
    CORCT_ACT_EVENT_DATA_OWNER_CDE CHAR(2)      not null,
    CORCT_ACT_EVENT_CODE           VARCHAR2(7)  not null,
    EVENT_AGN_CODE                 CHAR         not null,
    EVENT_SEQ_NUM                  NUMBER(10)   not null
)
/

create index IX_CA_AREA_REL_EVENT_CA_ARA_ID
    on RCRA_CA_AREA_REL_EVENT (CA_AREA_ID)
/

create table RCRA_CA_AUTHORITY
(
    CA_AUTHORITY_ID                VARCHAR2(40) not null
        constraint PK_CA_AUTHORITY
            primary key,
    CA_FAC_SUBM_ID                 VARCHAR2(40) not null
        constraint FK_CA_AUTHORITY_CA_FAC_SUBM
            references RCRA_CA_FAC_SUBM
                on delete cascade,
    TRANS_CODE                     CHAR,
    ACT_LOC_CODE                   CHAR(2)      not null,
    AUTHORITY_DATA_OWNER_CODE      CHAR(2)      not null,
    AUTHORITY_TYPE_CODE            CHAR         not null,
    AUTHORITY_AGN_CODE             CHAR         not null,
    AUTHORITY_EFFC_DATE            DATE         not null,
    ISSUE_DATE                     DATE,
    END_DATE                       DATE,
    ESTABLISHED_REPOSITORY_CODE    CHAR,
    RESP_LEAD_PROG_IDEN            CHAR,
    AUTHORITY_SUBORG_DATA_OWNR_CDE CHAR(2),
    AUTHORITY_SUBORG_CODE          VARCHAR2(10),
    RESP_PERSON_DATA_OWNER_CODE    CHAR(2),
    RESP_PERSON_ID                 VARCHAR2(5),
    SUPP_INFO_TXT                  VARCHAR2(2000),
    CREATED_BY_USERID              VARCHAR2(255),
    A_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE
)
/

create table RCRA_CA_AUTH_REL_EVENT
(
    CA_AUTH_REL_EVENT_ID           VARCHAR2(40) not null
        constraint PK_CA_AUTH_REL_EVENT
            primary key,
    CA_AUTHORITY_ID                VARCHAR2(40) not null
        constraint FK_CA_AUTH_RL_EVNT_CA_AUTHORTY
            references RCRA_CA_AUTHORITY
                on delete cascade,
    TRANS_CODE                     CHAR,
    ACT_LOC_CODE                   CHAR(2)      not null,
    CORCT_ACT_EVENT_DATA_OWNER_CDE CHAR(2)      not null,
    CORCT_ACT_EVENT_CODE           VARCHAR2(7)  not null,
    EVENT_AGN_CODE                 CHAR         not null,
    EVENT_SEQ_NUM                  NUMBER(10)   not null
)
/

create index IX_CA_ATH_RL_EVNT_CA_ATHRTY_ID
    on RCRA_CA_AUTH_REL_EVENT (CA_AUTHORITY_ID)
/

create index IX_CA_AUTHORITY_CA_FAC_SUBM_ID
    on RCRA_CA_AUTHORITY (CA_FAC_SUBM_ID)
/

create table RCRA_CA_EVENT
(
    CA_EVENT_ID                    VARCHAR2(40) not null
        constraint PK_CA_EVENT
            primary key,
    CA_FAC_SUBM_ID                 VARCHAR2(40) not null
        constraint FK_CA_EVENT_CA_FAC_SUBM
            references RCRA_CA_FAC_SUBM
                on delete cascade,
    TRANS_CODE                     CHAR,
    ACT_LOC_CODE                   CHAR(2)      not null,
    CORCT_ACT_EVENT_DATA_OWNER_CDE CHAR(2)      not null,
    CORCT_ACT_EVENT_CODE           VARCHAR2(7)  not null,
    EVENT_AGN_CODE                 CHAR         not null,
    EVENT_SEQ_NUM                  NUMBER(10)   not null,
    ACTL_DATE                      DATE,
    ORIGINAL_SCHEDULE_DATE         DATE,
    NEW_SCHEDULE_DATE              DATE,
    EVENT_SUBORG_DATA_OWNER_CODE   CHAR(2),
    EVENT_SUBORG_CODE              VARCHAR2(10),
    RESP_PERSON_DATA_OWNER_CODE    CHAR(2),
    RESP_PERSON_ID                 VARCHAR2(5),
    SUPP_INFO_TXT                  VARCHAR2(2000),
    PUBLIC_SUPP_INFO_TXT           VARCHAR2(2000),
    CREATED_BY_USERID              VARCHAR2(255),
    A_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE
)
/

create index IX_CA_EVENT_CA_FAC_SUBM_ID
    on RCRA_CA_EVENT (CA_FAC_SUBM_ID)
/

create table RCRA_CA_EVENT_COMMITMENT
(
    CA_EVENT_COMMITMENT_ID VARCHAR2(40) not null
        constraint PK_CA_EVENT_COMMITMENT
            primary key,
    CA_EVENT_ID            VARCHAR2(40) not null
        constraint FK_CA_EVENT_COMMITMENT_CA_EVNT
            references RCRA_CA_EVENT
                on delete cascade,
    TRANS_CODE             CHAR,
    COMMIT_LEAD            CHAR(2)      not null,
    COMMIT_SEQ_NUM         NUMBER(10)   not null
)
/

create index IX_CA_EVNT_COMMTMNT_CA_EVNT_ID
    on RCRA_CA_EVENT_COMMITMENT (CA_EVENT_ID)
/

create index IX_CA_FAC_SUBM_CA_SUBM_ID
    on RCRA_CA_FAC_SUBM (CA_SUBM_ID)
/

create table RCRA_CA_REL_PERMIT_UNIT
(
    CA_REL_PERMIT_UNIT_ID VARCHAR2(40) not null
        constraint PK_CA_REL_PERMIT_UNIT
            primary key,
    CA_AREA_ID            VARCHAR2(40) not null
        constraint FK_CA_REL_PERMIT_UNIT_CA_AREA
            references RCRA_CA_AREA
                on delete cascade,
    TRANS_CODE            CHAR,
    PERMIT_UNIT_SEQ_NUM   NUMBER(10)
)
/

create index IX_CA_REL_PERMIT_UNT_CA_ARA_ID
    on RCRA_CA_REL_PERMIT_UNIT (CA_AREA_ID)
/

create table RCRA_CA_STATUTORY_CITATION
(
    CA_STATUTORY_CITATION_ID       VARCHAR2(40) not null
        constraint PK_CA_STATUTORY_CITATION
            primary key,
    CA_AUTHORITY_ID                VARCHAR2(40) not null
        constraint FK_CA_STTUTRY_CITTON_CA_ATHRTY
            references RCRA_CA_AUTHORITY
                on delete cascade,
    TRANS_CODE                     CHAR,
    STATUTORY_CITTION_DTA_OWNR_CDE CHAR(2)      not null,
    STATUTORY_CITATION_IDEN        CHAR         not null
)
/

create index IX_CA_STTTRY_CTTN_CA_ATHRTY_ID
    on RCRA_CA_STATUTORY_CITATION (CA_AUTHORITY_ID)
/

create table RCRA_CME_SUBM
(
    CME_SUBM_ID VARCHAR2(40) not null
        constraint PK_CME_SUBM
            primary key
)
/

create table RCRA_CME_FAC_SUBM
(
    CME_FAC_SUBM_ID VARCHAR2(40) not null
        constraint PK_CME_FAC_SUBM
            primary key,
    CME_SUBM_ID     VARCHAR2(40) not null
        constraint FK_CME_FAC_SUBM_CME_SUBM
            references RCRA_CME_SUBM
                on delete cascade,
    EPA_HDLR_ID     CHAR(12)     not null
)
/

create table RCRA_CME_ENFRC_ACT
(
    CME_ENFRC_ACT_ID              VARCHAR2(40) not null
        constraint PK_CME_ENFRC_ACT
            primary key,
    CME_FAC_SUBM_ID               VARCHAR2(40) not null
        constraint FK_CME_ENFRC_ACT_CME_FAC_SUBM
            references RCRA_CME_FAC_SUBM
                on delete cascade,
    TRANS_CODE                    CHAR,
    ENFRC_AGN_LOC_NAME            CHAR(2)      not null,
    ENFRC_ACT_IDEN                VARCHAR2(3)  not null,
    ENFRC_ACT_DATE                DATE         not null,
    ENFRC_AGN_NAME                CHAR         not null,
    ENFRC_DOCKET_NUM              VARCHAR2(15),
    ENFRC_ATTRY                   VARCHAR2(5),
    CORCT_ACT_COMPT               CHAR,
    CNST_AGMT_FINAL_ORDER_SEQ_NUM NUMBER(10),
    APPEAL_INIT_DATE              DATE,
    APPEAL_RSLN_DATE              DATE,
    DISP_STAT_DATE                DATE,
    DISP_STAT_OWNER               CHAR(2),
    DISP_STAT                     CHAR(2),
    ENFRC_OWNER                   CHAR(2),
    ENFRC_TYPE                    CHAR(3),
    ENFRC_RESP_PERSON_OWNER       CHAR(2),
    ENFRC_RESP_PERSON_IDEN        VARCHAR2(5),
    ENFRC_RESP_SUBORG_OWNER       CHAR(2),
    ENFRC_RESP_SUBORG             VARCHAR2(10),
    NOTES                         VARCHAR2(4000),
    CREATED_BY_USERID             VARCHAR2(255),
    C_CREATED_DATE                DATE,
    DATA_ORIG                     CHAR(2),
    LAST_UPDT_BY                  VARCHAR2(255),
    LAST_UPDT_DATE                DATE,
    FA_REQUIRED                   CHAR
)
/

create table RCRA_CME_CSNY_DATE
(
    CME_CSNY_DATE_ID VARCHAR2(40) not null
        constraint PK_CME_CSNY_DATE
            primary key,
    CME_ENFRC_ACT_ID VARCHAR2(40) not null
        constraint FK_CME_CSNY_DATE_CME_ENFRC_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE       CHAR,
    SNY_DATE         DATE         not null
)
/

create index IX_CME_CSNY_DTE_CME_ENF_ACT_ID
    on RCRA_CME_CSNY_DATE (CME_ENFRC_ACT_ID)
/

create index IX_CME_ENFRC_ACT_CME_FC_SBM_ID
    on RCRA_CME_ENFRC_ACT (CME_FAC_SUBM_ID)
/

create table RCRA_CME_EVAL
(
    CME_EVAL_ID                 VARCHAR2(40) not null
        constraint PK_CME_EVAL
            primary key,
    CME_FAC_SUBM_ID             VARCHAR2(40) not null
        constraint FK_CME_EVAL_CME_FAC_SUBM
            references RCRA_CME_FAC_SUBM
                on delete cascade,
    TRANS_CODE                  CHAR,
    EVAL_ACT_LOC                CHAR(2)      not null,
    EVAL_IDEN                   VARCHAR2(3)  not null,
    EVAL_START_DATE             DATE         not null,
    EVAL_RESP_AGN               CHAR         not null,
    DAY_ZERO                    DATE,
    FOUND_VIOL                  CHAR,
    CTZN_CPLT_IND               CHAR,
    MULTIMEDIA_IND              CHAR,
    SAMPL_IND                   CHAR,
    NOT_SUBTL_C_IND             CHAR,
    EVAL_TYPE_OWNER             CHAR(2),
    EVAL_TYPE                   VARCHAR2(3),
    FOCUS_AREA_OWNER            CHAR(2),
    FOCUS_AREA                  VARCHAR2(3),
    EVAL_RESP_PERSON_IDEN_OWNER CHAR(2),
    EVAL_RESP_PERSON_IDEN       VARCHAR2(5),
    EVAL_RESP_SUBORG_OWNER      CHAR(2),
    EVAL_RESP_SUBORG            VARCHAR2(10),
    NOTES                       VARCHAR2(4000),
    NOC_DATE                    DATE,
    CREATED_BY_USERID           VARCHAR2(255),
    C_CREATED_DATE              DATE,
    DATA_ORIG                   CHAR(2),
    LAST_UPDT_BY                VARCHAR2(255),
    LAST_UPDT_DATE              DATE
)
/

create index IX_CME_EVAL_CME_FAC_SUBM_ID
    on RCRA_CME_EVAL (CME_FAC_SUBM_ID)
/

create table RCRA_CME_EVAL_COMMIT
(
    CME_EVAL_COMMIT_ID VARCHAR2(40) not null
        constraint PK_CME_EVAL_COMMIT
            primary key,
    CME_EVAL_ID        VARCHAR2(40) not null
        constraint FK_CME_EVAL_COMMIT_CME_EVAL
            references RCRA_CME_EVAL
                on delete cascade,
    TRANS_CODE         CHAR,
    COMMIT_LEAD        CHAR(2)      not null,
    COMMIT_SEQ_NUM     NUMBER(10)   not null
)
/

create index IX_CME_EVAL_COMMIT_CME_EVAL_ID
    on RCRA_CME_EVAL_COMMIT (CME_EVAL_ID)
/

create table RCRA_CME_EVAL_VIOL
(
    CME_EVAL_VIOL_ID    VARCHAR2(40) not null
        constraint PK_CME_EVAL_VIOL
            primary key,
    CME_EVAL_ID         VARCHAR2(40) not null
        constraint FK_CME_EVAL_VIOL_CME_EVAL
            references RCRA_CME_EVAL
                on delete cascade,
    TRANS_CODE          CHAR,
    VIOL_ACT_LOC        CHAR(2)      not null,
    VIOL_SEQ_NUM        NUMBER(10)   not null,
    AGN_WHICH_DTRM_VIOL CHAR         not null
)
/

create index IX_CME_EVAL_VIOL_CME_EVAL_ID
    on RCRA_CME_EVAL_VIOL (CME_EVAL_ID)
/

create index IX_CME_FAC_SUBM_CME_SUBM_ID
    on RCRA_CME_FAC_SUBM (CME_SUBM_ID)
/

create table RCRA_CME_MEDIA
(
    CME_MEDIA_ID          VARCHAR2(40) not null
        constraint PK_CME_MEDIA
            primary key,
    CME_ENFRC_ACT_ID      VARCHAR2(40) not null
        constraint FK_CME_MEDIA_CME_ENFRC_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE            CHAR,
    MULTIMEDIA_CODE_OWNER CHAR(2)      not null,
    MULTIMEDIA_CODE       VARCHAR2(3)  not null,
    NOTES                 VARCHAR2(4000)
)
/

create index IX_CME_MEDIA_CME_ENFRC_ACT_ID
    on RCRA_CME_MEDIA (CME_ENFRC_ACT_ID)
/

create table RCRA_CME_MILESTONE
(
    CME_MILESTONE_ID         VARCHAR2(40) not null
        constraint PK_CME_MILESTONE
            primary key,
    CME_ENFRC_ACT_ID         VARCHAR2(40) not null
        constraint FK_CME_MILESTONE_CME_ENFRC_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE               CHAR,
    MILESTONE_SEQ_NUM        NUMBER(10)   not null,
    TECH_RQMT_IDEN           VARCHAR2(50),
    TECH_RQMT_DESC           VARCHAR2(200),
    MILESTONE_SCHD_COMP_DATE DATE,
    MILESTONE_ACTL_COMP_DATE DATE,
    MILESTONE_DFLT_DATE      DATE,
    NOTES                    VARCHAR2(4000)
)
/

create index IX_CME_MLSTNE_CME_ENFRC_ACT_ID
    on RCRA_CME_MILESTONE (CME_ENFRC_ACT_ID)
/

create table RCRA_CME_PNLTY
(
    CME_PNLTY_ID                   VARCHAR2(40) not null
        constraint PK_CME_PNLTY
            primary key,
    CME_ENFRC_ACT_ID               VARCHAR2(40) not null
        constraint FK_CME_PNLTY_CME_ENFRC_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE                     CHAR,
    PNLTY_TYPE_OWNER               CHAR(2)      not null,
    PNLTY_TYPE                     VARCHAR2(3)  not null,
    CASH_CIVIL_PNLTY_SOUGHT_AMOUNT NUMBER(13, 2),
    NOTES                          VARCHAR2(4000)
)
/

create index IX_CME_PNLTY_CME_ENFRC_ACT_ID
    on RCRA_CME_PNLTY (CME_ENFRC_ACT_ID)
/

create table RCRA_CME_PYMT
(
    CME_PYMT_ID      VARCHAR2(40) not null
        constraint PK_CME_PYMT
            primary key,
    CME_PNLTY_ID     VARCHAR2(40) not null
        constraint FK_CME_PYMT_CME_PNLTY
            references RCRA_CME_PNLTY
                on delete cascade,
    TRANS_CODE       CHAR,
    PYMT_SEQ_NUM     NUMBER(10)   not null,
    PYMT_DFLT_DATE   DATE,
    SCHD_PYMT_DATE   DATE,
    SCHD_PYMT_AMOUNT NUMBER(13, 2),
    ACTL_PYMT_DATE   DATE,
    ACTL_PAID_AMOUNT NUMBER(13, 2),
    NOTES            VARCHAR2(4000)
)
/

create index IX_CME_PYMT_CME_PNLTY_ID
    on RCRA_CME_PYMT (CME_PNLTY_ID)
/

create table RCRA_CME_RQST
(
    CME_RQST_ID    VARCHAR2(40) not null
        constraint PK_CME_RQST
            primary key,
    CME_EVAL_ID    VARCHAR2(40) not null
        constraint FK_CME_RQST_CME_EVAL
            references RCRA_CME_EVAL
                on delete cascade,
    TRANS_CODE     CHAR,
    RQST_SEQ_NUM   NUMBER(10)   not null,
    DATE_OF_RQST   DATE,
    DATE_RESP_RCVD DATE,
    RQST_AGN       CHAR,
    NOTES          VARCHAR2(4000)
)
/

create index IX_CME_RQST_CME_EVAL_ID
    on RCRA_CME_RQST (CME_EVAL_ID)
/

create table RCRA_CME_SUPP_ENVR_PRJT
(
    CME_SUPP_ENVR_PRJT_ID VARCHAR2(40) not null
        constraint PK_CME_SUPP_ENVR_PRJT
            primary key,
    CME_ENFRC_ACT_ID      VARCHAR2(40) not null
        constraint FK_CME_SPP_ENV_PRJ_CME_ENF_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE            CHAR,
    SEP_SEQ_NUM           NUMBER(10)   not null,
    SEP_EXPND_AMOUNT      NUMBER(13, 2),
    SEP_SCHD_COMP_DATE    DATE,
    SEP_ACTL_DATE         DATE,
    SEP_DFLT_DATE         DATE,
    SEP_CODE_OWNER        CHAR(2),
    SEP_DESC_TXT          VARCHAR2(3),
    NOTES                 VARCHAR2(4000)
)
/

create index IX_CME_SPP_ENV_PRJ_CM_EN_AC_ID
    on RCRA_CME_SUPP_ENVR_PRJT (CME_ENFRC_ACT_ID)
/

create table RCRA_CME_VIOL
(
    CME_VIOL_ID          VARCHAR2(40) not null
        constraint PK_CME_VIOL
            primary key,
    CME_FAC_SUBM_ID      VARCHAR2(40) not null
        constraint FK_CME_VIOL_CME_FAC_SUBM
            references RCRA_CME_FAC_SUBM
                on delete cascade,
    TRANS_CODE           CHAR,
    VIOL_ACT_LOC         CHAR(2)      not null,
    VIOL_SEQ_NUM         NUMBER(10)   not null,
    AGN_WHICH_DTRM_VIOL  CHAR         not null,
    VIOL_TYPE_OWNER      CHAR(2),
    VIOL_TYPE            VARCHAR2(10),
    FORMER_CITATION_NAME VARCHAR2(35),
    VIOL_DTRM_DATE       DATE,
    RTN_COMPL_ACTL_DATE  DATE,
    RTN_TO_COMPL_QUAL    CHAR,
    VIOL_RESP_AGN        CHAR,
    NOTES                VARCHAR2(4000),
    CREATED_BY_USERID    VARCHAR2(255),
    C_CREATED_DATE       DATE,
    LAST_UPDT_BY         VARCHAR2(255),
    LAST_UPDT_DATE       DATE
)
/

create table RCRA_CME_CITATION
(
    CME_CITATION_ID       VARCHAR2(40) not null
        constraint PK_CME_CITATION
            primary key,
    CME_VIOL_ID           VARCHAR2(40) not null
        constraint FK_CME_CITATION_CME_VIOL
            references RCRA_CME_VIOL
                on delete cascade,
    TRANS_CODE            CHAR,
    CITATION_NAME_SEQ_NUM NUMBER(10)   not null,
    CITATION_NAME         VARCHAR2(80),
    CITATION_NAME_OWNER   CHAR(2),
    CITATION_NAME_TYPE    CHAR(2),
    NOTES                 VARCHAR2(4000)
)
/

create index IX_CME_CITATION_CME_VIOL_ID
    on RCRA_CME_CITATION (CME_VIOL_ID)
/

create index IX_CME_VIOL_CME_FAC_SUBM_ID
    on RCRA_CME_VIOL (CME_FAC_SUBM_ID)
/

create table RCRA_CME_VIOL_ENFRC
(
    CME_VIOL_ENFRC_ID   VARCHAR2(40) not null
        constraint PK_CME_VIOL_ENFRC
            primary key,
    CME_ENFRC_ACT_ID    VARCHAR2(40) not null
        constraint FK_CME_VL_ENFRC_CME_ENFRC_ACT
            references RCRA_CME_ENFRC_ACT
                on delete cascade,
    TRANS_CODE          CHAR,
    VIOL_SEQ_NUM        NUMBER(10)   not null,
    AGN_WHICH_DTRM_VIOL CHAR         not null,
    RTN_COMPL_SCHD_DATE DATE
)
/

create index IX_CME_VL_ENFR_CME_ENFR_ACT_ID
    on RCRA_CME_VIOL_ENFRC (CME_ENFRC_ACT_ID)
/

create table RCRA_EM_SUBM
(
    EM_SUBM_ID VARCHAR2(40) not null
        constraint PK_EM_SUBM
            primary key
)
/

create table RCRA_EM_EMANIFEST
(
    EM_EMANIFEST_ID              VARCHAR2(40) not null
        constraint PK_EM_EMANIFEST
            primary key,
    EM_SUBM_ID                   VARCHAR2(40) not null
        constraint FK_EM_EMANIFEST_EM_SUBM
            references RCRA_EM_SUBM
                on delete cascade,
    CREATED_DATE                 DATE,
    UPDATED_DATE                 DATE,
    MAN_TRACKING_NUM             VARCHAR2(12),
    STATUS                       VARCHAR2(17),
    PUBLIC_IND                   CHAR,
    SUBM_TYPE                    VARCHAR2(14),
    SIGN_STATUS_IND              CHAR,
    ORIGIN_TYPE                  VARCHAR2(7),
    SHIPPED_DATE                 DATE,
    RECEIVED_DATE                DATE,
    CERT_DATE                    DATE,
    REJ_IND                      CHAR,
    DISCREPANCY_IND              CHAR,
    RESIDUE_IND                  CHAR,
    IMP_IND                      CHAR,
    CONT_PREV_REJ_RES_IND        CHAR,
    CERT_BY_FIRST_NAME           VARCHAR2(38),
    CERT_BY_LAST_NAME            VARCHAR2(38),
    CERT_BY_USER_ID              VARCHAR2(255),
    REJ_TRANS_ON_SITE_IND        CHAR,
    REJ_TYPE                     VARCHAR2(13),
    REJ_ALT_DES_FAC_TYPE         VARCHAR2(9),
    REJ_COMMENTS                 VARCHAR2(255),
    REJ_GEN_PS_NAME              VARCHAR2(80),
    REJ_GEN_PS_DATE              DATE,
    REJ_GEN_ES_SIGN_DATE         DATE,
    REJ_GEN_ES_CROMERR_ACT_ID    VARCHAR2(50),
    REJ_GEN_ES_CROMERR_DOC_ID    VARCHAR2(50),
    REJ_GEN_ES_SIGNER_FIRST_NAME VARCHAR2(38),
    REJ_GEN_ES_SIGNER_LAST_NAME  VARCHAR2(38),
    REJ_GEN_ES_SIGNER_USER_ID    VARCHAR2(255),
    REJ_GEN_ES_DOC_NAME          VARCHAR2(255),
    REJ_GEN_ES_DOC_SIZE          NUMBER(10),
    REJ_GEN_ES_DOC_MIME_TYPE     VARCHAR2(50),
    IMP_GEN_NAME                 VARCHAR2(80),
    IMP_GEN_ADDRESS              VARCHAR2(50),
    IMP_GEN_CITY                 VARCHAR2(100),
    IMP_GEN_POSTAL_CODE          VARCHAR2(25),
    IMP_GEN_PROVINCE             VARCHAR2(50),
    IMP_GEN_CNTRY_CODE           CHAR(2),
    IMP_GEN_CNTRY_NAME           VARCHAR2(100),
    IMP_PORT_CITY                VARCHAR2(100),
    IMP_PORT_STATE_CODE          CHAR(2),
    IMP_PORT_STATE_NAME          VARCHAR2(100),
    PRINTED_DOC_NAME             VARCHAR2(255),
    PRINTED_DOC_SIZE             NUMBER(10),
    PRINTED_DOC_MIME_TYPE        VARCHAR2(50),
    FORM_DOC_NAME                VARCHAR2(255),
    FORM_DOC_SIZE                NUMBER(10),
    FORM_DOC_MIME_TYPE           VARCHAR2(50),
    ADD_INFO_NEW_MAN_DEST        VARCHAR2(255),
    ADD_INFO_CONSENT_NUM         VARCHAR2(255),
    ADD_INFO_HAND_INSTR          VARCHAR2(4000),
    CORR_VERSION_NUM             NUMBER(10),
    CORR_ACTIVE_IND              CHAR,
    CORR_EPA_SITE_ID             VARCHAR2(15),
    CORR_ES_SIGN_DATE            DATE,
    CORR_ES_CROMERR_ACT_ID       VARCHAR2(50),
    CORR_ES_CROMERR_DOC_ID       VARCHAR2(50),
    CORR_ES_SIGNER_FIRST_NAME    VARCHAR2(38),
    CORR_ES_SIGNER_LAST_NAME     VARCHAR2(38),
    CORR_ES_SIGNER_USER_ID       VARCHAR2(255),
    CORR_ES_DOC_NAME             VARCHAR2(255),
    CORR_ES_DOC_SIZE             NUMBER(10),
    CORR_ES_DOC_MIME_TYPE        VARCHAR2(50)
)
/

create index IX_EM_EMANIFEST_EM_SUBM_ID
    on RCRA_EM_EMANIFEST (EM_SUBM_ID)
/

create index IX_EM_EMANIFEST_MAN_TR_NUM_VER
    on RCRA_EM_EMANIFEST (MAN_TRACKING_NUM, CORR_VERSION_NUM)
/

create table RCRA_EM_EMANIFEST_COMMENT
(
    EM_EMANIFEST_COMMENT_ID VARCHAR2(40) not null
        constraint PK_EM_EMANIFEST_COMMENT
            primary key,
    EM_EMANIFEST_ID         VARCHAR2(40) not null
        constraint FK_EM_EMNIFST_CMMNT_EM_EMNIFST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    COMMENT_DESC            VARCHAR2(4000),
    HANDLER_ID              VARCHAR2(15),
    COMMENT_LABEL           VARCHAR2(255)
)
/

create index IX_EM_EMNFST_CMMNT_EM_EMNFS_ID
    on RCRA_EM_EMANIFEST_COMMENT (EM_EMANIFEST_ID)
/

create table RCRA_EM_HANDLER
(
    EM_HANDLER_ID          VARCHAR2(40) not null
        constraint PK_EM_HANDLER
            primary key,
    EM_EMANIFEST_ID        VARCHAR2(40) not null
        constraint FK_EM_HANDLER_EM_EMANIFEST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    SITE_TYPE              VARCHAR2(11),
    EPA_SITE_ID            VARCHAR2(15),
    MANIFEST_NAME          VARCHAR2(80),
    ORDER_NUM              NUMBER(10),
    REG_IND                CHAR,
    MOD_IND                CHAR,
    MANIFEST_HANDLER_TYPE  VARCHAR2(40) not null,
    MAIL_STREET_NUM        VARCHAR2(12),
    MAIL_STREET1           VARCHAR2(50),
    MAIL_STREET2           VARCHAR2(50),
    MAIL_CITY              VARCHAR2(25),
    MAIL_ZIP               VARCHAR2(14),
    MAIL_CNTRY_CODE        CHAR(2),
    MAIL_CNTRY_NAME        VARCHAR2(100),
    MAIL_STATE_CODE        CHAR(2),
    MAIL_STATE_NAME        VARCHAR2(100),
    SITE_STREET_NUM        VARCHAR2(12),
    SITE_STREET1           VARCHAR2(50),
    SITE_STREET2           VARCHAR2(50),
    SITE_CITY              VARCHAR2(25),
    SITE_ZIP               VARCHAR2(14),
    SITE_CNTRY_CODE        CHAR(2),
    SITE_CNTRY_NAME        VARCHAR2(100),
    SITE_STATE_CODE        CHAR(2),
    SITE_STATE_NAME        VARCHAR2(100),
    CONTACT_FIRST_NAME     VARCHAR2(38),
    CONTACT_MIDDLE_INITIAL CHAR,
    CONTACT_LAST_NAME      VARCHAR2(38),
    CONTACT_EMAIL          VARCHAR2(80),
    CONTACT_COMPANY_NAME   VARCHAR2(80),
    CONTACT_PHONE_NUM      VARCHAR2(15),
    CONTACT_PHONE_EXT      VARCHAR2(6),
    EMERG_PHONE_NUM        VARCHAR2(15),
    EMERG_PHONE_EXT        VARCHAR2(6),
    PS_NAME                VARCHAR2(80),
    PS_DATE                DATE,
    ES_SIGN_DATE           DATE,
    ES_CROMERR_ACT_ID      VARCHAR2(50),
    ES_CROMERR_DOC_ID      VARCHAR2(50),
    ES_SIGNER_FIRST_NAME   VARCHAR2(38),
    ES_SIGNER_LAST_NAME    VARCHAR2(38),
    ES_SIGNER_USER_ID      VARCHAR2(255),
    ES_DOC_NAME            VARCHAR2(255),
    ES_DOC_SIZE            NUMBER(10),
    ES_DOC_MIME_TYPE       VARCHAR2(50)
)
/

create index IX_EM_HANDLER_EM_EMANIFEST_ID
    on RCRA_EM_HANDLER (EM_EMANIFEST_ID)
/

create table RCRA_EM_TR_NUM_ORIG
(
    EM_TR_NUM_ORIG_ID     VARCHAR2(40) default sys_guid() not null
        constraint PK_EM_TR_NUM_ORIG
            primary key,
    EM_EMANIFEST_ID       VARCHAR2(40)                    not null
        constraint FK_EM_TR_NUM_ORIG_EM_EMANIFEST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    MANIFEST_TRACKING_NUM VARCHAR2(12)                    not null
)
/

create index IX_EM_TR_NM_ORG_EM_EMNIFEST_ID
    on RCRA_EM_TR_NUM_ORIG (EM_EMANIFEST_ID)
/

create table RCRA_EM_TR_NUM_REJ
(
    EM_TR_NUM_REJ_ID      VARCHAR2(40) default sys_guid() not null
        constraint PK_EM_TR_NUM_REJ
            primary key,
    EM_EMANIFEST_ID       VARCHAR2(40)                    not null
        constraint FK_EM_TR_NUM_REJ_EM_EMANIFEST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    MANIFEST_TRACKING_NUM VARCHAR2(12)                    not null
)
/

create index IX_EM_TR_NUM_RJ_EM_EMNIFEST_ID
    on RCRA_EM_TR_NUM_REJ (EM_EMANIFEST_ID)
/

create table RCRA_EM_TR_NUM_RESIDUE_NEW
(
    EM_TR_NUM_RESIDUE_NEW_ID VARCHAR2(40) default sys_guid() not null
        constraint PK_EM_TR_NUM_RESIDUE_NEW
            primary key,
    EM_EMANIFEST_ID          VARCHAR2(40)                    not null
        constraint FK_EM_TR_NM_RSDUE_NW_EM_EMNFST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    MANIFEST_TRACKING_NUM    VARCHAR2(12)                    not null
)
/

create index IX_EM_TR_NM_RSDE_NW_EM_EMNF_ID
    on RCRA_EM_TR_NUM_RESIDUE_NEW (EM_EMANIFEST_ID)
/

create table RCRA_EM_WASTE
(
    EM_WASTE_ID           VARCHAR2(40) not null
        constraint PK_EM_WASTE
            primary key,
    EM_EMANIFEST_ID       VARCHAR2(40) not null
        constraint FK_EM_WASTE_EM_EMANIFEST
            references RCRA_EM_EMANIFEST
                on delete cascade,
    DOT_HAZ_IND           CHAR,
    WASTES_DESC           VARCHAR2(500),
    BR_IND                CHAR,
    PCB_IND               CHAR,
    LINE_NUM              NUMBER(10),
    EPA_WASTE_IND         CHAR,
    DOT_ID_NUM            VARCHAR2(255),
    DOT_PRINTED_INFO      VARCHAR2(500),
    QNT_CONT_NUM          NUMBER(10),
    QNT_VAL               NUMBER(14, 6),
    QNT_CONT_TYPE_CODE    VARCHAR2(255),
    QNT_CONT_TYPE_DESC    VARCHAR2(255),
    QNT_UOM_CODE          CHAR,
    QNT_UOM_DESC          VARCHAR2(28),
    BR_DENSITY            NUMBER(14, 6),
    BR_DENSITY_UOM_CODE   CHAR,
    BR_DENSITY_UOM_DESC   VARCHAR2(240),
    BR_FORM_CODE          VARCHAR2(4),
    BR_FORM_DESC          VARCHAR2(240),
    BR_SRC_CODE           VARCHAR2(3),
    BR_SRC_DESC           VARCHAR2(240),
    BR_WM_CODE            CHAR,
    BR_WM_DESC            VARCHAR2(240),
    DISC_WASTE_QTY_IND    CHAR,
    DISC_WASTE_TYPE_IND   CHAR,
    DISC_COMMENTS         VARCHAR2(255),
    DISC_RESIDUE_IND      CHAR,
    DISC_RESIDUE_COMMENTS VARCHAR2(255),
    MGMT_METHOD_CODE      VARCHAR2(4),
    MGMT_METHOD_DESC      VARCHAR2(240),
    ADD_INFO_NEW_MAN_DEST VARCHAR2(255),
    ADD_INFO_CONSENT_NUM  VARCHAR2(255),
    ADD_INFO_HAND_INSTR   VARCHAR2(4000)
)
/

create table RCRA_EM_TR_NUM_WASTE
(
    EM_TR_NUM_WASTE_ID    VARCHAR2(40) default sys_guid() not null
        constraint PK_EM_TR_NUM_WASTE
            primary key,
    EM_WASTE_ID           VARCHAR2(40)                    not null
        constraint FK_EM_TR_NUM_WASTE_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    MANIFEST_TRACKING_NUM VARCHAR2(12)                    not null
)
/

create index IX_EM_TR_NUM_WASTE_EM_WASTE_ID
    on RCRA_EM_TR_NUM_WASTE (EM_WASTE_ID)
/

create index IX_EM_WASTE_EM_EMANIFEST_ID
    on RCRA_EM_WASTE (EM_EMANIFEST_ID)
/

create table RCRA_EM_WASTE_CD_FED
(
    EM_WASTE_CD_FED_ID VARCHAR2(40) not null
        constraint PK_EM_WASTE_CD_FED
            primary key,
    EM_WASTE_ID        VARCHAR2(40) not null
        constraint FK_EM_WASTE_CD_FED_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    WASTE_CODE         VARCHAR2(6)  not null,
    WASTE_DESC         VARCHAR2(2000)
)
/

create index IX_EM_WASTE_CD_FED_EM_WASTE_ID
    on RCRA_EM_WASTE_CD_FED (EM_WASTE_ID)
/

create table RCRA_EM_WASTE_CD_GEN
(
    EM_WASTE_CD_GEN_ID VARCHAR2(40) not null
        constraint PK_EM_WASTE_CD_GEN
            primary key,
    EM_WASTE_ID        VARCHAR2(40) not null
        constraint FK_EM_WASTE_CD_GEN_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    WASTE_CODE         VARCHAR2(6)  not null,
    WASTE_DESC         VARCHAR2(2000)
)
/

create index IX_EM_WASTE_CD_GEN_EM_WASTE_ID
    on RCRA_EM_WASTE_CD_GEN (EM_WASTE_ID)
/

create table RCRA_EM_WASTE_CD_TRANS
(
    EM_WASTE_CD_TRANS_ID VARCHAR2(40) default sys_guid() not null
        constraint PK_EM_WASTE_CD_TRANS
            primary key,
    EM_WASTE_ID          VARCHAR2(40)                    not null
        constraint FK_EM_WASTE_CD_TRANS_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    WASTE_CODE           VARCHAR2(12)                    not null
)
/

create index IX_EM_WASTE_CD_TRNS_EM_WSTE_ID
    on RCRA_EM_WASTE_CD_TRANS (EM_WASTE_ID)
/

create table RCRA_EM_WASTE_CD_TSDF
(
    EM_WASTE_CD_TSDF_ID VARCHAR2(40) not null
        constraint PK_EM_WASTE_CD_TSDF
            primary key,
    EM_WASTE_ID         VARCHAR2(40) not null
        constraint FK_EM_WASTE_CD_TSDF_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    WASTE_CODE          VARCHAR2(6)  not null,
    WASTE_DESC          VARCHAR2(2000)
)
/

create index IX_EM_WASTE_CD_TSDF_EM_WSTE_ID
    on RCRA_EM_WASTE_CD_TSDF (EM_WASTE_ID)
/

create table RCRA_EM_WASTE_COMMENT
(
    EM_WASTE_COMMENT_ID VARCHAR2(40) not null
        constraint PK_EM_WASTE_COMMENT
            primary key,
    EM_WASTE_ID         VARCHAR2(40) not null
        constraint FK_EM_WASTE_COMMENT_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    COMMENT_DESC        VARCHAR2(4000),
    HANDLER_ID          VARCHAR2(15),
    COMMENT_LABEL       VARCHAR2(255)
)
/

create index IX_EM_WASTE_COMMENT_EM_WSTE_ID
    on RCRA_EM_WASTE_COMMENT (EM_WASTE_ID)
/

create table RCRA_EM_WASTE_PCB
(
    EM_WASTE_PCB_ID     VARCHAR2(40) not null
        constraint PK_EM_WASTE_PCB
            primary key,
    EM_WASTE_ID         VARCHAR2(40) not null
        constraint FK_EM_WASTE_PCB_EM_WASTE
            references RCRA_EM_WASTE
                on delete cascade,
    PCB_LOAD_TYPE_CODE  VARCHAR2(255),
    PCB_ARTICLE_CONT_ID VARCHAR2(255),
    PCB_REMOVAL_DATE    DATE,
    PCB_WEIGHT          NUMBER(14, 6),
    PCB_WASTE_TYPE      VARCHAR2(255),
    PCB_BULK_IDENTITY   VARCHAR2(255)
)
/

create index IX_EM_WASTE_PCB_EM_WASTE_ID
    on RCRA_EM_WASTE_PCB (EM_WASTE_ID)
/

create table RCRA_FA_SUBM
(
    FA_SUBM_ID VARCHAR2(40) not null
        constraint PK_FA_SUBM
            primary key
)
/

create table RCRA_FA_FAC_SUBM
(
    FA_FAC_SUBM_ID VARCHAR2(40) not null
        constraint PK_FA_FAC_SUBM
            primary key,
    FA_SUBM_ID     VARCHAR2(40) not null
        constraint FK_FA_FAC_SUBM_FA_SUBM
            references RCRA_FA_SUBM
                on delete cascade,
    HANDLER_ID     VARCHAR2(12) not null
)
/

create table RCRA_FA_COST_EST
(
    FA_COST_EST_ID              VARCHAR2(40) not null
        constraint PK_FA_COST_EST
            primary key,
    FA_FAC_SUBM_ID              VARCHAR2(40) not null
        constraint FK_FA_COST_EST_FA_FAC_SUBM
            references RCRA_FA_FAC_SUBM
                on delete cascade,
    TRANS_CODE                  CHAR,
    ACT_LOC_CODE                CHAR(2)      not null,
    COST_ESTIMATE_TYPE_CODE     CHAR         not null,
    COST_ESTIMATE_AGN_CODE      CHAR         not null,
    COST_ESTIMATE_SEQ_NUM       NUMBER(10)   not null,
    RESP_PERSON_DATA_OWNER_CODE CHAR(2),
    RESP_PERSON_ID              VARCHAR2(5),
    COST_ESTIMATE_AMOUNT        NUMBER(13, 2),
    COST_ESTIMATE_DATE          DATE,
    COST_ESTIMATE_RSN_CODE      CHAR,
    AREA_UNIT_NOTES_TXT         VARCHAR2(240),
    SUPP_INFO_TXT               VARCHAR2(2000),
    CREATED_BY_USERID           VARCHAR2(255),
    F_CREATED_DATE              DATE,
    DATA_ORIG                   CHAR(2),
    UPDATE_DUE_DATE             DATE,
    CURRENT_COST_ESTIMATE_IND   CHAR,
    LAST_UPDT_BY                VARCHAR2(255),
    LAST_UPDT_DATE              DATE
)
/

create index IX_FA_COST_EST_FA_FAC_SUBM_ID
    on RCRA_FA_COST_EST (FA_FAC_SUBM_ID)
/

create table RCRA_FA_COST_EST_REL_MECHANISM
(
    FA_COST_EST_REL_MECHANISM_ID VARCHAR2(40) not null
        constraint PK_FA_COST_EST_REL_MECHANISM
            primary key,
    FA_COST_EST_ID               VARCHAR2(40) not null
        constraint FK_FA_CST_EST_RL_MCH_FA_CST_ES
            references RCRA_FA_COST_EST
                on delete cascade,
    TRANS_CODE                   CHAR,
    ACT_LOC_CODE                 CHAR(2)      not null,
    MECHANISM_AGN_CODE           CHAR         not null,
    MECHANISM_SEQ_NUM            NUMBER(10)   not null,
    MECHANISM_DETAIL_SEQ_NUM     NUMBER(10)   not null
)
/

create index IX_FA_CST_ES_RL_MC_FA_CS_ES_ID
    on RCRA_FA_COST_EST_REL_MECHANISM (FA_COST_EST_ID)
/

create index IX_FA_FAC_SUBM_FA_SUBM_ID
    on RCRA_FA_FAC_SUBM (FA_SUBM_ID)
/

create table RCRA_FA_MECHANISM
(
    FA_MECHANISM_ID                VARCHAR2(40) not null
        constraint PK_FA_MECHANISM
            primary key,
    FA_FAC_SUBM_ID                 VARCHAR2(40) not null
        constraint FK_FA_MECHANISM_FA_FAC_SUBM
            references RCRA_FA_FAC_SUBM
                on delete cascade,
    TRANS_CODE                     CHAR,
    ACT_LOC_CODE                   CHAR(2)      not null,
    MECHANISM_AGN_CODE             CHAR         not null,
    MECHANISM_SEQ_NUM              NUMBER(10)   not null,
    MECHANISM_TYPE_DATA_OWNER_CODE CHAR(2),
    MECHANISM_TYPE_CODE            CHAR,
    PROVIDER_TXT                   VARCHAR2(80),
    PROVIDER_FULL_CONTACT_NAME     VARCHAR2(33),
    TELE_NUM_TXT                   VARCHAR2(15),
    SUPP_INFO_TXT                  VARCHAR2(2000),
    CREATED_BY_USERID              VARCHAR2(255),
    F_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    PROVIDER_CONTACT_EMAIL         VARCHAR2(80),
    ACTIVE_MECHANISM_IND           CHAR,
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE
)
/

create index IX_FA_MECHANISM_FA_FAC_SUBM_ID
    on RCRA_FA_MECHANISM (FA_FAC_SUBM_ID)
/

create table RCRA_FA_MECHANISM_DETAIL
(
    FA_MECHANISM_DETAIL_ID       VARCHAR2(40) not null
        constraint PK_FA_MECHANISM_DETAIL
            primary key,
    FA_MECHANISM_ID              VARCHAR2(40) not null
        constraint FK_FA_MECHNISM_DTIL_FA_MCHNISM
            references RCRA_FA_MECHANISM
                on delete cascade,
    TRANS_CODE                   CHAR,
    MECHANISM_DETAIL_SEQ_NUM     NUMBER(10)   not null,
    MECHANISM_IDEN_TXT           VARCHAR2(40),
    FACE_VAL_AMOUNT              NUMBER(13, 2),
    EFFC_DATE                    DATE,
    EXPIRATION_DATE              DATE,
    SUPP_INFO_TXT                VARCHAR2(2000),
    CURRENT_MECHANISM_DETAIL_IND CHAR,
    CREATED_BY_USERID            VARCHAR2(255),
    F_CREATED_DATE               DATE,
    DATA_ORIG                    CHAR(2),
    FAC_FACE_VAL_AMOUNT          NUMBER(14, 6),
    ALT_IND                      CHAR,
    LAST_UPDT_BY                 VARCHAR2(255),
    LAST_UPDT_DATE               DATE
)
/

create index IX_FA_MCHNISM_DTL_FA_MCHNSM_ID
    on RCRA_FA_MECHANISM_DETAIL (FA_MECHANISM_ID)
/

create table RCRA_GIS_SUBM
(
    GIS_SUBM_ID VARCHAR2(40) not null
        constraint PK_GIS_SUBM
            primary key
)
/

create table RCRA_GIS_FAC_SUBM
(
    GIS_FAC_SUBM_ID VARCHAR2(40) not null
        constraint PK_GIS_FAC_SUBM
            primary key,
    GIS_SUBM_ID     VARCHAR2(40) not null
        constraint FK_GIS_FAC_SUBM_GIS_SUBM
            references RCRA_GIS_SUBM
                on delete cascade,
    HANDLER_ID      VARCHAR2(12) not null
)
/

create index IX_GIS_FAC_SUBM_GIS_SUBM_ID
    on RCRA_GIS_FAC_SUBM (GIS_SUBM_ID)
/

create table RCRA_GIS_GEO_INFORMATION
(
    GIS_GEO_INFORMATION_ID         VARCHAR2(40) not null
        constraint PK_GIS_GEO_INFORMATION
            primary key,
    GIS_FAC_SUBM_ID                VARCHAR2(40) not null
        constraint FK_GIS__INFORMTION_GS_FC_SBM
            references RCRA_GIS_FAC_SUBM
                on delete cascade,
    TRANS_CODE                     CHAR,
    GEO_INFO_OWNER                 CHAR(2)      not null,
    GEO_INFO_SEQ_NUM               NUMBER(10)   not null,
    PERMIT_UNIT_SEQ_NUM            NUMBER(10),
    AREA_SEQ_NUM                   NUMBER(10),
    LOC_COMM_TXT                   VARCHAR2(2000),
    CREATED_BY_USERID              VARCHAR2(255),
    G_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE,
    AREA_ACREAGE_MEAS              NUMBER(13, 2),
    AREA_MEAS_SRC_DATA_OWNER_CODE  CHAR(2),
    AREA_MEAS_SRC_CODE             VARCHAR2(4),
    AREA_MEAS_DATE                 DATE,
    DATA_COLL_DATE                 DATE         not null,
    HORZ_ACC_MEAS                  NUMBER(10),
    SRC_MAP_SCALE_NUM              NUMBER(10),
    COORD_DATA_SRC_DATA_OWNER_CODE CHAR(2),
    COORD_DATA_SRC_CODE            VARCHAR2(3),
    GEO_REF_PT_DATA_OWNER_CODE     CHAR(2),
    GEO_REF_PT_CODE                VARCHAR2(3),
    GEOM_TYPE_DATA_OWNER_CODE      CHAR(2),
    GEOM_TYPE_CODE                 VARCHAR2(3),
    HORZ_COLL_METH_DATA_OWNER_CODE CHAR(2),
    HORZ_COLL_METH_CODE            VARCHAR2(3),
    HRZ_CRD_RF_SYS_DTM_DTA_OWN_CDE CHAR(2),
    HORZ_COORD_REF_SYS_DATUM_CODE  VARCHAR2(3),
    VERF_METH_DATA_OWNER_CODE      CHAR(2),
    VERF_METH_CODE                 VARCHAR2(3),
    LATITUDE                       NUMBER(19, 14),
    LONGITUDE                      NUMBER(19, 14),
    ELEVATION                      NUMBER(19, 14)
)
/

create index IX_GS__INFORMTN_GS_FC_SBM_ID
    on RCRA_GIS_GEO_INFORMATION (GIS_FAC_SUBM_ID)
/

create table RCRA_HD_SUBM
(
    HD_SUBM_ID VARCHAR2(40) not null
        constraint PK_HD_SUBM
            primary key
)
/

create table RCRA_HD_HBASIC
(
    HD_HBASIC_ID        VARCHAR2(40) not null
        constraint PK_HD_HBASIC
            primary key,
    HD_SUBM_ID          VARCHAR2(40) not null
        constraint FK_HD_HBASIC_HD_SUBM
            references RCRA_HD_SUBM
                on delete cascade,
    TRANSACTION_CODE    CHAR,
    HANDLER_ID          VARCHAR2(12),
    EXTRACT_FLAG        CHAR,
    FACILITY_IDENTIFIER VARCHAR2(12)
)
/

create table RCRA_HD_HANDLER
(
    HD_HANDLER_ID                  VARCHAR2(40) not null
        constraint PK_HD_HANDLER
            primary key,
    HD_HBASIC_ID                   VARCHAR2(40) not null
        constraint FK_HD_HANDLER_HD_HBASIC
            references RCRA_HD_HBASIC
                on delete cascade,
    TRANSACTION_CODE               CHAR,
    ACTIVITY_LOCATION              CHAR(2)      not null,
    SOURCE_TYPE                    CHAR         not null,
    SEQ_NUMBER                     NUMBER(10)   not null,
    RECEIVE_DATE                   VARCHAR2(10),
    HANDLER_NAME                   VARCHAR2(80),
    ACKNOWLEDGE_DATE               VARCHAR2(10),
    NON_NOTIFIER                   CHAR,
    NON_NOTIFIER_TEXT              VARCHAR2(255),
    TSD_DATE                       VARCHAR2(10),
    NATURE_OF_BUSINESS_TEXT        VARCHAR2(4000),
    OFF_SITE_RECEIPT               CHAR,
    ACCESSIBILITY                  CHAR,
    ACCESSIBILITY_TEXT             VARCHAR2(255),
    COUNTY_CODE_OWNER              CHAR(2),
    COUNTY_CODE                    VARCHAR2(5),
    NOTES                          VARCHAR2(4000),
    INTRNL_NOTES                   VARCHAR2(4000),
    SHORT_TERM_INTRNL_NOTES        VARCHAR2(4000),
    ACKNOWLEDGE_FLAG_IND           CHAR,
    INCLUDE_IN_NATIONAL_REPORT_IND CHAR,
    LQHUW_IND                      CHAR,
    HD_REPORT_CYCLE_YEAR           NUMBER(10),
    HEALTHCARE_FAC                 CHAR,
    REVERSE_DISTRIBUTOR            CHAR,
    SUBPART_P_WITHDRAWAL           CHAR,
    CURRENT_RECORD                 CHAR,
    CREATED_BY_USERID              VARCHAR2(255),
    H_CREATED_DATE                 DATE,
    DATA_ORIG                      CHAR(2),
    LOCATION_LATITUDE              NUMBER(19, 14),
    LOCATION_LONGITUDE             NUMBER(19, 14),
    LOCATION_GIS_PRIM              CHAR,
    LOCATION_GIS_ORIG              CHAR(2),
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE,
    BR_EXEMPT_IND                  CHAR,
    ACKNOWLEDGE_FLAG               CHAR,
    LOCATION_STREET_NUMBER         VARCHAR2(12),
    LOCATION_STREET1               VARCHAR2(50),
    LOCATION_STREET2               VARCHAR2(50),
    LOCATION_CITY                  VARCHAR2(25),
    LOCATION_STATE                 CHAR(2),
    LOCATION_COUNTRY               CHAR(2),
    LOCATION_ZIP                   VARCHAR2(14),
    MAIL_STREET_NUMBER             VARCHAR2(12),
    MAIL_STREET1                   VARCHAR2(50),
    MAIL_STREET2                   VARCHAR2(50),
    MAIL_CITY                      VARCHAR2(25),
    MAIL_STATE                     CHAR(2),
    MAIL_COUNTRY                   CHAR(2),
    MAIL_ZIP                       VARCHAR2(14),
    CONTACT_FIRST_NAME             VARCHAR2(38),
    CONTACT_MIDDLE_INITIAL         CHAR,
    CONTACT_LAST_NAME              VARCHAR2(38),
    CONTACT_ORG_NAME               VARCHAR2(80),
    CONTACT_TITLE                  VARCHAR2(80),
    CONTACT_EMAIL_ADDRESS          VARCHAR2(80),
    CONTACT_PHONE                  VARCHAR2(15),
    CONTACT_PHONE_EXT              VARCHAR2(6),
    CONTACT_FAX                    VARCHAR2(15),
    CONTACT_STREET_NUMBER          VARCHAR2(12),
    CONTACT_STREET1                VARCHAR2(50),
    CONTACT_STREET2                VARCHAR2(50),
    CONTACT_CITY                   VARCHAR2(25),
    CONTACT_STATE                  CHAR(2),
    CONTACT_COUNTRY                CHAR(2),
    CONTACT_ZIP                    VARCHAR2(14),
    PCONTACT_FIRST_NAME            VARCHAR2(38),
    PCONTACT_MIDDLE_NAME           CHAR,
    PCONTACT_LAST_NAME             VARCHAR2(38),
    PCONTACT_ORG_NAME              VARCHAR2(80),
    PCONTACT_TITLE                 VARCHAR2(80),
    PCONTACT_EMAIL_ADDRESS         VARCHAR2(80),
    PCONTACT_PHONE                 VARCHAR2(15),
    PCONTACT_PHONE_EXT             VARCHAR2(6),
    PCONTACT_FAX                   VARCHAR2(15),
    PCONTACT_STREET_NUMBER         VARCHAR2(12),
    PCONTACT_STREET1               VARCHAR2(50),
    PCONTACT_STREET2               VARCHAR2(50),
    PCONTACT_CITY                  VARCHAR2(25),
    PCONTACT_STATE                 CHAR(2),
    PCONTACT_COUNTRY               CHAR(2),
    PCONTACT_ZIP                   VARCHAR2(14),
    USED_OIL_BURNER                CHAR,
    USED_OIL_PROCESSOR             CHAR,
    USED_OIL_REFINER               CHAR,
    USED_OIL_MARKET_BURNER         CHAR,
    USED_OIL_SPEC_MARKETER         CHAR,
    USED_OIL_TRANSFER_FACILITY     CHAR,
    USED_OIL_TRANSPORTER           CHAR,
    LAND_TYPE                      CHAR,
    STATE_DISTRICT_OWNER           CHAR(2),
    STATE_DISTRICT                 VARCHAR2(10),
    STATE_DISTRICT_TEXT            VARCHAR2(255),
    IMPORTER_ACTIVITY              CHAR,
    MIXED_WASTE_GENERATOR          CHAR,
    RECYCLER_ACTIVITY              CHAR,
    TRANSPORTER_ACTIVITY           CHAR,
    TSD_ACTIVITY                   CHAR,
    UNDERGROUND_INJECTION_ACTIVITY CHAR,
    UNIVERSAL_WASTE_DEST_FACILITY  CHAR,
    ONSITE_BURNER_EXEMPTION        CHAR,
    FURNACE_EXEMPTION              CHAR,
    SHORT_TERM_GEN_IND             CHAR,
    TRANSFER_FACILITY_IND          CHAR,
    RECOGNIZED_TRADER_IMPORTER_IND CHAR,
    RECOGNIZED_TRADER_EXPORTER_IND CHAR,
    SLAB_IMPORTER_IND              CHAR,
    SLAB_EXPORTER_IND              CHAR,
    RECYCLER_ACT_NONSTORAGE        CHAR,
    MANIFEST_BROKER                CHAR,
    STATE_WASTE_GENERATOR_OWNER    CHAR(2),
    STATE_WASTE_GENERATOR          CHAR,
    FED_WASTE_GENERATOR_OWNER      CHAR(2),
    FED_WASTE_GENERATOR            CHAR,
    COLLEGE_IND                    CHAR,
    HOSPITAL_IND                   CHAR,
    NON_PROFIT_IND                 CHAR,
    WITHDRAWAL_IND                 CHAR,
    TRANS_CODE                     CHAR,
    NOTIFICATION_RSN_CODE          CHAR,
    EFFC_DATE                      DATE,
    FINANCIAL_ASSURANCE_IND        CHAR,
    RECYCLER_IND                   CHAR,
    RECYCLER_NOTES                 VARCHAR2(4000),
    RECYCLING_IND                  CHAR
)
/

create table RCRA_HD_CERTIFICATION
(
    HD_CERTIFICATION_ID VARCHAR2(40) not null
        constraint PK_HD_CERTIFICATION
            primary key,
    HD_HANDLER_ID       VARCHAR2(40) not null
        constraint FK_HD_CERTIFICATION_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE    CHAR,
    CERT_SEQ            NUMBER(10)   not null,
    CERT_SIGNED_DATE    VARCHAR2(10),
    CERT_TITLE          VARCHAR2(45),
    CERT_FIRST_NAME     VARCHAR2(38),
    CERT_MIDDLE_INITIAL CHAR,
    CERT_LAST_NAME      VARCHAR2(38),
    CERT_EMAIL_TEXT     VARCHAR2(80)
)
/

create index IX_HD_CERTIFICATIO_HD_HANDL_ID
    on RCRA_HD_CERTIFICATION (HD_HANDLER_ID)
/

create table RCRA_HD_ENV_PERMIT
(
    HD_ENV_PERMIT_ID  VARCHAR2(40) not null
        constraint PK_HD_ENV_PERMIT
            primary key,
    HD_HANDLER_ID     VARCHAR2(40) not null
        constraint FK_HD_ENV_PERMIT_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE  CHAR,
    ENV_PERMIT_NUMBER VARCHAR2(13) not null,
    ENV_PERMIT_OWNER  CHAR(2),
    ENV_PERMIT_TYPE   CHAR,
    ENV_PERMIT_DESC   VARCHAR2(80) not null
)
/

create index IX_HD_ENV_PERMIT_HD_HANDLER_ID
    on RCRA_HD_ENV_PERMIT (HD_HANDLER_ID)
/

create table RCRA_HD_EPISODIC_EVENT
(
    HD_EPISODIC_EVENT_ID   VARCHAR2(40) not null
        constraint PK_HD_EPISODIC_EVENT
            primary key,
    HD_HANDLER_ID          VARCHAR2(40) not null
        constraint FK_HD_EPISODIC_EVENT_HD_HANDLE
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE       CHAR,
    EVENT_OWNER            CHAR(2),
    EVENT_TYPE             CHAR,
    START_DATE             DATE,
    END_DATE               DATE,
    CONTACT_FIRST_NAME     VARCHAR2(38),
    CONTACT_MIDDLE_INITIAL CHAR,
    CONTACT_LAST_NAME      VARCHAR2(38),
    CONTACT_ORG_NAME       VARCHAR2(80),
    CONTACT_TITLE          VARCHAR2(80),
    CONTACT_EMAIL_ADDRESS  VARCHAR2(80),
    CONTACT_PHONE          VARCHAR2(15),
    CONTACT_PHONE_EXT      VARCHAR2(6),
    CONTACT_FAX            VARCHAR2(15)
)
/

create index IX_HD_EPISOD_EVENT_HD_HANDL_ID
    on RCRA_HD_EPISODIC_EVENT (HD_HANDLER_ID)
/

create table RCRA_HD_EPISODIC_PRJT
(
    HD_EPISODIC_PRJT_ID  VARCHAR2(40) not null
        constraint PK_HD_EPISODIC_PRJT
            primary key,
    HD_EPISODIC_EVENT_ID VARCHAR2(40) not null
        constraint FK_HD_EPISO_PRJT_HD_EPISO_EVEN
            references RCRA_HD_EPISODIC_EVENT
                on delete cascade,
    TRANSACTION_CODE     CHAR,
    PRJT_CODE_OWNER      CHAR(2)      not null,
    PRJT_CODE            CHAR(3)      not null,
    OTHER_PRJT_DESC      VARCHAR2(255)
)
/

create index IX_HD_EPIS_PRJT_HD_EPIS_EVE_ID
    on RCRA_HD_EPISODIC_PRJT (HD_EPISODIC_EVENT_ID)
/

create table RCRA_HD_EPISODIC_WASTE
(
    HD_EPISODIC_WASTE_ID VARCHAR2(40) not null
        constraint PK_HD_EPISODIC_WASTE
            primary key,
    HD_EPISODIC_EVENT_ID VARCHAR2(40) not null
        constraint FK_HD_EPISO_WASTE_HD_EPIS_EVEN
            references RCRA_HD_EPISODIC_EVENT
                on delete cascade,
    TRANSACTION_CODE     CHAR,
    SEQ_NUMBER           NUMBER(10)   not null,
    WASTE_DESC           VARCHAR2(4000),
    EST_QNTY             NUMBER(10)
)
/

create index IX_HD_EPIS_WAST_HD_EPIS_EVE_ID
    on RCRA_HD_EPISODIC_WASTE (HD_EPISODIC_EVENT_ID)
/

create table RCRA_HD_EPISODIC_WASTE_CODE
(
    HD_EPISODIC_WASTE_CODE_ID VARCHAR2(40) not null
        constraint PK_HD_EPISODIC_WASTE_CODE
            primary key,
    HD_EPISODIC_WASTE_ID      VARCHAR2(40) not null
        constraint FK_HD_EPIS_WAST_COD_HD_EPI_WAS
            references RCRA_HD_EPISODIC_WASTE
                on delete cascade,
    TRANSACTION_CODE          CHAR,
    WASTE_CODE_OWNER          CHAR(2),
    WASTE_CODE                VARCHAR2(6),
    WASTE_CODE_TEXT           VARCHAR2(80)
)
/

create index IX_HD_EPI_WAS_COD_HD_EPI_WA_ID
    on RCRA_HD_EPISODIC_WASTE_CODE (HD_EPISODIC_WASTE_ID)
/

create index IX_HD_HANDLER_HD_HBASIC_ID
    on RCRA_HD_HANDLER (HD_HBASIC_ID)
/

create index IX_HD_HBASIC_HD_SUBM_ID
    on RCRA_HD_HBASIC (HD_SUBM_ID)
/

create table RCRA_HD_LQG_CLOSURE
(
    HD_LQG_CLOSURE_ID     VARCHAR2(40) not null
        constraint PK_HD_LQG_CLOSURE
            primary key,
    HD_HANDLER_ID         VARCHAR2(40) not null
        constraint FK_HD_LQG_CLOSURE_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE      CHAR,
    CLOSURE_TYPE          CHAR,
    EXPECTED_CLOSURE_DATE DATE,
    NEW_CLOSURE_DATE      DATE,
    DATE_CLOSED           DATE,
    IN_COMPLIANCE_IND     CHAR
)
/

create index IX_HD_LQG_CLOSURE_HD_HANDLE_ID
    on RCRA_HD_LQG_CLOSURE (HD_HANDLER_ID)
/

create table RCRA_HD_LQG_CONSOLIDATION
(
    HD_LQG_CONSOLIDATION_ID VARCHAR2(40) not null
        constraint PK_HD_LQG_CONSOLIDATION
            primary key,
    HD_HANDLER_ID           VARCHAR2(40) not null
        constraint FK_HD_LQG_CONSOLIDATI_HD_HANDL
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE        CHAR,
    SEQ_NUMBER              NUMBER(10)   not null,
    HANDLER_ID              VARCHAR2(12),
    HANDLER_NAME            VARCHAR2(80),
    MAIL_STREET_NUMBER      VARCHAR2(12),
    MAIL_STREET1            VARCHAR2(50),
    MAIL_STREET2            VARCHAR2(50),
    MAIL_CITY               VARCHAR2(25),
    MAIL_STATE              CHAR(2),
    MAIL_COUNTRY            CHAR(2),
    MAIL_ZIP                VARCHAR2(14),
    CONTACT_FIRST_NAME      VARCHAR2(38),
    CONTACT_MIDDLE_INITIAL  CHAR,
    CONTACT_LAST_NAME       VARCHAR2(38),
    CONTACT_ORG_NAME        VARCHAR2(80),
    CONTACT_TITLE           VARCHAR2(80),
    CONTACT_EMAIL_ADDRESS   VARCHAR2(80),
    CONTACT_PHONE           VARCHAR2(15),
    CONTACT_PHONE_EXT       VARCHAR2(6),
    CONTACT_FAX             VARCHAR2(15)
)
/

create index IX_HD_LQG_CONSOLID_HD_HANDL_ID
    on RCRA_HD_LQG_CONSOLIDATION (HD_HANDLER_ID)
/

create table RCRA_HD_NAICS
(
    HD_NAICS_ID      VARCHAR2(40) not null
        constraint PK_HD_NAICS
            primary key,
    HD_HANDLER_ID    VARCHAR2(40) not null
        constraint FK_HD_NAICS_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE CHAR,
    NAICS_SEQ        VARCHAR2(4)  not null,
    NAICS_OWNER      CHAR(2),
    NAICS_CODE       VARCHAR2(6)
)
/

create index IX_HD_NAICS_HD_HANDLER_ID
    on RCRA_HD_NAICS (HD_HANDLER_ID)
/

create table RCRA_HD_OTHER_ID
(
    HD_OTHER_ID_ID     VARCHAR2(40) not null
        constraint PK_HD_OTHER_ID
            primary key,
    HD_HBASIC_ID       VARCHAR2(40) not null
        constraint FK_HD_OTHER_ID_HD_HBASIC
            references RCRA_HD_HBASIC
                on delete cascade,
    TRANSACTION_CODE   CHAR,
    OTHER_ID           VARCHAR2(12) not null,
    RELATIONSHIP_OWNER CHAR(2),
    RELATIONSHIP_TYPE  CHAR,
    SAME_FACILITY      CHAR,
    NOTES              VARCHAR2(4000)
)
/

create index IX_HD_OTHER_ID_HD_HBASIC_ID
    on RCRA_HD_OTHER_ID (HD_HBASIC_ID)
/

create table RCRA_HD_OWNEROP
(
    HD_OWNEROP_ID       VARCHAR2(40) not null
        constraint PK_HD_OWNEROP
            primary key,
    HD_HANDLER_ID       VARCHAR2(40) not null
        constraint FK_HD_OWNEROP_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE    CHAR,
    OWNER_OP_SEQ        NUMBER(10)   not null,
    OWNER_OP_IND        CHAR(2),
    OWNER_OP_TYPE       CHAR,
    DATE_BECAME_CURRENT VARCHAR2(10),
    DATE_ENDED_CURRENT  VARCHAR2(10),
    NOTES               VARCHAR2(4000),
    FIRST_NAME          VARCHAR2(38),
    MIDDLE_INITIAL      CHAR,
    LAST_NAME           VARCHAR2(38),
    ORG_NAME            VARCHAR2(80),
    TITLE               VARCHAR2(80),
    EMAIL_ADDRESS       VARCHAR2(80),
    PHONE               VARCHAR2(15),
    PHONE_EXT           VARCHAR2(6),
    FAX                 VARCHAR2(15),
    MAIL_ADDR_NUM_TXT   VARCHAR2(12),
    STREET1             VARCHAR2(50),
    STREET2             VARCHAR2(50),
    CITY                VARCHAR2(25),
    STATE               CHAR(2),
    COUNTRY             CHAR(2),
    ZIP                 VARCHAR2(14)
)
/

create index IX_HD_OWNEROP_HD_HANDLER_ID
    on RCRA_HD_OWNEROP (HD_HANDLER_ID)
/

create table RCRA_HD_SEC_MATERIAL_ACTIVITY
(
    HD_SEC_MATERIAL_ACTIVITY_ID VARCHAR2(40) not null
        constraint PK_HD_SEC_MATERIAL_ACTIVITY
            primary key,
    HD_HANDLER_ID               VARCHAR2(40) not null
        constraint FK_HD_SEC_MATER_ACTIV_HD_HANDL
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANS_CODE                  CHAR,
    HSM_SEQ_NUM                 VARCHAR2(4)  not null,
    FAC_CODE_OWNER_NAME         CHAR(2),
    FAC_TYPE_CODE               CHAR(2),
    ESTIMATED_SHORT_TONS_QNTY   NUMBER(10),
    ACTL_SHORT_TONS_QNTY        NUMBER(10),
    LAND_BASED_UNIT_IND         CHAR(2),
    LAND_BASED_UNIT_IND_TEXT    VARCHAR2(255)
)
/

create index IX_HD_SEC_MATE_ACTI_HD_HAND_ID
    on RCRA_HD_SEC_MATERIAL_ACTIVITY (HD_HANDLER_ID)
/

create table RCRA_HD_SEC_WASTE_CODE
(
    HD_SEC_WASTE_CODE_ID        VARCHAR2(40) not null
        constraint PK_HD_SEC_WASTE_CODE
            primary key,
    HD_SEC_MATERIAL_ACTIVITY_ID VARCHAR2(40) not null
        constraint FK_HD_SEC_WAS_COD_HD_SEC_MA_AC
            references RCRA_HD_SEC_MATERIAL_ACTIVITY
                on delete cascade,
    TRANSACTION_CODE            CHAR,
    WASTE_CODE_OWNER            CHAR(2),
    WASTE_CODE_TYPE             VARCHAR2(6)
)
/

create index IX_HD_SEC_WA_CO_HD_SE_MA_AC_ID
    on RCRA_HD_SEC_WASTE_CODE (HD_SEC_MATERIAL_ACTIVITY_ID)
/

create table RCRA_HD_STATE_ACTIVITY
(
    HD_STATE_ACTIVITY_ID VARCHAR2(40) not null
        constraint PK_HD_STATE_ACTIVITY
            primary key,
    HD_HANDLER_ID        VARCHAR2(40) not null
        constraint FK_HD_STATE_ACTIVITY_HD_HANDLE
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE     CHAR,
    STATE_ACTIVITY_OWNER CHAR(2)      not null,
    STATE_ACTIVITY_TYPE  VARCHAR2(5)  not null
)
/

create index IX_HD_STATE_ACTIVI_HD_HANDL_ID
    on RCRA_HD_STATE_ACTIVITY (HD_HANDLER_ID)
/

create table RCRA_HD_UNIVERSAL_WASTE
(
    HD_UNIVERSAL_WASTE_ID VARCHAR2(40) not null
        constraint PK_HD_UNIVERSAL_WASTE
            primary key,
    HD_HANDLER_ID         VARCHAR2(40) not null
        constraint FK_HD_UNIVERSA_WASTE_HD_HANDLE
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE      CHAR,
    UNIVERSAL_WASTE_OWNER CHAR(2),
    UNIVERSAL_WASTE_TYPE  CHAR,
    ACCUMULATED           CHAR,
    GENERATED             CHAR
)
/

create index IX_HD_UNIVER_WASTE_HD_HANDL_ID
    on RCRA_HD_UNIVERSAL_WASTE (HD_HANDLER_ID)
/

create table RCRA_HD_WASTE_CODE
(
    HD_WASTE_CODE_ID VARCHAR2(40) not null
        constraint PK_HD_WASTE_CODE
            primary key,
    HD_HANDLER_ID    VARCHAR2(40) not null
        constraint FK_HD_WASTE_CODE_HD_HANDLER
            references RCRA_HD_HANDLER
                on delete cascade,
    TRANSACTION_CODE CHAR,
    WASTE_CODE_OWNER CHAR(2),
    WASTE_CODE_TYPE  VARCHAR2(6)
)
/

create index IX_HD_WASTE_CODE_HD_HANDLER_ID
    on RCRA_HD_WASTE_CODE (HD_HANDLER_ID)
/

create table RCRA_PRM_SUBM
(
    PRM_SUBM_ID VARCHAR2(40) not null
        constraint PK_PRM_SUBM
            primary key
)
/

create table RCRA_PRM_FAC_SUBM
(
    PRM_FAC_SUBM_ID VARCHAR2(40) not null
        constraint PK_PRM_FAC_SUBM
            primary key,
    PRM_SUBM_ID     VARCHAR2(40) not null
        constraint FK_PRM_FAC_SUBM_PRM_SUBM
            references RCRA_PRM_SUBM
                on delete cascade,
    HANDLER_ID      VARCHAR2(12) not null
)
/

create index IX_PRM_FAC_SUBM_PRM_SUBM_ID
    on RCRA_PRM_FAC_SUBM (PRM_SUBM_ID)
/

create table RCRA_PRM_SERIES
(
    PRM_SERIES_ID               VARCHAR2(40) not null
        constraint PK_PRM_SERIES
            primary key,
    PRM_FAC_SUBM_ID             VARCHAR2(40) not null
        constraint FK_PRM_SERIES_PRM_FAC_SUBM
            references RCRA_PRM_FAC_SUBM
                on delete cascade,
    TRANS_CODE                  CHAR,
    PERMIT_SERIES_SEQ_NUM       NUMBER(10)   not null,
    PERMIT_SERIES_NAME          VARCHAR2(40),
    RESP_PERSON_DATA_OWNER_CODE CHAR(2),
    RESP_PERSON_ID              VARCHAR2(5),
    SUPP_INFO_TXT               VARCHAR2(2000),
    ACTIVE_SERIES_IND           CHAR,
    CREATED_BY_USERID           VARCHAR2(255),
    P_CREATED_DATE              DATE,
    LAST_UPDT_BY                VARCHAR2(255),
    LAST_UPDT_DATE              DATE
)
/

create table RCRA_PRM_EVENT
(
    PRM_EVENT_ID                 VARCHAR2(40) not null
        constraint PK_PRM_EVENT
            primary key,
    PRM_SERIES_ID                VARCHAR2(40) not null
        constraint FK_PRM_EVENT_PRM_SERIES
            references RCRA_PRM_SERIES
                on delete cascade,
    TRANS_CODE                   CHAR,
    ACT_LOC_CODE                 CHAR(2)      not null,
    PERMIT_EVENT_DATA_OWNER_CODE CHAR(2)      not null,
    PERMIT_EVENT_CODE            VARCHAR2(7)  not null,
    EVENT_AGN_CODE               CHAR         not null,
    EVENT_SEQ_NUM                NUMBER(10)   not null,
    ACTL_DATE                    DATE,
    ORIGINAL_SCHEDULE_DATE       DATE,
    NEW_SCHEDULE_DATE            DATE,
    RESP_PERSON_DATA_OWNER_CODE  CHAR(2),
    RESP_PERSON_ID               VARCHAR2(5),
    EVENT_SUBORG_DATA_OWNER_CODE CHAR(2),
    EVENT_SUBORG_CODE            VARCHAR2(10),
    SUPP_INFO_TXT                VARCHAR2(2000),
    CREATED_BY_USERID            VARCHAR2(255),
    P_CREATED_DATE               DATE,
    LAST_UPDT_BY                 VARCHAR2(255),
    LAST_UPDT_DATE               DATE
)
/

create index IX_PRM_EVENT_PRM_SERIES_ID
    on RCRA_PRM_EVENT (PRM_SERIES_ID)
/

create table RCRA_PRM_EVENT_COMMITMENT
(
    PRM_EVENT_COMMITMENT_ID VARCHAR2(40) not null
        constraint PK_PRM_EVENT_COMMITMENT
            primary key,
    PRM_EVENT_ID            VARCHAR2(40) not null
        constraint FK_PRM_EVNT_COMMITMNT_PRM_EVNT
            references RCRA_PRM_EVENT
                on delete cascade,
    TRANS_CODE              CHAR,
    COMMIT_LEAD             CHAR(2)      not null,
    COMMIT_SEQ_NUM          NUMBER(10)   not null
)
/

create index IX_PRM_EVNT_CMMTMN_PRM_EVNT_ID
    on RCRA_PRM_EVENT_COMMITMENT (PRM_EVENT_ID)
/

create table RCRA_PRM_MOD_EVENT
(
    PRM_MOD_EVENT_ID          VARCHAR2(40) not null
        constraint PK_PRM_MOD_EVENT
            primary key,
    PRM_EVENT_ID              VARCHAR2(40) not null
        constraint FK_PRM_MOD_EVENT_PRM_EVENT
            references RCRA_PRM_EVENT
                on delete cascade,
    TRANS_CODE                CHAR,
    MOD_HANDLER_ID            VARCHAR2(12) not null,
    MOD_ACT_LOC_CODE          VARCHAR2(50) not null,
    MOD_SERIES_SEQ_NUM        NUMBER(10)   not null,
    MOD_EVENT_SEQ_NUM         NUMBER(10)   not null,
    MOD_EVENT_AGN_CODE        CHAR         not null,
    MOD_EVENT_DATA_OWNER_CODE CHAR(2)      not null,
    MOD_EVENT_CODE            VARCHAR2(7)  not null
)
/

create index IX_PRM_MOD_EVENT_PRM_EVENT_ID
    on RCRA_PRM_MOD_EVENT (PRM_EVENT_ID)
/

create index IX_PRM_SERIES_PRM_FAC_SUBM_ID
    on RCRA_PRM_SERIES (PRM_FAC_SUBM_ID)
/

create table RCRA_PRM_UNIT
(
    PRM_UNIT_ID         VARCHAR2(40) not null
        constraint PK_PRM_UNIT
            primary key,
    PRM_FAC_SUBM_ID     VARCHAR2(40) not null
        constraint FK_PRM_UNIT_PRM_FAC_SUBM
            references RCRA_PRM_FAC_SUBM
                on delete cascade,
    TRANS_CODE          CHAR,
    PERMIT_UNIT_SEQ_NUM NUMBER(10),
    PERMIT_UNIT_NAME    VARCHAR2(40),
    SUPP_INFO_TXT       VARCHAR2(2000),
    ACTIVE_UNIT_IND     CHAR,
    CREATED_BY_USERID   VARCHAR2(255),
    P_CREATED_DATE      DATE,
    LAST_UPDT_BY        VARCHAR2(255),
    LAST_UPDT_DATE      DATE
)
/

create index IX_PRM_UNIT_PRM_FAC_SUBM_ID
    on RCRA_PRM_UNIT (PRM_FAC_SUBM_ID)
/

create table RCRA_PRM_UNIT_DETAIL
(
    PRM_UNIT_DETAIL_ID             VARCHAR2(40) not null
        constraint PK_PRM_UNIT_DETAIL
            primary key,
    PRM_UNIT_ID                    VARCHAR2(40) not null
        constraint FK_PRM_UNIT_DETAIL_PRM_UNIT
            references RCRA_PRM_UNIT
                on delete cascade,
    TRANS_CODE                     CHAR,
    PERMIT_UNIT_DETAIL_SEQ_NUM     NUMBER(10)   not null,
    PROC_UNIT_DATA_OWNER_CODE      CHAR(2),
    PROC_UNIT_CODE                 VARCHAR2(3),
    PERMIT_STAT_EFFC_DATE          DATE,
    PERMIT_UNIT_CAP_QNTY           NUMBER(14, 3),
    CAP_TYPE_CODE                  CHAR,
    COMMER_STAT_CODE               CHAR,
    LEGAL_OPER_STAT_DATA_OWNER_CDE CHAR(2),
    LEGAL_OPER_STAT_CODE           VARCHAR2(4),
    MEASUREMENT_UNIT_DATA_OWNR_CDE CHAR(2),
    MEASUREMENT_UNIT_CODE          CHAR,
    NUM_OF_UNITS_COUNT             NUMBER(10),
    STANDARD_PERMIT_IND            CHAR,
    SUPP_INFO_TXT                  VARCHAR2(2000),
    CURRENT_UNIT_DETAIL_IND        CHAR,
    CREATED_BY_USERID              VARCHAR2(255),
    P_CREATED_DATE                 DATE,
    LAST_UPDT_BY                   VARCHAR2(255),
    LAST_UPDT_DATE                 DATE
)
/

create table RCRA_PRM_RELATED_EVENT
(
    PRM_RELATED_EVENT_ID         VARCHAR2(40) not null
        constraint PK_PRM_RELATED_EVENT
            primary key,
    PRM_UNIT_DETAIL_ID           VARCHAR2(40) not null
        constraint FK_PRM_RELTD_EVNT_PRM_UNT_DTIL
            references RCRA_PRM_UNIT_DETAIL
                on delete cascade,
    TRANS_CODE                   CHAR,
    ACT_LOC_CODE                 CHAR(2)      not null,
    PERMIT_SERIES_SEQ_NUM        NUMBER(10)   not null,
    PERMIT_EVENT_DATA_OWNER_CODE CHAR(2)      not null,
    PERMIT_EVENT_CODE            VARCHAR2(7)  not null,
    EVENT_AGN_CODE               CHAR         not null,
    EVENT_SEQ_NUM                NUMBER(10)   not null
)
/

create index IX_PRM_RLTD_EVN_PRM_UNT_DTL_ID
    on RCRA_PRM_RELATED_EVENT (PRM_UNIT_DETAIL_ID)
/

create index IX_PRM_UNIT_DETAIL_PRM_UNIT_ID
    on RCRA_PRM_UNIT_DETAIL (PRM_UNIT_ID)
/

create table RCRA_PRM_WASTE_CODE
(
    PRM_WASTE_CODE_ID  VARCHAR2(40) not null
        constraint PK_PRM_WASTE_CODE
            primary key,
    PRM_UNIT_DETAIL_ID VARCHAR2(40) not null
        constraint FK_PRM_WASTE_CDE_PRM_UNT_DETIL
            references RCRA_PRM_UNIT_DETAIL
                on delete cascade,
    TRANSACTION_CODE   CHAR,
    WASTE_CODE_OWNER   CHAR(2),
    WASTE_CODE_TYPE    VARCHAR2(6)
)
/

create index IX_PRM_WSTE_CDE_PRM_UNT_DTL_ID
    on RCRA_PRM_WASTE_CODE (PRM_UNIT_DETAIL_ID)
/

create table RCRA_RU_SUBM
(
    RU_SUBM_ID  VARCHAR2(40) not null
        constraint PK_RU_SUBM
            primary key,
    DATA_ACCESS VARCHAR2(10)
)
/

create table RCRA_RU_REPORT_UNIV_SUBM
(
    RU_REPORT_UNIV_SUBM_ID VARCHAR2(40) not null
        constraint PK_RU_REPORT_UNIV_SUBM
            primary key,
    RU_SUBM_ID             VARCHAR2(40) not null
        constraint FK_RU_REPORT_UNIV_SUBM_RU_SUBM
            references RCRA_RU_SUBM
                on delete cascade
)
/

create table RCRA_RU_REPORT_UNIV
(
    RU_REPORT_UNIV_ID              VARCHAR2(40) not null
        constraint PK_RU_REPORT_UNIV
            primary key,
    RU_REPORT_UNIV_SUBM_ID         VARCHAR2(40) not null
        constraint FK_RU_RPRT_UNV_RU_RPRT_UNV_SBM
            references RCRA_RU_REPORT_UNIV_SUBM
                on delete cascade,
    HANDLER_ID                     VARCHAR2(12) not null,
    ACTIVITY_LOCATION              CHAR(2)      not null,
    SOURCE_TYPE                    CHAR,
    SEQ_NUMBER                     NUMBER(10),
    RECEIVE_DATE                   DATE,
    HANDLER_NAME                   VARCHAR2(80),
    NON_NOTIFIER_IND               CHAR,
    ACCESSIBILITY                  CHAR,
    REPORT_CYCLE                   NUMBER(10),
    REGION                         CHAR(2),
    STATE                          CHAR(2),
    EXTRACT_FLAG                   CHAR,
    ACTIVE_SITE                    VARCHAR2(5),
    COUNTY_CODE                    VARCHAR2(5),
    COUNTY_NAME                    VARCHAR2(80),
    CONTACT_NAME                   VARCHAR2(80),
    CONTACT_PHONE                  VARCHAR2(22),
    CONTACT_FAX                    VARCHAR2(15),
    CONTACT_EMAIL                  VARCHAR2(80),
    CONTACT_TITLE                  VARCHAR2(45),
    OWNER_NAME                     VARCHAR2(80),
    OWNER_TYPE                     CHAR,
    OWNER_SEQ_NUM                  NUMBER(10),
    OPER_NAME                      VARCHAR2(80),
    OPER_TYPE                      CHAR,
    OPER_SEQ_NUM                   NUMBER(10),
    NAIC1_CODE                     VARCHAR2(6),
    NAIC2_CODE                     VARCHAR2(6),
    NAIC3_CODE                     VARCHAR2(6),
    NAIC4_CODE                     VARCHAR2(6),
    IN_HANDLER_UNIVERSE            CHAR,
    IN_A_UNIVERSE                  CHAR,
    FED_WASTE_GENERATOR_OWNER      CHAR(2),
    FED_WASTE_GENERATOR            CHAR,
    STATE_WASTE_GENERATOR_OWNER    CHAR(2),
    STATE_WASTE_GENERATOR          CHAR,
    GEN_STATUS                     VARCHAR2(3),
    UNIV_WASTE                     CHAR,
    LAND_TYPE                      CHAR,
    STATE_DISTRICT_OWNER           CHAR(2),
    STATE_DISTRICT                 VARCHAR2(10),
    SHORT_TERM_GEN_IND             CHAR,
    IMPORTER_ACTIVITY              CHAR,
    MIXED_WASTE_GENERATOR          CHAR,
    TRANSPORTER_ACTIVITY           CHAR,
    TRANSFER_FACILITY_IND          CHAR,
    RECYCLER_ACTIVITY              CHAR,
    ONSITE_BURNER_EXEMPTION        CHAR,
    FURNACE_EXEMPTION              CHAR,
    UNDERGROUND_INJECTION_ACTIVITY CHAR,
    UNIVERSAL_WASTE_DEST_FACILITY  CHAR,
    OFFSITE_WASTE_RECEIPT          CHAR,
    USED_OIL                       VARCHAR2(7),
    FEDERAL_UNIVERSAL_WASTE        CHAR,
    AS_FEDERAL_REGULATED_TSDF      VARCHAR2(6),
    AS_CONVERTED_TSDF              VARCHAR2(6),
    AS_STATE_REGULATED_TSDF        VARCHAR2(9),
    FEDERAL_IND                    VARCHAR2(3),
    HSM                            CHAR(2),
    SUBPART_K                      VARCHAR2(4),
    COMMERCIAL_TSD                 CHAR,
    TSD                            VARCHAR2(5),
    GPRA_PERMIT                    CHAR,
    GPRA_RENEWAL                   CHAR,
    PERMIT_RENEWAL_WRKLD           VARCHAR2(6),
    PERM_WRKLD                     VARCHAR2(6),
    PERM_PROG                      VARCHAR2(6),
    PC_WRKLD                       VARCHAR2(6),
    CLOS_WRKLD                     VARCHAR2(6),
    GPRACA                         CHAR,
    CA_WRKLD                       CHAR,
    SUBJ_CA                        CHAR,
    SUBJ_CA_NON_TSD                CHAR,
    SUBJ_CA_TSD_3004               CHAR,
    SUBJ_CA_DISCRETION             CHAR,
    NCAPS                          CHAR,
    EC_IND                         CHAR,
    IC_IND                         CHAR,
    CA_725_IND                     CHAR,
    CA_750_IND                     CHAR,
    OPERATING_TSDF                 VARCHAR2(6),
    FULL_ENFORCEMENT               VARCHAR2(6),
    SNC                            CHAR,
    BOY_SNC                        CHAR,
    BOY_STATE_UNADDRESSED_SNC      CHAR,
    STATE_UNADDRESSED              CHAR,
    STATE_ADDRESSED                CHAR,
    BOY_STATE_ADDRESSED            CHAR,
    STATE_SNC_WITH_COMP_SCHED      CHAR,
    BOY_STATE_SNC_WITH_COMP_SCHED  CHAR,
    EPA_UNADDRESSED                CHAR,
    BOY_EPA_UNADDRESSED            CHAR,
    EPA_ADDRESSED                  CHAR,
    BOY_EPA_ADDRESSED              CHAR,
    EPA_SNC_WITH_COMP_SCHED        CHAR,
    BOY_EPA_SNC_WITH_COMP_SCHED    CHAR,
    FA_REQUIRED                    VARCHAR2(5),
    HHANDLER_LAST_CHANGE_DATE      DATE,
    PUBLIC_NOTES                   VARCHAR2(4000),
    NOTES                          VARCHAR2(4000),
    RECOGNIZED_TRADER_IMPORTER_IND CHAR,
    RECOGNIZED_TRADER_EXPORTER_IND CHAR,
    SLAB_IMPORTER_IND              CHAR,
    SLAB_EXPORTER_IND              CHAR,
    RECYCLER_NON_STORAGE_IND       CHAR,
    MANIFEST_BROKER_IND            CHAR,
    SUBPART_P_IND                  CHAR,
    LOCATION_LATITUDE              NUMBER(19, 14),
    LOCATION_LONGITUDE             NUMBER(19, 14),
    LOCATION_GIS_PRIM              CHAR,
    LOCATION_GIS_ORIG              CHAR(2),
    LOCATION_STREET_NUMBER         VARCHAR2(12),
    LOCATION_STREET1               VARCHAR2(50),
    LOCATION_STREET2               VARCHAR2(50),
    LOCATION_CITY                  VARCHAR2(25),
    LOCATION_STATE                 CHAR(2),
    LOCATION_ZIP                   VARCHAR2(14),
    LOCATION_COUNTRY               CHAR(2),
    MAIL_STREET_NUMBER             VARCHAR2(12),
    MAIL_STREET1                   VARCHAR2(50),
    MAIL_STREET2                   VARCHAR2(50),
    MAIL_CITY                      VARCHAR2(25),
    MAIL_STATE                     CHAR(2),
    MAIL_COUNTRY                   CHAR(2),
    MAIL_ZIP                       VARCHAR2(14),
    CONTACT_STREET_NUMBER          VARCHAR2(12),
    CONTACT_STREET1                VARCHAR2(50),
    CONTACT_STREET2                VARCHAR2(50),
    CONTACT_CITY                   VARCHAR2(25),
    CONTACT_STATE                  CHAR(2),
    CONTACT_COUNTRY                CHAR(2),
    CONTACT_ZIP                    VARCHAR2(14)
)
/

create index IX_RU_RPR_UNV_RU_RPR_UNV_SB_ID
    on RCRA_RU_REPORT_UNIV (RU_REPORT_UNIV_SUBM_ID)
/

create index IX_RU_REPORT_UNV_HANDLER_ID
    on RCRA_RU_REPORT_UNIV (HANDLER_ID)
/

create index IX_RU_REPORT_UNV_SBM_RU_SBM_ID
    on RCRA_RU_REPORT_UNIV_SUBM (RU_SUBM_ID)
/

create table RCRA_SUBMISSIONHISTORY
(
    SUBMISSIONHISTORY_ID VARCHAR2(40) not null
        constraint PK_SUBMISSIONHISTORY
            primary key,
    SUBMISSIONTYPE       VARCHAR2(50) not null,
    SCHEDULERUNDATE      DATE         not null,
    TRANSACTIONID        VARCHAR2(50) not null,
    PROCESSINGSTATUS     VARCHAR2(50) not null
)
/

create table RCRA_CME_SUBM_DEL
(
    CME_SUBM_DEL_ID VARCHAR2(40) not null
        constraint PK_CME_SUBM_DEL
            primary key
)
/

comment on table RCRA_CME_SUBM_DEL is 'Schema element with delete information: HazardousWasteCMESubmissionDataType'
/

create table RCRA_CME_FAC_SUBM_DEL
(
    CME_FAC_SUBM_DEL_ID VARCHAR2(40) not null
        constraint PK_CME_FAC_SUBM_DEL
            primary key,
    CME_SUBM_DEL_ID     VARCHAR2(40) not null
        constraint FK_CME_FC_SB_CM_SB_DEL
            references RCRA_CME_SUBM_DEL
                on delete cascade,
    EPA_HDLR_ID         CHAR(12)     not null
)
/

comment on table RCRA_CME_FAC_SUBM_DEL is 'Schema element with delete information: CMEFacilitySubmissionDataType'
/

comment on column RCRA_CME_FAC_SUBM_DEL.CME_FAC_SUBM_DEL_ID is 'Parent: This contains Hbasic Data (_PK)'
/

comment on column RCRA_CME_FAC_SUBM_DEL.CME_SUBM_DEL_ID is 'Parent: This contains Hbasic Data (_FK)'
/

comment on column RCRA_CME_FAC_SUBM_DEL.EPA_HDLR_ID is 'Number that uniquely identifies the EPA handler. (EPAHandlerID)'
/

create index IX_CM_FC_SB_CM_SB_DEL
    on RCRA_CME_FAC_SUBM_DEL (CME_SUBM_DEL_ID)
/

create table RCRA_CME_VIOL_DEL
(
    CME_VIOL_DEL_ID     VARCHAR2(40) not null
        constraint PK_CME_VIOL_DEL
            primary key,
    CME_FAC_SUBM_DEL_ID VARCHAR2(40) not null
        constraint FK_CME_VL_CM_FC_SB_DEL
            references RCRA_CME_FAC_SUBM_DEL
                on delete cascade,
    VIOL_ACT_LOC        CHAR(2)      not null,
    VIOL_SEQ_NUM        NUMBER(10)   not null,
    AGN_WHICH_DTRM_VIOL CHAR         not null,
    NOTES               VARCHAR2(4000)
)
/

comment on table RCRA_CME_VIOL_DEL is 'Schema element with delete information: ViolationDataType'
/

comment on column RCRA_CME_VIOL_DEL.CME_VIOL_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Violation Data (_PK)'
/

comment on column RCRA_CME_VIOL_DEL.CME_FAC_SUBM_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Violation Data (_FK)'
/

comment on column RCRA_CME_VIOL_DEL.VIOL_ACT_LOC is 'Parent: Compliance Monitoring and Enforcement Violation Data (ViolationActivityLocation)'
/

comment on column RCRA_CME_VIOL_DEL.VIOL_SEQ_NUM is 'Parent: Compliance Monitoring and Enforcement Violation Data (ViolationSequenceNumber)'
/

comment on column RCRA_CME_VIOL_DEL.AGN_WHICH_DTRM_VIOL is 'Parent: Compliance Monitoring and Enforcement Violation Data (AgencyWhichDeterminedViolation)'
/

comment on column RCRA_CME_VIOL_DEL.NOTES is 'Parent: Compliance Monitoring and Enforcement Violation Data (Notes)'
/

create index IX_CM_VL_CM_FC_SB_DEL
    on RCRA_CME_VIOL_DEL (CME_FAC_SUBM_DEL_ID)
/

create table RCRA_CME_ENFRC_ACT_DEL
(
    CME_ENFRC_ACT_DEL_ID VARCHAR2(40) not null
        constraint PK_CME_ENFRC_ACT_DEL
            primary key,
    CME_FAC_SUBM_DEL_ID  VARCHAR2(40) not null
        constraint FK_CM_EN_AC_CM_FC_DEL
            references RCRA_CME_FAC_SUBM_DEL
                on delete cascade,
    ENFRC_AGN_LOC_NAME   CHAR(2)      not null,
    ENFRC_ACT_IDEN       VARCHAR2(3)  not null,
    ENFRC_ACT_DATE       DATE         not null,
    ENFRC_AGN_NAME       CHAR         not null,
    NOTES                VARCHAR2(4000)
)
/

comment on table RCRA_CME_ENFRC_ACT_DEL is 'Schema element with delete information: EnforcementActionDataType'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.CME_ENFRC_ACT_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Data (_PK)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.CME_FAC_SUBM_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Data (_FK)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.ENFRC_AGN_LOC_NAME is 'The U.S.Postal Service alphabetic code that represents the U.S.State or territory in which a state or local government enforcement agency operates. (EnforcementAgencyLocationName)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.ENFRC_ACT_IDEN is 'The unique alphanumeric identifier used in the applicable database to identify a specific enforcement action pertaining to a regulated entity or facility. (EnforcementActionIdentifier)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.ENFRC_ACT_DATE is 'The calendar date the enforcement action was issued or filed. (EnforcementActionDate)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.ENFRC_AGN_NAME is 'The full name of the agency, department, or organization that submitted the enforcement action data to EPA. (EnforcementAgencyName)'
/

comment on column RCRA_CME_ENFRC_ACT_DEL.NOTES is 'Parent: Compliance Monitoring and Enforcement Data (Notes)'
/

create index IX_CM_EN_AC_CM_FC_DEL
    on RCRA_CME_ENFRC_ACT_DEL (CME_FAC_SUBM_DEL_ID)
/

create table RCRA_CME_EVAL_DEL
(
    CME_EVAL_DEL_ID     VARCHAR2(40) not null
        constraint PK_CME_EVAL_DEL
            primary key,
    CME_FAC_SUBM_DEL_ID VARCHAR2(40) not null
        constraint FK_CME_EV_CM_FC_SB_DEL
            references RCRA_CME_FAC_SUBM_DEL
                on delete cascade,
    EVAL_ACT_LOC        CHAR(2)      not null,
    EVAL_IDEN           VARCHAR2(3)  not null,
    EVAL_START_DATE     DATE         not null,
    EVAL_RESP_AGN       CHAR         not null,
    NOTES               VARCHAR2(4000)
)
/

comment on table RCRA_CME_EVAL_DEL is 'Schema element with delete information: EvaluationDataType'
/

comment on column RCRA_CME_EVAL_DEL.CME_EVAL_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Evaluation Data (_PK)'
/

comment on column RCRA_CME_EVAL_DEL.CME_FAC_SUBM_DEL_ID is 'Parent: Compliance Monitoring and Enforcement Evaluation Data (_FK)'
/

comment on column RCRA_CME_EVAL_DEL.EVAL_ACT_LOC is 'Indicates the location of the agency regulating the EPA handler. (EvaluationActivityLocation)'
/

comment on column RCRA_CME_EVAL_DEL.EVAL_IDEN is 'Name or number assigned by the implementing agency to identify an evaluation. (EvaluationIdentifier)'
/

comment on column RCRA_CME_EVAL_DEL.EVAL_START_DATE is 'The first day of the inspection or record review regardless of the duration of the inspection. (EvaluationStartDate)'
/

comment on column RCRA_CME_EVAL_DEL.EVAL_RESP_AGN is 'Code indicating the agency responsible for conducting the evaluation. (EvaluationResponsibleAgency)'
/

comment on column RCRA_CME_EVAL_DEL.NOTES is 'Parent: Compliance Monitoring and Enforcement Evaluation Data (Notes)'
/

create index IX_CM_EV_CM_FC_SB_DEL
    on RCRA_CME_EVAL_DEL (CME_FAC_SUBM_DEL_ID)
/
