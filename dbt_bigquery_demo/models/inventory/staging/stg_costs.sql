with source_data as (
    select date as effective_date
        , COALESCE(LEAD(date) OVER (PARTITION BY item_id, location_id ORDER BY date), '2900-12-31' ) AS end_effective_date
        , location_id
        , item_id
        , cost

    from {{ source('inventory_transactions_raw', 'costs') }}
)
select effective_date
, end_effective_date
, location_id
, item_id
, cost
from source_data