DECLARE @codStdMat char(03),
        @Descricao Char(40),
        @str       Varchar(MAX) = ''

DECLARE cur CURSOR FOR
SELECT TOP 20 CODSTDMAT, '[' + RTRIM(DESCRICAO) + ']' AS DESCRICAO FROM TBPROD060           

OPEN cur
FETCH cur INTO @codStdMat, @Descricao

WHILE (@@FETCH_STATUS <> -1)
BEGIN
   SET @str = @str + CHAR(13) + ' , ' +
              RTRIM(@Descricao)  + ' = MAX(CASE WHEN P.CODSTDMAT = ''' + @codStdMat + ''' THEN P.PRECO ELSE NULL END)' 

   FETCH cur INTO @codStdMat, @Descricao
   CONTINUE

END

CLOSE cur
DEALLOCATE cur

SET @str = ' SELECT P.CODMAT ' + @str + CHAR(13) +
           ' FROM TBPROD061 P GROUP BY P.CODMAT'
PRINT @str

EXEC(@str)
        
  