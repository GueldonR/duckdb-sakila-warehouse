-- Q2: How does revenue develop month by month?
select
    t.first_day_of_month,
    t.month_name,
    count(*) as payments,
    sum(p.amount) as revenue
from {{ ref('fact_payment_transaction') }} p
inner join {{ ref('dim_time') }} t on p.payment_date_sk = t.date_sk
group by t.first_day_of_month, t.month_name
order by t.first_day_of_month
