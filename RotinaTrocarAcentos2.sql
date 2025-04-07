SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE TabelasComAcento
AS
BEGIN

	-- Copyright © 2002 Narayana Vyas Kondreddi. All rights reserved.
	-- Written by: Narayana Vyas Kondreddi
	-- Site: http://vyaskn.tripod.com
   -- Adaptado por Ronaldo Brisola
	-- Objectivo: Buscar tabelas e seus campos que contém acentuação
	-- Data: 21/12/2012

	SET NOCOUNT ON

   CREATE TABLE #results (TableName nvarchar(40), ColumnName nvarchar(40), ColumnValue nvarchar(3630))

	DECLARE @TableName  nvarchar(256), 
           @ColumnName nvarchar(128), 
           @chaveAcento nvarchar(100),
           @Collation   nvarchar(100) 
           
   SELECT @chaveAcento = RTRIM(LTRIM(DESPARAM)) FROM TBCOMP996 WHERE NOMPARAM = 'Z_CHAVEACENTO'
   SET @chaveAcento = QUOTENAME('%[' + @chaveAcento + ']%','''')

   SELECT @Collation = CAST (DATABASEPROPERTYEX(db_name(),  'Collation') AS nvarchar(100) ) 
   SET @Collation = REPLACE(@Collation, '_AI' , '_AS')

	SET @TableName  = ''

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT TOP 1 T.TABLE_NAME
			FROM 	 INFORMATION_SCHEMA.TABLES  T,
                INFORMATION_SCHEMA.COLUMNS C
			WHERE  T.TABLE_TYPE = 'BASE TABLE'
				AND T.TABLE_NAME > @TableName
				AND OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(T.TABLE_SCHEMA) + '.' + QUOTENAME(T.TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
            AND T.TABLE_NAME NOT LIKE '%TMP%'
            AND T.TABLE_NAME NOT LIKE '%BAK%'
            AND T.TABLE_NAME NOT LIKE '%sys%'
            AND T.TABLE_NAME NOT LIKE '%TEMP%'
            AND T.TABLE_NAME NOT IN ('Results', 'TBFATU152')
            AND C.TABLE_NAME = T.TABLE_NAME
            AND C.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'text')
            AND C.CHARACTER_MAXIMUM_LENGTH > 1
            AND NOT EXISTS (SELECT K.TABLE_NAME+'.'+K.COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE K
                            WHERE K.TABLE_NAME = T.TABLE_NAME AND K.COLUMN_NAME=C.COLUMN_NAME)
         ORDER BY 1

		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT TOP 1 COLUMN_NAME
				FROM INFORMATION_SCHEMA.COLUMNS C
				WHERE C.TABLE_NAME	= @TableName
				  AND	C.DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'text')
				  AND	C.COLUMN_NAME > @ColumnName
				  AND	(    (C.COLUMN_NAME NOT LIKE 'COD%')
                   AND (C.COLUMN_NAME NOT LIKE 'NUM%')
                   AND (C.COLUMN_NAME NOT LIKE 'VAL%')
                   AND (C.COLUMN_NAME NOT LIKE 'U%')
                   AND (C.COLUMN_NAME NOT LIKE 'MES%')
                   AND (C.COLUMN_NAME NOT LIKE 'ANO%')
                   AND (C.COLUMN_NAME NOT LIKE 'CEP%')
                   AND (C.COLUMN_NAME NOT LIKE 'TEL%')
                   AND (C.COLUMN_NAME NOT LIKE 'CEL%')
                   AND (C.COLUMN_NAME NOT LIKE 'FAX%')
                   AND (C.COLUMN_NAME NOT LIKE 'RAMA%')
                   AND (C.COLUMN_NAME NOT LIKE 'TIP%')
                   AND (C.COLUMN_NAME NOT LIKE 'TP%')
                   AND (C.COLUMN_NAME NOT LIKE 'HOR%')
                   AND (C.COLUMN_NAME NOT LIKE 'SER%')
                   AND (C.COLUMN_NAME NOT LIKE 'SUB%')
                   AND (C.COLUMN_NAME NOT LIKE 'CC%')
                   AND (C.COLUMN_NAME NOT LIKE 'CX%')
                   AND (C.COLUMN_NAME NOT LIKE 'DIG%')
                   AND (C.COLUMN_NAME NOT LIKE 'INSC%')
                   AND (C.COLUMN_NAME NOT LIKE '%CPF%')
                   AND (C.COLUMN_NAME NOT LIKE '%CNPJ%')
                   AND (C.COLUMN_NAME NOT LIKE '%CGC%')
                   AND (C.COLUMN_NAME NOT LIKE 'CTA%')
                   AND (C.COLUMN_NAME NOT LIKE 'CHAVE%')
                   AND (C.COLUMN_NAME NOT LIKE 'PESO%')
                   AND (C.COLUMN_NAME NOT LIKE 'PLACA%')
                   AND (C.COLUMN_NAME NOT LIKE 'SEQ%')
                   AND (C.COLUMN_NAME NOT LIKE 'STA%')
                   AND (C.COLUMN_NAME NOT LIKE 'DAT%')
                   AND (C.COLUMN_NAME NOT LIKE 'ID%')
                   AND (C.COLUMN_NAME NOT LIKE 'DESDOBRO%')
                   AND (C.COLUMN_NAME NOT LIKE 'TAM%')
                   AND (C.COLUMN_NAME NOT LIKE 'CST%')
                   AND (C.COLUMN_NAME NOT LIKE 'NR%')
                  )
              AND C.CHARACTER_MAXIMUM_LENGTH > 2
              AND NOT EXISTS (SELECT K.TABLE_NAME+'.'+K.COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE K
                            WHERE K.TABLE_NAME = C.TABLE_NAME AND K.COLUMN_NAME=C.COLUMN_NAME)

            ORDER BY 1
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
            --PRINT
				EXEC(
'
DECLARE @Value nvarchar(3630)

IF EXISTS ( SELECT TOP 1 1 FROM ' + @TableName + ' WHERE ISNUMERIC(CAST('+ @ColumnName + ' AS NVARCHAR(100)))=0 ) 
BEGIN
   SELECT TOP 1 @Value = ' + @ColumnName + ' FROM ' + @TableName + ' 
   WHERE ' + @ColumnName + ' COLLATE ' + @Collation + ' LIKE '+ @chaveAcento + ' 

   IF @Value IS NOT NULL
      INSERT INTO #results VALUES ( ''' + @TableName + ''', ''' + @ColumnName + ''', @Value ) 
END ' 
      )      

			END
		END	
	END

   SELECT * FROM #Results
END
GO

Exec TabelasComAcento

SE

