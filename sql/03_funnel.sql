-- Воронка по группам: получили письмо -> зашли на сайт -> купили
SELECT
    segment AS grp,
    COUNT(*) AS sent,
    SUM(visit) AS visited,
    SUM(conversion) AS purchased,
    ROUND(100.0 * SUM(visit) / COUNT(*), 2) AS sent_to_visit_pct,
    ROUND(100.0 * SUM(conversion) / NULLIF(SUM(visit), 0), 2) AS visit_to_purchase_pct,
    ROUND(100.0 * SUM(conversion) / COUNT(*), 3) AS sent_to_purchase_pct
FROM customers
GROUP BY segment
ORDER BY CASE segment WHEN 'No E-Mail' THEN 0 WHEN 'Mens E-Mail' THEN 1 ELSE 2 END;
