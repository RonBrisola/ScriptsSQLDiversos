DECLARE @tabela char(09)

-- Informe aqui o nome da tabela que terão as estatisticas excluidas
SET     @tabela = 'TBFATU018'

DECLARE tableStats CURSOR FOR
  select 'drop statistics ' + o.name + '.' + s.name AS IndexName
  from sys.stats s left join sys.objects o on o.object_id = s.object_id 
  where o.name = @tabela
    and s.name like '_WA%'
  order by o.name

OPEN tableStats
DECLARE @tablename sysname

FETCH NEXT FROM tableStats INTO @tablename
WHILE (@@FETCH_STATUS <> -1)
BEGIN
   EXEC (@tablename)
   FETCH NEXT FROM tableStats INTO @tablename
END
PRINT 'Estatisticas excluídas da tabela ' + @tabela 
DEALLOCATE tableStats

GO

exec sp_dboption 'BDTRADEnew', 'auto create statistics', 'false' 
GO
exec sp_dboption 'BDTRADEnew', 'auto update statistics', 'false' 
GO
