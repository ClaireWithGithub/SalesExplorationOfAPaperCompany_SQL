-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) first_name, SUBSTR(primary_poc, POSITION(' ' IN primary_poc)+1) last_name
FROM accounts;
/* Alternative */
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

-- do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT LEFT(name, POSITION(' ' IN name)-1) first_name, SUBSTR(name, POSITION(' ' IN name)+1) last_name
FROM sales_reps
/* Alternative */
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;
