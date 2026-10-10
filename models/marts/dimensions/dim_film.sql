with film as (
    select * from {{ ref('stg_film') }}
),

film_category as (
    select * from {{ ref('stg_film_category') }}
),

category as (
    select * from {{ ref('stg_category') }}
),

language as (
    select * from {{ ref('stg_language') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['film.film_id']) }} as film_sk,
        film.film_id as film_id,
        film.title as film_title,
        film.release_year as film_release_year,
        film.rental_duration as film_rental_duration,
        film.rental_rate as film_rental_rate,
        film.length as film_length_minutes,
        film.rating as film_age_rating,
        film.replacement_cost as film_replacement_cost,

        language.name as film_language,

        category.name as film_category,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from
        film

    left join language on language.language_id = film.language_id
    left join film_category on film_category.film_id = film.film_id
    left join category on category.category_id = film_category.category_id
)

select * from final
