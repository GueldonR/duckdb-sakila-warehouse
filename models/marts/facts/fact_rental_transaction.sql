with rental as (
    select * from {{ ref('stg_rental') }}
),

inventory as (
    select * from {{ ref('stg_inventory') }}
),

dim_customer as (
    select customer_sk, customer_id from {{ ref('dim_customer') }}
),

dim_film as (
    select film_sk, film_id from {{ ref('dim_film') }}
),

dim_store as (
    select store_sk, store_id from {{ ref('dim_store') }}
),

dim_staff as (
    select staff_sk, staff_id from {{ ref('dim_staff') }}
),

final as (
    select
        dim_customer.customer_sk,
        dim_film.film_sk,
        dim_store.store_sk,
        dim_staff.staff_sk,

        rental.rental_id,
        
        cast(strftime(rental.rental_date, '%Y%m%d') as integer) as rental_date_sk,
        cast(strftime(rental.return_date, '%Y%m%d') as integer) as return_date_sk,

     
        date_diff('day', rental.rental_date, rental.return_date) as rental_days,
        current_timestamp as dbt_loaded_at
        
    from 
        rental
    left join inventory   on rental.inventory_id = inventory.inventory_id
    left join dim_customer on rental.customer_id = dim_customer.customer_id
    left join dim_film     on inventory.film_id  = dim_film.film_id
    left join dim_store    on inventory.store_id = dim_store.store_id
    left join dim_staff    on rental.staff_id    = dim_staff.staff_id
)

select * from final