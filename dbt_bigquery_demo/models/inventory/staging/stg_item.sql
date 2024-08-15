with source_data as (
    select id as item_id
        , name as item_name
    from {{ source('inventory_transactions_raw', 'item') }}
)
select *
from source_data