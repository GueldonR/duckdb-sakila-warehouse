with store as (
    select * from {{ ref('stg_store') }}
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
        {{ dbt_utils.generate_surrogate_key(['store.store_id']) }} as store_sk,
        store.store_id,

        address.address as store_address,
        address.postal_code as store_postal_code,
        address.district as store_district,
        city.city as store_city,
        country.country as store_country,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from store
    left join address on address.address_id = store.address_id
    left join city on city.city_id = address.city_id
    left join country on country.country_id = city.country_id
)

select * from final
