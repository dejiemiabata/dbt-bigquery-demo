with source_data as (
    select id as bin_id
        , name as bin_name
    from {{ source('inventory_transactions_raw', 'bin') }}
)
select *
from source_data