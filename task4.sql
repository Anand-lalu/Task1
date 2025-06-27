SELECT 
  SUM(quantity) AS total_quantity_sold,
  AVG(price) AS average_price,
  COUNT(*) AS number_of_sales
FROM sales;
SELECT 
  category,
  SUM(quantity) AS total_quantity,
  AVG(price) AS avg_price,
  COUNT(*) AS sale_count
FROM sales
GROUP BY category;
SELECT 
  category,
  SUM(quantity) AS total_quantity,
  AVG(price) AS avg_price
FROM sales
GROUP BY category
HAVING SUM(quantity) > 5;
