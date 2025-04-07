SELECT TOP 15 CODEMP, NUMNF, SERNF 
INTO ##tmpNFe
FROM TBFATU024
WHERE DATEMISSAO > '2017-01-01'

DECLARE @codEmp VARCHAR(10),
        @numNF  VARCHAR(10),
        @serNF  VARCHAR(10)
DECLARE @querytextNoVid VARCHAR(1000)
DECLARE @querytext      VARCHAR(1000)
DECLARE @filelocation   VARCHAR(1000)
DECLARE @cmd            VARCHAR(1000)

DECLARE nfCursor CURSOR FOR SELECT * FROM ##tmpNFe
OPEN nfCursor
FETCH NEXT FROM nfCursor INTO @codEmp, @numNF, @serNF

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @filelocation = '"c:\sisinfor\temp\nfe' + @numNF + '.xml"'
    SET @codEmp = QUOTENAME(RTRIM(LTRIM(@codEmp)),'''')
    SET @numNF  = QUOTENAME(RTRIM(LTRIM(@numNF)) ,'''')
    SET @serNF  = QUOTENAME(RTRIM(LTRIM(@serNF)) ,'''')
    SET @querytext = '"SELECT TOP 1 XMLDISTRIBUICAO FROM BDSANPHAR..TBFATU152 WHERE CODEMP = ' + @codEmp + ' AND NUMNF = ' + @numNF ++ ' AND SERNF = ' + @serNF + '"'
    SET @cmd = 'bcp ' + @querytext + ' queryout ' + @filelocation + ' -T -c '
    print @cmd 
    EXEC  master..XP_CMDSHELL @cmd 
    FETCH NEXT FROM nfCursor INTO @codEmp, @numNF, @serNF
END
CLOSE nfCursor
DEALLOCATE nfCursor

DROP TABLE ##tmpNFe

