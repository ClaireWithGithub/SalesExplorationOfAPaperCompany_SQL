-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table.
-- This should give a dollar amount for each order in the table.
-- Notice, this solution did not use an aggregate.
SELECT standard_amt_usd+gloss_amt_usd AS total_standard_gloss
FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper.
-- Your solution should use both an aggregation and a mathematical operator.
-- Though the price/standard_qty paper varies from one order to the next.
-- I would like this ratio across all of the sales made in the orders table.
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;
