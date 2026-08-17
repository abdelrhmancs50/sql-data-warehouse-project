/*
===============================================================
Create Gold Layer Views
===============================================================

Script Purpose:
    This script creates the Gold layer views used for analytics
    and reporting by combining and presenting business-ready data
    from the Silver layer.

WARNING:
    The views depend on the Silver layer tables and must be created
    after the required Silver tables have been loaded successfully.
*/


CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id             AS customer_id,
    ci.cst_key            AS customer_number,
    ci.cst_firstname      AS first_name,
    ci.cst_lastname       AS last_name,
    la.CNTRY              AS country,
    ci.cst_marital_status AS marital_status,

    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ca.bdate           AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

LEFT JOIN silver.erp_CUST_AZ12 ca
    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_LOC_A101 la
    ON ci.cst_key = la.cid;
GO


-- ==========================================================================


CREATE OR ALTER VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY pn.prd_start_dt, pn.prd_key
    ) AS product_key,

    pn.prd_id  AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm  AS product_name,
    pn.cat_id  AS category_id,

    pc.CAT     AS category,
    pc.SUBCAT  AS subcategory,
    pc.MAINTENANCE AS maintenance_required,

    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn

LEFT JOIN silver.erp_PX_CAT_G1V2 pc
    ON pn.cat_id = pc.ID

WHERE pn.prd_end_dt IS NULL;
GO


-- ==========================================================================


CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,

    sls_order_dt AS order_date,
    sls_ship_dt  AS shipping_date,
    sls_due_dt   AS due_date,

    sls_sales    AS sales_amount,
    sls_quantity AS quantity,
    sls_price    AS price

FROM silver.crm_sales_details sd

LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
