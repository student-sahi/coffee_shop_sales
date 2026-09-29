# coffee_shop_sales
** Objective
Monday Coffee sells coffee products (beans, instant coffee, cold brew, syrups) and coffee-themed merchandise (mugs, tumblers, apparel, gifts) online since January 2023. This project uses SQL to:

-- Explore sales, customer, product and city data
-- Measure revenue, customer counts and product performance by city
-- Compare revenue against rent to judge profitability potential
-- Track month-over-month growth
-- Recommend the top 3 cities for opening new coffee shops


🎯 Business Problem

Management wants to open new coffee shops. Using sales data from 2023–2024, which cities offer the best mix of high revenue, a large customer base, and manageable rent?


** Key Questions
-- Coffee Consumers Count
How many people in each city are estimated to consume coffee, given that 25% of the population does?

-- Total Revenue from Coffee Sales
What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

-- Sales Count for Each Product
How many units of each coffee product have been sold?

-- Average Sales Amount per City
What is the average sales amount per customer in each city?

-- City Population and Coffee Consumers
Provide a list of cities along with their populations and estimated coffee consumers.

-- Top Selling Products by City
What are the top 3 selling products in each city based on sales volume?

-- Customer Segmentation by City
How many unique customers are there in each city who have purchased coffee products?

-- Average Sale vs Rent
Find each city and their average sale per customer and avg rent per customer

-- Monthly Sales Growth
Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).

-- Market Potential Analysis
Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer


** Highlights

* Pune leads in total revenue and has the highest average spend per customer, with low rent per customer.
* Delhi has by far the largest untapped market: about 7.75 million estimated coffee consumers.
* Jaipur has the largest customer base (69) and the lowest rent per customer (~₹157).
* Mumbai and Hyderabad have high rent per customer (₹1,000+) but low revenue, making them weak expansion candidates.
* Best-selling products: Cold Brew Coffee Pack, Ground Espresso Coffee, Instant Coffee Powder, and Coffee Beans (each with 1,200+ orders).
* Q4 2023 revenue: ₹1,963,300 across all cities.

** Recommendations
After analyzing the data, the recommended top three cities for new store openings are:

* City 1: Pune

Average rent per customer is very low.
Highest total revenue.
Average sales per customer is also high.

* City 2: Delhi

Highest estimated coffee consumers at 7.7 million.
Highest total number of customers, which is 68.
Average rent per customer is 330 (still under 500).

* City 3: Jaipur

Highest number of customers, which is 69.
Average rent per customer is very low at 156.
Average sales per customer is better at 11.6k.

🛠 SQL Concepts Used

Joins (INNER, LEFT) across 3–4 tables
Aggregations: SUM, COUNT, COUNT(DISTINCT ...)
Common Table Expressions (CTEs)
Window functions: DENSE_RANK(), LAG()
Date functions: EXTRACT(YEAR / MONTH / QUARTER)
ROUND for ratio and percentage metrics
Subqueries and filtering with IN
