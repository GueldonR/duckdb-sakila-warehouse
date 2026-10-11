-- Q5: What share of returned rentals were kept longer than the film allows?
-- rental_days counts whole days between rental and return, so this is approximate.
-- Rentals not yet returned have no return date and are left out.
select
    s.store_country,
    s.store_city,
    count(r.return_date_sk) as returned_rentals,
    sum(case when r.rental_days > f.film_rental_duration then 1 else 0 end)
        as late_returns,
    round(
        100.0
        * sum(
            case when r.rental_days > f.film_rental_duration then 1 else 0 end
        )
        / count(*),
        1
    ) as late_pct
from {{ ref('fact_rental_transaction') }} r
inner join {{ ref('dim_film') }} f on r.film_sk = f.film_sk
inner join {{ ref('dim_store') }} s on r.store_sk = s.store_sk
where r.return_date_sk is not null
group by s.store_country, s.store_city
order by late_pct desc
