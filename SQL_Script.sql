CREATE TABLE sales (
    invoice_id VARCHAR(30) PRIMARY KEY,
    branch VARCHAR(5),
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT NUMERIC(6, 4) NOT NULL,
    total NUMERIC(12, 4) NOT NULL,
    date TIMESTAMP NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs NUMERIC(10, 2) NOT NULL,
    gross_margin_pct NUMERIC(11, 9),
    gross_income NUMERIC(12, 4) NOT NULL,
    rating NUMERIC(2, 1)
);

ALTER TABLE sales
ALTER COLUMN rating TYPE NUMERIC(3,1);



-- ----------------------------------------------------------------------------------------------
-- FEATURE ENGINEERING---------------------------------------------------------------------------

-- time_of_day


SELECT
    time,
    CASE
        WHEN time BETWEEN  '00:00:00' AND  '12:00:00' THEN 'Morning'
        WHEN time BETWEEN  '12:01:00' AND  '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	    CASE
        WHEN time BETWEEN  '00:00:00' AND  '12:00:00' THEN 'Morning'
        WHEN time BETWEEN  '12:01:00' AND  '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END 
);

-- day_name

SELECT 
    date,
    TO_CHAR(date, 'Day') AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = (
	TO_CHAR(date, 'Day') 
);

-- month_name

SELECT
	date,
	TO_CHAR(date, 'Month')
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = (
	TO_CHAR(date, 'Month')
);

-- ----------------------------------------------------------------------------------------------
-- GENERIC---------------------------------------------------------------------------------------

-- How many unique cities does the data have?----------------------------------------------------

SELECT
	DISTINCT(city)
FROM sales;

-- In which city is each branch?-----------------------------------------------------------------

SELECT
	DISTINCT(city),
	branch
FROM sales;

-- ----------------------------------------------------------------------------------------------
-- PRODUCT---------------------------------------------------------------------------------------

-- How many unique product lines does the data have?

SELECT
	DISTINCT(product_line)
FROM sales;

SELECT
	COUNT(DISTINCT(product_line))
FROM sales;

-- What is the most common payment method?

SELECT 
	payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line?----------------------------------------------------------

SELECT 
	product_line,
	COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?

SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- What month had the largest COGS?

SELECT
	month_name AS month,
	SUM(COGS) AS largest_COGS
FROM sales
GROUP BY month
ORDER BY largest_COGS DESC;


SELECT
	month_name AS month,
	SUM(COGS) AS largest_COGS
FROM sales
GROUP BY month
ORDER BY largest_COGS DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY product_line
ORDER BY largest_revenue DESC;

SELECT
	product_line,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY product_line
ORDER BY largest_revenue DESC
LIMIT 1;

-- What is the city with the largest revenue?

SELECT
	branch,
	city,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY city, branch
ORDER BY largest_revenue DESC;


SELECT
	branch,
	city,
	SUM(total) AS largest_revenue
FROM sales
GROUP BY city, branch
ORDER BY largest_revenue DESC
LIMIT 1;

-- What product line had the largest VAT?

SELECT
	product_line,
	SUM(VAT) AS largest_VAT
FROM sales
GROUP BY product_line
ORDER BY largest_VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad"
-- Good if its greater than average sales


SELECT
	product_line,
	CASE
	WHEN AVG(total) > (SELECT AVG(total) FROM sales) THEN 'Good'
	ELSE 'Bad'
	END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?

SELECT
    branch,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales)
ORDER BY total_quantity DESC;


-- What is the most common product line by gender?

SELECT 
	gender,
	product_line,
	COUNT(gender) AS cnt
FROM sales
GROUP BY gender, product_line
ORDER BY cnt DESC;


-- What is the average rating of each product line?

SELECT
	product_line,
	ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;



