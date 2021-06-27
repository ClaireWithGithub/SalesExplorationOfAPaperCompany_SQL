-- From the web_events table, display the concatenated value of
-- account_id, '_' , channel, '_', count of web events of the particular channel
WITH T1 AS (
 SELECT ACCOUNT_ID, CHANNEL, COUNT(*)
 FROM WEB_EVENTS
 GROUP BY ACCOUNT_ID, CHANNEL
 ORDER BY ACCOUNT_ID
)
SELECT CONCAT(T1.ACCOUNT_ID, '_', T1.CHANNEL, '_', COUNT)
FROM T1;

-- From the accounts table, display the name of the client,
-- the coordinate as concatenated (latitude, longitude),
-- email id of the primary point of contact as
-- <first letter of the primary_poc><last letter of the primary_poc>@<extracted name and domain from the website>
SELECT NAME, CONCAT(LAT, ', ', LONG) COORDINATE,
CONCAT(LEFT(PRIMARY_POC, 1), RIGHT(PRIMARY_POC, 1), '@', SUBSTR(WEBSITE, 5)) EMAIL
FROM ACCOUNTS;

-- write a query to change the date into the correct SQL date format (YYYY-MM-DD)
-- Also convert the column to a date
-- Notice, this new date can be operated on using DATE_TRUNC and DATE_PART in the same way
/* || works as a CONCAT; :: works as CAST */
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com
/* removing all of the spaces in the account name */
-- Use REPLACE(STR, REP_FROM_STR, REP_TO_STR)
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,
 name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;
-- below is not very readable
SELECT REPLACE(LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) || '.'
|| RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) || '@' || name || '.com', ' ', '') AS email
FROM accounts;


/* create an initial password, which they will change after their first log in.
The first password will be the first letter of the primary_poc's first name (lowercase),
then the last letter of their first name (lowercase),
the first letter of their last name (lowercase),
the last letter of their last name (lowercase), the number of letters in their first name,
the number of letters in their last name,
and then the name of the company they are working with, all capitalized with no spaces.*/
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
 RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name,
 name
 FROM accounts)
SELECT first_name, last_name,
CONCAT(first_name, '.', last_name, '@', name, '.com'),
LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) ||
LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) ||
LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;
-- Alternative
with t1 as(
  select left(PRIMARY_POC, POSITION(' ' IN primary_poc)-1) first_name,
  SUBSTR(primary_poc, POSITION(' ' IN name)+1) last_name,
  name
  from accounts
)
SELECT UPPER(REPLACE(LOWER(LEFT(first_name, 1)) ||
LOWER(RIGHT(first_name, 1)) ||
LOWER(LEFT(last_name, 1)) ||
LOWER(RIGHT(last_name, 1)) ||
LENGTH(first_name) ||
LENGTH(last_name) || name, ' ', '')) AS password
FROM t1;
