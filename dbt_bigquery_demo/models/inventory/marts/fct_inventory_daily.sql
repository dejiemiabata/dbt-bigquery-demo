WITH parsed_transaction_line AS (
    SELECT 
       transaction_date
        , item_id
        , bin_id
        , inventory_status_id
        , location_id
        , SUM(quantity) AS total_quantity
    FROM 
        {{ ref('stg_transaction_line') }}
    GROUP BY 
        transaction_date, item_id, bin_id, inventory_status_id, location_id
)

SELECT 

{{ dbt_utils.generate_surrogate_key(['par_txn_line.item_id','location.location_name', 'par_txn_line.bin_id', 'par_txn_line.inventory_status_id', 'par_txn_line.transaction_date']) }} as id
, par_txn_line.item_id
, par_txn_line.transaction_date as date
, location.location_name
, bin.bin_name
, inv_status.inventory_status_name as inventory_status_name
, par_txn_line.total_quantity
, (par_txn_line.total_quantity * costs.cost) as value

FROM parsed_transaction_line as par_txn_line
LEFT JOIN {{ ref('dim_location') }} location ON par_txn_line.location_id = location.location_id
LEFT JOIN {{ ref('dim_bin') }} bin ON par_txn_line.bin_id = bin.bin_id
LEFT JOIN {{ ref('dim_inventory_status') }} inv_status ON par_txn_line.inventory_status_id = inv_status.inventory_status_id
LEFT JOIN {{ ref('stg_costs') }} costs
    ON par_txn_line.item_id = costs.item_id
    AND par_txn_line.location_id = costs.location_id
    AND par_txn_line.transaction_date >= costs.effective_date
    AND par_txn_line.transaction_date < costs.end_effective_date