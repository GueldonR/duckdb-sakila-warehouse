with source_category as (
    select * from {{ source('sakila', 'category') }}
),

cleaned as (

    select
        category_id,
        {{clean_text('name')}} as name,
        last_update as updated_at

    from source_category

)

select * from cleaned
