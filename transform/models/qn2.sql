{{ config(materialized='view') }}
with vendors as (
    select * from `vendors.vendors` 
), orders_vendors as (
    select * from `orders.orders` o
    inner join
        vendors v
    on o.vendor_id = v.id
    WHERE
        o.country_name = 'Taiwan'
)

SELECT
  vendor_name,
  COUNT(DISTINCT customer_id) AS customer_count,
  ROUND(SUM(gmv_local),2) AS total_gmv
FROM
  orders_vendors

GROUP BY
  vendor_name
ORDER BY
  customer_count DESC