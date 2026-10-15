with payment as (
    select * from {{ ref('stg_payment') }}
),

rental as (
    select
        rental_id,
        inventory_id
    from {{ ref('stg_rental') }}
),

inventory as (
    select
        inventory_id,
        film_id,
        store_id
    from {{ ref('stg_inventory') }}
),

dim_customer as (
    select
        customer_sk,
        customer_id
    from {{ ref('dim_customer') }}
),

dim_staff as (
    select
        staff_sk,
        staff_id
    from {{ ref('dim_staff') }}
),

dim_film as (
    select
        film_sk,
        film_id
    from {{ ref('dim_film') }}
),

dim_store as (
    select
        store_sk,
        store_id
    from {{ ref('dim_store') }}
),

final as (
    select
        dim_customer.customer_sk,
        dim_staff.staff_sk,
        -- '-1' is the default row for payments without a rental.
        coalesce(dim_film.film_sk, '-1') as film_sk,
        coalesce(dim_store.store_sk, '-1') as store_sk,
        cast(strftime(payment.payment_date, '%Y%m%d') as integer)
            as payment_date_sk,
        payment.payment_id,
        payment.rental_id,
        payment.amount,
        current_timestamp as dbt_loaded_at
    from payment
    left join rental on payment.rental_id = rental.rental_id
    left join inventory on rental.inventory_id = inventory.inventory_id
    left join dim_customer on payment.customer_id = dim_customer.customer_id
    left join dim_staff on payment.staff_id = dim_staff.staff_id
    left join dim_film on inventory.film_id = dim_film.film_id
    left join dim_store on inventory.store_id = dim_store.store_id
)
select * from final