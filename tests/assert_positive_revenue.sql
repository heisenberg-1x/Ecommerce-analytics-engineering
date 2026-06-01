SELECT *
FROM {{ ref('fact_sales') }}
WHERE price < 0
   OR freight_value < 0
   OR total_amount < 0