/*
Script de implementación para NorthwindDW

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "NorthwindDW"
:setvar DefaultFilePrefix "NorthwindDW"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Creando Esquema [staging]...';


GO
CREATE SCHEMA [staging]
    AUTHORIZATION [dbo];


GO
PRINT N'Creando Tabla [staging].[Orders]...';


GO
CREATE TABLE [staging].[Orders] (
    [OrderID]            INT           NOT NULL,
    [CustomerSK]         INT           NOT NULL,
    [EmployeeSK]         INT           NOT NULL,
    [ProductSK]          INT           NOT NULL,
    [UnitPrice]          MONEY         NOT NULL,
    [Quantity]           SMALLINT      NOT NULL,
    [Discount]           REAL          NOT NULL,
    [OrderDateKey]       INT           NOT NULL,
    [RequiredDateKey]    INT           NOT NULL,
    [ShippedDateKey]     INT           NOT NULL,
    [Freight]            MONEY         NOT NULL,
    [ShipName]           NVARCHAR (40) NOT NULL,
    [ShipAddress]        NVARCHAR (60) NOT NULL,
    [ShipCity]           NVARCHAR (15) NOT NULL,
    [ShipRegion]         NVARCHAR (15) NOT NULL,
    [ShipPostalCode]     NVARCHAR (10) NOT NULL,
    [ShipCountry]        NVARCHAR (15) NOT NULL,
    [ShipperCompanyName] NVARCHAR (40) NOT NULL,
    [ShipperPhone]       NVARCHAR (24) NOT NULL,
    [OrderDate]          DATETIME      NOT NULL,
    [RequiredDate]       DATETIME      NOT NULL,
    [ShippedDate]        DATETIME      NOT NULL
);


GO
PRINT N'Creando Tabla [staging].[Product]...';


GO
CREATE TABLE [staging].[Product] (
    [ProductSK]            INT           NOT NULL,
    [ProductName]          NVARCHAR (40) NOT NULL,
    [QuantityPerUnit]      NVARCHAR (20) NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [UnitsInStock]         SMALLINT      NOT NULL,
    [UnitsOnOrder]         SMALLINT      NOT NULL,
    [ReorderLevel]         SMALLINT      NOT NULL,
    [Discontinued]         BIT           NOT NULL,
    [CategoryName]         NVARCHAR (15) NOT NULL,
    [Description]          NTEXT         NULL,
    [Picture]              IMAGE         NULL,
    [SupplierCompanyName]  NVARCHAR (40) NOT NULL,
    [SupplierContactName]  NVARCHAR (30) NULL,
    [SupplierContactTitle] NVARCHAR (30) NULL,
    [SupplierAddress]      NVARCHAR (60) NULL,
    [SupplierCity]         NVARCHAR (15) NULL,
    [SupplierRegion]       NVARCHAR (15) NULL,
    [SupplierPostalCode]   NVARCHAR (10) NULL,
    [SupplierCountry]      NVARCHAR (15) NULL,
    [SupplierPhone]        NVARCHAR (24) NULL,
    [SupplierFax]          NVARCHAR (24) NULL,
    [SupplierHomePage]     NTEXT         NULL
);


GO
PRINT N'Creando Tabla [staging].[Employee]...';


GO
CREATE TABLE [staging].[Employee] (
    [EmployeeSK]           INT            NOT NULL,
    [LastName]             NVARCHAR (20)  NOT NULL,
    [FirstName]            NVARCHAR (10)  NOT NULL,
    [Title]                NVARCHAR (30)  NULL,
    [TitleOfCourtesy]      NVARCHAR (25)  NOT NULL,
    [BirthDate]            DATETIME       NOT NULL,
    [HireDate]             DATETIME       NOT NULL,
    [Address]              NVARCHAR (60)  NULL,
    [City]                 NVARCHAR (15)  NOT NULL,
    [Region]               NVARCHAR (15)  NULL,
    [PostalCode]           NVARCHAR (10)  NULL,
    [Country]              NVARCHAR (10)  NOT NULL,
    [HomePhone]            NVARCHAR (24)  NULL,
    [Extension]            NVARCHAR (4)   NULL,
    [Photo]                IMAGE          NULL,
    [Notes]                NTEXT          NULL,
    [ReportsTo]            INT            NOT NULL,
    [PhotoPath]            NVARCHAR (255) NULL,
    [TerritoryDescription] NCHAR (50)     NOT NULL,
    [RegionDescription]    NCHAR (50)     NOT NULL
);


GO
PRINT N'Creando Tabla [staging].[Customer]...';


GO
CREATE TABLE [staging].[Customer] (
    [CustomerSK]   INT           NOT NULL,
    [CustomerID]   INT           NOT NULL,
    [CompanyName]  NVARCHAR (40) NOT NULL,
    [ContactName]  NVARCHAR (30) NOT NULL,
    [ContactTitle] NVARCHAR (30) NULL,
    [Address]      NVARCHAR (60) NOT NULL,
    [City]         NVARCHAR (15) NULL,
    [Region]       NVARCHAR (15) NULL,
    [PostalCode]   NVARCHAR (10) NULL,
    [Country]      NVARCHAR (15) NOT NULL,
    [Phone]        NVARCHAR (24) NULL,
    [Fax]          NVARCHAR (24) NULL,
    [CustomerDesc] NTEXT         NULL
);


GO
PRINT N'Creando Tabla [dbo].[DimCustomer]...';


GO
CREATE TABLE [dbo].[DimCustomer] (
    [CustomerSK]   INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]   INT           NOT NULL,
    [CompanyName]  NVARCHAR (40) NOT NULL,
    [ContactName]  NVARCHAR (30) NOT NULL,
    [ContactTitle] NVARCHAR (30) NULL,
    [Address]      NVARCHAR (60) NOT NULL,
    [City]         NVARCHAR (15) NULL,
    [Region]       NVARCHAR (15) NULL,
    [PostalCode]   NVARCHAR (10) NULL,
    [Country]      NVARCHAR (15) NOT NULL,
    [Phone]        NVARCHAR (24) NULL,
    [Fax]          NVARCHAR (24) NULL,
    [CustomerDesc] NTEXT         NULL,
    CONSTRAINT [PK_DimCustomer] PRIMARY KEY CLUSTERED ([CustomerSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[DimDate]...';


GO
CREATE TABLE [dbo].[DimDate] (
    [DateKey]           INT           NOT NULL,
    [FullDate]          DATE          NOT NULL,
    [DayNumberOfWeek]   TINYINT       NOT NULL,
    [DayNameOfWeek]     NVARCHAR (10) NOT NULL,
    [DayNumberOfMonth]  TINYINT       NOT NULL,
    [DayNumberOfYear]   SMALLINT      NOT NULL,
    [WeekNumberOfYear]  TINYINT       NOT NULL,
    [MonthName]         NVARCHAR (10) NOT NULL,
    [MonthNumberOfYear] TINYINT       NOT NULL,
    [CalendarQuarter]   TINYINT       NOT NULL,
    [CalendarYear]      SMALLINT      NOT NULL,
    [CalendarSemester]  TINYINT       NOT NULL,
    CONSTRAINT [PK_DimDate] PRIMARY KEY CLUSTERED ([DateKey] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[DimEmployee]...';


GO
CREATE TABLE [dbo].[DimEmployee] (
    [EmployeeSK]           INT            IDENTITY (1, 1) NOT NULL,
    [EmployeeID]           INT            NOT NULL,
    [LastName]             NVARCHAR (20)  NOT NULL,
    [FirstName]            NVARCHAR (10)  NOT NULL,
    [Title]                NVARCHAR (30)  NULL,
    [TitleOfCourtesy]      NVARCHAR (25)  NOT NULL,
    [BirthDate]            DATETIME       NOT NULL,
    [HireDate]             DATETIME       NOT NULL,
    [Address]              NVARCHAR (60)  NULL,
    [City]                 NVARCHAR (15)  NOT NULL,
    [Region]               NVARCHAR (15)  NULL,
    [PostalCode]           NVARCHAR (10)  NULL,
    [Country]              NVARCHAR (10)  NOT NULL,
    [HomePhone]            NVARCHAR (24)  NULL,
    [Extension]            NVARCHAR (4)   NULL,
    [Photo]                IMAGE          NULL,
    [Notes]                NTEXT          NULL,
    [ReportsTo]            INT            NOT NULL,
    [PhotoPath]            NVARCHAR (255) NULL,
    [TerritoryDescription] NCHAR (50)     NOT NULL,
    [RegionDescription]    NCHAR (50)     NOT NULL,
    CONSTRAINT [PK_DimEmployees] PRIMARY KEY CLUSTERED ([EmployeeSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[DimProduct]...';


GO
CREATE TABLE [dbo].[DimProduct] (
    [ProductSK]            INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]            INT           NOT NULL,
    [ProductName]          NVARCHAR (40) NOT NULL,
    [QuantityPerUnit]      NVARCHAR (20) NOT NULL,
    [UnitPrice]            MONEY         NOT NULL,
    [UnitsInStock]         SMALLINT      NOT NULL,
    [UnitsOnOrder]         SMALLINT      NOT NULL,
    [ReorderLevel]         SMALLINT      NOT NULL,
    [Discontinued]         BIT           NOT NULL,
    [CategoryName]         NVARCHAR (15) NOT NULL,
    [Description]          NTEXT         NULL,
    [Picture]              IMAGE         NULL,
    [SupplierCompanyName]  NVARCHAR (40) NOT NULL,
    [SupplierContactName]  NVARCHAR (30) NULL,
    [SupplierContactTitle] NVARCHAR (30) NULL,
    [SupplierAddress]      NVARCHAR (60) NULL,
    [SupplierCity]         NVARCHAR (15) NULL,
    [SupplierRegion]       NVARCHAR (15) NULL,
    [SupplierPostalCode]   NVARCHAR (10) NULL,
    [SupplierCountry]      NVARCHAR (15) NULL,
    [SupplierPhone]        NVARCHAR (24) NULL,
    [SupplierFax]          NVARCHAR (24) NULL,
    [SupplierHomePage]     NTEXT         NULL,
    CONSTRAINT [PK_DimProducts] PRIMARY KEY CLUSTERED ([ProductSK] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[FactOrders]...';


GO
CREATE TABLE [dbo].[FactOrders] (
    [OrderID]            INT           NOT NULL,
    [CustomerSK]         INT           NOT NULL,
    [EmployeeSK]         INT           NOT NULL,
    [ProductSK]          INT           NOT NULL,
    [UnitPrice]          MONEY         NOT NULL,
    [Quantity]           SMALLINT      NOT NULL,
    [Discount]           REAL          NOT NULL,
    [OrderDateKey]       INT           NOT NULL,
    [RequiredDateKey]    INT           NOT NULL,
    [ShippedDateKey]     INT           NOT NULL,
    [Freight]            MONEY         NOT NULL,
    [ShipName]           NVARCHAR (40) NOT NULL,
    [ShipAddress]        NVARCHAR (60) NOT NULL,
    [ShipCity]           NVARCHAR (15) NOT NULL,
    [ShipRegion]         NVARCHAR (15) NOT NULL,
    [ShipPostalCode]     NVARCHAR (10) NOT NULL,
    [ShipCountry]        NVARCHAR (15) NOT NULL,
    [ShipperCompanyName] NVARCHAR (40) NOT NULL,
    [ShipperPhone]       NVARCHAR (24) NOT NULL,
    [OrderDate]          DATETIME      NOT NULL,
    [RequiredDate]       DATETIME      NOT NULL,
    [ShippedDate]        DATETIME      NOT NULL,
    CONSTRAINT [PK_FactOrders] PRIMARY KEY CLUSTERED ([OrderID] ASC)
);


GO
PRINT N'Creando Tabla [dbo].[PackageConfig]...';


GO
CREATE TABLE [dbo].[PackageConfig] (
    [PackageID]      INT          IDENTITY (1, 1) NOT NULL,
    [TableName]      VARCHAR (50) NOT NULL,
    [LastRowVersion] BIGINT       NULL,
    CONSTRAINT [PK_PackageConfig] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimCustomer]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimCustomer] FOREIGN KEY ([CustomerSK]) REFERENCES [dbo].[DimCustomer] ([CustomerSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimDate_OrderDate]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimDate_OrderDate] FOREIGN KEY ([OrderDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimDate_RequiredDate]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimDate_RequiredDate] FOREIGN KEY ([RequiredDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimDate_ShippedDate]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimDate_ShippedDate] FOREIGN KEY ([ShippedDateKey]) REFERENCES [dbo].[DimDate] ([DateKey]);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimProduct]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimProduct] FOREIGN KEY ([ProductSK]) REFERENCES [dbo].[DimProduct] ([ProductSK]);


GO
PRINT N'Creando Clave externa [dbo].[FK_DimEmployee]...';


GO
ALTER TABLE [dbo].[FactOrders] WITH NOCHECK
    ADD CONSTRAINT [FK_DimEmployee] FOREIGN KEY ([EmployeeSK]) REFERENCES [dbo].[DimEmployee] ([EmployeeSK]);


GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimCustomer]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimCustomer]
AS
BEGIN

	UPDATE dc
	SET [CompanyName]   = sc.[CompanyName]
	   ,[ContactName]   = sc.[ContactName]
	   ,[ContactTitle]  = sc.[ContactTitle]
	   ,[Address]       = sc.[Address]
	   ,[City]			= sc.[City]
	   ,[Region]        = sc.[Region]
	   ,[PostalCode]    = sc.[PostalCode]
	   ,[Country]		= sc.[Country]
	   ,[Phone]			= sc.[Phone]
	   ,[Fax]			= sc.[Fax]
	   ,[CustomerDesc]  = sc.[CustomerDesc]
	FROM [dbo].[DimCustomer]        dc
	INNER JOIN [staging].[Customer] sc ON (dc.[CustomerSK] = sc.[CustomerSK])
END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimEmployee]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimEmployee]
AS
BEGIN

	UPDATE dc
	SET [LastName]					= sc.[LastName]
	   ,[FirstName]					= sc.[FirstName]
	   ,[Title]						= sc.[Title]
	   ,[TitleOfCourtesy]			= sc.[TitleOfCourtesy]
	   ,[BirthDate]					= sc.[BirthDate]
	   ,[HireDate]					= sc.[HireDate]
	   ,[Address]					= sc.[Address]
	   ,[City]						= sc.[City]
	   ,[Region]					= sc.[Region]
	   ,[PostalCode]				= sc.[PostalCode]
	   ,[Country]					= sc.[Country]
	   ,[HomePhone]					= sc.[HomePhone]
	   ,[Extension]					= sc.[Extension]
	   ,[Photo]						= sc.[Photo]
	   ,[Notes]						= sc.[Notes]
	   ,[ReportsTo]					= sc.[ReportsTo]
	   ,[PhotoPath]					= sc.[PhotoPath]
	   ,[TerritoryDescription]		= sc.[TerritoryDescription]
	   ,[RegionDescription]			= sc.[RegionDescription]
	FROM [dbo].[DimEmployee]        dc
	INNER JOIN [staging].[Employee] sc ON (dc.[EmployeeSK] = sc.[EmployeeSK])
END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeDimProduct]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeDimProduct]
AS
BEGIN

	UPDATE dc
	SET [ProductName]			= sc.[ProductName]
	   ,[QuantityPerUnit]		= sc.[QuantityPerUnit]
	   ,[UnitPrice]				= sc.[UnitPrice]
	   ,[UnitsInStock]			= sc.[UnitsInStock]
	   ,[UnitsOnOrder]			= sc.[UnitsOnOrder]
	   ,[ReorderLevel]			= sc.[ReorderLevel]
	   ,[Discontinued]			= sc.[Discontinued]
	   ,[CategoryName]			= sc.[CategoryName]
	   ,[Description]			= sc.[Description]
	   ,[Picture]				= sc.[Picture]
	   ,[SupplierCompanyName]	= sc.[SupplierCompanyName]
	   ,[SupplierContactName]	= sc.[SupplierContactName]
	   ,[SupplierContactTitle]	= sc.[SupplierContactTitle]
	   ,[SupplierAddress]		= sc.[SupplierAddress]
	   ,[SupplierCity]			= sc.[SupplierCity]
	   ,[SupplierRegion]		= sc.[SupplierRegion]
	   ,[SupplierPostalCode]	= sc.[SupplierPostalCode]
	   ,[SupplierCountry]		= sc.[SupplierCountry]
	   ,[SupplierPhone]			= sc.[SupplierPhone]
	   ,[SupplierFax]			= sc.[SupplierFax]
	   ,[SupplierHomepage]		= sc.[SupplierHomepage]
	FROM [dbo].[DimProduct]        dc
	INNER JOIN [staging].[Product] sc ON (dc.[ProductSK] = sc.[ProductSK])
END
GO
PRINT N'Creando Procedimiento [dbo].[DW_MergeFactOrders]...';


GO
CREATE PROCEDURE [dbo].[DW_MergeFactOrders]
AS
BEGIN

	UPDATE dc
	SET [CustomerSK]			= sc.[CustomerSK]
	   ,[EmployeeSK]			= sc.[EmployeeSK]
	   ,[ProductSK]				= sc.[ProductSK]
	   ,[unitPrice]				= sc.[unitPrice]
	   ,[Quantity]				= sc.[Quantity]
	   ,[Discount]				= sc.[Discount]
	   ,[OrderDateKey]			= sc.[OrderDateKey]
	   ,[RequiredDateKey]		= sc.[RequiredDateKey]
	   ,[ShippedDateKey]		= sc.[ShippedDateKey]
	   ,[Freight]				= sc.[Freight]
	   ,[ShipName]				= sc.ShipName
	   ,[ShipAddress]			= sc.[ShipAddress]
	   ,[ShipCity]				= sc.[ShipCity]
	   ,[ShipRegion]			= sc.[ShipRegion]
	   ,[ShipPostalCode]		= sc.[ShipPostalCode]
	   ,[ShipCountry]			= sc.[ShipCountry]
	   ,[ShipperCompanyName]	= sc.[ShipperCompanyName]
	   ,[ShipperPhone]			= sc.[ShipperPhone]
	   ,[OrderDate]				= sc.[OrderDate]
	   ,[RequiredDate]			= sc.[RequiredDate]
	   ,[ShippedDate]			= sc.[ShippedDate]
	FROM [dbo].[FactOrders]        dc
	INNER JOIN [staging].[Orders] sc ON (dc.[OrderID] = sc.[OrderID])
END
GO
PRINT N'Creando Procedimiento [dbo].[GetLastPackageRowVersion]...';


GO
CREATE PROCEDURE [dbo].[GetLastPackageRowVersion]
(
	@tableName VARCHAR(50)
)
  AS
  BEGIN
	SELECT LastRowVersion
	FROM [dbo].[PackageConfig]
	WHERE TableName = @tableName;
  END
GO
PRINT N'Creando Procedimiento [dbo].[UpdateLastPackageRowVersion]...';


GO
CREATE PROCEDURE [dbo].[UpdateLastPackageRowVersion]
  (
	@tableName VARCHAR(50)
	,@lastRowVersion BIGINT
  )
  AS
  BEGIN
	UPDATE [dbo].[PackageConfig]
	SET LastRowVersion = @lastRowVersion
	WHERE TableName = @tableName;
  END
GO
/*
Plantilla de script posterior a la implementación							
--------------------------------------------------------------------------------------
 Este archivo contiene instrucciones de SQL que se anexarán al script de compilación.		
 Use la sintaxis de SQLCMD para incluir un archivo en el script posterior a la implementación.			
 Ejemplo:      :r .\miArchivo.sql								
 Use la sintaxis de SQLCMD para hacer referencia a una variable en el script posterior a la implementación.		
 Ejemplo:      :setvar TableName miTabla							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Customer')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Customer', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Employee')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Employee', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Product')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Product', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[PackageConfig]
			  WHERE [TableName] = 'Orders')
 BEGIN
	INSERT [dbo].[PackageConfig] ([TableName], [LastRowVersion]) VALUES ('Orders', 0)
 END
GO
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[DimDate])
 BEGIN
	BEGIN TRAN 
		DECLARE @startdate DATE = '1995-01-01',
				@enddate   DATE = '2001-01-01';
		DECLARE @datelist TABLE(FullDate DATE);

	IF @startdate IS NULL
		BEGIN
			SELECT TOP 1 
				   @startdate = FullDate
			FROM dbo.DimDate 
			ORDER By DateKey ASC;
		END

	WHILE (@startdate <= @enddate)
	BEGIN 
		INSERT INTO @datelist(FullDate)
		SELECT @startdate

		SET @startdate = DATEADD(dd,1,@startdate);
	END

	 INSERT INTO dbo.DimDate(DateKey
							,FullDate 
							,DayNumberOfWeek 
							,DayNameOfWeek 
							,DayNumberOfMonth 
							,DayNumberOfYear 
							,WeekNumberOfYear 
							,[MonthName] 
							,MonthNumberOfYear 
							,CalendarQuarter 
							,CalendarYear 
							,CalendarSemester)

	SELECT DateKey           = CONVERT(INT,CONVERT(VARCHAR,dl.FullDate,112))
		  ,FullDate          = dl.FullDate
		  ,DayNumberOfWeek   = DATEPART(dw,dl.FullDate)
		  ,DayNameOfWeek     = DATENAME(WEEKDAY,dl.FullDate) 
		  ,DayNumberOfMonth  = DATEPART(d,dl.FullDate)
		  ,DayNumberOfYear   = DATEPART(dy,dl.FullDate)
		  ,WeekNumberOfYear  = DATEPART(wk, dl.FUllDate)
		  ,[MonthName]       = DATENAME(MONTH,dl.FullDate) 
		  ,MonthNumberOfYear = MONTH(dl.FullDate)
		  ,CalendarQuarter   = DATEPART(qq, dl.FullDate)
		  ,CalendarYear      = YEAR(dl.FullDate)
		  ,CalendarSemester  = CASE DATEPART(qq, dl.FullDate)
										WHEN 1 THEN 1
										WHEN 2 THEN 1
										WHEN 3 THEN 2
										WHEN 4 THEN 2
								  END
		FROM @datelist              dl 
		LEFT OUTER JOIN dbo.DimDate dd ON (dl.FullDate = dd.FullDate)
		WHERE dd.FullDate IS NULL;
	COMMIT TRAN
END
GO
IF NOT EXISTS(SELECT TOP(1) 1
              FROM [dbo].[DimDate]
			  WHERE [DateKey] = 0)
BEGIN

    INSERT INTO [dbo].[DimDate]
               ([DateKey]
               ,[FullDate]
               ,[DayNumberOfWeek]
               ,[DayNameOfWeek]
               ,[DayNumberOfMonth]
               ,[DayNumberOfYear]
               ,[WeekNumberOfYear]
               ,[MonthName]
               ,[MonthNumberOfYear]
               ,[CalendarQuarter]
               ,[CalendarYear]
               ,[CalendarSemester])
         VALUES
               (0
               ,GETDATE()
               ,0
               ,''
               ,0
               ,0
               ,1
               ,''
               ,0
               ,0
               ,0
               ,0);
END
GO

GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimCustomer];

ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimDate_OrderDate];

ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimDate_RequiredDate];

ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimDate_ShippedDate];

ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimProduct];

ALTER TABLE [dbo].[FactOrders] WITH CHECK CHECK CONSTRAINT [FK_DimEmployee];


GO
PRINT N'Actualización completada.';


GO
