--- envio de email pela trigger
CREATE TRIGGER whatever ON tbgene002
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;

        EXEC msdb.dbo.sp_send_dbmail
          @recipients = 'kleber@agiw.com.br;ronaldo@agiw.com.br', 
          @profile_name = 'email',
          @subject = 'teste pela trigger', 
          @body = 'outro  registro';
END
GO

--enviando resultado de uma query no email
EXEC msdb.dbo.sp_send_dbmail
      @profile_name = 'email',
      @recipients = 'ronaldo@agiw.com.br',
      @subject = 'T-SQL Query Result',
      @body = 'The result from SELECT is appended below.',
      @execute_query_database = 'BDIBRASA',
      @query = 'SELECT * FROM TBGENE002',
      @attach_query_result_as_file = 1 ;  -- <-- se estiver 0 ou não informado o resultado vai no corpo
                                          --     se 1 vai como anexo 


/************* Enviando email como HTML *************/
-- Email Querry--
DECLARE @Body varchar(max)
declare @TableHead varchar(max)
declare @TableTail varchar(max)
declare @mailitem_id as int
declare	@statusMsg as varchar(max)
declare	@Error as varchar(max) 
declare	@Note as varchar(max)

Set NoCount On;
set @mailitem_id = null
set @statusMsg = null
set @Error = null
set @Note = null
Set @TableTail = '</table></body></html>';

--HTML layout--
Set @TableHead = '<html><head>' +
'<H1 style="color: #000000">LISTA DE UFs</H1>' +
'<style>' +
'td {border: solid black 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font-size:9pt;color:Black;} ' +
'</style>' +
'</head>' +
'<body><table cellpadding=0 cellspacing=0 border=0>' +
'<tr bgcolor=#F6AC5D>'+
'<td align=center><b>CoduF</b></td>' + 
'<td align=center><b>NomUf</b></td></tr>';

--Select information for the Report-- 
Select @Body= (Select CODUF As [TD], NOMUF As [TD] FROM TBGENE002
For XML raw('tr'), Elements)

-- Replace the entity codes and row numbers
Set @Body = Replace(@Body, '_x0020_', space(1))
Set @Body = Replace(@Body, '_x003D_', '=')
Set @Body = Replace(@Body, '<tr><TRRow>1</TRRow>', '<tr bgcolor=#C6CFFF>')
Set @Body = Replace(@Body, '<TRRow>0</TRRow>', '')


Set @Body = @TableHead + @Body + @TableTail

-- return output--
Select @Body

--Email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name ='email',
@mailitem_id = @mailitem_id out,
@recipients='ronaldo@agiw.com.br',
@subject = 'subject Email',
@body = @Body,
@body_format = 'HTML'; 

/************  FIM HTML *****************/