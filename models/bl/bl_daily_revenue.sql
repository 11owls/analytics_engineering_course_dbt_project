WITH 
    location AS
    (
    SELECT
        store_id,
        location
    FROM {{ ref('ol_stores') }}
    )
,

orders AS
(
SELECT 
location_id,
TO_DATE(ordered_at) AS order_date,
order_total
FROM {{ ref('ol_orders') }}
)

SELECT
    order_date,
    location,
    ROUND(SUM(order_total),2) AS daily_order_value
FROM orders o
LEFT join location l 
ON
    o.location_id = l.store_id
GROUP BY 
    order_date, location