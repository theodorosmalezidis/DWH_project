/* 
----------------------------------------------------------------
Bronze Schema Stored Procedure
----------------------------------------------------------------
This script creates the stored procedure to load the data from external source into the Bronze Schema tables (Source -> Brone Schema)
Steps:
	- Truncates the tables before loading data.
  - Uses the `BULK INSERT` command to load data from csv Files into tables.

To execute this stored procedure, you can use the following command: EXECUTE bronze.load_schema
*/




CREATE OR ALTER PROCEDURE bronze.load_schema AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=====================================================================';
		PRINT 'Loading Bronze Schema';
		PRINT '=====================================================================';

		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------------------------------------';
		TRUNCATE TABLE bronze.crm_branch_cnt_loc;
		BULK INSERT bronze.crm_branch_cnt_loc
		FROM 'C:\Users\User\Desktop\dwh project\sources\crm\branch_cnt_loc.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);


		TRUNCATE TABLE bronze.crm_clients_info;
		BULK INSERT bronze.crm_clients_info
		FROM 'C:\Users\User\Desktop\dwh project\sources\crm\clients_info.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);


		TRUNCATE TABLE bronze.crm_prds_info;
		BULK INSERT bronze.crm_prds_info
		FROM 'C:\Users\User\Desktop\dwh project\sources\crm\prds_info.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);


		TRUNCATE TABLE bronze.crm_transactions_details;
		BULK INSERT bronze.crm_transactions_details
		FROM 'C:\Users\User\Desktop\dwh project\sources\crm\transactions_details.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);
		SET @end_time = GETDATE();
		PRINT '** Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
		PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.'

		
		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------------------------------';
		TRUNCATE TABLE bronze.erp_branch_emp_loc;
		BULK INSERT bronze.erp_branch_emp_loc
		FROM 'C:\Users\User\Desktop\dwh project\sources\erp\branch_emp_loc.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);


		TRUNCATE TABLE bronze.erp_HR_data;
		BULK INSERT bronze.erp_HR_data
		FROM 'C:\Users\User\Desktop\dwh project\sources\erp\HR_data.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);


		TRUNCATE TABLE bronze.erp_research_data;
		BULK INSERT bronze.erp_research_data
		FROM 'C:\Users\User\Desktop\dwh project\sources\erp\research_data.csv'
		WITH (
			FIRSTROW=2, 
			FIELDTERMINATOR = ';'
		);
		SET @end_time = GETDATE();
		PRINT '** Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'


		SET @batch_end_time = GETDATE();
		PRINT '==========================================================';
		PRINT 'Loading Bronze Schema Completed'
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




