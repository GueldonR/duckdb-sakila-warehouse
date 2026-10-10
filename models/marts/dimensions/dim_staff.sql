with staff as (
    select * from {{ ref('stg_staff') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['staff.staff_id']) }} as staff_sk,
        staff.staff_id,
        staff.store_id as staff_store_id,

        staff.is_active as is_active_staff,

        date_trunc('second', current_timestamp at time zone 'UTC')
            as dbt_loaded_at
    from staff
)

select * from final
