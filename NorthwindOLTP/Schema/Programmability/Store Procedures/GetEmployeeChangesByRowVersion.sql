CREATE PROCEDURE [dbo].[GetEmployeeChangesByRowVersion]
(
  @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT emp.[EmployeeID]
          ,emp.[LastName]
          ,emp.[FirstName]
          ,emp.[Title]
          ,emp.[TitleOfCourtesy]
          ,emp.[BirthDate]
          ,emp.[HireDate]
          ,emp.[Address]
          ,emp.[City]
          ,emp.[Region]
          ,emp.[PostalCode]
          ,emp.[Country]
          ,emp.[HomePhone]
          ,emp.[Extension]
          ,emp.[Photo]
          ,emp.[Notes]
          ,emp.[ReportsTo]
          ,emp.[PhotoPath]
          ,ter.[TerritoryDescription]
          ,reg.[RegionDescription]
	  FROM [Employees]                           emp
      INNER JOIN [EmployeeTerritories]           emt ON emp.[EmployeeID] = emt.[EmployeeID]
      INNER JOIN [Territories]                   ter ON emt.[TerritoryID] = ter.[TerritoryID]
      INNER JOIN [Region]                        reg ON ter.[RegionID] = reg.[RegionID]
	  WHERE (emp.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND emp.[rowversion] <= CONVERT(ROWVERSION,@endRow))
      OR (emt.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND emt.[rowversion] <= CONVERT(ROWVERSION,@endRow))
      OR (ter.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND ter.[rowversion] <= CONVERT(ROWVERSION,@endRow))
      OR (reg.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND reg.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
GO


















