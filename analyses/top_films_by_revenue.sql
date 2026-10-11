-- Q3: Which films earn the most?
-- Payments without a rental have no film and are left out (5 payments).
select
    f.film_title,
    f.film_category,
    f.film_rental_rate,
    count(*) as payments,
    sum(p.amount) as revenue
from {{ ref('fact_payment_transaction') }} p
inner join {{ ref('dim_film') }} f on p.film_sk = f.film_sk
group by f.film_title, f.film_category, f.film_rental_rate
order by revenue desc
limit 10
