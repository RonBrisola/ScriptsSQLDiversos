EXEC [sp_MSforeachtable] @command1="RAISERROR('DBCC DBREINDEX(''?'') ...',10,1) WITH NOWAIT DBCC DBREINDEX('?')"
