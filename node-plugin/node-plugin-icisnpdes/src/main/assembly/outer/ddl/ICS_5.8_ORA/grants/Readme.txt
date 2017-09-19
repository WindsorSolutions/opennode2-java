ICIS_5.6-ORA-DDL-GRANTS-SYS.sql: These grants will enable the DBMS_CRYPTO package (necessary for Change Detection) to be used by the stage users ICS_FLOW_LOCAL and ICS_FLOW_ICIS.

ICIS_5.6-ORA-DDL-GRANTS-SYSTEM.sql: These grants will enable DMBS_CRYTPO package used by the stage users ICS_FLOW_LOCAL and ICS_FLOW_ICIS if it is already usable and grantable by SYSTEM.

ICIS_5.8-ORA-DDL-GRANTS-ICS_FLOW_ICIS.sql: Gives permissions on all ICS_FLOW_ICIS tables to ICS_FLOW_LOCAL

ICIS_5.8-ORA-DDL-GRANTS-ICS_FLOW_LOCAL.sql: Gives ICS_FLOW_LOCAL_USER schema permission to all ICS_FLOW_LOCAL objects.

use of ICS_FLOW_LOCAL_USER schema is optional for tighter security.
