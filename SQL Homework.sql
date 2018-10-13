USE sakila;

-- 1a
SELECT (first_name), (last_name) FROM actor;

-- 1b
ALTER TABLE actor; 
SET SQL_SAFE_UPDATES = 0;
ADD COLUMN Actor_Name VARCHAR(75);
INSERT INTO actor (Actor_Name) VALUES (UPPER(first_name, " ", last_name));
SELECT * from actor;
SET SQL_SAFE_UPDATES = 1;

-- 2a
SELECT * FROM actor 
WHERE first_name = "Joe";

-- 2b
SELECT *FROM actor
WHERE last_name
LIKE '%GEN%';

-- 2c
SELECT last_name, first_name FROM actor
WHERE last_name
LIKE '%LI%';

-- 2d
SELECT country_id, country 
FROM country
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor 
ADD COLUMN description BLOB AFTER last_name;

-- 3b
ALTER TABLE actor
DROP COLUMN description; 

-- 4a
SELECT last_name, 
COUNT(*)
FROM actor 
GROUP BY last_name;

-- 4b
SELECT last_name, 
COUNT(*) AS 'Grouped Last Names' 
FROM actor 
GROUP BY last_name HAVING COUNT(*) > 1;

-- 4c
UPDATE actor 
SET first_name = 'Harpo' 
WHERE actor_id = '172';

-- 4d
UPDATE actor 
SET first_name = 'Groucho' 
WHERE actor_id = '172';

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, staff.address_id, address.address
FROM staff
JOIN address
ON staff.address_id = address.address_id;

-- 6b
SELECT staff.first_name, staff.last_name, staff.staff_id,
COUNT(payment.amount)
FROM staff
JOIN payment
ON payment.staff_id = staff.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;

-- 6c
SELECT film.title, 
COUNT(actor_id)
FROM film
JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY title;

-- 6d
SELECT title, 
COUNT(inventory_id)
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";

-- 6e
SELECT customer.last_name, customer.first_name, 
SUM(payment.amount)
FROM payment
JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;

-- 7a
SELECT title
FROM film 
WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
	(SELECT title 
	 FROM film 
	 WHERE language_id = 1);

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(Select actor_id
	 FROM film_actor
	 WHERE film_id IN 
			(SELECT film_id
			 FROM film
			 WHERE title = 'Alone Trip'));
             
-- 7c    
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address
ON customer.address_id = address.address_id
JOIN city
ON city.city_id = address.address_id
JOIN country
ON country.country_id = city.country_id
WHERE country.country = 'Canada';

-- 7d
SELECT title
FROM film
WHERE film_id IN 
	(SELECT film_id 
	 FROM film_category 
     WHERE category_id IN 
		(SELECT category_id
		FROM category
		WHERE name = 'Family'));
         
-- 7e    
SELECT film.title,
COUNT(rental.rental_id)
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f  
SELECT store.store_id, SUM(amount) 
FROM payment
JOIN rental
ON (payment.rental_id = rental.rental_id)
JOIN inventory
ON (inventory.inventory_id = rental.inventory_id)
JOIN store
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id;   

-- 7g
SELECT store.store_id, city.city, country.country
FROM store
JOIN address
ON address.address_id = store.address_id
JOIN city
ON address.city_id = city.city_id
JOIN country
ON city.country_id = country.country_id;

-- 7h
-- category, film_category, inventory, payment, and rental.
SELECT category.name,
COUNT(category.name)
FROM category
JOIN film_category
ON film_category.category_id = category.category_id
JOIN inventory
ON inventory.film_id = film_category.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY COUNT(category.name) DESC;

-- 8a
CREATE VIEW Top_Five AS
SELECT category.name,
COUNT(category.name)
FROM category
JOIN film_category
ON film_category.category_id = category.category_id
JOIN inventory
ON inventory.film_id = film_category.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY COUNT(category.name) DESC
LIMIT 5;

-- 8b
SELECT * FROM Top_Five;

-- 8c
DROP VIEW Top_Five;


