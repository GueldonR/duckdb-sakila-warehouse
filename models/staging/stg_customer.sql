with source_customer as (
    select * from {{ source('sakila', 'customer') }}
),

cleaned as (
    select
        customer_id,
        store_id,
        address_id,

        cast(active as boolean) as is_active,

        create_date as created_at,
        last_update as updated_at
    from source_customer
)

select * from cleaned
