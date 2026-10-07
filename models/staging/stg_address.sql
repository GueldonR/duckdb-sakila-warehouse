with source_address as (
    select * from {{ source('sakila', 'address') }}
),

cleaned as (
    select
        address_id,
        city_id,

        {{clean_text('address')}} as address,
        {{clean_text('address2')}} as address2,
        {{clean_text('district')}} as district,
        postal_code,

        last_update as updated_at
    from source_address
)

select * from cleaned
