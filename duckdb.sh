#!/bin/sh
cd "$(dirname "$0")"
exec duckdb -cmd "ATTACH 'data/sakila.duckdb' AS source; ATTACH 'data/warehouse.duckdb' AS warehouse;"