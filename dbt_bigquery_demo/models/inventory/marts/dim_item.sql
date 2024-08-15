SELECT
    item_id
    , item_name
FROM 
    {{ ref('stg_item') }}
