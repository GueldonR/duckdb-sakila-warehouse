with source_staff as (
    select * from {{ source('sakila', 'staff') }}
),

cleaned as (
    select
        staff_id,
        store_id,

        {{ clean_text('first_name') }} as first_name,
        {{ clean_text('last_name') }} as last_name,
        {{ clean_text('username') }} as username,

        cast(active as boolean) as is_active,

        last_update as updated_at
    from source_staff
)

select * from cleaned
