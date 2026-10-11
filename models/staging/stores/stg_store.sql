with source_store as (
    select * from {{ source('sakila', 'store') }}
),

cleaned as (
    select
        store_id,
        address_id,

        last_update as updated_at
    from source_store
)

select * from cleaned
