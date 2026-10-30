-- Эффект каждого письма относительно контроля в каждом сегменте
WITH long AS (
    SELECT 'newbie_label' AS dimension, newbie_label AS value, segment, visit, conversion, spend FROM customers
    UNION ALL
    SELECT 'channel', channel, segment, visit, conversion, spend FROM customers
    UNION ALL
    SELECT 'zip_code', zip_code, segment, visit, conversion, spend FROM customers
    UNION ALL
    SELECT 'history_segment', history_segment, segment, visit, conversion, spend FROM customers
    UNION ALL
    SELECT 'recency_bucket', recency_bucket, segment, visit, conversion, spend FROM customers
    UNION ALL
    SELECT 'buyer_type', buyer_type, segment, visit, conversion, spend FROM customers
),
agg AS (
    SELECT
        dimension, value, segment,
        COUNT(*) AS n,
        AVG(visit) AS visit_rate,
        AVG(conversion) AS conv_rate,
        AVG(spend) AS spend_avg
    FROM long
    GROUP BY dimension, value, segment
)
SELECT
    t.dimension,
    t.value,
    t.segment AS email,
    t.n AS n_email,
    c.n AS n_control,
    ROUND(100.0 * c.visit_rate, 2) AS control_visit_pct,
    ROUND(100.0 * t.visit_rate, 2) AS email_visit_pct,
    ROUND(100.0 * (t.visit_rate - c.visit_rate), 2) AS visit_lift_pp,
    ROUND(100.0 * (t.conv_rate - c.conv_rate), 3) AS conversion_lift_pp,
    ROUND(t.spend_avg - c.spend_avg, 3) AS spend_lift
FROM agg t
JOIN agg c
    ON c.dimension = t.dimension AND c.value = t.value AND c.segment = 'No E-Mail'
WHERE t.segment <> 'No E-Mail'
ORDER BY t.dimension, t.value, t.segment;
