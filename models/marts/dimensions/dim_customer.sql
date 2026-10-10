with customer as (
    select * from {{ ref('stg_customer') }}
),

address as (
    select * from {{ ref('stg_address') }}
),

city as (
    select * from {{ ref('stg_city') }}
),

country as (
    select * from {{ ref('stg_country') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer.customer_id']) }}
            as customer_sk,
        customer.customer_id,
        customer.store_id as customer_store_id,

        customer.is_active as is_active_customer,
        customer.created_at as customer_created_at,

        address.district as customer_district,
        city.city as customer_city,
        country.country as customer_country,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from customer
    left join address on address.address_id = customer.address_id
    left join city on city.city_id = address.city_id
    left join country on country.country_id = city.country_id
)

select * from final
