/* Query 4 - Question 4: Who was the customer that pay the most difference? */

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

SELECT fullname, diff_paid
FROM
(
SELECT fullname,
DATE_PART('month', pay_mon) AS month,
pay_amount,
pay_amount - LAG(pay_amount) OVER (PARTITION BY fullname ORDER BY fullname) AS diff_paid
FROM
(
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
) sub_1

ORDER BY 4 DESC
) sub_2
WHERE diff_paid > 0
LIMIT 10
