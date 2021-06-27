-- Write a query to return the top 5 orders in terms of largest total_amt_usd.
-- Include the id, account_id, and total_amt_usd.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- all of the orders for each account ID are grouped together,
-- and then within each of those groupings, the orders appear from the greatest order amount to the least.
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;
