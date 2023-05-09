/****** Object:  Table [dbo].[RCRA_CA_AREA]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_AREA](
                                     [CA_AREA_ID] [varchar](40) NOT NULL,
                                     [CA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                     [TRANS_CODE] [char](1) NULL,
                                     [AREA_SEQ_NUM] [int] NULL,
                                     [FAC_WIDE_IND] [char](1) NULL,
                                     [AREA_NAME] [varchar](40) NULL,
                                     [AIR_REL_IND] [char](1) NULL,
                                     [GROUNDWATER_REL_IND] [char](1) NULL,
                                     [SOIL_REL_IND] [char](1) NULL,
                                     [SURFACE_WATER_REL_IND] [char](1) NULL,
                                     [REGULATED_UNIT_IND] [char](1) NULL,
                                     [EPA_RESP_PERSON_DATA_OWNER_CDE] [char](2) NULL,
                                     [EPA_RESP_PERSON_ID] [varchar](5) NULL,
                                     [STA_RESP_PERSON_DATA_OWNER_CDE] [char](2) NULL,
                                     [STA_RESP_PERSON_ID] [varchar](5) NULL,
                                     [SUPP_INFO_TXT] [varchar](2000) NULL,
                                     [CREATED_BY_USERID] [varchar](255) NULL,
                                     [A_CREATED_DATE] [datetime] NULL,
                                     [DATA_ORIG] [char](2) NULL,
                                     [LAST_UPDT_BY] [varchar](255) NULL,
                                     [LAST_UPDT_DATE] [datetime] NULL,
                                     CONSTRAINT [PK_CA_AREA] PRIMARY KEY CLUSTERED
                                         (
                                          [CA_AREA_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_AREA_REL_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_AREA_REL_EVENT](
                                               [CA_AREA_REL_EVENT_ID] [varchar](40) NOT NULL,
                                               [CA_AREA_ID] [varchar](40) NOT NULL,
                                               [TRANS_CODE] [char](1) NULL,
                                               [ACT_LOC_CODE] [char](2) NOT NULL,
                                               [CORCT_ACT_EVENT_DATA_OWNER_CDE] [char](2) NOT NULL,
                                               [CORCT_ACT_EVENT_CODE] [varchar](7) NOT NULL,
                                               [EVENT_AGN_CODE] [char](1) NOT NULL,
                                               [EVENT_SEQ_NUM] [int] NOT NULL,
                                               CONSTRAINT [PK_CA_AREA_REL_EVENT] PRIMARY KEY CLUSTERED
                                                   (
                                                    [CA_AREA_REL_EVENT_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_AUTH_REL_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_AUTH_REL_EVENT](
                                               [CA_AUTH_REL_EVENT_ID] [varchar](40) NOT NULL,
                                               [CA_AUTHORITY_ID] [varchar](40) NOT NULL,
                                               [TRANS_CODE] [char](1) NULL,
                                               [ACT_LOC_CODE] [char](2) NOT NULL,
                                               [CORCT_ACT_EVENT_DATA_OWNER_CDE] [char](2) NOT NULL,
                                               [CORCT_ACT_EVENT_CODE] [varchar](7) NOT NULL,
                                               [EVENT_AGN_CODE] [char](1) NOT NULL,
                                               [EVENT_SEQ_NUM] [int] NOT NULL,
                                               CONSTRAINT [PK_CA_AUTH_REL_EVENT] PRIMARY KEY CLUSTERED
                                                   (
                                                    [CA_AUTH_REL_EVENT_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_AUTHORITY]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_AUTHORITY](
                                          [CA_AUTHORITY_ID] [varchar](40) NOT NULL,
                                          [CA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                          [TRANS_CODE] [char](1) NULL,
                                          [ACT_LOC_CODE] [char](2) NOT NULL,
                                          [AUTHORITY_DATA_OWNER_CODE] [char](2) NOT NULL,
                                          [AUTHORITY_TYPE_CODE] [char](1) NOT NULL,
                                          [AUTHORITY_AGN_CODE] [char](1) NOT NULL,
                                          [AUTHORITY_EFFC_DATE] [datetime] NOT NULL,
                                          [ISSUE_DATE] [datetime] NULL,
                                          [END_DATE] [datetime] NULL,
                                          [ESTABLISHED_REPOSITORY_CODE] [char](1) NULL,
                                          [RESP_LEAD_PROG_IDEN] [char](1) NULL,
                                          [AUTHORITY_SUBORG_DATA_OWNR_CDE] [char](2) NULL,
                                          [AUTHORITY_SUBORG_CODE] [varchar](10) NULL,
                                          [RESP_PERSON_DATA_OWNER_CODE] [char](2) NULL,
                                          [RESP_PERSON_ID] [varchar](5) NULL,
                                          [SUPP_INFO_TXT] [varchar](2000) NULL,
                                          [CREATED_BY_USERID] [varchar](255) NULL,
                                          [A_CREATED_DATE] [datetime] NULL,
                                          [DATA_ORIG] [char](2) NULL,
                                          [LAST_UPDT_BY] [varchar](255) NULL,
                                          [LAST_UPDT_DATE] [datetime] NULL,
                                          CONSTRAINT [PK_CA_AUTHORITY] PRIMARY KEY CLUSTERED
                                              (
                                               [CA_AUTHORITY_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_EVENT](
                                      [CA_EVENT_ID] [varchar](40) NOT NULL,
                                      [CA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [ACT_LOC_CODE] [char](2) NOT NULL,
                                      [CORCT_ACT_EVENT_DATA_OWNER_CDE] [char](2) NOT NULL,
                                      [CORCT_ACT_EVENT_CODE] [varchar](7) NOT NULL,
                                      [EVENT_AGN_CODE] [char](1) NOT NULL,
                                      [EVENT_SEQ_NUM] [int] NOT NULL,
                                      [ACTL_DATE] [datetime] NULL,
                                      [ORIGINAL_SCHEDULE_DATE] [datetime] NULL,
                                      [NEW_SCHEDULE_DATE] [datetime] NULL,
                                      [EVENT_SUBORG_DATA_OWNER_CODE] [char](2) NULL,
                                      [EVENT_SUBORG_CODE] [varchar](10) NULL,
                                      [RESP_PERSON_DATA_OWNER_CODE] [char](2) NULL,
                                      [RESP_PERSON_ID] [varchar](5) NULL,
                                      [SUPP_INFO_TXT] [varchar](2000) NULL,
                                      [PUBLIC_SUPP_INFO_TXT] [varchar](2000) NULL,
                                      [CREATED_BY_USERID] [varchar](255) NULL,
                                      [A_CREATED_DATE] [datetime] NULL,
                                      [DATA_ORIG] [char](2) NULL,
                                      [LAST_UPDT_BY] [varchar](255) NULL,
                                      [LAST_UPDT_DATE] [datetime] NULL,
                                      CONSTRAINT [PK_CA_EVENT] PRIMARY KEY CLUSTERED
                                          (
                                           [CA_EVENT_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_EVENT_COMMITMENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_EVENT_COMMITMENT](
                                                 [CA_EVENT_COMMITMENT_ID] [varchar](40) NOT NULL,
                                                 [CA_EVENT_ID] [varchar](40) NOT NULL,
                                                 [TRANS_CODE] [char](1) NULL,
                                                 [COMMIT_LEAD] [char](2) NOT NULL,
                                                 [COMMIT_SEQ_NUM] [int] NOT NULL,
                                                 CONSTRAINT [PK_CA_EVENT_COMMITMENT] PRIMARY KEY CLUSTERED
                                                     (
                                                      [CA_EVENT_COMMITMENT_ID] ASC
                                                         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_FAC_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_FAC_SUBM](
                                         [CA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                         [CA_SUBM_ID] [varchar](40) NOT NULL,
                                         [HANDLER_ID] [varchar](12) NOT NULL,
                                         CONSTRAINT [PK_CA_FAC_SUBM] PRIMARY KEY CLUSTERED
                                             (
                                              [CA_FAC_SUBM_ID] ASC
                                                 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_REL_PERMIT_UNIT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_REL_PERMIT_UNIT](
                                                [CA_REL_PERMIT_UNIT_ID] [varchar](40) NOT NULL,
                                                [CA_AREA_ID] [varchar](40) NOT NULL,
                                                [TRANS_CODE] [char](1) NULL,
                                                [PERMIT_UNIT_SEQ_NUM] [int] NULL,
                                                CONSTRAINT [PK_CA_REL_PERMIT_UNIT] PRIMARY KEY CLUSTERED
                                                    (
                                                     [CA_REL_PERMIT_UNIT_ID] ASC
                                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_STATUTORY_CITATION]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_STATUTORY_CITATION](
                                                   [CA_STATUTORY_CITATION_ID] [varchar](40) NOT NULL,
                                                   [CA_AUTHORITY_ID] [varchar](40) NOT NULL,
                                                   [TRANS_CODE] [char](1) NULL,
                                                   [STATUTORY_CITTION_DTA_OWNR_CDE] [char](2) NOT NULL,
                                                   [STATUTORY_CITATION_IDEN] [char](1) NOT NULL,
                                                   CONSTRAINT [PK_CA_STATUTORY_CITATION] PRIMARY KEY CLUSTERED
                                                       (
                                                        [CA_STATUTORY_CITATION_ID] ASC
                                                           )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CA_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CA_SUBM](
                                     [CA_SUBM_ID] [varchar](40) NOT NULL,
                                     CONSTRAINT [PK_CA_SUBM] PRIMARY KEY CLUSTERED
                                         (
                                          [CA_SUBM_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_CITATION]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_CITATION](
                                          [CME_CITATION_ID] [varchar](40) NOT NULL,
                                          [CME_VIOL_ID] [varchar](40) NOT NULL,
                                          [TRANS_CODE] [char](1) NULL,
                                          [CITATION_NAME_SEQ_NUM] [int] NOT NULL,
                                          [CITATION_NAME] [varchar](80) NULL,
                                          [CITATION_NAME_OWNER] [char](2) NULL,
                                          [CITATION_NAME_TYPE] [char](2) NULL,
                                          [NOTES] [varchar](4000) NULL,
                                          CONSTRAINT [PK_CME_CITATION] PRIMARY KEY CLUSTERED
                                              (
                                               [CME_CITATION_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_CSNY_DATE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_CSNY_DATE](
                                           [CME_CSNY_DATE_ID] [varchar](40) NOT NULL,
                                           [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                           [TRANS_CODE] [char](1) NULL,
                                           [SNY_DATE] [datetime] NOT NULL,
                                           CONSTRAINT [PK_CME_CSNY_DATE] PRIMARY KEY CLUSTERED
                                               (
                                                [CME_CSNY_DATE_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_ENFRC_ACT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_ENFRC_ACT](
                                           [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                           [CME_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                           [TRANS_CODE] [char](1) NULL,
                                           [ENFRC_AGN_LOC_NAME] [char](2) NOT NULL,
                                           [ENFRC_ACT_IDEN] [varchar](3) NOT NULL,
                                           [ENFRC_ACT_DATE] [datetime] NOT NULL,
                                           [ENFRC_AGN_NAME] [char](1) NOT NULL,
                                           [ENFRC_DOCKET_NUM] [varchar](15) NULL,
                                           [ENFRC_ATTRY] [varchar](5) NULL,
                                           [CORCT_ACT_COMPT] [char](1) NULL,
                                           [CNST_AGMT_FINAL_ORDER_SEQ_NUM] [int] NULL,
                                           [APPEAL_INIT_DATE] [datetime] NULL,
                                           [APPEAL_RSLN_DATE] [datetime] NULL,
                                           [DISP_STAT_DATE] [datetime] NULL,
                                           [DISP_STAT_OWNER] [char](2) NULL,
                                           [DISP_STAT] [char](2) NULL,
                                           [ENFRC_OWNER] [char](2) NULL,
                                           [ENFRC_TYPE] [char](3) NULL,
                                           [ENFRC_RESP_PERSON_OWNER] [char](2) NULL,
                                           [ENFRC_RESP_PERSON_IDEN] [varchar](5) NULL,
                                           [ENFRC_RESP_SUBORG_OWNER] [char](2) NULL,
                                           [ENFRC_RESP_SUBORG] [varchar](10) NULL,
                                           [NOTES] [varchar](4000) NULL,
                                           [CREATED_BY_USERID] [varchar](255) NULL,
                                           [C_CREATED_DATE] [datetime] NULL,
                                           [DATA_ORIG] [char](2) NULL,
                                           [LAST_UPDT_BY] [varchar](255) NULL,
                                           [LAST_UPDT_DATE] [datetime] NULL,
                                           [FA_REQUIRED] [char](1) NULL,
                                           CONSTRAINT [PK_CME_ENFRC_ACT] PRIMARY KEY CLUSTERED
                                               (
                                                [CME_ENFRC_ACT_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_ENFRC_ACT_DEL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_ENFRC_ACT_DEL](
                                               [CME_ENFRC_ACT_DEL_ID] [varchar](40) NOT NULL,
                                               [CME_FAC_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                               [ENFRC_AGN_LOC_NAME] [char](2) NOT NULL,
                                               [ENFRC_ACT_IDEN] [varchar](3) NOT NULL,
                                               [ENFRC_ACT_DATE] [date] NOT NULL,
                                               [ENFRC_AGN_NAME] [char](1) NOT NULL,
                                               [NOTES] [varchar](4000) NULL,
                                               CONSTRAINT [PK_CME_ENFRC_ACT_DEL] PRIMARY KEY CLUSTERED
                                                   (
                                                    [CME_ENFRC_ACT_DEL_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_EVAL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_EVAL](
                                      [CME_EVAL_ID] [varchar](40) NOT NULL,
                                      [CME_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [EVAL_ACT_LOC] [char](2) NOT NULL,
                                      [EVAL_IDEN] [varchar](3) NOT NULL,
                                      [EVAL_START_DATE] [datetime] NOT NULL,
                                      [EVAL_RESP_AGN] [char](1) NOT NULL,
                                      [DAY_ZERO] [datetime] NULL,
                                      [FOUND_VIOL] [char](1) NULL,
                                      [CTZN_CPLT_IND] [char](1) NULL,
                                      [MULTIMEDIA_IND] [char](1) NULL,
                                      [SAMPL_IND] [char](1) NULL,
                                      [NOT_SUBTL_C_IND] [char](1) NULL,
                                      [EVAL_TYPE_OWNER] [char](2) NULL,
                                      [EVAL_TYPE] [varchar](3) NULL,
                                      [FOCUS_AREA_OWNER] [char](2) NULL,
                                      [FOCUS_AREA] [varchar](3) NULL,
                                      [EVAL_RESP_PERSON_IDEN_OWNER] [char](2) NULL,
                                      [EVAL_RESP_PERSON_IDEN] [varchar](5) NULL,
                                      [EVAL_RESP_SUBORG_OWNER] [char](2) NULL,
                                      [EVAL_RESP_SUBORG] [varchar](10) NULL,
                                      [NOTES] [varchar](4000) NULL,
                                      [NOC_DATE] [datetime] NULL,
                                      [CREATED_BY_USERID] [varchar](255) NULL,
                                      [C_CREATED_DATE] [datetime] NULL,
                                      [DATA_ORIG] [char](2) NULL,
                                      [LAST_UPDT_BY] [varchar](255) NULL,
                                      [LAST_UPDT_DATE] [datetime] NULL,
                                      CONSTRAINT [PK_CME_EVAL] PRIMARY KEY CLUSTERED
                                          (
                                           [CME_EVAL_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_EVAL_COMMIT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_EVAL_COMMIT](
                                             [CME_EVAL_COMMIT_ID] [varchar](40) NOT NULL,
                                             [CME_EVAL_ID] [varchar](40) NOT NULL,
                                             [TRANS_CODE] [char](1) NULL,
                                             [COMMIT_LEAD] [char](2) NOT NULL,
                                             [COMMIT_SEQ_NUM] [int] NOT NULL,
                                             CONSTRAINT [PK_CME_EVAL_COMMIT] PRIMARY KEY CLUSTERED
                                                 (
                                                  [CME_EVAL_COMMIT_ID] ASC
                                                     )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_EVAL_DEL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_EVAL_DEL](
                                          [CME_EVAL_DEL_ID] [varchar](40) NOT NULL,
                                          [CME_FAC_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                          [EVAL_ACT_LOC] [char](2) NOT NULL,
                                          [EVAL_IDEN] [varchar](3) NOT NULL,
                                          [EVAL_START_DATE] [date] NOT NULL,
                                          [EVAL_RESP_AGN] [char](1) NOT NULL,
                                          [NOTES] [varchar](4000) NULL,
                                          CONSTRAINT [PK_CME_EVAL_DEL] PRIMARY KEY CLUSTERED
                                              (
                                               [CME_EVAL_DEL_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_EVAL_VIOL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_EVAL_VIOL](
                                           [CME_EVAL_VIOL_ID] [varchar](40) NOT NULL,
                                           [CME_EVAL_ID] [varchar](40) NOT NULL,
                                           [TRANS_CODE] [char](1) NULL,
                                           [VIOL_ACT_LOC] [char](2) NOT NULL,
                                           [VIOL_SEQ_NUM] [int] NOT NULL,
                                           [AGN_WHICH_DTRM_VIOL] [char](1) NOT NULL,
                                           CONSTRAINT [PK_CME_EVAL_VIOL] PRIMARY KEY CLUSTERED
                                               (
                                                [CME_EVAL_VIOL_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_FAC_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_FAC_SUBM](
                                          [CME_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                          [CME_SUBM_ID] [varchar](40) NOT NULL,
                                          [EPA_HDLR_ID] [char](12) NOT NULL,
                                          CONSTRAINT [PK_CME_FAC_SUBM] PRIMARY KEY CLUSTERED
                                              (
                                               [CME_FAC_SUBM_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_FAC_SUBM_DEL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_FAC_SUBM_DEL](
                                              [CME_FAC_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                              [CME_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                              [EPA_HDLR_ID] [char](12) NOT NULL,
                                              CONSTRAINT [PK_CME_FAC_SUBM_DEL] PRIMARY KEY CLUSTERED
                                                  (
                                                   [CME_FAC_SUBM_DEL_ID] ASC
                                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_MEDIA]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_MEDIA](
                                       [CME_MEDIA_ID] [varchar](40) NOT NULL,
                                       [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                       [TRANS_CODE] [char](1) NULL,
                                       [MULTIMEDIA_CODE_OWNER] [char](2) NOT NULL,
                                       [MULTIMEDIA_CODE] [varchar](3) NOT NULL,
                                       [NOTES] [varchar](4000) NULL,
                                       CONSTRAINT [PK_CME_MEDIA] PRIMARY KEY CLUSTERED
                                           (
                                            [CME_MEDIA_ID] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_MILESTONE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_MILESTONE](
                                           [CME_MILESTONE_ID] [varchar](40) NOT NULL,
                                           [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                           [TRANS_CODE] [char](1) NULL,
                                           [MILESTONE_SEQ_NUM] [int] NOT NULL,
                                           [TECH_RQMT_IDEN] [varchar](50) NULL,
                                           [TECH_RQMT_DESC] [varchar](200) NULL,
                                           [MILESTONE_SCHD_COMP_DATE] [datetime] NULL,
                                           [MILESTONE_ACTL_COMP_DATE] [datetime] NULL,
                                           [MILESTONE_DFLT_DATE] [datetime] NULL,
                                           [NOTES] [varchar](4000) NULL,
                                           CONSTRAINT [PK_CME_MILESTONE] PRIMARY KEY CLUSTERED
                                               (
                                                [CME_MILESTONE_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_PNLTY]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_PNLTY](
                                       [CME_PNLTY_ID] [varchar](40) NOT NULL,
                                       [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                       [TRANS_CODE] [char](1) NULL,
                                       [PNLTY_TYPE_OWNER] [char](2) NOT NULL,
                                       [PNLTY_TYPE] [varchar](3) NOT NULL,
                                       [CASH_CIVIL_PNLTY_SOUGHT_AMOUNT] [decimal](13, 2) NULL,
                                       [NOTES] [varchar](4000) NULL,
                                       CONSTRAINT [PK_CME_PNLTY] PRIMARY KEY CLUSTERED
                                           (
                                            [CME_PNLTY_ID] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_PYMT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_PYMT](
                                      [CME_PYMT_ID] [varchar](40) NOT NULL,
                                      [CME_PNLTY_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [PYMT_SEQ_NUM] [int] NOT NULL,
                                      [PYMT_DFLT_DATE] [datetime] NULL,
                                      [SCHD_PYMT_DATE] [datetime] NULL,
                                      [SCHD_PYMT_AMOUNT] [decimal](13, 2) NULL,
                                      [ACTL_PYMT_DATE] [datetime] NULL,
                                      [ACTL_PAID_AMOUNT] [decimal](13, 2) NULL,
                                      [NOTES] [varchar](4000) NULL,
                                      CONSTRAINT [PK_CME_PYMT] PRIMARY KEY CLUSTERED
                                          (
                                           [CME_PYMT_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_RQST]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_RQST](
                                      [CME_RQST_ID] [varchar](40) NOT NULL,
                                      [CME_EVAL_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [RQST_SEQ_NUM] [int] NOT NULL,
                                      [DATE_OF_RQST] [datetime] NULL,
                                      [DATE_RESP_RCVD] [datetime] NULL,
                                      [RQST_AGN] [char](1) NULL,
                                      [NOTES] [varchar](4000) NULL,
                                      CONSTRAINT [PK_CME_RQST] PRIMARY KEY CLUSTERED
                                          (
                                           [CME_RQST_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_SUBM](
                                      [CME_SUBM_ID] [varchar](40) NOT NULL,
                                      CONSTRAINT [PK_CME_SUBM] PRIMARY KEY CLUSTERED
                                          (
                                           [CME_SUBM_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_SUBM_DEL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_SUBM_DEL](
                                          [CME_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                          CONSTRAINT [PK_CME_SUBM_DEL] PRIMARY KEY CLUSTERED
                                              (
                                               [CME_SUBM_DEL_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_SUPP_ENVR_PRJT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_SUPP_ENVR_PRJT](
                                                [CME_SUPP_ENVR_PRJT_ID] [varchar](40) NOT NULL,
                                                [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                                [TRANS_CODE] [char](1) NULL,
                                                [SEP_SEQ_NUM] [int] NOT NULL,
                                                [SEP_EXPND_AMOUNT] [decimal](13, 2) NULL,
                                                [SEP_SCHD_COMP_DATE] [datetime] NULL,
                                                [SEP_ACTL_DATE] [datetime] NULL,
                                                [SEP_DFLT_DATE] [datetime] NULL,
                                                [SEP_CODE_OWNER] [char](2) NULL,
                                                [SEP_DESC_TXT] [varchar](3) NULL,
                                                [NOTES] [varchar](4000) NULL,
                                                CONSTRAINT [PK_CME_SUPP_ENVR_PRJT] PRIMARY KEY CLUSTERED
                                                    (
                                                     [CME_SUPP_ENVR_PRJT_ID] ASC
                                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_VIOL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_VIOL](
                                      [CME_VIOL_ID] [varchar](40) NOT NULL,
                                      [CME_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [VIOL_ACT_LOC] [char](2) NOT NULL,
                                      [VIOL_SEQ_NUM] [int] NOT NULL,
                                      [AGN_WHICH_DTRM_VIOL] [char](1) NOT NULL,
                                      [VIOL_TYPE_OWNER] [char](2) NULL,
                                      [VIOL_TYPE] [varchar](10) NULL,
                                      [FORMER_CITATION_NAME] [varchar](35) NULL,
                                      [VIOL_DTRM_DATE] [datetime] NULL,
                                      [RTN_COMPL_ACTL_DATE] [datetime] NULL,
                                      [RTN_TO_COMPL_QUAL] [char](1) NULL,
                                      [VIOL_RESP_AGN] [char](1) NULL,
                                      [NOTES] [varchar](4000) NULL,
                                      [CREATED_BY_USERID] [varchar](255) NULL,
                                      [C_CREATED_DATE] [datetime] NULL,
                                      [LAST_UPDT_BY] [varchar](255) NULL,
                                      [LAST_UPDT_DATE] [datetime] NULL,
                                      CONSTRAINT [PK_CME_VIOL] PRIMARY KEY CLUSTERED
                                          (
                                           [CME_VIOL_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_VIOL_DEL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_VIOL_DEL](
                                          [CME_VIOL_DEL_ID] [varchar](40) NOT NULL,
                                          [CME_FAC_SUBM_DEL_ID] [varchar](40) NOT NULL,
                                          [VIOL_ACT_LOC] [char](2) NOT NULL,
                                          [VIOL_SEQ_NUM] [int] NOT NULL,
                                          [AGN_WHICH_DTRM_VIOL] [char](1) NOT NULL,
                                          [NOTES] [varchar](4000) NULL,
                                          CONSTRAINT [PK_CME_VIOL_DEL] PRIMARY KEY CLUSTERED
                                              (
                                               [CME_VIOL_DEL_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_CME_VIOL_ENFRC]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_CME_VIOL_ENFRC](
                                            [CME_VIOL_ENFRC_ID] [varchar](40) NOT NULL,
                                            [CME_ENFRC_ACT_ID] [varchar](40) NOT NULL,
                                            [TRANS_CODE] [char](1) NULL,
                                            [VIOL_SEQ_NUM] [int] NOT NULL,
                                            [AGN_WHICH_DTRM_VIOL] [char](1) NOT NULL,
                                            [RTN_COMPL_SCHD_DATE] [datetime] NULL,
                                            CONSTRAINT [PK_CME_VIOL_ENFRC] PRIMARY KEY CLUSTERED
                                                (
                                                 [CME_VIOL_ENFRC_ID] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_EMANIFEST]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_EMANIFEST](
                                          [EM_EMANIFEST_ID] [varchar](40) NOT NULL,
                                          [EM_SUBM_ID] [varchar](40) NOT NULL,
                                          [CREATED_DATE] [datetime] NULL,
                                          [UPDATED_DATE] [datetime] NULL,
                                          [MAN_TRACKING_NUM] [varchar](12) NULL,
                                          [STATUS] [varchar](17) NULL,
                                          [IMPORT] [char](1) NULL,
                                          [SUBM_TYPE] [varchar](14) NULL,
                                          [GENERATOR_MODIFIED] [char](1) NULL,
                                          [ORIGIN_TYPE] [varchar](7) NULL,
                                          [SHIPPED_DATE] [datetime] NULL,
                                          [RECEIVED_DATE] [datetime] NULL,
                                          [CERT_DATE] [datetime] NULL,
                                          [REJ_IND] [char](1) NULL,
                                          [DES_FAC_REGISTERED] [char](1) NULL,
                                          [DES_FAC_MODIFIED] [char](1) NULL,
                                          [RESIDUE] [char](1) NULL,
                                          [TRANSPORTER_ON_SITE] [char](1) NULL,
                                          [GENERATOR_CONTACT_FIRST_NAME] [varchar](38) NULL,
                                          [GENERATOR_CONTACT_LAST_NAME] [varchar](38) NULL,
                                          [GENERATOR_REGISTERED] [char](1) NULL,
                                          [REJECTION_TYPE] [varchar](13) NULL,
                                          [ALTERNATE_DESIGNATED_FAC_TYPE] [varchar](9) NULL,
                                          [GENERATOR_NAME] [varchar](80) NULL,
                                          [DES_FAC_SIGNATURE_DATE] [datetime] NULL,
                                          [GENERATOR_ESIG_SIGNATURE_DATE] [datetime] NULL,
                                          [DES_FAC_LOC_STREET_1] [varchar](50) NULL,
                                          [ALT_FAC_MAIL_STREET_2] [varchar](50) NULL,
                                          [DES_FAC_CONTACT_FIRST_NAME] [varchar](38) NULL,
                                          [DES_FAC_CONTACT_LAST_NAME] [varchar](38) NULL,
                                          [GENERATOR_LOC_STREET_2] [varchar](50) NULL,
                                          [GENERATOR_CONTACT_EMAIL] [varchar](80) NULL,
                                          [DES_FAC_MAIL_STREET_1] [varchar](50) NULL,
                                          [PORT_OF_ENTRY_CITY] [varchar](100) NULL,
                                          [GENERATOR_MAIL_ZIP] [varchar](25) NULL,
                                          [DES_FAC_MAIL_STREET_2] [varchar](50) NULL,
                                          [GENERATOR_MAIL_STA] [char](2) NULL,
                                          [FOREIGN_GENERATOR_CTRY_NAME] [varchar](100) NULL,
                                          [GENERATOR_MAIL_CTRY] [char](2) NULL,
                                          [GENERATOR_MAIL_STREET_1] [varchar](50) NULL,
                                          [GENERATOR_MAIL_STREET_2] [varchar](50) NULL,
                                          [MANIFEST_HANDLING_INSTR] [varchar](4000) NULL,
                                          [COI_ONLY] [char](1) NULL,
                                          [GENERATOR_ID] [varchar](15) NULL,
                                          [GENERATOR_SIGNATURE_DATE] [datetime] NULL,
                                          [DES_FAC_LOC_STREET_2] [varchar](50) NULL,
                                          [ALT_FAC_MAIL_STREET_1] [varchar](50) NULL,
                                          [GENERATOR_ESIG_FIRST_NAME] [varchar](38) NULL,
                                          [GENERATOR_ESIG_LAST_NAME] [varchar](38) NULL,
                                          [GENERATOR_LOC_STREET_1] [varchar](50) NULL,
                                          [GENERATOR_MAIL_STREET_NUM] [varchar](12) NULL,
                                          [GENERATOR_MAIL_CITY] [varchar](35) NULL,
                                          [GENERATOR_LOC_STREET_NUM] [varchar](12) NULL,
                                          [GENERATOR_LOC_CITY] [varchar](35) NULL,
                                          [GENERATOR_LOC_STA] [char](2) NULL,
                                          [GENERATOR_LOC_ZIP] [varchar](25) NULL,
                                          [GENERATOR_CONTACT_PHONE_NUM] [varchar](15) NULL,
                                          [GENERATOR_CONTACT_PHONE_EXT] [varchar](6) NULL,
                                          [GENERATOR_CONTACT_COMPANY_NAME] [varchar](80) NULL,
                                          [EMERGENCY_PHONE_NUM] [varchar](15) NULL,
                                          [EMERGENCY_PHONE_EXT] [varchar](6) NULL,
                                          [GENERATOR_PRINTED_NAME] [varchar](80) NULL,
                                          [DES_FAC_ID] [varchar](15) NULL,
                                          [DES_FAC_NAME] [varchar](80) NULL,
                                          [DES_FAC_MAIL_STREET_NUM] [varchar](12) NULL,
                                          [DES_FAC_MAIL_CITY] [varchar](35) NULL,
                                          [DES_FAC_MAIL_CTRY] [char](2) NULL,
                                          [DES_FAC_MAIL_STA] [char](2) NULL,
                                          [DES_FAC_MAIL_ZIP] [varchar](25) NULL,
                                          [DES_FAC_LOC_STREET_NUM] [varchar](12) NULL,
                                          [DES_FAC_LOC_CITY] [varchar](35) NULL,
                                          [DES_FAC_LOC_STA] [char](2) NULL,
                                          [DES_FAC_LOC_ZIP] [varchar](25) NULL,
                                          [DES_FAC_CONTACT_PHONE_NUM] [varchar](15) NULL,
                                          [DES_FAC_CONTACT_PHONE_EXT] [varchar](6) NULL,
                                          [DES_FAC_CONTACT_EMAIL] [varchar](80) NULL,
                                          [DES_FAC_CONTACT_COMPANY_NAME] [varchar](80) NULL,
                                          [DES_FAC_PRINTED_NAME] [varchar](80) NULL,
                                          [DES_FAC_ESIG_FIRST_NAME] [varchar](38) NULL,
                                          [DES_FAC_ESIG_LAST_NAME] [varchar](38) NULL,
                                          [DES_FAC_ESIG_SIGNATURE_DATE] [datetime] NULL,
                                          [ORIG_SUBM_TYPE] [varchar](14) NULL,
                                          [BROKER_ID] [varchar](15) NULL,
                                          [LAST_EM_UPDT_DATE] [datetime] NULL,
                                          [ALT_FAC_PRINTED_NAME] [varchar](80) NULL,
                                          [ALT_FAC_SIGNATURE_DATE] [datetime] NULL,
                                          [ALT_FAC_ESIG_FIRST_NAME] [varchar](38) NULL,
                                          [ALT_FAC_ESIG_LAST_NAME] [varchar](38) NULL,
                                          [ALT_FAC_ESIG_SIGNATURE_DATE] [datetime] NULL,
                                          [ALT_FAC_ID] [varchar](12) NULL,
                                          [ALT_FAC_NAME] [varchar](80) NULL,
                                          [ALT_FAC_MAIL_STREET_NUM] [varchar](12) NULL,
                                          [ALT_FAC_MAIL_CITY] [varchar](25) NULL,
                                          [ALT_FAC_MAIL_STA] [char](2) NULL,
                                          [ALT_FAC_MAIL_ZIP] [varchar](14) NULL,
                                          [ALT_FAC_LOC_STREET_NUM] [varchar](12) NULL,
                                          [ALT_FAC_LOC_STREET_1] [varchar](50) NULL,
                                          [ALT_FAC_LOC_STREET_2] [varchar](50) NULL,
                                          [ALT_FAC_LOC_CITY] [varchar](25) NULL,
                                          [ALT_FAC_LOC_STA] [char](2) NULL,
                                          [ALT_FAC_LOC_ZIP] [varchar](14) NULL,
                                          [ALT_FAC_CONTACT_FIRST_NAME] [varchar](38) NULL,
                                          [ALT_FAC_CONTACT_LAST_NAME] [varchar](38) NULL,
                                          [ALT_FAC_CONTACT_PHONE_NO] [varchar](15) NULL,
                                          [ALT_FAC_CONTACT_PHONE_EXT] [varchar](6) NULL,
                                          [ALT_FAC_CONTACT_EMAIL] [varchar](80) NULL,
                                          [ALT_FAC_CONTACT_COMPANY_NAME] [varchar](80) NULL,
                                          [ALT_FAC_REGISTERED] [char](1) NULL,
                                          [ALT_FAC_MODIFIED] [char](1) NULL,
                                          [FOREIGN_GENERATOR_NAME] [varchar](80) NULL,
                                          [FOREIGN_GENERATOR_STREET] [varchar](50) NULL,
                                          [FOREIGN_GENERATOR_CITY] [varchar](25) NULL,
                                          [FOREIGN_GENERATOR_CTRY_CODE] [char](2) NULL,
                                          [FOREIGN_GENERATOR_POST_CODE] [varchar](50) NULL,
                                          [FOREIGN_GENERATOR_PROVINCE] [varchar](50) NULL,
                                          [PORT_OF_ENTRY_STA] [char](2) NULL,
                                          CONSTRAINT [PK_EM_EMANIFEST] PRIMARY KEY CLUSTERED
                                              (
                                               [EM_EMANIFEST_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_EMANIFEST_COMMENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_EMANIFEST_COMMENT](
                                                  [EM_EMANIFEST_COMMENT_ID] [varchar](40) NOT NULL,
                                                  [EM_EMANIFEST_ID] [varchar](40) NOT NULL,
                                                  [CMNT_LABEL] [varchar](255) NULL,
                                                  [CMNT_DESC] [varchar](255) NULL,
                                                  CONSTRAINT [PK_EM_EMANIFEST_COMMENT] PRIMARY KEY CLUSTERED
                                                      (
                                                       [EM_EMANIFEST_COMMENT_ID] ASC
                                                          )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_FED_WASTE_CODE_DESC]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_FED_WASTE_CODE_DESC](
                                                    [EM_FED_WASTE_CODE_DESC_ID] [varchar](40) NOT NULL,
                                                    [EM_WASTE_ID] [varchar](40) NOT NULL,
                                                    [FED_MANIFEST_WASTE_CODE] [varchar](6) NOT NULL,
                                                    [MANIFEST_WASTE_DESC] [varchar](2000) NULL,
                                                    [COI_IND] [char](1) NULL,
                                                    CONSTRAINT [PK_EM_FED_WASTE_CODE_DESC] PRIMARY KEY CLUSTERED
                                                        (
                                                         [EM_FED_WASTE_CODE_DESC_ID] ASC
                                                            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_STATE_WASTE_CODE_DESC]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_STATE_WASTE_CODE_DESC](
                                                      [EM_STATE_WASTE_CODE_DESC_ID] [varchar](40) NOT NULL,
                                                      [EM_WASTE_ID] [varchar](40) NOT NULL,
                                                      [STA_MANIFEST_WASTE_CODE] [varchar](8) NOT NULL,
                                                      [MANIFEST_WASTE_DESC] [varchar](2000) NULL,
                                                      CONSTRAINT [PK_EM_STATE_WASTE_CODE_DESC] PRIMARY KEY CLUSTERED
                                                          (
                                                           [EM_STATE_WASTE_CODE_DESC_ID] ASC
                                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_SUBM](
                                     [EM_SUBM_ID] [varchar](40) NOT NULL,
                                     CONSTRAINT [PK_EM_SUBM] PRIMARY KEY CLUSTERED
                                         (
                                          [EM_SUBM_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_TRANSPORTER]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_TRANSPORTER](
                                            [EM_TRANSPORTER_ID] [varchar](40) NOT NULL,
                                            [EM_EMANIFEST_ID] [varchar](40) NOT NULL,
                                            [TRANSPORTER_ID] [varchar](15) NULL,
                                            [TRANSPORTER_NAME] [varchar](80) NULL,
                                            [TRANSPORTER_PRINTED_NAME] [varchar](80) NULL,
                                            [TRANSPORTER_SIGNATURE_DATE] [datetime] NULL,
                                            [TRANSPORTER_ESIG_FIRST_NAME] [varchar](38) NULL,
                                            [TRANSPORTER_ESIG_LAST_NAME] [varchar](38) NULL,
                                            [TRANS_ESIG_SIGNATURE_DATE] [datetime] NULL,
                                            [TRANSPORTER_LINE_NUM] [varchar](19) NULL,
                                            [TRANSPORTER_REGISTERED] [char](1) NULL,
                                            CONSTRAINT [PK_EM_TRANSPORTER] PRIMARY KEY CLUSTERED
                                                (
                                                 [EM_TRANSPORTER_ID] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_WASTE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_WASTE](
                                      [EM_WASTE_ID] [varchar](40) NOT NULL,
                                      [EM_EMANIFEST_ID] [varchar](40) NOT NULL,
                                      [DOT_HAZRD] [char](1) NULL,
                                      [NON_HAZ_WASTE_DESC] [varchar](500) NULL,
                                      [QNTY_DISCREPANCY] [char](1) NULL,
                                      [PCB] [char](1) NULL,
                                      [LINE_NUM] [int] NULL,
                                      [BR_MIXED_RADIOACTIVE_WASTE] [char](1) NULL,
                                      [DOT_PRINTED_INFO] [varchar](500) NULL,
                                      [CONTAINER_NUM] [int] NULL,
                                      [QNTY_VAL] [decimal](14, 6) NULL,
                                      [QTY_UNIT_OF_MEAS_CODE] [char](1) NULL,
                                      [QTY_UNIT_OF_MEAS_DESC] [varchar](28) NULL,
                                      [BR_DENSITY] [decimal](14, 6) NULL,
                                      [BR_DENSITY_UOM_CODE] [char](1) NULL,
                                      [BR_DENSITY_UOM_DESC] [varchar](240) NULL,
                                      [BR_FORM_CODE] [varchar](4) NULL,
                                      [BR_FORM_CODE_DESC] [varchar](240) NULL,
                                      [BR_SRC_CODE] [varchar](3) NULL,
                                      [BR_SRC_CODE_DESC] [varchar](240) NULL,
                                      [BR_WASTE_MIN_CODE] [char](1) NULL,
                                      [BR_WASTE_MIN_DESC] [varchar](240) NULL,
                                      [EPA_WASTE] [char](1) NULL,
                                      [WASTE_TYPE_DISCREPANCY] [char](1) NULL,
                                      [WASTE_RESIDUE_COMM] [varchar](255) NULL,
                                      [WASTE_RESIDUE] [char](1) NULL,
                                      [MANAGEMENT_METH_CODE] [varchar](4) NULL,
                                      [MANAGEMENT_METH_DESC] [varchar](240) NULL,
                                      [HANDLING_INSTRUCTIONS] [varchar](4000) NULL,
                                      [DOT_ID_NUM_DESC] [varchar](6) NULL,
                                      [CONTAINER_TYPE_CODE] [char](2) NULL,
                                      [CONTAINER_TYPE_DESC] [varchar](50) NULL,
                                      [DISCREPANCY_COMM] [varchar](257) NULL,
                                      [CNST_NUM] [varchar](12) NULL,
                                      [COI_ONLY] [char](1) NULL,
                                      [QNTY_ACUTE_KG] [decimal](14, 6) NULL,
                                      [QNTY_ACUTE_TONS] [decimal](14, 6) NULL,
                                      [QNTY_KG] [decimal](14, 6) NULL,
                                      [QNTY_NON_ACUTE_KG] [decimal](14, 6) NULL,
                                      [QNTY_NON_ACUTE_TONS] [decimal](14, 6) NULL,
                                      [QNTY_TONS] [decimal](14, 6) NULL,
                                      CONSTRAINT [PK_EM_WASTE] PRIMARY KEY CLUSTERED
                                          (
                                           [EM_WASTE_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_WASTE_CD_TRANS]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_WASTE_CD_TRANS](
                                               [EM_WASTE_CD_TRANS_ID] [varchar](40) NOT NULL,
                                               [EM_WASTE_ID] [varchar](40) NOT NULL,
                                               [WASTE_CODE] [varchar](12) NOT NULL,
                                               CONSTRAINT [PK_EM_WASTE_CD_TRANS] PRIMARY KEY CLUSTERED
                                                   (
                                                    [EM_WASTE_CD_TRANS_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_WASTE_COMMENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_WASTE_COMMENT](
                                              [EM_WASTE_COMMENT_ID] [varchar](40) NOT NULL,
                                              [EM_WASTE_ID] [varchar](40) NOT NULL,
                                              [CMNT_LABEL] [varchar](255) NULL,
                                              [CMNT_DESC] [varchar](255) NULL,
                                              CONSTRAINT [PK_EM_WASTE_COMMENT] PRIMARY KEY CLUSTERED
                                                  (
                                                   [EM_WASTE_COMMENT_ID] ASC
                                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_EM_WASTE_PCB]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_EM_WASTE_PCB](
                                          [EM_WASTE_PCB_ID] [varchar](40) NOT NULL,
                                          [EM_WASTE_ID] [varchar](40) NOT NULL,
                                          [PCB_LOAD_TYPE_CODE] [varchar](25) NULL,
                                          [PCB_ARTICLE_CONT_ID] [varchar](255) NULL,
                                          [PCB_REMOVAL_DATE] [datetime] NULL,
                                          [PCB_WEIGHT] [decimal](14, 6) NULL,
                                          [PCB_WASTE_TYPE] [varchar](150) NULL,
                                          [PCB_BULK_IDENTITY] [varchar](255) NULL,
                                          [LOAD_TYPE_DESC] [varchar](25) NULL,
                                          CONSTRAINT [PK_EM_WASTE_PCB] PRIMARY KEY CLUSTERED
                                              (
                                               [EM_WASTE_PCB_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_COST_EST]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_COST_EST](
                                         [FA_COST_EST_ID] [varchar](40) NOT NULL,
                                         [FA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                         [TRANS_CODE] [char](1) NULL,
                                         [ACT_LOC_CODE] [char](2) NOT NULL,
                                         [COST_ESTIMATE_TYPE_CODE] [char](1) NOT NULL,
                                         [COST_ESTIMATE_AGN_CODE] [char](1) NOT NULL,
                                         [COST_ESTIMATE_SEQ_NUM] [int] NOT NULL,
                                         [RESP_PERSON_DATA_OWNER_CODE] [char](2) NULL,
                                         [RESP_PERSON_ID] [varchar](5) NULL,
                                         [COST_ESTIMATE_AMOUNT] [decimal](13, 2) NULL,
                                         [COST_ESTIMATE_DATE] [datetime] NULL,
                                         [COST_ESTIMATE_RSN_CODE] [char](1) NULL,
                                         [AREA_UNIT_NOTES_TXT] [varchar](240) NULL,
                                         [SUPP_INFO_TXT] [varchar](2000) NULL,
                                         [CREATED_BY_USERID] [varchar](255) NULL,
                                         [F_CREATED_DATE] [datetime] NULL,
                                         [DATA_ORIG] [char](2) NULL,
                                         [UPDATE_DUE_DATE] [datetime] NULL,
                                         [CURRENT_COST_ESTIMATE_IND] [char](1) NULL,
                                         [LAST_UPDT_BY] [varchar](255) NULL,
                                         [LAST_UPDT_DATE] [datetime] NULL,
                                         CONSTRAINT [PK_FA_COST_EST] PRIMARY KEY CLUSTERED
                                             (
                                              [FA_COST_EST_ID] ASC
                                                 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_COST_EST_REL_MECHANISM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_COST_EST_REL_MECHANISM](
                                                       [FA_COST_EST_REL_MECHANISM_ID] [varchar](40) NOT NULL,
                                                       [FA_COST_EST_ID] [varchar](40) NOT NULL,
                                                       [TRANS_CODE] [char](1) NULL,
                                                       [ACT_LOC_CODE] [char](2) NOT NULL,
                                                       [MECHANISM_AGN_CODE] [char](1) NOT NULL,
                                                       [MECHANISM_SEQ_NUM] [int] NOT NULL,
                                                       [MECHANISM_DETAIL_SEQ_NUM] [int] NOT NULL,
                                                       CONSTRAINT [PK_FA_COST_EST_REL_MECHANISM] PRIMARY KEY CLUSTERED
                                                           (
                                                            [FA_COST_EST_REL_MECHANISM_ID] ASC
                                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_FAC_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_FAC_SUBM](
                                         [FA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                         [FA_SUBM_ID] [varchar](40) NOT NULL,
                                         [HANDLER_ID] [varchar](12) NOT NULL,
                                         CONSTRAINT [PK_FA_FAC_SUBM] PRIMARY KEY CLUSTERED
                                             (
                                              [FA_FAC_SUBM_ID] ASC
                                                 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_MECHANISM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_MECHANISM](
                                          [FA_MECHANISM_ID] [varchar](40) NOT NULL,
                                          [FA_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                          [TRANS_CODE] [char](1) NULL,
                                          [ACT_LOC_CODE] [char](2) NOT NULL,
                                          [MECHANISM_AGN_CODE] [char](1) NOT NULL,
                                          [MECHANISM_SEQ_NUM] [int] NOT NULL,
                                          [MECHANISM_TYPE_DATA_OWNER_CODE] [char](2) NULL,
                                          [MECHANISM_TYPE_CODE] [char](1) NULL,
                                          [PROVIDER_TXT] [varchar](80) NULL,
                                          [PROVIDER_FULL_CONTACT_NAME] [varchar](33) NULL,
                                          [TELE_NUM_TXT] [varchar](15) NULL,
                                          [SUPP_INFO_TXT] [varchar](2000) NULL,
                                          [CREATED_BY_USERID] [varchar](255) NULL,
                                          [F_CREATED_DATE] [datetime] NULL,
                                          [DATA_ORIG] [char](2) NULL,
                                          [PROVIDER_CONTACT_EMAIL] [varchar](80) NULL,
                                          [ACTIVE_MECHANISM_IND] [char](1) NULL,
                                          [LAST_UPDT_BY] [varchar](255) NULL,
                                          [LAST_UPDT_DATE] [datetime] NULL,
                                          CONSTRAINT [PK_FA_MECHANISM] PRIMARY KEY CLUSTERED
                                              (
                                               [FA_MECHANISM_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_MECHANISM_DETAIL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_MECHANISM_DETAIL](
                                                 [FA_MECHANISM_DETAIL_ID] [varchar](40) NOT NULL,
                                                 [FA_MECHANISM_ID] [varchar](40) NOT NULL,
                                                 [TRANS_CODE] [char](1) NULL,
                                                 [MECHANISM_DETAIL_SEQ_NUM] [int] NOT NULL,
                                                 [MECHANISM_IDEN_TXT] [varchar](40) NULL,
                                                 [FACE_VAL_AMOUNT] [decimal](13, 2) NULL,
                                                 [EFFC_DATE] [datetime] NULL,
                                                 [EXPIRATION_DATE] [datetime] NULL,
                                                 [SUPP_INFO_TXT] [varchar](2000) NULL,
                                                 [CURRENT_MECHANISM_DETAIL_IND] [char](1) NULL,
                                                 [CREATED_BY_USERID] [varchar](255) NULL,
                                                 [F_CREATED_DATE] [datetime] NULL,
                                                 [DATA_ORIG] [char](2) NULL,
                                                 [FAC_FACE_VAL_AMOUNT] [decimal](14, 6) NULL,
                                                 [ALT_IND] [char](1) NULL,
                                                 [LAST_UPDT_BY] [varchar](255) NULL,
                                                 [LAST_UPDT_DATE] [datetime] NULL,
                                                 CONSTRAINT [PK_FA_MECHANISM_DETAIL] PRIMARY KEY CLUSTERED
                                                     (
                                                      [FA_MECHANISM_DETAIL_ID] ASC
                                                         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_FA_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_FA_SUBM](
                                     [FA_SUBM_ID] [varchar](40) NOT NULL,
                                     CONSTRAINT [PK_FA_SUBM] PRIMARY KEY CLUSTERED
                                         (
                                          [FA_SUBM_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_GIS_FAC_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_GIS_FAC_SUBM](
                                          [GIS_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                          [GIS_SUBM_ID] [varchar](40) NOT NULL,
                                          [HANDLER_ID] [varchar](12) NOT NULL,
                                          CONSTRAINT [PK_GIS_FAC_SUBM] PRIMARY KEY CLUSTERED
                                              (
                                               [GIS_FAC_SUBM_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_GIS_GEO_INFORMATION]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_GIS_GEO_INFORMATION](
                                                 [GIS_GEO_INFORMATION_ID] [varchar](40) NOT NULL,
                                                 [GIS_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                                 [TRANS_CODE] [char](1) NULL,
                                                 [GEO_INFO_OWNER] [char](2) NOT NULL,
                                                 [GEO_INFO_SEQ_NUM] [int] NOT NULL,
                                                 [PERMIT_UNIT_SEQ_NUM] [int] NULL,
                                                 [AREA_SEQ_NUM] [int] NULL,
                                                 [LOC_COMM_TXT] [varchar](2000) NULL,
                                                 [CREATED_BY_USERID] [varchar](255) NULL,
                                                 [G_CREATED_DATE] [datetime] NULL,
                                                 [DATA_ORIG] [char](2) NULL,
                                                 [LAST_UPDT_BY] [varchar](255) NULL,
                                                 [LAST_UPDT_DATE] [datetime] NULL,
                                                 [AREA_ACREAGE_MEAS] [decimal](13, 2) NULL,
                                                 [AREA_MEAS_SRC_DATA_OWNER_CODE] [char](2) NULL,
                                                 [AREA_MEAS_SRC_CODE] [varchar](4) NULL,
                                                 [AREA_MEAS_DATE] [datetime] NULL,
                                                 [DATA_COLL_DATE] [datetime] NOT NULL,
                                                 [HORZ_ACC_MEAS] [int] NULL,
                                                 [SRC_MAP_SCALE_NUM] [int] NULL,
                                                 [COORD_DATA_SRC_DATA_OWNER_CODE] [char](2) NULL,
                                                 [COORD_DATA_SRC_CODE] [varchar](3) NULL,
                                                 [GEO_REF_PT_DATA_OWNER_CODE] [char](2) NULL,
                                                 [GEO_REF_PT_CODE] [varchar](3) NULL,
                                                 [GEOM_TYPE_DATA_OWNER_CODE] [char](2) NULL,
                                                 [GEOM_TYPE_CODE] [varchar](3) NULL,
                                                 [HORZ_COLL_METH_DATA_OWNER_CODE] [char](2) NULL,
                                                 [HORZ_COLL_METH_CODE] [varchar](3) NULL,
                                                 [HRZ_CRD_RF_SYS_DTM_DTA_OWN_CDE] [char](2) NULL,
                                                 [HORZ_COORD_REF_SYS_DATUM_CODE] [varchar](3) NULL,
                                                 [VERF_METH_DATA_OWNER_CODE] [char](2) NULL,
                                                 [VERF_METH_CODE] [varchar](3) NULL,
                                                 [LATITUDE] [decimal](19, 14) NULL,
                                                 [LONGITUDE] [decimal](19, 14) NULL,
                                                 [ELEVATION] [decimal](19, 14) NULL,
                                                 CONSTRAINT [PK_GIS_GEO_INFORMATION] PRIMARY KEY CLUSTERED
                                                     (
                                                      [GIS_GEO_INFORMATION_ID] ASC
                                                         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_GIS_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_GIS_SUBM](
                                      [GIS_SUBM_ID] [varchar](40) NOT NULL,
                                      CONSTRAINT [PK_GIS_SUBM] PRIMARY KEY CLUSTERED
                                          (
                                           [GIS_SUBM_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_CERTIFICATION]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_CERTIFICATION](
                                              [HD_CERTIFICATION_ID] [varchar](40) NOT NULL,
                                              [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                              [TRANSACTION_CODE] [char](1) NULL,
                                              [CERT_SEQ] [int] NOT NULL,
                                              [CERT_SIGNED_DATE] [varchar](10) NULL,
                                              [CERT_TITLE] [varchar](45) NULL,
                                              [CERT_FIRST_NAME] [varchar](38) NULL,
                                              [CERT_MIDDLE_INITIAL] [char](1) NULL,
                                              [CERT_LAST_NAME] [varchar](38) NULL,
                                              [CERT_EMAIL_TEXT] [varchar](80) NULL,
                                              CONSTRAINT [PK_HD_CERTIFICATION] PRIMARY KEY CLUSTERED
                                                  (
                                                   [HD_CERTIFICATION_ID] ASC
                                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_ENV_PERMIT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_ENV_PERMIT](
                                           [HD_ENV_PERMIT_ID] [varchar](40) NOT NULL,
                                           [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                           [TRANSACTION_CODE] [char](1) NULL,
                                           [ENV_PERMIT_NUMBER] [varchar](13) NOT NULL,
                                           [ENV_PERMIT_OWNER] [char](2) NULL,
                                           [ENV_PERMIT_TYPE] [char](1) NULL,
                                           [ENV_PERMIT_DESC] [varchar](80) NOT NULL,
                                           CONSTRAINT [PK_HD_ENV_PERMIT] PRIMARY KEY CLUSTERED
                                               (
                                                [HD_ENV_PERMIT_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_EPISODIC_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_EPISODIC_EVENT](
                                               [HD_EPISODIC_EVENT_ID] [varchar](40) NOT NULL,
                                               [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                               [TRANSACTION_CODE] [char](1) NULL,
                                               [EVENT_OWNER] [char](2) NULL,
                                               [EVENT_TYPE] [char](1) NULL,
                                               [START_DATE] [datetime] NULL,
                                               [END_DATE] [datetime] NULL,
                                               [CONTACT_FIRST_NAME] [varchar](38) NULL,
                                               [CONTACT_MIDDLE_INITIAL] [char](1) NULL,
                                               [CONTACT_LAST_NAME] [varchar](38) NULL,
                                               [CONTACT_ORG_NAME] [varchar](80) NULL,
                                               [CONTACT_TITLE] [varchar](80) NULL,
                                               [CONTACT_EMAIL_ADDRESS] [varchar](80) NULL,
                                               [CONTACT_PHONE] [varchar](15) NULL,
                                               [CONTACT_PHONE_EXT] [varchar](6) NULL,
                                               [CONTACT_FAX] [varchar](15) NULL,
                                               CONSTRAINT [PK_HD_EPISODIC_EVENT] PRIMARY KEY CLUSTERED
                                                   (
                                                    [HD_EPISODIC_EVENT_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_EPISODIC_PRJT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_EPISODIC_PRJT](
                                              [HD_EPISODIC_PRJT_ID] [varchar](40) NOT NULL,
                                              [HD_EPISODIC_EVENT_ID] [varchar](40) NOT NULL,
                                              [TRANSACTION_CODE] [char](1) NULL,
                                              [PRJT_CODE_OWNER] [char](2) NOT NULL,
                                              [PRJT_CODE] [char](3) NOT NULL,
                                              [OTHER_PRJT_DESC] [varchar](255) NULL,
                                              CONSTRAINT [PK_HD_EPISODIC_PRJT] PRIMARY KEY CLUSTERED
                                                  (
                                                   [HD_EPISODIC_PRJT_ID] ASC
                                                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_EPISODIC_WASTE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_EPISODIC_WASTE](
                                               [HD_EPISODIC_WASTE_ID] [varchar](40) NOT NULL,
                                               [HD_EPISODIC_EVENT_ID] [varchar](40) NOT NULL,
                                               [TRANSACTION_CODE] [char](1) NULL,
                                               [SEQ_NUMBER] [int] NOT NULL,
                                               [WASTE_DESC] [varchar](4000) NULL,
                                               [EST_QNTY] [int] NULL,
                                               CONSTRAINT [PK_HD_EPISODIC_WASTE] PRIMARY KEY CLUSTERED
                                                   (
                                                    [HD_EPISODIC_WASTE_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_EPISODIC_WASTE_CODE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_EPISODIC_WASTE_CODE](
                                                    [HD_EPISODIC_WASTE_CODE_ID] [varchar](40) NOT NULL,
                                                    [HD_EPISODIC_WASTE_ID] [varchar](40) NOT NULL,
                                                    [TRANSACTION_CODE] [char](1) NULL,
                                                    [WASTE_CODE_OWNER] [char](2) NULL,
                                                    [WASTE_CODE] [varchar](6) NULL,
                                                    [WASTE_CODE_TEXT] [varchar](4000) NULL,
                                                    CONSTRAINT [PK_HD_EPISODIC_WASTE_CODE] PRIMARY KEY CLUSTERED
                                                        (
                                                         [HD_EPISODIC_WASTE_CODE_ID] ASC
                                                            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_HANDLER]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_HANDLER](
                                        [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                        [HD_HBASIC_ID] [varchar](40) NOT NULL,
                                        [TRANSACTION_CODE] [char](1) NULL,
                                        [ACTIVITY_LOCATION] [char](2) NOT NULL,
                                        [SOURCE_TYPE] [char](1) NOT NULL,
                                        [SEQ_NUMBER] [int] NOT NULL,
                                        [RECEIVE_DATE] [varchar](10) NULL,
                                        [HANDLER_NAME] [varchar](80) NULL,
                                        [ACKNOWLEDGE_DATE] [varchar](10) NULL,
                                        [NON_NOTIFIER] [char](1) NULL,
                                        [NON_NOTIFIER_TEXT] [varchar](255) NULL,
                                        [TSD_DATE] [varchar](10) NULL,
                                        [NATURE_OF_BUSINESS_TEXT] [varchar](4000) NULL,
                                        [OFF_SITE_RECEIPT] [char](1) NULL,
                                        [ACCESSIBILITY] [char](1) NULL,
                                        [ACCESSIBILITY_TEXT] [varchar](255) NULL,
                                        [COUNTY_CODE_OWNER] [char](2) NULL,
                                        [COUNTY_CODE] [varchar](5) NULL,
                                        [NOTES] [varchar](4000) NULL,
                                        [INTRNL_NOTES] [varchar](4000) NULL,
                                        [SHORT_TERM_INTRNL_NOTES] [varchar](4000) NULL,
                                        [ACKNOWLEDGE_FLAG_IND] [char](1) NULL,
                                        [INCLUDE_IN_NATIONAL_REPORT_IND] [char](1) NULL,
                                        [LQHUW_IND] [char](1) NULL,
                                        [HD_REPORT_CYCLE_YEAR] [int] NULL,
                                        [HEALTHCARE_FAC] [char](1) NULL,
                                        [REVERSE_DISTRIBUTOR] [char](1) NULL,
                                        [SUBPART_P_WITHDRAWAL] [char](1) NULL,
                                        [CURRENT_RECORD] [char](1) NULL,
                                        [CREATED_BY_USERID] [varchar](255) NULL,
                                        [H_CREATED_DATE] [datetime] NULL,
                                        [DATA_ORIG] [char](2) NULL,
                                        [LOCATION_LATITUDE] [decimal](19, 14) NULL,
                                        [LOCATION_LONGITUDE] [decimal](19, 14) NULL,
                                        [LOCATION_GIS_PRIM] [char](1) NULL,
                                        [LOCATION_GIS_ORIG] [char](2) NULL,
                                        [LAST_UPDT_BY] [varchar](255) NULL,
                                        [LAST_UPDT_DATE] [datetime] NULL,
                                        [BR_EXEMPT_IND] [char](1) NULL,
                                        [ACKNOWLEDGE_FLAG] [char](1) NULL,
                                        [LOCATION_STREET_NUMBER] [varchar](12) NULL,
                                        [LOCATION_STREET1] [varchar](50) NULL,
                                        [LOCATION_STREET2] [varchar](50) NULL,
                                        [LOCATION_CITY] [varchar](25) NULL,
                                        [LOCATION_STATE] [char](2) NULL,
                                        [LOCATION_COUNTRY] [char](2) NULL,
                                        [LOCATION_ZIP] [varchar](14) NULL,
                                        [MAIL_STREET_NUMBER] [varchar](12) NULL,
                                        [MAIL_STREET1] [varchar](50) NULL,
                                        [MAIL_STREET2] [varchar](50) NULL,
                                        [MAIL_CITY] [varchar](25) NULL,
                                        [MAIL_STATE] [char](2) NULL,
                                        [MAIL_COUNTRY] [char](2) NULL,
                                        [MAIL_ZIP] [varchar](14) NULL,
                                        [CONTACT_FIRST_NAME] [varchar](38) NULL,
                                        [CONTACT_MIDDLE_INITIAL] [char](1) NULL,
                                        [CONTACT_LAST_NAME] [varchar](38) NULL,
                                        [CONTACT_ORG_NAME] [varchar](80) NULL,
                                        [CONTACT_TITLE] [varchar](80) NULL,
                                        [CONTACT_EMAIL_ADDRESS] [varchar](80) NULL,
                                        [CONTACT_PHONE] [varchar](15) NULL,
                                        [CONTACT_PHONE_EXT] [varchar](6) NULL,
                                        [CONTACT_FAX] [varchar](15) NULL,
                                        [CONTACT_STREET_NUMBER] [varchar](12) NULL,
                                        [CONTACT_STREET1] [varchar](50) NULL,
                                        [CONTACT_STREET2] [varchar](50) NULL,
                                        [CONTACT_CITY] [varchar](25) NULL,
                                        [CONTACT_STATE] [char](2) NULL,
                                        [CONTACT_COUNTRY] [char](2) NULL,
                                        [CONTACT_ZIP] [varchar](14) NULL,
                                        [PCONTACT_FIRST_NAME] [varchar](38) NULL,
                                        [PCONTACT_MIDDLE_NAME] [char](1) NULL,
                                        [PCONTACT_LAST_NAME] [varchar](38) NULL,
                                        [PCONTACT_ORG_NAME] [varchar](80) NULL,
                                        [PCONTACT_TITLE] [varchar](80) NULL,
                                        [PCONTACT_EMAIL_ADDRESS] [varchar](80) NULL,
                                        [PCONTACT_PHONE] [varchar](15) NULL,
                                        [PCONTACT_PHONE_EXT] [varchar](6) NULL,
                                        [PCONTACT_FAX] [varchar](15) NULL,
                                        [PCONTACT_STREET_NUMBER] [varchar](12) NULL,
                                        [PCONTACT_STREET1] [varchar](50) NULL,
                                        [PCONTACT_STREET2] [varchar](50) NULL,
                                        [PCONTACT_CITY] [varchar](25) NULL,
                                        [PCONTACT_STATE] [char](2) NULL,
                                        [PCONTACT_COUNTRY] [char](2) NULL,
                                        [PCONTACT_ZIP] [varchar](14) NULL,
                                        [USED_OIL_BURNER] [char](1) NULL,
                                        [USED_OIL_PROCESSOR] [char](1) NULL,
                                        [USED_OIL_REFINER] [char](1) NULL,
                                        [USED_OIL_MARKET_BURNER] [char](1) NULL,
                                        [USED_OIL_SPEC_MARKETER] [char](1) NULL,
                                        [USED_OIL_TRANSFER_FACILITY] [char](1) NULL,
                                        [USED_OIL_TRANSPORTER] [char](1) NULL,
                                        [LAND_TYPE] [char](1) NULL,
                                        [STATE_DISTRICT_OWNER] [char](2) NULL,
                                        [STATE_DISTRICT] [varchar](10) NULL,
                                        [STATE_DISTRICT_TEXT] [varchar](255) NULL,
                                        [IMPORTER_ACTIVITY] [char](1) NULL,
                                        [MIXED_WASTE_GENERATOR] [char](1) NULL,
                                        [RECYCLER_ACTIVITY] [char](1) NULL,
                                        [TRANSPORTER_ACTIVITY] [char](1) NULL,
                                        [TSD_ACTIVITY] [char](1) NULL,
                                        [UNDERGROUND_INJECTION_ACTIVITY] [char](1) NULL,
                                        [UNIVERSAL_WASTE_DEST_FACILITY] [char](1) NULL,
                                        [ONSITE_BURNER_EXEMPTION] [char](1) NULL,
                                        [FURNACE_EXEMPTION] [char](1) NULL,
                                        [SHORT_TERM_GEN_IND] [char](1) NULL,
                                        [TRANSFER_FACILITY_IND] [char](1) NULL,
                                        [RECOGNIZED_TRADER_IMPORTER_IND] [char](1) NULL,
                                        [RECOGNIZED_TRADER_EXPORTER_IND] [char](1) NULL,
                                        [SLAB_IMPORTER_IND] [char](1) NULL,
                                        [SLAB_EXPORTER_IND] [char](1) NULL,
                                        [RECYCLER_ACT_NONSTORAGE] [char](1) NULL,
                                        [MANIFEST_BROKER] [char](1) NULL,
                                        [STATE_WASTE_GENERATOR_OWNER] [char](2) NULL,
                                        [STATE_WASTE_GENERATOR] [char](1) NULL,
                                        [FED_WASTE_GENERATOR_OWNER] [char](2) NULL,
                                        [FED_WASTE_GENERATOR] [char](1) NULL,
                                        [COLLEGE_IND] [char](1) NULL,
                                        [HOSPITAL_IND] [char](1) NULL,
                                        [NON_PROFIT_IND] [char](1) NULL,
                                        [WITHDRAWAL_IND] [char](1) NULL,
                                        [TRANS_CODE] [char](1) NULL,
                                        [NOTIFICATION_RSN_CODE] [char](1) NULL,
                                        [EFFC_DATE] [datetime] NULL,
                                        [FINANCIAL_ASSURANCE_IND] [char](1) NULL,
                                        [RECYCLER_IND] [char](1) NULL,
                                        [RECYCLER_NOTES] [varchar](4000) NULL,
                                        [RECYCLING_IND] [char](1) NULL,
                                        CONSTRAINT [PK_HD_HANDLER] PRIMARY KEY CLUSTERED
                                            (
                                             [HD_HANDLER_ID] ASC
                                                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_HBASIC]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_HBASIC](
                                       [HD_HBASIC_ID] [varchar](40) NOT NULL,
                                       [HD_SUBM_ID] [varchar](40) NOT NULL,
                                       [TRANSACTION_CODE] [char](1) NULL,
                                       [HANDLER_ID] [varchar](12) NULL,
                                       [EXTRACT_FLAG] [char](1) NULL,
                                       [FACILITY_IDENTIFIER] [varchar](12) NULL,
                                       CONSTRAINT [PK_HD_HBASIC] PRIMARY KEY CLUSTERED
                                           (
                                            [HD_HBASIC_ID] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_LQG_CLOSURE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_LQG_CLOSURE](
                                            [HD_LQG_CLOSURE_ID] [varchar](40) NOT NULL,
                                            [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                            [TRANSACTION_CODE] [char](1) NULL,
                                            [CLOSURE_TYPE] [char](1) NULL,
                                            [EXPECTED_CLOSURE_DATE] [datetime] NULL,
                                            [NEW_CLOSURE_DATE] [datetime] NULL,
                                            [DATE_CLOSED] [datetime] NULL,
                                            [IN_COMPLIANCE_IND] [char](1) NULL,
                                            CONSTRAINT [PK_HD_LQG_CLOSURE] PRIMARY KEY CLUSTERED
                                                (
                                                 [HD_LQG_CLOSURE_ID] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_LQG_CONSOLIDATION]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_LQG_CONSOLIDATION](
                                                  [HD_LQG_CONSOLIDATION_ID] [varchar](40) NOT NULL,
                                                  [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                                  [TRANSACTION_CODE] [char](1) NULL,
                                                  [SEQ_NUMBER] [int] NOT NULL,
                                                  [HANDLER_ID] [varchar](12) NULL,
                                                  [HANDLER_NAME] [varchar](80) NULL,
                                                  [MAIL_STREET_NUMBER] [varchar](12) NULL,
                                                  [MAIL_STREET1] [varchar](50) NULL,
                                                  [MAIL_STREET2] [varchar](50) NULL,
                                                  [MAIL_CITY] [varchar](25) NULL,
                                                  [MAIL_STATE] [char](2) NULL,
                                                  [MAIL_COUNTRY] [char](2) NULL,
                                                  [MAIL_ZIP] [varchar](14) NULL,
                                                  [CONTACT_FIRST_NAME] [varchar](38) NULL,
                                                  [CONTACT_MIDDLE_INITIAL] [char](1) NULL,
                                                  [CONTACT_LAST_NAME] [varchar](38) NULL,
                                                  [CONTACT_ORG_NAME] [varchar](80) NULL,
                                                  [CONTACT_TITLE] [varchar](80) NULL,
                                                  [CONTACT_EMAIL_ADDRESS] [varchar](80) NULL,
                                                  [CONTACT_PHONE] [varchar](15) NULL,
                                                  [CONTACT_PHONE_EXT] [varchar](6) NULL,
                                                  [CONTACT_FAX] [varchar](15) NULL,
                                                  CONSTRAINT [PK_HD_LQG_CONSOLIDATION] PRIMARY KEY CLUSTERED
                                                      (
                                                       [HD_LQG_CONSOLIDATION_ID] ASC
                                                          )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_NAICS]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_NAICS](
                                      [HD_NAICS_ID] [varchar](40) NOT NULL,
                                      [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                      [TRANSACTION_CODE] [char](1) NULL,
                                      [NAICS_SEQ] [varchar](4) NOT NULL,
                                      [NAICS_OWNER] [char](2) NULL,
                                      [NAICS_CODE] [varchar](6) NULL,
                                      CONSTRAINT [PK_HD_NAICS] PRIMARY KEY CLUSTERED
                                          (
                                           [HD_NAICS_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_OTHER_ID]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_OTHER_ID](
                                         [HD_OTHER_ID_ID] [varchar](40) NOT NULL,
                                         [HD_HBASIC_ID] [varchar](40) NOT NULL,
                                         [TRANSACTION_CODE] [char](1) NULL,
                                         [OTHER_ID] [varchar](12) NOT NULL,
                                         [RELATIONSHIP_OWNER] [char](2) NULL,
                                         [RELATIONSHIP_TYPE] [char](1) NULL,
                                         [SAME_FACILITY] [char](1) NULL,
                                         [NOTES] [varchar](4000) NULL,
                                         CONSTRAINT [PK_HD_OTHER_ID] PRIMARY KEY CLUSTERED
                                             (
                                              [HD_OTHER_ID_ID] ASC
                                                 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_OWNEROP]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_OWNEROP](
                                        [HD_OWNEROP_ID] [varchar](40) NOT NULL,
                                        [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                        [TRANSACTION_CODE] [char](1) NULL,
                                        [OWNER_OP_SEQ] [int] NOT NULL,
                                        [OWNER_OP_IND] [char](2) NULL,
                                        [OWNER_OP_TYPE] [char](1) NULL,
                                        [DATE_BECAME_CURRENT] [varchar](10) NULL,
                                        [DATE_ENDED_CURRENT] [varchar](10) NULL,
                                        [NOTES] [varchar](4000) NULL,
                                        [FIRST_NAME] [varchar](38) NULL,
                                        [MIDDLE_INITIAL] [char](1) NULL,
                                        [LAST_NAME] [varchar](38) NULL,
                                        [ORG_NAME] [varchar](80) NULL,
                                        [TITLE] [varchar](80) NULL,
                                        [EMAIL_ADDRESS] [varchar](80) NULL,
                                        [PHONE] [varchar](15) NULL,
                                        [PHONE_EXT] [varchar](6) NULL,
                                        [FAX] [varchar](15) NULL,
                                        [MAIL_ADDR_NUM_TXT] [varchar](12) NULL,
                                        [STREET1] [varchar](50) NULL,
                                        [STREET2] [varchar](50) NULL,
                                        [CITY] [varchar](25) NULL,
                                        [STATE] [char](2) NULL,
                                        [COUNTRY] [char](2) NULL,
                                        [ZIP] [varchar](14) NULL,
                                        CONSTRAINT [PK_HD_OWNEROP] PRIMARY KEY CLUSTERED
                                            (
                                             [HD_OWNEROP_ID] ASC
                                                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_SEC_MATERIAL_ACTIVITY]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_SEC_MATERIAL_ACTIVITY](
                                                      [HD_SEC_MATERIAL_ACTIVITY_ID] [varchar](40) NOT NULL,
                                                      [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                                      [TRANS_CODE] [char](1) NULL,
                                                      [HSM_SEQ_NUM] [varchar](4) NOT NULL,
                                                      [FAC_CODE_OWNER_NAME] [char](2) NULL,
                                                      [FAC_TYPE_CODE] [char](2) NULL,
                                                      [ESTIMATED_SHORT_TONS_QNTY] [int] NULL,
                                                      [ACTL_SHORT_TONS_QNTY] [int] NULL,
                                                      [LAND_BASED_UNIT_IND] [char](2) NULL,
                                                      [LAND_BASED_UNIT_IND_TEXT] [varchar](255) NULL,
                                                      CONSTRAINT [PK_HD_SEC_MATERIAL_ACTIVITY] PRIMARY KEY CLUSTERED
                                                          (
                                                           [HD_SEC_MATERIAL_ACTIVITY_ID] ASC
                                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_SEC_WASTE_CODE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_SEC_WASTE_CODE](
                                               [HD_SEC_WASTE_CODE_ID] [varchar](40) NOT NULL,
                                               [HD_SEC_MATERIAL_ACTIVITY_ID] [varchar](40) NOT NULL,
                                               [TRANSACTION_CODE] [char](1) NULL,
                                               [WASTE_CODE_OWNER] [char](2) NULL,
                                               [WASTE_CODE_TYPE] [varchar](6) NULL,
                                               CONSTRAINT [PK_HD_SEC_WASTE_CODE] PRIMARY KEY CLUSTERED
                                                   (
                                                    [HD_SEC_WASTE_CODE_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_STATE_ACTIVITY]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_STATE_ACTIVITY](
                                               [HD_STATE_ACTIVITY_ID] [varchar](40) NOT NULL,
                                               [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                               [TRANSACTION_CODE] [char](1) NULL,
                                               [STATE_ACTIVITY_OWNER] [char](2) NOT NULL,
                                               [STATE_ACTIVITY_TYPE] [varchar](5) NOT NULL,
                                               CONSTRAINT [PK_HD_STATE_ACTIVITY] PRIMARY KEY CLUSTERED
                                                   (
                                                    [HD_STATE_ACTIVITY_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_SUBM](
                                     [HD_SUBM_ID] [varchar](40) NOT NULL,
                                     CONSTRAINT [PK_HD_SUBM] PRIMARY KEY CLUSTERED
                                         (
                                          [HD_SUBM_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_UNIVERSAL_WASTE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_UNIVERSAL_WASTE](
                                                [HD_UNIVERSAL_WASTE_ID] [varchar](40) NOT NULL,
                                                [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                                [TRANSACTION_CODE] [char](1) NULL,
                                                [UNIVERSAL_WASTE_OWNER] [char](2) NULL,
                                                [UNIVERSAL_WASTE_TYPE] [char](1) NULL,
                                                [ACCUMULATED] [char](1) NULL,
                                                [GENERATED] [char](1) NULL,
                                                CONSTRAINT [PK_HD_UNIVERSAL_WASTE] PRIMARY KEY CLUSTERED
                                                    (
                                                     [HD_UNIVERSAL_WASTE_ID] ASC
                                                        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_HD_WASTE_CODE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_HD_WASTE_CODE](
                                           [HD_WASTE_CODE_ID] [varchar](40) NOT NULL,
                                           [HD_HANDLER_ID] [varchar](40) NOT NULL,
                                           [TRANSACTION_CODE] [char](1) NULL,
                                           [WASTE_CODE_OWNER] [char](2) NULL,
                                           [WASTE_CODE_TYPE] [varchar](6) NULL,
                                           CONSTRAINT [PK_HD_WASTE_CODE] PRIMARY KEY CLUSTERED
                                               (
                                                [HD_WASTE_CODE_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_EVENT](
                                       [PRM_EVENT_ID] [varchar](40) NOT NULL,
                                       [PRM_SERIES_ID] [varchar](40) NOT NULL,
                                       [TRANS_CODE] [char](1) NULL,
                                       [ACT_LOC_CODE] [char](2) NOT NULL,
                                       [PERMIT_EVENT_DATA_OWNER_CODE] [char](2) NOT NULL,
                                       [PERMIT_EVENT_CODE] [varchar](7) NOT NULL,
                                       [EVENT_AGN_CODE] [char](1) NOT NULL,
                                       [EVENT_SEQ_NUM] [int] NOT NULL,
                                       [ACTL_DATE] [datetime] NULL,
                                       [ORIGINAL_SCHEDULE_DATE] [datetime] NULL,
                                       [NEW_SCHEDULE_DATE] [datetime] NULL,
                                       [RESP_PERSON_DATA_OWNER_CODE] [char](2) NULL,
                                       [RESP_PERSON_ID] [varchar](5) NULL,
                                       [EVENT_SUBORG_DATA_OWNER_CODE] [char](2) NULL,
                                       [EVENT_SUBORG_CODE] [varchar](10) NULL,
                                       [SUPP_INFO_TXT] [varchar](2000) NULL,
                                       [CREATED_BY_USERID] [varchar](255) NULL,
                                       [P_CREATED_DATE] [datetime] NULL,
                                       [LAST_UPDT_BY] [varchar](255) NULL,
                                       [LAST_UPDT_DATE] [datetime] NULL,
                                       CONSTRAINT [PK_PRM_EVENT] PRIMARY KEY CLUSTERED
                                           (
                                            [PRM_EVENT_ID] ASC
                                               )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_EVENT_COMMITMENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_EVENT_COMMITMENT](
                                                  [PRM_EVENT_COMMITMENT_ID] [varchar](40) NOT NULL,
                                                  [PRM_EVENT_ID] [varchar](40) NOT NULL,
                                                  [TRANS_CODE] [char](1) NULL,
                                                  [COMMIT_LEAD] [char](2) NOT NULL,
                                                  [COMMIT_SEQ_NUM] [int] NOT NULL,
                                                  CONSTRAINT [PK_PRM_EVENT_COMMITMENT] PRIMARY KEY CLUSTERED
                                                      (
                                                       [PRM_EVENT_COMMITMENT_ID] ASC
                                                          )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_FAC_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_FAC_SUBM](
                                          [PRM_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                          [PRM_SUBM_ID] [varchar](40) NOT NULL,
                                          [HANDLER_ID] [varchar](12) NOT NULL,
                                          CONSTRAINT [PK_PRM_FAC_SUBM] PRIMARY KEY CLUSTERED
                                              (
                                               [PRM_FAC_SUBM_ID] ASC
                                                  )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_MOD_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_MOD_EVENT](
                                           [PRM_MOD_EVENT_ID] [varchar](40) NOT NULL,
                                           [PRM_EVENT_ID] [varchar](40) NOT NULL,
                                           [TRANS_CODE] [char](1) NULL,
                                           [MOD_HANDLER_ID] [varchar](12) NOT NULL,
                                           [MOD_ACT_LOC_CODE] [varchar](50) NOT NULL,
                                           [MOD_SERIES_SEQ_NUM] [int] NOT NULL,
                                           [MOD_EVENT_SEQ_NUM] [int] NOT NULL,
                                           [MOD_EVENT_AGN_CODE] [char](1) NOT NULL,
                                           [MOD_EVENT_DATA_OWNER_CODE] [char](2) NOT NULL,
                                           [MOD_EVENT_CODE] [varchar](7) NOT NULL,
                                           CONSTRAINT [PK_PRM_MOD_EVENT] PRIMARY KEY CLUSTERED
                                               (
                                                [PRM_MOD_EVENT_ID] ASC
                                                   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_RELATED_EVENT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_RELATED_EVENT](
                                               [PRM_RELATED_EVENT_ID] [varchar](40) NOT NULL,
                                               [PRM_UNIT_DETAIL_ID] [varchar](40) NOT NULL,
                                               [TRANS_CODE] [char](1) NULL,
                                               [ACT_LOC_CODE] [char](2) NOT NULL,
                                               [PERMIT_SERIES_SEQ_NUM] [int] NOT NULL,
                                               [PERMIT_EVENT_DATA_OWNER_CODE] [char](2) NOT NULL,
                                               [PERMIT_EVENT_CODE] [varchar](7) NOT NULL,
                                               [EVENT_AGN_CODE] [char](1) NOT NULL,
                                               [EVENT_SEQ_NUM] [int] NOT NULL,
                                               CONSTRAINT [PK_PRM_RELATED_EVENT] PRIMARY KEY CLUSTERED
                                                   (
                                                    [PRM_RELATED_EVENT_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_SERIES]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_SERIES](
                                        [PRM_SERIES_ID] [varchar](40) NOT NULL,
                                        [PRM_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                        [TRANS_CODE] [char](1) NULL,
                                        [PERMIT_SERIES_SEQ_NUM] [int] NOT NULL,
                                        [PERMIT_SERIES_NAME] [varchar](40) NULL,
                                        [RESP_PERSON_DATA_OWNER_CODE] [char](2) NULL,
                                        [RESP_PERSON_ID] [varchar](5) NULL,
                                        [SUPP_INFO_TXT] [varchar](2000) NULL,
                                        [ACTIVE_SERIES_IND] [char](1) NULL,
                                        [CREATED_BY_USERID] [varchar](255) NULL,
                                        [P_CREATED_DATE] [datetime] NULL,
                                        [LAST_UPDT_BY] [varchar](255) NULL,
                                        [LAST_UPDT_DATE] [datetime] NULL,
                                        CONSTRAINT [PK_PRM_SERIES] PRIMARY KEY CLUSTERED
                                            (
                                             [PRM_SERIES_ID] ASC
                                                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_SUBM](
                                      [PRM_SUBM_ID] [varchar](40) NOT NULL,
                                      CONSTRAINT [PK_PRM_SUBM] PRIMARY KEY CLUSTERED
                                          (
                                           [PRM_SUBM_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_UNIT]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_UNIT](
                                      [PRM_UNIT_ID] [varchar](40) NOT NULL,
                                      [PRM_FAC_SUBM_ID] [varchar](40) NOT NULL,
                                      [TRANS_CODE] [char](1) NULL,
                                      [PERMIT_UNIT_SEQ_NUM] [int] NULL,
                                      [PERMIT_UNIT_NAME] [varchar](40) NULL,
                                      [SUPP_INFO_TXT] [varchar](2000) NULL,
                                      [ACTIVE_UNIT_IND] [char](1) NULL,
                                      [CREATED_BY_USERID] [varchar](255) NULL,
                                      [P_CREATED_DATE] [datetime] NULL,
                                      [LAST_UPDT_BY] [varchar](255) NULL,
                                      [LAST_UPDT_DATE] [datetime] NULL,
                                      CONSTRAINT [PK_PRM_UNIT] PRIMARY KEY CLUSTERED
                                          (
                                           [PRM_UNIT_ID] ASC
                                              )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_UNIT_DETAIL]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_UNIT_DETAIL](
                                             [PRM_UNIT_DETAIL_ID] [varchar](40) NOT NULL,
                                             [PRM_UNIT_ID] [varchar](40) NOT NULL,
                                             [TRANS_CODE] [char](1) NULL,
                                             [PERMIT_UNIT_DETAIL_SEQ_NUM] [int] NOT NULL,
                                             [PROC_UNIT_DATA_OWNER_CODE] [char](2) NULL,
                                             [PROC_UNIT_CODE] [varchar](3) NULL,
                                             [PERMIT_STAT_EFFC_DATE] [datetime] NULL,
                                             [PERMIT_UNIT_CAP_QNTY] [decimal](14, 3) NULL,
                                             [CAP_TYPE_CODE] [char](1) NULL,
                                             [COMMER_STAT_CODE] [char](1) NULL,
                                             [LEGAL_OPER_STAT_DATA_OWNER_CDE] [char](2) NULL,
                                             [LEGAL_OPER_STAT_CODE] [varchar](4) NULL,
                                             [MEASUREMENT_UNIT_DATA_OWNR_CDE] [char](2) NULL,
                                             [MEASUREMENT_UNIT_CODE] [char](1) NULL,
                                             [NUM_OF_UNITS_COUNT] [int] NULL,
                                             [STANDARD_PERMIT_IND] [char](1) NULL,
                                             [SUPP_INFO_TXT] [varchar](2000) NULL,
                                             [CURRENT_UNIT_DETAIL_IND] [char](1) NULL,
                                             [CREATED_BY_USERID] [varchar](255) NULL,
                                             [P_CREATED_DATE] [datetime] NULL,
                                             [LAST_UPDT_BY] [varchar](255) NULL,
                                             [LAST_UPDT_DATE] [datetime] NULL,
                                             CONSTRAINT [PK_PRM_UNIT_DETAIL] PRIMARY KEY CLUSTERED
                                                 (
                                                  [PRM_UNIT_DETAIL_ID] ASC
                                                     )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_PRM_WASTE_CODE]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_PRM_WASTE_CODE](
                                            [PRM_WASTE_CODE_ID] [varchar](40) NOT NULL,
                                            [PRM_UNIT_DETAIL_ID] [varchar](40) NOT NULL,
                                            [TRANSACTION_CODE] [char](1) NULL,
                                            [WASTE_CODE_OWNER] [char](2) NULL,
                                            [WASTE_CODE_TYPE] [varchar](6) NULL,
                                            CONSTRAINT [PK_PRM_WASTE_CODE] PRIMARY KEY CLUSTERED
                                                (
                                                 [PRM_WASTE_CODE_ID] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_RU_REPORT_UNIV]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_RU_REPORT_UNIV](
                                            [RU_REPORT_UNIV_ID] [varchar](40) NOT NULL,
                                            [RU_REPORT_UNIV_SUBM_ID] [varchar](40) NOT NULL,
                                            [HANDLER_ID] [varchar](12) NOT NULL,
                                            [ACTIVITY_LOCATION] [char](2) NOT NULL,
                                            [SOURCE_TYPE] [char](1) NULL,
                                            [SEQ_NUMBER] [int] NULL,
                                            [RECEIVE_DATE] [datetime] NULL,
                                            [HANDLER_NAME] [varchar](80) NULL,
                                            [NON_NOTIFIER_IND] [char](1) NULL,
                                            [ACCESSIBILITY] [char](1) NULL,
                                            [REPORT_CYCLE] [int] NULL,
                                            [REGION] [char](2) NULL,
                                            [STATE] [char](2) NULL,
                                            [EXTRACT_FLAG] [char](1) NULL,
                                            [ACTIVE_SITE] [varchar](5) NULL,
                                            [COUNTY_CODE] [varchar](5) NULL,
                                            [COUNTY_NAME] [varchar](80) NULL,
                                            [CONTACT_NAME] [varchar](80) NULL,
                                            [CONTACT_PHONE] [varchar](22) NULL,
                                            [CONTACT_FAX] [varchar](15) NULL,
                                            [CONTACT_EMAIL] [varchar](80) NULL,
                                            [CONTACT_TITLE] [varchar](45) NULL,
                                            [OWNER_NAME] [varchar](80) NULL,
                                            [OWNER_TYPE] [char](1) NULL,
                                            [OWNER_SEQ_NUM] [int] NULL,
                                            [OPER_NAME] [varchar](80) NULL,
                                            [OPER_TYPE] [char](1) NULL,
                                            [OPER_SEQ_NUM] [int] NULL,
                                            [NAIC1_CODE] [varchar](6) NULL,
                                            [NAIC2_CODE] [varchar](6) NULL,
                                            [NAIC3_CODE] [varchar](6) NULL,
                                            [NAIC4_CODE] [varchar](6) NULL,
                                            [IN_HANDLER_UNIVERSE] [char](1) NULL,
                                            [IN_A_UNIVERSE] [char](1) NULL,
                                            [FED_WASTE_GENERATOR_OWNER] [char](2) NULL,
                                            [FED_WASTE_GENERATOR] [char](1) NULL,
                                            [STATE_WASTE_GENERATOR_OWNER] [char](2) NULL,
                                            [STATE_WASTE_GENERATOR] [char](1) NULL,
                                            [GEN_STATUS] [varchar](3) NULL,
                                            [UNIV_WASTE] [char](1) NULL,
                                            [LAND_TYPE] [char](1) NULL,
                                            [STATE_DISTRICT_OWNER] [char](2) NULL,
                                            [STATE_DISTRICT] [varchar](10) NULL,
                                            [SHORT_TERM_GEN_IND] [char](1) NULL,
                                            [IMPORTER_ACTIVITY] [char](1) NULL,
                                            [MIXED_WASTE_GENERATOR] [char](1) NULL,
                                            [TRANSPORTER_ACTIVITY] [char](1) NULL,
                                            [TRANSFER_FACILITY_IND] [char](1) NULL,
                                            [RECYCLER_ACTIVITY] [char](1) NULL,
                                            [ONSITE_BURNER_EXEMPTION] [char](1) NULL,
                                            [FURNACE_EXEMPTION] [char](1) NULL,
                                            [UNDERGROUND_INJECTION_ACTIVITY] [char](1) NULL,
                                            [UNIVERSAL_WASTE_DEST_FACILITY] [char](1) NULL,
                                            [OFFSITE_WASTE_RECEIPT] [char](1) NULL,
                                            [USED_OIL] [varchar](7) NULL,
                                            [FEDERAL_UNIVERSAL_WASTE] [char](1) NULL,
                                            [AS_FEDERAL_REGULATED_TSDF] [varchar](6) NULL,
                                            [AS_CONVERTED_TSDF] [varchar](6) NULL,
                                            [AS_STATE_REGULATED_TSDF] [varchar](9) NULL,
                                            [FEDERAL_IND] [varchar](3) NULL,
                                            [HSM] [char](2) NULL,
                                            [SUBPART_K] [varchar](4) NULL,
                                            [COMMERCIAL_TSD] [char](1) NULL,
                                            [TSD] [varchar](5) NULL,
                                            [GPRA_PERMIT] [char](1) NULL,
                                            [GPRA_RENEWAL] [char](1) NULL,
                                            [PERMIT_RENEWAL_WRKLD] [varchar](6) NULL,
                                            [PERM_WRKLD] [varchar](6) NULL,
                                            [PERM_PROG] [varchar](6) NULL,
                                            [PC_WRKLD] [varchar](6) NULL,
                                            [CLOS_WRKLD] [varchar](6) NULL,
                                            [GPRACA] [char](1) NULL,
                                            [CA_WRKLD] [char](1) NULL,
                                            [SUBJ_CA] [char](1) NULL,
                                            [SUBJ_CA_NON_TSD] [char](1) NULL,
                                            [SUBJ_CA_TSD_3004] [char](1) NULL,
                                            [SUBJ_CA_DISCRETION] [char](1) NULL,
                                            [NCAPS] [char](1) NULL,
                                            [EC_IND] [char](1) NULL,
                                            [IC_IND] [char](1) NULL,
                                            [CA_725_IND] [char](1) NULL,
                                            [CA_750_IND] [char](1) NULL,
                                            [OPERATING_TSDF] [varchar](6) NULL,
                                            [FULL_ENFORCEMENT] [varchar](6) NULL,
                                            [SNC] [char](1) NULL,
                                            [BOY_SNC] [char](1) NULL,
                                            [BOY_STATE_UNADDRESSED_SNC] [char](1) NULL,
                                            [STATE_UNADDRESSED] [char](1) NULL,
                                            [STATE_ADDRESSED] [char](1) NULL,
                                            [BOY_STATE_ADDRESSED] [char](1) NULL,
                                            [STATE_SNC_WITH_COMP_SCHED] [char](1) NULL,
                                            [BOY_STATE_SNC_WITH_COMP_SCHED] [char](1) NULL,
                                            [EPA_UNADDRESSED] [char](1) NULL,
                                            [BOY_EPA_UNADDRESSED] [char](1) NULL,
                                            [EPA_ADDRESSED] [char](1) NULL,
                                            [BOY_EPA_ADDRESSED] [char](1) NULL,
                                            [EPA_SNC_WITH_COMP_SCHED] [char](1) NULL,
                                            [BOY_EPA_SNC_WITH_COMP_SCHED] [char](1) NULL,
                                            [FA_REQUIRED] [varchar](5) NULL,
                                            [HHANDLER_LAST_CHANGE_DATE] [datetime] NULL,
                                            [PUBLIC_NOTES] [varchar](4000) NULL,
                                            [NOTES] [varchar](4000) NULL,
                                            [RECOGNIZED_TRADER_IMPORTER_IND] [char](1) NULL,
                                            [RECOGNIZED_TRADER_EXPORTER_IND] [char](1) NULL,
                                            [SLAB_IMPORTER_IND] [char](1) NULL,
                                            [SLAB_EXPORTER_IND] [char](1) NULL,
                                            [RECYCLER_NON_STORAGE_IND] [char](1) NULL,
                                            [MANIFEST_BROKER_IND] [char](1) NULL,
                                            [SUBPART_P_IND] [char](1) NULL,
                                            [LOCATION_LATITUDE] [decimal](19, 14) NULL,
                                            [LOCATION_LONGITUDE] [decimal](19, 14) NULL,
                                            [LOCATION_GIS_PRIM] [char](1) NULL,
                                            [LOCATION_GIS_ORIG] [char](2) NULL,
                                            [LOCATION_STREET_NUMBER] [varchar](12) NULL,
                                            [LOCATION_STREET1] [varchar](50) NULL,
                                            [LOCATION_STREET2] [varchar](50) NULL,
                                            [LOCATION_CITY] [varchar](25) NULL,
                                            [LOCATION_STATE] [char](2) NULL,
                                            [LOCATION_ZIP] [varchar](14) NULL,
                                            [LOCATION_COUNTRY] [char](2) NULL,
                                            [MAIL_STREET_NUMBER] [varchar](12) NULL,
                                            [MAIL_STREET1] [varchar](50) NULL,
                                            [MAIL_STREET2] [varchar](50) NULL,
                                            [MAIL_CITY] [varchar](25) NULL,
                                            [MAIL_STATE] [char](2) NULL,
                                            [MAIL_COUNTRY] [char](2) NULL,
                                            [MAIL_ZIP] [varchar](14) NULL,
                                            [CONTACT_STREET_NUMBER] [varchar](12) NULL,
                                            [CONTACT_STREET1] [varchar](50) NULL,
                                            [CONTACT_STREET2] [varchar](50) NULL,
                                            [CONTACT_CITY] [varchar](25) NULL,
                                            [CONTACT_STATE] [char](2) NULL,
                                            [CONTACT_COUNTRY] [char](2) NULL,
                                            [CONTACT_ZIP] [varchar](14) NULL,
                                            CONSTRAINT [PK_RU_REPORT_UNIV] PRIMARY KEY CLUSTERED
                                                (
                                                 [RU_REPORT_UNIV_ID] ASC
                                                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_RU_REPORT_UNIV_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_RU_REPORT_UNIV_SUBM](
                                                 [RU_REPORT_UNIV_SUBM_ID] [varchar](40) NOT NULL,
                                                 [RU_SUBM_ID] [varchar](40) NOT NULL,
                                                 CONSTRAINT [PK_RU_REPORT_UNIV_SUBM] PRIMARY KEY CLUSTERED
                                                     (
                                                      [RU_REPORT_UNIV_SUBM_ID] ASC
                                                         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_RU_SUBM]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_RU_SUBM](
                                     [RU_SUBM_ID] [varchar](40) NOT NULL,
                                     [DATA_ACCESS] [varchar](10) NULL,
                                     CONSTRAINT [PK_RU_SUBM] PRIMARY KEY CLUSTERED
                                         (
                                          [RU_SUBM_ID] ASC
                                             )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RCRA_SUBMISSIONHISTORY]    Script Date: 1/12/2023 11:07:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RCRA_SUBMISSIONHISTORY](
                                               [SUBMISSIONHISTORY_ID] [varchar](40) NOT NULL,
                                               [SUBMISSIONTYPE] [varchar](50) NOT NULL,
                                               [SCHEDULERUNDATE] [datetime] NOT NULL,
                                               [TRANSACTIONID] [varchar](50) NOT NULL,
                                               [PROCESSINGSTATUS] [varchar](50) NOT NULL,
                                               CONSTRAINT [PK_SUBMISSIONHISTORY] PRIMARY KEY CLUSTERED
                                                   (
                                                    [SUBMISSIONHISTORY_ID] ASC
                                                       )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_CD_TRANS] ADD  CONSTRAINT [DF_EM_WASTE_CD_TRANS_ID]  DEFAULT (newid()) FOR [EM_WASTE_CD_TRANS_ID]
GO
ALTER TABLE [dbo].[RCRA_CA_AREA]  WITH CHECK ADD  CONSTRAINT [FK_CA_AREA_CA_FAC_SUBM] FOREIGN KEY([CA_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CA_FAC_SUBM] ([CA_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_AREA] CHECK CONSTRAINT [FK_CA_AREA_CA_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CA_AREA_REL_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_CA_AREA_REL_EVENT_CA_AREA] FOREIGN KEY([CA_AREA_ID])
    REFERENCES [dbo].[RCRA_CA_AREA] ([CA_AREA_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_AREA_REL_EVENT] CHECK CONSTRAINT [FK_CA_AREA_REL_EVENT_CA_AREA]
GO
ALTER TABLE [dbo].[RCRA_CA_AUTH_REL_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_CA_AUTH_RL_EVNT_CA_AUTHORTY] FOREIGN KEY([CA_AUTHORITY_ID])
    REFERENCES [dbo].[RCRA_CA_AUTHORITY] ([CA_AUTHORITY_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_AUTH_REL_EVENT] CHECK CONSTRAINT [FK_CA_AUTH_RL_EVNT_CA_AUTHORTY]
GO
ALTER TABLE [dbo].[RCRA_CA_AUTHORITY]  WITH CHECK ADD  CONSTRAINT [FK_CA_AUTHORITY_CA_FAC_SUBM] FOREIGN KEY([CA_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CA_FAC_SUBM] ([CA_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_AUTHORITY] CHECK CONSTRAINT [FK_CA_AUTHORITY_CA_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CA_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_CA_EVENT_CA_FAC_SUBM] FOREIGN KEY([CA_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CA_FAC_SUBM] ([CA_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_EVENT] CHECK CONSTRAINT [FK_CA_EVENT_CA_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CA_EVENT_COMMITMENT]  WITH CHECK ADD  CONSTRAINT [FK_CA_EVENT_COMMITMENT_CA_EVNT] FOREIGN KEY([CA_EVENT_ID])
    REFERENCES [dbo].[RCRA_CA_EVENT] ([CA_EVENT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_EVENT_COMMITMENT] CHECK CONSTRAINT [FK_CA_EVENT_COMMITMENT_CA_EVNT]
GO
ALTER TABLE [dbo].[RCRA_CA_FAC_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_CA_FAC_SUBM_CA_SUBM] FOREIGN KEY([CA_SUBM_ID])
    REFERENCES [dbo].[RCRA_CA_SUBM] ([CA_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_FAC_SUBM] CHECK CONSTRAINT [FK_CA_FAC_SUBM_CA_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CA_REL_PERMIT_UNIT]  WITH CHECK ADD  CONSTRAINT [FK_CA_REL_PERMIT_UNIT_CA_AREA] FOREIGN KEY([CA_AREA_ID])
    REFERENCES [dbo].[RCRA_CA_AREA] ([CA_AREA_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_REL_PERMIT_UNIT] CHECK CONSTRAINT [FK_CA_REL_PERMIT_UNIT_CA_AREA]
GO
ALTER TABLE [dbo].[RCRA_CA_STATUTORY_CITATION]  WITH CHECK ADD  CONSTRAINT [FK_CA_STTUTRY_CITTON_CA_ATHRTY] FOREIGN KEY([CA_AUTHORITY_ID])
    REFERENCES [dbo].[RCRA_CA_AUTHORITY] ([CA_AUTHORITY_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CA_STATUTORY_CITATION] CHECK CONSTRAINT [FK_CA_STTUTRY_CITTON_CA_ATHRTY]
GO
ALTER TABLE [dbo].[RCRA_CME_CITATION]  WITH CHECK ADD  CONSTRAINT [FK_CME_CITATION_CME_VIOL] FOREIGN KEY([CME_VIOL_ID])
    REFERENCES [dbo].[RCRA_CME_VIOL] ([CME_VIOL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_CITATION] CHECK CONSTRAINT [FK_CME_CITATION_CME_VIOL]
GO
ALTER TABLE [dbo].[RCRA_CME_CSNY_DATE]  WITH CHECK ADD  CONSTRAINT [FK_CME_CSNY_DATE_CME_ENFRC_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_CSNY_DATE] CHECK CONSTRAINT [FK_CME_CSNY_DATE_CME_ENFRC_ACT]
GO
ALTER TABLE [dbo].[RCRA_CME_ENFRC_ACT]  WITH CHECK ADD  CONSTRAINT [FK_CME_ENFRC_ACT_CME_FAC_SUBM] FOREIGN KEY([CME_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM] ([CME_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_ENFRC_ACT] CHECK CONSTRAINT [FK_CME_ENFRC_ACT_CME_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CME_ENFRC_ACT_DEL]  WITH CHECK ADD  CONSTRAINT [FK_CM_EN_AC_CM_FC_DEL] FOREIGN KEY([CME_FAC_SUBM_DEL_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM_DEL] ([CME_FAC_SUBM_DEL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_ENFRC_ACT_DEL] CHECK CONSTRAINT [FK_CM_EN_AC_CM_FC_DEL]
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL]  WITH CHECK ADD  CONSTRAINT [FK_CME_EVAL_CME_FAC_SUBM] FOREIGN KEY([CME_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM] ([CME_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL] CHECK CONSTRAINT [FK_CME_EVAL_CME_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_COMMIT]  WITH CHECK ADD  CONSTRAINT [FK_CME_EVAL_COMMIT_CME_EVAL] FOREIGN KEY([CME_EVAL_ID])
    REFERENCES [dbo].[RCRA_CME_EVAL] ([CME_EVAL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_COMMIT] CHECK CONSTRAINT [FK_CME_EVAL_COMMIT_CME_EVAL]
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_DEL]  WITH CHECK ADD  CONSTRAINT [FK_CME_EV_CM_FC_SB_DEL] FOREIGN KEY([CME_FAC_SUBM_DEL_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM_DEL] ([CME_FAC_SUBM_DEL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_DEL] CHECK CONSTRAINT [FK_CME_EV_CM_FC_SB_DEL]
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_VIOL]  WITH CHECK ADD  CONSTRAINT [FK_CME_EVAL_VIOL_CME_EVAL] FOREIGN KEY([CME_EVAL_ID])
    REFERENCES [dbo].[RCRA_CME_EVAL] ([CME_EVAL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_EVAL_VIOL] CHECK CONSTRAINT [FK_CME_EVAL_VIOL_CME_EVAL]
GO
ALTER TABLE [dbo].[RCRA_CME_FAC_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_CME_FAC_SUBM_CME_SUBM] FOREIGN KEY([CME_SUBM_ID])
    REFERENCES [dbo].[RCRA_CME_SUBM] ([CME_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_FAC_SUBM] CHECK CONSTRAINT [FK_CME_FAC_SUBM_CME_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CME_FAC_SUBM_DEL]  WITH CHECK ADD  CONSTRAINT [FK_CME_FC_SB_CM_SB_DEL] FOREIGN KEY([CME_SUBM_DEL_ID])
    REFERENCES [dbo].[RCRA_CME_SUBM_DEL] ([CME_SUBM_DEL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_FAC_SUBM_DEL] CHECK CONSTRAINT [FK_CME_FC_SB_CM_SB_DEL]
GO
ALTER TABLE [dbo].[RCRA_CME_MEDIA]  WITH CHECK ADD  CONSTRAINT [FK_CME_MEDIA_CME_ENFRC_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_MEDIA] CHECK CONSTRAINT [FK_CME_MEDIA_CME_ENFRC_ACT]
GO
ALTER TABLE [dbo].[RCRA_CME_MILESTONE]  WITH CHECK ADD  CONSTRAINT [FK_CME_MILESTONE_CME_ENFRC_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_MILESTONE] CHECK CONSTRAINT [FK_CME_MILESTONE_CME_ENFRC_ACT]
GO
ALTER TABLE [dbo].[RCRA_CME_PNLTY]  WITH CHECK ADD  CONSTRAINT [FK_CME_PNLTY_CME_ENFRC_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_PNLTY] CHECK CONSTRAINT [FK_CME_PNLTY_CME_ENFRC_ACT]
GO
ALTER TABLE [dbo].[RCRA_CME_PYMT]  WITH CHECK ADD  CONSTRAINT [FK_CME_PYMT_CME_PNLTY] FOREIGN KEY([CME_PNLTY_ID])
    REFERENCES [dbo].[RCRA_CME_PNLTY] ([CME_PNLTY_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_PYMT] CHECK CONSTRAINT [FK_CME_PYMT_CME_PNLTY]
GO
ALTER TABLE [dbo].[RCRA_CME_RQST]  WITH CHECK ADD  CONSTRAINT [FK_CME_RQST_CME_EVAL] FOREIGN KEY([CME_EVAL_ID])
    REFERENCES [dbo].[RCRA_CME_EVAL] ([CME_EVAL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_RQST] CHECK CONSTRAINT [FK_CME_RQST_CME_EVAL]
GO
ALTER TABLE [dbo].[RCRA_CME_SUPP_ENVR_PRJT]  WITH CHECK ADD  CONSTRAINT [FK_CME_SPP_ENV_PRJ_CME_ENF_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_SUPP_ENVR_PRJT] CHECK CONSTRAINT [FK_CME_SPP_ENV_PRJ_CME_ENF_ACT]
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL]  WITH CHECK ADD  CONSTRAINT [FK_CME_VIOL_CME_FAC_SUBM] FOREIGN KEY([CME_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM] ([CME_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL] CHECK CONSTRAINT [FK_CME_VIOL_CME_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL_DEL]  WITH CHECK ADD  CONSTRAINT [FK_CME_VL_CM_FC_SB_DEL] FOREIGN KEY([CME_FAC_SUBM_DEL_ID])
    REFERENCES [dbo].[RCRA_CME_FAC_SUBM_DEL] ([CME_FAC_SUBM_DEL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL_DEL] CHECK CONSTRAINT [FK_CME_VL_CM_FC_SB_DEL]
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL_ENFRC]  WITH CHECK ADD  CONSTRAINT [FK_CME_VL_ENFRC_CME_ENFRC_ACT] FOREIGN KEY([CME_ENFRC_ACT_ID])
    REFERENCES [dbo].[RCRA_CME_ENFRC_ACT] ([CME_ENFRC_ACT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_CME_VIOL_ENFRC] CHECK CONSTRAINT [FK_CME_VL_ENFRC_CME_ENFRC_ACT]
GO
ALTER TABLE [dbo].[RCRA_EM_EMANIFEST]  WITH CHECK ADD  CONSTRAINT [FK_EM_EMANIFEST_EM_SUBM] FOREIGN KEY([EM_SUBM_ID])
    REFERENCES [dbo].[RCRA_EM_SUBM] ([EM_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_EMANIFEST] CHECK CONSTRAINT [FK_EM_EMANIFEST_EM_SUBM]
GO
ALTER TABLE [dbo].[RCRA_EM_EMANIFEST_COMMENT]  WITH CHECK ADD  CONSTRAINT [FK_EM_EMNIFST_CMMNT_EM_EMNIFST] FOREIGN KEY([EM_EMANIFEST_ID])
    REFERENCES [dbo].[RCRA_EM_EMANIFEST] ([EM_EMANIFEST_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_EMANIFEST_COMMENT] CHECK CONSTRAINT [FK_EM_EMNIFST_CMMNT_EM_EMNIFST]
GO
ALTER TABLE [dbo].[RCRA_EM_FED_WASTE_CODE_DESC]  WITH CHECK ADD  CONSTRAINT [FK_EM_FED_WSTE_CDE_DSC_EM_WSTE] FOREIGN KEY([EM_WASTE_ID])
    REFERENCES [dbo].[RCRA_EM_WASTE] ([EM_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_FED_WASTE_CODE_DESC] CHECK CONSTRAINT [FK_EM_FED_WSTE_CDE_DSC_EM_WSTE]
GO
ALTER TABLE [dbo].[RCRA_EM_STATE_WASTE_CODE_DESC]  WITH CHECK ADD  CONSTRAINT [FK_EM_STTE_WSTE_CDE_DSC_EM_WST] FOREIGN KEY([EM_WASTE_ID])
    REFERENCES [dbo].[RCRA_EM_WASTE] ([EM_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_STATE_WASTE_CODE_DESC] CHECK CONSTRAINT [FK_EM_STTE_WSTE_CDE_DSC_EM_WST]
GO
ALTER TABLE [dbo].[RCRA_EM_TRANSPORTER]  WITH CHECK ADD  CONSTRAINT [FK_EM_TRANSPORTER_EM_EMANIFEST] FOREIGN KEY([EM_EMANIFEST_ID])
    REFERENCES [dbo].[RCRA_EM_EMANIFEST] ([EM_EMANIFEST_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_TRANSPORTER] CHECK CONSTRAINT [FK_EM_TRANSPORTER_EM_EMANIFEST]
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE]  WITH CHECK ADD  CONSTRAINT [FK_EM_WASTE_EM_EMANIFEST] FOREIGN KEY([EM_EMANIFEST_ID])
    REFERENCES [dbo].[RCRA_EM_EMANIFEST] ([EM_EMANIFEST_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE] CHECK CONSTRAINT [FK_EM_WASTE_EM_EMANIFEST]
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_CD_TRANS]  WITH CHECK ADD  CONSTRAINT [FK_EM_WASTE_CD_TRANS_EM_WASTE] FOREIGN KEY([EM_WASTE_ID])
    REFERENCES [dbo].[RCRA_EM_WASTE] ([EM_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_CD_TRANS] CHECK CONSTRAINT [FK_EM_WASTE_CD_TRANS_EM_WASTE]
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_COMMENT]  WITH CHECK ADD  CONSTRAINT [FK_EM_WASTE_COMMENT_EM_WASTE] FOREIGN KEY([EM_WASTE_ID])
    REFERENCES [dbo].[RCRA_EM_WASTE] ([EM_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_COMMENT] CHECK CONSTRAINT [FK_EM_WASTE_COMMENT_EM_WASTE]
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_PCB]  WITH CHECK ADD  CONSTRAINT [FK_EM_WASTE_PCB_EM_WASTE] FOREIGN KEY([EM_WASTE_ID])
    REFERENCES [dbo].[RCRA_EM_WASTE] ([EM_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_EM_WASTE_PCB] CHECK CONSTRAINT [FK_EM_WASTE_PCB_EM_WASTE]
GO
ALTER TABLE [dbo].[RCRA_FA_COST_EST]  WITH CHECK ADD  CONSTRAINT [FK_FA_COST_EST_FA_FAC_SUBM] FOREIGN KEY([FA_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_FA_FAC_SUBM] ([FA_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_FA_COST_EST] CHECK CONSTRAINT [FK_FA_COST_EST_FA_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_FA_COST_EST_REL_MECHANISM]  WITH CHECK ADD  CONSTRAINT [FK_FA_CST_EST_RL_MCH_FA_CST_ES] FOREIGN KEY([FA_COST_EST_ID])
    REFERENCES [dbo].[RCRA_FA_COST_EST] ([FA_COST_EST_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_FA_COST_EST_REL_MECHANISM] CHECK CONSTRAINT [FK_FA_CST_EST_RL_MCH_FA_CST_ES]
GO
ALTER TABLE [dbo].[RCRA_FA_FAC_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_FA_FAC_SUBM_FA_SUBM] FOREIGN KEY([FA_SUBM_ID])
    REFERENCES [dbo].[RCRA_FA_SUBM] ([FA_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_FA_FAC_SUBM] CHECK CONSTRAINT [FK_FA_FAC_SUBM_FA_SUBM]
GO
ALTER TABLE [dbo].[RCRA_FA_MECHANISM]  WITH CHECK ADD  CONSTRAINT [FK_FA_MECHANISM_FA_FAC_SUBM] FOREIGN KEY([FA_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_FA_FAC_SUBM] ([FA_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_FA_MECHANISM] CHECK CONSTRAINT [FK_FA_MECHANISM_FA_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_FA_MECHANISM_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK_FA_MECHNISM_DTIL_FA_MCHNISM] FOREIGN KEY([FA_MECHANISM_ID])
    REFERENCES [dbo].[RCRA_FA_MECHANISM] ([FA_MECHANISM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_FA_MECHANISM_DETAIL] CHECK CONSTRAINT [FK_FA_MECHNISM_DTIL_FA_MCHNISM]
GO
ALTER TABLE [dbo].[RCRA_GIS_FAC_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_GIS_FAC_SUBM_GIS_SUBM] FOREIGN KEY([GIS_SUBM_ID])
    REFERENCES [dbo].[RCRA_GIS_SUBM] ([GIS_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_GIS_FAC_SUBM] CHECK CONSTRAINT [FK_GIS_FAC_SUBM_GIS_SUBM]
GO
ALTER TABLE [dbo].[RCRA_GIS_GEO_INFORMATION]  WITH CHECK ADD  CONSTRAINT [FK_GIS_GO_INFORMTION_GS_FC_SBM] FOREIGN KEY([GIS_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_GIS_FAC_SUBM] ([GIS_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_GIS_GEO_INFORMATION] CHECK CONSTRAINT [FK_GIS_GO_INFORMTION_GS_FC_SBM]
GO
ALTER TABLE [dbo].[RCRA_HD_CERTIFICATION]  WITH CHECK ADD  CONSTRAINT [FK_HD_CERTIFICATION_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_CERTIFICATION] CHECK CONSTRAINT [FK_HD_CERTIFICATION_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_HD_ENV_PERMIT]  WITH CHECK ADD  CONSTRAINT [FK_HD_ENV_PERMIT_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_ENV_PERMIT] CHECK CONSTRAINT [FK_HD_ENV_PERMIT_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_HD_EPISODIC_EVENT_HD_HANDLE] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_EVENT] CHECK CONSTRAINT [FK_HD_EPISODIC_EVENT_HD_HANDLE]
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_PRJT]  WITH CHECK ADD  CONSTRAINT [FK_HD_EPISO_PRJT_HD_EPISO_EVEN] FOREIGN KEY([HD_EPISODIC_EVENT_ID])
    REFERENCES [dbo].[RCRA_HD_EPISODIC_EVENT] ([HD_EPISODIC_EVENT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_PRJT] CHECK CONSTRAINT [FK_HD_EPISO_PRJT_HD_EPISO_EVEN]
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_WASTE]  WITH CHECK ADD  CONSTRAINT [FK_HD_EPISO_WASTE_HD_EPIS_EVEN] FOREIGN KEY([HD_EPISODIC_EVENT_ID])
    REFERENCES [dbo].[RCRA_HD_EPISODIC_EVENT] ([HD_EPISODIC_EVENT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_WASTE] CHECK CONSTRAINT [FK_HD_EPISO_WASTE_HD_EPIS_EVEN]
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_WASTE_CODE]  WITH CHECK ADD  CONSTRAINT [FK_HD_EPIS_WAST_COD_HD_EPI_WAS] FOREIGN KEY([HD_EPISODIC_WASTE_ID])
    REFERENCES [dbo].[RCRA_HD_EPISODIC_WASTE] ([HD_EPISODIC_WASTE_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_EPISODIC_WASTE_CODE] CHECK CONSTRAINT [FK_HD_EPIS_WAST_COD_HD_EPI_WAS]
GO
ALTER TABLE [dbo].[RCRA_HD_HANDLER]  WITH CHECK ADD  CONSTRAINT [FK_HD_HANDLER_HD_HBASIC] FOREIGN KEY([HD_HBASIC_ID])
    REFERENCES [dbo].[RCRA_HD_HBASIC] ([HD_HBASIC_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_HANDLER] CHECK CONSTRAINT [FK_HD_HANDLER_HD_HBASIC]
GO
ALTER TABLE [dbo].[RCRA_HD_HBASIC]  WITH CHECK ADD  CONSTRAINT [FK_HD_HBASIC_HD_SUBM] FOREIGN KEY([HD_SUBM_ID])
    REFERENCES [dbo].[RCRA_HD_SUBM] ([HD_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_HBASIC] CHECK CONSTRAINT [FK_HD_HBASIC_HD_SUBM]
GO
ALTER TABLE [dbo].[RCRA_HD_LQG_CLOSURE]  WITH CHECK ADD  CONSTRAINT [FK_HD_LQG_CLOSURE_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_LQG_CLOSURE] CHECK CONSTRAINT [FK_HD_LQG_CLOSURE_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_HD_LQG_CONSOLIDATION]  WITH CHECK ADD  CONSTRAINT [FK_HD_LQG_CONSOLIDATI_HD_HANDL] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_LQG_CONSOLIDATION] CHECK CONSTRAINT [FK_HD_LQG_CONSOLIDATI_HD_HANDL]
GO
ALTER TABLE [dbo].[RCRA_HD_NAICS]  WITH CHECK ADD  CONSTRAINT [FK_HD_NAICS_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_NAICS] CHECK CONSTRAINT [FK_HD_NAICS_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_HD_OTHER_ID]  WITH CHECK ADD  CONSTRAINT [FK_HD_OTHER_ID_HD_HBASIC] FOREIGN KEY([HD_HBASIC_ID])
    REFERENCES [dbo].[RCRA_HD_HBASIC] ([HD_HBASIC_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_OTHER_ID] CHECK CONSTRAINT [FK_HD_OTHER_ID_HD_HBASIC]
GO
ALTER TABLE [dbo].[RCRA_HD_OWNEROP]  WITH CHECK ADD  CONSTRAINT [FK_HD_OWNEROP_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_OWNEROP] CHECK CONSTRAINT [FK_HD_OWNEROP_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_HD_SEC_MATERIAL_ACTIVITY]  WITH CHECK ADD  CONSTRAINT [FK_HD_SEC_MATER_ACTIV_HD_HANDL] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_SEC_MATERIAL_ACTIVITY] CHECK CONSTRAINT [FK_HD_SEC_MATER_ACTIV_HD_HANDL]
GO
ALTER TABLE [dbo].[RCRA_HD_SEC_WASTE_CODE]  WITH CHECK ADD  CONSTRAINT [FK_HD_SEC_WAS_COD_HD_SEC_MA_AC] FOREIGN KEY([HD_SEC_MATERIAL_ACTIVITY_ID])
    REFERENCES [dbo].[RCRA_HD_SEC_MATERIAL_ACTIVITY] ([HD_SEC_MATERIAL_ACTIVITY_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_SEC_WASTE_CODE] CHECK CONSTRAINT [FK_HD_SEC_WAS_COD_HD_SEC_MA_AC]
GO
ALTER TABLE [dbo].[RCRA_HD_STATE_ACTIVITY]  WITH CHECK ADD  CONSTRAINT [FK_HD_STATE_ACTIVITY_HD_HANDLE] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_STATE_ACTIVITY] CHECK CONSTRAINT [FK_HD_STATE_ACTIVITY_HD_HANDLE]
GO
ALTER TABLE [dbo].[RCRA_HD_UNIVERSAL_WASTE]  WITH CHECK ADD  CONSTRAINT [FK_HD_UNIVERSA_WASTE_HD_HANDLE] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_UNIVERSAL_WASTE] CHECK CONSTRAINT [FK_HD_UNIVERSA_WASTE_HD_HANDLE]
GO
ALTER TABLE [dbo].[RCRA_HD_WASTE_CODE]  WITH CHECK ADD  CONSTRAINT [FK_HD_WASTE_CODE_HD_HANDLER] FOREIGN KEY([HD_HANDLER_ID])
    REFERENCES [dbo].[RCRA_HD_HANDLER] ([HD_HANDLER_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_HD_WASTE_CODE] CHECK CONSTRAINT [FK_HD_WASTE_CODE_HD_HANDLER]
GO
ALTER TABLE [dbo].[RCRA_PRM_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_PRM_EVENT_PRM_SERIES] FOREIGN KEY([PRM_SERIES_ID])
    REFERENCES [dbo].[RCRA_PRM_SERIES] ([PRM_SERIES_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_EVENT] CHECK CONSTRAINT [FK_PRM_EVENT_PRM_SERIES]
GO
ALTER TABLE [dbo].[RCRA_PRM_EVENT_COMMITMENT]  WITH CHECK ADD  CONSTRAINT [FK_PRM_EVNT_COMMITMNT_PRM_EVNT] FOREIGN KEY([PRM_EVENT_ID])
    REFERENCES [dbo].[RCRA_PRM_EVENT] ([PRM_EVENT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_EVENT_COMMITMENT] CHECK CONSTRAINT [FK_PRM_EVNT_COMMITMNT_PRM_EVNT]
GO
ALTER TABLE [dbo].[RCRA_PRM_FAC_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_PRM_FAC_SUBM_PRM_SUBM] FOREIGN KEY([PRM_SUBM_ID])
    REFERENCES [dbo].[RCRA_PRM_SUBM] ([PRM_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_FAC_SUBM] CHECK CONSTRAINT [FK_PRM_FAC_SUBM_PRM_SUBM]
GO
ALTER TABLE [dbo].[RCRA_PRM_MOD_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_PRM_MOD_EVENT_PRM_EVENT] FOREIGN KEY([PRM_EVENT_ID])
    REFERENCES [dbo].[RCRA_PRM_EVENT] ([PRM_EVENT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_MOD_EVENT] CHECK CONSTRAINT [FK_PRM_MOD_EVENT_PRM_EVENT]
GO
ALTER TABLE [dbo].[RCRA_PRM_RELATED_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_PRM_RELTD_EVNT_PRM_UNT_DTIL] FOREIGN KEY([PRM_UNIT_DETAIL_ID])
    REFERENCES [dbo].[RCRA_PRM_UNIT_DETAIL] ([PRM_UNIT_DETAIL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_RELATED_EVENT] CHECK CONSTRAINT [FK_PRM_RELTD_EVNT_PRM_UNT_DTIL]
GO
ALTER TABLE [dbo].[RCRA_PRM_SERIES]  WITH CHECK ADD  CONSTRAINT [FK_PRM_SERIES_PRM_FAC_SUBM] FOREIGN KEY([PRM_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_PRM_FAC_SUBM] ([PRM_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_SERIES] CHECK CONSTRAINT [FK_PRM_SERIES_PRM_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_PRM_UNIT]  WITH CHECK ADD  CONSTRAINT [FK_PRM_UNIT_PRM_FAC_SUBM] FOREIGN KEY([PRM_FAC_SUBM_ID])
    REFERENCES [dbo].[RCRA_PRM_FAC_SUBM] ([PRM_FAC_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_UNIT] CHECK CONSTRAINT [FK_PRM_UNIT_PRM_FAC_SUBM]
GO
ALTER TABLE [dbo].[RCRA_PRM_UNIT_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK_PRM_UNIT_DETAIL_PRM_UNIT] FOREIGN KEY([PRM_UNIT_ID])
    REFERENCES [dbo].[RCRA_PRM_UNIT] ([PRM_UNIT_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_UNIT_DETAIL] CHECK CONSTRAINT [FK_PRM_UNIT_DETAIL_PRM_UNIT]
GO
ALTER TABLE [dbo].[RCRA_PRM_WASTE_CODE]  WITH CHECK ADD  CONSTRAINT [FK_PRM_WASTE_CDE_PRM_UNT_DETIL] FOREIGN KEY([PRM_UNIT_DETAIL_ID])
    REFERENCES [dbo].[RCRA_PRM_UNIT_DETAIL] ([PRM_UNIT_DETAIL_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_PRM_WASTE_CODE] CHECK CONSTRAINT [FK_PRM_WASTE_CDE_PRM_UNT_DETIL]
GO
ALTER TABLE [dbo].[RCRA_RU_REPORT_UNIV]  WITH CHECK ADD  CONSTRAINT [FK_RU_RPRT_UNV_RU_RPRT_UNV_SBM] FOREIGN KEY([RU_REPORT_UNIV_SUBM_ID])
    REFERENCES [dbo].[RCRA_RU_REPORT_UNIV_SUBM] ([RU_REPORT_UNIV_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_RU_REPORT_UNIV] CHECK CONSTRAINT [FK_RU_RPRT_UNV_RU_RPRT_UNV_SBM]
GO
ALTER TABLE [dbo].[RCRA_RU_REPORT_UNIV_SUBM]  WITH CHECK ADD  CONSTRAINT [FK_RU_REPORT_UNIV_SUBM_RU_SUBM] FOREIGN KEY([RU_SUBM_ID])
    REFERENCES [dbo].[RCRA_RU_SUBM] ([RU_SUBM_ID])
    ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RCRA_RU_REPORT_UNIV_SUBM] CHECK CONSTRAINT [FK_RU_REPORT_UNIV_SUBM_RU_SUBM]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Areas for a particluar Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'CA_AREA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Areas for a particluar Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'CA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used for administrative purposes to uniquely designate a group of units (or a single unit) with a common history and projection of corrective action requirements. (AreaSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'AREA_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the corrective action applies to the entire facility. (FacilityWideIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'FAC_WIDE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the Corrective Action area. (AreaName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'AREA_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that there has been a release to air (either within or beyond the facility boundary) from the unit/area. This may include releases of subsurface gas. (AirReleaseIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'AIR_REL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that there has been a release to groundwater from the unit/area. (GroundwaterReleaseIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'GROUNDWATER_REL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that there has been a release to soil (either within or beyond the facility boundary) from the unit/area. This may include subsoil contamination beneath the unit/area. (SoilReleaseIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'SOIL_REL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that there has been a release to surface water (either within or beyond the facility boundary) from the unit/area. (SurfaceWaterReleaseIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'SURFACE_WATER_REL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the corrective action applies to a regulated unit. (RegulatedUnitIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'REGULATED_UNIT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (EPAResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'EPA_RESP_PERSON_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The person currently responsible for the permit at the EPA level. (EPAResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'EPA_RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (StateResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'STA_RESP_PERSON_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The state person currently responsible for overseeing the corrective action area. (StateResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'STA_RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (ACreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'A_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionAreaDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Areas and Events or Authorities and Events (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CA_AREA_REL_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Areas and Events or Authorities and Events (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CA_AREA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the corrective action event. (CorrectiveActionEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code which corresponds to a specific event or event type. The first two characters indicate the event category and the last three characters the numeric event number. (CorrectiveActionEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the event. (EventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify multiple occurrences of a corrective action event. (EventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionAreaRelatedEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AREA_REL_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Areas and Events or Authorities and Events (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CA_AUTH_REL_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Areas and Events or Authorities and Events (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CA_AUTHORITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the corrective action event. (CorrectiveActionEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code which corresponds to a specific event or event type. The first two characters indicate the event category and the last three characters the numeric event number. (CorrectiveActionEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the event. (EventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify multiple occurrences of a corrective action event. (EventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionAuthorityRelatedEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTH_REL_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Authorities for a particluar Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'CA_AUTHORITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Authorities for a particluar Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'CA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the authority. (AuthorityDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code used to indicate whether a permit, administrative order, or other authority has been issued to implement the corrective action process. (AuthorityTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the Authority. (AuthorityAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date that the authority became effective. (AuthorityEffectiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_EFFC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the authorized agency official signs the order, permit, or permit modification. (IssueDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'ISSUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date when the corrective action authority is revoked or ended. (EndDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The action by which the Director requires the owner/operator to establish and maintain an information repository at a location near the facility for the purpose of making accessible to interested parties documents, reports, and other public information relevant to public understanding of the activities, findings, and plans for such corrective action initiatives. (EstablishedRepositoryCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'ESTABLISHED_REPOSITORY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the program in which the organization establishes the applicable guidance that the authority should be issued. (ResponsibleLeadProgramIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'RESP_LEAD_PROG_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Authority responsible suborganization owner. (AuthoritySuborganizationDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_SUBORG_DATA_OWNR_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Authority responsible suborganization. (AuthoritySuborganizationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'AUTHORITY_SUBORG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (ResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation or who is the responsible Authority. (ResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (ACreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'A_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionAuthorityDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_AUTHORITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Events for a particluar Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'CA_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A list of Correction Action Events for a particluar Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'CA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the corrective action event. (CorrectiveActionEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code which corresponds to a specific event or event type. The first two characters indicate the event category and the last three characters the numeric event number. (CorrectiveActionEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the event. (EventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify multiple occurrences of a corrective action event. (EventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date on which actual completion of an event occurs. (ActualDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'ACTL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The original scheduled completion date for an event. This date cannot be changed once entered. Slippage of the scheduled completion date is recorded in the NewScheduleDate Data Element. (OriginalScheduleDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'ORIGINAL_SCHEDULE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Revised scheduled completion date of the event. This date is used in conjunction with the Original Scheduled Event Date to allow tracking scheduled date slippage. As the scheduled date changes, this field is updated with the new date and the Original Scheduled Event Date is not changed. (NewScheduleDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_SCHEDULE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Event responsible suborganization owner. (EventSuborganizationDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SUBORG_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Event responsible suborganization. (EventSuborganizationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SUBORG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (ResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation or who is the responsible Authority. (ResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Public notes providing more information. (PublicSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'PUBLIC_SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (ACreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'A_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'CA_EVENT_COMMITMENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'CA_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (CommitmentLead)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'COMMIT_LEAD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (CommitmentSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'COMMIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EventEventCommitmentDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_EVENT_COMMITMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant Corrective Action Data for a given Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'CA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant Corrective Action Data for a given Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'CA_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_FAC_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A permitted unit related to a corrective action area. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_REL_PERMIT_UNIT', @level2type=N'COLUMN',@level2name=N'CA_REL_PERMIT_UNIT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: A permitted unit related to a corrective action area. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_REL_PERMIT_UNIT', @level2type=N'COLUMN',@level2name=N'CA_AREA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_REL_PERMIT_UNIT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a process unit. (PermitUnitSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_REL_PERMIT_UNIT', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionRelatedPermitUnitDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_REL_PERMIT_UNIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Authorities and Statutory Citations (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION', @level2type=N'COLUMN',@level2name=N'CA_STATUTORY_CITATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Corrective Action Authorities and Statutory Citations (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION', @level2type=N'COLUMN',@level2name=N'CA_AUTHORITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orgnaization responsible for the Statutory Citation (use two-digit postal code) (StatutoryCitationDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION', @level2type=N'COLUMN',@level2name=N'STATUTORY_CITTION_DTA_OWNR_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifier that identifies the statutory authority under which the corrective action event occured (StatutoryCitationIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION', @level2type=N'COLUMN',@level2name=N'STATUTORY_CITATION_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CorrectiveActionStatutoryCitationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_STATUTORY_CITATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWasteCorrectiveActionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CA_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Citation Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CME_CITATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Citation Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CME_VIOL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Citation Data (CitationNameSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CITATION_NAME_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The citation(s) of the violations alleged (CME) or of the Authority used (CA). (CitationName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CITATION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State postal code (CitationNameOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CITATION_NAME_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Existing nationally defined values: FR, FS, OC, PC,SR,SS,V3 (CitationNameType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'CITATION_NAME_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Citation Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CitationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CITATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Significant Non-Complier Date Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CSNY_DATE', @level2type=N'COLUMN',@level2name=N'CME_CSNY_DATE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Significant Non-Complier Date Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CSNY_DATE', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CSNY_DATE', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of the SNY that the Action is Addressing (SNYDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CSNY_DATE', @level2type=N'COLUMN',@level2name=N'SNY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CSNYDateDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_CSNY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The U.S.Postal Service alphabetic code that represents the U.S.State or territory in which a state or local government enforcement agency operates. (EnforcementAgencyLocationName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_AGN_LOC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The unique alphanumeric identifier used in the applicable database to identify a specific enforcement action pertaining to a regulated entity or facility. (EnforcementActionIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_ACT_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calendar date the enforcement action was issued or filed. (EnforcementActionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_ACT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The full name of the agency, department, or organization that submitted the enforcement action data to EPA. (EnforcementAgencyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_AGN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes the relevant docket number which enforcement staff have assigned for tracking of enforcement actions. (EnforcementDocketNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_DOCKET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies the attorney within the agency responsible for issuing the enforcement action. (EnforcementAttorney)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_ATTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (CorrectiveActionComponent)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'CORCT_ACT_COMPT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (ConsentAgreementFinalOrderSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'CNST_AGMT_FINAL_ORDER_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (AppealInitiatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'APPEAL_INIT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (AppealResolutionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'APPEAL_RSLN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (DispositionStatusDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'DISP_STAT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (DispositionStatusOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'DISP_STAT_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (DispositionStatus)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'DISP_STAT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State Postal Code (EnforcementOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'A code that identifies the type of action being taken against a handler. (EnforcementType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (EnforcementResponsiblePersonOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_RESP_PERSON_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the enforcement. (EnforcementResponsiblePersonIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_RESP_PERSON_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (EnforcementResponsibleSuborganizationOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_RESP_SUBORG_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (EnforcementResponsibleSuborganization)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'ENFRC_RESP_SUBORG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (CCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'C_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (FinancialAssuranceReq)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT', @level2type=N'COLUMN',@level2name=N'FA_REQUIRED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EnforcementActionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The U.S.Postal Service alphabetic code that represents the U.S.State or territory in which a state or local government enforcement agency operates. (EnforcementAgencyLocationName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'ENFRC_AGN_LOC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The unique alphanumeric identifier used in the applicable database to identify a specific enforcement action pertaining to a regulated entity or facility. (EnforcementActionIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'ENFRC_ACT_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calendar date the enforcement action was issued or filed. (EnforcementActionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'ENFRC_ACT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The full name of the agency, department, or organization that submitted the enforcement action data to EPA. (EnforcementAgencyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'ENFRC_AGN_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element with delete information: EnforcementActionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_ENFRC_ACT_DEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'CME_EVAL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the EPA handler. (EvaluationActivityLocation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_ACT_LOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name or number assigned by the implementing agency to identify an evaluation. (EvaluationIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The first day of the inspection or record review regardless of the duration of the inspection. (EvaluationStartDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the agency responsible for conducting the evaluation. (EvaluationResponsibleAgency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_AGN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date fo the Last Non-Followup Evaluation (Applies to SNY/SNN Evaluations Only) (DayZero)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'DAY_ZERO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if a violation was found. (FoundViolation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'FOUND_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The inspection or record review was initiated because of a tip/complaint (CitizenComplaintIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'CTZN_CPLT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (MultimediaIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'MULTIMEDIA_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (SamplingIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'SAMPL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The inspection conducted pursuant to RCRA 3007 or State equivalent; determiniation made: sit is Non-Hazardous Waste. (NotSubtitleCIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'NOT_SUBTL_C_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the type of evaluation. (EvaluationTypeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_TYPE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code to report the type of evaluation conducted at the handler. (EvaluationType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (FocusAreaOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'FOCUS_AREA_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (FocusArea)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'FOCUS_AREA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (EvaluationResponsiblePersonIdentifierOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_PERSON_IDEN_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation. (EvaluationResponsiblePersonIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_PERSON_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the suborganization identifier. (EvaluationResponsibleSuborganizationOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_SUBORG_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the branch/district within the agency responsible for conducting the evaluation. (EvaluationResponsibleSuborganization)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_SUBORG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NOC Date. (NOCDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'NOC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (CCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'C_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EvaluationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Evaluation. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT', @level2type=N'COLUMN',@level2name=N'CME_EVAL_COMMIT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Evaluation. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT', @level2type=N'COLUMN',@level2name=N'CME_EVAL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Evaluation. (CommitmentLead)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT', @level2type=N'COLUMN',@level2name=N'COMMIT_LEAD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Evaluation. (CommitmentSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT', @level2type=N'COLUMN',@level2name=N'COMMIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EvaluationCommitmentDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_COMMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'CME_EVAL_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the EPA handler. (EvaluationActivityLocation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'EVAL_ACT_LOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name or number assigned by the implementing agency to identify an evaluation. (EvaluationIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'EVAL_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The first day of the inspection or record review regardless of the duration of the inspection. (EvaluationStartDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'EVAL_START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the agency responsible for conducting the evaluation. (EvaluationResponsibleAgency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'EVAL_RESP_AGN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Evaluation Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element with delete information: EvaluationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_DEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Evaluation and Violation (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'CME_EVAL_VIOL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Evaluation and Violation (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'CME_EVAL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Evaluation and Violation (ViolationActivityLocation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_ACT_LOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Evaluation and Violation (ViolationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Evaluation and Violation (AgencyWhichDeterminedViolation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL', @level2type=N'COLUMN',@level2name=N'AGN_WHICH_DTRM_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EvaluationViolationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_EVAL_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This contains Hbasic Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This contains Hbasic Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'CME_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number that uniquely identifies the EPA handler. (EPAHandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'EPA_HDLR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CMEFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This contains Hbasic Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM_DEL', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This contains Hbasic Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM_DEL', @level2type=N'COLUMN',@level2name=N'CME_SUBM_DEL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number that uniquely identifies the EPA handler. (EPAHandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM_DEL', @level2type=N'COLUMN',@level2name=N'EPA_HDLR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element with delete information: CMEFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_FAC_SUBM_DEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enfocement Multimedia Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'CME_MEDIA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enfocement Multimedia Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the multimedia code. (MultimediaCodeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'MULTIMEDIA_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code which indicates the medium or program other than RCRA participating in the enforcement action. (MultimediaCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'MULTIMEDIA_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enfocement Multimedia Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: MediaDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MEDIA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'CME_MILESTONE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (MilestoneSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'MILESTONE_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (TechnicalRequirementIdentifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'TECH_RQMT_IDEN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (TechnicalRequirementDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'TECH_RQMT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (MilestoneScheduledCompletionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'MILESTONE_SCHD_COMP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (MilestoneActualCompletionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'MILESTONE_ACTL_COMP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (MilestoneDefaultedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'MILESTONE_DFLT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Milestone Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: MilestoneDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_MILESTONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Penalty Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'CME_PNLTY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Penalty Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the penalty type (PenaltyTypeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'PNLTY_TYPE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code which indicates the type of penalty associated with the penalty amount. (PenaltyType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'PNLTY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The dollar amount of any proposed cash civil penalty set forth in a Complaint/Proposed Order. (CashCivilPenaltySoughtAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'CASH_CIVIL_PNLTY_SOUGHT_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Penalty Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PenaltyDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PNLTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'CME_PYMT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'CME_PNLTY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (PaymentSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'PYMT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (PaymentDefaultedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'PYMT_DFLT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (ScheduledPaymentDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'SCHD_PYMT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (ScheduledPaymentAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'SCHD_PYMT_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (ActualPaymentDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'ACTL_PYMT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The dollar amount of any cost recovery required to be paid pursuant to a Final Order. (ActualPaidAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'ACTL_PAID_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Payment Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PaymentDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_PYMT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'CME_RQST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'CME_EVAL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (RequestSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'RQST_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (DateOfRequest)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'DATE_OF_RQST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (DateResponseReceived)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'DATE_RESP_RCVD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (RequestAgency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'RQST_AGN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Request Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: RequestDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_RQST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWasteCMESubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element with delete information: HazardousWasteCMESubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUBM_DEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Supplemental Environmental Project Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'CME_SUPP_ENVR_PRJT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Supplemental Environmental Project Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SEP Sequence Number allowed value 01-99 (SEPSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Expenditure Amount (SEPExpenditureAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_EXPND_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valid date greater than or equal to the Date of Enforcement Action. (SEPScheduledCompletionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_SCHD_COMP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SEP actual completion date (SEPActualDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_ACTL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the SEP defaulted (SEPDefaultedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_DFLT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State postal code (SEPCodeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The narrative text describing any Supplemental Environmental Projects required to be performed pursuant to a Final Order. (SEPDescriptionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'SEP_DESC_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Supplemental Environmental Project Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: SupplementalEnvironmentalProjectDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_SUPP_ENVR_PRJT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'CME_VIOL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'CME_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (ViolationActivityLocation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_ACT_LOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (ViolationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (AgencyWhichDeterminedViolation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'AGN_WHICH_DTRM_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allowed value HQ (ViolationTypeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_TYPE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Violation Type (ViolationType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (FormerCitationName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'FORMER_CITATION_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calendar date the Responsible Authority determines that a regulated entity is in violation of a legally enforceable obligation. (ViolationDeterminedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_DTRM_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calendar date, determined by the Responsible Authority, on which the regulated entity actually returned to compliance with respect to the legal obligation that is the subject of the Violation Determined Date. (ReturnComplianceActualDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'RTN_COMPL_ACTL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (ReturnToComplianceQualifier)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'RTN_TO_COMPL_QUAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (ViolationResponsibleAgency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'VIOL_RESP_AGN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Compliance Monitoring and Enforcement Violation Data (Notes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (CCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'C_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ViolationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Violation and Enforcement (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'CME_VIOL_ENFRC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Violation and Enforcement (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'CME_ENFRC_ACT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Violation and Enforcement (ViolationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'VIOL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Violation and Enforcement (AgencyWhichDeterminedViolation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'AGN_WHICH_DTRM_VIOL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calendar date, specified in the Compliance Schedule (if any), on which the regulated entity is scheduled to return to compliance with respect to the legal obligation that is the subject of the Violation Determined Date. (ReturnComplianceScheduledDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC', @level2type=N'COLUMN',@level2name=N'RTN_COMPL_SCHD_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ViolationEnforcementDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_CME_VIOL_ENFRC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Created date (CreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Updated date (UpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'UPDATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest tracking number (ManifestTrackingNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'MAN_TRACKING_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest status (Status)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Import indicator (Import)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'IMPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Submission type (SubmissionType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'SUBM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator modified (GeneratorModified)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MODIFIED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Original type (OriginType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ORIGIN_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Shipped date (ShippedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'SHIPPED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Received date (ReceivedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'RECEIVED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Certified date (CertifiedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'CERT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rejection indicator (Rejection)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'REJ_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac registered (DesFacRegistered)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_REGISTERED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac modified (DesFacModified)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MODIFIED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicate residue information (Residue)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'RESIDUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates if transporter is on site (TransporterOnSite)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ON_SITE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact first name (GeneratorContactFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact last name (GeneratorContactLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator registered (GeneratorRegistered)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_REGISTERED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rejection type (RejectionType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'REJECTION_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alternate designated facility type (AlternateDesignatedFacilityType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALTERNATE_DESIGNATED_FAC_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator name (GeneratorName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac signature date (DesFacSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator esig signature date (GeneratorEsigSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_ESIG_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location street 1 (DesFacLocationStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail street 2 (AltFacMailStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact first name (DesFacContactFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact last name (DesFacContactLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location street 2 (GeneratorLocationStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact email (GeneratorContactEmail)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail street 1 (DesFacMailStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Port of entry city (PortOfEntryCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'PORT_OF_ENTRY_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail zip code (GeneratorMailZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail street 2 (DesFacMailStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail state (GeneratorMailState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator country name (ForeignGeneratorCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_CTRY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail country (GeneratorMailCountry)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_CTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail street 1 (GeneratorMailStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail street 2 (GeneratorMailStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest handling instruction (ManifestHandlingInstr)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'MANIFEST_HANDLING_INSTR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is public indicator (COIOnly)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'COI_ONLY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator Id (GeneratorId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator signature date (GeneratorSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location street 2 (DesFacLocationStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail street 1 (AltFacMailStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator esig first name (GeneratorEsigFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_ESIG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator esig last name (GeneratorEsigLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_ESIG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location street 1 (GeneratorLocationStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail street number (GeneratorMailStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator mail city (GeneratorMailCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location street number (GeneratorLocationStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location city (GeneratorLocationCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location state (GeneratorLocationState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator location zip code (GeneratorLocationZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_LOC_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact phone number (GeneratorContactPhoneNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_PHONE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact phone extension (GeneratorContactPhoneExt)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator contact company name (GeneratorContactCompanyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_CONTACT_COMPANY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Emergency phone number (EmergencyPhoneNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'EMERGENCY_PHONE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Emergency phone extension (EmergencyPhoneExt)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'EMERGENCY_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Generator printed name (GeneratorPrintedName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'GENERATOR_PRINTED_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Des facility Id (DesFacilityId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Des facility name (DesFacilityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail street number (DesFacMailStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail city (DesFacMailCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail country (DesFacMailCountry)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_CTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail state (DesFacMailState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac mail zip code (DesFacMailZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location street number (DesFacLocationStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location city (DesFacLocationCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location state (DesFacLocationState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac location zip code (DesFacLocationZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_LOC_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact phone number (DesFacContactPhoneNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_PHONE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact phone extension (DesFacContactPhoneExt)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact email (DesFacContactEmail)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac contact company name (DesFacContactCompanyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_CONTACT_COMPANY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac printed name (DesFacPrintedName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_PRINTED_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac esig first name (DesFacEsigFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_ESIG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac esig last name (DesFacEsigLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_ESIG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DesFac esig signature date (DesFacEsigSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'DES_FAC_ESIG_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orig submission type (OrigSubmissionType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ORIG_SUBM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Broker id (BrokerId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'BROKER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last EM record cahnged date (LastEMUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'LAST_EM_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac printed name (AltFacPrintedName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_PRINTED_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac signature date (AltFacSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Esig first name (AltFacEsigFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_ESIG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Esig last name (AltFacEsigLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_ESIG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Esiog signature date (AltFacEsigSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_ESIG_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac id (AltFacilityId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac name (AltFacilityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail street no (AltFacMailStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail city (AltFacMailCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail state (AltFacMailState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac mail zip (AltFacMailZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location street no (AltFacLocationStreetNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_STREET_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location street 1 (AltFacLocationStreet1)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_STREET_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location street 2 (AltFacLocationStreet2)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_STREET_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location city (AltFacLocationCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location state (AltFacLocationState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Location zip (AltFacLocationZip)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_LOC_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact first name (AltFacContactFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact last name (AltFacContactLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact phone number (AltFacContactPhoneNo)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_PHONE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact phone ext (AltFacContactPhoneExt)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact email (AltFacContactEmail)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Contact Company Name (AltFacContactCompanyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_CONTACT_COMPANY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Registered indicator (AltFacRegistered)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_REGISTERED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alt Fac Modified indicator (AltFacModified)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'ALT_FAC_MODIFIED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator name (ForeignGeneratorName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator street (ForeignGeneratorStreet)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_STREET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator city (ForeignGeneratorCity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator country code (ForeignGeneratorCountryCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_CTRY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator postal code (ForeignGeneratorPostalCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_POST_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Foreign generator province (ForeignGeneratorProvince)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'FOREIGN_GENERATOR_PROVINCE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Port of entry state (PortOfEntryState)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST', @level2type=N'COLUMN',@level2name=N'PORT_OF_ENTRY_STA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: Emanifests' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Additional omment (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST_COMMENT', @level2type=N'COLUMN',@level2name=N'EM_EMANIFEST_COMMENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Additional omment (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST_COMMENT', @level2type=N'COLUMN',@level2name=N'EM_EMANIFEST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comment label (CommentLabel)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST_COMMENT', @level2type=N'COLUMN',@level2name=N'CMNT_LABEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comment description (CommentDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST_COMMENT', @level2type=N'COLUMN',@level2name=N'CMNT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EmanifestsAdditionalComment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_EMANIFEST_COMMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'EM_FED_WASTE_CODE_DESC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Fed manifest waste code information (FedManifestWasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'FED_MANIFEST_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest waste description information (ManifestWasteDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'MANIFEST_WASTE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COI indicator. (COIIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'COI_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: FedManifestWasteCodeDescription' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_FED_WASTE_CODE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_STATE_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'EM_STATE_WASTE_CODE_DESC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_STATE_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State manifest waste code information (StateManifestWasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_STATE_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'STA_MANIFEST_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest waste description information (ManifestWasteDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_STATE_WASTE_CODE_DESC', @level2type=N'COLUMN',@level2name=N'MANIFEST_WASTE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: StateManifestWasteCodeDescription' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_STATE_WASTE_CODE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWasteEmanifestsDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Transporter list (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'EM_TRANSPORTER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Transporter list (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'EM_EMANIFEST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Id. (TransporterId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Name. (TransporterName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Printed Name. (TransporterPrintedName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_PRINTED_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Signature Date. (TransporterSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Esig First Name. (TransporterEsigFirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ESIG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Esig Last Name. (TransporterEsigLastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ESIG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Esig Signature Date. (TransEsigSignatureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANS_ESIG_SIGNATURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transporter Line Number. (TransporterLineNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_LINE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Registered indicator. (TransporterRegistered)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_REGISTERED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ManifestTransporter' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_TRANSPORTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'EM_EMANIFEST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hazardous indicator. (DotHazardous)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'DOT_HAZRD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste description. (NonHazWasteDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'NON_HAZ_WASTE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicate waste quantity (QuantityDiscrepancy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_DISCREPANCY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PCB indicator. (Pcb)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'PCB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Line number. (LineNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'LINE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste minimization description information (BrMixedRadioactiveWaste)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_MIXED_RADIOACTIVE_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Printed DOT information (DotPrintedInformation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'DOT_PRINTED_INFO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Container number information (ContainerNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'CONTAINER_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity Valure information (QuantityVal)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_VAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qty unit of measure code. (QtyUnitOfMeasureCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QTY_UNIT_OF_MEAS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qty unit of measure description information. (QtyUnitOfMeasureDesc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QTY_UNIT_OF_MEAS_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR density information (BrDensity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_DENSITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR density unit of measurement code (BrDensityUOMCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_DENSITY_UOM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR density unit of measurement description (BrDensityUOMDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_DENSITY_UOM_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR form code information (BrFormCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_FORM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR form code description (BrFormCodeDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_FORM_CODE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR source code information (BrSourceCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_SRC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BR source code information (BrSourceCodeDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_SRC_CODE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste minimization code information (BrWasteMinCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_WASTE_MIN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste minimization description information (BrWasteMinDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'BR_WASTE_MIN_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicate if it''s a waste (EpaWaste)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'EPA_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicate waste type (WasteTypeDiscrepancy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'WASTE_TYPE_DISCREPANCY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Residue comments information (WasteResidueComments)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'WASTE_RESIDUE_COMM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicate residue information (WasteResidue)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'WASTE_RESIDUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Management method code information (ManagementMethodCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'MANAGEMENT_METH_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Management method description information (ManagementMethodDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'MANAGEMENT_METH_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies a handling instructions (HandlingInstructions)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'HANDLING_INSTRUCTIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id number information (DotIdNumberDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'DOT_ID_NUM_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Container type code. (ContainerTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'CONTAINER_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Container type description information. (ContainerTypeDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'CONTAINER_TYPE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Discrepancy comments information (DiscrepancyComments)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'DISCREPANCY_COMM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies a consent number (ConsentNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'CNST_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is public indicator (COIOnly)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'COI_ONLY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity acute kg information (QuantityAcuteKg)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_ACUTE_KG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity acute tons information (QuantityAcuteTons)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_ACUTE_TONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity kg information (QuantityKg)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_KG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity non acute kg information (QuantityNonAcuteKg)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_NON_ACUTE_KG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity non acute tons information (QuantityNonAcuteTons)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_NON_ACUTE_TONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity tons information (QuantityTons)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE', @level2type=N'COLUMN',@level2name=N'QNTY_TONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ManifestWaste' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_CD_TRANS', @level2type=N'COLUMN',@level2name=N'EM_WASTE_CD_TRANS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_CD_TRANS', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Wastes information (WasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_CD_TRANS', @level2type=N'COLUMN',@level2name=N'WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: TxWasteCode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_CD_TRANS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Additional omment (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_COMMENT', @level2type=N'COLUMN',@level2name=N'EM_WASTE_COMMENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Additional omment (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_COMMENT', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comment label (CommentLabel)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_COMMENT', @level2type=N'COLUMN',@level2name=N'CMNT_LABEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comment description (CommentDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_COMMENT', @level2type=N'COLUMN',@level2name=N'CMNT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: WasteAdditionalComment' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_COMMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: PCB information. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'EM_WASTE_PCB_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: PCB information. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'EM_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Load type information (LoadTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_LOAD_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Article container Id (ArticleContainerId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_ARTICLE_CONT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of removal (DateOfRemoval)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_REMOVAL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Weight information (Weight)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_WEIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste type information (WasteType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_WASTE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bulk identity information (BulkIdentity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'PCB_BULK_IDENTITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Load type description (LoadTypeDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB', @level2type=N'COLUMN',@level2name=N'LOAD_TYPE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PcbInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_EM_WASTE_PCB'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Estimates of the Financial liability costs associated with a given Handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'FA_COST_EST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Estimates of the Financial liability costs associated with a given Handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'FA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates what type of Financial Assurance is Required. (CostEstimateTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the agency responsible for overseeing the review of the cost estimate. (CostEstimateAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique number that identifies the cost estimate. (CostEstimateSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (ResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation or who is the responsible Authority. (ResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The dollar amount of the cost estimate for a given financial assurance type. (CostEstimateAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date when the cost estimate for a given financial assurance type was submitted, adjusted, approved, or required to be in place. (CostEstimateDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The reason the cost estimate for a financial assurance type is being reported. (CostEstimateReasonCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'COST_ESTIMATE_RSN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding the corrective action area or permit unit that this cost estimate applies. (AreaUnitNotesText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'AREA_UNIT_NOTES_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (FCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'F_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The update due date. (UpdateDueDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'UPDATE_DUE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is current cost estimate. (CurrentCostEstimateIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'CURRENT_COST_ESTIMATE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CostEstimateDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Cost Estimates and Related Mechanisms (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'FA_COST_EST_REL_MECHANISM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Cost Estimates and Related Mechanisms (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'FA_COST_EST_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The agency responsible for overseeing the review of the mechanism. (MechanismAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique numerical identier for the mechanism. (MechanismSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique numerical code identifying the mechanism detail. (MechanismDetailSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_DETAIL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CostEstimateRelatedMechanismDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_COST_EST_REL_MECHANISM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant Financial Assurance Data for a given Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'FA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant Financial Assurance Data for a given Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'FA_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: FinancialAssuranceFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_FAC_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mechanisms used to address cost estimates of the Financial liability associated with a given Handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'FA_MECHANISM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mechanisms used to address cost estimates of the Financial liability associated with a given Handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'FA_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The agency responsible for overseeing the review of the mechanism. (MechanismAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique numerical identier for the mechanism. (MechanismSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defined the mechanism type. (MechanismTypeDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_TYPE_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The type of mechanism that addresses the cost estimate. (MechanismTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'MECHANISM_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The name of the financial institution with which the financial assurance mechanism is held, such as a bank (letter of credit) or a surety (surety bond); also identifies a facility (financial test), or a guarantor (corporate guarantee). (ProviderText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'PROVIDER_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact Name of the provider. (ProviderFullContactName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'PROVIDER_FULL_CONTACT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'TELE_NUM_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (FCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'F_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The contact email address of the provider. (ProviderContactEmail)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'PROVIDER_CONTACT_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is active mechanism. (ActiveMechanismIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'ACTIVE_MECHANISM_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: MechanismDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Details of the mechanism used to address cost estimates of the Financial liability associated with a given Handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'FA_MECHANISM_DETAIL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Details of the mechanism used to address cost estimates of the Financial liability associated with a given Handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'FA_MECHANISM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique numerical code identifying the mechanism detail. (MechanismDetailSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'MECHANISM_DETAIL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number assigned to the mechanism, such as a bond number or insurance policy number. (MechanismIdentificationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'MECHANISM_IDEN_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The total dollar value of the financial assurance mechanism. (FaceValueAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'FACE_VAL_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Effective Date of the action: 1. Hazardous Secondary Material notification in Handler, 2. Corrective Action Authority, 3. Financial Assurance Mechanism. (EffectiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'EFFC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date the instrument terminates, such as the end of the term of an insurance policy. (ExpirationDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'EXPIRATION_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates if the machamism detail is current. Possible values are: Y/N (CurrentMechanismDetailIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'CURRENT_MECHANISM_DETAIL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (FCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'F_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The total dollar value of facility financial assurance mechanism. (FacilityFaceValueAmount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'FAC_FACE_VAL_AMOUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is alternative. (AlternativeIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'ALT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: MechanismDetailDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_MECHANISM_DETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: FinancialAssuranceSubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_FA_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant GIS Data for a given Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'GIS_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Supplies all of the relevant GIS Data for a given Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'GIS_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: GISFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_FAC_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Used to define the geographic coordinates of the Handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GIS_GEO_INFORMATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Used to define the geographic coordinates of the Handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GIS_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner of Geographic Information. Should match state code (i.e. KS). (GeographicInformationOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEO_INFO_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique identifier for the geographic information. (GeographicInformationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEO_INFO_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a process unit. (PermitUnitSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used for administrative purposes to uniquely designate a group of units (or a single unit) with a common history and projection of corrective action requirements. (AreaSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'AREA_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The text that provides additional informaiton about the geographic coordinates. (LocationCommentsText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'LOC_COMM_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (GCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'G_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number of acres associated with the handler or area. (AreaAcreageMeasure)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'AREA_ACREAGE_MEAS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defined the AreaMeasureSource. (AreaMeasureSourceDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'AREA_MEAS_SRC_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The source of information used to determine the number of acres associated with the handler or area. (AreaMeasureSourceCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'AREA_MEAS_SRC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date acreage information for the handler or area was collected. (AreaMeasureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'AREA_MEAS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The calender date when data were collected (DataCollectionDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'DATA_COLL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The horizontal measure, in meters, of the relative accuracy of the latitude and longitude coordinates. (HorizontalAccuracyMeasure)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'HORZ_ACC_MEAS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number that represents the proportional distance on the ground for one unit of measure on the map or photo. (SourceMapScaleNumeric)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'SRC_MAP_SCALE_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (CoordinateDataSourceDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'COORD_DATA_SRC_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the party responsible for proiding the latitude and longitude coordinates. (CoordinateDataSourceCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'COORD_DATA_SRC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (GeographicReferencePointDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEO_REF_PT_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the place for which the geographic codes were established (GeographicReferencePointCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEO_REF_PT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (GeometricTypeDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEOM_TYPE_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the geometric entity represented by one point or a sequence of points (GeometricTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'GEOM_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (HorizontalCollectionMethodDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'HORZ_COLL_METH_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the method used to deterimine the latitude and longitude coordinates for a point on the earth. (HorizontalCollectionMethodCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'HORZ_COLL_METH_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (HorizontalCoordinateReferenceSystemDatumDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'HRZ_CRD_RF_SYS_DTM_DTA_OWN_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the datum used in determining latitude and longitude coordinates (HorizontalCoordinateReferenceSystemDatumCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'HORZ_COORD_REF_SYS_DATUM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The owner of the code. If provided, it should be HQ. (VerificationMethodDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'VERF_METH_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The code that represents the process used to verify the latitude and longitude coordinates. (VerificationMethodCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'VERF_METH_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Geometry property element of a GeoRSS GML instance (Latitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'LATITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Geometry property element of a GeoRSS GML instance (Longitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'LONGITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Geometry property element of a GeoRSS GML instance (Elevation)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION', @level2type=N'COLUMN',@level2name=N'ELEVATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: GeographicInformationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_GEO_INFORMATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: GeographicInformationSubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_GIS_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Certification information for the person who certified report to the authorizing agency. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'HD_CERTIFICATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Certification information for the person who certified report to the authorizing agency. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence number for each certification for the handler. (CertificationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date on which the handler information was certified by the reporting site. (SignedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_SIGNED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'First name of a person. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Middle initial of a person. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_MIDDLE_INITIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last name of a person. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (CertificationEmailText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION', @level2type=N'COLUMN',@level2name=N'CERT_EMAIL_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: CertificationDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_CERTIFICATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Information about environmental permits issued to the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'HD_ENV_PERMIT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Information about environmental permits issued to the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification number of an effective environmental permit issued to the handler, or the number of a filed application for which an environmental permit has not yet been issued. (EnvironmentalPermitID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'ENV_PERMIT_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the other permit type. (EnvironmentalPermitOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'ENV_PERMIT_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the environmental program and/or jurisdictional authority under which an environmental permit was issued to the facility, or under which an application has been filed for which a permit has not yet been issued. This data element is applicable to TSD facilities only. (EnvironmentalPermitTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'ENV_PERMIT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description of any permit type indicated as O (Other) in the Permit Type field. (EnvironmentalPermitDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT', @level2type=N'COLUMN',@level2name=N'ENV_PERMIT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EnvironmentalPermitDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_ENV_PERMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner of the episodic event. (EpisodicEventOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of the episodic event. (EpisodicEventType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Episodic event start event. (EpisodicEventStartDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Episodic event end date. (EpisodicEventEndDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_MIDDLE_INITIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (OrganizationFormalName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_ORG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (EmailAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_EMAIL_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone number extension (PhoneExtensionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax number (FaxNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT', @level2type=N'COLUMN',@level2name=N'CONTACT_FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HandlerEpisodicEvent' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Episodic project of the Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_PRJT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Episodic project of the Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Project code owner of the episodic project. (EpisodicProjectCodeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'PRJT_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Project code of the episodic project. (EpisodicProjectCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'PRJT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Other project description. (OtherProjectDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT', @level2type=N'COLUMN',@level2name=N'OTHER_PRJT_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EpisodicProjectDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_PRJT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Episodic waste of the Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Episodic waste of the Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique number that identifies the episodic waste. (EpisodicWasteSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'SEQ_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Waste description. (WasteDescription)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'WASTE_DESC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The quantity of waste that is handled by each process code. This element pertains only to Part A submissions. (EstimatedQuantity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE', @level2type=N'COLUMN',@level2name=N'EST_QNTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EpisodicWaste' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_WASTE_CODE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_EPISODIC_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that owns the data record. (WasteCodeOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to describe hazardous waste. (WasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing the Waste Code(Data publishing only). (WasteCodeText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: EpisodicHandlerWasteCodeDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_EPISODIC_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HD_HBASIC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACTIVITY_LOCATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the source of information for the associated data (activity, wastes, etc.). (SourceTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SOURCE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence number for each source record about a handler. (SourceRecordSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SEQ_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date that the form (indicated by the associated Source) was received from the handler by the appropriate authority. (ReceiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECEIVE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of the Handler (HandlerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HANDLER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date information was received for the handler. (AcknowledgeReceiptDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACKNOWLEDGE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating that the handler has been identified through a source other than Notification and is suspected of conducting RCRA-regulated activities without proper authority. (NonNotifierIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NON_NOTIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing Notification source(Data publishing only). (NonNotifierIndicatorText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NON_NOTIFIER_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date that operation of the facility commenced, the date construction on the facility commenced, or the date that operation is expected to begin. Part-A submissions (TreatmentStorageDisposalDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TSD_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding Handler Part-A submissions. (NatureOfBusinessText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NATURE_OF_BUSINESS_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler, whether public or private, currently accepts hazardous waste from another site (site identified by a different EPA ID). If information is also available on the specific processes and wastes which are accepted, it is indicated by a flag at the process unit level (Process Unit Group Commercial Status). (OffsiteWasteReceiptCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'OFF_SITE_RECEIPT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the reason why the handler is not accessible for normal RCRA tracking and processing (previously called Bankrupt Indicator). (AccessibilityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACCESSIBILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing reason facility is not accessible(Data publishing only). (AccessibilityCodeText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACCESSIBILITY_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the county code. (CountyCodeOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'COUNTY_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Federal Information Processing Standard (FIPS) code for the county in which the facility is located (Ref: FIPS Publication, 6-3, "Counties and County Equivalents of the States of the United States"). (CountyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'COUNTY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding the Handler (these are public notes; will be available via all services). (HandlerSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding the Handler (these are internal notes; will be available via authenticated services). (HandlerInternalSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'INTRNL_NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding the Handler (these are internal notes; will be available via authenticated services). (ShortTermSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SHORT_TERM_INTRNL_NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is acknowledged. (AcknowledgeFlagIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACKNOWLEDGE_FLAG_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is included in national report. (IncludeInNationalReportIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'INCLUDE_IN_NATIONAL_REPORT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is LQHUW. (LQHUWIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LQHUW_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the year of report cycle. (HDReportCycleYear)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HD_REPORT_CYCLE_YEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the health care facility. (HealthcareFacility)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HEALTHCARE_FAC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the reverse distributor. (ReverseDistributor)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'REVERSE_DISTRIBUTOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the withdrawal from Subpart P. (SubpartPWithdrawal)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SUBPART_P_WITHDRAWAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is current record. (CurrentRecord)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CURRENT_RECORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (HCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'H_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates data origination information. (DataOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'DATA_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude data type (LocationLatitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_LATITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude data type (LocationLongitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_LONGITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location GIS primary. (LocationGisPrimary)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_GIS_PRIM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location GIS data original source. (LocationGisOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_GIS_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating if it is BR exempt. (BRExemptIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'BR_EXEMPT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (AcknowledgeFlag)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ACKNOWLEDGE_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (SupplementalLocationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocalityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (StateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (CountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LOCATION_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_MIDDLE_INITIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (OrganizationFormalName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_ORG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (EmailAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_EMAIL_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone number extension (PhoneExtensionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax number (FaxNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'CONTACT_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_MIDDLE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (OrganizationFormalName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_ORG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (EmailAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_EMAIL_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone number extension (PhoneExtensionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax number (FaxNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'PCONTACT_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the burning of used oil fuel. (FuelBurnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_BURNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in processing used oil activities. (ProcessorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_PROCESSOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in re-refining used oil activities. (RefinerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_REFINER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler directs shipments of used oil to burners. (MarketBurnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_MARKET_BURNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is a marketer who first claims the used oil meets the specifications. (SpecificationMarketerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_SPEC_MARKETER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler owns or operates a used oil transfer facility. (TransferFacilityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_TRANSFER_FACILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in used oil transportation and/or transfer facility activities. (TransporterCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'USED_OIL_TRANSPORTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating current ownership status of the land on which the facility is located. (LandTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'LAND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner of the state district code. Usually 2-digit postal code (i.e. KS). (StateDistrictOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'STATE_DISTRICT_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the state-designated legislative district(s) in which the site is located. (StateDistrictCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'STATE_DISTRICT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing the code indicating the state-designated legislative district(s) in which the site is located. (StateDistrictCodeText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'STATE_DISTRICT_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in importing hazardous waste into the United States. (ImporterActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'IMPORTER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in generating mixed waste (waste that is both hazardous and radioactive). (MixedWasteGeneratorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MIXED_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code for recycling hazardous waste. (RecyclerActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECYCLER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the transportation of hazardous waste. (TransporterActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the treatment, storage, or disposal of hazardous waste. (TreatmentStorageDisposalActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TSD_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler generates and or treats, stores, or disposes of hazardous waste and has an injection well located at the installation. (UndergroundInjectionActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'UNDERGROUND_INJECTION_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler treats, disposes of, or recycles hazardous waste on site. (UniversalWasteDestinationFacilityIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'UNIVERSAL_WASTE_DEST_FACILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler qualifies for the Small Quantity Onsite Burner Exemption. (OnsiteBurnerExemptionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'ONSITE_BURNER_EXEMPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler qualifies for the Smelting, Melting, and Refining Furnace Exemption. (FurnaceExemptionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'FURNACE_EXEMPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in short-term hazardous waste generation activities. (ShortTermGeneratorIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SHORT_TERM_GEN_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is a Hazardous Waste Transfer Facility (not to be confused with a used oil transfer facility). (TransferFacilityIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TRANSFER_FACILITY_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Import Trading activity. Possible values are: Y/N (RecognizedTraderImporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECOGNIZED_TRADER_IMPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Export Trading activity. Possible values are: Y/N (RecognizedTraderExporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECOGNIZED_TRADER_EXPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Slab Import activity. Possible values are: Y/N (SlabImporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SLAB_IMPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Slab Export activity. Possible values are: Y/N (SlabExporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'SLAB_EXPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies that Handler participates in Nonstorage Recycler Activity. (RecyclerActivityNonstorage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECYCLER_ACT_NONSTORAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies that Handler is ManifestBroker. (ManifestBroker)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'MANIFEST_BROKER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the generator status type. (WasteGeneratorOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'STATE_WASTE_GENERATOR_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the generation of hazardous waste. (WasteGeneratorStatusCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'STATE_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the generator status type. (WasteGeneratorOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'FED_WASTE_GENERATOR_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the generation of hazardous waste. (WasteGeneratorStatusCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'FED_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the Handler is a College or University opting into SubPart K. (CollegeIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'COLLEGE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the Handler is a Hospital opting into SubPart K. (HospitalIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'HOSPITAL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the Handler is a Non-Profit opting into SubPart K. (NonProfitIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NON_PROFIT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the Handler is withdrawing from SubPart K. (WithdrawalIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'WITHDRAWAL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the reason for notifying Hazardous Secondary Material (NotificationReasonCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'NOTIFICATION_RSN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Effective Date of the action: 1. Hazardous Secondary Material notification in Handler, 2. Corrective Action Authority, 3. Financial Assurance Mechanism. (EffectiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'EFFC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the facility has provided Financial Assurance for the HSM Activities (FinancialAssuranceIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'FINANCIAL_ASSURANCE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code for recycling hazardous waste. (RecyclerIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECYCLER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes for recycling hazardous waste. (RecyclerNotes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECYCLER_NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Description of the Hazardous Secondary Material managed by the Handler (RecyclingIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER', @level2type=N'COLUMN',@level2name=N'RECYCLING_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HandlerDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HANDLER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Details of facility submission. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'HD_HBASIC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Details of facility submission. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'HD_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Designates that data is available for extract for public use. (PublicUseExtractIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'EXTRACT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Computer-generated primary facility-level key in the EPA FINDS data system used as an identifier to cross-reference entities regulated under different environmental programs. The Agency Facility Identification Data Standard (FIDS) requires that program offices store this key in their data systems. (FacilityRegistryID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC', @level2type=N'COLUMN',@level2name=N'FACILITY_IDENTIFIER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: FacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_HBASIC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'HD_LQG_CLOSURE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of the closure. (ClosureType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'CLOSURE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of expected closure. (ExpectedClosureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'EXPECTED_CLOSURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'New closure date. (NewClosureDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'NEW_CLOSURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date of closed. (DateClosed)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'DATE_CLOSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of in compliance. (InComplianceIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE', @level2type=N'COLUMN',@level2name=N'IN_COMPLIANCE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HandlerLqgClosure' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CLOSURE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'HD_LQG_CONSOLIDATION_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Top level of all information about the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique number that identifies the Consolidation. (ConsolidationSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'SEQ_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of the Handler (HandlerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'HANDLER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_MIDDLE_INITIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (OrganizationFormalName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_ORG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (EmailAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_EMAIL_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone number extension (PhoneExtensionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax number (FaxNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION', @level2type=N'COLUMN',@level2name=N'CONTACT_FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HandlerLqgConsolidation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_LQG_CONSOLIDATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: North American Industry Classification Status codes reported for the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'HD_NAICS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: North American Industry Classification Status codes reported for the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence number for each NAICS code for the handler. (NAICSSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'NAICS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the NAICS Code. (NAICSOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'NAICS_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The North American Industry Classification System Code that identifies the business activities of the facility. (NAICSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS', @level2type=N'COLUMN',@level2name=N'NAICS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: NAICSIdentityDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_NAICS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contains alternative identifiers for the facility. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'HD_OTHER_ID_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contains alternative identifiers for the facility. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'HD_HBASIC_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Alternate facility identifier. (OtherHandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'OTHER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that owns the Relationship. (RelationshipOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'RELATIONSHIP_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the type of the relationship. (RelationshipTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'RELATIONSHIP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether the alternate Id references the same facility. (SameFacilityIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'SAME_FACILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes regarding the alternative facility identifier. (OtherIDSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: OtherIDDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OTHER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Handler owner and operator information. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'HD_OWNEROP_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Handler owner and operator information. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequential number used to order multiple occurrences of owners and operators. (OwnerOperatorSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'OWNER_OP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating whether the data is associated with a current or previous owner or operator. The system will allow multiple current owners and operators. (OwnerOperatorIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'OWNER_OP_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the owner/operator type. (OwnerOperatorTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'OWNER_OP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date indicating when the owner/operator became current. (CurrentStartDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'DATE_BECAME_CURRENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date indicating when the owner/operator changed to a different owner/operator. (CurrentEndDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'DATE_ENDED_CURRENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes for the facility Owner Operator. (OwnerOperatorSupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (FirstName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (MiddleInitial)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'MIDDLE_INITIAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (LastName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Contact information. (OrganizationFormalName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'ORG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Title of the contact person or the title of the person who certified the handler information reported to the authorizing agency. (IndividualTitleText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Email address data (EmailAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'EMAIL_ADDRESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone Number data (TelephoneNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Telephone number extension (PhoneExtensionText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'PHONE_EXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax number (FaxNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'MAIL_ADDR_NUM_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP', @level2type=N'COLUMN',@level2name=N'ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: FacilityOwnerOperatorDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_OWNEROP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous Secondary Material activity of the Handler (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'HD_SEC_MATERIAL_ACTIVITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous Secondary Material activity of the Handler (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unique number identifying the HSM Activity for the Handler (HSMSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'HSM_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner of the Facility Code. Shoule be HQ or the state code (i.e. KS) (FacilityCodeOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'FAC_CODE_OWNER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of facility generating Hazardous Secondary Material (FacilityTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'FAC_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The estimated amount of HSM generated by the Handler (EstimatedShortTonsQuantity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'ESTIMATED_SHORT_TONS_QNTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The actual amount of HSM generated by the Handler (ActualShortTonsQuantity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'ACTL_SHORT_TONS_QNTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code to indicate if the HSM is being managed in a Land Based Unit (LandBasedUnitIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'LAND_BASED_UNIT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing the code to indicate if the HSM is being managed in a Land Based Unit (LandBasedUnitIndicatorText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY', @level2type=N'COLUMN',@level2name=N'LAND_BASED_UNIT_IND_TEXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousSecondaryMaterialActivityDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_MATERIAL_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_SEC_WASTE_CODE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_SEC_MATERIAL_ACTIVITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that owns the data record. (WasteCodeOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to describe hazardous waste. (WasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: SecondaryHandlerWasteCodeDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SEC_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: State waste activity of the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY', @level2type=N'COLUMN',@level2name=N'HD_STATE_ACTIVITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: State waste activity of the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the state activity type. (StateActivityOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY', @level2type=N'COLUMN',@level2name=N'STATE_ACTIVITY_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the type of state activity. (StateActivityTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY', @level2type=N'COLUMN',@level2name=N'STATE_ACTIVITY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: StateActivityDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_STATE_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWasteHandlerSubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Information about universal waste generated by the handler. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'HD_UNIVERSAL_WASTE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Information about universal waste generated by the handler. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the universal waste type. (UniversalWasteOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'UNIVERSAL_WASTE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the type of universal waste. (UniversalWasteTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'UNIVERSAL_WASTE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in accumulating waste on site. (AccumulatedWasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'ACCUMULATED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in generating waste on site. (GeneratedHandlerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE', @level2type=N'COLUMN',@level2name=N'GENERATED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: UniversalWasteActivityDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_UNIVERSAL_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_WASTE_CODE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'HD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that owns the data record. (WasteCodeOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to describe hazardous waste. (WasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HandlerWasteCodeDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_HD_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit event Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit event Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_SERIES_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the event. (PermitEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'PERMIT_EVENT_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to indicate a specific permitting/closure program event and status that has actually occurred or is scheduled to occur. (PermitEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'PERMIT_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the event. (EventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify multiple occurrences of a corrective action event. (EventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date on which actual completion of an event occurs. (ActualDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'ACTL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The original scheduled completion date for an event. This date cannot be changed once entered. Slippage of the scheduled completion date is recorded in the NewScheduleDate Data Element. (OriginalScheduleDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'ORIGINAL_SCHEDULE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Revised scheduled completion date of the event. This date is used in conjunction with the Original Scheduled Event Date to allow tracking scheduled date slippage. As the scheduled date changes, this field is updated with the new date and the Original Scheduled Event Date is not changed. (NewScheduleDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'NEW_SCHEDULE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (ResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation or who is the responsible Authority. (ResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Event responsible suborganization owner. (EventSuborganizationDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SUBORG_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Event responsible suborganization. (EventSuborganizationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SUBORG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (PCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'P_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'PRM_EVENT_COMMITMENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'PRM_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (CommitmentLead)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'COMMIT_LEAD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Commitment/Initiative and Corrective Action or Permitting Events. (CommitmentSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT', @level2type=N'COLUMN',@level2name=N'COMMIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitEventCommitmentDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_EVENT_COMMITMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This is the root element for this flow XML Schema. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'PRM_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This is the root element for this flow XML Schema. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'PRM_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code that uniquely identifies the handler. (HandlerID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_FAC_SUBM', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitFacilitySubmissionDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_FAC_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking mod event for Permitting Events. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_MOD_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking mod event for Permitting Events. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Handler id. (ModHandlerId)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit event activity location. (ModActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit series sequence number. (ModSeriesSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_SERIES_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit event sequence number. (ModEventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit event owner. (ModEventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit event owner. (ModEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_EVENT_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit event code. (ModEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT', @level2type=N'COLUMN',@level2name=N'MOD_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitModEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_MOD_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Permitted Units and Permitting Events (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_RELATED_EVENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Linking Data for Permitted Units and Permitting Events (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'PRM_UNIT_DETAIL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'ACT_LOC_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a permit series. (PermitSeriesSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'PERMIT_SERIES_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the event. (PermitEventDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'PERMIT_EVENT_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to indicate a specific permitting/closure program event and status that has actually occurred or is scheduled to occur. (PermitEventCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'PERMIT_EVENT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agency responsible for the event. (EventAgencyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_AGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify multiple occurrences of a corrective action event. (EventSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT', @level2type=N'COLUMN',@level2name=N'EVENT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitRelatedEventDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_RELATED_EVENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit series Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'PRM_SERIES_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit series Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'PRM_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a permit series. (PermitSeriesSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'PERMIT_SERIES_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name or number assigned by the implementing agency. (PermitSeriesName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'PERMIT_SERIES_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the person identifier. (ResponsiblePersonDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the person within the agency responsible for conducting the evaluation or who is the responsible Authority. (ResponsiblePersonID)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'RESP_PERSON_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates if the permit series is active. Possible values are: Y/N (ActiveSeriesIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'ACTIVE_SERIES_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (PCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'P_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitSeriesDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SERIES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWastePermitDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit Unit Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'PRM_UNIT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit Unit Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'PRM_FAC_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a process unit. (PermitUnitSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name or number assigned by the implementing agency to identify a process unit group. (PermitUnitName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates if the permit unit is active. Possible values are: Y/N (ActiveUnitIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'ACTIVE_UNIT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (PCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'P_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitUnitDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit Unit Detail Data (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PRM_UNIT_DETAIL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Permit Unit Detail Data (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PRM_UNIT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'TRANS_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'System-generated value used to uniquely identify a process unit detail. (PermitUnitDetailSequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_DETAIL_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the process code. (ProcessUnitDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PROC_UNIT_DATA_OWNER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code specifying the unit group''s current waste treatment, storage, or disposal process. (ProcessUnitCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PROC_UNIT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date specifying when the other information in the process detail data record (i.e., process, capacity, and operating and legal status) became effective. (PermitStatusEffectiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PERMIT_STAT_EFFC_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permitted capacity of the unit (PermitUnitCapacityQuantity)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'PERMIT_UNIT_CAP_QNTY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the type of capacity. (CapacityTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'CAP_TYPE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the facility, whether public or private, accepts hazardous waste for the process unit group from a third party. (CommercialStatusCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'COMMER_STAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the legal/operating status code. (LegalOperatingStatusDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'LEGAL_OPER_STAT_DATA_OWNER_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to indicate programmatic (operating and legal status) conditions that reflect RCRA program activity requirements of a unit. (LegalOperatingStatusCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'LEGAL_OPER_STAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that defines the unit of measure. (MeasurementUnitDataOwnerCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'MEASUREMENT_UNIT_DATA_OWNR_CDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the unit of measure. (MeasurementUnitCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'MEASUREMENT_UNIT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total number of units of the same process grouped together to form a single process unit group. (NumberOfUnitsCount)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'NUM_OF_UNITS_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates whether or not the permit is a standardized permit. (StandardPermitIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'STANDARD_PERMIT_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes providing more information. (SupplementalInformationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'SUPP_INFO_TXT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates if the unit detail is current. Possible values are: Y/N (CurrentUnitDetailIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'CURRENT_UNIT_DETAIL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of record creation (CreatedByUserid)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'CREATED_BY_USERID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Creation date (PCreatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'P_CREATED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User id of last record update (LastUpdatedBy)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last update date (LastUpdatedDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL', @level2type=N'COLUMN',@level2name=N'LAST_UPDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitUnitDetailDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_UNIT_DETAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'PRM_WASTE_CODE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Hazardous waste codes describing the handler''s hazardous waste streams. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'PRM_UNIT_DETAIL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction code used to define the add, update, or delete. (TransactionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'TRANSACTION_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the agency that owns the data record. (WasteCodeOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code used to describe hazardous waste. (WasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE', @level2type=N'COLUMN',@level2name=N'WASTE_CODE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: PermitHandlerWasteCodeDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_PRM_WASTE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: All information about the ReportUniv. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RU_REPORT_UNIV_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: All information about the ReportUniv. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RU_REPORT_UNIV_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Handler ID (HandlerIdCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'HANDLER_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates the location of the agency regulating the handler. (ActivityLocationCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'ACTIVITY_LOCATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the source of information for the associated data (activity, wastes, etc.). (SourceTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SOURCE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence number for each source record about a handler. (SequenceNumber)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SEQ_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date that the form (indicated by the associated Source) was received from the handler by the appropriate authority. (ReceiveDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RECEIVE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of the Handler (HandlerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'HANDLER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag indicating that the handler has been identified through a source other than Notification and is suspected of conducting RCRA-regulated activities without proper authority. (NonNotifierIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NON_NOTIFIER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reason why the handler is not accessible for normal processing (Bankrupt Indicator). (Accessibility)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'ACCESSIBILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Report cycle (ReportCycle)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'REPORT_CYCLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Region (Region)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'REGION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State (State)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Extract flag (ExtractFlag)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'EXTRACT_FLAG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active site (ActiveSite)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'ACTIVE_SITE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Federal Information Processing Standard (FIPS) code for the county in which the facility is located (Ref: FIPS Publication, 6-3, "Counties and County Equivalents of the States of the United States"). (CountyCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'COUNTY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing the County Name(Data publishing only). (CountyName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'COUNTY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact name (first + last) (ContactNameCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact phone (ContactPhoneCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_PHONE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact fax (ContactFaxCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_FAX'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact email (ContactEmailCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contact title (ContactTitleCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_TITLE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner name (OwnerNameCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OWNER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner type (OwnerTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OWNER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner seq (OwnerSeqCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OWNER_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator name (OperatorNameCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OPER_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator type (OperatorTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OPER_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operator seq (OperatorSeqCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OPER_SEQ_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NAIC 1 (NAIC1Code)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NAIC1_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NAIC 2 (NAIC2Code)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NAIC2_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NAIC 3 (NAIC3Code)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NAIC3_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NAIC 4 (NAIC4Code)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NAIC4_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In handler universe (InHandlerUniverseCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'IN_HANDLER_UNIVERSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In A universe (InAUniverseCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'IN_A_UNIVERSE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Federal code indicating that the handler is engaged in the generation of hazardous waste. (FederalWasteGeneratorOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FED_WASTE_GENERATOR_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Federal code indicating that the handler is engaged in the generation of hazardous waste. (FederalWasteGeneratorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FED_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State code indicating that the handler is engaged in the generation of hazardous waste. (StateWasteGeneratorOwner)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_WASTE_GENERATOR_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State code indicating that the handler is engaged in the generation of hazardous waste. (StateWasteGeneratorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gen status (GENSTATUS)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'GEN_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Univ waste (UNIVWASTE)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'UNIV_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating current ownership status of the land on which the facility is located. (LandTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LAND_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner of the state district code. Usually 2-digit postal code (i.e. KS). (StateDistrictOwnerName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_DISTRICT_OWNER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating the state-designated legislative district(s) in which the site is located. (StateDistrictCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_DISTRICT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in short-term hazardous waste generation activities. (ShortTermGeneratorIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SHORT_TERM_GEN_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in importing hazardous waste into the United States. (ImporterActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'IMPORTER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in generating mixed waste (waste that is both hazardous and radioactive). (MixedWasteGeneratorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MIXED_WASTE_GENERATOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is engaged in the transportation of hazardous waste. (TransporterActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'TRANSPORTER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler is a Hazardous Waste Transfer Facility (not to be confused with a used oil transfer facility). (TransferFacilityIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'TRANSFER_FACILITY_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code for recycling hazardous waste. (RecyclerActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RECYCLER_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler qualifies for the Small Quantity Onsite Burner Exemption. (OnsiteBurnerExemptionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'ONSITE_BURNER_EXEMPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler qualifies for the Smelting, Melting, and Refining Furnace Exemption. (FurnaceExemptionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FURNACE_EXEMPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler generates and or treats, stores, or disposes of hazardous waste and has an injection well located at the installation. (UndergroundInjectionActivityCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'UNDERGROUND_INJECTION_ACTIVITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code indicating that the handler treats, disposes of, or recycles hazardous waste on site. (UniversalWasteDestinationFacilityIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'UNIVERSAL_WASTE_DEST_FACILITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Off site waste receipt (OffSiteWasteReceiptCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OFFSITE_WASTE_RECEIPT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Used oil (UsedOilCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'USED_OIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Federal universal waste (FederalUniversalWasteCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FEDERAL_UNIVERSAL_WASTE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'As federal regulated TSDF (AsFederalRegulatedTSDFCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'AS_FEDERAL_REGULATED_TSDF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'As converter TSDF (AsConverterTSDFCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'AS_CONVERTED_TSDF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'As state regulated TSDF (AsStateRegulatedTSDFCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'AS_STATE_REGULATED_TSDF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Federal indicator (FederalIndicatorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FEDERAL_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'HSM code (HSMCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'HSM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subpart K code (SubpartKCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBPART_K'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Commercial TSD code (CommercialTSDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'COMMERCIAL_TSD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TSD type (TSDTypeCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'TSD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GPRA permit (GPRAPermitCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'GPRA_PERMIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GPRA renewal code (GPRARenewalCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'GPRA_RENEWAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permit renewal WRKLD (PermitRenewalWRKLDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'PERMIT_RENEWAL_WRKLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Perm WRKLD (PermWRKLDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'PERM_WRKLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Perm PROG (PermPROGCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'PERM_PROG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PC WRKLD (PCWRKLDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'PC_WRKLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clos WRKLD (ClosWRKLDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CLOS_WRKLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'GPRACA (GPRACACode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'GPRACA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CAWRKLD (CAWRKLDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CA_WRKLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subj CA (SubjCACode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBJ_CA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subj CA non TSD (SubjCANonTSDCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBJ_CA_NON_TSD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subj CA TSD 3004 (SubjCATSD3004Code)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBJ_CA_TSD_3004'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subj CA discretion (SubjCADiscretionCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBJ_CA_DISCRETION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'NCAPS (NCAPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NCAPS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EC indicator (ECIndicatorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'EC_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IC indicator (ICIndicatorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'IC_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CA 725 indicator (CA725IndicatorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CA_725_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CA 750 indicator (CA750IndicatorCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CA_750_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Operating TSDF (OperatingTSDFCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'OPERATING_TSDF'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Full enforcement (FullEnforcementCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FULL_ENFORCEMENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SNC (SNCCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SNC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY SNC (BOYSNCCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_SNC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY state unaddressed SNC (BOYStateUnaddressedSNCCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_STATE_UNADDRESSED_SNC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State unaddressed (StateUnaddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_UNADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State addressed (StateAddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_ADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY state addressed (BOYStateAddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_STATE_ADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'State SNC with comp sched (StateSNCWithCompSchedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'STATE_SNC_WITH_COMP_SCHED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY state SNC with comp sched (BOYStateSNCWithCompSchedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_STATE_SNC_WITH_COMP_SCHED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EPA unaddressed (EPAUnaddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'EPA_UNADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY EPA unaddressed (BOYEPAUnaddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_EPA_UNADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EPA addressed (EPAAddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'EPA_ADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY EPA addressed (BOYEPAAddressedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_EPA_ADDRESSED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EPA SNC with comp sched (EPASNCWithcompSchedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'EPA_SNC_WITH_COMP_SCHED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BOY EPA SNC with comp sched (BOYEPASNCWithcompSchedCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'BOY_EPA_SNC_WITH_COMP_SCHED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FA required (FARequiredCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'FA_REQUIRED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'HHandler last change date (HHandlerLastChangeDate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'HHANDLER_LAST_CHANGE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes (PublicNotesCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'PUBLIC_NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Notes (NotesCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'NOTES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Import Trading activity. Possible values are: Y/N (RecognizedTraderImporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RECOGNIZED_TRADER_IMPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Export Trading activity. Possible values are: Y/N (RecognizedTraderExporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RECOGNIZED_TRADER_EXPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Slab Import activity. Possible values are: Y/N (SlabImporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SLAB_IMPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicates that the Handler is participating in Slab Export activity. Possible values are: Y/N (SlabExporterIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SLAB_EXPORTER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Recycle non storage (RecyclerNonStorageIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'RECYCLER_NON_STORAGE_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Manifest broker (ManifestBrokerIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MANIFEST_BROKER_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subpart P code (SubpartPIndicator)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'SUBPART_P_IND'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude data type (LocationLatitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_LATITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude data type (LocationLongitude)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_LONGITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location GIS primary. (LocationGisPrimary)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_GIS_PRIM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Location GIS data original source. (LocationGisOrig)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_GIS_ORIG'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (SupplementalLocationText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocalityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (StateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (LocationZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Location address information. (CountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'LOCATION_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: Mailing address information. (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'MAIL_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressNumberText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (SupplementalAddressText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_STREET2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressCityName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_CITY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressStateUSPSCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressCountryName)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_COUNTRY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: RU contact address (MailingAddressZIPCode)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV', @level2type=N'COLUMN',@level2name=N'CONTACT_ZIP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ReportUniv' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This is the root element for this flow XML Schema. (_PK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV_SUBM', @level2type=N'COLUMN',@level2name=N'RU_REPORT_UNIV_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parent: This is the root element for this flow XML Schema. (_FK)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV_SUBM', @level2type=N'COLUMN',@level2name=N'RU_SUBM_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: ReportUnivSubmission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_REPORT_UNIV_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descriptive text describing whether the data are public or private. (DataAccessText)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_SUBM', @level2type=N'COLUMN',@level2name=N'DATA_ACCESS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: HazardousWasteReportUnivDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_RU_SUBM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Schema element: SubmissionHistoryDataType' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RCRA_SUBMISSIONHISTORY'
GO
