USE AdventureWorks2016;
----------------------------------------------------------------------
---- TEMP TABLES
----------------------------------------------------------------------
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #Sales
FROM AdventureWorks2016.Sales.SalesOrderHeader


SELECT
OrderMonth,
TotalSales = SUM(TotalDue)
INTO #SalesMinusTop10
FROM #Sales
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #Purchases
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader


SELECT
OrderMonth,
TotalPurchases = SUM(TotalDue)
INTO #PurchasesMinusTop10
FROM #Purchases
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #SalesMinusTop10 A
	JOIN #PurchasesMinusTop10 B
		ON A.OrderMonth = B.OrderMonth

ORDER BY 1

DROP TABLE #Sales
DROP TABLE #SalesMinusTop10
DROP TABLE #Purchases
DROP TABLE #PurchasesMinusTop10

--------------------------------------------------------------------------------------------------
---	CREATE AND INSERT con TEMP TABLES
--------------------------------------------------------------------------------------------------
CREATE TABLE #Sales
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Sales
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader



CREATE TABLE #SalesMinusTop10
(
OrderMonth DATE,
TotalSales MONEY
)

INSERT INTO #SalesMinusTop10
(
OrderMonth,
TotalSales
)
SELECT
OrderMonth,
TotalSales = SUM(TotalDue)
FROM #Sales
WHERE OrderRank > 10
GROUP BY OrderMonth


CREATE TABLE #Purchases
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Purchases
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader



CREATE TABLE #PurchaseMinusTop10
(
OrderMonth DATE,
TotalPurchases MONEY
)

INSERT INTO #PurchaseMinusTop10
(
OrderMonth,
TotalPurchases
)
SELECT
OrderMonth,
TotalPurchases = SUM(TotalDue)
FROM #Purchases
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #SalesMinusTop10 A
	JOIN #PurchaseMinusTop10 B
		ON A.OrderMonth = B.OrderMonth

ORDER BY 1

DROP TABLE #Sales
DROP TABLE #SalesMinusTop10
DROP TABLE #Purchases
DROP TABLE #PurchaseMinusTop10

--------------------------------------------------------------------------------------------------
---	TRUNCATE  con TEMP TABLES
--------------------------------------------------------------------------------------------------

--Top 10 sales + purchases script

CREATE TABLE #Orders
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Orders
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader

CREATE TABLE #Top10Orders
(
OrderMonth DATE,
OrderType VARCHAR(32),
Top10Total MONEY
)


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Sales',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth


/*Fun part begins here*/

TRUNCATE TABLE #Orders

INSERT INTO #Orders
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Purchase',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth


SELECT
A.OrderMonth,
A.OrderType,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM #Top10Orders A
	LEFT JOIN #Top10Orders B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
			AND A.OrderType = B.OrderType

ORDER BY 3 DESC

DROP TABLE #Orders
DROP TABLE #Top10Orders