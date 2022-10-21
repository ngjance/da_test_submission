{{ config(materialized='view') }}
WITH
  table1 AS (
  SELECT
    TIMESTAMP(date_local) year,
    o.country_name,
    vendor_name,
    ROUND(SUM(gmv_local), 2) AS total_gmv
  FROM
    `orders.orders`o
  INNER JOIN
    `vendors.vendors` v
  ON
    o.vendor_id = v.id
  GROUP BY
    year,
    o.country_name,
    vendor_name),
  table2 AS(
  SELECT
    *,
    RANK() OVER (PARTITION BY year, country_name ORDER BY year ASC, country_name ASC, total_gmv DESC) AS ranking
  FROM
    table1)
SELECT
  year,
  country_name,
  vendor_name,
  total_gmv
FROM
  table2
WHERE
  ranking IN (1, 2)
  order by year, country_name, total_gmv DESC