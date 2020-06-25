--  create a running total of standard_amt_usd (in the orders table) over order time with no date truncation.
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) as running_total
FROM orders;

-- Creating a Partitioned Running Total Using Window Functions
SELECT occurred_at,
       DATE_TRUNC('year', occurred_at) AS year,
       standard_amt_usd,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total_year
FROM orders;

-- Ranking Total Paper Ordered by Account
SELECT id, account_id, total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;

-- Aggregates in Window Functions with and without ORDER BY
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;

-- Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below. Evaluate your new query, compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders;

-- Shorten Your Window Function Queries by Aliasing
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER main_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER main_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER main_window avg_total_amt_usd,
       MIN(total_amt_usd) OVER main_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER main_window AS max_total_amt_usd
FROM orders
WINDOW  main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

-- Comparing a Row to Previous Row
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY total_amt_usd) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY total_amt_usd) - total_amt_usd AS lead_difference
FROM (
     SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
     FROM orders
     GROUP BY 1
) sub

-- Percentiles with Partitions
-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY account_id DESC;

-- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC;

-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC;

