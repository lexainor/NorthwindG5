DELETE Categories;
DBCC CHECKIDENT ('Categories', RESEED);

DELETE Customers;

DELETE Employees;
DBCC CHECKIDENT ('Employees', RESEED);

DELETE EmployeeTerritories;

DELETE [Order Details];

DELETE Orders;
DBCC CHECKIDENT ('Orders', RESEED);

DELETE Products;
DBCC CHECKIDENT ('Products', RESEED);

DELETE Region;

DELETE Shippers;
DBCC CHECKIDENT ('Shippers', RESEED);

DELETE Suppliers;
DBCC CHECKIDENT ('Suppliers', RESEED);

DELETE Territories;
