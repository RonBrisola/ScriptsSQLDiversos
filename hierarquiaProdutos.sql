
DECLARE @codMatIni Char(15) = null,
        @codMatFim Char(15) = null,
        @revisao   Char(03) = null,
        @starev    Char(1)  = null

SET @codMatIni = '0000001'
SET @codMatFim = '0Z'

WITH cte_Expl 
    (CODMAT, CODMAT_PAI, HIERARQUIA, QTDE, Nivel, SEQ, Chave, REVISAO, FATOR_QTDE, Pai
     --, NrReg
     )
AS  (SELECT P.CODMAT,
            CAST(NULL AS CHAR(15)),
            CAST(P.CODMAT AS VARCHAR(200)) AS HIERARQUIA,
            P.QTDEFAB,
            1,
            CAST(NULL AS CHAR(3)) AS SEQ,
            CAST(RTRIM(P.CODMAT) + '-' + RTRIM(P.REVISAO) AS VARCHAR(500)) AS CHAVE,
            P.REVISAO,
            CAST(1 AS DECIMAL(28,14)) AS FATOR
            --Cast(Null as Integer) as Pai
            , ROW_NUMBER() over (order by P.CODMAT, P.REVISAO) AS Pai
            --CAST(dbo.udf_StrZero( ROW_NUMBER() over (order by P.CODMAT, P.REVISAO), 6) AS VARCHAR(300)) AS NrReg
     FROM   TBPROD010 P
     WHERE (@codMatIni IS NULL OR P.CODMAT >= @codMatIni) 
       AND (@codMatFim IS NULL OR P.CODMAT <= @codMatFim) 
       AND (@revisao   IS NULL OR P.REVISAO = @revisao) 
       AND (@starev    IS NULL OR P.STAREV  = @starev)


     UNION ALL
     SELECT P.CODMATCOMP,
            X.CODMAT,
            CAST(REPLICATE('| ',X.Nivel) + P.CODMATCOMP AS VARCHAR(200)) AS HIERARQUIA ,
            P.QTDECOMP,
            X.Nivel + 1,
            P.SEQ,
            CAST (X.Chave + '\' + RTRIM(P.SEQ) + '-'  + 
                                  RTRIM(P.CODMATCOMP) + 
                                  RTRIM(ISNULL('-'+P.REVCOMP, ''))  AS VARCHAR (500)),
            P.REVCOMP,
            P.FATOR,
            x.Pai
            --,Isnull(x.Pai, 0) + (ROW_NUMBER() over (order by P.SEQ, P.CODMATCOMP, P.REVCOMP)) AS NrReg

            --CAST(X.NrReg + dbo.udf_StrZero( ROW_NUMBER() over (order by P.SEQ, P.CODMATCOMP, P.REVCOMP), 6) AS VARCHAR(300))
     FROM   cte_Expl X
     INNER JOIN VW_ListaComp AS P
             ON P.CODMAT  = X.CODMAT
            AND P.REVISAO = X.REVISAO
    )
SELECT CAST(SUBSTRING(Chave, 1, CHARINDEX('-', Chave)-1) AS CHAR(15)) AS CODMAT_0,
       CAST(CASE WHEN CHARINDEX('\', Chave) <> 0 THEN
              REPLACE(SUBSTRING(Chave, CHARINDEX('-', Chave)+1, 3 ), '\','') 
           ELSE SUBSTRING(Chave, CHARINDEX('-', Chave)+1, 3)  END AS CHAR(03)) AS REVISAO_0,
       CODMAT_PAI, 
       CODMAT,
       QTDE,  
       FATOR_QTDE, 
       Nivel, 
       Chave, 
       HIERARQUIA, 
       REVISAO, Pai
FROM  cte_Expl
ORDER BY Chave

/*
select * 
into tmpExplMP
from VW_ExplMP
WHERE CODMAT_0 = '0000001'
ORDER BY Chave
*/
/*
SELECT SUBSTRING(myColumn, 1, CHARINDEX('/', myColumn)-1) AS FirstName,
       SUBSTRING(myColumn, CHARINDEX('/', myColumn) + 1, 1000) AS LastName
FROM   MyTable
*/

--SELECT * FROM TBPROD011
/*
USE BDINOVWAY_NOVO

CREATE VIEW VW_ListaComp
As
SELECT V.*,
       R.REVISAO AS REVCOMP,
       P.QTDEFAB,
       CAST(V.QTDECOMP / dbo.IsZero(P.QTDEFAB, 1) AS DECIMAL(28,14)) AS FATOR  
FROM VWPROD011 V
LEFT JOIN TBPROD010 R
       ON R.CODMAT = V.CODMATCOMP
      AND R.STAREV = 'S'
LEFT JOIN TBPROD010 P
       ON P.CODMAT  = V.CODMAT
      AND P.REVISAO = V.REVISAO


CREATE NONCLUSTERED INDEX INDTBPROD010_STAREV ON TBPROD010
(CODMAT , STAREV , REVISAO)

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX INDTBPROD011_REVISAO ON TBPROD011
(REVISAO   ,
 CODMAT    ,
 CODMATCOMP,
 QTDECOMP  ,
 SEQ       
)
GO

CREATE NONCLUSTERED INDEX INDTBPROD012_REVISAO ON TBPROD012
(REVISAO   ,
 CODMAT    ,
 CODMATCOMP,
 QTDECOMP  ,
 SEQ       
)
GO


use bdinovway
sp_msforeachdb ' select ''?'', * from ?..tbprod010 where QTDEFAB <> 1'
*/