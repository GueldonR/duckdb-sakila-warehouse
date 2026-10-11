-- Q1: How much revenue does each store bring in, and where is it?
-- Payments without a rental have no store and are left out (5 payments).
select
    s.store_country,
    s.store_city,
    count(*) as payments,
    sum(p.amount) as revenue
from {{ ref('fact_payment_transaction') }} p
inner join {{ ref('dim_store') }} s on p.store_sk = s.store_sk
group by s.store_country, s.store_city
order by revenue desc
