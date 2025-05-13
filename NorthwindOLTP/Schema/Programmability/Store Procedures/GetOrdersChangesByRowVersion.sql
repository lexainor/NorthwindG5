CREATE PROCEDURE [dbo].[GetOrdersChangesByRowVersion]
(
  @startRow BIGINT 
   ,@endRow  BIGINT 
)
AS
BEGIN
	SELECT ord.[OrderID]
      ,ord.[CustomerID]
      ,ord.[EmployeeID]
      ,dor.[ProductID]
      ,dor.[UnitPrice]
      ,dor.[Quantity]
      ,dor.[Discount]
		,OrderDateKey = CONVERT(INT,
							(CONVERT(CHAR(4),DATEPART(YEAR,ord.[OrderDate]))
						  + CASE 
								WHEN DATEPART(MONTH,ord.[OrderDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(MONTH,ord.[OrderDate]))
								ELSE + CONVERT(CHAR(2),DATEPART(MONTH,ord.[OrderDate]))
							END
						  + CASE 
								WHEN DATEPART(DAY,ord.[OrderDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(DAY,ord.[OrderDate]))
								ELSE + CONVERT(CHAR(2),DATEPART(DAY,ord.[OrderDate]))
							END))
		,RequiredDateKey = CONVERT(INT,
							(CONVERT(CHAR(4),DATEPART(YEAR,ord.[RequiredDate]))
						  + CASE 
								WHEN DATEPART(MONTH,ord.[RequiredDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(MONTH,ord.[RequiredDate]))
								ELSE + CONVERT(CHAR(2),DATEPART(MONTH,ord.[RequiredDate]))
							END
						  + CASE 
								WHEN DATEPART(DAY,ord.[RequiredDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(DAY,ord.[RequiredDate]))
								ELSE + CONVERT(CHAR(2),DATEPART(DAY,ord.[RequiredDate]))
							END))
		,ShippedDateKey = CASE
							WHEN ord.[ShippedDate] IS NULL THEN 0
							ELSE (CONVERT(INT,
										(CONVERT(CHAR(4),DATEPART(YEAR,ord.[ShippedDate]))
										+ CASE 
											WHEN DATEPART(MONTH,ord.[ShippedDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(MONTH,ord.[ShippedDate]))
											ELSE + CONVERT(CHAR(2),DATEPART(MONTH,ord.[ShippedDate]))
										END
										+ CASE 
											WHEN DATEPART(DAY,ord.[ShippedDate]) < 10 THEN '0' + CONVERT(CHAR(1),DATEPART(DAY,ord.[ShippedDate]))
											ELSE + CONVERT(CHAR(2),DATEPART(DAY,ord.[ShippedDate]))
										END)))
							END
      ,ord.[Freight]
      ,ord.[ShipName]
      ,ord.[ShipAddress]
      ,ord.[ShipCity]
      ,ord.[ShipRegion]
      ,ord.[ShipPostalCode]
      ,ord.[ShipCountry]
      ,shi.[CompanyName]
      ,shi.[Phone]
      ,ord.[OrderDate]
      ,ord.[RequiredDate]
      ,ord.[ShippedDate]
	  FROM [Orders]                        ord
      INNER JOIN [Order Details]           dor ON ord.[OrderID] = dor.[OrderID]
      INNER JOIN [Shippers]                shi ON ord.[ShipVia] = shi.[ShipperID]      
	  WHERE (ord.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND ord.[rowversion] <= CONVERT(ROWVERSION,@endRow))
         OR (dor.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND dor.[rowversion] <= CONVERT(ROWVERSION,@endRow))
         OR (shi.[rowversion] > CONVERT(ROWVERSION,@startRow) 
	     AND shi.[rowversion] <= CONVERT(ROWVERSION,@endRow))
END
GO


















