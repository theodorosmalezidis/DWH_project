
DROP TABLE IF EXISTS bronze.crm_clients_info;
CREATE TABLE bronze.crm_clients_info(
client_id INT,
employee_id NVARCHAR(50),
client_full_name NVARCHAR(50),
client_marital_status NVARCHAR(50),
client_gender NVARCHAR(50),
create_date DATE,
end_date DATE,
country NVARCHAR(50),
);

DROP TABLE IF EXISTS bronze.crm_prds_info;
CREATE TABLE bronze.crm_prds_info(
product_id NVARCHAR(50),
product_type NVARCHAR(50),
product_name NVARCHAR(150),
);

DROP TABLE IF EXISTS bronze.crm_branch_cnt_loc;
CREATE TABLE bronze.crm_branch_cnt_loc(
branch NVARCHAR(50),
client_id INT,
);


DROP TABLE IF EXISTS bronze.crm_transactions_details;
CREATE TABLE bronze.crm_transactions_details(
transaction_id NVARCHAR(50),
client_id INT,
product_id NVARCHAR(50),
transaction_date DATETIME,
invested_amount INT,
withdrawal_amount INT,
);

DROP TABLE IF EXISTS bronze.erp_HR_data;
CREATE TABLE bronze.erp_HR_data(
employee_id NVARCHAR(50),
employee_full_name NVARCHAR(50),
gender NVARCHAR(50),
marital_status NVARCHAR(50),
department NVARCHAR(50),
position NVARCHAR(50),
hiring_date DATE,
end_date DATE,
salary INT,
);

DROP TABLE IF EXISTS bronze.erp_research_data;
CREATE TABLE bronze.erp_research_data(
employee_id NVARCHAR(50),
product_id NVARCHAR(50),
);

DROP TABLE IF EXISTS bronze.erp_branch_emp_loc;
CREATE TABLE bronze.erp_branch_emp_loc(
branch NVARCHAR(50),
employee_id NVARCHAR(50),
);
