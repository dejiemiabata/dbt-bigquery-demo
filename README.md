# Inventory Analysis Case Study

This case study involves analyzing NetSuite transactional data related to inventory using BigQuery and dbt. The goal is to provide insights into inventory levels and answer specific business questions.


## Data Quality Check 

- Duplicate Data: Multiple rows with identical values across all columns, particularly transaction_date and transaction_id. This data likely needs to be deduplicated based on business criteria.
- Negative Quantities: Further investigation is needed to understand the context of negative quantities before deeming them as poor or invalid data. High negative quantities should be examined closely.
- Inconsistent Data: Variations in the type_based_document_number column. Confirmation is required to determine if this inconsistency is expected from a business standpoint.

## Business Questions and Answers

- What is the quantity, and location/bin/status combos of item 355576 on
date 2022-11-21?

Answer can be found in `question1.csv` of the `case study questions and answers directory`

```
select 
  location_name
  , bin_name
  , inventory_status_name
  , SUM(total_quantity) AS total_quantity_per_item
from 
`dbt-bigquery-demo.inventory_transactions.fct_inventory_daily`
where item_id = 355576
and date <= '2022-11-21'
group by location_name,bin_name,inventory_status_name;

```

- What is the total value of item 209372 on Date 2022-06-05?

Answer can be found in `question2.csv` of the `case study questions and answers directory`

```
with item_total_value as (
select 
  item_id
  ,SUM(value) AS total_value
from 
`dbt-bigquery-demo.inventory_transactions.fct_inventory_daily`
where item_id = 209372
and date <= '2022-06-05'
group by item_id
)

select item_id
  , round(total_value, 2) as total_value
from item_total_value;

```

- What is the total value of inventory in Location c7a95e433e878be525d03a08d6ab666b on 2022-01-01?

Answer can be found in `question3.csv` of the `case study questions and answers directory`


```

with location_total_value as (
  
  select 
  location_name
  , SUM(value) AS total_value
from 
`dbt-bigquery-demo.inventory_transactions.fct_inventory_daily`
where location_name = 'c7a95e433e878be525d03a08d6ab666b'
and date <= '2022-01-01'
group by location_name
)

select location_name
, round(total_value,2) as total_value
from location_total_value;

```

- Open Ended Question

Results can be found in `open_ended_question.csv` of the `case study questions and answers directory`

```

SELECT 
    DATE_TRUNC(date, MONTH) AS month,
    SUM(total_quantity) AS total_quantity,
    SUM(value) AS total_value
FROM 
    `dbt-bigquery-demo.inventory_transactions.fct_inventory_daily`
GROUP BY 
  month
ORDER BY 
    month;

```

### Insights Observed

- Seasonal Trends and Peaks:
    
    July 2020: High inventory levels with a total quantity of 66,347 and a high total value of approximately 4.4 million. This could be due to seasonal stocking or increased demand during summer.
    
    January 2021: A significant increase in inventory levels with a total quantity of 204,415, indicating post-holiday restocking or preparation for new year demands.

- The data shows significant fluctuations in inventory and value across several months. June 2021 had a major adjustment with -264,642 in quantity and -4.5 million in value, likely due to a large return, recall, or inventory correction.

- December 2021 had a negative total value of -1 million despite a low positive quantity, potentially indicating end-of-year loss adjustments.

Given more time, the analysis would dive deeper into:

- The specific items and their type_based_document_status types leading to these fluctuations.
- Detailed investigation of the periods with negative inventory values to understand the underlying causes
- Comparison of different locations to see if certain locations are more prone to adjustments or some sort of higher demand during specific times.



### Helpful Links

- https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup#oauth-via-gcloud
- https://medium.com/towards-data-engineering/dbt-and-bigquery-a-powerful-duo-for-modern-data-engineering-5f4ba97fd0c9
- https://www.anchorgroup.tech/netsuite-inventory-management#inventory_losses_how_to_avoid_it
- https://www.netsuite.com/portal/resource/articles/inventory-management/inventory-management.shtml
