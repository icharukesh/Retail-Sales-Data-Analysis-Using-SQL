-- Create Table
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

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

--Data Cleaning

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
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

	
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
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
--Data Exploration

-- How many sales we have?
SELECT COUNT(*) FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Types of category we have?
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Buissness key problems & Answers:

-- Q1) Write a SQL query to retrieve all columns for sales made on '2022-11-05'?

SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';

-- Q2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022?
SELECT *
FROM retail_sales
WHERE category='Clothing' AND quantity >=4 AND TO_CHAR(sale_date,'YYYY-MM')='2022-11';

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
SELECT ROUND(AVG(age),2) AS Average_Age 
FROM retail_sales
WHERE category='Beauty';

-- Q5) Write a SQL query to find all transactions where the total_sale is greater than 1000?
SELECT *	
FROM retail_sales
WHERE total_sale > 1000;

-- Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?
SELECT category,COUNT(transactions_id) AS No_Of_Transactions,gender
FROM retail_sales
GROUP BY gender, category;

-- Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_total_sales,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1,2;

-- Q8) Write a SQL query to find the top 5 customers based on the highest total sales?
SELECT customer_id,SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5

-- Q9) Write a SQL query to find the number of unique customers who purchased items from each category?
SELECT category,COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category 

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
