CREATE FUNCTION dbo.HierarchyTraversal
(
    @Levels      INT
    ,@TopLevel   INT
)
RETURNS @H TABLE
(
     NIVEL   INT
    , CODMAT CHAR(15)
    , CODMAT CHAR(15)
    ,MgrEmp  VARCHAR(8000)
)
AS BEGIN
    IF @Levels > 0
        INSERT INTO @H
        -- The top level manager
        SELECT 1, ManagerID, EmployeeID
            ,CAST(ManagerID AS VARCHAR(8000)) + '/' + CAST(EmployeeID AS VARCHAR(8000))
        FROM dbo.ManagersDirectory
        WHERE ManagerID = @TopLevel
       
        UNION ALL
       
        -- The remainder of the hierarchy
        SELECT [Level]+1, a.ManagerID, a.EmployeeID
            ,MgrEmp + '/' + CAST(a.EmployeeID AS VARCHAR(8000))
        FROM dbo.ManagersDirectory a
        JOIN dbo.HierarchyTraversal(@Levels-1, @TopLevel) b ON b.EmployeeID = a.ManagerID;
    RETURN
END


SELECT L.CODMAT, L.REVISAO, L.CODMATCOMP,
       L.QTDECOMP, L.QTDECONSUMOFIXO  
FROM TBPROD011 L 

SELECT * FROM TBPROD010

with Hierarchy --(Id, ParentId, AbsoluteUrl, Level)
 AS
 (
    -- anchor member
    SELECT L.CODMAT, L.REVISAO, CAST(NULL AS CHAR(15)) AS CODMATCOMP,
           L.QTDEFAB, 0 AS Level
    FROM TBPROD010 L 
    WHERE CODMAT = '50120002'
      AND REVISAO = '001'
    UNION ALL
     -- recursive members
    SELECT D.CODMAT, D.REVISAO, D.CODMATCOMP,
           D.QTDECOMP, Level + 1 AS Level   
    FROM TBPROD011 D 
    INNER JOIN Hierarchy H ON H.CODMAT  = D.CODMAT 
                          AND H.REVISAO = D.REVISAO
    
 )
 SELECT * FROM Hierarchy

 WHERE CODMAT = '50120002'
 AND REVISAO = '001'



SELECT P.CODMAT, P.REVISAO, P.CODMATCOMP, P.QTDECOMP, F.CODMATCOMP
       --, Level + 1 AS Level   
FROM TBPROD011 P 
LEFT JOIN TBPROD011 F
       ON F.CODMAT = P.CODMATCOMP 
WHERE P.CODMAT = '50120002'

ShowHierarchy '50120002'

ALTER PROC dbo.ShowHierarchy
(
	@Root char(15)
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @codMat char(15), 
           @desMat char(30)

	SET @desMat = (SELECT DESMAT FROM TBCOMP002 WHERE CODMAT = @Root)
	PRINT REPLICATE('| ', (@@NESTLEVEL-1) * 1) + @desMat

	SET @codMat = (SELECT MIN(CODMATCOMP) FROM TBPROD011 WHERE CODMAT = @Root)

	WHILE @codMat IS NOT NULL
	BEGIN
		EXEC dbo.ShowHierarchy @codMat
		SET @codMat = (SELECT MIN(CODMATCOMP) FROM TBPROD011 WHERE CODMAT = @Root AND CODMATCOMP > @codMat)
	END
END
GO
