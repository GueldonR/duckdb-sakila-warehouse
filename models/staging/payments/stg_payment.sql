with source_payment as (
    select * from {{ source('sakila', 'payment') }}
),

cleaned as (
    select
        payment_id,
        customer_id,
        staff_id,
        rental_id,

        amount,

        payment_date,
        
        last_update as updated_at
    from source_payment
)

select * from cleaned
