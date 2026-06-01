import snowflake.connector
import pandas as pd
import os

# Snowflake connection
conn = snowflake.connector.connect(
    account="ph72377.ap-southeast-1",
    user="Pranav1999",
    password=os.environ.get("DBT_SNOWFLAKE_PASSWORD"),
    warehouse="COMPUTE_WH",
    database="RETAILX",
    schema="RAW"
)

cursor = conn.cursor()
print("Connected to Snowflake successfully")

##################################################################

# Path to your CSV files
data_path = r"C:\Users\prana\Desktop\RetailX Project"

# Tables to load
tables = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "products": "olist_products_dataset.csv",
    "product_category_name_translation": "product_category_name_translation.csv"
}

for table_name, file_name in tables.items():
    file_path = os.path.join(data_path, file_name)
    df = pd.read_csv(file_path)
    
    # Uppercase column names to match Snowflake
    df.columns = df.columns.str.upper()
    
    # Truncate existing table before loading
    cursor.execute(f"TRUNCATE TABLE {table_name}")
    
    # Write dataframe to Snowflake
    from snowflake.connector.pandas_tools import write_pandas
    success, chunks, rows, output = write_pandas(conn, df, table_name.upper())
    
    if success:
        print(f"Loaded {rows} rows into {table_name}")
    else:
        print(f"Failed to load {table_name}")

cursor.close()
conn.close()
print("Connection closed")