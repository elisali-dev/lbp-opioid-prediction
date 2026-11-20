
-- EDA 04: Referential integrity validation

WITH child_stays AS (
    SELECT 'triage' AS table_name, stay_id
    FROM `physionet-data.mimiciv_ed.triage`

    UNION ALL

    SELECT 'diagnosis', stay_id
    FROM `physionet-data.mimiciv_ed.diagnosis`

    UNION ALL

    SELECT 'vitalsign', stay_id
    FROM `physionet-data.mimiciv_ed.vitalsign`

    UNION ALL

    SELECT 'medrecon', stay_id
    FROM `physionet-data.mimiciv_ed.medrecon`

    UNION ALL

    SELECT 'pyxis', stay_id
    FROM `physionet-data.mimiciv_ed.pyxis`
)

SELECT
    c.table_name,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT c.stay_id) AS unique_stays,
    COUNTIF(c.stay_id IS NULL) AS null_stay_ids,
    COUNTIF(
        c.stay_id IS NOT NULL
        AND e.stay_id IS NULL
    ) AS unmatched_rows,
    COUNT(DISTINCT IF(
        c.stay_id IS NOT NULL
        AND e.stay_id IS NULL,
        c.stay_id,
        NULL
    )) AS unmatched_stays
FROM child_stays c
LEFT JOIN `physionet-data.mimiciv_ed.edstays` e
    ON c.stay_id = e.stay_id
GROUP BY c.table_name
ORDER BY c.table_name;
