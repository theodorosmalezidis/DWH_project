# MetaData Dictionary for Gold Layer (Star Schema)


---

### 1. **gold.dim_clients**


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| client_key       | INT           | A surrogate key system-generated for each client in the dimension table.               |
| client_id        | INT           | A unique numeric id assigned to each client from the source records.                                        |
| client_full_name | NVARCHAR(50)  | The client's full name.         |
| country          | NVARCHAR(50)  | Country where the client is based.                                         |
| client_gender    | NVARCHAR(50)  | The client's gender ('Male', 'Female').                                                     |
| client_  marital_status| NVARCHAR(50)  | The client's marital status ('Married', 'Single').                               |
| create_date      | DATE          | The date when the client initiated their portfolio with the firm.                              |
| closure_date     | DATE          | The date marking the formal closure of the client's portfolio, if applicable.                                  |
| employee_id      | NVARCHAR(50)  | A unique id assigned to the employee that manages the client's portfolio.               |
| branch           | NVARCHAR(50)  | The location of the branch of the firm that manages the client's portfolio.|

---

### 2. **gold.dim_products**


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key      | INT           | A surrogate key system-generated for each product in the dimension table.                               |
| product_id       | NVARCHAR(50)  | A unique alphanumeric id assigned to each product from the source records.                                 |
| product_type     | NVARCHAR(50)  | Categories of products ('ETF', 'BOND', 'STOCK').                                              |
| product_name     | NVARCHAR(50)  | The formal names or identifiers of financial products (e.g., 'Apple', 'VOO') as recognized by the Securities and Exchange Commission (SEC).                                                                                                         |

---

### 3. **gold.dim_employees**


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| employee_key     | INT           | A surrogate key system-generated for each employee in the dimension table.                              |
| employee_id      | NVARCHAR(50)  | A unique alphanumeric id assigned to each employee from the source records.                        |
| employee_full_name| NVARCHAR(50) | The employee's full name.                                                                     |
| department       | NVARCHAR(50)  | The department or functional area in which an employee is assigned or actively working ('Investments',  'Research').                                                                                                                       |
| position         | NVARCHAR(50)  | The specific role or position held by an employee within their assigned department. (e.g., 'Analyst', 'Portfolio Manager', 'Investment Strategist').                                                                                                                      |
| branch           | NVARCHAR(50)  | The location of the branch to which the employee is assigned within the firm.                 |
| salary           | INT           | The employee's yearly salary in USD.                                                            |
| employee_gender  | NVARCHAR(50)  | The  employee's gender ('Male', 'Female').                                                    |
| employee_ marital_status| NVARCHAR(50)  | The  employee's marital status ('Married', 'Single').                                  |
| hiring_date      | DATE          | The date when the employee officially joined the firm..                                       |
| exit_date        | DATE          | The date on which the employee's contract with the firm ended, if applicable.                 |
 
---

### 4. **gold.fact_transactions**


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| transaction_id   | NVARCHAR(50)  | A unique alphanumeric id assigned to each transaction from the source records.                |
| client_key       | INT           | A surrogate key that connects transactions to the clients dimension table.                    |
| product_key      | INT           | A surrogate key that connects transactions to the products dimension table.                   |
| transaction_date | DATE          | The date when the transaction took place.                                                     |
| invested_amount  | INT           | The total amount of money invested from client for this transaction in USD, if applicable.    |
| withdrawal_amount| INT           | The total value of products that were sold and subsequently withdrawn from the client's portfolio during this transaction in USD, if applicable.                 |

---

### 5. **gold.fact_employee_client** (A table that connects the clients to the employees that manages their portfolio)


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| client_key       | INT           | A surrogate key that connects the employees dimension table to the clients dimension table.   |
| employee_key     | INT           | A surrogate key that connects the employee-client fact table to the employees dimension table.|

---

### 6. **gold.fact_employee_product**(A table that connects employees to the products they have researched and analyzed)


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key      | INT           | A surrogate key that connects the products dimension table to the employees dimension table.  |
| employee_key     | INT           | A surrogate key that connects the employees dimension table to the products dimension table.  |

