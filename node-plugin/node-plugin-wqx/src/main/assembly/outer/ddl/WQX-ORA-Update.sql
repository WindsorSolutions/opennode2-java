-- To be used on staging tables if this field does not exist (most WQX staging schemas created before the 2.00 Java OpenNode2 release will be missing this field)
ALTER TABLE WQX_SUBMISSIONHISTORY ADD (ORGID VARCHAR2(30) NULL);

UPDATE WQX_SUBMISSIONHISTORY set ORGID = '';

ALTER TABLE WQX_SUBMISSIONHISTORY MODIFY ORGID VARCHAR2(30) NOT NULL;

-- Added in version 2.06 of the plugin
CREATE VIEW WQX_V_ACTIVITYGROUPID_HIB AS
SELECT WQX_ACTIVITYACTIVITYGROUP.ACTIVITYGROUPPARENTID
     , WQX_ACTIVITY.ACTIVITYID 
  FROM WQX_ACTIVITYACTIVITYGROUP 
  JOIN WQX_ACTIVITY 
    ON WQX_ACTIVITYACTIVITYGROUP.ACTIVITYPARENTID = WQX_ACTIVITY.RECORDID;

CREATE VIEW WQX_V_ATTACHEDBINARYOBJECT_HIB AS
SELECT RECORDID
     , PARENTID
     , BINARYOBJECTFILE
     , BINARYOBJECTFILETYPECODE
     , BINARYOBJECTCONTENT
  FROM WQX_ACTATTACHEDBINARYOBJECT
UNION ALL
SELECT RECORDID
     , PARENTID
     , BINARYOBJECTFILE
     , BINARYOBJECTFILETYPECODE
     , BINARYOBJECTCONTENT
  FROM WQX_MONLOCATTACHEDBINARYOBJECT
UNION ALL
SELECT RECORDID
     , PARENTID
     , BINARYOBJECTFILE
     , BINARYOBJECTFILETYPECODE
     , BINARYOBJECTCONTENT
FROM WQX_PROJATTACHEDBINARYOBJECT
UNION ALL
SELECT RECORDID
     , PARENTID
     , BINARYOBJECTFILE
     , BINARYOBJECTFILETYPECODE
     , BINARYOBJECTCONTENT
FROM WQX_RESULTATTACHEDBINARYOBJECT;

CREATE VIEW WQX_V_PROJECTACTIVITYID_HIB AS
SELECT WQX_PROJECTACTIVITY.ACTIVITYPARENTID
     , WQX_PROJECT.PROJECTID 
  FROM WQX_PROJECTACTIVITY 
  JOIN WQX_ACTIVITY 
    ON WQX_PROJECTACTIVITY.ACTIVITYPARENTID = WQX_ACTIVITY.RECORDID
  JOIN WQX_PROJECT 
    ON WQX_PROJECTACTIVITY.PROJECTPARENTID = WQX_PROJECT.RECORDID;