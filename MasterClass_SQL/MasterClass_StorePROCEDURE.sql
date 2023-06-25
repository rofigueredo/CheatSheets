--Create the procedure:
use AdventureWorks2019;

CREATE PROCEDURE dbo.PedidosSobreUmbral(@Limite MONEY, @StartYear INT, @EndYear INT)

AS

BEGIN
	SELECT 
		A.SalesOrderID,
		A.OrderDate,
		A.TotalDue

	FROM  AdventureWorks2019.Sales.SalesOrderHeader A
		JOIN AdventureWorks2019.dbo.Calendario B
			ON A.OrderDate = B.FECHA

	WHERE A.TotalDue >= @Limite
		AND B.NroANHO BETWEEN @StartYear AND @EndYear
END


--Execute the procedure:

EXEC dbo.PedidosSobreUmbral 10000, 2012, 2013

---------------------------------------------------------------------
---  Control Flow With IF Statements
---------------------------------------------------------------------
ALTER PROCEDURE dbo.PedidosSobreUmbral(@Limite MONEY, @StartYear INT, @EndYear INT, @OrderType INT)

AS

BEGIN
	IF @OrderType = 1
		BEGIN
			SELECT 
				A.SalesOrderID,
				A.OrderDate,
				A.TotalDue

			FROM  AdventureWorks2019.Sales.SalesOrderHeader A
				JOIN AdventureWorks2019.dbo.Calendario B
					ON A.OrderDate = B.FECHA

			WHERE A.TotalDue >= @Limite
				AND B.NroANHO BETWEEN @StartYear AND @EndYear

			ORDER BY A.TotalDue DESC
		END

	ELSE
			BEGIN
				SELECT 
					A.PurchaseOrderID,
					A.OrderDate,
					A.TotalDue

				FROM  AdventureWorks2019.Purchasing.PurchaseOrderHeader A
					JOIN AdventureWorks2019.dbo.Calendario B
						ON A.OrderDate = B.FECHA

				WHERE A.TotalDue >= @Limite
					AND B.NroANHO BETWEEN @StartYear AND @EndYear

				ORDER BY A.TotalDue DESC
			END
END

--Descomentar para Ejecutar

-- EXEC dbo.PedidosSobreUmbral 10000, 2011, 2013, 1

-- EXEC dbo.PedidosSobreUmbral 10000, 2011, 2013, 2

