with film_category as (
    select * from {{ source('sakila', 'film_category') }}
)

select 

    film_id, 
    category_id, 
    last_update as updated_at

 from film_category