with source_country as (
    select * from {{ source('sakila', 'country') }}
),

cleaned as (
    select
        country_id,

        {{clean_text('country')}} as country,

        last_update as updated_at
    from source_country
)

select * from cleaned
