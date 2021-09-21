USE sakila;

SELECT inventory_id, store_id, COUNT(rental_id) AS times_rented, rental_duration, rental_rate, length, replacement_cost, rating, MAX(rented_august) as rented_august
FROM
(
SELECT inventory_id, store_id, rental_id, rental_duration, rental_rate, length, replacement_cost, rating, rental_date,
CASE
WHEN rental_date BETWEEN '2005-08-01' AND '2005-08-31' THEN 1
ELSE 0
END AS rented_august
FROM inventory
LEFT JOIN rental
USING(inventory_id)
LEFT JOIN film
USING(film_id)
WHERE rental_date BETWEEN '2005-01-01' AND '2005-12-31') sub1
GROUP BY inventory_id, store_id, rental_duration, rental_rate, length, replacement_cost, rating;
