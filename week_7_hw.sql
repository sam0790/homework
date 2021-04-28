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

--category table joined to film_category usinf category_id, film_category joined to inventory using film_id and grouped by category and showing category, and total in result table.
-- because film category table is acting as link table between category and film table.

	SELECT c.name as category, COUNT(i.film_id) as total
	FROM category as c
	JOIN film_category as fc
	ON c.category_id = fc.category_id
	JOIN inventory as i
	ON fc.film_id = i.film_id
	GROUP BY category;



4.	Show a roster for the staff that includes their email, address, city, and country (not ids)

--in this query customer table is joined with address on address_id, address joined with city on city_id, city joined on country_id to show final columns first name,
--last name, email and address.

	SELECT c.first_name , c.last_name, c.email, ci.city, co.country
	FROM customer AS c
	JOIN address AS a
	ON c.address_id = a.address_id
	JOIN city as ci
	ON a.city_id = ci.city_id
	JOIN country as co
	ON ci.country_id = co.country_id;

5.	Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005

--film table joined with inventory using film_id, inventory then joined with rental using inventory_id where date between may 15 to 31,2015.

	SELECT f.film_id, f.title, f.length
	FROM film AS f
	JOIN inventory AS i
	ON f.film_id = i.film_id
	JOIN rental AS r
	ON i.inventory_id = r.inventory_id
	WHERE r.return_date BETWEEN '2005/05/15' AND '2005/05/31';


6.	Write a subquery to show which movies are rented below the average price for all movies. 

--payment table is joined with rental at rental_id, rental with inventory using inventory_id, inventory with film using film_id, filtering amount less than average amount price
--in where clause and ordering by title.

	SELECT title, amount
	FROM payment AS p
	JOIN rental AS r
	ON p.rental_id = r.rental_id
	JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	JOIN film AS f
	ON i.film_id = f.film_id
	WHERE p.amount < (SELECT ROUND((AVG(amount)),2)FROM payment)
	ORDER BY title;

7.	Write a join statement to show which moves are rented below the average price for all movies.

--payment table is joined with rental at rental_id, rental with inventory using inventory_id, inventory with film using film_id and joining with subquesry which filters 
--amount less than average amount and ordering by title.
	
	SELECT title, amount
	FROM payment AS p
	JOIN rental AS r
	ON p.rental_id = r.rental_id
	JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	JOIN film AS f
	ON i.film_id = f.film_id
	JOIN (SELECT ROUND((AVG(amount)),2) as avg_am FROM payment) as avg_rate on p.amount < avg_rate.avg_am
	ORDER BY title;



8.	Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.

--based on data from these results we can see that query 6 is faster than query 7.
--query 6 

	EXPLAIN ANALYSE
	SELECT title, amount
	FROM payment AS p
	JOIN rental AS r
	ON p.rental_id = r.rental_id
	JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	JOIN film AS f
	ON i.film_id = f.film_id
	WHERE p.amount < (SELECT ROUND((AVG(amount)),2)FROM payment)
	ORDER BY title;
	
	"Sort  (cost=1632.79..1644.96 rows=4865 width=21) (actual time=51.080..51.499 rows=7554 loops=1)"
"  Sort Key: f.title"
"  Sort Method: quicksort  Memory: 772kB"
"  InitPlan 1 (returns $0)"
"    ->  Aggregate  (cost=290.45..290.46 rows=1 width=32) (actual time=7.199..7.200 rows=1 loops=1)"
"          ->  Seq Scan on payment  (cost=0.00..253.96 rows=14596 width=6) (actual time=0.013..2.307 rows=14596 loops=1)"
"  ->  Hash Join  (cost=715.56..1044.39 rows=4865 width=21) (actual time=15.520..26.916 rows=7554 loops=1)"
"        Hash Cond: (i.film_id = f.film_id)"
"        ->  Hash Join  (cost=639.06..955.06 rows=4865 width=8) (actual time=14.662..23.939 rows=7554 loops=1)"
"              Hash Cond: (r.inventory_id = i.inventory_id)"
"              ->  Hash Join  (cost=510.99..814.21 rows=4865 width=10) (actual time=13.107..19.996 rows=7554 loops=1)"
"                    Hash Cond: (p.rental_id = r.rental_id)"
"                    ->  Seq Scan on payment p  (cost=0.00..290.45 rows=4865 width=10) (actual time=7.229..11.147 rows=7554 loops=1)"
"                          Filter: (amount < $0)"
"                          Rows Removed by Filter: 7042"
"                    ->  Hash  (cost=310.44..310.44 rows=16044 width=8) (actual time=5.755..5.756 rows=16044 loops=1)"
"                          Buckets: 16384  Batches: 1  Memory Usage: 755kB"
"                          ->  Seq Scan on rental r  (cost=0.00..310.44 rows=16044 width=8) (actual time=0.037..2.729 rows=16044 loops=1)"
"              ->  Hash  (cost=70.81..70.81 rows=4581 width=6) (actual time=1.504..1.504 rows=4581 loops=1)"
"                    Buckets: 8192  Batches: 1  Memory Usage: 234kB"
"                    ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.019..0.735 rows=4581 loops=1)"
"        ->  Hash  (cost=64.00..64.00 rows=1000 width=19) (actual time=0.814..0.815 rows=1000 loops=1)"
"              Buckets: 1024  Batches: 1  Memory Usage: 60kB"
"              ->  Seq Scan on film f  (cost=0.00..64.00 rows=1000 width=19) (actual time=0.064..0.440 rows=1000 loops=1)"
"Planning Time: 0.952 ms"
"Execution Time: 52.989 ms"


--query 7 

	EXPLAIN ANALYSE	
	SELECT title, amount
	FROM payment AS p
	JOIN rental AS r
	ON p.rental_id = r.rental_id
	JOIN inventory AS i
	ON r.inventory_id = i.inventory_id
	JOIN film AS f
	ON i.film_id = f.film_id
	JOIN (SELECT ROUND((AVG(amount)),2) as avg_am FROM payment) as avg_rate on p.amount < avg_rate.avg_am
	ORDER BY title;




	"Sort  (cost=1755.13..1767.29 rows=4865 width=21) (actual time=62.447..62.946 rows=7554 loops=1)"
"  Sort Key: f.title"
"  Sort Method: quicksort  Memory: 772kB"
"  ->  Hash Join  (cost=992.27..1457.19 rows=4865 width=21) (actual time=15.747..32.576 rows=7554 loops=1)"
"        Hash Cond: (i.film_id = f.film_id)"
"        ->  Hash Join  (cost=915.77..1367.86 rows=4865 width=8) (actual time=15.187..28.611 rows=7554 loops=1)"
"              Hash Cond: (r.inventory_id = i.inventory_id)"
"              ->  Hash Join  (cost=787.70..1227.01 rows=4865 width=10) (actual time=12.987..22.416 rows=7554 loops=1)"
"                    Hash Cond: (r.rental_id = p.rental_id)"
"                    ->  Seq Scan on rental r  (cost=0.00..310.44 rows=16044 width=8) (actual time=0.025..2.143 rows=16044 loops=1)"
"                    ->  Hash  (cost=726.88..726.88 rows=4865 width=10) (actual time=12.661..12.663 rows=7554 loops=1)"
"                          Buckets: 8192  Batches: 1  Memory Usage: 389kB"
"                          ->  Nested Loop  (cost=290.45..726.88 rows=4865 width=10) (actual time=3.464..10.296 rows=7554 loops=1)"
"                                Join Filter: (p.amount < (round(avg(payment.amount), 2)))"
"                                Rows Removed by Join Filter: 7042"
"                                ->  Aggregate  (cost=290.45..290.46 rows=1 width=32) (actual time=3.422..3.422 rows=1 loops=1)"
"                                      ->  Seq Scan on payment  (cost=0.00..253.96 rows=14596 width=6) (actual time=0.015..1.117 rows=14596 loops=1)"
"                                ->  Seq Scan on payment p  (cost=0.00..253.96 rows=14596 width=10) (actual time=0.036..1.773 rows=14596 loops=1)"
"              ->  Hash  (cost=70.81..70.81 rows=4581 width=6) (actual time=2.150..2.151 rows=4581 loops=1)"
"                    Buckets: 8192  Batches: 1  Memory Usage: 234kB"
"                    ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6) (actual time=0.023..1.016 rows=4581 loops=1)"
"        ->  Hash  (cost=64.00..64.00 rows=1000 width=19) (actual time=0.548..0.548 rows=1000 loops=1)"
"              Buckets: 1024  Batches: 1  Memory Usage: 60kB"
"              ->  Seq Scan on film f  (cost=0.00..64.00 rows=1000 width=19) (actual time=0.026..0.274 rows=1000 loops=1)"
"Planning Time: 1.094 ms"
"Execution Time: 63.513 ms"

9.	With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 

	SELECT title, length, ntile(100) OVER (ORDER BY length) AS percentile
	FROM film
	ORDER BY percentile;

10.	In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 

	The term set-based is used to describe an approach to handle querying tasks and is based on principles from the relational model.
	whereas Procedural Programming can be defined as a programming model which is derived from structured programming, based upon the concept of calling procedure. 
	Procedures, also known as routines, subroutines or functions, simply consist of a series of computational steps to be carried out.
	SQL is a declarative language, designed to work with sets of data. Python is considered as an object-oriented programming language rather than a procedural programming language.

Bonus:
Find the relationship that is wrong in the data model. Explain why its wrong. 
