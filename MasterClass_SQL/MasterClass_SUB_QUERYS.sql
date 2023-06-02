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