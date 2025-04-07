/*
Dynamic sql for convert SQL statement to txt/csv file
By Konstantin Taranov, 2016/12/09

EXECUTE [NIIGAZ].[dbo].[usp_bcpUnloadSelect]
    @outputFilePath  = 'd:\',
    @serverName      = '',
    @sqlCommand     = 'SELECT * FROM YourTable',
    @fileName        = '',
    @fieldTerminator = '|',
    @fileExtension = 'txt',
    @debug = 0;

@debug = 1 print only bcp command without executing it.
*/

IF OBJECT_ID('usp_bcpUnloadSelect', 'P') IS NULL 
   EXECUTE('CREATE PROCEDURE usp_bcpUnloadSelect AS SELECT 1');
GO

ALTER PROCEDURE usp_bcpUnloadSelect(
    @outputFilePath  VARCHAR(255),  -- The path can have from 1 through 255 characters, see documentation
    @serverName      SYSNAME      = @@SERVERNAME,
    @sqlCommand      VARCHAR(MAX),
    @fileName        VARCHAR(300) = '',
    @fieldTerminator VARCHAR(10)  = '|',
    @fileExtension   VARCHAR(10)  = 'txt',
    @codePage        VARCHAR(10)  = 'C1251',
    @debug           BIT          = 0
)
AS
/*--
Official bcp documentation: http://technet.microsoft.com/en-us/library/ms162802.aspx
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1;
GO
-- To update the currently configured value for advanced options.
RECONFIGURE;
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1;
GO
-- To update the currently configured value for this feature.
RECONFIGURE;
GO

EXECUTE [NIIGAZ].[dbo].[usp_bcpUnloadSelect]
    @outputFilePath  = 'd:\',
    @serverName      = '',
    @sqlCommand     = 'SELECT * FROM YourTable',
    @fileName        = '',
    @fieldTerminator = '|',
    @fileExtension = 'txt',
    @debug = 0;
--*/
BEGIN
    BEGIN TRY
        DECLARE @filePath    VARCHAR(2000) = @outputFilePath + 
                                             CASE WHEN @fileName = '' THEN 'bcp_export_' ELSE @fileName END +
                                             QUOTENAME(REPLACE(CONVERT(VARCHAR, GETDATE(), 126 ), ':', '_')) +
                                             '.' + @fileExtension;
        DECLARE @tsqlCommand VARCHAR(8000) = '';
        DECLARE @crlf        VARCHAR(10)   = CHAR(13) + CHAR(10);

        IF @debug = 0 SET NOCOUNT ON ELSE PRINT '/******* Start Debug' + @crlf;

        /* remove break lines from select statement*/
        SET @sqlCommand = REPLACE(REPLACE(@sqlCommand, CHAR(13), ' '), CHAR(10), ' ');
        /* remove break lines from select statement*/
        SET @sqlCommand = REPLACE(REPLACE(REPLACE(@sqlCommand,' ','<>'),'><',''),'<>',' ');

        IF @debug = 1
        PRINT ISNULL('@filePath = {' + @crlf + @filePath + @crlf + '}', '@filePath = {Null}' + @crlf)
        PRINT'@sqlCommand = {' + @crlf + @sqlCommand + @crlf + '}';

        SET @tsqlCommand = 'bcp "' + REPLACE(@sqlCommand, @crlf, ' ') + '" queryout "' + @filePath + '" -T -S ' + @serverName + ' -c -' + @codePage + ' -t"' + @fieldTerminator + '"' + @crlf;

        IF @debug = 1
        PRINT ISNULL( '@tsqlCommand = {' + @crlf + @tsqlCommand + '}' + @crlf, '@tsqlCommand = {Null}');
        ELSE
        EXECUTE xp_cmdshell @tsqlCommand;

        IF @debug = 0 SET NOCOUNT OFF ELSE PRINT @crlf + '--End Deubg*********/';
    END TRY

    BEGIN CATCH
        EXECUTE dbo.usp_LogError;
        EXECUTE dbo.usp_PrintError;
    END CATCH
END
go
