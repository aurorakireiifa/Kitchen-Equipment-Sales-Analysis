
-- Kitchen Equipment Sales Analysis
-- Tool: Google BigQuery

-- 1. Retrieve order IDs
SELECT order_id
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`;


-- 2. Retrieve order IDs and sales dates
SELECT order_id, sales_date
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`;


-- 3. Retrieve orders with a valid sales date
SELECT *
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE sales_date IS NOT NULL;


-- 4. Retrieve cancelled orders
SELECT *
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'cancel';


-- 5. Find cancelled kitchen equipment orders
SELECT
  sales_date,
  order_id,
  product_name,
  category_clean
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE category_clean = 'Alat Masak'
  AND status_clean = 'cancel'
ORDER BY sales_date
LIMIT 5;


-- 6. Calculate total sales from completed orders in 2025
SELECT SUM(total_sales) AS total_sales_2025
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete'
  AND sales_date >= DATE '2025-01-01'
  AND sales_date < DATE '2026-01-01';


-- 7. Calculate completed sales by product category
SELECT
  category_clean,
  SUM(total_sales) AS revenue
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE status_clean = 'complete'
GROUP BY category_clean
ORDER BY revenue DESC;


-- 8. Classify spending by order value
-- Small: less than IDR 500,000
-- Medium: IDR 500,000 to less than IDR 2,000,000
-- Large: IDR 2,000,000 or more

SELECT
  order_id,
  total_sales,
  CASE
    WHEN total_sales >= 2000000 THEN 'Large'
    WHEN total_sales >= 500000 THEN 'Medium'
    ELSE 'Small'
  END AS spending_category
FROM `digital-yeti-501312-b7.toko_peralatan_dapur.orders`
WHERE sales_date IS NOT NULL;


