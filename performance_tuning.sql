-- the query below takes forever. Revise it to be more efficient

/* 1. the below query tells us that 79083 results from order data */
SELECT o.occurred_at AS date,
       a.sales_rep_id,
       o.id AS order_id,
       we.id AS web_event_id
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
ORDER BY 1 DESC

/* below is the query that you need to improve */
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
       COUNT(DISTINCT o.id) AS num_orders,
       COUNT(DISTINCT we.id) AS num_web_events
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
GROUP BY 1
ORDER BY 1 DESC
/* Sample of Returns
date	                   active_sales_reps	num_orders	num_web_events
2017-01-01T00:00:00.000Z	13	                  24	       31
2016-12-31T00:00:00.000Z	15	                  26	       27
2016-12-30T00:00:00.000Z	7	                    11	       18 */

-- revision
SELECT COALESCE(order_agg.date,web_events_agg.date) AS date,
       active_sales_reps, num_orders, num_web_events
FROM (
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(a.sales_rep_id) AS active_sales_reps,
       COUNT(o.id) AS num_orders
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
GROUP BY 1 ) order_agg -- RETURNS 1060 ROWS

FULL JOIN
(
SELECT DATE_TRUNC('day', we.occurred_at) AS date,
       COUNT(we.id) AS num_web_events
FROM accounts a
JOIN   web_events we
ON we.account_id = a.id
GROUP BY 1) web_events_agg -- returns 1119 rows

ON order_agg.date = web_events_agg.date
ORDER BY 1 DESC -- returns 1120 ROWS
/*
date	                   active_sales_reps	num_orders	num_web_events
2017-01-02T00:00:00.000Z	1	                 1
2017-01-01T00:00:00.000Z	24	               24	31
2016-12-31T00:00:00.000Z	26	               26	27
2016-12-30T00:00:00.000Z	11	               11	18
2016-12-29T00:00:00.000Z	11	               11	19
*/
