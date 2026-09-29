CREATE DATABASE COFFEE_SALES;
USE COFFEE_SALES;

Select * from city;
select * from customers;
select * from products;
select * from sales;

-- Reports & Data Analysis

-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

select city_name,
	Round((population * 0.25 / 1000000),2) As Coffee_consumers_in_millions,
    city_rank 
    from city
    order by 2 desc;
    
-- -- Q.2
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

Select 
	sum(total) As Total_Revenue
    from sales 
    where
    Extract(year from sale_date) = 2023
    AND
    Extract(quarter from sale_date) = 4;
    
    
select ci.city_name,
	sum(s.total) As Total_Revenue
    from sales s join customers c
    on s.customer_id = c.customer_id
    join city ci
    on ci.city_id = c.city_id
    where
    Extract(year from sale_date) = 2023
    AND
    Extract(quarter from sale_date) = 4
	group by 1
    order by 2 desc;
    
    
    -- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
Select p.product_name,
	count(s.sale_id) As Total_Count
    from products p 
    Left Join sales s
    on p.product_id = s.product_id
    group by 1
	order by 2 desc;
    
    
-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?

Select ci.city_name,
	sum(s.total) As Total_Revenue,
    count(distinct s.customer_id) As Total_Customers,
    Round(
			( sum(s.total) / count(distinct s.customer_id) ),2)  As Average_sale_per_customer
    from sales s join customers c 
    on s.customer_id = c.customer_id
    join city ci 
    on ci.city_id = c.city_id
    group by 1
    order by 2 desc;
    
    
-- -- Q.5
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)

with consumers as 
(
	select city_name,
		Round((population * 0.25) / 1000000,2) as coffee_consumers_in_millions
        from city
),
customer_table as 
(
	select ci.city_name,
		count(distinct c.customer_id) As unique_customers
        from sales s join customers c 
        on c.customer_id = s.customer_id
        join city ci
        on ci.city_id = c.city_id
        group by 1
)
select 
		customer_table.city_name,
		consumers.coffee_consumers_in_millions,
        customer_table.unique_customers 
        from customer_table 
        join consumers 
        on customer_table.city_name = consumers.city_name;
        
        
-- -- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
Select * from 
(
	Select 
		ci.city_name,
		p.product_name,
        Count(s.sale_id) As Order_Volume,
        dense_rank() Over(partition by ci.city_name order by count(s.sale_id) desc) As Top_Products
        from sales s join products p
        on s.product_id = p.product_id
        join customers c 
        on s.customer_id = c.customer_id 
        join city ci
        on ci.city_id = c.city_id
        group by 1, 2
        
) 
As Top_Products_Table
where Top_Products <= 3; 


-- Q.7
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

-- Coffee products are till 14 only 

Select 
		ci.city_name,
		count(distinct c.customer_id) As Unique_customers
	from city ci 
    Left Join customers c
    on c.city_id = ci.city_id
    join sales s 
    on s.customer_id = c.customer_id
    Where 
    s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
    group by 1
    order by 2 desc ;

        
-- -- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer

-- Conclusions

WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(
				SUM(s.total) / COUNT(DISTINCT s.customer_id)
				,2) as Avg_sale_pr_cx
		
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(SELECT 
	city_name, 
	Estimated_rent
FROM city
)
SELECT 
	cr.city_name,
	cr.Estimated_rent,
	ct.Total_cx,
	ct.Avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent /	ct.total_cx
		, 2) as Avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 4 DESC;

-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city

WITH
monthly_sales
AS
(
	SELECT 
		ci.city_name,
		EXTRACT(MONTH FROM sale_date) as month,
		EXTRACT(YEAR FROM sale_date) as YEAR,
		SUM(s.total) as total_sale
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1, 2, 3
	ORDER BY 1, 3, 2
),
growth_ratio
AS
(
		SELECT
			city_name,
			month,
			year,
			total_sale as cr_month_sale,
			LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year, month) as last_month_sale
		FROM monthly_sales
)

SELECT
	city_name,
	month,
	year,
	cr_month_sale,
	last_month_sale,
	ROUND(
		(cr_month_sale-last_month_sale) / last_month_sale * 100
		, 2
		) as growth_ratio

FROM growth_ratio
WHERE 
	last_month_sale IS NOT NULL;
    
    
-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer



WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as Total_revenue,
		COUNT(DISTINCT s.customer_id) as Total_customers,
		ROUND(
				SUM(s.total) / COUNT(DISTINCT s.customer_id)
				,2) as Avg_sale_per_customers
		
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25)/1000000, 3) as Estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	total_revenue,
	cr.estimated_rent as Total_rent,
	ct.total_customers,
	Estimated_coffee_consumer_in_millions,
	ct.avg_sale_per_customers,
	ROUND(
		cr.estimated_rent / ct.total_customers
		, 2) as Avg_rent_per_customers
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 2 DESC; 

    

