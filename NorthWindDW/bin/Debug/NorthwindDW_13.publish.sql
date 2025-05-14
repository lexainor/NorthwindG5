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
PRINT N'Modificando Tabla [dbo].[DimEmployee]...';


GO
ALTER TABLE [dbo].[DimEmployee] ALTER COLUMN [RegionDescription] NVARCHAR (4000) NOT NULL;

ALTER TABLE [dbo].[DimEmployee] ALTER COLUMN [TerritoryDescription] NVARCHAR (50) NOT NULL;


GO
PRINT N'Modificando Tabla [staging].[Employee]...';


GO
ALTER TABLE [staging].[Employee] ALTER COLUMN [RegionDescription] NVARCHAR (4000) NOT NULL;

ALTER TABLE [staging].[Employee] ALTER COLUMN [TerritoryDescription] NVARCHAR (50) NOT NULL;


GO
PRINT N'Actualizando Procedimiento [dbo].[DW_MergeDimEmployee]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[DW_MergeDimEmployee]';


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
PRINT N'Actualización completada.';


GO
