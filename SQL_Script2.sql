SELECT *,
       AVG(total) OVER (PARTITION BY product_line) AS avg_product_revenue
FROM sales;
