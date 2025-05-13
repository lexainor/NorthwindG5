PRINT 'Populating Region table';
SET NOCOUNT ON;
/*SET IDENTITY_INSERT Region ON;*/
Insert Into [Region]([RegionID],[RegionDescription]) Values (1,'Eastern')
Insert Into [Region]([RegionID],[RegionDescription]) Values (2,'Western')
Insert Into [Region]([RegionID],[RegionDescription]) Values (3,'Northern')
Insert Into [Region]([RegionID],[RegionDescription]) Values (4,'Southern')
Go
/*SET IDENTITY_INSERT Region OFF;*/