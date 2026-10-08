with customer as (
    select * from {{ ref('stg_customer') }}
),

country as (
    select * from {{ ref('stg_country') }}

),

city as (

    select * from {{ ref('stg_city') }}
),

address as (
    select * from {{ ref('stg_address') }}
),

joined as (
    select
        {{dbt_utils.generate_surrogate_key(['customer.customer_id'])}}
            as customer_sk,
        customer.customer_id,
        customer.store_id,

        customer.first_name as customer_first_name,
        customer.last_name as customer_last_name,
        customer.is_active as is_active_customer,

        address.address as customer_address,
        address.address2 as customer_address2,
        address.postal_code as customer_postal_code,
        address.district as customer_district,

        city.city as customer_city,

        country.country as customer_country,
        customer.created_at as customer_created_at,
        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from
        customer

    left join address on address.address_id = customer.address_id
    left join city on city.city_id = address.city_id
    left join country on country.country_id = city.country_id
)

select * from joined
