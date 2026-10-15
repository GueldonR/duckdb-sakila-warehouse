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

stores as (
    select
        {{ dbt_utils.generate_surrogate_key(['store.store_id']) }} as store_sk,
        store.store_id,

        address.address as store_address,
        address.district as store_district,
        city.city as store_city,
        country.country as store_country,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from store
    left join address on address.address_id = store.address_id
    left join city on city.city_id = address.city_id
    left join country on country.country_id = city.country_id
),

-- Default row:
unknown_store as (
    select
        '-1' as store_sk,
        -1 as store_id,

        null as store_address,
        null as store_district,
        'Unknown' as store_city,
        'Unknown' as store_country,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
),

final as (
    select * from stores
    union all
    select * from unknown_store
)

select * from final
