1.	Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. 

--in this query rental and inventory table joined using inventory id and inventory and film table joined using film_id and in select statement selecting all columns from rental 
--and new column called rental status is created using case statement
--in case statement column return_status is calculted in which difference between return_date and rental_date is compared with rental_duration 
-- if rental duration is greater than that value then dvd returned early, if rental duration is less than the calculted value then dvd returned late.
-- if it is neither greater nor lesser then dvd retuned on time.

SELECT r.*, 
		CASE WHEN f.rental_duration > DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'early'
			WHEN f.rental_duration < DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'late'
			ELSE 'on time' END AS return_status
FROM rental as r
JOIN inventory as i
ON r.inventory_id = i.inventory_id
JOIN film as f
ON i.film_id = f.film_id;


2.	Show the total payment amounts for people who live in Kansas City or Saint Louis.

--payment table joined to customer using customer_id, customer and address using address_id, address and city using city_id 
-- where clause is filtering data for Saint louis and kansas city
--in the resulted table we have customer's first_name and last_name and amount as sum and city 

	SELECT c.first_name AS fname, c.last_name AS lname, SUM(p.amount) AS total_amount , ci.city
	FROM payment as p
	JOIN customer as c
	ON p.customer_id = c.customer_id
	JOIN address as a
	ON c.address_id = a.address_id
	JOIN city as ci
	ON a.city_id = ci.city_id
	WHERE city = 'Kansas City' OR city = 'Saint Louis'
	GROUP BY fname, lname, ci.city;
	
	
3.	How many film categories are in each category? Why do you think there is a table for category and a table for film category?

	SELECT c.name as category, COUNT(i.film_id) as total
	FROM category as c
	JOIN film_category as fc
	ON c.category_id = fc.category_id
	JOIN inventory as i
	ON fc.film_id = i.film_id
	GROUP BY category;



4.	Show a roster for the staff that includes their email, address, city, and country (not ids)

	SELECT c.first_name , c.last_name, c.email, ci.city, co.country
	FROM customer AS c
	JOIN address AS a
	ON c.address_id = a.address_id
	JOIN city as ci
	ON a.city_id = ci.city_id
	JOIN country as co
	ON ci.country_id = co.country_id;

5.	Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005

	SELECT f.film_id, f.title, f.length
	FROM film AS f
	JOIN inventory AS i
	ON f.film_id = i.film_id
	JOIN rental AS r
	ON i.inventory_id = r.inventory_id
	WHERE r.return_date BETWEEN '2005/05/15' AND '2005/05/31';


6.	Write a subquery to show which movies are rented below the average price for all movies. 



7.	Write a join statement to show which moves are rented below the average price for all movies.

8.	Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.

9.	With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 

10.	In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 

Bonus:
Find the relationship that is wrong in the data model. Explain why its wrong. 
