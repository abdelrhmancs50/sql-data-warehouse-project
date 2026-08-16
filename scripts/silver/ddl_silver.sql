/*
===============================================================
Create Silver Layer Tables
===============================================================

Script Purpose:
    This script creates the Silver layer tables used to store
    cleaned, standardized, and transformed data from the Bronze layer.

WARNING:
    If any of these tables already exist, they will be permanently
    deleted and recreated. Any data currently stored in these
    tables will be lost.
*/

USE DataWarehouse;
GO


-- Drop and recreate the CRM customer information table
DROP TABLE IF EXISTS silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);
GO


-- Drop and recreate the CRM product information table
DROP TABLE IF EXISTS silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Drop and recreate the CRM sales transaction table
DROP TABLE IF EXISTS silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Drop and recreate the ERP customer information table
DROP TABLE IF EXISTS silver.erp_CUST_AZ12;
GO

CREATE TABLE silver.erp_CUST_AZ12 (
    cid             NVARCHAR(50),
    bdate           DATE,
    gen             NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Drop and recreate the ERP customer location table
DROP TABLE IF EXISTS silver.erp_LOC_A101;
GO

CREATE TABLE silver.erp_LOC_A101 (
    cid             NVARCHAR(50),
    cntry           NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Drop and recreate the ERP product category table
DROP TABLE IF EXISTS silver.erp_PX_CAT_G1V2;
GO

CREATE TABLE silver.erp_PX_CAT_G1V2 (
    id              NVARCHAR(50),
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
