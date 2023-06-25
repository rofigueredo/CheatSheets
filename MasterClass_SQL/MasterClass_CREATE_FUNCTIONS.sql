USE AdventureWorks2019;
GO
---  EJERCICIO 1
ALTER FUNCTION dbo.ufPorcentajeEntero(@Numerador INT, @Denominador INT)
RETURNS VARCHAR(8)
AS 
BEGIN
	DECLARE @Decimal FLOAT  = (@Numerador * 1.0) / @Denominador

	RETURN FORMAT(@Decimal, 'P')
END

DECLARE @MaxVacationHours INT = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

SELECT
	BusinessEntityID,
	JobTitle,
	VacationHours,
	PercentOfMaxVacation = dbo.ufPorcentajeEntero(VacationHours, @MaxVacationHours)

FROM AdventureWorks2019.HumanResources.Employee

