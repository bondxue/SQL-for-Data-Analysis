-- Finding Matched and Unmatched Rows with FULL OUTER JOIN
SELECT *
FROM sales_reps s
FULL JOIN accounts a
ON s.id = a.sales_rep_id

SELECT *
FROM sales_reps s
FULL JOIN accounts a
ON s.id = a.sales_rep_id
WHERE a.sales_rep_id is NULL OR s.id IS NULL;

-- JOINs with Comparison Operators
SELECT a.name, a.primary_poc, s.name
FROM sales_reps s
RIGHT JOIN accounts a
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name

-- Self JOINs
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
FROM orders o1
LEFT JOIN orders o2
ON o1.account_id = o2.account_id
AND o2.occurred_at > o1.occurred_at
AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

-- Appending Data via UNION
-- Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.
SELECT *
    FROM accounts

UNION ALL

SELECT *
  FROM accounts

-- Pretreating Tables before doing a UNION
SELECT *
    FROM accounts
    WHERE name = 'Walmart'

UNION ALL

SELECT *
  FROM accounts
  WHERE name = 'Disney'

-- Pretreating Tables before doing a UNION
WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC
