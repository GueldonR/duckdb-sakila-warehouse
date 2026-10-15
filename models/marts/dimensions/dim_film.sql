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

films as (
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
),

-- Default row:
unknown_film as (
    select
        '-1' as film_sk,
        -1 as film_id,
        'Unknown' as film_title,
        null as film_release_year,
        null as film_rental_duration,
        null as film_rental_rate,
        null as film_length_minutes,
        null as film_age_rating,
        null as film_replacement_cost,

        'Unknown' as film_language,

        'Unknown' as film_category,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
),

final as (
    select * from films
    union all
    select * from unknown_film
)

select * from final
