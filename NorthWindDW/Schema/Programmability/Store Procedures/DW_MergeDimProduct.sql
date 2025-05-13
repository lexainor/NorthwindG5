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