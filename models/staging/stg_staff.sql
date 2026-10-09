with source_staff as (
    select * from {{ source('sakila', 'staff') }}
),

cleaned as (
    select
        staff_id,
        store_id,

        cast(active as boolean) as is_active,

        last_update as updated_at
    from source_staff
)

select * from cleaned
