
-- Lab | SQL - Lab 3.01
USE sakila2;
-- 1 Drop column picture from staff.
ALTER table staff
DROP COLUMN picture;

-- 2 A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer.
-- Update the database accordingly.

SELECT * FROM sakila2.staff;
SELECT * FROM sakila2.customer;

INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,password,last_update)
VALUES
('3','TAMMY','SANDERS','79','TAMMY.SANDERS@sakilacustomer.org','2','1','Tammy',NULL,'2021-04-05 17:03:42');


-- 3 Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table.

SELECT customer_id FROM sakila2.customer
WHERE first_name = 'CHARLOTTE' AND last_name = 'HUNTER';


INSERT INTO inventory(inventory_id,film_id,store_id,last_update)
VALUES
(4582,1,1,'2021-04-05 16:59:00');

INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES
('2021-04-05 17:00:00', 4582, 130, NULL, 1, '2021-04-05 17:00:00');

SELECT film_id
FROM film
WHERE title = 'Academy Dinosaur';

SELECT inventory_id
FROM inventory
WHERE film_id = 1 AND last_update = '2021-04-05 16:59:00';

SELECT staff_id
FROM rental
WHERE inventory_id = 4582;
