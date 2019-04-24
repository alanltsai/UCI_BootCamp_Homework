-- Assignment 09 - SQL --
USE sakila;
SELECT * FROM actor;
-- 1a. Display the first and last names of all actors from the table `actor`
SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`
SELECT CONCAT(first_name, " ", last_name) as "Actor Name"
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name like 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`
SELECT *
FROM actor
WHERE last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order
SELECT *
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant)
ALTER TABLE actor
ADD COLUMN Description BLOB;
SELECT * FROM actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the `description` column
ALTER TABLE actor
DROP COLUMN Description;
SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) as "Count"
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO";

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`
SELECT s.first_name as "First Name", s.last_name as "Last Name", s.staff_id as "Staff ID", SUM(p.amount) as "Total Amount"
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title as "Film",  COUNT(fa.actor_id) as "Number of Actors in Film"
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.film_id;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(film_id) as "Hunchback Impossible Inventory"
FROM inventory
WHERE film_id IN
(
	SELECT film_id
    FROM film
    WHERE title = "Hunchback Impossible"
);

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
SELECT c.first_name as "First Name", c.last_name as "Last Name", SUM(p.amount) as "Total Amount Paid"
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title as "Movie Titles"
FROM film
WHERE title like "K%" OR title like "Q%" AND language_id IN
(
	SELECT language_id
    FROM language
    WHERE name = "English"
);

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`
SELECT first_name as "First Name", last_name as "Last Name"
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
    (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
    )
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name as "First Name", c.last_name as "Last Name", c.email as "Email Address"
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id
WHERE country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title as "Movie Title", f.film_id as "Film ID", fc.category_id as "Category ID", c.name as "Genre"
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = "Family";

-- 7e. Display the most frequently rented movies in descending order.
SELECT film.title as "Movie Title", COUNT(rental.rental_id) as "Number of Times Rented"
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT staff_id as "Staff ID", concat("$",format(SUM(amount), 2)) as "Total Payments"
FROM payment
GROUP BY staff_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id as "Store ID", city.city as "City", country.country as "Country"
FROM store AS store
INNER JOIN address address
ON store.address_id = address.address_id
INNER JOIN city city
on address.city_id = city.city_id
INNER JOIN country country
on city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name as "Category", concat("$", format(SUM(payment.amount), 2)) as "Total Gross Revenue"
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW genre_top_5 AS
SELECT category.name as "Category", concat("$", format(SUM(payment.amount), 2)) as "Total Gross Revenue"
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * from genre_top_5;

-- c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW genre_top_5;


