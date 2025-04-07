SELECT
    OBJECT_NAME(c.object_id) as 'Table Name',
    c.name 'Column Name',
    t.Name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL('ALTER TABLE ' + OBJECT_NAME(c.object_id) + ' DROP ' + d.name + '||', '')+
    ISNULL('ALTER TABLE ' + OBJECT_NAME(c.object_id) + ' ALTER COLUMN ' + c.name + ' NUMERIC(28,14) ||', '') +
    ISNULL('ALTER TABLE ' + OBJECT_NAME(c.object_id) + ' ADD DEFAULT ' + d.definition + ' FOR ' +  c.name + '||', '') 
    AS tsqlADD
FROM      sys.columns c INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints d
       ON d.parent_object_id = c.object_id
      AND d.parent_column_id = c.column_id
WHERE OBJECT_NAME(c.object_id) LIKE 'TB%'
AND t.Name in ('float')
