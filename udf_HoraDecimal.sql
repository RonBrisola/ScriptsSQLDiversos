SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ronaldo Brisola
-- Create date: 06/04/2017
-- Description:	Converte HoraMinuto para Decimal
-- =============================================
CREATE FUNCTION udf_HoraDecimal 
(
	-- Add the parameters for the function here
	@horaMinuto DECIMAL(28,14)
)
RETURNS DECIMAL(28,14)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result DECIMAL(28,14)

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = ROUND(@horaMinuto, 0, 1) +
                    ((@horaMinuto - ROUND(@horaMinuto, 0, 1)) / 0.6 ) 

	-- Return the result of the function
	RETURN @Result

END
GO

