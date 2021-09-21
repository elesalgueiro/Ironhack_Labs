-- Lab | SQL Subqueries 3.03

USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT * from sakila.film; -- film_id, title
SELECT * FROM sakila. inventory;-- film_id, inventory_id

SELECT COUNT(*) FROM inventory
WHERE film_id IN (
	SELECT film_id FROM (
    SELECT film_id,title FROM film
    WHERE title LIKE 'Hunchback Impossible'
    ) sub1
);

    -- 2.List all films whose length is longer than the average of all the films
    
    SELECT title, length FROM film
WHERE length > (
  SELECT avg(length)
  FROM film
);

-- 3 Use subqueries to display all actors who appear in the film Alone Trip.  

SELECT * FROM film; -- FILM_ID, title
SELECT * FROM film_actor; -- ACTOR_ID, film_id
SELECT * FROM actor;-- last_name,first_name,ACTOR_ID

SELECT last_name, first_name,actor_id FROM actor 
WHERE actor_id IN (
	SELECT actor_id FROM (
    SELECT actor_id ,film_id FROM film_actor
    WHERE film_id IN (
		SELECT film_id FROM (
        SELECT film_id, title FROM film 
			WHERE title LIKE 'Alone Trip' -- like when your are looking for a test
			) sub1
		)
	)sub2
);


-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT * FROM sakila.category;-- name,category_id  ( name=Family)
SELECT * FROM film_category; -- film_id, category_id
SELECT * FROM film; -- title, film_id;

SELECT title, film_id FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
	WHERE category_id IN (
		SELECT category_id FROM category
		WHERE name LIKE 'family'
		)
	);
	
-- 5. Get name and email from customers from Canada using subqueries.
--    Do the same with joins.
--    Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT * FROM customer; -- first_name, last_name,email, ADDRESS_ID
SELECT * FROM address; -- ADDRESS_ID, city_id
SELECT * FROM city; -- CITY_ID, COUNTRY_ID
SELECT * FROM country; -- country, COUNTRY_ID


SELECT first_name, last_name, email,address_id FROM customer
WHERE address_id IN (
	SELECT address_id FROM 
		(SELECT city_id FROM city 
        WHERE country_id IN 
			(SELECT country_id FROM country
            WHERE country LIKE 'Canada'
			)
		)sub1
);


  SELECT c.first_name, c.last_name, c.email,co.country 
  FROM customer c
  JOIN address a
  USING (address_id)
  JOIN city
  USING (city_id)
  JOIN country co
  USING (country_id)
  WHERE co.country LIKE 'Canada';
  
  
  
  
  
  
-- 6.Which are films starred by the most prolific actor? 
 -- Most prolific actor is defined as the actor that has acted in the most number of films. 
 -- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT * FROM film; -- title, film_id
SELECT * FROM film_actor; -- actor_id,film_id
SELECT * FROM actor; -- actor_id

SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_actor
    WHERE actor_id IN (
		SELECT actor_id FROM(
			SELECT actor_id,COUNT(film_id) AS total_films
            FROM actor a
            JOIN film_actor fa
            USING (actor_id)
            GROUP BY actor_id
			ORDER BY total_films DESC
			LIMIT 1) sub1
			)
            ); 
            
-- 7.Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT * FROM film; -- title,film_id
SELECT * FROM inventory; -- film_id, inventory_id
SELECT * FROM rental; -- inventory_id,customer_id, 
SELECT * FROM payment; -- customer_id, payment_id

SELECT title 
FROM film
WHERE film_id IN(
	SELECT film_id FROM inventory 
		WHERE inventory_id IN( 
			SELECT inventory_id FROM rental
				WHERE customer_id IN(
					SELECT customer_id FROM(
                    SELECT customer_id, SUM(payment_id) as max_payment
                    FROM payment p
					GROUP BY customer_id
					ORDER BY max_payment DESC
					LIMIT 1) sub1
                    )
                    )
                    );
					
 -- 8.Customers who spent more than the average payments.
 SELECT * FROM customer; -- first_name, last_name, customer_id
 SELECT * FROM payment; -- rental_id,amount,customer_id
 
 SELECT customer_id, first_name, last_name FROM customer
 WHERE customer_id IN(
		SELECT customer_id FROM payment
        WHERE amount > (SELECT avg(amount)
					FROM payment)
		GROUP BY customer_id
        
    );
-- checking if it is correct.	
SELECT AVG(amount) FROM payment;
SELECT customer_id FROM payment
WHERE AMOUNT > '4.200667'
GROUP BY customer_id;