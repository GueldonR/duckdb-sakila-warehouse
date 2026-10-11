.PHONY: setup build test docs compile analysis

# set up deps
setup:
	uv sync
	uv run dbt deps

# build all models
build:
	uv run dbt build

# run all the tests
test:
	uv run dbt test

# generate and open the docs site with lineage graph
docs:
	uv run dbt docs generate
	uv run dbt docs serve

# compile models and analyses to SQL in target/compiled
compile:
	uv run dbt compile

# run one analysis. Example: make analysis name=revenue_by_store
analysis:
	uv run dbt show --select $(name) --limit 50
