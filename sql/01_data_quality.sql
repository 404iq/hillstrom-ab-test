-- Проверка качества данных: каждое значение, кроме rows_total, должно быть 0
SELECT
    COUNT(*) AS rows_total,
    SUM(CASE WHEN recency IS NULL OR history IS NULL OR segment IS NULL THEN 1 ELSE 0 END) AS rows_with_nulls,
    SUM(CASE WHEN conversion = 1 AND visit = 0 THEN 1 ELSE 0 END) AS purchase_without_visit,
    SUM(CASE WHEN spend > 0 AND conversion = 0 THEN 1 ELSE 0 END) AS spend_without_purchase,
    SUM(CASE WHEN spend < 0 THEN 1 ELSE 0 END) AS negative_spend,
    SUM(CASE WHEN mens = 0 AND womens = 0 THEN 1 ELSE 0 END) AS neither_mens_nor_womens
FROM customers;
