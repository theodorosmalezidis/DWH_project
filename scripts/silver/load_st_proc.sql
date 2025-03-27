/* 
----------------------------------------------------------------
Silver Schema Stored Procedure
----------------------------------------------------------------
This stored procedure executes the ETL (Extract, Transform, Load) process to transfer and cleanse data from the Bronze Schema to the Silver Schema tables (Bronze Schema -> Silver Schema).
Steps:
  - Truncates existing tables in the silver schema to ensure fresh data.
  - Extracts raw data from the bronze schema.
  - Transforms data by applying cleansing operations, including trimming, handling null values, and standardizing formats.
  - Loads the processed data into the silver schema.

To execute this stored procedure, you can use the following command: EXECUTE silver.load_schema
*/




CREATE OR ALTER PROCEDURE silver.load_schema AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=====================================================================';
		PRINT 'Loading Silver Schema';
		PRINT '=====================================================================';

		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------------------------------------';
TRUNCATE TABLE silver.crm_clients_info;
INSERT INTO silver.crm_clients_info(
	client_id,
	employee_id,
	client_full_name,
	client_gender,
	client_marital_status,
	create_date,
	end_date,
	country)
SELECT
	client_id,
	ISNULL(TRIM(employee_id), 'n/a') AS employee_id,
	ISNULL(TRIM(client_full_name), 'n/a') AS client_full_name,
	CASE WHEN UPPER(client_gender) = 'M' THEN 'Male'
		 WHEN UPPER(client_gender) = 'F' THEN 'Female'
		 ELSE 'n/a'
	END AS client_gender,
	CASE WHEN UPPER(client_marital_status) = 'S' THEN 'Single'
		 WHEN UPPER(client_marital_status) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END AS client_marital_status,
	create_date,
	end_date,
	ISNULL(TRIM(country), 'n/a') AS country
FROM (
    SELECT *, 
	ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY client_id) AS rn
    FROM bronze.crm_clients_info
) s
WHERE rn = 1 OR client_id IS NULL;

TRUNCATE TABLE silver.crm_prds_info;
INSERT INTO silver.crm_prds_info(
	product_id,
	product_type,
	product_name)
SELECT
	ISNULL(TRIM(product_id), 'n/a') AS product_id,
	UPPER(TRIM(product_type)) AS product_type,
	ISNULL(TRIM(product_name ), 'n/a') AS product_name
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY product_id ORDER BY product_id) AS rn
	FROM bronze.crm_prds_info
) s
WHERE rn=1 OR product_id IS NULL;


TRUNCATE TABLE silver.crm_branch_cnt_loc;
INSERT INTO silver.crm_branch_cnt_loc(
	branch,
	client_id)
SELECT
	ISNULL(TRIM(branch), 'n/a') AS branch,
	client_id
FROM (
    SELECT *, 
    ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY client_id) AS rn
    FROM bronze.crm_branch_cnt_loc
) s
WHERE rn = 1 OR client_id IS NULL;




TRUNCATE TABLE silver.crm_transactions_details;
INSERT INTO silver.crm_transactions_details(
	transaction_id,
	client_id,
	product_id,
	transaction_date,
	invested_amount,
	withdrawal_amount
)
SELECT
	ISNULL(TRIM(transaction_id), 'n/a') AS transaction_id,
	client_id,
	ISNULL(TRIM(product_id), 'n/a') AS product_id,
	CAST(transaction_date AS DATE) AS transaction_date,
	CAST(REPLACE(invested_amount, '$', '') AS INT) AS invested_amount,
	CAST(REPLACE(withdrawal_amount, '$', '') AS INT) AS withdrawal_amount
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) AS rn
	FROM bronze.crm_transactions_details
) s
WHERE rn=1 or transaction_id IS NULL
SET @end_time = GETDATE();
PRINT '** Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.'





SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------------------------------';
TRUNCATE TABLE silver.erp_HR_data;
INSERT INTO silver.erp_HR_data(
	employee_id,
	employee_full_name,
	employee_gender,
	employee_marital_status,
	department,
	position,
	hiring_date,
	end_date,
	salary
)
SELECT
	ISNULL(TRIM(employee_id), 'n/a') AS employee_id,
	TRIM(employee_full_name) AS employee_full_name,
	CASE WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male'
		 WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female'
		 ELSE 'n/a'
	END AS employee_gender,
	CASE WHEN UPPER(TRIM(marital_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(marital_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END AS employee_marital_status,
	UPPER(LEFT(TRIM(department), 1)) + LOWER(SUBSTRING(TRIM(department), 2, LEN(department))) AS department,
	TRIM(position) AS position,
	hiring_date,
	end_date,
	salary
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY employee_id) AS rn
	FROM bronze.erp_HR_data
) s
WHERE rn=1 or employee_id IS NULL;

TRUNCATE TABLE silver.erp_research_data;
INSERT INTO silver.erp_research_data(
	employee_id,
	product_id
)
SELECT
	ISNULL(TRIM(employee_id), 'n/a') AS employee_id,
	ISNULL(TRIM(product_id), 'n/a') AS product_id
FROM (
    SELECT 
        employee_id,
        product_id,
        ROW_NUMBER() OVER (PARTITION BY employee_id, product_id ORDER BY employee_id, product_id) AS rn
    FROM 
        bronze.erp_research_data
) s
WHERE 
    rn = 1 OR employee_id IS NULL OR product_id IS NULL;


TRUNCATE TABLE silver.erp_branch_emp_loc;
INSERT INTO silver.erp_branch_emp_loc(
	branch,
	employee_id
)
SELECT
	UPPER(LEFT(TRIM(branch), 1)) + LOWER(SUBSTRING(TRIM(branch), 2, LEN(branch))) AS branch,
	ISNULL(TRIM(employee_id), 'n/a') AS employee_id
FROM (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY employee_id) AS rn
	FROM bronze.erp_branch_emp_loc
) s
WHERE rn=1 or employee_id IS NULL;
SET @end_time = GETDATE();
PRINT '** Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'




		SET @batch_end_time = GETDATE();
		PRINT '==========================================================';
		PRINT 'Loading Silver Schema Completed'
		PRINT 'Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
		PRINT '==========================================================';
	END TRY
	BEGIN CATCH
		PRINT '==========================================================';
		PRINT 'ERROR: Execution failed loading Bronze Schema.';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT '==========================================================';
	END CATCH
END


