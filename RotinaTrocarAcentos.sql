SELECT * FROM TBCONB001


ÇüéâàçêÉôÜáíóúñÑªºÁÂÀãÃÊÍÓÔõÕÚ

SELECT * FROM TBGENE997

DELETE FROM TBCOMP996 WHERE NOMPARAM='Z_CHAVEACENTO'

SELECT * FROM TBCOMP996 WHERE NOMPARAM='Z_CHAVEACENTO'


INSERT INTO TBCOMP996 (CODEMP, NOMPARAM,DESPARAM, VALMAXPARAM,DATATUPARAM)
VALUES ('01', 'Z_CHAVEACENTO', 'ÇüéâàçêÉôÜáíóúñÑªºÁÂÀãÃÊÍÓÔõÕÚ', 0, GETDATE())


SELECT * FROM ACENTOS  
WHERE ASC_BDE  IN (SELECT ASC_SQL FROM ACENTOS)


SELECT * FROM ACENTOS  
WHERE ASC_SQL IN (SELECT ASC_BDE FROM ACENTOS)


SELECT * FROM ACENTOS    
order by ASC_BDE desc
                  
WHERE ASC_SQL IN (SELECT ASC_BDE FROM ACENTOS)

select ASC_BDE, count(*) from ACENTOS group by ASC_BDE order by 2 desc

drop table acentos


-- Cria tabela para gravar a relacionamento de código de acentos
CREATE TABLE ACENTOS (LETRA    CHAR(1),
                      LETRABDE CHAR(1),
                      ASC_BDE  INT,
                      ASC_SQL  INT)
GO


SELECT * FROM TBCOMP996 WHERE NOMPARAM='Z_CHAVEACENTO'

┼
--Rotina para alimentar a tabela ACENTAS com o texto com acentos
--gravado no campo EMAIL de algum cliente, através do próprio sistema (BDE)
SET TEXTSIZE 0
SET NOCOUNT ON

DECLARE @position    int, 
        @stringBDE   varchar(50),
        @stringsSQL  varchar(50),
        @Chave       varchar(20)
        
SET @Chave  = 'Z_CHAVEACENTO' -- ==> Indique aqui o código do cliente que tem o texto gravado     
SET @position     = 1
SET @stringsSQL   = 'áàâãéèêíìîóòôõúùûçñäëïüÁÀÂÃÉÈÊÍÌÎÓÒÔÕÚÙÛÇÑÄËÏÖÜ'
                   --ßÓÔÒÚÞÛÝý¯¾‗¶§·¨¹þ±õÙ´³┴└┬├╔╚╩═╠╬ËÊÈı┌┘█ÃÐ─╦¤Í▄
                   --ÓÔÒÚÛõÙËÊÈÃÍ

SELECT @stringBDE = DESPARAM FROM TBCOMP996 WHERE NOMPARAM=@Chave

WHILE @position <= LEN(@stringsSQL)
BEGIN
   INSERT INTO ACENTOS
   SELECT SUBSTRING(@stringsSQL, @position, 1),
          SUBSTRING(@stringBDE , @position, 1), 
          ASCII(SUBSTRING(@stringBDE, @position, 1)), 
          ASCII(SUBSTRING(@stringsSQL, @position, 1))  
   
    SET @position = @position + 1
END
SET NOCOUNT OFF
GO

-- Função que irá substituir os acentos
CREATE FUNCTION TrocaAcento(@Texto varchar(8000))
RETURNS varchar(8000) 
AS 
BEGIN
   DECLARE @letra char(1),
           @position Int ;

   SET @position   = 1;

   WHILE @position <= LEN(@Texto)
   BEGIN
      set @letra = NULL
      SELECT @letra = letra FROM acentos
      WHERE ASC_BDE = ASCII(SUBSTRING(@Texto, @position, 1));
	   
	  IF @letra IS NOT NULL 
	  BEGIN
         SET @Texto =  STUFF(@Texto, @position, 1, @letra)
	  END
     
     SET @position = @position + 1;
   END

   RETURN @Texto;
END
GO


SELECT STUFF('abc', 2, 1, 'd');

SELECT DBO.TrocaAcento('HortolÔndia')


SELECT DBO.TrocaAcento(EMAIL2)FROM TBFATU006 WHERE CODCLI = '000269'
UNION
SELECT EMAIL2 FROM TBFATU006 WHERE CODCLI = '000269'


SELECT * FROM SYSOBJECTS WHERE NAME LIKE 'T%'
AND xtype = 'U'
ORDER BY NAME

SELECT * FROM SYSOBJECTS WHERE NAME LIKE 'T%'
AND xtype = 'U'
ORDER BY NAME

/*
How to find names with accented letters?
Execute the following Microsoft SQL Server T-SQL scripts in SSMS Query Editor to find names with accent marks in an Accent Sensitive collation:
*/
 
SELECT DISTINCT FullName=FirstName + ' ' + LastName
FROM   Person.Contact
WHERE  FirstName + LastName LIKE N'%[~ñöÿþüý]%';
 
/*
FullName
Jaime Muñoz
Niñia Anand
Jose Muñoz
Jamie Muñoz
....
*/
 
USE AdventureWorks2008;
 
SELECT DISTINCT FullName=FirstName + ' ' + LastName
FROM   Person.Person
WHERE  FirstName + LastName LIKE N'%[àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ]%';
/*
FullName
Abby Kovár
Adrienne Jiménez
Albert Jiménez
....
*/


SELECT DATABASEPROPERTYEX('BDAGIW', 'Collation')
GO