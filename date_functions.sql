-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
-- Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
-- either DATE_TRUNC() or DATE_PART() will work
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

SELECT DATE_PART('year', occurred_at) order_year, COUNT(DISTINCT DATE_PART('month', occurred_at)) num_months
FROM orders
GROUP BY 1;
/*
notice that 2013 and 2017 have much smaller totals than all other years.
If we look further at the monthly data,
we see that for 2013 and 2017 there is only one month of sales for each of these years (12 for 2013 and 1 for 2017).
Therefore, neither of these are evenly represented.
Sales have been increasing year over year, with 2016 being the largest sales to date.
At this rate, we might expect 2017 to have the largest sales.
*/
-- Which month did Parch & Posey have the greatest sales in terms of total dollars?
-- In order for this to be 'fair', we should remove the sales from 2013 and 2017.
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01' -- ***
GROUP BY 1
ORDER BY 2 DESC;

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
