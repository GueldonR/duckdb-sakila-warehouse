-- Film dimension definition
-- To run directly: .read sql/warehouse/dimensions/dim_films.sql
Create table
    if not exists warehouse.dim_films as
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
    f.special_features
    -- lägg till kolumner från de andra tabellerna
from
    source.film f
    left join source.film_text ft on ft.film_id = f.film_id
    left join source.language l on l.language_id = f.language_id;


-- handle actor and film_actor down here