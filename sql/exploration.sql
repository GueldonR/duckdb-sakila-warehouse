ATTACH 'data/sakila.duckdb' AS source;


-- Shows that one movie can have several actors, therefore the actor table will be handled as its own dimension
-- Since i want to be able to slice on singular actors primarily
select
    f.film_id,
    count(distinct (a.first_name)) as actors
from
    source.film f
    left join source.film_actor fa on fa.film_id = f.film_id
    left join source.actor a on a.actor_id = fa.actor_id
group by
    f.film_id;


-- Returns zero rows
-- This means that there i one film per category
-- Which is not explicitly enforced in the schema, but as its in the source data that is being followed
-- category can therefore be flattened into film dimension later
select
    film_id,
    count(category_id) as category_count
from
    source.film_category
group by
    film_id
having
    category_count > 1;


-- Check whether films can have multiple inventory copies per store
-- Answer: the data shows that its true 1 film != 1 inventory record
select
    f.title,
    s.store_id,
    count(i.inventory_id) as inventory_count
from
    source.film f
    left join source.inventory i on f.film_id = i.film_id
    left join source.store s on s.store_id = i.store_id
    -- where
    --     f.title = 'AIRPLANE SIERRA'
group by
    f.film_id,
    f.title,
    s.store_id
limit
    10;