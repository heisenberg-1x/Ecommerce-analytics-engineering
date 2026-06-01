WITH payments AS (
    SELECT
        order_id,
        payment_type,
        payment_installments,
        payment_value,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY payment_value DESC) AS rn
    FROM {{ source('raw', 'order_payments') }}
),
payment_info as (
SELECT
    order_id,
    payment_type,
    payment_installments
FROM payments
WHERE rn = 1
)
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    o.customer_id,
    DATE(TRY_TO_TIMESTAMP(o.order_purchase_timestamp, 'DD-MM-YYYY HH24:MI')) AS date_id,
    o.order_status,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_amount,
    op.payment_type,
    op.payment_installments
FROM {{ source('raw', 'order_items') }} oi
LEFT JOIN {{ source('raw', 'orders') }} o
    ON oi.order_id = o.order_id
LEFT JOIN payment_info op
    ON oi.order_id = op.order_id
WHERE o.order_status = 'delivered'