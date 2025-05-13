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