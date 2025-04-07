SELECT ' ALTER TABLE '    + t.name + 
       ' ADD CONSTRAINT ' + OBJECT_NAME(FK.constid) +
       ' FOREIGN KEY ('   + c.name + ')' +
       ' REFERENCES '     + target.name + '(' + targetc.name + ')'
FROM 
    sysobjects t -- source table
    INNER JOIN syscolumns c ON t.id = c.id -- source column
    INNER JOIN sysconstraints co ON t.id = co.id AND co.colid = c.colid -- general constraint
    INNER JOIN sysforeignkeys fk ON co.constid = fk.constid -- foreign key constraint
    INNER JOIN sysobjects target ON fk.rkeyid = target.id -- target table
    INNER JOIN syscolumns targetc ON fk.rkey = targetc.colid AND fk.rkeyid = targetc.id -- target column
WHERE target.name = 'TBCOMP002'
