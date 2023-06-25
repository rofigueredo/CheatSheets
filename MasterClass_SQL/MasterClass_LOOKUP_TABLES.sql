-----------------------------------------------------------------------------------------------------------
----------- LOOKUP TABLES
-----------------------------------------------------------------------------------------------------------
USE AdventureWorks2019;

CREATE TABLE dbo.Calendario (
		FECHA DATE,
		SemanaNRO INT,
		DiaDeLaSemana NVARCHAR(32),
		NroDiaDelMES INT,
		NroMES INT,
		NroANHO INT,
		WeekendFlag TINYINT,
		HolidayFlag TINYINT

)
--Insert values manually
INSERT INTO Adventureworks2019.dbo.Calendario(
		FECHA,
		SemanaNRO,
		DiaDeLaSemana,
		NroDiaDelMES,
		NroMES,
		NroANHO,
		WeekendFlag,
		HolidayFlag
)

VALUES
(CAST('01-01-2011' AS DATE),7,'Saturday',1,1,2011,1,1),
(CAST('01-02-2011' AS DATE),1,'Sunday',2,1,2011,1,0)

SELECT * FROM Adventureworks2019.dbo.Calendario

TRUNCATE TABLE Adventureworks2019.dbo.Calendario
------------------------------------------------------------------------------------
--------	Insert dates to table with RECURSIVE CTE
WITH Fechas AS (
	SELECT CAST('2011-01-01' AS DATE) AS MiFecha

UNION ALL

SELECT
DATEADD(DAY, 1, MiFecha)
FROM Fechas
WHERE MiFecha < CAST('2030-12-31' AS DATE)
)

INSERT INTO AdventureWorks2019.dbo.Calendario (
	FECHA
	)
SELECT MiFecha FROM Fechas
OPTION (MAXRECURSION 10000)

SELECT * FROM AdventureWorks2019.dbo.Calendario
-----------------------------------------------------------------------------
--- parte 2
-----------------------------------------------------------------------------
--Update NULL fields in Calendar table

UPDATE AdventureWorks2019.dbo.Calendario
SET
	DiaSemanaNRO = DATEPART(WEEKDAY,FECHA),
	DiaDeLaSemana = FORMAT(FECHA,'dddd'),
	NroDiaDelMES = DAY(FECHA),
	NroMES = MONTH(FECHA),
	NroANHO = YEAR(FECHA)


SELECT * FROM AdventureWorks2019.dbo.Calendario

---------------------------------------------------------
UPDATE AdventureWorks2019.dbo.Calendario
SET
WeekendFlag = 
	CASE
		WHEN DiaSemanaNRO IN(1,7) THEN 1
		ELSE 0
	END

UPDATE AdventureWorks2019.dbo.Calendario
SET
HolidayFlag =
	CASE
		WHEN NroDiaDelMES = 8 AND NroMES = 12 THEN 1
		ELSE 0
	END


SELECT * FROM AdventureWorks2019.dbo.Calendario



