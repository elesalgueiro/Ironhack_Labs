USE SAKILA;
-- 1.In the table actor, which are the actors whose last names are not repeated? 

SELECT * FROM sakila.actor;
SELECT first_name, last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) = 1;

-- 2.Which last names appear more than once?

SELECT first_name, last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1 ;
 
-- 3 Using the rental table, find out how many rentals were processed by each employee

SELECT * FROM sakila.rental;

SELECT COUNT(rental_id) FROM sakila.rental
where staff_id= '1' ;

SELECT COUNT(rental_id) FROM sakila.rental
WHERE staff_id= '2';

-- 4.Using the film table, find out how many films were released each year.

SELECT DISTINCT release_year FROM film;
SELECT  COUNT(release_year) FROM sakila.film
WHERE release_year= '2006';

-- 5.Using the film table, find out for each rating how many films were there.

 SELECT DISTINCT rating, COUNT(title) FROM film
 GROUP BY rating;
 
 -- 6 What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
 
 SELECT rating, round(AVG(length),2) FROM film
 GROUP BY rating;
 
 -- 7 Which kind of movies (rating) have a mean duration of more than two hours?
 
 SELECT AVG(length) as average_r ,rating 
 FROM film
 GROUP BY rating
 HAVING average_r> '120';
 
 -- 8 Rank films by length (filter out the rows that have nulls or 0s in length column). 
 -- In your output, only select the columns title, length, and the rank.
 
 SELECT title,length,rating FROM film 
 WHERE length <> ' '
 ORDER BY length ASC
