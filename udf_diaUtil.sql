USE [BDEVANCE]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_DIAUTIL]    Script Date: 21/06/2018 10:42:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_DIAUTIL] (
  @DATE      DATE,
  @NDAYS     INT   
) RETURNS DATE     
BEGIN         

       IF @DATE IS NULL
         BEGIN       
           SET @DATE = GETDATE();
         END

       DECLARE @STARTDATE  INT  = 0
       DECLARE @COUNT      INT  = 0
       DECLARE @NEWDATE    DATE = DATEADD(DAY, 1, @DATE)                                         

       WHILE @COUNT < @NDAYS 
        BEGIN 
          IF DATEPART(WEEKDAY, @NEWDATE) NOT IN (7, 1) 
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '1 1' --REVEILLON
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '214' --TIRADENTES
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '1 5' --TRABALHO
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '9 7' --REV.CONSITUCIONALISTA
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '7 9' --INDEPENDENCIA
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '1210' --N.S.APARECIDA
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '2 11' --FINADOS
             AND ( CAST(DAY(@NEWDATE) AS CHAR(02)) + CAST(MONTH(@NEWDATE) AS CHAR(02))) <> '2512' --NATAL
             AND @NEWDATE NOT IN ( SELECT DATFERIADO FROM TBGENE020 )
              
            SET @COUNT += 1;
            SELECT @NEWDATE = DATEADD(DAY, 1, @NEWDATE), @STARTDATE += 1;
        END 

        RETURN DATEADD(DAY, @STARTDATE, @DATE);
  END 

--SELECT CAST (DAY('02-NOV-2015') AS CHAR(02)) + CAST( MONTH('02-NOV-2015')AS CHAR(02))

--SELECT * FROM TBGENE020
GO


