SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference
FROM (
       SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
      ) sub

SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
     ) sub

-- compare current revenue with revenue in the next day
SELECT date,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY date) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY date) - total_amt_usd AS lead_difference
FROM (
SELECT DATE_TRUNC('day', occurred_at) as date,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders
 GROUP BY 1
) sub
/*
date	               total_amt_usd	lead	lead_difference
2013-12-04T00:00:00.000Z	5983.87	3278.98	-2704.89
2013-12-05T00:00:00.000Z	3278.98	24071.14	20792.16
2013-12-06T00:00:00.000Z	24071.14	58294.79	34223.65
*/
