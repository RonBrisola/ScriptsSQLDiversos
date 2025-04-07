Create Table #dbInfo (dId smallint, dbName sysname, gId smallint NULL, segName varchar(256) NULL, 
       filName varchar(520) NULL, sizeMg decimal(10,2) null, 
       usedMg decimal(10,2) null, freeMg decimal(10,2) null, 
       pcntUsed decimal(10,2) null, pcntFree decimal(10,2) null)
Declare @sSql varchar(1000)
Set @sSql = 'Use [?];
Insert #dbInfo (dId, dbName, gid, segName, filName, sizeMg, usedMg)
Select db_id(), db_name(), groupid, rtrim(name), filename, Cast(size/128.0 As Decimal(10,2)), 
Cast(Fileproperty(name, ''SpaceUsed'')/128.0 As Decimal(10,2))
From dbo.sysfiles Order By groupId Desc;'
Exec sp_MSforeachdb @sSql
Update #dbInfo Set
freeMg = sizeMg - usedMg,
pcntUsed = (usedMg/sizeMg)*100,
pcntFree = ((sizeMg-usedMg)/sizeMg)*100

select * from #dbInfo compute sum(sizeMG),  sum(FreeMg) 
drop table #dbInfo