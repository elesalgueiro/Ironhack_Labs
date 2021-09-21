
-- Lab | SQL Join (Part I)

USE SAKILA;

-- 1 How many films are there for each of the categories in the category table.
--  Use appropriate join to write this query.


-- ONE CATEGORY, MANY FILMS IT ONE-TO-MANY
SELECT * FROM category;
SELECT * FROM film_category;
-- JOIN category_id

SELECT fc.category_id, COUNT(fc.film_id)
FROM category c
JOIN film_category fc
USING ( category_id)
GROUP BY category_id;

-- 2 Display the total amount rung up by each staff member in August of 2005.
-- TOTAL AMOUNT in payment 
-- STAFF ID in staff and payment
-- PAYMENT DATE in payment
-- ONE (STAFF) - MANY ( PAYMENT)
SELECT * FROM staff;
SELECT * FROM payment;

SELECT SUM(p.amount),s.staff_id, p.payment_date
FROM staff s
JOIN payment p
USING (staff_id)
WHERE payment_date BETWEEN '2005-08-1 00:00:00' AND  '2005-08-31 00:00:00'
GROUP BY staff_id;
-- other way 
SELECT SUM(amount), staff_id
FROM sakila.payment p
WHERE DATE(payment_date) BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY p.staff_id;

-- 3 Which actor has appeared in the most films?
-- que actor ha aparecido en mas peliculas
SELECT * FROM actor;
SELECT *FROM film_actor;
SELECT * FROM film;
-- actor_id, first_name, last_name from actor
-- film_id,title from film 
-- actor_id,film_id from film_actor

SELECT fa.actor_id, COUNT(DISTINCT f.film_id) AS total_films
FROM film f
JOIN film_actor fa
USING (film_id)
GROUP BY actor_id
ORDER BY total_films DESC;


-- 4 Most active customer (the customer that has rented the most number of films)
-- customer_id 
-- with bigger rental_id 
SELECT * FROM customer; -- customer_id (599 diferentes)
SELECT * FROM rental ;-- rental_id,customer_id

SELECT c.customer_id, COUNT(r.rental_id) AS total_rent
FROM customer c
JOIN rental r
USING (customer_id)
GROUP BY c.customer_id
ORDER BY total_rent DESC;

-- 5 Display the first and last names, as well as the address, of each staff member.

-- staff first_name, last_name, address in address
SELECT * FROM staff;-- first_name, last_name, address_id
SELECT * FROM address; -- address_id, address

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
USING(address_id);

-- 6 List each film and the number of actors who are listed for that film.

-- film_title
-- actors_id  count
SELECT * FROM film; -- film_id, title
SELECT * FROM film_actor; -- actor_id, film_id

SELECT f.title, COUNT(fa.actor_id) AS num_actor
FROM film f
JOIN film_actor fa
USING(film_id)
GROUP BY title
ORDER BY num_actor DESC;

-- 7 Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name.
-- total paid by customer
SELECT * FROM payment; -- amount, customer_id, payment_id
SELECT * FROM customer;-- customer_id, last_name, first_name

SELECT DISTINCT c.customer_id,c.last_name,c.first_name, SUM(p.amount) as total_paid
FROM customer c
JOIN payment p
USING(customer_id)
GROUP BY customer_id
ORDER BY c.last_name ASC;

-- 8 List number of films per category.


SELECT * FROM category; -- category_id, name
SELECT * FROM film_category; -- film_id, category_id

SELECT c.name, COUNT(fc.film_id) as total_films
FROM category c
JOIN film_category fc
USING(category_id)
GROUP BY c.name;

-- END OF LAB