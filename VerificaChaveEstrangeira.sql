SELECT cast(f.name as Char(30)) AS ForeignKey,
       cast(OBJECT_NAME(f.parent_object_id)      as char(20))  AS TabelaOrigem,
       cast(COL_NAME(f.parent_object_id,fc.parent_column_id) as char(20)) AS CampoReferenciado,
       cast(OBJECT_NAME (f.referenced_object_id) as char(20)) AS TabelaReferenciada,
       cast(COL_NAME(fc.referenced_object_id,fc.referenced_column_id) as char(20)) AS CampoTabelaReferencia
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
WHERE OBJECT_NAME (f.referenced_object_id) = 'TBFATU006'  -- <== indforme a tabela


SELECT distinct 'delete from ' + 
OBJECT_NAME(f.parent_object_id) AS TableName
--,f.name AS ForeignKey,
--SCHEMA_NAME(o.SCHEMA_ID) ReferenceSchemaName,
--OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName,
--COL_NAME(fc.referenced_object_id,fc.referenced_column_id) AS ReferenceColumnName
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
INNER JOIN sys.objects AS o ON o.OBJECT_ID = fc.referenced_object_id
WHERE OBJECT_NAME (f.referenced_object_id) = 'TBGENE023'
GO

