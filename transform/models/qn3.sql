{{ config(materialized='view') }}
with table1 as (
    select
        country_name,
        vendor_name,
        sum(total_gmv) as total_gmv
    from {{ ref('qn4') }}
    where 
    group by
        country_name,
        vendor_name),
    table2 as(
        select *, 
        RANK() OVER (PARTITION BY country_name ORDER BY country_name ASC, total_gmv DESC) AS ranking
        FROM table1)
select * from table2
WHERE
  ranking = 1
order by country_name