with source_customer as (
    select * from {{ source('sakila', 'customer') }}
),

cleaned as (
    select
        customer_id,
        store_id,
        address_id,

        {{clean_text('first_name')}} as first_name,
        {{clean_text('last_name')}} as last_name,
        cast(active as boolean) as is_active,

        create_date as created_at,
        last_update as updated_at
    from source_customer
)

select * from cleaned
