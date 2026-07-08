SELECT
    CASE CAST(strftime('%m', order_date) AS INTEGER)
        WHEN 1  THEN '01-Jan' WHEN 2  THEN '02-Feb'
        WHEN 3  THEN '03-Mar' WHEN 4  THEN '04-Apr'
        WHEN 5  THEN '05-May' WHEN 6  THEN '06-Jun'
        WHEN 7  THEN '07-Jul' WHEN 8  THEN '08-Aug'
        WHEN 9  THEN '09-Sep' WHEN 10 THEN '10-Oct'
        WHEN 11 THEN '11-Nov' WHEN 12 THEN '12-Dec'
    END                                      AS month,
    COUNT(o.order_id)                        AS total_orders,
    ROUND(SUM(o.revenue), 2)                 AS total_revenue,
    ROUND(SUM(CASE WHEN p.category = 'Batteries'
              THEN o.revenue ELSE 0 END), 2) AS battery_revenue,
    ROUND(SUM(CASE WHEN p.category = 'Filters'
              THEN o.revenue ELSE 0 END), 2) AS filter_revenue,
    ROUND(SUM(CASE WHEN p.category = 'Suspension'
              THEN o.revenue ELSE 0 END), 2) AS suspension_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY strftime('%m', order_date)
ORDER BY strftime('%m', order_date);