/*
===============================================================
Load Silver Layer
===============================================================

Script Purpose:
    This stored procedure transforms and loads cleaned and
    standardized data from the Bronze layer into the Silver layer.

WARNING:
    - Each Silver table is truncated before loading, so existing
      data in these tables will be permanently removed.
    - The transformation logic assumes that the Bronze tables
      contain the expected source data structure.
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @startTime DATETIME,
                @endTime DATETIME,
                @batchStartTime DATETIME,
                @batchEndTime DATETIME;

        SET @batchStartTime = GETDATE();


        -- Clean and load CRM customer information
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.crm_cust_info IS BEING TRUNCATED';

        TRUNCATE TABLE silver.crm_cust_info;

        PRINT 'TABLE silver.crm_cust_info IS BEING INSERTED';

        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname) AS cst_lastname,
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_marital_status,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,
            cst_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (
                    PARTITION BY cst_id
                    ORDER BY cst_create_date DESC
                ) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Clean and transform CRM product information
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.crm_prd_info IS BEING TRUNCATED';

        TRUNCATE TABLE silver.crm_prd_info;

        PRINT 'TABLE silver.crm_prd_info IS BEING INSERTED';

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,
            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            CAST(prd_start_dt AS DATE) AS prd_start_dt,
            CAST(
                LEAD(prd_start_dt) OVER (
                    PARTITION BY prd_key
                    ORDER BY prd_start_dt
                ) - 1 AS DATE
            ) AS prd_end_dt
        FROM bronze.crm_prd_info;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Clean and validate CRM sales transaction data
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.crm_sales_details IS BEING TRUNCATED';

        TRUNCATE TABLE silver.crm_sales_details;

        PRINT 'TABLE silver.crm_sales_details IS BEING INSERTED';

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,

            CASE
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_order_dt))
            END AS sls_order_dt,

            CASE
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_ship_dt))
            END AS sls_ship_dt,

            CASE
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE TRY_CONVERT(DATE, CONVERT(VARCHAR(8), sls_due_dt))
            END AS sls_due_dt,

            CASE
                WHEN sls_sales IS NULL
                     OR sls_sales <= 0
                     OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,

            sls_quantity,

            CASE
                WHEN sls_price IS NULL OR sls_price <= 0
                THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price

        FROM bronze.crm_sales_details;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Clean and standardize ERP customer information
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.erp_CUST_AZ12 IS BEING TRUNCATED';

        TRUNCATE TABLE silver.erp_CUST_AZ12;

        PRINT 'TABLE silver.erp_CUST_AZ12 IS BEING INSERTED';

        INSERT INTO silver.erp_CUST_AZ12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,

            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,

            CASE
                WHEN UPPER(TRIM(gen)) IN ( 'F', 'Female') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ( 'M', 'Male')   THEN 'Male'
                ELSE 'n/a'
            END AS gen

        FROM bronze.erp_CUST_AZ12;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Clean and standardize ERP customer location information
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.erp_LOC_A101 IS BEING TRUNCATED';

        TRUNCATE TABLE silver.erp_LOC_A101;

        PRINT 'TABLE silver.erp_LOC_A101 IS BEING INSERTED';

        INSERT INTO silver.erp_LOC_A101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid,

            CASE
                WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
                WHEN UPPER(TRIM(cntry)) IN ('USA', 'US') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE UPPER(TRIM(cntry))
            END AS cntry

        FROM bronze.erp_LOC_A101;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load ERP product category information
        SET @startTime = GETDATE();

        PRINT 'TABLE silver.erp_PX_CAT_G1V2 IS BEING TRUNCATED';

        TRUNCATE TABLE silver.erp_PX_CAT_G1V2;

        PRINT 'TABLE silver.erp_PX_CAT_G1V2 IS BEING INSERTED';

        INSERT INTO silver.erp_PX_CAT_G1V2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_PX_CAT_G1V2;

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';


        PRINT '===========================================================================';

        SET @batchEndTime = GETDATE();

        PRINT 'Loading Silver Layer was completed.';
        PRINT ' - The whole batch duration: '
            + CAST(DATEDIFF(SECOND, @batchStartTime, @batchEndTime) AS NVARCHAR) + ' sec.';

        PRINT '===========================================================================';


    END TRY

    BEGIN CATCH

        PRINT '=======================================================';
        PRINT 'Error occurred during loading Silver Layer.';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=======================================================';

        THROW;

    END CATCH
END;
