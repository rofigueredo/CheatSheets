use AdventureWorksDW2019;

--- Esta primera consulta devolverá todas las tablas de la base de datos que está consultando.
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM
  	INFORMATION_SCHEMA.TABLES

--- La segunda consulta devolverá una lista de todas las columnas y tablas de la base de datos que está consultando.
SELECT 
	COLUMN_NAME, DATA_TYPE, ORDINAL_POSITION,
	TABLE_SCHEMA, TABLE_CATALOG, TABLE_NAME
FROM
  	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'FactFinance' 

---------------------------------------- DDL

  CREATE TABLE Online_Customers (Customer_Id INT PRIMARY KEY IDENTITY(1, 1),
  Customer_Name VARCHAR(100),
  Customer_City VARCHAR(100),
  Customer_Mail VARCHAR(100))
  GO
  
  INSERT INTO [dbo].Online_Customers(Customer_Name, Customer_City, Customer_Mail) VALUES
		(N'Salvador', N'Philadelphia', N'tyiptqo.wethls@chttw.org'),
		(N'Gilbert', N'San Diego', N'rrvyy.wdumos@lklkj.org'),
		(N'Ernest', N'New York', N'ymuea.pnxkukf@dwv.org'),
		(N'Stella', N'Phoenix', N'xvsfzp.rjhtni@rdn.com');

---  UPDATE FROM SELECT

CREATE TABLE dbo.Persons
( PersonId       INT
  PRIMARY KEY IDENTITY(1, 1) NOT NULL, 
  PersonName     VARCHAR(100) NULL, 
  PersonLastName VARCHAR(100) NULL, 
  PersonPostCode VARCHAR(100) NULL, 
  PersonCityName VARCHAR(100) NULL)
 
GO
 
CREATE TABLE  AddressList(
  [AddressId] [int]  PRIMARY KEY IDENTITY(1,1) NOT NULL,
  [PersonId] [int] NULL,
  [PostCode] [varchar](100) NULL,
  [City] [varchar](100) NULL)
 
GO
 
INSERT INTO Persons
(PersonName, PersonLastName )
VALUES
(N'Salvador', N'Williams'),
(N'Lawrence', N'Brown'),
( N'Gilbert', N'Jones'),
( N'Ernest', N'Smith'),
( N'Jorge', N'Johnson')
 
GO

UPDATE Per
	SET 
	Per.PersonCityName=Addr.City, 
	Per.PersonPostCode=Addr.PostCode
	FROM Persons Per
INNER JOIN
	AddressList Addr ON Per.PersonId = Addr.PersonId
