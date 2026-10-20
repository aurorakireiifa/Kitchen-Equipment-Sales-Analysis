```sql
-- =====================================================
-- Kitchen Equipment Sales Analysis
-- Tool: Google BigQuery
-- Purpose: Explore sales performance and generate
-- insights for the Looker Studio dashboard
-- =====================================================


-- 1. DATA EXPLORATION
-- Preview the dataset
SELECT *
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
LIMIT 10;


-- 2. DATA QUALITY CHECK
-- Check total rows and records with valid order IDs
SELECT
  COUNT(*) AS total_rows,
  COUNT(order_id) AS valid_order_ids,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNTIF(sales_date IS NULL) AS missing_sales_dates,
  COUNTIF(total_sales IS NULL) AS missing_sales_values
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`;


-- 3. ORDER STATUS SUMMARY
-- Analyze the number of unique orders by status
SELECT
  status_clean,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(total_sales) AS total_sales
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
GROUP BY status_clean
ORDER BY total_orders DESC;


-- 4. OVERALL SALES KPI
-- Calculate completed sales and unique orders
SELECT
  SUM(total_sales) AS total_sales,
  COUNT(DISTINCT order_id) AS total_orders
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete';


-- 5. MONTHLY SALES TREND
-- Analyze completed sales by month in 2025
SELECT
  FORMAT_DATE('%Y-%m', sales_date) AS sales_month,
  SUM(total_sales) AS monthly_sales,
  COUNT(DISTINCT order_id) AS total_orders
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete'
  AND sales_date >= DATE '2025-01-01'
  AND sales_date < DATE '2026-01-01'
GROUP BY sales_month
ORDER BY sales_month;


-- 6. SALES BY PRODUCT CATEGORY
-- Identify the highest-revenue categories
SELECT
  category_clean,
  SUM(total_sales) AS revenue,
  SAFE_DIVIDE(
    SUM(total_sales),
    SUM(SUM(total_sales)) OVER ()
  ) * 100 AS revenue_percentage
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete'
GROUP BY category_clean
ORDER BY revenue DESC;


-- 7. TOP 5 PRODUCTS BY SALES
-- Identify the top-performing products
SELECT
  product_name,
  SUM(total_sales) AS total_sales
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete'
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;


-- 8. CANCELLED ORDERS
-- Review cancelled orders by category
SELECT
  category_clean,
  COUNT(DISTINCT order_id) AS cancelled_orders,
  SUM(total_sales) AS cancelled_sales_value
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'cancel'
GROUP BY category_clean
ORDER BY cancelled_orders DESC;


-- 9. SPENDING CLASSIFICATION
-- Classify order values into spending groups
SELECT
  order_id,
  total_sales,
  CASE
    WHEN total_sales >= 2000000 THEN 'Large'
    WHEN total_sales >= 500000 THEN 'Medium'
    ELSE 'Small'
  END AS spending_category
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE order_id IS NOT NULL;
```


