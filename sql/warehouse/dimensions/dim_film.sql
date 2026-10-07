-- Film dimension definition
-- To run directly: .read sql/warehouse/dimensions/dim_films.sql
Create table
    if not exists warehouse.dim_film as
select
    row_number() over (
        order by
            f.film_id
    ) as dim_film_sk,
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features,
    l.name as current_language,
    ol.name as original_language,
    c.name as film_category_name
from
    source.film f
    -- left join source.film_text ft on ft.film_id = f.film_id
    left join source.language l on l.language_id = f.language_id
    left join source.language ol on ol.language_id = f.original_language_id
    left join source.film_category fc on fc.film_id = f.film_id
    -- In source: category 1-1 with film
    left join source.category c on fc.category_id = c.category_id;


-- Actor m:n film lookup table defintion from source into warehouse
Create table
    if not exists warehouse.bridge_film_actor as
select
    actor_id,
    film_id
from
    source.film_actor;