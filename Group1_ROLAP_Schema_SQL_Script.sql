/****** Object:  Database ist722_hhkhan_oc1_dw    Script Date: 6/9/22 4:25:55 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_hhkhan_oc1_dw
GO
CREATE DATABASE ist722_hhkhan_oc1_dw
GO
ALTER DATABASE ist722_hhkhan_oc1_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oc1_dw
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;



/* Drop table dbo.FactCustomerFeedback */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactCustomerFeedback') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactCustomerFeedback 
;


/* Drop table dbo.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimDate 
;

/* Create table dbo.DimDate */
CREATE TABLE dbo.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  smallint   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  smallint   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_dbo.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;



INSERT INTO dbo.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;







/* Drop table dbo.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimProduct 
;

/* Create table dbo.DimProduct */
CREATE TABLE dbo.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  nvarchar(20)   NOT NULL
,  [ProductName]  nvarchar(200)   NOT NULL
,  [ProductCategory]  nvarchar(20)   NOT NULL
,  [ProductIsActive]  nvarchar(5)   NOT NULL
,  [ProductVendor]  nvarchar(50)   NOT NULL
,  [ProductSource]  nvarchar(50) NOT NULL
,  [RowIsCurrent]  bit  DEFAULT 1  NOT NULL
,  [RowStartDate]  datetime  DEFAULT '1/1/00' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;



SET IDENTITY_INSERT dbo.DimProduct ON
;
INSERT INTO dbo.DimProduct (ProductKey, ProductID, ProductName, ProductCategory, ProductIsActive, ProductVendor, ProductSource, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'Unknown', 'Unknown', 'False', 'Unknown', 'Unknown', 0, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimProduct OFF
;








/* Drop table dbo.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCustomer 
;

/* Create table dbo.DimCustomer */
CREATE TABLE dbo.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(10)   NOT NULL
,  [CustomerFirstName]  nvarchar(50)   NOT NULL
,  [CustomerLastName]  nvarchar(50)   NOT NULL
,  [CustomerEmail]  nvarchar(200)   NOT NULL
,  [CustomerZipCode]  nvarchar(20)   NOT NULL
,  [CustomerSource]  nvarchar(50) NOT NULL
,  [MaritalStatus]  varchar(255)   NULL
,  [HouseholdIncome]  float   NULL
,  [OwnHome]  varchar(255)   NULL
,  [Education]  varchar(255)   NULL
,  [FavoriteDepartment]  varchar(255)   NULL
,  [RowIsCurrent]  bit  DEFAULT 1  NOT NULL
,  [RowStartDate]  datetime  DEFAULT '1/1/00' NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NULL
, CONSTRAINT [PK_dbo.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;




SET IDENTITY_INSERT dbo.DimCustomer ON
;
INSERT INTO dbo.DimCustomer (CustomerKey, CustomerID, CustomerFirstName, CustomerLastName, CustomerEmail, CustomerZipCode, CustomerSource, MaritalStatus, HouseholdIncome, OwnHome, Education, FavoriteDepartment, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', -1, 'Unknown', 'Unknown', 'Unknown', 0, '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT dbo.DimCustomer OFF
;



/* Create table dbo.FactCustomerFeedback */
CREATE TABLE dbo.FactCustomerFeedback (
   [ProductKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ReviewDateKey]  int  NOT NULL
,  [ReviewStars]  int   NULL
,  [Source]  nvarchar(20)   NULL
, CONSTRAINT [PK_dbo.FactCustomerFeedback] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [CustomerKey], [ReviewDateKey] )
) ON [PRIMARY]
;






ALTER TABLE dbo.FactCustomerFeedback ADD CONSTRAINT
   FK_dbo_FactCustomerFeedback_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES dbo.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactCustomerFeedback ADD CONSTRAINT
   FK_dbo_FactCustomerFeedback_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES dbo.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactCustomerFeedback ADD CONSTRAINT
   FK_dbo_FactCustomerFeedback_ReviewDateKey FOREIGN KEY
   (
   ReviewDateKey
   ) REFERENCES dbo.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
