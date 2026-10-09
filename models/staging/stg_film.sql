with source_film as (
    select * from {{ source('sakila', 'film') }}
),

cleaned as (
    select
        film_id,
        {{clean_text('title')}} as title,
        release_year,
        language_id,
        rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        last_update as updated_at
    from source_film

)

select * from cleaned
