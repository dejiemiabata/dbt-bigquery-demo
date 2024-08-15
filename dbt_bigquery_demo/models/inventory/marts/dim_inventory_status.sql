SELECT inventory_status_id
    , inventory_status_name
FROM {{ ref('stg_inventory_status') }}