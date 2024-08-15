with source_data as (
    select id as inventory_status_id
        , name as inventory_status_name
    from {{ source('inventory_transactions_raw', 'inventory_status') }}
)
select *
from source_data