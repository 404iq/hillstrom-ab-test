-- Итоги теста по группам: размер, визиты, конверсия, траты
SELECT
    segment AS grp,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(visit), 2) AS visit_rate_pct,
    ROUND(100.0 * AVG(conversion), 3) AS conversion_rate_pct,
    ROUND(AVG(spend), 3) AS spend_per_customer,
    ROUND(SUM(spend) * 1.0 / NULLIF(SUM(conversion), 0), 2) AS avg_order_value
FROM customers
GROUP BY segment
ORDER BY CASE segment WHEN 'No E-Mail' THEN 0 WHEN 'Mens E-Mail' THEN 1 ELSE 2 END;
