-- EDA (Analyse Exploratrices)

SELECT * FROM category;
SELECT * FROM customers;
SELECT * FROM inventory;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;

SELECT 
	DISTINCT payment_status
FROM payments;

--2840
SELECT * FROM shippings
WHERE return_date IS NOT NULL ;

SELECT * FROM orders 
WHERE order_id = 6747;

SELECT * FROM payments
WHERE order_id = 6747;

-------------------------------------------------------
-- Business Problemns 
-- Advanced Analysis 
-------------------------------------------------------

/*
1. Top Selling Products
Query the top 10 products by total sales value.
Challenge: Include product name, total quantity sold, and total sales value.
*/

-- oi -o -pr 
-- prod id
-- sum qty * price per unit 
-- group by prod id 
-- top 10 product 

--creating new column 
ALTER TABLE order_items 
ADD COLUMN total_sale FLOAT;

SELECT * FROM order_items;

-- updating price qty* price per unit
UPDATE order_items
SET total_sale = quantity*price_per_unit;
SELECT * FROM order_items;

SELECT * FROM order_items
ORDER BY quantity DESC;

SELECT 
	oi.product_id,
	p.product_name,
	SUM(oi.total_sale) as total_sale,
	COUNT(o.order_id) as total_orders
FROM orders as o
JOIN 
order_items as oi
ON oi.order_id = o.order_id
JOIN 
products as p 
ON p.product_id = oi.product_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10

/*
2. Revenue by Category
Calculate total revenue generated by each product category.
Challenge: Include the percentage contribution of each category to total revenue.
*/

-- category_id, category_name, total_revenue, total_contribution
-- oi --products --category
-- group by cat id and name sum total(oi)


SELECT 
	p.category_id,
	c.category_name,
	SUM(oi.total_sale) as total_sale,
	SUM(oi.total_sale) / 
						(SELECT SUM(total_sale) FROM order_items) * 100 
	as contribution
	FROM order_items as oi
		JOIN 
			products as p
		ON p.product_id = oi.product_id
		LEFT JOIN 
			category as c
		ON c.category_id = p.category_id
	GROUP BY 1,2
	ORDER BY 3 DESC

/*
3. Average Order Value (AOV)
Compute the average order value for each customer.
Challenge: Include only customers with more than 5 orders.
*/

-- o -- oi -cx
-- group by cx id ans cx name sum(total sale)

SELECT 
	c.customer_id,
	CONCAT(c.first_name,' ', c.last_name) as full_name,
	SUM(oi.total_sale) / COUNT (o.order_id) as AOV,
	COUNT (o.order_id) as total_orders --- filter ---
FROM orders as o
JOIN customers as c
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON oi.order_id = o.order_id
GROUP BY 1,2
HAVING COUNT(o.order_id) > 5

/*
4. Monthly Sales Trend
Query monthly total sales over the past year.
Challenge: Display the sales trend, grouping by month, return current_month sale, last month sale!
*/

-- last 1 year data 
-- each month -- their sale and their prev month sale
-- window lag 

-- Save in a sub query
SELECT 
	year,
	month,
	total_sale as current_month_sale,
	LAG(total_sale, 1) OVER(ORDER  BY year, month) AS last_month_sale
FROM ---
(
--- Query
SELECT 
	EXTRACT(MONTH FROM o.order_date) as month,
	EXTRACT(YEAR FROM o.order_date) as year,
	ROUND(
		SUM (oi.total_sale::numeric),2)
	as total_sale
FROM orders as o 
JOIN
order_items as oi 
ON oi.order_id = o.order_id
WHERE order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 1,2
ORDER BY year, month
) as t1

/*
5. Customers with No Purchases
Find customers who have registered but never placed an order.
Challenge: List customer details and the time since their registration.
*/

-- Approach 1
SELECT * 
FROM customers 
WHERE customer_id NOT IN (SELECT 
							DISTINCT customer_id
							FROM orders);
-- Approach 2
SELECT *
FROM customers as c
LEFT JOIN orders as o
ON o.customer_id = c.customer_id
WHERE o.customer_id


/*
6. Least-Selling Categories by State
Identify the least-selling product category for each state.
Challenge: Include the total sales for that category within each state.
*/

SELECT 
	c.state,
	ca.category_name,
	SUM(oi.total_sale) as total_sale,
	RANK() OVER(PARTITION BY ca.category_name ORDER BY SUM(oi.total_sale) DESC) as rank
FROM orders as o
JOIN customers as c
ON o.customer_id = c.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
JOIN products as p
ON oi.product_id = p.product_id
JOIN category as ca
ON ca.category_id = p.category_id
GROUP BY 1,2

/*
7. Customer Lifetime Value (CLTV)
Calculate the total value of orders placed by each customer over their lifetime.
Challenge: Rank customers based on their CLTV.
*/

--cx - o -oi
--cx id group by sum(total_sale)

SELECT 
	c.customer_id,
	CONCAT(c.first_name,' ', c.last_name) as full_name,
	SUM(oi.total_sale) as CLTV,
	DENSE_RANK() OVER(ORDER BY SUM(total_sale) DESC) as cx_ranking
FROM orders as o
JOIN customers as c
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON oi.order_id = o.order_id
GROUP BY 1,2

/*
8. Inventory Stock Alerts
Query products with stock levels below a certain threshold (e.g., less than 10 units).
Challenge: Include last restock date and warehouse information.
*/

SELECT 
	i.inventory_id,
	p.product_name,
	i.stock as current_stock_left,
	i.last_stock_date,
	i.warehouse_id
FROM inventory as i
JOIN products as p
ON p.product_id = i.product_id
WHERE stock < 10

/*
9. Shipping Delays
Identify orders where the shipping date is later than 3 days after the order date.
Challenge: Include customer, order details, and delivery provider.
*/

-- cx -- o --ship

SELECT 
	c.*,
	o.*,
	s.shipping_providers,
	s.shipping_date - o.order_date as days_took_to_ship
FROM orders as o
JOIN customers as c
ON c.customer_id = o.customer_id
JOIN shippings as s
ON s.order_id = o.order_id
WHERE s.shipping_date - o.order_date > 3

/*
10. Payment Success Rate 
Calculate the percentage of successful payments across all orders.
Challenge: Include breakdowns by payment status (e.g., failed, pending).
*/

SELECT
	p.payment_status,
	COUNT(*) as total_cont,
	COUNT(*) / (SELECT COUNT(*) FROM payments) :: numeric *100
FROM orders as o
JOIN payments as p
ON o.order_id = p.order_id
GROUP BY 1

/*
11. Top Performing Sellers
Find the top 5 sellers based on total sales value.
Challenge: Include both successful and failed orders, and display their percentage of successful orders.
*/

WITH top_sellers
AS(
SELECT 
	s.seller_id,
	s.seller_name,
	SUM(oi.total_sale) as total_sale
FROM orders as o
JOIN sellers as s
ON o.seller_id = s.seller_id
JOIN order_items as oi
ON oi.order_id = o.order_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5
), 

sellers_reports
AS(
SELECT 
	o.seller_id,
	ts.seller_name,
	o.order_status,
	COUNT(*) as total_orders
FROM orders as o
JOIN 
top_sellers as ts
ON ts.seller_id = o.seller_id
WHERE o.order_status NOT IN ('Inprogress', 'Returned')
GROUP BY 1,2,3
)
SELECT 
	seller_id,
	seller_name,
	SUM(CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END) as Completed_orders,
	SUM(CASE WHEN order_status = 'Cancelled' THEN total_orders ELSE 0 END) as Completed_orders,
	SUM(total_orders) as total_orders,
	SUM (CASE WHEN order_status = 'Completed' THEN total_orders ELSE 0 END) / SUM(total_orders)::numeric * 100 as successful_orders
FROM sellers_reports
GROUP BY 1,2

/*
12. Product Profit Margin
Calculate the profit margin for each product (difference between price and cost of goods sold).
Challenge: Rank products by their profit margin, showing highest to lowest.
*/

-- o --oi --prod
-- group pid sum (total sale - cogs * qty) as profit

SELECT 
	product_id,
	product_name,
	profit_margin,
	DENSE_RANK() OVER( ORDER BY profit_margin DESC) as product_ranking
FROM 
(
SELECT 
	p.product_id,
	p.product_name,
	SUM(total_sale - (p.cogs * oi.quantity)) / SUM(total_sale) * 100 as profit_margin
FROM orders as o 
JOIN order_items as oi 
ON oi.order_id = o.order_id
JOIN products as p 
ON p.product_id = oi.product_id
GROUP BY 1,2
)

/*
13. Most Returned Products
Query the top 10 products by the number of returns.
Challenge: Display the return rate as a percentage of total units sold for each product.
*/

SELECT 
	p.product_id,
	p.product_name,
	COUNT(*) as total_unit_sold,
	SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) as total_returned,
	SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) :: numeric / COUNT(*) :: numeric * 100 as total_returned
FROM order_items as oi
JOIN 
	products as p
ON 
	oi.product_id = p.product_id
JOIN 
	orders as o 
ON 
	o.order_id = oi.order_id
GROUP BY 1,2
ORDER BY 5 DESC

/*
14. Orders Pending Shipment
Find orders that have been paid but are still pending shipment.
Challenge: Include order details, payment date, and customer information.
*/









