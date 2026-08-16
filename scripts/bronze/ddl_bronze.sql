/*
===============================================================
Create Bronze Layer Tables
===============================================================

Script Purpose:
    This script creates the Bronze layer tables used to store
    raw data from CRM and ERP source systems.

WARNING:
    If any of these tables already exist, they will be permanently
    deleted and recreated. Any data currently stored in these
    tables will be lost.
*/

USE DataWarehouse;
GO


-- Drop and recreate the CRM customer information table
DROP TABLE IF EXISTS bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);
GO


-- Drop and recreate the CRM product information table
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm        NVARCHAR(50),
    prd_cost      INT,
    prd_line      NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO


-- Drop and recreate the CRM sales transaction table
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO


-- Drop and recreate the ERP customer information table
DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;
GO

CREATE TABLE bronze.erp_CUST_AZ12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO


-- Drop and recreate the ERP customer location table
DROP TABLE IF EXISTS bronze.erp_LOC_A101;
GO

CREATE TABLE bronze.erp_LOC_A101 (
    cid  NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO


-- Drop and recreate the ERP product category table
DROP TABLE IF EXISTS bronze.erp_PX_CAT_G1V2;
GO

CREATE TABLE bronze.erp_PX_CAT_G1V2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50) 
);
GO
