ALTER PROCEDURE uspParamGeral( @tabela  VARCHAR(30))
AS 
BEGIN
  --generic solution
  DECLARE @sql     VARCHAR(max),
          @emp     VARCHAR(max)
        
  SET @sql=''
  SELECT @sql=@sql + 'SELECT CODEMP,'''+Name+''' as Par,cast('+Name+' as varchar(100)) as Val FROM '+ @tabela + ' union 
' 
  FROM sys.columns 
  where  object_id=object_id(@tabela)
    AND name <> 'CODEMP'

  SET @emp=''
  SELECT @emp=@emp+'MAX(CASE CODEMP WHEN '''+CODEMP+''' THEN VAL ELSE '''' END ) AS '''+ CODEMP+''',
'
  FROM TBGENE032 

  SET @sql = LEFT(@sql,LEN(@sql)-8)  -- except last 'union all'
  SET @emp = LEFT(@emp,LEN(@emp)-3)  -- except last ,'
  --print @sql
  --print @emp
 
  EXEC( ' SELECT par, ' + @emp +
        ' FROM ( ' + 
        @sql +
        ') AS X GROUP BY par')
END
GO


uspParamGeral 'TBLFIS999'