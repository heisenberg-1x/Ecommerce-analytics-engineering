-- ============================================
-- RetailX Business Queries
-- Author: Pranav KS
-- Description: Business analysis queries built
--              on top of the RetailX star schema
-- ============================================


-- ============================================
-- Query 1: Revenue by Product Category
-- Description: Top 10 product categories by 
--              total revenue and order count
-- ============================================
SELECT 
    p.product_category_name_english,
    ROUND(SUM(f.total_amount), 2) AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM RETAILX.ANALYTICS.FACT_SALES f
LEFT JOIN RETAILX.ANALYTICS.DIM_PRODUCT p
    ON f.product_id = p.product_id
GROUP BY p.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- Query 2: Monthly Order Trend
-- Description: Monthly revenue and order volume
--              trend across all years
-- ============================================
SELECT
    d.year,
    d.month,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.total_amount), 2) AS total_revenue
FROM RETAILX.ANALYTICS.FACT_SALES f
LEFT JOIN RETAILX.ANALYTICS.DIM_DATE d
    ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;


-- ============================================
-- Query 3: Revenue by Customer State
-- Description: Top 10 states by revenue,
--              order count and average order value
-- ============================================
SELECT
    c.customer_state,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.total_amount), 2) AS total_revenue,
    ROUND(AVG(f.total_amount), 2) AS avg_order_value
FROM RETAILX.ANALYTICS.FACT_SALES f
LEFT JOIN RETAILX.ANALYTICS.DIM_CUSTOMER c
    ON f.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================
-- Query 4: Payment Method Distribution
-- Description: Order volume and revenue split
--              across different payment methods
-- ============================================
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM RETAILX.ANALYTICS.FACT_SALES
GROUP BY payment_type
ORDER BY total_orders DESC;