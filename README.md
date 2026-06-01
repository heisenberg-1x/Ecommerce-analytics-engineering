# RetailX — End-to-End Data Pipeline Project

## Overview
An end-to-end data pipeline built on a real-world Brazilian e-commerce dataset 
(Olist). Designed to demonstrate Analytics Engineering skills including data 
modeling, cloud warehousing, transformation pipelines, data quality testing 
and business analytics.

## Tech Stack
- **Snowflake** — Cloud data warehouse
- **dbt** — Data transformation, testing and documentation
- **Python** — Data exploration and automated ingestion
- **SQL** — Business analytics queries

## Data Model
Star schema with one fact table and three dimension tables.

### Grain
One row in Fact_Sales = one order item within a delivered order

### Tables
| Table | Type | Description |
|---|---|---|
| fact_sales | Fact | One row per order item, delivered orders only |
| dim_customer | Dimension | Unique customer details and location |
| dim_product | Dimension | Product details with English category names |
| dim_date | Dimension | Date attributes extracted from order timestamps |

## Pipeline Flow

Raw CSVs → Python Ingestion → Snowflake RAW Schema
→ dbt Transformations → Snowflake ANALYTICS Schema
→ SQL Business Queries

## Key Engineering Decisions

**1. Grain set at order item level, not order level**
EDA revealed 9,803 orders contained multiple items (max 21 items).
Setting grain at order level would have lost product-level detail.

**2. Payment deduplication using ROW_NUMBER()**
EDA revealed 2,961 orders had multiple payment records (max 29 rows).
ROW_NUMBER() partitioned by order_id ordered by payment_value DESC
ensured one payment row per order without losing any orders.

**3. LEFT JOIN on all dimension tables**
Prevents silent data loss. Orders without matching dimension records
retain NULL values rather than being dropped from the fact table.

**4. Raw layer stores timestamps as VARCHAR**
Source data timestamp format (DD-MM-YYYY) differs from Snowflake default.
Type conversion handled in dbt transformation layer using TRY_TO_TIMESTAMP()
with explicit format mask.

**5. English category names via LEFT JOIN**
610 products had no Portuguese category name. LEFT JOIN on translation
table retains all products — unmatched ones show NULL for English category.

## Data Quality Tests
- Unique and not_null on all dimension primary keys
- not_null on fact_sales key columns
- accepted_values — order_status must be 'delivered'
- Singular test — no negative revenue values

## Business Queries
Four business questions answered using the modeled data:
1. Revenue by product category
2. Monthly order trend
3. Revenue by customer state  
4. Payment method distribution

## Key EDA Findings
- 99,441 unique orders across 112,650 order items
- 775 orders existed with no items — all cancelled or unavailable status
- 2,961 orders had multiple payment methods — handled via deduplication
- 610 products missing category names — retained via LEFT JOIN

## Project Structure

retailx/
├── exploration/          # Python EDA notebook and ingestion script
├── models/               # dbt models, sources and schema definitions
├── tests/                # Custom dbt singular tests
├── analysis/             # SQL business queries
└── dbt_project.yml       # dbt project configuration

## dbt Lineage
![alt text](<Screenshot 2026-04-21 095734.png>)
