-- get a table that shows the average number of events a day for each channel.
-- there should be only 2 columns: channel, avg #of events in a day
-- Solution: step 1. find the number of events that occur for each day for each channel
SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;
-- step 2.  included an * in our SELECT statement. You will need to be sure to alias your table.
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2
          ORDER BY 3 DESC) sub;
-- step 3.
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events
         GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;

-- which channels send the most traffic per day on average to Parch and Posey
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events
         GROUP BY 1,2) sub
GROUP BY channel
ORDER BY average_events DESC;

-- What is the top channel used by each account to market product?
-- How often was the channel used?
-- Solution: picture what final table you are looking for
-- It should be account name, top channel, and max number of uses by that account
-- step 1: count uses for each channel of each account
(SELECT a.name, w.channel, COUNT(*) ct
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY 1,2) t1
-- step 2: find max uses for each account
(SELECT t1.name, MAX(ct) max_ct
FROM t1
GROUP BY 1) t2
-- step 3: find the top channel by associating account name and # of uses
SELECT t1.name, t1.channel, t1.ct
FROM t1
JOIN t2
ON t1.name = t2.name AND t1.ct = t2.max_ct
-- 整合结果
SELECT t1.name, t1.channel, t1.ct
FROM
    (SELECT a.name, w.channel, COUNT(*) ct
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    GROUP BY 1,2) t1
JOIN
    (SELECT t1.name, MAX(ct) max_ct
    FROM (SELECT a.name, w.channel, COUNT(*) ct
          FROM accounts a
          JOIN web_events w
          ON a.id = w.account_id
          GROUP BY 1,2) t1
    GROUP BY 1) t2
ON t1.name = t2.name AND t1.ct = t2.max_ct
ORDER BY t1.name;

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
-- step 1: find the total_amt_usd totals associated with each sales rep, and the region in which they were located.
-- step 2: pulled the max for each region
-- step 3: JOIN of these two tables, where the region and amount match.
/* WITH */
WITH t1 AS (
  	  SELECT r.name region_name, s.name sales_rep, SUM(o.total_amt_usd) total_sales
      FROM orders o
      JOIN accounts a
      ON o.account_id = a.id
      JOIN sales_reps s
      ON s.id = a.sales_rep_id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2),
      t2 AS (
        SELECT t1.region_name, MAX(t1.total_sales) max_sales
      	FROM t1
        GROUP BY 1)
SELECT t2.region_name, t1.sales_rep, t2.max_sales
FROM t1
JOIN t2
ON t2.region_name = t1.region_name AND t2.max_sales = t1.total_sales;
/* inline */
SELECT t2.region_name, t1.sales_rep, t2.max_sales
FROM (SELECT r.name region_name, s.name sales_rep, SUM(o.total_amt_usd) total_sales
      FROM orders o
      JOIN accounts a
      ON o.account_id = a.id
      JOIN sales_reps s
      ON s.id = a.sales_rep_id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY 1,2) t1
JOIN (SELECT t1.region_name, MAX(t1.total_sales) max_sales
      FROM
          (SELECT r.name region_name, s.name sales_rep, SUM(o.total_amt_usd) total_sales
          FROM orders o
          JOIN accounts a
          ON o.account_id = a.id
          JOIN sales_reps s
          ON s.id = a.sales_rep_id
          JOIN region r
          ON r.id = s.region_id
          GROUP BY 1,2) t1
      GROUP BY 1) t2
ON t2.region_name = t1.region_name AND t2.max_sales = t1.total_sales;


-- For the region with the largest (sum) of sales total_amt_usd,
-- how many total (count) orders were placed?
SELECT r.name, COUNT(*) total_orders
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
  	SELECT MAX(total_sales) FROM(
      -- whether to use `MAX()` or  `ORDER BY and LIMIT` depends on
      -- if you need other collateral info associated with the max
      -- if no, then use MAX(), otherwise, use `ORDER BY DESC and LIMIT`
      SELECT r.name, SUM(o.total_amt_usd) total_sales
      FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON s.id = a.sales_rep_id
      JOIN orders o
      ON o.account_id = a.id
      GROUP BY 1) t3);
-- Alternative solution
/* WITH */
WITH t1 AS (
  SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
  FROM sales_reps s
  JOIN accounts a
  ON a.sales_rep_id = s.id
  JOIN orders o
  ON o.account_id = a.id
  JOIN region r
  ON r.id = s.region_id
  GROUP BY r.name
  ORDER BY 2 DESC
  LIMIT 1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
WHERE r.name = (SELECT region_name
                FROM t1)
GROUP BY r.name;
/* INLINE */
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
WHERE r.name = (SELECT region_name
                FROM (
                  SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
                  FROM sales_reps s
                  JOIN accounts a
                  ON a.sales_rep_id = s.id
                  JOIN orders o
                  ON o.account_id = a.id
                  JOIN region r
                  ON r.id = s.region_id
                  GROUP BY r.name
               	  ORDER BY 2 DESC
                  LIMIT 1) sub)
GROUP BY r.name;


-- How many accounts had more total purchases
-- than the account name which has bought the most standard_qty paper
-- throughout their lifetime as a customer?
/*审题！你要找的是 accounts的total 比 某些accounts的total 多的accounts（是total和total比）；
某些accounts是那些买了最多standard_qty纸的accounts
但不是 accounts的total 比 accounts的most standard_qty多的 accoubts */
-- step 1: find the account that had the most standard_qty paper.
-- step 2: pull all the accounts with more total sales
-- step 3: get the count of the accounts that meet the condition.
SELECT COUNT(*)
FROM (SELECT a.name -- You don't necessarily need to find name. id would work
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1 -- You must add `GROUP BY` before `HAVING`
       HAVING SUM(o.total) > (SELECT total
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC -- `ORDER BY` is crucial for finding max
                         LIMIT 1) inner_tab)
             ) counter_tab;
-- Alternative solution: use id
SELECT COUNT(*) -- returns 3
FROM (
  SELECT account_id
  FROM orders
  GROUP BY account_id
  HAVING SUM(total) > (
    SELECT total_qty FROM (
        SELECT account_id, SUM(standard_qty) total_std_qty, SUM(total) total_qty
        FROM orders
        GROUP BY account_id
        ORDER BY 2 DESC
        LIMIT 1) t5)
      ) t6;

/* WITH */
WITH t1 AS (
      SELECT account_id, SUM(standard_qty) total_std_qty, SUM(total) total_qty
      FROM orders
      GROUP BY account_id
      ORDER BY 2 DESC
      LIMIT 1),
     t2 AS (
       SELECT account_id
       FROM orders
       GROUP BY account_id
       HAVING SUM(total) > (
         SELECT total_qty FROM t1))
SELECT COUNT(*)
FROM t2;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
-- how many web_events did they have for each channel?
-- step 1: we first want to pull the customer with the most spent in lifetime value.
SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;
-- step 2: we want to look at the number of events on each channel this company had, which we can match with just the id.
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC -- this is a better way to find the customer that spent the most
                           LIMIT 1) inner_table) -- rather than use MAX() and more to find the account_id
GROUP BY 1, 2
ORDER BY 3 DESC;
/* WITH */
WITH t1 AS (
  		SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
        GROUP BY a.id, a.name
        ORDER BY 3 DESC
        LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(tot_spent) -- Note: it's looking for only 1 number as a return
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;
/* WITH */
WITH t1 AS (
 	  SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
     FROM orders o
     JOIN accounts a
     ON a.id = o.account_id
     GROUP BY a.id, a.name
     ORDER BY 3 DESC
     LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;


-- What is the lifetime average amount spent in terms of total_amt_usd,
-- including only the companies that spent more per order, on average,
-- than the average of all orders.
/* Note: the underlying question is avg(total_amt_usd) `by each account`,
because lifetime is for each account instead of each order */
SELECT AVG(avg_amt) -- ***直接从subquery里面取avg就是每个account的avg spent
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                   FROM orders o)) temp_table; -- 注意下()位置
/* WITH */
WITH t1 AS (
		SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
       FROM orders o
       GROUP BY 1
       HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all FROM orders o))
SELECT AVG(avg_amt)
FROM t1;
