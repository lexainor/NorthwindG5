/*
Script de implementación para NorthwindOLTP

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "NorthwindOLTP"
:setvar DefaultFilePrefix "NorthwindOLTP"
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
/*
 Plantilla de script anterior a la implementación							
--------------------------------------------------------------------------------------
 Este archivo contiene instrucciones de SQL que se ejecutarán antes del script de compilación	
 Use la sintaxis de SQLCMD para incluir un archivo en el script anterior a la implementación			
 Ejemplo:      :r .\miArchivo.sql								
 Use la sintaxis de SQLCMD para hacer referencia a una variable en el script anterior a la implementación		
 Ejemplo:      :setvar TableName miTabla							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
SET NOCOUNT ON
GO

set quoted_identifier on
GO

/* Set DATEFORMAT so that the date strings are interpreted correctly regardless of
   the default DATEFORMAT on the server.
*/
SET DATEFORMAT mdy
GO

GO
PRINT N'Quitando Clave externa [dbo].[FK_Employees_Employees]...';


GO
ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [FK_Employees_Employees];


GO
PRINT N'Quitando Restricción CHECK [dbo].[CK_Birthdate]...';


GO
ALTER TABLE [dbo].[Employees] DROP CONSTRAINT [CK_Birthdate];


GO
PRINT N'Creando Clave externa [dbo].[FK_Employees_Employees]...';


GO
ALTER TABLE [dbo].[Employees] WITH NOCHECK
    ADD CONSTRAINT [FK_Employees_Employees] FOREIGN KEY ([ReportsTo]) REFERENCES [dbo].[Employees] ([EmployeeID]);


GO
PRINT N'Creando Restricción CHECK [dbo].[CK_Birthdate]...';


GO
ALTER TABLE [dbo].[Employees] WITH NOCHECK
    ADD CONSTRAINT [CK_Birthdate] CHECK (BirthDate < getdate());


GO
PRINT N'Modificando Procedimiento [dbo].[GetCustomerChangesByRowVersion]...';


GO
ALTER PROCEDURE [dbo].[GetCustomerChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT cus.[CustomerID]
          ,cus.[CompanyName]
          ,cus.[ContactName]
          ,cus.[ContactTitle]
          ,cus.[Address]
          ,cus.[City]
          ,cus.[Region]
          ,cus.[PostalCode]
          ,cus.[Country]
          ,cus.[Phone]
          ,cus.[Fax]
          ,cud.[CustomerDesc]
	  FROM [customers]                           cus
      INNER JOIN [CustomerCustomerDemo]          ccd ON cus.[CustomerID] = ccd.[CustomerID]
      INNER JOIN [CustomerDemographics]          cud ON ccd.[CustomerTypeID] = cud.[CustomerTypeID]
	  WHERE (cus.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND cus.[rowversion] <= CONVERT(ROWVERSION,@endRow))
         OR (ccd.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND ccd.[rowversion] <= CONVERT(ROWVERSION,@endRow))
         OR (cud.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND cud.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
GO
PRINT N'Modificando Procedimiento [dbo].[GetEmployeeChangesByRowVersion]...';


GO
ALTER PROCEDURE [dbo].[GetEmployeeChangesByRowVersion]
(
  @startRow BIGINT, 
  @endRow  BIGINT 
)
AS
BEGIN
	SELECT 
		emp.[EmployeeID],
		emp.[LastName],
		emp.[FirstName],
		emp.[Title],
		emp.[TitleOfCourtesy],
		emp.[BirthDate],
		emp.[HireDate],
		emp.[Address],
		emp.[City],
		emp.[Region],
		emp.[PostalCode],
		emp.[Country],
		emp.[HomePhone],
		emp.[Extension],
		emp.[Photo],
		emp.[Notes],
		emp.[ReportsTo],
		emp.[PhotoPath],
		STRING_AGG(ter.[TerritoryDescription], ', ') AS TerritoryDescription,
		STRING_AGG(reg.[RegionDescription], ', ') AS RegionDescription

	FROM [Employees] emp
	INNER JOIN [EmployeeTerritories] emt ON emp.[EmployeeID] = emt.[EmployeeID]
	INNER JOIN [Territories] ter ON emt.[TerritoryID] = ter.[TerritoryID]
	INNER JOIN [Region] reg ON ter.[RegionID] = reg.[RegionID]

	WHERE 
		(emp.[rowversion] > CONVERT(ROWVERSION,@startRow) AND emp.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (emt.[rowversion] > CONVERT(ROWVERSION,@startRow) AND emt.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (ter.[rowversion] > CONVERT(ROWVERSION,@startRow) AND ter.[rowversion] <= CONVERT(ROWVERSION,@endRow))
		OR (reg.[rowversion] > CONVERT(ROWVERSION,@startRow) AND reg.[rowversion] <= CONVERT(ROWVERSION,@endRow))

	GROUP BY 
		emp.[EmployeeID],
		emp.[LastName],
		emp.[FirstName],
		emp.[Title],
		emp.[TitleOfCourtesy],
		emp.[BirthDate],
		emp.[HireDate],
		emp.[Address],
		emp.[City],
		emp.[Region],
		emp.[PostalCode],
		emp.[Country],
		emp.[HomePhone],
		emp.[Extension],
		emp.[Photo],
		emp.[Notes],
		emp.[ReportsTo],
		emp.[PhotoPath]
END
GO
PRINT N'Comprobando los datos existentes con las restricciones recién creadas';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Employees] WITH CHECK CHECK CONSTRAINT [FK_Employees_Employees];

ALTER TABLE [dbo].[Employees] WITH CHECK CHECK CONSTRAINT [CK_Birthdate];


GO
PRINT N'Actualización completada.';


GO
