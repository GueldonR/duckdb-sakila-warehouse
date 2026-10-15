with generate_date as (
    select cast(range as date) as full_date
    -- Whole calendar years that cover all Sakila activity (rentals and payments
    -- 2005-05-24 to 2006-02-14). Fixed so the table is the same on every build.
    -- The stop date is exclusive, so this ends on 2006-12-31.
    from range(date '2005-01-01', date '2007-01-01', interval 1 day)
),

calendar as (
    select
        cast(strftime(full_date, '%Y%m%d') as integer) as date_sk,
        full_date,

        cast(year(full_date) as integer) as calendar_year,
        quarter(full_date) as quarter_of_year,
        month(full_date) as month_of_year,
        monthname(full_date) as month_name,
        cast(date_trunc('month', full_date) as date) as first_day_of_month,
        weekofyear(full_date) as week_of_year,
        day(full_date) as day_of_month,
        isodow(full_date) as iso_day_of_week,
        dayname(full_date) as day_name,
        case when isodow(full_date) in (6, 7) then true else false end
            as is_weekend
    from generate_date
),

-- Default row: 
no_date as (
    select
        -1 as date_sk,

        date '9999-12-31' as full_date,

        null as calendar_year,
        null as quarter_of_year,
        null as month_of_year,
        'No date' as month_name,
        null as first_day_of_month,
        null as week_of_year,
        null as day_of_month,
        null as iso_day_of_week,
        'No date' as day_name,
        null as is_weekend
),

final as (
    select * from calendar
    union all
    select * from no_date
)

select * from final
