with source_inventory as (
    select * from {{ source('sakila', 'inventory') }}
),

cleaned as (
    select
        inventory_id,
        film_id,
        store_id,
        last_update as updated_at
    from
        source_inventory
)

select * from cleaned
