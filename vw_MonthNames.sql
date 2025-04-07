CREATE VIEW vw_MonthNames
AS
WITH CTEMonth
AS
(
      SELECT 1 AS MonNum
      UNION ALL
      SELECT MonNum + 1 -- add month number to 1 recursively
      FROM CTEMonth
      WHERE MonNum < 12 -- just to restrict the monthnumber upto 12
)
SELECT
      MonNum,
      DATENAME(MONTH,DATEADD(MONTH,MonNum,0)- 1)[MonthName] -- function to list the monthname.
FROM CTEMonth
