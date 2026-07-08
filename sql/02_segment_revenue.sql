SELECT
    b.segment,
    COUNT(DISTINCT b.branch_id)  AS number_of_branches,
    COUNT(o.order_id)            AS total_orders,
    ROUND(SUM(o.revenue), 2)     AS total_revenue,
    ROUND(AVG(o.revenue), 2)     AS avg_order_value,
    ROUND(SUM(o.revenue) * 100.0 / 
          (SELECT SUM(revenue) FROM orders), 1) AS revenue_share_pct
FROM orders o
JOIN branches b ON o.branch_id = b.branch_id
GROUP BY b.segment
ORDER BY total_revenue DESC;