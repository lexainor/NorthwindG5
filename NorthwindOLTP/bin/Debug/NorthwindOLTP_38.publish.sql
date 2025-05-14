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
PRINT N'Modificando Procedimiento [dbo].[GetEmployeeChangesByRowVersion]...';


GO
ALTER PROCEDURE [dbo].[GetEmployeeChangesByRowVersion]
(
    @startRow BIGINT,
    @endRow BIGINT
)
AS
BEGIN
    WITH ChangedRelatedData AS (
        SELECT DISTINCT
            emt.EmployeeID,
            LTRIM(RTRIM(ter.TerritoryDescription)) AS TerritoryDescription,
            LTRIM(RTRIM(reg.RegionDescription)) AS RegionDescription
        FROM [EmployeeTerritories] emt
        LEFT JOIN [Territories] ter ON emt.TerritoryID = ter.TerritoryID
        LEFT JOIN [Region] reg ON ter.RegionID = reg.RegionID
        WHERE (emt.[rowversion] > CONVERT(ROWVERSION, @startRow)
               AND emt.[rowversion] <= CONVERT(ROWVERSION, @endRow))
            OR (ter.[rowversion] > CONVERT(ROWVERSION, @startRow)
               AND ter.[rowversion] <= CONVERT(ROWVERSION, @endRow))
            OR (reg.[rowversion] > CONVERT(ROWVERSION, @startRow)
               AND reg.[rowversion] <= CONVERT(ROWVERSION, @endRow))
    ),
    DistinctEmployeeRegions AS (
        SELECT DISTINCT
            EmployeeID,
            RegionDescription
        FROM ChangedRelatedData
    ),
    AggregatedTerritories AS (
        SELECT
            EmployeeID,
            STRING_AGG(TerritoryDescription, ', ') AS TerritoryDescription
        FROM ChangedRelatedData
        GROUP BY EmployeeID
    ),
    AggregatedRegions AS (
        SELECT
            EmployeeID,
            STRING_AGG(RegionDescription, ', ') AS RegionDescription
        FROM DistinctEmployeeRegions
        GROUP BY EmployeeID
    )
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
        at.TerritoryDescription,
        ar.RegionDescription 
    FROM [Employees] emp
    LEFT JOIN AggregatedTerritories at ON emp.EmployeeID = at.EmployeeID
    LEFT JOIN AggregatedRegions ar ON emp.EmployeeID = ar.EmployeeID
    WHERE emp.[rowversion] > CONVERT(ROWVERSION, @startRow)
      AND emp.[rowversion] <= CONVERT(ROWVERSION, @endRow);
END
GO
PRINT N'Actualización completada.';


GO
