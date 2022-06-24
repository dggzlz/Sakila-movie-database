/* Query 3 - Question 3: Who were our top 10 customers during 2007 and how much they paid? */

WITH t1 AS (
  SELECT SUM(p.amount) AS pay_amount,
  COUNT(p.amount) AS count_amount,
  CONCAT(c.first_name, ' ', c.last_name) AS fullname
  FROM payment p
  JOIN customer c
  ON c.customer_id = p.customer_id
  GROUP BY 3
  ORDER BY 1 DESC, 2
  LIMIT 10
)

SELECT DATE_TRUNC('month', p.payment_date) AS pay_mon,
first_name || ' ' || last_name AS fullname,
COUNT(p.amount) AS count_permon,
SUM(p.amount) AS pay_amount
FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
WHERE first_name || ' ' || last_name IN (SELECT fullname FROM t1)
GROUP BY 1, 2
ORDER BY 2, 1
