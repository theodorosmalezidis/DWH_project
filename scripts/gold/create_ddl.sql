/*
--------------------------------------------------------------------------
Create Views for Gold Schema
--------------------------------------------------------------------------

This script generates views for the Gold layer in the data warehouse. The Gold layer consists of the final dimension and fact tables (Star Schema).
Each view integrates data from the Silver layer to create a flexible and business-ready dataset (Silver Schema -> Star Schema).
*/



IF OBJECT_ID('gold.dim_clients', 'V') IS NOT NULL
    DROP VIEW gold.dim_clients;
GO

CREATE VIEW gold.dim_clients AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cl.client_id) AS client_key,
    cl.client_id,
    cl.client_full_name,
    cl.country,
    cl.client_gender,
    cl.client_marital_status,
    cl.create_date,
    cl.end_date AS closure_date,
    cl.employee_id,
    COALESCE(br.branch, 'n/a') AS branch
FROM silver.crm_clients_info cl
LEFT JOIN silver.crm_branch_cnt_loc br
ON cl.client_id = br.client_id;
GO


IF OBJECT_ID('gold.dim_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS
SELECT
    ROW_NUMBER() OVER (ORDER BY hr.employee_id) AS employee_key,
    hr.employee_id,
    hr.employee_full_name,
    hr.department,
    hr.position,
    COALESCE(br.branch, 'n/a') AS branch,
    hr.salary,
    hr.employee_gender,
    hr.employee_marital_status,
    hr.hiring_date,
    hr.end_date AS exit_date
FROM silver.erp_HR_data hr
LEFT JOIN silver.erp_branch_emp_loc br
ON hr.employee_id = br.employee_id;
GO


IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
    product_id,
    product_type,
    product_name
FROM silver.crm_prds_info;
GO


IF OBJECT_ID('gold.fact_transactions', 'V') IS NOT NULL
    DROP VIEW gold.fact_transactions;
GO

CREATE VIEW gold.fact_transactions AS
SELECT
    tr.transaction_id,
    cl.client_key,
    pr.product_key,
    tr.transaction_date,
    tr.invested_amount,
    tr.withdrawal_amount
FROM silver.crm_transactions_details tr
LEFT JOIN gold.dim_clients cl
ON tr.client_id = cl.client_id
LEFT JOIN gold.dim_products pr
ON tr.product_id = pr.product_id;
GO


IF OBJECT_ID('gold.fact_employee_client', 'V') IS NOT NULL
    DROP VIEW gold.fact_employee_client;
GO

CREATE VIEW gold.fact_employee_client AS
SELECT
    cl.client_key,
    hr.employee_key
FROM gold.dim_clients cl
LEFT JOIN gold.dim_employees hr
ON cl.employee_id = hr.employee_id;
GO


IF OBJECT_ID('gold.fact_employee_product', 'V') IS NOT NULL
    DROP VIEW gold.fact_employee_product;
GO

CREATE VIEW gold.fact_employee_product AS
SELECT
    pr.product_key,
    hr.employee_key
FROM silver.erp_research_data re
LEFT JOIN gold.dim_employees hr
ON hr.employee_id = re.employee_id
LEFT JOIN gold.dim_products pr
ON re.product_id = pr.product_id;
GO
