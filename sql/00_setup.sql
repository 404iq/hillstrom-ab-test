-- Таблица email_campaign загружается из CSV (Hillstrom Email Marketing).
-- Представление customers добавляет понятные сегменты.
DROP VIEW IF EXISTS customers;

CREATE VIEW customers AS
SELECT
    segment,
    recency,
    history,
    history_segment,
    zip_code,
    channel,
    newbie,
    mens,
    womens,
    CASE WHEN newbie = 1 THEN 'new' ELSE 'existing' END AS newbie_label,
    CASE
        WHEN recency <= 3 THEN '1-3'
        WHEN recency <= 6 THEN '4-6'
        WHEN recency <= 9 THEN '7-9'
        ELSE '10-12'
    END AS recency_bucket,
    CASE
        WHEN mens = 1 AND womens = 0 THEN 'only_mens'
        WHEN mens = 0 AND womens = 1 THEN 'only_womens'
        WHEN mens = 1 AND womens = 1 THEN 'both'
        ELSE 'neither'
    END AS buyer_type,
    visit,
    conversion,
    spend
FROM email_campaign;
