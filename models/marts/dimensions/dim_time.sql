with generate_date as (
    select cast(range as date) as full_date
    -- Whole calendar years that cover all Sakila activity (rentals and payments
    -- 2005-05-24 to 2006-02-14). Fixed so the table is the same on every build.
    -- The stop date is exclusive, so this ends on 2006-12-31.
    from range(date '2005-01-01', date '2007-01-01', interval 1 day)
),

final as (
    select
        cast(strftime(full_date, '%Y%m%d') as integer) as date_sk,
        full_date,

        cast(year(full_date) as integer) as year_key,
        quarter(full_date) as quarter_of_year,
        month(full_date) as month_of_year,
        cast(strftime(full_date, '%Y%m') as integer) as month_key,
        monthname(full_date) as month_name,
        cast(date_trunc('month', full_date) as date) as first_day_of_month,
        weekofyear(full_date) as week_of_year,
        day(full_date) as day_of_month,
        isodow(full_date) as iso_day_of_week,
        dayname(full_date) as day_name,
        case when isodow(full_date) in (6, 7) then true else false end
            as is_weekend
    from generate_date
)

select * from final
