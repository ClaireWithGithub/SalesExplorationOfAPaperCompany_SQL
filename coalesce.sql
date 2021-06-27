-- use COALESCE to fill in the accounts.id column with the accounts.id
-- fill the orders.accounts_id column with the account.id
-- fill in each of the qty and usd columns with 0
/* COALESCE(a.id) will also work */
SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long,
a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id,
o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty,
COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty,
COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd,
COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd,
COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;
