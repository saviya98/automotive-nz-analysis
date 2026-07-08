SELECT 
    b.branch_name,
    b.brand,
    b.region,
    b.segment,
    COUNT(o.order_id)          AS total_orders,
    ROUND(SUM(o.revenue), 2)   AS total_revenue,
    ROUND(AVG(o.revenue), 2)   AS avg_order_value
FROM orders o
JOIN branches b ON o.branch_id = b.branch_id
GROUP BY b.branch_id, b.branch_name, b.brand, b.region, b.segment
ORDER BY total_revenue DESC;