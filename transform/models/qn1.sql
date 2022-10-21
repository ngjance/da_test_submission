{{ config(materialized='view') }}
with orders as (
    SELECT * FROM `orders.orders`)
SELECT
  country_name,
  ROUND(SUM(gmv_local),2) AS total_gmv
FROM
  orders
GROUP BY
  country_name