-- Database creation
CREATE DATABASE sql_p1;

-- To make database default database
USE sql_p1;

-- Table creation 
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- How many uniuque categories we have ?
SELECT DISTINCT category FROM retail_sales;


-- *** Project: Data analysis and bussiness key problems & answers ***

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT 
	* 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT 
	* 
FROM retail_sales 
WHERE 
	category = 'Clothing' 
	AND quantity >= 4 
    AND sale_date between '2022-11-01' AND '2022-11-30';

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category. 
SELECT 
	category,
	SUM(total_sale)
FROM retail_sales
GROUP BY category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT 
	*
FROM retail_sales
WHERE total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    category,
     gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY 1;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH sale_cte AS
(
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS best_rank
FROM retail_sales
GROUP BY 1, 2
)
SELECT 
	year,
	month,
	avg_sale
FROM sale_cte
WHERE best_rank = 1;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM 
	retail_sales
GROUP BY 
	customer_id
ORDER BY 
	total_sales DESC
LIMIT 5;


-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
	COUNT(DISTINCT customer_id) AS customer_count,
	category
FROM retail_sales
GROUP BY 2;


-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH shift_cte AS
(
	SELECT 
	CASE WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN  'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17  THEN 'Afternoon'
	ELSE 'Evening' END AS shift
	FROM retail_sales
)

SELECT
	shift,
	COUNT(*) AS no_of_orders
	FROM shift_cte
GROUP BY shift;


-- *** END OF PROJECT***






