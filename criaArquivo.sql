declare @sql varchar(8000)
select @sql = 'bcp "SELECT * FROM BDSANPHAR..TBGENE002" queryout \\Corvus\c$\unimake\UniNFe4\46256772000190\Envio\tbgene002.txt -c -t; -T '
exec master..xp_cmdshell @sql



declare @bcp  varchar(300),
        @sql  varchar(500), 
        @path char(100)

set @bcp = 'bcp "select ''<?xml version=""1.0"" encoding=""UTF-8""?><altConfUniNFe><GravarEventosNaPastaEnviadosNFe>True</GravarEventosNaPastaEnviadosNFe><GravarEventosCancelamentoNaPastaEnviadosNFe>True</GravarEventosCancelamentoNaPastaEnviadosNFe></altConfUniNFe>''" '

declare cEmp cursor
for select CAMINHOXMLENVIO from tbgene035

open cEmp
fetch next from cEmp into @path

while @@fetch_status = 0
begin
   if (@path is not null) and (@path <> '')
   begin
      set @sql = @bcp + ' queryout ' +
                 ltrim(rtrim(@path)) + '\uninfe-alt-con.xml -c -x -T '
      
      print @sql
      exec master..xp_cmdshell @sql 
   end
   
   fetch next from cEmp into @path
end

close cEmp
deallocate cEmp





exec master..xp_cmdshell @sql


select CAMINHOXMLENVIO from tbgene035

exec master..xp_cmdshell ' bcp'



exec master..xp_fixeddrives