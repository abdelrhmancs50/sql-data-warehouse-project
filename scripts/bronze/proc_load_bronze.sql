/*
===============================================================
Load Bronze Layer
===============================================================

Script Purpose:
    This stored procedure loads raw data from CRM and ERP CSV
    files into the Bronze layer tables.

WARNING:
    - Each table is truncated before loading, so existing data
      in the Bronze tables will be permanently removed.
    - The file paths used by BULK INSERT must be accessible from
      the SQL Server machine, not just from the SSMS machine.
    - Make sure the SQL Server service account has permission
      to access the source files.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    BEGIN TRY
        DECLARE @startTime DATETIME,
                @endTime DATETIME,
                @batchStartTime DATETIME,
                @batchEndTime DATETIME;

        SET @batchStartTime = GETDATE();


        -- Load CRM customer information
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load CRM product information
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load CRM sales details
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load ERP customer information
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.erp_CUST_AZ12;

        BULK INSERT bronze.erp_CUST_AZ12
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load ERP customer location information
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.erp_LOC_A101;

        BULK INSERT bronze.erp_LOC_A101
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';
        PRINT '------------------------------------------------------------------------------';


        -- Load ERP product category information
        SET @startTime = GETDATE();

        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'D:\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @endTime = GETDATE();

        PRINT 'The duration time: '
            + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR) + ' sec.';


        PRINT '===========================================================================';

        SET @batchEndTime = GETDATE();

        PRINT 'Loading Bronze Layer was completed.';
        PRINT ' - The whole batch duration: '
            + CAST(DATEDIFF(SECOND, @batchStartTime, @batchEndTime) AS NVARCHAR) + ' sec.';

        PRINT '===========================================================================';


    END TRY

    BEGIN CATCH

        PRINT '=======================================================';
        PRINT 'Error occurred during loading Bronze Layer.';
        PRINT 'Error message: ' + ERROR_MESSAGE();
        PRINT 'Error number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=======================================================';

        THROW;

    END CATCH
END;
