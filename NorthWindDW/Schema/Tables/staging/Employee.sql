CREATE TABLE [staging].[Employee]
(
	[EmployeeSK] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[TitleOfCourtesy] [nvarchar](25) NOT NULL,
	[BirthDate] [datetime] NOT NULL,
	[HireDate] [datetime] NOT NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NOT NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NOT NULL,
	[HomePhone] [nvarchar](24),
	[Extension] [nvarchar](4),
	[Photo] [image],
	[Notes] [ntext],
	[ReportsTo] [int] NULL,
	[PhotoPath] [nvarchar](255),
	[TerritoryDescription] [nvarchar](4000) NOT NULL,
	[RegionDescription] [nvarchar](4000) NOT NULL
)
