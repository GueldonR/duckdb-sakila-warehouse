with source_city as (
    select * from {{ source('sakila', 'city') }}
),

cleaned as (
    select
        city_id,
        country_id,

        {{clean_text('city')}} as city,

        last_update as updated_at
    from source_city
)

select * from cleaned
