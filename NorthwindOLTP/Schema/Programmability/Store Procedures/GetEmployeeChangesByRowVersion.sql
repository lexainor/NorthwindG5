CREATE PROCEDURE [dbo].[GetEmployeeChangesByRowVersion]
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