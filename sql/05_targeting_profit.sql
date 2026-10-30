-- Вклад в прибыль на 1000 клиентов базы от женского письма
-- Параметры: {{ cost }} – стоимость одного письма, $; {{ margin }} – маржа с продаж (1 = 100% выручки)
-- spend в данных это выручка, поэтому вклад = margin * дополнительные траты - cost
-- Сумма строк = слать всем; строка bought_womens = 1 = правило "слать только покупавшим женское".
WITH base AS (
    SELECT
        womens AS bought_womens,
        COUNT(*) AS n,
        AVG(CASE WHEN segment = 'Womens E-Mail' THEN spend END) AS spend_email,
        AVG(CASE WHEN segment = 'No E-Mail' THEN spend END) AS spend_control
    FROM customers
    WHERE segment IN ('Womens E-Mail', 'No E-Mail')
    GROUP BY womens
)
SELECT
    bought_womens,
    n AS customers,
    ROUND(100.0 * n / (SELECT SUM(n) FROM base), 1) AS share_of_base_pct,
    ROUND(spend_email - spend_control, 3) AS spend_lift,
    ROUND(1000.0 * n / (SELECT SUM(n) FROM base)
          * ({{ margin }} * (spend_email - spend_control) - {{ cost }}), 1) AS profit_per_1000_if_sent
FROM base
ORDER BY bought_womens;
