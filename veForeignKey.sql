SELECT CAST (t.name AS CHAR(10)) AS 'TABELA FILHO', 
       CAST (c.name AS CHAR(10)) AS 'CAMPO REFER.',
       CAST (target.name AS CHAR(10)) AS 'TABELA PAI', 
       CAST (targetc.name AS CHAR(10)) AS 'CAMPO CHAVE', 
       CAST(OBJECT_NAME(FK.constid) AS CHAR(30))   AS 'NOME CHAVE'
       
FROM 
    sysobjects t -- source table
    INNER JOIN syscolumns c ON t.id = c.id -- source column
    INNER JOIN sysconstraints co ON t.id = co.id AND co.colid = c.colid -- general constraint
    INNER JOIN sysforeignkeys fk ON co.constid = fk.constid -- foreign key constraint
    INNER JOIN sysobjects target ON fk.rkeyid = target.id -- target table
    INNER JOIN syscolumns targetc ON fk.rkey = targetc.colid AND fk.rkeyid = targetc.id -- target column
WHERE 
-- target.name = 'TBLFIS047'
 t.name = 'TBLFIS048'

