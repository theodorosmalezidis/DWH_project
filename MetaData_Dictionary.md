# MetaData Dictionary for Gold Layer (Star Schema)


---

### 1. **gold.dim_clients**


| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| client_key       | INT           | A unique surrogate key for each client in the dimension table.               |
| client_id        | INT           | A unique id assigned to each client from the source records.                                        |
| client_full_name | NVARCHAR(50)  | The client's full name.         |
| country          | NVARCHAR(50)  | Country where the client is based.                                         |
| client_gender    | NVARCHAR(50)  | The client's gender ('Male', 'Female').                                                     |
| client_  marital_status| NVARCHAR(50)  | The client's marital status ('Married', 'Single').                               |
| create_date      | DATE          | The date when the client initiated their portfolio with the firm.                              |
| closure_date     | DATE          | The date marking the formal closure of the client's portfolio.                                  |
| employee_id      | NVARCHAR(50)  | A unique id assigned to the employee that manages the client's portfolio.               |
| branch           | NVARCHAR(50)  | The location of the branch of the firm that manages the client's portfolio.|

---

