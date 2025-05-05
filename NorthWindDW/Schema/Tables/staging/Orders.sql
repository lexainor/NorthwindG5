CREATE TABLE [staging].[Orders]
(
	[OrderID] [int] NOT NULL,
	[CustomerSK] [int] NOT NULL,
	[EmployeeSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Discount] [real] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[RequiredDateKey] [int] NOT NULL,
	[ShippedDateKey] [int] NOT NULL,
	[Freight] [money] NOT NULL,
	[ShipName] [nvarchar](40) NOT NULL,
	[ShipAddress] [nvarchar](60) NOT NULL,
	[ShipCity] [nvarchar](15) NOT NULL,
	[ShipRegion] [nvarchar](15) NOT NULL,
	[ShipPostalCode] [nvarchar](10) NOT NULL,
	[ShipCountry] [nvarchar](15) NOT NULL,
	[ShipperCompanyName] [nvarchar](40) NOT NULL,
	[ShipperPhone] [nvarchar](24) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[RequiredDate] [datetime] NOT NULL,
	[ShippedDate] [datetime] NOT NULL
)
GO