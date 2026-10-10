with source_language as (
    select * from {{ source('sakila', 'language') }}
),

cleaned as (
    select
        language_id,

        {{ clean_text('name') }} as name,

        last_update as updated_at
    from source_language
)

select * from cleaned
