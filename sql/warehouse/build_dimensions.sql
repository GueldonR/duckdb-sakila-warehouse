-- Build script for the data warehouse
-- Run from the repo root: duckdb mydb.duckdb -c ".read sql/warehouse/build.sql"

.read sql/warehouse/dimensions/dim_customer.sql
.read sql/warehouse/dimensions/dim_films.sql