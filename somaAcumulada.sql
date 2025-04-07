WITH cteA AS
 (
  SELECT row_number() over(order by YEAR(DATCOMPETEN), MONTH(DATCOMPETEN)) as numerador,
         MONTH(DATCOMPETEN) AS MES,
         YEAR(DATCOMPETEN)  AS ANO,
         SUM(QTDMOVTO * CASE ID_OPER WHEN '+' THEN 1 ELSE -1 END) AS QTDMOVTO,  
         SUM(VALMOVTO * CASE ID_OPER WHEN '+' THEN 1 ELSE -1 END) AS VALMOVTO
  FROM TBESTO004 E
  WHERE E.CODEMP = '01'
    AND E.CODMAT = '10000106'
  GROUP BY MONTH(DATCOMPETEN),
           YEAR(DATCOMPETEN)
 )
  SELECT 
         a.*,
         isnull((select a.QTDMOVTO + b.QTDMOVTO from cteA b where b.numerador = a.numerador-1),a.QTDMOVTO) as QTDACUM,
         f.QTDESTOQ,
         isnull((select a.VALMOVTO + b.VALMOVTO from cteA b where b.numerador = a.numerador-1),a.VALMOVTO) as VALACUM,
         f.VALESTOQ
  FROM cteA a
  LEFT JOIN (SELECT MONTH(DATPOSIC) AS MES,
                    YEAR(DATPOSIC)  AS ANO,
                    SUM(QTDESTOQ)   AS QTDESTOQ,  
                    SUM(VALESTOQ)   AS VALESTOQ
             FROM TBESTO007
             WHERE CODMAT = '10000106'
             GROUP BY  MONTH(DATPOSIC),YEAR(DATPOSIC)) AS f
         ON f.ANO = a.ANO
        AND f.MES = a.MES
