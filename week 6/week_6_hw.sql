
1.	Show all customers whose last names start with T. Order them by first name from A-Z.

-- selecting first_name and last_name from customer table using last_name starts with T and ordering by first_name
	
	SELECT first_name, last_name
	FROM customer
	WHERE last_name LIKE 'T%'
	ORDER BY first_name;

2.	Show all rentals returned from 5/28/2005 to 6/1/2005

-- showing all rental details from rental table between 2005/05/28 AND 2005/06/01
	SELECT *
	FROM rental
	WHERE rental_date BETWEEN '2005/05/28' AND '2005/06/01';


3.	How would you determine which movies are rented the most?

--joining inventory with rental at film_id and inventory with rental at inventory_id and showing film title and id with how many times it is rented grouping by 
--film_id and ordering with times rented descending so we get most time rented at top

	SELECT COUNT(*) as total, f.title, f.film_id
	FROM film f
	JOIN inventory i 
	ON i.film_id = f.film_id
	JOIN rental r
	ON r.inventory_id = i.inventory_id
	GROUP BY f.film_id
	ORDER BY COUNT(*) DESC;


4.	Show how much each customer spent on movies (for all time) . Order them from least to most.

--joining payment table with customer using customer_id and showing first and last name of customer and total amount they spent on rental 
--grouping with their first and last name and ordering by total amount spend on rental from least to most.

	SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spend
	FROM payment AS p
	JOIN customer AS c
	ON p.customer_id = c.customer_id
	GROUP BY c.first_name, c.last_name
	ORDER BY total_spend;
	
	
5.	Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias the actor name and count as a more descriptive name. Order the results from most to least.

--joining actor with film_actor with actor_id, film_actor with film using film_id and filtering result with year 2006 in where clause and grouping result by first and last name and 
--ordering them with total descending so we can get from most to least and showing first name asa fname, last name as lname and total with total number of movies in the final result.

	SELECT a.first_name AS fname, a.last_name AS lname, count(*) AS total
	FROM actor AS a
	JOIN film_actor as fa
	ON a.actor_id = fa.actor_id
	JOIN film AS f
	ON f.film_id = fa.film_id
	WHERE f.release_year = '2006'
	GROUP BY fname, lname
	ORDER BY total DESC;
	

6.	Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. Use the following link to understand how this works http://postgresguide.com/performance/explain.html 

--query 4

EXPLAIN ANALYSE SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spend
	FROM payment AS p
	JOIN customer AS c
	ON p.customer_id = c.customer_id
	GROUP BY c.first_name, c.last_name
	ORDER BY total_spend;

"Sort  (cost=459.61..461.11 rows=599 width=45) (actual time=25.088..25.130 rows=599 loops=1)"
"  Sort Key: (sum(p.amount))"
"  Sort Method: quicksort  Memory: 71kB"
"  ->  HashAggregate  (cost=424.49..431.98 rows=599 width=45) (actual time=24.191..24.642 rows=599 loops=1)"
"        Group Key: c.first_name, c.last_name"
"        Batches: 1  Memory Usage: 297kB"
"        ->  Hash Join  (cost=22.48..315.02 rows=14596 width=19) (actual time=0.406..12.092 rows=14596 loops=1)"
"              Hash Cond: (p.customer_id = c.customer_id)"
"              ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=8) (actual time=0.029..2.256 rows=14596 loops=1)"
"              ->  Hash  (cost=14.99..14.99 rows=599 width=17) (actual time=0.360..0.361 rows=599 loops=1)"
"                    Buckets: 1024  Batches: 1  Memory Usage: 39kB"
"                    ->  Seq Scan on customer c  (cost=0.00..14.99 rows=599 width=17) (actual time=0.021..0.180 rows=599 loops=1)"
"Planning Time: 0.513 ms"
"Execution Time: 25.337 ms"

--Query 5

EXPLAIN	ANALYSE SELECT a.first_name AS fname, a.last_name AS lname, count(*) AS total
	FROM actor AS a
	JOIN film_actor as fa
	ON a.actor_id = fa.actor_id
	JOIN film AS f
	ON f.film_id = fa.film_id
	WHERE f.release_year = '2006'
	GROUP BY fname, lname
	ORDER BY total DESC;
	
"Sort  (cost=245.88..246.20 rows=128 width=21) (actual time=19.480..19.503 rows=199 loops=1)"
"  Sort Key: (count(*)) DESC"
"  Sort Method: quicksort  Memory: 40kB"
"  ->  HashAggregate  (cost=240.12..241.40 rows=128 width=21) (actual time=19.206..19.309 rows=199 loops=1)"
"        Group Key: a.first_name, a.last_name"
"        Batches: 1  Memory Usage: 64kB"
"        ->  Hash Join  (cost=85.50..199.15 rows=5462 width=13) (actual time=0.768..12.700 rows=5462 loops=1)"
"              Hash Cond: (fa.film_id = f.film_id)"
"              ->  Hash Join  (cost=6.50..105.76 rows=5462 width=15) (actual time=0.209..7.318 rows=5462 loops=1)"
"                    Hash Cond: (fa.actor_id = a.actor_id)"
"                    ->  Seq Scan on film_actor fa  (cost=0.00..84.62 rows=5462 width=4) (actual time=0.053..1.497 rows=5462 loops=1)"
"                    ->  Hash  (cost=4.00..4.00 rows=200 width=17) (actual time=0.112..0.113 rows=200 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 18kB"
"                          ->  Seq Scan on actor a  (cost=0.00..4.00 rows=200 width=17) (actual time=0.024..0.055 rows=200 loops=1)"
"              ->  Hash  (cost=66.50..66.50 rows=1000 width=4) (actual time=0.541..0.541 rows=1000 loops=1)"
"                    Buckets: 1024  Batches: 1  Memory Usage: 44kB"
"                    ->  Seq Scan on film f  (cost=0.00..66.50 rows=1000 width=4) (actual time=0.017..0.336 rows=1000 loops=1)"
"                          Filter: ((release_year)::integer = 2006)"
"Planning Time: 0.971 ms"
"Execution Time: 19.728 ms"

7.	What is the average rental rate per genre?

--joining category table with film_category using category_id column and film_category table with film using film_id column and showing category name as genre and
--by roundung rental_rate from film table showing as avg_rental_price and showing final table grouping by genre

	SELECT c.name AS genre, ROUND(AVG(f.rental_rate),2) AS avg_rental_price
	FROM category AS c
	JOIN film_category AS fc
	ON c.category_id = fc.category_id
	JOIN film AS f
	ON fc.film_id = f.film_id
	GROUP BY genre;
	
8.	How many films were returned late? Early? On time?

--joining film table with inventory using film_id column and inventory table with rental using inventory_id
--in final result table column retrun_status is calculted by case statement in which difference between return_date and rental_date is compared with rental_duration 
-- if rental duration is greater than that value then dvd returned early, if rental duration is less than the calculted value then dvd returned late.
-- if it is neither greater nor lesser then dvd retuned on time.

	SELECT CASE WHEN f.rental_duration > DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'early'
				WHEN f.rental_duration < DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'late'
				ELSE 'on time' END AS return_status,
				COUNT(f.film_id) AS total 
	FROM film as f
	JOIN inventory as i
	ON f.film_id = i.film_id
	JOIN rental as r
	ON i.inventory_id = r.inventory_id
	GROUP BY return_status;


9.	What categories are the most rented and what are their total sales?

--from the below query sports is the most rented category with total sales is 4892.19.
--"Sports"	4892.19
"Sci-Fi"	4336.01
"Animation"	4245.31
"Drama"		4118.46
"Comedy"	4002.48
"New"		3966.38
"Action"	3951.84
"Foreign"	3934.47
"Games"		3922.18
"Family"	3830.15
"Documentary"	3749.65
"Horror"	3401.27
"Classics"	3353.38
"Children"	3309.39
"Travel"	3227.36
"Music"		3071.52

	SELECT c.name AS category, SUM(p.amount) AS total_sales
	FROM category AS c
	JOIN film_category AS fc
	ON c.category_id = fc.category_id
	JOIN inventory AS i
	ON fc.film_id = i.film_id
	JOIN rental AS r
	ON i.inventory_id = r.inventory_id
	JOIN payment AS p
	ON r.rental_id = p.rental_id
	GROUP BY category
	ORDER BY total_sales DESC;
	
	
10.	Create a view for 8 and a view for 9. Be sure to name them appropriately. 

--creating view from 8 and naming view as movie_return_status

CREATE VIEW movie_return_status AS
SELECT CASE WHEN f.rental_duration > DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'early'
			WHEN f.rental_duration < DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) THEN 'late'
			ELSE 'on time' END AS return_status,
			COUNT(f.film_id) AS total 
FROM film as f
JOIN inventory as i
ON f.film_id = i.film_id
JOIN rental as r
ON i.inventory_id = r.inventory_id
GROUP BY return_status;



-- creating view from 9 and naming it as total_sales_by_genre
	
	CREATE VIEW total_sales_by_genre AS
	SELECT c.name AS category, SUM(p.amount) AS total_sales
	FROM category AS c
	JOIN film_category AS fc
	ON c.category_id = fc.category_id
	JOIN inventory AS i
	ON fc.film_id = i.film_id
	JOIN rental AS r
	ON i.inventory_id = r.inventory_id
	JOIN payment AS p
	ON r.rental_id = p.rental_id
	GROUP BY category
	ORDER BY total_sales DESC;


Bonus:
Write a query that shows how many films were rented each month. Group them by category and month. 
