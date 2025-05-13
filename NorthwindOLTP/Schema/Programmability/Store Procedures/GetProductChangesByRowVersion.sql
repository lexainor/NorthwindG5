CREATE PROCEDURE [dbo].[GetProductChangesByRowVersion]
(
   @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT pro.[ProductID]
          ,pro.[ProductName]
          ,pro.[QuantityPerUnit]
          ,pro.[UnitPrice]
          ,pro.[UnitsInStock]
          ,pro.[UnitsOnOrder]
          ,pro.[ReorderLevel]
          ,pro.[Discontinued]
          ,cat.[CategoryName]
          ,cat.[Description]
          ,cat.[Picture]
          ,sup.[CompanyName]
          ,sup.[ContactName]
          ,sup.[ContactTitle]
          ,sup.[Address]
          ,sup.[City]
          ,sup.[Region]
          ,sup.[PostalCode]
          ,sup.[Country]
          ,sup.[Phone]
          ,sup.[Fax]
          ,sup.[HomePage]
	  FROM [Products]                           pro
      INNER JOIN [Categories]                   cat ON pro.[CategoryID] = cat.[CategoryID]
      INNER JOIN [Suppliers]                    sup ON pro.[SupplierID] = sup.[SupplierID]
	  WHERE (pro.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND pro.[rowversion] <= CONVERT(ROWVERSION,@endRow))
      OR (cat.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND cat.[rowversion] <= CONVERT(ROWVERSION,@endRow))
      OR (sup.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	  AND sup.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
GO


















