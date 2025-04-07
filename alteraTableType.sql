EXEC sys.sp_rename 'dbo.typeTBMOV', 'ztypeTBMOV';
GO
CREATE TYPE typeTBMOV AS TABLE (
	IDMOV         int ,
	NUMDOCTO      varchar(20) ,
	SERDOCTO      varchar(5) ,
	CODEMITENTE   varchar(15) ,
	NUMITEM       varchar(5) ,
	CODMAT        varchar(15) ,
	CODLOTE       varchar(15) ,
	TIPOMOV       varchar(2) ,
	QTDE          decimal(28, 14) ,
	CODALMOX      varchar(3) ,
	CODALMOXDEST  varchar(3) ,
	UMVOLUME      varchar(2) ,
	QTDEVOLUME    decimal(28, 14) ,
	STAMOV        char(1) ,
	USER_ID       varchar(10), 
	QTDEINFORMADA   decimal(28, 14) ,
	QTDEJAINFORMADA decimal(28, 14) 
)
GO
DECLARE @Name NVARCHAR(776);

DECLARE REF_CURSOR CURSOR FOR
SELECT referencing_schema_name + '.' + referencing_entity_name
FROM sys.dm_sql_referencing_entities('dbo.typeTBMOV', 'TYPE');

OPEN REF_CURSOR;

FETCH NEXT FROM REF_CURSOR INTO @Name;
WHILE (@@FETCH_STATUS = 0)
BEGIN
    EXEC sys.sp_refreshsqlmodule @name = @Name;
    FETCH NEXT FROM REF_CURSOR INTO @Name;
END;

CLOSE REF_CURSOR;
DEALLOCATE REF_CURSOR;
GO
DROP TYPE dbo.ztypeTBMOV;
GO