-- procedure para executar a query
CREATE PROCEDURE [dbo].[procHtmlSql] AS
BEGIN
   WITH htmlresult AS (
      SELECT ROW_NUMBER() OVER (ORDER BY I.NUMITEMPED) AS RowNumber,  --seleciona os dados da tabela,
             '<td>' + I.NUMITEMPED    + '</td>'+                         --formatando uma grid html
             '<td>' + I.CODMAT        + '</td>'+
				 '<td>' + RTRIM(M.DESMAT) + '</td>'+
				 '<td align=right>' + dbo.udf_FormataNumero(I.VALTOT,2) + '</td>'+
				 '<td align=right>' + dbo.udf_FormataNumero(I.PERCACRESDESCITEM,5)+ '</td>' AS HtmlData
		FROM TBFATU013 I
		INNER JOIN TBCOMP002 M ON M.CODMAT = I.CODMAT
		WHERE i.CODEMP = '90'
		  AND i.NUMPED = '000157'
      )
   SELECT 
'<style type="text/css">
.myTable { border-collapse:collapse;font-family:Tahoma;color:black;font-size:12px; }
.myTable th { background-color:#5D7B9D;color:white; }
.myTable td, .myTable th { padding:5px;border:1px solid #5D7B9D; }
.myTable td { line-height:1.2em; }
</style>
<html><head><title></title></head>
<body><br><br>
<table class="myTable">
<th>Item</th><th>Produto</th><th>Descrição</th><th>Valor</th><th>Desconto</th></tr>' AS HtmlData              --cabeçalho da grid  
   UNION ALL
   SELECT HtmlData = CASE RowNumber%2
                        WHEN 0 THEN '<tr style="background-color: #F7F6F3">' + HtmlData + '</tr>'
                        ELSE '<tr>' + HtmlData + '</tr>'
                     END                                       -- para "zebrar" as linhas da grid
   FROM htmlresult
   UNION ALL
   SELECT '</table></body></html>'
END

-- comando para executar a procedure e salvar o resultado num arquivo com extensão html
master..xp_cmdshell 'bcp "EXEC BDBIOMIN.dbo.procHtmlSql" queryout C:\TEMP\xteste.html -S vmserver\sql2008 -U SISCOMP -P SISCOMP -T -c', NO_OUTPUT

 DECLARE  @to varchar(255)      = 'ronaldobrisola@gmail.com',   
          @from varchar(255)    = 'ronaldo@agiw.com.br',
          @subject varchar(100) = 'Teste envio, por Blat'  ,
          @command as varchar(1500) = ''
 
  SET @command = @command + 'c:\Blat\Blat '              --executando blat.exe
  SET @command = @command + 'C:\TEMP\xteste.html'        --arquivo a ser anexado
  SET @command = @command + ' -to ' + '"' + @to + '"'    --email de destino
  SET @command = @command + ' -server smtp.agiw.com.br ' --servidor da conta de email 
  SET @command = @command + ' -u ' + @from               --usuário da conta de email
  SET @command = @command + ' -pw ********* '            --senha da conta de email
  SET @command = @command + ' -f ' + '"' + @from + '"'   --email do remetente 
  SET @command = @command + ' -subject ' + '"' + @subject + CONVERT(nvarchar(25), GETDATE()) + '"' --assundo do email
   
  EXEC master.dbo.xp_cmdshell @command                    --comando para executar o envio