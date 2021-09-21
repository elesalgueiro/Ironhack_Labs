USE sakila;
-- 1 Review the tables in the database
SHOW COLUMNS FROM actor;
SHOW COLUMNS FROM address;
-- 2 Explore tables by selecting all columns from each table or using the in built review features for your client.
SELECT * FROM actor;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM film;
-- 3 Select one column from a table. Get film titles.
SELECT title FROM film; 
-- 4 Select one column from a table and alias it. Get unique list of film languages under the alias language
SELECT name AS languages FROM language;
-- 4 Find out how many stores and staff does the company have? Can you return a list of employee first names only?
SELECT staff_id FROM staff;
SELECT store_id FROM store;
SELECT first_name FROM staff;
-- Bonus: How many unique days did customers rent movies in this dataset?
SELECT DISTINCT rental_date  FROM rental;