-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales; 

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct DECIMAL(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct DECIMAL(11,9),
    gross_income DECIMAL(12, 4),
    rating DECIMAL(2, 1)
);


-- Add time of day--
SELECT time, 
    CASE
    WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE 'Evening'
    END AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE
       WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
       WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
       ELSE 'Evening'
    END);
SET SQL_SAFE_UPDATES = 0;

-- Day name--
SELECT date, DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Month name--
SELECT date, MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- Business Questions To Answer

-- Generic Questions
-- 1.How many unique cities does the data have?
SELECT DISTINCT city FROM sales;

-- 2.In which city is each branch?
SELECT DISTINCT branch, city FROM sales;

-- Product Questions
-- 1.How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) FROM sales;

-- 2.What is the most common payment method?
SELECT
  payment, COUNT(payment) AS payment_count
FROM sales
GROUP BY payment
ORDER BY payment_count DESC;

-- 3.What is the most selling product line?
SELECT
  product_line, COUNT(product_line) AS product_count
FROM sales
GROUP BY product_line
ORDER BY product_count DESC;

-- 4.What is the total revenue by month?
SELECT month_name AS month, SUM(total) AS total_revenue 
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- 5.What month had the largest COGS? (COGS = Beginning Inventory + Purchased Inventory - Ending Inventory)
SELECT month_name, SUM(cogs) AS COGS
FROM sales
GROUP BY month_name
ORDER BY COGS DESC;

-- 6.What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue 
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 7.What is the city with the largest revenue?
SELECT branch, city, SUM(total) AS total_revenue 
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- 8.What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- 9.Which branch sold more products than average product sold?
SELECT branch, SUM(quantity)
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- 10.What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- 11.What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Sales Questions
-- 1.Number of sales made in each time of the day per weekday
SELECT time_of_day, day_name, COUNT(total) AS day_revenue
FROM sales
GROUP BY time_of_day, day_name
ORDER BY time_of_day DESC;

-- 2.Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS type_revenue_count
FROM sales
GROUP BY customer_type
ORDER BY type_revenue_count DESC;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(tax_pct) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- 4.Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- Customer Questions
-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) FROM sales;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM sales;

-- 3.What is the most common customer type?
SELECT customer_type,COUNT(customer_type) AS customer_count
FROM sales
GROUP BY customer_type
ORDER BY customer_count DESC;

-- 4.Which customer type buys the most?
SELECT customer_type, SUM(total) AS total_count
FROM sales
GROUP BY customer_type
ORDER BY total_count DESC;

-- 5.What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- 6.What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_distribution
FROM sales
GROUP BY branch, gender
ORDER BY branch ASC;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS ratings_count
FROM sales
GROUP BY time_of_day
ORDER BY ratings_count DESC;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating) AS ratings_count
FROM sales
GROUP BY time_of_day, branch
ORDER BY ratings_count DESC;

-- 9.Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_ratings
FROM sales
GROUP BY day_name
ORDER BY avg_ratings DESC;

-- 10.Which day of the week has the best average ratings per branch?
SELECT day_name, branch, AVG(rating) AS avg_ratings
FROM sales
WHERE branch = 'A'
GROUP BY day_name
ORDER BY avg_ratings DESC;