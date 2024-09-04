CREATE DATABASE IF NOT EXISTS walmart_sales_data;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(50) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
	gross_margin_percentage FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT (2,1)
);

SELECT *
FROM sales;

-- ---- Feature Engineering

-- time_of_day
SELECT time,
	(
    CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
	ELSE
		'Evening'
	END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(30);

UPDATE sales
SET time_of_day = (
CASE
		WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN `time` BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
	ELSE
		'Evening'
	END
);

-- day_name

SELECT `date`, 
DAYNAME(`date`) AS day_name
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(15);

UPDATE sales
SET day_name = 	DAYNAME(`date`);

-- month_name

SELECT `date`, 
MONTHNAME(`date`) AS month_name
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name  = 	MONTHNAME(`date`);

-- --- Generic
-- How many unique cities does the data have?

SELECT 
	DISTINCT City AS number_of_cities
FROM sales;

-- How many unique branches do we have?

SELECT 
	DISTINCT branch AS number_of_branches
FROM sales;

-- In which city is each individual branch

SELECT
	DISTINCT city,
    branch
FROM sales;

-- --Products

-- How many unique product lines does the data have?

SELECT 
	DISTINCT product_line
FROM sales;

-- common payment method

SELECT 
	payment_method, 
	COUNT(payment_method) AS count_payment_method
FROM sales
GROUP BY payment_method
ORDER BY count_payment_method DESC;

-- the most selling product_line

SELECT 
	 product_line,
     COUNT(product_line) AS count_product_line
FROM sales
GROUP BY product_line
ORDER BY count_product_line DESC;

-- Total revenue by month

SELECT 
	month_name, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- what month had the largest cogs

SELECT 
	month_name, 
    SUM(cogs) AS cogs_monthly
FROM sales
GROUP BY month_name
ORDER BY cogs_monthly DESC;

-- what product_line had the largest revenue?

SELECT 
	 product_line,
     SUM(total) AS revenue_product_line
FROM sales
GROUP BY product_line
ORDER BY revenue_product_line DESC;

-- city with the largest revenue

SELECT 
	 city, branch,
     SUM(total) AS revenue_city
FROM sales
GROUP BY city, branch
ORDER BY revenue_city DESC;

-- product_line with VAT

SELECT 
	 product_line,
     AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product_line and add a column to those product_line showing "Good","Bad". Good if it's greater than avg sales

-- branch that sold more products than average product sold

SELECT 
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > 
	(SELECT AVG(quantity) 
FROM sales);

-- most common product_line by gender

SELECT
	gender,
    product_line,
    COUNT(gender) AS count_gender
FROM sales
GROUP BY gender, product_line
ORDER BY product_line;

-- average rating of each product_line

SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ---Sales
-- Number of sales made in each time of day per week

SELECT 
	time_of_day,
    COUNT(*) AS total_per_day
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_per_day DESC;

-- customer that brings the most revenue

SELECT 
	customer_type,
    SUM(total) AS customer_sales
FROM sales
GROUP BY customer_type
ORDER BY customer_sales DESC;

-- city that has the largest tax percent

SELECT 
	city,
    AVG(VAT) AS city_tax
FROM sales
GROUP BY city
ORDER BY city_tax DESC;

-- customer type that pay more VAT

SELECT 
	customer_type,
    AVG(VAT) AS customer_VAT
FROM sales
GROUP BY customer_type
ORDER BY customer_VAT DESC;

-- ---Customer
-- Unique customer types in the data
SELECT 
	DISTINCT customer_type
FROM sales;

-- unique payment methods

SELECT 
	DISTINCT payment_method
FROM sales;

-- most common customer type

SELECT 
	customer_type,
	COUNT(customer_type) AS count_customertype
FROM sales
GROUP BY customer_type
ORDER BY count_customertype DESC;

-- customer type that buys the most

SELECT 
	customer_type,
	COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type
ORDER BY customer_count DESC;

-- most common gender
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- gender distribution by branch

SELECT 
	gender,
    COUNT(*) AS gender_branchcount
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_count DESC;

-- time of day that customers give most ratings

SELECT 
	time_of_day,
    AVG(rating) AS average_rating
FROM sales
GROUP BY time_of_day
ORDER BY average_rating DESC;


SELECT 
	time_of_day,
    AVG(rating) AS average_rating
FROM sales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY average_rating DESC;

    
-- day of week with the most avg rating

SELECT 
	day_name,
    AVG(rating) AS day_rating
FROM sales
GROUP BY day_name
ORDER BY day_rating DESC;

SELECT 
	day_name,
    AVG(rating) AS day_rating
FROM sales
WHERE branch = 'B'
GROUP BY day_name
ORDER BY day_rating DESC;


 







