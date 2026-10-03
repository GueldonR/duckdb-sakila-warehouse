-- Customer dimension table definition
-- To run directly: .read sql/warehouse/dimensions/dim_customer.sql
Create table
    if not exists warehouse.DimCustomers as
select
    row_number() over (
        order by
            c.customer_id
    ) as dim_customer_sk, -- surrogate key
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.active,
    a.address,
    a.address2,
    a.phone,
    a.postal_code,
    ci.city,
    co.country
from
    source.customer c
    left join source.address a on a.address_id = c.address_id
    left join source.city ci on ci.city_id = a.city_id
    left join source.country co on co.country_id = ci.country_id;