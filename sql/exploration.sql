ATTACH 'data/sakila.duckdb' AS source;


-- Shows that one movie can have several actors, therefore the actor table will be handled as its own dimension
select f.film_id, 
count(distinct(a.first_name)) as actors 
from source.film f 
left join source.film_actor fa on fa.film_id = f.film_id 
left join source.actor a on a.actor_id = fa.actor_id 
group by f.film_id;


-- Returns zero rows
-- This means that there i one film per category
-- Which is not explicitly enforced in the schema, but as its in the source data that is being followed
-- category can therefore be flattened into film dimension later

select
film_id,
count(*) as category_count
from source.film_category
group by film_id
having count(*) > 1;