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