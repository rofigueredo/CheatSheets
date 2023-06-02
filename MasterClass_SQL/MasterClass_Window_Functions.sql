--------	MASTER CLASS For Data Analysis   --------------
USE AdventureWorks2019;
--------------------------------------------------------------------------------------
----------	Function OVER	
--------------------------------------------------------------------------------------
SELECT
		p.FirstName	Nombre,
		p.LastName Apellido,
		e.JobTitle Cargo,
		eh.Rate,
		AVG(eh.Rate) OVER () PromedioRate,
		MAX(eh.Rate) OVER () MaximoRate,
		DiffFromAvgRate = eh.Rate - AVG(EH.Rate) OVER (),
		PercentOfMaxRate = eh.Rate / MAX(eh.Rate) OVER () * 100

FROM Person.Person p
	JOIN HumanResources.Employee e
	 ON p.BusinessEntityID = e.BusinessEntityID
	JOIN HumanResources.EmployeePayHistory EH
	 ON p.BusinessEntityID = eh.BusinessEntityID
GROUP BY p.FirstName, p.LastName, e.JobTitle, eh.Rate

--------------------------------------------------------------------------------------
----------	PARTITION BY	
--------------------------------------------------------------------------------------
SELECT
		Nombre = p.Name,
		[Precio de Lista] = ListPrice,
		[Categoria Producto] = pc.Name,
		[SubCategoria Producto] = ps.Name,
		[Prom ListPrice por Cat] = AVG(ListPrice) OVER (PARTITION BY pc.name),
		[Prom ListPrice por Cat y SubCat] = AVG(ListPrice) OVER (PARTITION BY pc.name, ps.name),
		[ProductVsCategoria] = ListPrice - AVG(ListPrice) OVER (PARTITION BY pc.Name)

FROM Production.Product p
	JOIN Production.ProductSubcategory ps
	 ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN Production.ProductCategory pc
	 ON ps.ProductCategoryID = pc.ProductCategoryID

--------------------------------------------------------------------------------------
----------	ROW NUMBER	
--------------------------------------------------------------------------------------
SELECT
		Nombre = p.Name,
		[Precio de Lista] = ListPrice,
		[SubCategoria Producto] = ps.Name,
		[Categoria Producto] = pc.Name,

		[Price Rank] = ROW_NUMBER() OVER(ORDER BY[ListPrice] DESC),
		[Category Price Rank] = ROW_NUMBER() OVER(PARTITION BY pc.Name ORDER BY[ListPrice] DESC),
		[Top 5 Price in Category] = 
		CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY pc.Name ORDER BY[ListPrice] DESC) <= 5 THEN 'Yes'
			ELSE 'No'
		END

FROM Production.Product p
	JOIN Production.ProductSubcategory ps
	 ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN Production.ProductCategory pc
	 ON ps.ProductCategoryID = pc.ProductCategoryID

--------------------------------------------------------------------------------------
----------	LEAD & LAG	
--------------------------------------------------------------------------------------
SELECT 
	   PurchaseOrderID as CompraID,
       OrderDate as FechaOrden,
       TotalDue,
	   VendorName = B.Name,
	   NroCuenta = B.AccountNumber,
	   PrevOrderFromVendorAmt = LAG(A.TotalDue) OVER(PARTITION BY A.VendorID ORDER BY A.OrderDate),
	   NextOrderByEmployeeVendor = LEAD(B.Name) OVER(PARTITION BY A.EmployeeID ORDER BY A.OrderDate),
	   Next2OrderByEmployeeVendor = LEAD(B.Name,2) OVER(PARTITION BY A.EmployeeID ORDER BY A.OrderDate)

  FROM Purchasing.PurchaseOrderHeader A
  JOIN Purchasing.Vendor B
    ON A.VendorID = B.BusinessEntityID

  WHERE YEAR(A.OrderDate) >= 2013
	AND A.TotalDue > 500

  ORDER BY 
  A.EmployeeID,
  A.OrderDate

  --------------------------------------------------------------------------------------
----------	SUB QUERY 	Nivel 1
----------------------------------------------------------------------------------------
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
			[RankTotal] = ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY[TotalDue] DESC)
	FROM Purchasing.PurchaseOrderHeader
	) a

WHERE RankTotal <= 3

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
			[RankTotal] = DENSE_RANK() OVER(PARTITION BY VendorID ORDER BY[TotalDue] DESC)
	FROM Purchasing.PurchaseOrderHeader
	) a

WHERE RankTotal <= 3
