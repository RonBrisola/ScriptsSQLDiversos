-- Chaves primárias e indices
WITH cteIDX as
(
SELECT RTRIM(LTRIM(cast(t.name as char(15)))) as Tabela,
       RTRIM(LTRIM(cast(i.name as char(50)))) as Nome_Indice,
       RTRIM(LTRIM(STUFF((SELECT ', ' + c.Name FROM SYS.INDEX_COLUMNS x, SYS.COLUMNS c
                          WHERE x.object_id = i.object_id 
                            AND x.index_id  = i.index_id
                            AND c.object_id = x.object_id
                            AND c.column_id = x.column_id 
                          ORDER BY x.index_column_id  for xml path('')) ,1,1,''))) as Campos_Indice
FROM       SYS.INDEXES AS i 
INNER JOIN SYS.TABLES  AS t
        ON i.object_id = t.object_id
--WHERE t.name = @tabela
) SELECT --*, 
         --'DROP INDEX '   + Tabela + '.' + Nome_Indice  AS sqlDROP,
         case substring(Nome_Indice, 1, 2)
           when 'PK' THEN 'ALTER TABLE ' + Tabela + ' ADD CONSTRAINT '+Nome_Indice+ ' PRIMARY KEY (' + Campos_Indice + ')
           GO'
           ELSE 'CREATE INDEX ' + Nome_Indice + ' ON ' + Tabela + ' ('+ Campos_Indice + ')
           GO' 
          END AS sqlCREATE
  FROM cteIDX
  where Nome_Indice is not null
  ORDER BY Tabela,
           Nome_Indice

/* Chaves
   Estrangeiras
*/

-- Cursor principal 
DECLARE cFK CURSOR FOR 
SELECT DISTINCT 
	OBJECT_NAME(F.PARENT_OBJECT_ID) AS TABLE_NAME, 
	F.NAME AS fk_name, 
	OBJECT_NAME (F.REFERENCED_OBJECT_ID) AS remote_table_name 
FROM SYS.FOREIGN_KEYS AS F 
	INNER JOIN SYS.FOREIGN_KEY_COLUMNS AS FC ON F.OBJECT_ID = FC.CONSTRAINT_OBJECT_ID 
ORDER BY OBJECT_NAME(F.PARENT_OBJECT_ID) 
 
DECLARE @FkTable SYSNAME 
DECLARE @FkName SYSNAME 
DECLARE @FkTableRemote SYSNAME 
 
-- Abre o cursor e inicia o loop para cada FK 
OPEN cFK 
FETCH NEXT FROM cFK INTO @FkTable, @FkName, @FkTableRemote 
WHILE (@@FETCH_STATUS = 0) 
BEGIN 
	DECLARE @FKSQL NVARCHAR(4000) 
	SET @FKSQL = '' 
	SET @FKSQL = 'ALTER TABLE ' + @FkTable + ' ADD CONSTRAINT ' + @FkName + ' FOREIGN KEY (' 
 
	-- Identifica todas as colunas que compoem a FK 
	DECLARE cFKCol CURSOR FOR 
	SELECT 
		COL_NAME(FC.PARENT_OBJECT_ID,FC.PARENT_COLUMN_ID), 
		COL_NAME(FC.REFERENCED_OBJECT_ID,FC.REFERENCED_COLUMN_ID) 
	FROM SYS.FOREIGN_KEYS AS F 
		INNER JOIN SYS.FOREIGN_KEY_COLUMNS AS FC ON F.OBJECT_ID = FC.CONSTRAINT_OBJECT_ID 
	WHERE F.name = @FkName 
	ORDER BY constraint_column_id 
 
	OPEN cFKCol 
	DECLARE @FkColumnOrig SYSNAME 
	DECLARE @FkColumnDest SYSNAME 
	DECLARE @FKColumns VARCHAR(1000) 
 
	SET @FKColumns = '' 
	DECLARE @PkFirst BIT 
	SET @PkFirst = 1 
 
	-- Abre o cursor e inicia o loop adicionando cada coluna ao comando 
	FETCH NEXT FROM cFKCol INTO @FkColumnOrig, @FkColumnDest 
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		IF (@PkFirst = 1) 
		BEGIN 
			SET @PkFirst = 0 
			SET @FKColumns = '' 
		END 
		ELSE 
		BEGIN 
			SET @FKSQL = @FKSQL + ', ' 
			SET @FKColumns = @FKColumns + ', ' 
		END 
 
		SET @FKSQL = @FKSQL + @FkColumnOrig 
		SET @FKColumns = @FKColumns + @FkColumnDest 
 
		FETCH NEXT FROM cFKCol INTO @FkColumnOrig, @FkColumnDest 
	END 
	CLOSE cFKCol 
	DEALLOCATE cFKCol 
 
	SET @FKSQL = 'IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID('''+ @FkName+''') AND parent_object_id = OBJECT_ID('''+@FkTable+'''))
BEGIN 
   ' + @FKSQL + ') REFERENCES ' + @FkTableRemote + '(' + @FKColumns + ')
END
GO' 
 
	-- Exibe o conteudo de CREATE da PK 
	PRINT @FKSQL 
	FETCH NEXT FROM cFK INTO @FkTable, @FkName, @FkTableRemote 
END 
CLOSE cFK 
DEALLOCATE cFK