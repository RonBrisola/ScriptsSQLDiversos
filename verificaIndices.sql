DECLARE @tabela char(30)

set @tabela = 'TBFATU185'   -- <=== Informe aqui a tabela que deseja verificar

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
WHERE t.name = @tabela
) SELECT *, 
         'DROP INDEX '   + Tabela + '.' + Nome_Indice  AS sqlDROP,
         'CREATE INDEX ' + Nome_Indice + ' ON ' + Tabela + ' ('+ Campos_Indice + ')' AS sqlCREATE
  FROM cteIDX
  ORDER BY Tabela,
           Nome_Indice


SELECT Cast(fk.name as VarChar(40))                                                      AS ForeignKey,
       Cast(OBJECT_NAME(fk.parent_object_id) as VarChar(40))                             AS Tabela,
       Cast(COL_NAME(fkc.parent_object_id, fkc.parent_column_id) as VarChar(40))         AS CampoChave,
       Cast(OBJECT_NAME (fk.referenced_object_id) as VarChar(40))                        AS TabelaReferenciada,
       Cast(COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) as VarChar(40)) AS CampoReferenciado
FROM       sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fkc
        ON fk.OBJECT_ID = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id)  = @tabela
ORDER BY Tabela

