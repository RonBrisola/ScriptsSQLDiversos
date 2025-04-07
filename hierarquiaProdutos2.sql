SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ronaldo Brisola
-- Create date: 17/08/2018
-- Description:	Explosão completa da lista de componentes
-- =============================================
ALTER FUNCTION udf_ExplLista (@param1 CHAR(15), @param2 CHAR(15), @qtde decimal(28,14) )
RETURNS @Table_Var TABLE 
( SEQ        INTEGER IDENTITY(1,1), 
  SEQ_PAI    INTEGER, 
  CODMAT_0   char(15),      
  REVISAO_0  char(3),      
  CODMAT_PAI char(15),    
  CODMAT     char(15),        
  QTDE       decimal(28,14),            
  FATOR_QTDE decimal(28,14),      
  Nivel      int,               
  HIERARQUIA varchar (200),
  REVISAO    char (3)     ,
  SEQ_REG    VarChar (300) primary key )        

AS
BEGIN
   DECLARE @codMatIni Char(15) = null,
           @codMatFim Char(15) = null,
           @revisao   Char(03) = null,
           @starev    Char(1)  = null
   
   SET @codMatIni = NULLIF(RTRIM(LTRIM(@param1)),'')
   SET @codMatFim = @codMatIni
   SET @starev    = 'S'
   SET @qtde      = ISNULL(@qtde, 1)

   IF RTRIM(LTRIM(@param2)) <> ''
   BEGIN
      SET @param2 = RTRIM(LTRIM(@param2))
      IF LEN(@param2) <= 3
      BEGIN
         SET @revisao   = @param2
         SET @starev    = NULL
      END
      ELSE
      BEGIN
         SET @codMatFim = @param2
      END
   END

   WITH cte_Expl 
        (CODMAT, CODMAT_PAI, HIERARQUIA, QTDE, Nivel, SEQ_L, REVISAO, FATOR_QTDE, SEQ_REG )
    AS  (SELECT P.CODMAT,
                CAST(NULL AS CHAR(15)),
                CAST(P.CODMAT AS VARCHAR(200)) AS HIERARQUIA,
                CAST((@qtde + dbo.udf_FatorPerdaProd(P.CODMAT, @qtde)) AS DECIMAL(28,14)) , --P.QTDEFAB,
                0,
                CAST(NULL AS CHAR(3)) AS SEQ_L ,
                P.REVISAO,
                CAST((1 / P.QTDEFAB) AS DECIMAL(28,14)) AS FATOR,
                CAST(dbo.udf_StrZero( ROW_NUMBER() over (order by P.CODMAT, P.REVISAO), 6) AS VARCHAR(300)) AS SEQ_REG
         FROM   TBPROD010 P
         WHERE (@codMatIni IS NULL OR P.CODMAT >= @codMatIni) 
           AND (@codMatFim IS NULL OR P.CODMAT <= @codMatFim) 
           AND (@revisao   IS NULL OR P.REVISAO = @revisao) 
           AND (@starev    IS NULL OR P.STAREV  = @starev)
         UNION ALL
         SELECT P.CODMATCOMP,
                X.CODMAT,
                CAST(REPLICATE('| ',X.Nivel+1) + P.CODMATCOMP AS VARCHAR(200)) AS HIERARQUIA ,
                CAST( (P.QTDECOMP * X.QTDE) + 
                      CASE WHEN P.REVCOMP IS NOT NULL  
                           THEN dbo.udf_FatorPerdaProd(P.CODMATCOMP, (P.QTDECOMP * X.QTDE))
                           ELSE 0 END   AS DECIMAL(28,14)),
                X.Nivel + 1,
                P.SEQ SEQ_L,
                P.REVCOMP,
                P.FATOR,
                CAST(X.SEQ_REG + dbo.udf_StrZero( ROW_NUMBER() over (order by P.SEQ, P.CODMATCOMP, P.REVCOMP), 6) AS VARCHAR(300)) AS SEQ_REG
         FROM   cte_Expl X
         INNER JOIN VW_ListaComp AS P
                 ON P.CODMAT  = X.CODMAT
                AND P.REVISAO = X.REVISAO
        ),
    tmp As
        (SELECT *
         FROM  cte_Expl
    ) INSERT INTO @Table_Var
      SELECT null,
             null,
             null,
             CODMAT_PAI,
             CODMAT,
             QTDE, --@qtde * FATOR_QTDE,
             FATOR_QTDE,
             Nivel,
             HIERARQUIA,
             REVISAO,
             SEQ_REG
      FROM tmp tt
      ORDER BY SEQ_REG
      
      UPDATE T SET T.SEQ_PAI  = O.SEQ
      FROM @Table_Var T,
           @Table_Var O
      WHERE T.Nivel > 0 AND
        O.SEQ_REG = NULLIF(SUBSTRING(T.SEQ_REG, 1, 6 * (T.Nivel)), '')
      
      UPDATE T SET T.CODMAT_0  = O.CODMAT,
                   T.REVISAO_0 = O.REVISAO
      FROM @Table_Var T,
           @Table_Var O
      WHERE O.SEQ_REG = SUBSTRING(T.SEQ_REG, 1, 6)
	   
	 RETURN 
END
GO
use bdinovway_novo


with cus as (
SELECT X.*,
       M.CUSTOCOMPRA,                   
       P.PRECO      ,                   
       E.QTDESTOQ   ,                   
       E.VALESTOQ                            
FROM udf_ExplLista('0000001', '0ZZZZZZZ', 100) AS X
LEFT JOIN TBCOMP002 M ON M.CODMAT  = X.CODMAT
LEFT JOIN TBPROD061 P ON X.REVISAO IS NULL
      AND P.CODMAT    = X.CODMAT        
      AND P.CODSTDMAT = 'CUSTO'
LEFT JOIN (SELECT CODMAT,               
                  SUM(QTDESTOQ) AS QTDESTOQ,
                  SUM(VALESTOQ) AS VALESTOQ  
           FROM TBESTO003 E             
           WHERE CODEMP = '01'  
           GROUP BY CODMAT) AS E        
       ON X.REVISAO IS NULL
      AND E.CODMAT = X.CODMAT           
)
select * 
from cus
where revisao is not null --CODMAT_PAI = '2030071'
ORDER BY nivel DESC, CODMAT 
--REVISAO is not null
--order by nivel desc, CODMAT, SEQ_PAI desc

        SEQ     SEQ_PAI CODMAT_0        REVISAO_0 CODMAT_PAI      CODMAT                                             QTDE                              FATOR_QTDE       Nivel HIERARQUIA                                                                                                                                                                                               REVISAO SEQ_REG                                                                                                                                                                                                                                                                                                                                  CUSTOCOMPRA                                   PRECO                                QTDESTOQ                                VALESTOQ
----------- ----------- --------------- --------- --------------- --------------- --------------------------------------- --------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ --------------------------------------- --------------------------------------- --------------------------------------- ---------------------------------------
       7529        7528 0AK965RV        004       3032086         2030071                              200.00000000000000                        1.00000000000000           3 | | | 2030071                                                                                                                                                                                            002     000620000006000003000001                                                                                                                                                                                                                                                                                                            0.00000000000000                                    NULL                                    NULL                                    NULL



SEQ_PAI desc


SELECT * FROM  udf_ExplLista('0000001', '0000002', 1)
where (REVISAO is null or nivel = 0)
order by SEQ_REG

select * from tbprod061

SELECT * FROM  udf_ExplLista(NULL, NULL, 101)

SELECT * FROM TBPROD221
UPDATE TBPROD221 SET REVISAO = '01', QTDEINICIALPROD = 100, 
QTDEAMAISPRODACABADO = 10, --NULL,
PERCAMAISPRODACABADO = null
WHERE REVISAO = '01'

UPDATE TBPROD221 SET REVISAO = '001'
WHERE REVISAO = '002'

declare @t decimal(28, 14) = 100
SELECT @t + DBO.udf_FatorPerdaProd('0000001', @t), DBO.udf_FatorPerdaProd('0000001', @t)

SELECT * FROM TBESTO003 WHERE CODMAT = '1030082'
SELECT M.CUSTOCOMPRA,                   
       P.PRECO      ,                   
       E.QTDE       ,                   
       E.VAL                            
FROM      TBCOMP002 M                   
LEFT JOIN TBPROD061 P                   
       ON P.CODMAT    = M.CODMAT        
      AND P.CODSTDMAT = :ParCodStdMat   
LEFT JOIN (SELECT CODMAT,               
                  SUM(QTDESTOQ) AS QTDE,
                  SUM(VALESTOQ) AS VAL  
           FROM TBESTO003 E             
           WHERE CODEMP = :ParCodEmp    
           GROUP BY CODMAT) AS E        
       ON E.CODMAT = M.CODMAT           
 WHERE M.CODMAT    = :ParCodMat         



   DECLARE @codMatIni Char(15) = NULL,
           @codMatFim Char(15) = NULL,
           @revisao   Char(03) = NULL,
           @starev    Char(1)  = NULL,
           @param1    CHAR(15), 
           @param2    CHAR(15)

   PRINT ISNULL(@codMatIni, 'NULL')
   PRINT ISNULL(@codMatFim, 'NULL')
   PRINT ISNULL(@revisao  , 'NULL')
   PRINT ISNULL(@starev   , 'X')
   PRINT '--'
   
   SET @param1 = '0000001'
   SET @param2 = '0ZZZZZZ'

   SET @codMatIni = NULLIF(RTRIM(LTRIM(@param1)),'')
   SET @codMatFim = @codMatIni
   SET @starev    = 'S'

   IF RTRIM(LTRIM(@param2)) <> ''
   BEGIN
      SET @param2 = RTRIM(LTRIM(@param2))
      IF LEN(@param2) <= 3
      BEGIN
         SET @revisao   = @param2
         SET @starev    = NULL
      END
      ELSE
      BEGIN
         SET @codMatFim = @param2
         --SET @starev    = 'S'
      END
   END

   --SET @starev = ISNULL(@revisao, 'S')

   PRINT ISNULL(@codMatIni, 'NULL')
   PRINT ISNULL(@codMatFim, 'NULL')
   PRINT ISNULL(@revisao  , 'NULL')
   PRINT ISNULL(@starev   , 'X')
