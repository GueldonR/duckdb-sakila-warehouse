-- Q6 (advanced): How concentrated is revenue across customers?
-- Rank customers by lifetime spend, split them into four equal groups (quartiles)
-- and compare each group's size, revenue share and rental behaviour.
-- Both facts are aggregated to customer level first, so joining them cannot fan out.
with spend as (
    select
        customer_sk,
        sum(amount) as lifetime_spend
    from {{ ref('fact_payment_transaction') }}
    group by customer_sk
),

activity as (
    select
        customer_sk,
        count(*) as rentals,
        avg(rental_days) as avg_rental_days
    from {{ ref('fact_rental_transaction') }}
    group by customer_sk
),

ranked as (
    select
        spend.customer_sk,
        spend.lifetime_spend,
        activity.rentals,
        activity.avg_rental_days,
        ntile(4) over (
            order by spend.lifetime_spend 
            desc) as spend_quartile
    from spend
    inner join activity on spend.customer_sk = activity.customer_sk
)

select
    spend_quartile,
    count(*) as customers,
    round(sum(lifetime_spend), 2) as revenue,
    round(100.0 * sum(lifetime_spend) / sum(sum(lifetime_spend)) over (), 1)
        as revenue_share_pct,
    round(avg(lifetime_spend), 2) as avg_spend,
    round(avg(rentals), 1) as avg_rentals,
    round(avg(avg_rental_days), 1) as avg_rental_days
from ranked
group by spend_quartile
order by spend_quartile
