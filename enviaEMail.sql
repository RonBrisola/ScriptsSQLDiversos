--Envie o resultado da query no corpo do email, como uma página HTML
DECLARE @ReportHTML  NVARCHAR(MAX);

SET @ReportHTML = '<html><body bgcolor=yellow>'+ 
    '<font size="5" face="tahoma">Lista de UFs</font>' +
    '<font size="3" face="tahoma"><table border="0">' +
                                 '<tr><th>UF</th>' +
                                 '<th>Nome</th>' +
                                 '<th>IBGE</th></tr>' +
    CAST((SELECT td = CODUF, '',
                 td = NOMUF, '',
                 td = CODUFIBGE, ''
          FROM TBGENE002    
          ORDER BY CODUF  
          FOR XML PATH('tr'), TYPE) 
    AS NVARCHAR(MAX) ) +
    '</table></font></body></html>' ;            
    
    
EXEC msdb.dbo.sp_send_dbmail 
     @recipients='ronaldo@agiw.com.br',
     @subject = 'Teste',  
     @body = @ReportHTML,
     @body_format = 'HTML',
     @profile_name='E-Mail SQL-Server';
    
    
--Envia o resultado de uma query como um anexo no email
EXEC msdb.dbo.sp_send_dbmail
     @recipients='ronaldo@agiw.com.br',
     @body='Message Body', 
     @subject ='Message Subject',
     @profile_name ='E-Mail SQL-Server',
     @query ='SELECT C.CODUF AS UF,
                     SUM(N.VALTOTNF) AS TotalVendas
              FROM BDFLEXTINTAS..TBFATU024 N LEFT JOIN BDFLEXTINTAS..TBFATU006 C ON C.CODCLI = N.CODCLI
              WHERE N.CODEMP = ''01''
                AND N.DATEMISSAO BETWEEN ''01-OCT-2011'' AND GETDATE()
                AND N.STANF <> ''C''
              GROUP BY C.CODUF          ', 
     @attach_query_result_as_file = 1,
     @query_attachment_filename ='Results.txt'
     --,@query_result_separator=';',
     --@query_result_no_padding=1    
