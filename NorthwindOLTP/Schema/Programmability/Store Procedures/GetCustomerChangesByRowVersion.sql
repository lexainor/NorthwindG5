CREATE PROCEDURE [dbo].[GetCustomerChangesByRowVersion]
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


















