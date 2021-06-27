-- Have any sales reps worked on more than one account
-- Actually all of the sales reps have worked on more than one account.
-- The fewest number of accounts any sales rep works on is 3.
-- There are 50 sales reps, and they all have more than one account. 
SELECT s.name, COUNT(DISTINCT a.id) num_accounts
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY num_accounts;
