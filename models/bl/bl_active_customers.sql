/*
An active customer is defined as one that has made at least one purchase in the last 2 weeks.
This model calculates the development of active customers over time
*/

WITH order_times AS (
    SELECT 
        customer_id,
        ordered_at AS active_from,
        ordered_at + INTERVAL '14 DAY' AS active_until

    FROM {{ref('ol_orders')}}
),

overlap_gaps AS (
    SELECT 
        customer_id,
        active_from,
        active_until,
        CASE 
            WHEN active_from > LAG(active_until) OVER (PARTITION BY customer_id ORDER BY active_from) THEN 1 
            ELSE 0 
        END AS gap_start
    FROM order_times
),

calculate_groups AS (
    SELECT 
        customer_id,
        active_from,
        active_until,
        SUM(gap_start) OVER (PARTITION BY customer_id ORDER BY active_from) AS group_id
    FROM overlap_gaps 
)

SELECT 
    customer_id,
    group_id AS activity_period,
    MIN(active_from) AS valid_from,
    MAX(active_until) AS valid_to,
    
    COUNT(*) AS num_orders

FROM calculate_groups 
GROUP BY 1,2
       




