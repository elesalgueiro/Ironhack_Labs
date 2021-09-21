USE SAKILA; 
-- Lab | SQL Join (Part II)

-- 1 Write a query to display for each store its store ID, city, and country.

SELECT * FROM country; --  country, country_id
SELECT * FROM city; -- city, country_id, city_id
SELECT * FROM address; -- city_id, address_id
SELECT * FROM store; -- store_id, address_id

SELECT s.store_id, ci.city, co.country
FROM country co
JOIN city ci
USING(country_id)
JOIN address a
USING (city_id)
JOIN store s
USING ( address_id);

-- 2 Write a query to display how much business, in dollars, each store brought in.
-- sum amount payment per store
SELECT * FROM payment; -- amount, staff_id
SELECT * FROM staff;-- store_id, staff_id, 

SELECT s.store_id,SUM(p.amount) AS total_business
FROM payment p
JOIN staff s
USING (staff_id)
GROUP BY s.store_id
ORDER BY total_business DESC;

-- 3 Which film categories are longest?
-- categories highest sum lenght
SELECT * FROM film; -- length, film_id
SELECT * FROM film_category; -- film_id, category_id
SELECT * FROM category; -- name, category_id

SELECT c.name, SUM(length) AS total_category_length
FROM film f
JOIN film_category fc
USING (film_id)
JOIN category c
USING (category_id)
GROUP BY c.name
ORDER BY total_category_length DESC;

-- 4 Display the most frequently rented movies in descending order.
-- film title with max rental_id count

SELECT * FROM  rental; -- rental_id, inventory_id
SELECT * FROM inventory; -- inventory_id,film_id
SELECT * FROM film; -- title, film_id

SELECT f.title, COUNT( r.rental_id) as total_rentals
FROM rental r
JOIN inventory i
USING (inventory_id)
JOIN film f
USING (film_id)
GROUP BY f.title
ORDER BY total_rentals DESC;


-- 5 List the top five genres in gross revenue in descending order.

SELECT * FROM category; -- category_id, name
SELECT * FROM film_category; -- category_id, film_id
SELECT * FROM inventory;  -- film_id, inventory_id
SELECT * FROM rental;  -- inventory_id, customer_id
SELECT * FROM payment; -- payment - customer_id, amount

SELECT c.name, SUM(p.amount) AS gross_revenue
FROM sakila.category c
JOIN sakila.film_category fc
USING (category_id)
JOIN sakila.inventory i
USING (film_id)
JOIN sakila.rental r
USING (inventory_id)
JOIN sakila.payment p
USING (rental_id)
GROUP BY c.name
ORDER BY gross_revenue DESC
LIMIT 5;

-- 6 Is "Academy Dinosaur" available for rent from Store 1?
SELECT * FROM rental;-- rental_id, rental_date, return_date
SELECT * FROM inventory; -- store_id, film_id,inventory_id
SELECT * FROM film; -- title, film_id

SELECT f.title, COUNT(r.return_date IS NULL) AS not_available, COUNT(r.return_date IS NOT NULL) AS available, i.store_id
FROM sakila.rental r
JOIN sakila.inventory i
USING (inventory_id)
JOIN sakila.film f
USING (film_id)
WHERE f.title = 'Academy Dinosaur' AND i.store_id=1;

-- 7 Get all pairs of actors that worked together.
 SELECT * FROM actor; -- first_name, last_name,actor_id
 SELECT * FROM film_actor; -- actor_id, film_id
 SELECT * FROM film; -- film_id, title

SELECT a.first_name, a.last_name, f.title
FROM film f
JOIN film_actor fa
USING (film_id)
JOIN actor a
USING(actor_id)
ORDER BY f.title;

-- 8 Get all pairs of customers that have rented the same film more than 3 times.

-- customer_id
-- title
-- rent

-- 9. For each film, list actor that has acted in more films.

SELECT * FROM actor; -- first_name, last_name,actor_id
 SELECT * FROM film_actor; -- actor_id, film_id
 SELECT * FROM film; -- film_id, title

SELECT CONCAT(a.first_name,' ', a.last_name) AS Actor, COUNT(film_id) AS Num_films
FROM film
JOIN sakila.film_actor fa
USING(film_id)
JOIN sakila.actor a
USING (actor_id)
GROUP BY actor_id
ORDER BY Num_films DESC
LIMIT 1;