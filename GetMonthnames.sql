CREATE PROCEDURE Usp_GetMonthnames
AS
BEGIN
      SET NOCOUNT ON;
     
      SELECT
            MonNum,
            [MonthName]
      FROM vw_MonthNames -- call the CTE view
END
