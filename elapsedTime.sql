-- Vishal - http://SqlAndMe.com

DECLARE @startTime DATETIME
DECLARE @endTime DATETIME

SET @startTime = '2013-08-05'
SET @endTime = getdate()

SELECT	[DD:HH:MM:SS] =
	CAST((DATEDIFF(HOUR, @startTime, @endTime) / 24) AS VARCHAR)
	+ ':' +
	CAST((DATEDIFF(HOUR, @startTime, @endTime) % 24) AS VARCHAR)
	+ ':' + 
	CASE WHEN DATEPART(SECOND, @endTime) >= DATEPART(SECOND, @startTime)
	THEN CAST((DATEDIFF(MINUTE, @startTime, @endTime) % 60) AS VARCHAR)
	ELSE
	CAST((DATEDIFF(MINUTE, DATEADD(MINUTE, -1, @endTime), @endTime) % 60)
		AS VARCHAR)
	END
	+ ':' + CAST((DATEDIFF(SECOND, @startTime, @endTime) % 60) AS VARCHAR),
	[StringFormat] =
	CAST((DATEDIFF(HOUR , @startTime, @endTime) / 24) AS VARCHAR) +
	' Days ' +
	CAST((DATEDIFF(HOUR , @startTime, @endTime) % 24) AS VARCHAR) +
	' Hours ' +
	CASE WHEN DATEPART(SECOND, @endTime) >= DATEPART(SECOND, @startTime)
	THEN CAST((DATEDIFF(MINUTE, @startTime, @endTime) % 60) AS VARCHAR)
	ELSE
	CAST((DATEDIFF(MINUTE, DATEADD(MINUTE, -1, @endTime), @endTime) % 60)
	AS VARCHAR)
	END +
	' Minutes ' +
	CAST((DATEDIFF(SECOND, @startTime, @endTime) % 60) AS VARCHAR) +
	' Seconds '