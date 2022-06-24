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
