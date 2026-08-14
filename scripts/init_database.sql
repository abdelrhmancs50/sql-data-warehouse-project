/*
===============================================================
Create Data Warehouse Database and Schemas
===============================================================

Script Purpose:
    This script creates a new database named 'DataWarehouse'
    and sets up three schemas: 'bronze', 'silver', and 'gold'.

WARNING:
    If the 'DataWarehouse' database already exists, this script
    will permanently delete it along with all its data and objects.
    Make sure you have a proper backup before running this script.
*/

USE master;
GO

-- Drop the existing database to ensure a clean environment
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

-- Create the DataWarehouse database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create the Bronze, Silver, and Gold schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
