with source_rental as (
    select * from {{ source('sakila', 'rental') }}
),

cleaned as (

    select 
        rental_id, 
        inventory_id, 
        customer_id,
        rental_date, 
        return_date, 
        staff_id, 
        last_update as updated_at 

    from 

    source_rental 
)

select * from cleaned 