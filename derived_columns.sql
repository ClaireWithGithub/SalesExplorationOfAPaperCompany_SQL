-- add non-standard qty
SELECT account_id, standard_qty, gloss_qty, poster_qty, gloss_qty+poster_qty AS nonstandard_qty
FROM orders
LIMIT 10;

-- % of sales for standard paper
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

-- Order of Operations
SELECT id, standard_qty / (standard_qty + gloss_qty + poster_qty)*100 AS std_qty_percent
FROM orders
LIMIT 10;

-- find the unit price for standard paper 
SELECT id, account_id, standard_amt_usd/standard_qty AS standard_unit_price
FROM orders
LIMIT 10;
