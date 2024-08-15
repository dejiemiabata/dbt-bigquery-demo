with source_data as (
    select CAST (TIMESTAMP(transaction_date) as DATE) AS transaction_date,
        transaction_id,
        transaction_line_id,
        transaction_type,
        type_based_document_number,
        type_based_document_status,
        item_id,
        bin_id,
        inventory_status_id,
        location_id,
        quantity
    from {{ source('inventory_transactions_raw', 'transaction_line') }}
)
select *
from source_data