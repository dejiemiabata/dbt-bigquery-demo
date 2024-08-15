SELECT
    bin_id
    , bin_name
FROM 
    {{ ref('stg_bin') }}
