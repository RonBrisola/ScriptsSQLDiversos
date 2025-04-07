-- Description: Turns a query into a formatted HTML table. Useful for emails. 
-- Any ORDER BY clause needs to be passed in the separate ORDER BY parameter.
-- =============================================
alter PROC [dbo].[spQueryToHtmlTable] 
(
  @query nvarchar(MAX), --A query to turn into HTML format. It should not include an ORDER BY clause.
  @orderBy nvarchar(MAX) = NULL, --An optional ORDER BY clause. It should contain the words 'ORDER BY'.
  @html nvarchar(MAX) = NULL OUTPUT --The HTML output of the procedure.
)
AS
BEGIN   
  SET NOCOUNT ON;

  IF @orderBy IS NULL BEGIN
    SET @orderBy = ''  
  END

  DECLARE @realQuery nvarchar(MAX) = '
    DECLARE @headerRow nvarchar(MAX);
    DECLARE @cols nvarchar(MAX);    

    SELECT * INTO #dynSql FROM (' + @query + ') sub;

    SELECT @cols = COALESCE(@cols + '', '''''''', '', '''') + ''['' + name + ''] AS ''''td''''''
    FROM tempdb.sys.columns 
    WHERE object_id = object_id(''tempdb..#dynSql'');

    SET @cols = ''SET @html = CAST(( SELECT '' + @cols + '' FROM #dynSql ' + @orderBy + ' FOR XML PATH(''''tr''''), ELEMENTS) AS nvarchar(max))''    

    EXEC sys.sp_executesql @cols, N''@html nvarchar(MAX) OUTPUT'', @html=@html OUTPUT

    SELECT @headerRow = COALESCE(@headerRow + '''', '''') + ''<th>'' + name + ''</th>'' 
    FROM tempdb.sys.columns 
    WHERE object_id = object_id(''tempdb..#dynSql'');

    SET @headerRow = ''<tr>'' + @headerRow + ''</tr>'';

    SET @html = ''<table border="1">'' + @headerRow + @html + ''</table>'';    
    ';

  EXEC sys.sp_executesql @realQuery, N'@html nvarchar(MAX) OUTPUT', @html=@html OUTPUT
END
GO


DECLARE @html  nvarchar(MAX), 
        @comando nvarchar(4000) 
EXEC spQueryToHtmlTable @html = @html OUTPUT,  @query = N'SELECT  top 10 CODMATCOMP, CODLOTE FROM TBFATU094 ', @orderBy = N'ORDER BY 1' --, @html = '';
select @html
SET @comando = 'bcp "SELECT ''' + @html +''' " queryout C:\TEMP\yteste.html -S vmserver\sql2008 -U SISCOMP -P SISCOMP -T -c'
EXEC master..xp_cmdshell @comando 

-- comando para executar a procedure e salvar o resultado num arquivo com extensão html
master..xp_cmdshell 'bcp "EXEC BDBIOMIN.dbo.procHtmlSql" queryout C:\TEMP\xteste.html -S vmserver\sql2008 -U SISCOMP -P SISCOMP -T -c', NO_OUTPUT

 DECLARE  @to varchar(255)      = 'ronaldobrisola@gmail.com',   
          @from varchar(255)    = 'ronaldo@agiw.com.br',
          @subject varchar(100) = 'Teste envio, por Blat'  ,
          @command as varchar(1500) = ''
 
  SET @command = @command + 'c:\Blat\Blat '              --executando blat.exe
  SET @command = @command + 'C:\TEMP\yteste.html'        --arquivo a ser anexado
  SET @command = @command + ' -to ' + '"' + @to + '"'    --email de destino
  SET @command = @command + ' -server smtp.agiw.com.br ' --servidor da conta de email 
  SET @command = @command + ' -u ' + @from               --usuário da conta de email
  SET @command = @command + ' -pw 12mnas34 '            --senha da conta de email
  SET @command = @command + ' -f ' + '"' + @from + '"'   --email do remetente 
  SET @command = @command + ' -subject ' + '"' + @subject + CONVERT(nvarchar(25), GETDATE()) + '"' --assundo do email
   
  EXEC master.dbo.xp_cmdshell @command                    --comando para executar o envio

