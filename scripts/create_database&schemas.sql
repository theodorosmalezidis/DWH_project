/*
--------------------------------------------------------------------------
Create Initial Database & Schemas
--------------------------------------------------------------------------

This script creates the new database 'DataWareHouse', if it exists it is dropped and recreated.
Also three schemas are created in the database.
*/





USE master;
GO

-- Drop database if it already exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN
    DROP DATABASE DataWareHouse;
END
GO

--Create Database 'DataWareHouse'--

Create Database DataWareHouse;

USE DataWareHouse;
GO

--Create Schemas--

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
