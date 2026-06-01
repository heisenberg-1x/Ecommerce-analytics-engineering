SELECT DISTINCT
    DATE(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS date_id,
    YEAR(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS year,
    MONTH(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS month,
    DAY(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS day,
    QUARTER(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS quarter,
    DAYOFWEEK(TRY_TO_TIMESTAMP(order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS day_of_week
FROM {{ source('raw', 'orders') }}
WHERE order_purchase_timestamp IS NOT NULL