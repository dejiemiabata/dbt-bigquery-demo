-- models/dim/dim_location.sql
SELECT
    location_id
    , location_name
FROM 
    {{ ref('stg_location') }}
