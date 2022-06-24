/* Query 1 - Question 1: Which is the most rented family movie? */
SELECT film_category,
       COUNT(rental_count) AS rental_count
FROM
    (
     SELECT film_title,
            film_category,
            COUNT(rental_duration) AS rental_count
       FROM
           (
            SELECT c.name AS film_category,
                   f.title AS film_title,
                   f.rental_duration
              FROM category c
              JOIN film_category fc
                ON fc.category_id = c.category_id
              JOIN film f
                ON f.film_id = fc.film_id
              JOIN inventory i
                ON f.film_id = i.film_id
              JOIN rental r
                ON i.inventory_id = r.inventory_id
             WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
           ) sub_1

       GROUP BY 1, 2
       ORDER BY 2, 1
) sub_2

GROUP BY 1



/* Query 2 - Question 2: Which is the month and year with most rented times? And how the 2 store compare to each other? */
SELECT month,
year,
store_id,
COUNT(rental_date) AS count_rental
FROM
(
  SELECT DATE_PART('month', rental_date) AS month,
  DATE_PART('year', rental_date) AS year,
  rental_date,
  s.store_id
  FROM store s
  JOIN staff st
  ON st.store_id = s.store_id
  JOIN rental r
  ON r.staff_id = st.staff_id

) sub_1

GROUP BY 1, 2, 3
ORDER BY 4 DESC



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
