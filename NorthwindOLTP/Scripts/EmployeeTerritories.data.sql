﻿PRINT 'Populating [EmployeeTerritories] table';
set quoted_identifier on
go
/*set identity_insert Employees on*/
go
ALTER TABLE Employees NOCHECK CONSTRAINT ALL
go
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (1,'06897')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (1,'19713')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'01581')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'01730')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'01833')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'02116')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'02139')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'02184')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (2,'40222')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (3,'30346')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (3,'31406')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (3,'32859')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (3,'33607')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (4,'20852')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (4,'27403')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (4,'27511')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'02903')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'07960')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'08837')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'10019')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'10038')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'11747')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (5,'14450')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (6,'85014')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (6,'85251')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (6,'98004')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (6,'98052')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (6,'98104')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'60179')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'60601')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'80202')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'80909')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'90405')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'94025')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'94105')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'95008')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'95054')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (7,'95060')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (8,'19428')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (8,'44122')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (8,'45839')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (8,'53404')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'03049')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'03801')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'48075')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'48084')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'48304')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'55113')
Insert Into [EmployeeTerritories]([EmployeeID],[TerritoryID]) Values (9,'55439')
GO
go
ALTER TABLE [Customers] CHECK CONSTRAINT ALL
go
/*SET IDENTITY_INSERT [EmployeeTerritories] OFF;*/