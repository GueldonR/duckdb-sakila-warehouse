ATTACH 'data/sakila.duckdb' AS source;

select * from source.actor limit 10;