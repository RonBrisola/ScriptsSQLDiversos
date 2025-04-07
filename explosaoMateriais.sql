with Hierarchy 
 AS
 (
    -- anchor member
    SELECT L.CODMAT, L.REVISAO, CAST(NULL AS CHAR(15)) AS CODMATCOMP,
           L.QTDEFAB, 0 AS Level
    FROM TBPROD010 L 
    WHERE CODMAT = '10110003'
      AND REVISAO = '002'
    UNION ALL
     -- recursive members
    SELECT D.CODMAT, D.REVISAO, D.CODMATCOMP,
           D.QTDECOMP, Level + 1 AS Level   
    FROM TBPROD011 D 
    INNER JOIN Hierarchy H ON H.CODMAT  = D.CODMAT 
                          AND H.REVISAO = D.REVISAO
    
 )
 SELECT * FROM Hierarchy

 