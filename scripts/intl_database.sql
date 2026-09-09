/*
===============================================================
Create Database and Schemas
===============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouseAnalyst' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouseAnalyst' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/





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
