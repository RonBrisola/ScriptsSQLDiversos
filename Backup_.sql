DECLARE @nomeArq  CHAR(50)
DECLARE @data     CHAR(40)
SELECT @nomeArq = 'C:\sisinfor\backup\BDINTEG_' +
       CASE datepart(dw, GETDATE())
          WHEN 1 THEN '1_dom'
          WHEN 2 THEN '2_seg'
          WHEN 3 THEN '3_ter'
          WHEN 4 THEN '4_qua'
          WHEN 5 THEN '5_qui'
          WHEN 6 THEN '6_sex'
          WHEN 7 THEN '7_sab'
         END  + '.BAK',
       @data = 'BDINTEG - Database Backup ' + CONVERT(CHAR(8), GETDATE(), 112)

BACKUP DATABASE BDINTEG TO  DISK = @nomeArq
WITH NOFORMAT, INIT,  NAME = @data, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
