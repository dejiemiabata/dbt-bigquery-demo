with source_data as (
    select id as location_id
        , name as location_name
    from {{ source('inventory_transactions_raw', 'location') }}
)
select *
from source_data