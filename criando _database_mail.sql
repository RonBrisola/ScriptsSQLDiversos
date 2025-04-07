--Configura��es da Conta de e-mail que ser� respons�vel pelo envio dos e-mail
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = 'Email', --Nome da Conta
@description = 'Envio de Email', --Descri��o da Conta
@email_address = 'compras@soropack.com.br', --Endere�o de e-mail
@display_name = 'Liberacao Pedido de Compras', -- Nome de Excibi��o
@username='compras@soropack.com.br', --User name da conta
@password='######', --Senha da conta
@mailserver_name = 'smtp.soropack.com.br', --Servidor SMTP
@port = '587' --Porta SMTP


--Criando o Perfil de envio:
EXECUTE msdb.dbo.sysmail_add_profile_sp
@profile_name = 'Email', --Nome do Perfil de Envio
@description = 'Liberacao Pedido de Compras' --Descri��o do Perfil de Envio


--Vinculando o Perfil de envio com a conta 
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
@profile_name = 'Email', --Usar mesmo nome do Perfil criado acima
@account_name = 'Email', --Usar mesmo nome da Conta criada acima
@sequence_number = 1


--Setando como Perfil Principal
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@profile_name = 'Email', --Usar mesmo nome do Perfil criado acima
@principal_name = 'public',
@is_default = 1 ;

--Habilitando ou n�o o O SSL da conta
--Ensure SSL is enable, otherwise Gmail will complain.
use msdb
UPDATE sysmail_server 
SET enable_ssl = 0
--And send a mail with:

----habilitando servi�o do database mail
USE MASTER
GO
SP_CONFIGURE 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO
/* Enable Database Mail XPs Advanced Options in SQL Server */
SP_CONFIGURE 'Database Mail XPs', 1
RECONFIGURE WITH OVERRIDE
GO
SP_CONFIGURE 'show advanced options', 0
RECONFIGURE WITH OVERRIDE
GO


--Iniciando o servi�o de envio de e-mail
USE msdb;
GO
EXEC dbo.sysmail_start_sp;
GO

--criando corpo do e-mail
declare @body1 varchar(100)
set @body1 = 'Server :'+@@servername+ 'Liberacao Pedido de Compras' --corpo do e-mail

--enviando e-mail
EXEC msdb.dbo.sp_send_dbmail @recipients='ssouza@soropack.com.br;inunes@soropack.com.br', --destinat�rios separados por ponto e virgula
@subject = 'Liberacao Pedido de Compras', --assunto
@body = @body1,
@body_format = 'HTML';  --formato do email, text (padr�o) ou html
--@file_attachments = 'C:\SISINFOR\Boleto'; --anexos separados por ponto e virgula, com no mm�ximo 1mb e em um diret�rio sem restri��es de acesso


--verificando log do database mail
SELECT * FROM msdb.dbo.sysmail_event_log order by log_date
