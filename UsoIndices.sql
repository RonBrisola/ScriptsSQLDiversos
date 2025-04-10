--sp_helpindex 'TBPROD100'

DECLARE @TABLENAME SYSNAME
SET @TABLENAME= 'dbo.TBFATU006'

SELECT DB_NAME(DATABASE_ID) AS [DATABASE NAME]
 , OBJECT_NAME(SS.OBJECT_ID) AS [OBJECT NAME]
 , I.NAME AS [INDEX NAME]
 , I.INDEX_ID AS [INDEX ID]
 , USER_SEEKS AS [NUMBER OF SEEKS]
 , USER_SCANS AS [NUMBER OF SCANS]
 , USER_LOOKUPS AS [NUMBER OF BOOKMARK LOOKUPS]
 , USER_UPDATES AS [NUMBER OF UPDATES]
FROM     
   SYS.DM_DB_INDEX_USAGE_STATS SS
   INNER JOIN SYS.INDEXES I
       ON I.OBJECT_ID = SS.OBJECT_ID
            AND I.INDEX_ID = SS.INDEX_ID
WHERE DATABASE_ID = DB_ID()
--  AND OBJECTPROPERTY (SS.OBJECT_ID,'IsUserTable') = 1
-- AND  SS.OBJECT_ID = OBJECT_ID(@TABLENAME)  
ORDER BY USER_SEEKS
    , USER_SCANS
    , USER_LOOKUPS
      , USER_UPDATES ASC
GO
