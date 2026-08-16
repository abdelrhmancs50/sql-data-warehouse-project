/*
===============================================================
Silver Layer Data Quality Checks
===============================================================

Script Purpose:
    This script validates the quality, consistency, and
    standardization of data loaded into the Silver layer.

*/


-- Check duplicates or nulls in PK
-- Expectations: No results
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for unwanted spaces
-- Expectations: No results
SELECT 
    cst_firstname
FROM silver.crm_cust_info 
WHERE cst_firstname != TRIM(cst_firstname);


-- Data standardization & consistency
SELECT DISTINCT 
    cst_gndr
FROM silver.crm_cust_info;

SELECT 
    *
FROM silver.crm_cust_info;


----------------------------------------------------------------------------------

-- Check duplication & null for PK
-- Expectations: No results
SELECT 
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for unwanted spaces
-- Expectations: No results
SELECT 
    prd_nm
FROM silver.crm_prd_info 
WHERE prd_nm != TRIM(prd_nm);


-- Check for nulls and negative numbers
SELECT 
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost != ABS(prd_cost) OR prd_cost IS NULL;


-- Data standardization & consistency
SELECT DISTINCT 
    prd_line
FROM silver.crm_prd_info;


-- Check date validation
SELECT 
    prd_start_dt,
    prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

SELECT 
    *
FROM silver.crm_prd_info;


-------------------------------------------------------------------------------

-- Check for date validation
SELECT 
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt = 0 
   OR LEN(sls_due_dt) != 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;


-- Check for date validation: order < ship, order < due
-- Expectations: No results
SELECT 
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;


-- Check for data consistency: sales, quantity, price
-- Sales = quantity * price
-- All values must not be negative, null, or zero
-- Expectations: No results
SELECT 
    sls_sales AS old_sales,
    sls_quantity,
    sls_price AS old_price,

    CASE 
        WHEN sls_sales IS NULL 
          OR sls_sales <= 0  
          OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    CASE 
        WHEN sls_price IS NULL 
          OR sls_price <= 0 
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price 
    END AS sls_price

FROM silver.crm_sales_details 
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0;


SELECT 
    *
FROM silver.crm_sales_details;


---------------------------------------------------------------------------------------------

-- Check for date validation
-- Expectations: No results
SELECT 
    bdate 
FROM silver.erp_CUST_AZ12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();


-- Check for data standardization & consistency
-- Expectations: No results
SELECT DISTINCT
    gen
FROM silver.erp_CUST_AZ12;


SELECT DISTINCT
    *
FROM silver.erp_CUST_AZ12;


-------------------------------------------------------------------------------------


-- Check for data standardization & consistency
-- Expectations: No results
SELECT DISTINCT
    cntry
FROM silver.erp_LOC_A101;


SELECT DISTINCT
    *
FROM silver.erp_LOC_A101;


-------------------------------------------------------------------------------------------


-- Check for unwanted spaces
-- Expectations: No results
SELECT
    subcat
FROM silver.erp_PX_CAT_G1V2
WHERE subcat != TRIM(subcat);


-- Check for data standardization & consistency
-- Expectations: No results
SELECT DISTINCT 
    maintenance 
FROM silver.erp_PX_CAT_G1V2;


SELECT  
    *
FROM silver.erp_PX_CAT_G1V2;
