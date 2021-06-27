-- Pull these website extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- Use the accounts table to pull the first letter of each company name
-- to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- Use the accounts table and a CASE statement to create two groups:
-- one group of company names that start with a number and a second group of those company names that start with a letter.
-- What proportion of company names start with a letter?
WITH t1 AS (
  SELECT name, CASE WHEN LEFT(UPPER(name),1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 'START WITH A NUMBER'
  ELSE 'START WITH A LETTER' END AS name_cate
  FROM accounts)
SELECT name_cate, COUNT(name_cate) FROM t1 group by 1;
/* Answer from Udacity */
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name,
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
                THEN 1 ELSE 0 END AS num,
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
                THEN 0 ELSE 1 END AS letter
     FROM accounts) t1;

-- Consider vowels as a, e, i, o, and u.
-- What proportion of company names start with a vowel,
-- and what percent start with anything else?
WITH t2 AS (
  SELECT name, CASE WHEN LEFT(UPPER(name),1) IN ('A','E','I','O','U') THEN 'START WITH A VOWEL'
  ELSE 'NOT START WITH A VOWEL' END AS name_cate
  FROM accounts)
SELECT name_cate, COUNT(name_cate) FROM t2 group by 1;
/* RETURNS:
name_cate	              count
NOT START WITH A VOWEL	271
START WITH A VOWEL	    80    */
/* Answer from Udacity */
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name,
            CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
                THEN 1 ELSE 0 END AS vowels,
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
                THEN 0 ELSE 1 END AS other
      FROM accounts) t1;
