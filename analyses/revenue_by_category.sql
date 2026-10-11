-- Q4: Which film categories drive revenue, and what share of the total?
select
    f.film_category,
    sum(p.amount) as revenue,
    round(
        100.0 * sum(p.amount) / sum(sum(p.amount)) over (), 
        1
    ) as share_pct
from {{ ref('fact_payment_transaction') }} p
inner join {{ ref('dim_film') }} f on p.film_sk = f.film_sk
group by f.film_category
order by revenue desc
