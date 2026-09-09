USE Master;
Go
IF EXISTS(Select 1 from sys.databases
where name = 'DataWarehouseAnalyst')
Begin 
alter database DataWarehouseAnalyst 
set single_user with rollback immediate;
drop database DataWarehouseAnalyst;
END;
Go

Create database DataWarehouseAnalyst
GO
Use DataWarehouseAnalyst;
GO
CREATE SCHEMA bronze;
GO
Create SCHEMA Silver;
GO
Create SCHEMA Gold;
GO
