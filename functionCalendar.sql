
create FUNCTION dbo.CALENDAR 
(
    @StartDate DATETIME
,   @EndDate DATETIME
) 
RETURNS TABLE
AS
--====================================
-- Name: CALENDAR
-- Created: Chris Kutsch 12/29/2014
-- Usage: Returns a dynamic calendar for date manipulation
--====================================

RETURN  
(   

    SELECT  tt.RID
        ,   DATEADD(DAY,tt.RID-1,@StartDate) AS [Date]
        ,   DATEPART(quarter,DATEADD(DAY,tt.RID-1,@StartDate)) AS [Quarter]
        ,   DATEPART(dayofyear,DATEADD(DAY,tt.RID-1,@StartDate)) AS [DayofYear]
        ,   DATEPART(WEEK,DATEADD(DAY,tt.RID-1,@StartDate)) AS [WeekofYear]
        ,   DATEPART(YEAR,DATEADD(DAY,tt.RID-1,@StartDate)) AS [Year]    
        ,   DATEPART(MONTH,DATEADD(DAY,tt.RID-1,@StartDate)) AS [Month]
        ,   DATEPART(DAY,DATEADD(DAY,tt.RID-1,@StartDate)) AS [Day]    
        ,   DATEPART(weekday,DATEADD(DAY,tt.RID-1,@StartDate)) AS [Weekday]
        ,   DATENAME(MONTH,DATEADD(DAY,tt.RID-1,@StartDate)) AS [MonthName]
        ,   DATENAME(weekday,DATEADD(DAY,tt.RID-1,@StartDate)) AS [WeekdayName]
        ,   CASE WHEN(    (DATEPART(weekday,DATEADD(DAY,tt.RID-1,@StartDate)) NOT IN (1,7)) 
                      AND (rh.[DATFERIADO] IS NULL) ) 
                 THEN 1 ELSE 0 END AS [IsBusinessDay]
        ,   (RIGHT( 
                REPLICATE('0',(4)) +
                CONVERT([VARCHAR],DATEPART(YEAR,DATEADD(DAY,tt.RID-1,@StartDate)),0)
                ,(4)
             )+
             RIGHT(
                REPLICATE('0',(2)) +
                CONVERT([VARCHAR],DATEPART(MONTH,DATEADD(DAY,tt.RID-1,@StartDate)),0)
                ,(2)
             )
            ) AS [Vintage]
        
    FROM    ( SELECT ROW_NUMBER() OVER (ORDER BY [object_id]) AS [RID]
              FROM sys.all_objects WITH (NOLOCK)
            ) tt LEFT OUTER JOIN
            TBGENE020 rh WITH (NOLOCK) ON DATEADD(DAY,tt.RID-1,@StartDate) = rh.[DATFERIADO]
            
    WHERE   DATEADD(DAY,tt.RID-1,@StartDate) <= @EndDate
    
)
 
GO


--Last Day in each month:
SELECT  DISTINCT MAX([Date]) OVER (PARTITION BY [Year],[MonthName]) AS [Date]
FROM    dbo.CALENDAR('01/01/2015','12/31/2015')
ORDER BY [Date]


SELECT  *
FROM    dbo.CALENDAR('01/01/2015','01/31/2015')
where IsBusinessDay=0
ORDER BY [Date]


--First and Third Monday in each month:
SELECT  c.[Date]
FROM    dbo.CALENDAR('01/01/2014','01/01/2015') AS c
        JOIN
        (   SELECT  ROW_NUMBER() OVER (PARTITION BY [Year],[MonthName],[WeekdayName] ORDER BY [RID]) AS [ID]
                ,   [MonthName]
                ,   [WeekdayName]
                ,   RID
            FROM    dbo.CALENDAR('01/01/2014','01/01/2015')
        ) l on c.RID = l.RID
WHERE   l.[WeekdayName] = 'Monday' And
        l.ID in (1,3)
ORDER BY c.RID



--Last Thursday in each month:
SELECT  DISTINCT MAX([Date]) OVER (PARTITION BY [Year],[MonthName],[WeekdayName]) AS [Date]
FROM    dbo.CALENDAR('01/01/2015','12/31/2015')
WHERE   [WeekdayName] = 'Thursday'
ORDER BY [Date]