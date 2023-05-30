USE AdventureWorks2016;

-----------------------------------------------------------------------------------
-----		FUNCION OVER		para calculos en todas las filas de la consulta
-----------------------------------------------------------------------------------
SELECT 
		p.FirstName	[Nombre] , 
		p.LastName	[Apellido],
		e.JobTitle	[Cargo],
		eh.Rate Rate,
		[AverageRate] = AVG(eh.Rate) OVER (),
		MaximoRate = MAX(eh.Rate) OVER (),
		DiffFromAvgRate = eh.rate - AVG(eh.Rate) OVER (),
		PercentofMaxRate = eh.Rate/MAX(eh.Rate) OVER () *100
FROM Person.Person p 
	JOIN HumanResources.Employee E 
	 ON p.BusinessEntityID = E.BusinessEntityID
	JOIN HumanResources.EmployeePayHistory eh 
	 ON p.BusinessEntityID = eh.BusinessEntityID
GROUP BY p.FirstName, p.LastName, e.JobTitle, eh.Rate

-----------------------------------------------------------------------------------
------		PARTITION BY		
-----------------------------------------------------------------------------------
SELECT 
		p.Name		as NombreProducto,
		ListPrice	as [Precio de Lista],
		ps.Name		as ProductSubcategory,
		pc.Name		as CategoriaProducto,
		AVG(ListPrice) OVER (PARTITION BY pc.Name) AvgPriceByCategory,
		AVG(ListPrice) OVER (PARTITION BY pc.Name, ps.Name) AvgPriceByCategoryAndSubcategory,
		ProductVsCategoryDelta = ListPrice - AVG(ListPrice) OVER (PARTITION BY pc.Name)
FROM Production.Product p 
	JOIN Production.ProductSubcategory ps 
	 ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN Production.ProductCategory pc 
	 ON pc.ProductCategoryID = ps.ProductCategoryID

-----------------------------------------------------------------------------------
------		ROW NUMBER	--------
-----------------------------------------------------------------------------------
SELECT 
		ProductName = P.Name,
		p.ListPrice,
		ProductSubcategory = ps.Name,
		ProductCategory = pc.Name,
		[Price Rank] = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
		[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC), 
		[Top 5 Price In Category] = 
			CASE
				WHEN ROW_NUMBER() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC) <= 5 THEN 'Yes'
				ELSE 'No'
			END
FROM Production.Product p 
	JOIN Production.ProductSubcategory ps 
	 ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN Production.ProductCategory pc 
	 ON pc.ProductCategoryID = ps.ProductCategoryID

-----------------------------------------------------------------------------------
-----	RAKN AND DENSE RANK	--------------
-----------------------------------------------------------------------------------
SELECT 
		ProductName = P.Name,
		p.ListPrice,
		ProductSubcategory = ps.Name,
		ProductCategory = pc.Name,
		[Price Rank] = ROW_NUMBER() OVER(ORDER BY p.ListPrice DESC),
		[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC),
		[Category Price Rank With Rank] = RANK() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC),
		[Category Price Rank With DenseRank] = DENSE_RANK() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC),
		[Top 5 Price In Category] = 
			CASE
				WHEN DENSE_RANK() OVER(PARTITION BY pc.Name ORDER BY p.ListPrice DESC) <= 5 THEN 'Yes'
				ELSE 'No'
			END
FROM Production.Product p 
	JOIN Production.ProductSubcategory ps 
	 ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN Production.ProductCategory pc 
	 ON pc.ProductCategoryID = ps.ProductCategoryID

-----------------------------------------------------------------------------------
------------	LEAD & LAG Function		
-----------------------------------------------------------------------------------
SELECT 
		OH.PurchaseOrderID,
		[OrderDate] = CAST(OH.OrderDate AS DATE),
		OH.TotalDue,
		[VendorName] = V.Name,
		PrevOrderFromVendorAmt = LAG(OH.TotalDue) OVER(PARTITION BY OH.VendorID ORDER BY OH.OrderDate),
		NextOrderByEmployeeVendor = LEAD(V.Name) OVER(PARTITION BY OH.EmployeeID ORDER BY OH.OrderDate),
		Next2OrderByEmployeeVendor = LEAD(V.Name,2) OVER(PARTITION BY OH.EmployeeID ORDER BY OH.OrderDate)
FROM Purchasing.PurchaseOrderHeader OH
	JOIN Purchasing.Vendor V
	 ON OH.VendorID = V.BusinessEntityID
WHERE 
	YEAR(OH.OrderDate) >= 2013
	AND OH.TotalDue > 500

-----------------------------------------------------------------------------------
------------	SUB Query Nivel 1
-- consulta que muestre los tres pedidos más caros, por ID de proveedor
-----------------------------------------------------------------------------------
SELECT
	PurchaseOrderID,
	VendorID,
	OrderDate,
	TaxAmt,
	Freight,
	TotalDue
FROM
	(SELECT
			PurchaseOrderID,
			VendorID,
			OrderDate,
			TaxAmt,
			Freight,
			TotalDue,
			--[RankTotal] = ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY [TotalDue] DESC)	 -- 248 FILAS
			[RankTotal] = DENSE_RANK() OVER(PARTITION BY VendorID ORDER BY [TotalDue] DESC)  -- 3142 FILAS
	 FROM Purchasing.PurchaseOrderHeader
	) a
WHERE [RankTotal] <=3