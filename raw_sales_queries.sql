-- Q_1: Which date corresponds to the highest number of sales?
SELECT date_sold AS 'date', COUNT(*) AS number_of_sales
FROM sold_units
GROUP BY date_sold
ORDER BY number_of_sales DESC
LIMIT 1;

-- Q_2: Find out the postcode with the highest average price per sale?
SELECT post_code, AVG(unit_price) AS 'average' FROM sold_units
GROUP BY post_code
ORDER BY average DESC
LIMIT 1;

-- Q_3: Which year witnessed the lowest number of sales?
SELECT YEAR(date_sold) AS 'year', COUNT(*) AS number_of_sales
FROM sold_units
GROUP BY YEAR(date_sold)
ORDER BY number_of_sales ASC
LIMIT 1;

-- Q_4: Use the window function to deduce the top six postcodes by year's price.
WITH saless AS (
  SELECT 
    year(date_sold) as 'year', 
    post_code, 
    unit_price,
    DENSE_RANK() OVER (PARTITION BY year(date_sold), post_code ORDER BY unit_price DESC) AS dense_rnk
  FROM sold_units
)
SELECT 
  year,
  post_code,
  unit_price
FROM (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY unit_price DESC) AS row_n
  FROM saless
  WHERE dense_rnk < 2
) AS e
WHERE row_n BETWEEN 1 AND 6;