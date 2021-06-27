-- Use the NTILE functionality to divide the accounts into 4 levels
-- in terms of the amount of standard_qty for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order,
-- the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
  FROM orders
 ORDER BY 1,4
