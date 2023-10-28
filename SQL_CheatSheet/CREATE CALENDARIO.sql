-- ============================ Tabla Calendario =================================
---	Dev: Rodrigo Figueredo
-- ===============================================================================
use AdventureWorksDW2019;

-- Creamos la tabla Calendario 

CREATE OR REPLACE TABLE dbo.Calendario (
		FECHA DATE,
		NRODiaSemana INT,
		DiaDeLaSemana NVARCHAR(32),
		NroDiaDelMES INT,
		NroMES INT,
		NroANHO INT,
		Nro_AnhoMes NVARCHAR(7), 
		WeekendFlag TINYINT,
		HolidayFlag TINYINT
)
--	DROP table dbo.Calendario

-- Mediante CTE Cargaremos las fechas

WITH Fechas AS (
	SELECT CAST('2011-01-01' AS DATE) AS MiFecha

	UNION ALL

	SELECT
	DATEADD(DAY, 1, MiFecha)
	FROM Fechas
	WHERE MiFecha < CAST('2030-12-31' AS DATE)
)

	INSERT INTO dbo.Calendario (
		FECHA
		)
	SELECT MiFecha FROM Fechas
	OPTION (MAXRECURSION 10000)

--	SELECT * FROM dbo.Calendario

	UPDATE dbo.Calendario
	   SET
		   NRODiaSemana = DATEPART(WEEKDAY,FECHA),
		   DiaDeLaSemana = FORMAT(FECHA,'dddd'),
		   NroDiaDelMES = DAY(FECHA),
		   NroMES = MONTH(FECHA),
		   NroANHO = YEAR(FECHA),
		   Nro_AnhoMes = CONCAT(YEAR(FECHA),'/',FORMAT(FECHA,'MM'))

---------------------------------------------------------
	UPDATE dbo.Calendario
	   SET
		   WeekendFlag = 
		   CASE
				WHEN NRODiaSemana IN(1,7) THEN 1
				ELSE 0
		   END

	UPDATE dbo.Calendario
	   SET
		   HolidayFlag =
		   CASE
				WHEN NroDiaDelMES = 8 AND NroMES = 12 THEN 1
				ELSE 0
		   END


