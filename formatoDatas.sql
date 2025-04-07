DECLARE @counter INT = 0
DECLARE @date DATETIME = '2006-12-30 00:38:54.840'

CREATE TABLE #dateFormats (dateFormatOption int, dateOutput nvarchar(40), command varchar(100))

set nocount on
WHILE (@counter <= 300 )
BEGIN
   
   BEGIN TRY
      INSERT INTO #dateFormats
      SELECT CONVERT(nvarchar, @counter), CONVERT(nvarchar,@date, @counter),
             'SELECT CONVERT(VARCHAR, GETDATE(), '  + CONVERT(nvarchar, @counter) + ')'
      SET @counter = @counter + 1
   END TRY
   BEGIN CATCH;
      SET @counter = @counter + 1
      IF @counter >= 300
      BEGIN
         BREAK
      END
   END CATCH
END

SELECT * FROM #dateFormats

drop table #dateFormats

