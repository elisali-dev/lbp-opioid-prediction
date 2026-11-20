
-- EDA 07: Chief complaint frequency analysis

WITH normalized_complaints AS (
    SELECT
        LOWER(TRIM(chiefcomplaint)) AS complaint_normalized
    FROM `physionet-data.mimiciv_ed.triage`
),

complaint_counts AS (
    SELECT
        complaint_normalized,
        COUNT(*) AS encounter_count
    FROM normalized_complaints
    GROUP BY complaint_normalized
)

SELECT
    complaint_normalized,
    encounter_count,
    ROUND(
        100.0 * SAFE_DIVIDE(
            encounter_count,
            SUM(encounter_count) OVER ()
        ),
        3
    ) AS encounter_pct
FROM complaint_counts
ORDER BY encounter_count DESC;
