-- Use the accounts table to find

-- All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

-- All companies whose names contain the string 'one' somewhere in the name.
SELECT name
FROM accounts
WHERE name LIKE '%one%';

-- All companies whose names end with 's'.
SELECT name
FROM accounts
WHERE name LIKE '%s';
