
-- EDA 02: Table granularity and record counts

WITH table_counts AS (

    SELECT
        'edstays' AS table_name,
        COUNT(*) AS row_count,
        COUNT(DISTINCT stay_id) AS unique_stays
    FROM `physionet-data.mimiciv_ed.edstays`

    UNION ALL

    SELECT
        'triage',
        COUNT(*),
        COUNT(DISTINCT stay_id)
    FROM `physionet-data.mimiciv_ed.triage`

    UNION ALL

    SELECT
        'diagnosis',
        COUNT(*),
        COUNT(DISTINCT stay_id)
    FROM `physionet-data.mimiciv_ed.diagnosis`

    UNION ALL

    SELECT
        'vitalsign',
        COUNT(*),
        COUNT(DISTINCT stay_id)
    FROM `physionet-data.mimiciv_ed.vitalsign`

    UNION ALL

    SELECT
        'medrecon',
        COUNT(*),
        COUNT(DISTINCT stay_id)
    FROM `physionet-data.mimiciv_ed.medrecon`

    UNION ALL

    SELECT
        'pyxis',
        COUNT(*),
        COUNT(DISTINCT stay_id)
    FROM `physionet-data.mimiciv_ed.pyxis`
)

SELECT
    table_name,
    row_count,
    unique_stays,
    ROUND(
        SAFE_DIVIDE(row_count, unique_stays), 2
    ) AS avg_rows_per_stay
FROM table_counts
ORDER BY table_name;
