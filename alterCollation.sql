DECLARE @TableName nvarchar(255),
        @ColumnName nvarchar(255),
        @SQLText nvarchar(255),
        @DataType nvarchar(255),
        @CharacterMaxLen nvarchar(255),
        @IsNullable nvarchar(255),
        @CollationName nvarchar(255)

set @CollationName = 'SQL_Latin1_General_CP850_CI_AI'

DECLARE MyTableCursor Cursor
FOR 
SELECT name FROM SYSOBJECTS
WHERE XTYPE ='u'
AND name like 'TB%'
OPEN MyTableCursor

FETCH NEXT FROM MyTableCursor INTO @TableName
WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE MyColumnCursor Cursor
        FOR 
        SELECT COLUMN_NAME,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
            IS_NULLABLE from information_schema.columns
            WHERE table_name = @TableName AND  (Data_Type LIKE '%char%' 
            OR Data_Type LIKE '%text%') AND COLLATION_NAME <> @CollationName
            ORDER BY ordinal_position 
        Open MyColumnCursor

        FETCH NEXT FROM MyColumnCursor INTO @ColumnName, @DataType, 
              @CharacterMaxLen, @IsNullable
        WHILE @@FETCH_STATUS = 0
            BEGIN
            SET @SQLText = 'ALTER TABLE ' + @TableName + ' ALTER COLUMN [' + @ColumnName + '] ' + 
              @DataType + '(' + CASE WHEN @CharacterMaxLen = -1 THEN 'MAX' ELSE @CharacterMaxLen END + 
              ') COLLATE ' + @CollationName + ' ' + 
              CASE WHEN @IsNullable = 'NO' THEN 'NOT NULL' ELSE 'NULL' END
            PRINT @SQLText 

        FETCH NEXT FROM MyColumnCursor INTO @ColumnName, @DataType, 
              @CharacterMaxLen, @IsNullable
        END
        CLOSE MyColumnCursor
        DEALLOCATE MyColumnCursor

FETCH NEXT FROM MyTableCursor INTO @TableName
END
CLOSE MyTableCursor
DEALLOCATE MyTableCursor

ALTER TABLE TBGENE002 DROP CONSTRAINT PKTBGENE002
ALTER TABLE TBGENE002 ALTER COLUMN [CODUF] char(2) COLLATE SQL_Latin1_General_CP850_CI_AI NOT NULL
ALTER TABLE TBGENE002 ADD CONSTRAINT PKTBGENE002 PRIMARY KEY(CODUF)
ALTER TABLE TBGENE002 ALTER COLUMN [NOMUF] char(30) COLLATE SQL_Latin1_General_CP850_CI_AI NOT NULL
ALTER TABLE TBGENE002 ALTER COLUMN [CODSINIEF] char(3) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBGENE002 ALTER COLUMN [CODUFIBGE] char(2) COLLATE SQL_Latin1_General_CP850_CI_AI NULL

ALTER TABLE TBMOV ALTER COLUMN [NUMDOCTO] varchar(20) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [SERDOCTO] varchar(5) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [CODEMITENTE] varchar(15) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [NUMITEM] varchar(5) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [CODMAT] varchar(15) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [CODLOTE] varchar(15) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [TIPOMOV] varchar(2) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [CODALMOX] varchar(3) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [CODALMOXDEST] varchar(3) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBMOV ALTER COLUMN [UMVOLUME] varchar(2) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBTIPOMOV ALTER COLUMN [TIPOMOV] varchar(2) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBTIPOMOV ALTER COLUMN [DESCMOV] varchar(30) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
ALTER TABLE TBTIPOMOV ALTER COLUMN [ID_OPER] varchar(1) COLLATE SQL_Latin1_General_CP850_CI_AI NULL
