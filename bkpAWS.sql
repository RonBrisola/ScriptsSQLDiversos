use master

DECLARE @nomeArq    VARCHAR(300),
        @bd         VARCHAR(300),
        @bucket     VARCHAR(300),
        @backup_to  VARCHAR(300)

SET @bd        = 'BDAGIW' 

SELECT @nomeArq = @bd + '_' +
       CASE datepart(dw, GETDATE())
          WHEN 1 THEN '1_dom'
          WHEN 2 THEN '2_seg'
          WHEN 3 THEN '3_ter'
          WHEN 4 THEN '4_qua'
          WHEN 5 THEN '5_qui'
          WHEN 6 THEN '6_sex'
          WHEN 7 THEN '7_sab'
         END  + '.bak'

SET @bucket    = 'awssatis/'
SET @backup_to = 'arn:aws:s3:::' + @bucket + @nomeArq


exec msdb.dbo.rds_backup_database 
        @source_db_name=@bd, 
        @s3_arn_to_backup_to= @backup_to,
        @overwrite_S3_backup_file=1;

