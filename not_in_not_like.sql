-- NOT IN. find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- NOT LIKE. All companies whose names do not end with 's'.
SELECT name
FROM accounts
WHERE name NOT LIKE '%s';
