-- divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order
-- solution without an error for a division by zero.
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders;
--  You will notice, we essentially charge all of our accounts 4.99 for standard paper.
-- It makes sense this doesn't fluctuate

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order.
-- The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count -- ***
FROM orders
GROUP BY 1; -- returns only 3 rows. It's handy to GROUP BY column number

-- We would like to understand 3 different branches of customers based on the amount associated with their purchases.
-- obtain the total amount spent by customers only in 2016 and 2017.
-- The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
-- The second branch is between 200,000 and 100,000 usd.
-- The lowest branch is anyone under 100,000 usd.
-- Provide a table that includes the level associated with each account.
-- You should provide the account name, the total sales of all orders for the customer, and the level.
-- It is worth mentioning that this assumes each name is unique.
-- We otherwise would want to break by the name and the id of the table.
-- Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent,
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top' -- aggregation in CASE
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' -- or use BETWEEN AND for a certain date period
GROUP BY 1
ORDER BY 2 DESC;

-- We would like to identify top performing sales reps,
-- which are sales reps associated with more than 200 orders or more than 750000 in total sales.
-- The middle group has any rep with more than 150 orders or 500000 in sales.
-- Create a table with the sales rep name, the total number of orders,
-- total sales across all orders, and a column with top, middle, or low depending on this criteria.
-- Place the top sales people based on dollar amount of sales first in your final table.
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent,
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC; -- column 3 is total_spent
