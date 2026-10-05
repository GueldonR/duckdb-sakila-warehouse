-- Store dimension table definition
-- To run directly: .read sql/warehouse/dimensions/dim_staff.sql
-- Grain: per staff member 
create table
    if not exists warehouse.dim_staff as
select
    row_number() over (
        order by
            st.staff_id
    ) as dim_staff_sk,
    st.staff_id,
    st.first_name as staff_first_name,
    st.last_name as staff_last_name,
    st.username as staff_username,
    st.email as staff_email,
    st.active as staff_active,
    st.store_id as staff_store,
    s.manager_staff_id as store_manager_id,
    (st.staff_id = s.manager_staff_id) as is_staff_manager
from
    source.staff st
    left join source.store s on st.store_id = s.store_id;