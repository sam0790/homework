/* 1. shows the content of each table we've created */

	select * from leoka;
	select * from nibrs;
	select * from population;

/* 2. counts the total population covered by Natinal Incident Based Reporting System (NIBRS) in the last decade by year */

	select p.data_year, sum(n.nibrs_population_covered) as total_covered_population
	from population p
	left join nibrs n
	on p.data_year=n.data_year
	where p.data_year > 2009
	group by 1
	order by p.data_year desc;

/* 3. counts the total number of law enforcement officers killed and assaulted in the last decade by year */

	select p.data_year, sum(l.agency_count_leoka_submitting) as total_leoka
	from population p
	left join nibrs n
	on p.data_year=n.data_year
	left join leoka l
	on n.total_agency_count = l.total_agency_count
	where p.data_year > 2009
	group by 1
	order by p.data_year desc;

/* 4. the count of the total number of law enforcement officers killed and assaulted in the last decade*/

	select sum(l.agency_count_leoka_submitting) as last_decade_total_leoka
	from population p
	left join nibrs n
	on p.data_year=n.data_year
	left join leoka l
	on n.total_agency_count = l.total_agency_count;

/* 5. labeling data as decade1 and decade2 using the case statement which creates a new column named "decade"*/

	select *,
	case 
	when p.data_year between 2009 and 2019 then 'decade_1'
	when p.data_year between 1999 and 2009 then 'decade_2'
	end as decade
	from population p
	left join nibrs n
	on p.data_year=n.data_year
	left join leoka l
	on n.total_agency_count = l.total_agency_count
	where p.data_year > 1999;

/* 6. creates a temporary table which stores the data labeled by decade1 and decade2 
(like in the previous query). This gives us a chance to use the result of that query in the same query.
In this case, we're calculating the number of total leoka (law enforcement officers killed and assaulted) cases by decade.*/

	with Decades as (select *,
	case 
	when p.data_year between 2009 and 2019 then 'decade_1'
	when p.data_year between 1999 and 2009 then 'decade_2'
	end as decade
	from population p
	left join nibrs n
	on p.data_year=n.data_year
	left join leoka l
	on n.total_agency_count = l.total_agency_count
	where p.data_year > 1999)

	select decade, sum(agency_count_leoka_submitting) as total_num_leoka
	from Decades
	group by 1
	order by 1;

/* 7. showing all the nibrs population covered after 2000 and 
Natinal Incident Based Reporting System population covered is greater than 100MM*/
	
	select data_year, nibrs_population_covered
	from nibrs
	where data_year > 2000 and nibrs_population_covered > 100000000
	order by 2 desc;

/* 8. showing minumum and maximum Natinal Incident Based Reporting System population covered */
	
	select max(nibrs_population_covered) as maximum_covered_population,
	min(nibrs_population_covered) as minimum_covered_population
	from nibrs;

/* 9. calculating average number of law enforcement officers killed and assaulted cases */
	
	select avg(agency_count_leoka_submitting) as avg_leoka_num
	from leoka;

/* 10. selecting only those rows from leoka table
where the number of law enforcement officers killed and assaulted cases is greated the 
the average number of cases from the previous query*/
	
	select *
	from leoka
	where agency_count_leoka_submitting > (select avg(agency_count_leoka_submitting)
	from leoka);
	