--------	MASTER CLASS For Data Analysis   --------------
USE AdventureWorks2019;
--------------------------------------------------------------------------------------
----------	SCALAR SUB QUERYS	
--------------------------------------------------------------------------------------
SELECT
		BusinessEntityID,
		JobTitle,
		VacationHours,
		Percent_Vacations = (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM HumanResources.Employee),
		MAX_Vacation_Hours = (SELECT MAX(VacationHours) FROM HumanResources.Employee)
FROM HumanResources.Employee
WHERE (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM HumanResources.Employee) >= 0.80



--------------------------------------------------------------------------------------
----------	CARRELATED SUB Query	
--------------------------------------------------------------------------------------
SELECT 
		PurchaseOrderID,
		VendorID,
		OrderDate,
		TotalDue,
		NonRejectedItems = (
			SELECT COUNT(*) 
			FROM Purchasing.PurchaseOrderDetail B 
			WHERE A.PurchaseOrderID=B.PurchaseOrderID AND B.RejectedQty = 0 
			),
		MostExpensiveItem = (
			SELECT MAX(B.UnitPrice)
			FROM Purchasing.PurchaseOrderDetail B 
			WHERE A.PurchaseOrderID=B.PurchaseOrderID
			)
FROM Purchasing.PurchaseOrderHeader A

---------------------------------------------------------------------------------------
----------	IF EXISTS SUBQUERY	
--------------------------------------------------------------------------------------
/*Select all records from the Purchasing.PurchaseOrderHeader table such that there is at least one item in the order
with an order quantity greater than 500, AND a unit price greater than $50.00. */

SELECT ph.*
FROM   purchasing.purchaseorderheader ph
WHERE  EXISTS (SELECT 1
               FROM   purchasing.purchaseorderdetail pd
               WHERE  ph.PurchaseOrderID = pd.PurchaseOrderID
					  AND pd.orderqty > 500
                      AND pd.unitprice > 50)
ORDER  BY purchaseorderid 

/*Select all records from the Purchasing.PurchaseOrderHeader table such that NONE of the items within
the order have a rejected quantity greater than 0.*/

SELECT ph.*
FROM   purchasing.purchaseorderheader ph
WHERE  NOT EXISTS (SELECT
	1
	FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail pd
	WHERE ph.PurchaseOrderID = pd.PurchaseOrderID
		AND pd.RejectedQty > 0)
ORDER  BY purchaseorderid 

---------------------------------------------------------------------------------------
----------	FOR XML PATH With STUFF	
---------------------------------------------------------------------------------------
SELECT 
       SubcategoryName = A.[Name]
	  ,Products =
		STUFF(
			(
				SELECT
					';' + B.Name
				FROM AdventureWorks2019.Production.Product B
				WHERE A.ProductSubcategoryID = B.ProductSubcategoryID

				FOR XML PATH('')

			),1,1,''
		)
  FROM AdventureWorks2019.Production.ProductSubcategory A

--Exercise 2

SELECT 
       SubcategoryName = A.[Name]
	  ,Products =
		STUFF(
			(
				SELECT
					';' + B.Name
				FROM AdventureWorks2019.Production.Product B

				WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
					AND B.ListPrice > 50

				FOR XML PATH('')
			),1,1,''
		)
 FROM AdventureWorks2019.Production.ProductSubcategory A

 ---------------------------------------------------------------------------------------
----------	PIVOT	
----------------------------------------------------------------------------------------
SELECT
	[Employee Gender] = Gender,
	[Sales Representative],
	Buyer,
	Janitor
FROM (
		SELECT 
			JobTitle,
			Gender,
			VacationHours
		FROM HumanResources.Employee
	 ) S

PIVOT(
AVG(VacationHours)
FOR JobTitle IN([Sales Representative],[Buyer],[Janitor])
) B

SELECT * FROM HumanResources.EmployeePayHistory