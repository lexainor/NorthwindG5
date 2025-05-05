CREATE TABLE [dbo].[DimCustomer]
(
	[CustomerSK] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_DimCustomer PRIMARY KEY,
	[CustomerID] [int] NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NOT NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NOT NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NOT NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	[CustomerDesc] [ntext] NULL
)
