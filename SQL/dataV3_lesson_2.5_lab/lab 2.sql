USE sakila; 

-- 1 Select all the actors with the first name ‘Scarlett’
SELECT * FROM sakila.actor
WHERE first_name = 'Scarlett';

-- 2 How many films (movies) are available for rent and how many films have been rented?
SELECT * FROM rental;

SELECT COUNT(rental_date)-COUNT(return_date)  AS Available FROM rental;
-- todas la peliculas alquiladas - todas las peliculas devueltas = peliculas disponibles totales

SELECT COUNT(DISTINCT inventory_id) - (COUNT(rental_date)-COUNT(return_date))  AS 'Available' FROM rental;

-- 3 What are the shortest and longest movie duration? Name the values max_duration and min_duration
SELECT MAX(length) as max_duration FROM sakila.film;
SELECT MIN(length) as max_duration FROM sakila.film;

-- 4 What's the average movie duration expressed in format (hours, minutes)?

SELECT FLOOR(AVG(length)/ 60) AS hour, (AVG(length) % 60) AS minutes
 FROM film;

-- 5 How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT last_name) FROM sakila.actor;

-- 6 Since how many days has the company been operating (check DATEDIFF() function)?

SELECT * FROM sakila.payment;

SELECT (MAX(payment_date)-MIN(payment_date)) FROM sakila.payment;

 SELECT MAX(payment_date) FROM payment;
 SELECT MIN(payment_date) FROM payment;
 SELECT DATEDIFF('2006/02/14', '2005/05/24') AS DateDiff;
-- IS AN MATH OPERATION SO WE DO NOT PUT FROM

-- 7. Show rental info with additional columns month and weekday. Get 20 results.
SELECT * FROM sakila.rental;

SELECT *, date_format(rental_date, '%M') AS 'month', WEEKDAY (rental_date) AS wday FROM sakila.rental;
SELECT *, date_format(rental_date, '%M') AS 'month', DAYNAME (rental_date) AS wday FROM sakila.rental;

-- 8 Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.

SELECT *,
CASE
WHEN weekday(rental_date) < 6 then 'Weekday'
ELSE 'Weekend'
END AS 'day_type'
FROM rental;

-- 9. Get release years

SELECT DISTINCT release_year FROM sakila.film;

-- 10.Get all films with ARMAGEDDON in the title.

SELECT title
FROM film
WHERE title LIKE '%ARMAGEDDON%';

-- 11  Get all films which title ends with APOLLO.
SELECT title
FROM film
WHERE title LIKE '%APOLLO';

-- 12 Get 10 the longest films

SELECT title, length FROM film
ORDER BY length DESC
LIMIT 10;

-- How many films include Behind the Scenes content?

SELECT COUNT(title) FROM film
WHERE special_features LIKE '%Behind the Scenes%';