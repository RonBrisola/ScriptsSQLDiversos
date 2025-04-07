declare @data datetime = '20160731',
        @codemp char(02) = '01'

update tbgene035 set ULTANOFECH = cast(year(@data) as char(4)),
                     ULTMESFECH = case when month(@data) < 10 then '0' else '' end + cast(month(@data) as char(2)) 
where CODEMP = @codemp

insert into tbesto007
select
CODEMP,
CODALMOX, 
CODMAT,          
@data,
abs(sum(case m.TIPMOVTO when 'R' then qtdmovto* fator_oper else 0 end)) QTDCONSUMOMES,
abs(sum(case m.TIPMOVTO when 'V' then qtdmovto* fator_oper else 0 end)) QTDVENDASMES,
abs(sum(case m.TIPMOVTO when 'C' then qtdmovto* fator_oper else 0 end)) QTDCOMPRASMES,                            
abs(sum(case m.TIPMOVTO when 'O' then qtdmovto* fator_oper else 0 end)) QTDOUTROSMES,                            
sum(qtdmovto * fator_oper) as QTDESTOQ,
sum(valmovto * fator_oper) as valESTOQ,
sum(case m.TIPMOVTO when 'P' then qtdmovto else 0 end) QTDPRODUCAOMES,
abs(sum(case m.TIPMOVTO when 'R' then valmovto* fator_oper else 0 end)) VALCONSUMOMES,
abs(sum(case m.TIPMOVTO when 'V' then valmovto* fator_oper else 0 end)) VALVENDASMES,
abs(sum(case m.TIPMOVTO when 'C' then valmovto* fator_oper else 0 end)) VALCOMPRASMES,                            
abs(sum(case m.TIPMOVTO when 'O' then valmovto* fator_oper else 0 end)) VALOUTROSMES,                            
abs(sum(case m.TIPMOVTO when 'P' then valmovto* fator_oper else 0 end)) valPRODUCAOMES
from tbesto004 e, 
     tbesto002 m
where e.CODEMP = @codemp
and e.DATCOMPETEN <= @data
and m.CODMOVESTOQ = e.CODMOVESTOQ
group by CODEMP,
CODALMOX, 
CODMAT          


/*


--INSERT INTO TBESTO007 (CODEMP, CODALMOX, CODMAT, DATPOSIC, QTDESTOQ, VALESTOQ)
SELECT E.CODEMP,
       E.CODALMOX,
       E.CODMAT,
       Y.DATPOSIC,
       SUM(QTDMOVTO * (CASE ID_OPER WHEN '+' THEN 1 ELSE -1 END)) AS QTDMOVTO,
       SUM(VALMOVTO * (CASE ID_OPER WHEN '+' THEN 1 ELSE -1 END)) AS VALMOVTO
FROM TBESTO004 E,
(SELECT DISTINCT DATEADD(mm, 1, convert(datetime, CAST(YEAR(DATCOMPETEN)  AS CHAR(4)) + '/' + 
                                        CAST(MONTH(DATCOMPETEN) AS CHAR(2)) + '/' + '01', 111)) -1 AS DATPOSIC
 FROM TBESTO004                                        
 WHERE DATCOMPETEN > (SELECT MAX(DATPOSIC) FROM TBESTO007)                                        
   AND DATCOMPETEN < '01-DEC-2010') AS Y
WHERE E.DATCOMPETEN <= Y.DATPOSIC
GROUP BY  E.CODEMP,
       E.CODALMOX,
       E.CODMAT,
       Y.DATPOSIC  
ORDER BY 3, 2, 4

*/