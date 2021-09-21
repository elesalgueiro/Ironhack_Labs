-- Lab | SQL Queries - Lesson 2.5


USE sakila;

-- 1. Select all the actors with the first name ‘Scarlett’.
SELECT * FROM actor
WHERE first_name = 'Scarlett';
-- 2. How many films (movies) are available for rent and how many films have been rented?


-- 3. What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT MAX(length) AS max_duration, MIN(length) AS min_duration FROM film;

-- 4.What's the average movie duration expressed in format (hours, minutes)?
SELECT AVG(length)/60 as hours FROM film;


SELECT FLOOR(AVG(length)/60) as hours, (AVG(length) % 60) as minutes  FROM film;

-- 5. How many distinct (different) actors' last names are there?

SELECT COUNT(DISTINCT last_name) FROM actor;

-- 6. Since how many days has the company been operating (check DATEDIFF() function)?

SELECT DATEDIFF(MAX(payment_date), MIN(payment_date)) AS active_days
FROM
    payment;

SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS active_days
FROM
    rental;
-- 7. Show rental info with additional columns month and weekday. Get 20 results.
SELECT* FROM rental;
SELECT *, date_format(rental_date, '%M'), date_format(rental_date, '%W')FROM rental;

-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *,
CASE
	WHEN DATE_FORMAT(rental_date, '%W') IN ('Saturday' , 'Sunday') THEN 'weekend'
	ELSE 'workday'
END AS day_type
FROM
    rental;

-- Get release years
SELECT DISTINCT (release_year) FROM film;
-- Get all films with ARMAGEDDON in the title.
SELECT film_id, title FROM film
WHERE title LIKE '%Armageddon%';
-- Get all films which title ends with APOLLO.
SELECT film_id, title FROM film
WHERE title LIKE '%APOLLO';
-- Get 10 the longest films.
SELECT title, length FROM film
ORDER BY length DESC
LIMIT 10;
-- How many films include Behind the Scenes content?

SELECT COUNT(title) FROM FILM
WHERE special_features LIKE '%Behind the Scenes%';

-- Lab | SQL Queries - Lesson 2.6

-- 1 In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list.
SELECT * FROM actor
GROUP BY last_name
HAVING COUNT(last_name)= 1;

-- 2 Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once
SELECT last_name FROM actor
GROUP BY last_name
HAVING COUNT(*)>1;
-- 3 Using the rental table, find out how many rentals were processed by each employee.

SELECT staff_id,COUNT(*) FROM rental
GROUP BY staff_id;

-- 4 Using the film table, find out how many films were released each year.
SELECT release_year,COUNT(*)
FROM film
GROUP BY release_year;

-- 5 Using the film table, find out for each rating how many films were there.
SELECT rating, COUNT(*)
FROM film
GROUP BY rating;
-- 6 What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
SELECT rating, round(AVG(length),2) AS avg_length
FROM film
GROUP BY rating;

-- 7 Which kind of movies (rating) have a mean duration of more than two hours?
SELECT rating, round(AVG(length),2) AS average_duration FROM film
GROUP BY rating
HAVING AVG(length)> 120;

-- 8 Rank films by length (filter out the rows that have nulls or 0s in length column). 
-- In your output, only select the columns title, length, and the rank.
SELECT title, length, RANK() OVER (ORDER BY length) ranks
FROM film
WHERE (length IS NOT NULL) AND (length <> '0');


-- Lab 2.7| SQL Join (Part I)

-- 1. How many films are there for each of the categories in the category table. Use appropriate join to write this query.
SELECT * FROM category;
SELECT * FROM  film_category;

SELECT c.name, COUNT(fc.film_id) AS num_films
 FROM category c
 JOIN film_category fc
 ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY num_films DESC;

-- 2.Display the total amount rung up by each staff member in August of 2005.
SELECT * FROM payment; 
SELECT * FROM staff; 

SELECT s.staff_id, CONCAT(s.first_name,' ',s.last_name) AS name,  SUM(p.amount)
FROM staff s
JOIN payment p
USING (staff_id)
WHERE MONTH(p.payment_date) ='8' AND YEAR(p.payment_date)='2005'
GROUP BY s.staff_id;

-- 3. Which actor has appeared in the most films?
SELECT * FROM actor; 
SELECT * FROM film_actor;

SELECT CONCAT(a.first_name,' ', a.last_name), COUNT(fa.film_id) AS num_films
FROM actor a
RIGHT JOIN film_actor fa
USING (actor_id)
GROUP BY actor_id 
ORDER BY num_films DESC
LIMIT 1;
-- 4. Most active customer (the customer that has rented the most number of films)
SELECT COUNT(*) FROM rental;
SELECT * FROM customer;

SELECT c.customer_id,CONCAT( c.first_name,' ', c.last_name) AS name, COUNT(r.rental_id) AS num_rents
FROM rental r
JOIN customer c
USING ( customer_id)
GROUP BY name
ORDER BY num_rents DESC
LIMIT 1;

-- 5.Display the first and last names, as well as the address, of each staff member.
SELECT * FROM staff;
SELECT * FROM address; -- address_id
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
USING (address_id);

 
-- 6.List each film and the number of actors who are listed for that film.

SELECT f.title, COUNT( fa.actor_id) AS num_actor
FROM film f
JOIN film_actor fa
USING( film_id)
GROUP BY title
ORDER BY num_actor DESC;
-- 7.Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.
SELECT * FROM payment;
SELECT * FROM customer; 

SELECT  customer_id,c.last_name, c.first_name, SUM(p.amount) AS total_paid
FROM payment p
JOIN customer c
USING ( customer_id)
GROUP BY customer_id
ORDER BY c.last_name;

-- 8.List number of films per category.
SELECT * FROM category;
SELECT * FROM film_category;

SELECT c.name, COUNT(fc.film_id) as num_films
FROM  category c
JOIN film_category fc
USING ( category_id)
GROUP BY c.name
ORDER BY num_films DESC;

-- Lab | SQL Join (Part II)

-- 1.Write a query to display for each store its store ID, city, and country.
SELECT * FROM store;
SELECT * FROM address; -- address_id
SELECT * FROM city;-- city_id
SELECT * FROM country;-- country_id

SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a
USING ( address_id)
JOIN city c
USING ( city_id)
JOIN country co
USING( country_id)
GROUP BY s.store_id;

-- 2.Write a query to display how much business, in dollars, each store brought in.
SELECT COUNT(*) FROM payment;
SELECT * FROM staff; -- staff_id

SELECT s.store_id, SUM( p.amount) AS total_business
FROM staff s
JOIN payment p
USING( staff_id)
 GROUP BY s.store_id;


-- 3.Which film categories are longest?

SELECT * FROM category;
SELECT * FROM film_category; -- categroy_id
SELECT * FROM film; -- film_id

SELECT c.name, SUM(f.length) AS longest
FROM category c
JOIN film_category fa
USING( category_id)
JOIN film f
USING( film_id)
GROUP BY c.name
ORDER BY longest DESC;

SELECT c.name, AVG(f.length) AS longest
FROM category c
JOIN film_category fa
USING( category_id)
JOIN film f
USING( film_id)
GROUP BY c.name
ORDER BY longest DESC;

-- 4.Display the most frequently rented movies in descending order.
SELECT * FROM film; -- film_id, title
SELECT * FROM inventory; -- film_id
SELECT * FROM rental; -- inventory_id

SELECT f.title, COUNT(r.rental_id) AS num_rentals
FROM film f
JOIN inventory i
USING( film_id)
JOIN rental r
USING ( inventory_id)
GROUP BY title
ORDER BY num_rentals DESC;
-- 5.List the top five genres in gross revenue in descending order.
SELECT * FROM category; -- NAME
SELECT * FROM film_category;-- category_id
SELECT * FROM film;-- film_id
SELECT * FROM inventory; -- film_id
SELECT * FROM rental; -- inventory_id --AMOUNT

SELECT  c.name,SUM(p.amount) AS profit
FROM category c
JOIN film_category  fc 
USING ( category_id)
JOIN film f  
USING (film_id)
JOIN inventory i
USING (film_id)
JOIN rental r
USING( inventory_id)
JOIN payment p
USING (rental_id)
GROUP BY name
ORDER BY  profit DESC
LIMIT 5;

-- 6.Is "Academy Dinosaur" available for rent from Store 1?
SELECT * FROM film; -- title
SELECT * FROM inventory; -- film_id, store_id
SELECT * FROM store;-- store_id_id

SELECT f.title, i.store_id, i.inventory_id
FROM film f
JOIN inventory i
USING(film_id)
WHERE title = 'Academy Dinosaur' AND store_id= '1';

-- 7.Get all pairs of actors that worked together.
-- see lab solution
SELECT * FROM actor;
SELECT * FROM film_actor; -- actor_id

-- 8.Get all pairs of customers that have rented the same film more than 3 times.
-- lab solution

-- 9. For each film, list actor that has acted in more films.

SELECT * FROM film;
SELECT * FROM film_actor; -- film_id
SELECT * FROM actor; -- actor_id

SELECT a.actor_id, CONCAT ( a.first_name, ' ', a.last_name), COUNT(fa.film_id) as num_films
FROM actor a
JOIN film_actor fa USING ( actor_id)
JOIN film f USING (film_id)
GROUP BY actor_id
ORDER BY num_films DESC
LIMIT 1;

-- Lab | SQL - Lab 3.01 MANIPULATING DATABASE/TABLES
USE sakila2;
-- 1.Drop column picture from staff.
ALTER TABLE staff
DROP COLUMN picture;
-- 2.A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. 
-- Update the database accordingly.
SELECT * FROM CUSTOMER
WHERE last_name = 'SANDERS' AND first_name ='TAMMY';

SELECT * FROM STAFF;
INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update)
VALUES('3','TAMMY','SANDERS','79','TAMMY.SANDERS@sakilacustomer.org','2','1','Tammy',NULL,'2021-04-05 17:03:42');

-- 3.Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. For eg., you would notice that you need customer_id information as well. To get that you can use the following query:
	--  select customer_id from sakila.customer
	--  where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
	--  Use similar method to get inventory_id, film_id, and staff_id.
    
    USE sakila;
-- LAB | SQL Subqueries 3.03

-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film_id,COUNT( inventory_id) AS num_copies
FROM sakila.inventory
WHERE film_id IN (SELECT film_id FROM sakila.film
			WHERE title = 'Hunchback Impossible')
;
-- 2 List all films whose length is longer than the average of all the films.

SELECT AVG(length) FROM sakila.film;

SELECT title, length FROM sakila.film
WHERE length > ( SELECT AVG(length) FROM sakila.film);
-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id, first_name, last_name FROM actor;
SELECT actor_id, film_id FROM film_actor;
SELECT film_id, title FROM film
WHERE title = 'Alone Trip';
-- subquery:
SELECT actor_id, first_name, last_name FROM actor
WHERE actor_id IN
    (SELECT actor_id FROM
    ( SELECT actor_id, film_id FROM film_actor 
    WHERE film_id IN 
		( SELECT film_id FROM ( SELECT film_id, title FROM film
		WHERE title = 'Alone Trip'
        )sub1
        )
    )sub2
);
    
    -- USIN JOINS IS POSSIBLE?? YES, AND FOR ME IS MUCH MORE EASY!!
    SELECT title, actor_id, first_name, last_name 
    FROM actor
    JOIN film_actor
    USING ( actor_id)
    JOIN film
    USING (film_id)
    WHERE title = 'Alone Trip';
    
-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- TITLE AND CATEGORY FAMILY

SELECT * FROM sakila.film; -- FILM ID
SELECT * FROM sakila.film_category; -- FILM_ID, CATEGORY_ID
SELECT * FROM sakila.category; -- CATEGORY_ID, NAME

SELECT title FROM film
	WHERE film_id IN
		(SELECT film_id FROM film_category 
				WHERE category_id IN
                (SELECT category_id FROM category 
					WHERE name = 'Family')
		);
	-- USING JOINS: 

    SELECT title, name 
    FROM film
    JOIN film_category
    USING ( film_id)
    JOIN category
    USING ( category_id)
    WHERE name = 'Family';
    
-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
	-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT COUNT(address_id) FROM customer; -- FIRST_NAME, LAST_NAME,E-MAIL  --address_id
SELECT COUNT(city_id) FROM address; -- address_id, city_id
SELECT COUNT(city_id) FROM city;-- city_id,country_id
SELECT * FROM country; -- name 

SELECT first_name,last_name,email FROM customer
	WHERE address_id IN 
		(SELECT address_id FROM address
			WHERE city_id IN 
				(SELECT city_id FROM city
					WHERE country_id IN	
						(SELECT country_id FROM country
				WHERE country = 'Canada')
			)
		);
    
   -- USING JOIN:
   SELECT first_name,last_name,email,country 
   FROM customer
   JOIN address USING (address_id)
   JOIN city USING (city_id)
   JOIN country USING (country_id)
   WHERE country = 'Canada';

-- 6 Which are films starred by the most prolific actor? 
	-- Most prolific actor is defined as the actor that has acted in the most number of films. 
	-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
   SELECT * FROM actor;
   SELECT * FROM film_actor; -- actor_id
   SELECT * FROM film; -- film_id, title
   -- FINDING MOST PROLIFIC ACTOR:
    SELECT CONCAT( first_name,' ', last_name), actor_id,COUNT(film_id) as total_films
    FROM actor
    JOIN film_actor USING (actor_id)
    JOIN film USING (film_id)
    GROUP BY actor_id
    ORDER BY total_films DESC
    LIMIT 1;
    -- actor_id = 1
    
    SELECT title, film_id 
    FROM film
		WHERE film_id IN 
			(SELECT film_id FROM film_actor
            WHERE actor_id= 1);
    
    SELECT title, film_id 
    FROM film
		WHERE film_id IN
			(SELECT film_id FROM film_actor
				WHERE actor_id =
					(SELECT actor_id 
                    FROM actor
					JOIN film_actor USING (actor_id)
					JOIN film USING (film_id)
					GROUP BY actor_id
					ORDER BY COUNT(film_id) DESC
					LIMIT 1)
				);
                
-- 7 Films rented by most profitable customer. 
--   ---MOST PROFITABLE CUSTOMER = customer pay the MAX
SELECT customer_id, SUM(amount) AS total_expense
FROM payment
GROUP BY customer_id
ORDER BY total_expense DESC
LIMIT 1;
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title FROM film; -- title
SELECT * FROM inventory; -- film_id, inventory_id
SELECT * FROM rental; -- inventory_id, customer_id
SELECT * FROM payment;-- customer_id, AMOUNT

SELECT title FROM film
	WHERE film_id IN
		(SELECT film_id FROM inventory
			WHERE inventory_id IN 
				(SELECT inventory_id FROM rental
					WHERE customer_id = 
						(SELECT customer_id
						FROM payment
						GROUP BY customer_id
						ORDER BY SUM(amount) DESC
						LIMIT 1)
				)
		);
                        
-- 8 Customers who spent more than the average payments.
SELECT * FROM customer;
SELECT AVG(amount) FROM payment;

SELECT CONCAT(first_name, ' ', last_name), customer_id
FROM customer 
	WHERE customer_id IN 
		(SELECT customer_id FROM payment
			WHERE amount >
				( SELECT AVG(amount) FROM payment))
					
GROUP BY customer_id;
            
SELECT CONCAT(first_name, ' ', last_name), customer_id, SUM(amount) AS total_payment
FROM customer
JOIN payment
USING (customer_id)
GROUP BY customer_id
HAVING SUM(amount) >AVG (total_payment)
ORDER BY total_payment DESC;
	 