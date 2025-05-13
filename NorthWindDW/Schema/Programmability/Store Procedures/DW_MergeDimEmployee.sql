﻿CREATE PROCEDURE [dbo].[DW_MergeDimEmployee]
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