-- EJERCICIO 1

SELECT
	   BusinessEntityID
      ,JobTitle
      ,VacationHours
	  ,MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)
	  ,PercentOfMaxVacationHours = (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

FROM AdventureWorks2019.HumanResources.Employee

WHERE (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee) >= 0.8



--Solución rediseñada

DECLARE @MaxVacation FLOAT = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

SELECT
	   [BusinessEntityID]
      ,[JobTitle]
      ,[VacationHours]
	  ,MaxVacationHours = @MaxVacation
	  ,PercentOfMaxVacationHours = VacationHours / @MaxVacation

FROM AdventureWorks2019.HumanResources.Employee

WHERE VacationHours / @MaxVacation >= 0.8

-- EJERCICIO 2
DECLARE @Today DATE = CAST(GETDATE() AS DATE)

SELECT @Today as Today

DECLARE @Current14 DATE = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),14)

DECLARE @PayPeriodEnd DATE = 
	CASE
		WHEN DAY(@Today) < 15 THEN DATEADD(MONTH,-1,@Current14)
		ELSE @Current14
	END 

DECLARE @PayPeriodStart DATE = DATEADD(DAY,1,DATEADD(MONTH,-1,@PayPeriodEnd)) 


SELECT @PayPeriodStart as PeriodInicio
SELECT @PayPeriodEnd as PeriodFin

SELECT

ElapsedBusinessDays = (

SELECT

COUNT(*)

FROM AdventureWorks2019.dbo.Calendar B

WHERE B.DateValue BETWEEN A.OrderDate AND A.ShipDate

AND B.WeekendFlag = 0

AND B.HolidayFlag = 0

  ) - 1
FROM