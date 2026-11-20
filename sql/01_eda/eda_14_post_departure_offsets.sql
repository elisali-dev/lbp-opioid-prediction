
-- EDA 14: Post-departure event time offsets
-- Calculate delay after ED departure in minutes

WITH events AS (
    SELECT
        'pyxis' AS table_name,
        stay_id,
        charttime
    FROM `physionet-data.mimiciv_ed.pyxis`

    UNION ALL

    SELECT
        'vitalsign',
        stay_id,
        charttime
    FROM `physionet-data.mimiciv_ed.vitalsign`
),

post_departure AS (
    SELECT
        ev.table_name,
        ev.stay_id,
        TIMESTAMP_DIFF(
            ev.charttime,
            e.outtime,
            SECOND
        ) / 60.0 AS delay_minutes
    FROM events ev
    JOIN `physionet-data.mimiciv_ed.edstays` e
        ON ev.stay_id = e.stay_id
    WHERE e.outtime >= e.intime
      AND ev.charttime > e.outtime
),

delay_categories AS (
    SELECT
        table_name,
        stay_id,
        CASE
            WHEN delay_minutes <= 15 THEN '01: <=15 min'
            WHEN delay_minutes <= 60 THEN '02: 15-60 min'
            WHEN delay_minutes <= 360 THEN '03: 1-6 hours'
            WHEN delay_minutes <= 1440 THEN '04: 6-24 hours'
            ELSE '05: >24 hours'
        END AS delay_category
    FROM post_departure
)

SELECT
    table_name,
    delay_category,
    COUNT(*) AS event_count,
    COUNT(DISTINCT stay_id) AS unique_stays,
    ROUND(
        100.0 * SAFE_DIVIDE(
            COUNT(*),
            SUM(COUNT(*)) OVER (
                PARTITION BY table_name
            )
        ),
        2
    ) AS pct_of_post_departure_events
FROM delay_categories
GROUP BY table_name, delay_category
ORDER BY table_name, delay_category;
