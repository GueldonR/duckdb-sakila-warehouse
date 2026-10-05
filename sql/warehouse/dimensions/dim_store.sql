-- Store dimension table definition
-- To run directly: .read sql/warehouse/dimensions/dim_store.sql
-- Grain: per store 
create table
    if not exists warehouse.dim_store as
select
    row_number() over (
        order by
            s.store_id
    ) as dim_store_sk,
    s.store_id,
    s.manager_staff_id as store_manager_id,
    st.first_name as store_manager_fn,
    st.last_name as store_manager_ln,
    a.address as store_address,
    a.address2 as store_previous_address,
    a.district as store_district,
    ci.city as store_city,
    co.country as store_country
from
    source.store s
    left join source.staff st on st.staff_id = s.manager_staff_id
    left join source.address a on a.address_id = s.address_id
    left join source.city ci on ci.city_id = a.city_id
    left join source.country co on co.country_id = ci.country_id;