/* este script contém exemplos de 
   - DENSE_RANK(): numeração de registros agrupado por determinado campo,
   - CTE: commom table expression - fazer select de um select
   - calcular um valor no registro atual, verificando o registro anterior. 
     Neste caso é cálculo o número de dias que passou da emissão da nota anterior
*/

WITH cte AS
 (  
   --SELECT DATEMISSAO,
   --       ROW_NUMBER() over(ORDER BY DATEMISSAO) NId   
   --FROM (SELECT DISTINCT DATEMISSAO
   --      FROM TBFATU048) AS DAT
  select dense_rank() over (order by datemissao) as NId, datemissao, NUMNFSERV
  from TBFATU048
  )
  SELECT AVG(PRAZO) FROM (
  SELECT DISTINCT DATEDIFF(DAY , c1.DATEMISSAO, c2.DATEMISSAO) AS PRAZO, 
         c1.DATEMISSAO INICIO, c2.DATEMISSAO FIM
  FROM cte c1 LEFT JOIN cte c2 ON c1.NId + 1 = c2.NId
  --ORDER BY 2, 3
                         )  AS X

-- soma acumulada
with acum as
(
 SELECT ROW_NUMBER() over(ORDER BY NUMNFSERV, SERNFSERV) Id ,
        NUMNFSERV, SERNFSERV, VALTOTNF
 FROM TBFATU048
 )
 SELECT c1.NUMNFSERV, c1.SERNFSERV, c1.VALTOTNF, sum(c2.VALTOTNF) AS VALACUMULADO
 FROM acum c1
 LEFT JOIN acum c2 on c2.Id <= c1.Id
 GROUP BY c1.NUMNFSERV, c1.SERNFSERV, c1.VALTOTNF
 ORDER BY c1.NUMNFSERV, c1.SERNFSERV


