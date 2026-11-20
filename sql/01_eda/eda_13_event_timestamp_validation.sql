
-- EDA 13: Event timestamp consistency
-- Event-level analysis

WITH events AS (

    SELECT
        'vitalsign' AS table_name,
        stay_id,
        charttime
    FROM `physionet-data.mimiciv_ed.vitalsign`

    UNION ALL

    SELECT
        'pyxis',
        stay_id,
        charttime
    FROM `physionet-data.mimiciv_ed.pyxis`

    UNION ALL

    SELECT
        'medrecon',
        stay_id,
        charttime
    FROM `physionet-data.mimiciv_ed.medrecon`
),

classified AS (
    SELECT
        ev.table_name,
        ev.stay_id,

        CASE
            WHEN e.intime IS NULL
              OR e.outtime IS NULL
              OR e.outtime < e.intime
                THEN 'Invalid ED interval'

            WHEN ev.charttime IS NULL
                THEN 'Missing timestamp'

            WHEN ev.charttime < e.intime
                THEN 'Before arrival'

            WHEN ev.charttime > e.outtime
                THEN 'After departure'

            ELSE 'Within ED stay'
        END AS timestamp_status

    FROM events ev
    JOIN `physionet-data.mimiciv_ed.edstays` e
        ON ev.stay_id = e.stay_id
),

counts AS (
    SELECT
        table_name,
        timestamp_status,
        COUNT(*) AS event_count,
        COUNT(DISTINCT stay_id) AS unique_stays
    FROM classified
    GROUP BY table_name, timestamp_status
)

SELECT
    table_name,
    timestamp_status,
    event_count,
    unique_stays,

    ROUND(
        100.0 * SAFE_DIVIDE(
            event_count,
            SUM(event_count) OVER (
                PARTITION BY table_name
            )
        ),
        3
    ) AS event_pct

FROM counts
ORDER BY table_name, event_count DESC;
