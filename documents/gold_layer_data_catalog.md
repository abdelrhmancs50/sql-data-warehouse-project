# Data Catalog for Gold Layer

## Overview

The Gold Layer contains business-ready data designed for analytics, reporting, and decision-making. It includes dimension tables that describe business entities and a fact table that stores sales transactions and measurable business data.

---

### 1. **gold.dim_customers**

- **Purpose:** Contains customer information combined with demographic and geographic attributes.
- **Columns:**

| Column Name     | Data Type    | Description                                                                   |
| --------------- | ------------ | ----------------------------------------------------------------------------- |
| customer_key    | INT          | Surrogate key that uniquely identifies each customer record in the dimension. |
| customer_id     | INT          | Unique identifier assigned to the customer.                                   |
| customer_number | NVARCHAR(50) | Alphanumeric customer identifier used for tracking and reference.             |
| first_name      | NVARCHAR(50) | Customer's first name.                                                        |
| last_name       | NVARCHAR(50) | Customer's last name.                                                         |
| country         | NVARCHAR(50) | Customer's country of residence.                                              |
| marital_status  | NVARCHAR(50) | Customer's marital status, such as Married or Single.                         |
| gender          | NVARCHAR(50) | Customer's gender, such as Male, Female, or n/a.                              |
| birthdate       | DATE         | Customer's date of birth in YYYY-MM-DD format.                                |
| create_date     | DATE         | Date when the customer record was created in the system.                      |

---

### 2. **gold.dim_products**

- **Purpose:** Contains product information and the main attributes used to analyze products.
- **Columns:**

| Column Name          | Data Type    | Description                                                                           |
| -------------------- | ------------ | ------------------------------------------------------------------------------------- |
| product_key          | INT          | Surrogate key that uniquely identifies each product record in the dimension.          |
| product_id           | INT          | Unique identifier assigned to the product.                                            |
| product_number       | NVARCHAR(50) | Alphanumeric product code used for tracking, categorization, and inventory.           |
| product_name         | NVARCHAR(50) | Name of the product, including relevant product details such as type, color, or size. |
| category_id          | NVARCHAR(50) | Identifier of the product's main category.                                            |
| category             | NVARCHAR(50) | Main category used to group related products, such as Bikes or Components.            |
| subcategory          | NVARCHAR(50) | More specific classification of the product within its main category.                 |
| maintenance_required | NVARCHAR(50) | Indicates whether the product requires maintenance, such as Yes or No.                |
| cost                 | INT          | Base cost of the product in whole currency units.                                     |
| product_line         | NVARCHAR(50) | Product line or series, such as Road, Mountain, or Touring.                           |
| start_date           | DATE         | Date when the product became available for sale or use.                               |

---

### 3. **gold.fact_sales**

- **Purpose:** Contains sales transactions and measures used for sales analysis and reporting.
- **Columns:**

| Column Name   | Data Type    | Description                                                               |
| ------------- | ------------ | ------------------------------------------------------------------------- |
| order_number  | NVARCHAR(50) | Alphanumeric identifier of the sales order, such as SO54496.              |
| product_key   | INT          | Surrogate key that links the sales transaction to the product dimension.  |
| customer_key  | INT          | Surrogate key that links the sales transaction to the customer dimension. |
| order_date    | DATE         | Date when the order was placed.                                           |
| shipping_date | DATE         | Date when the order was shipped to the customer.                          |
| due_date      | DATE         | Date when payment for the order was due.                                  |
| sales_amount  | INT          | Total sales value of the line item in whole currency units.               |
| quantity      | INT          | Number of product units included in the sales line item.                  |
| price         | INT          | Price per unit of the product in whole currency units.                    |
