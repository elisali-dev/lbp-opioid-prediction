
-- EDA 11: Triage acuity distribution and validity
-- Expected values: 1–5

WITH acuity_counts AS (
    SELECT
        acuity,
        COUNT(*) AS encounter_count
    FROM `physionet-data.mimiciv_ed.triage`
    GROUP BY acuity
),

acuity_classified AS (
    SELECT
        acuity,
        encounter_count,
        CASE
            WHEN acuity IS NULL THEN 'Missing'
            WHEN acuity BETWEEN 1 AND 5 THEN 'Valid'
            ELSE 'Invalid'
        END AS acuity_status
    FROM acuity_counts
)

SELECT
    acuity,
    acuity_status,
    encounter_count,

    ROUND(
        100.0 * SAFE_DIVIDE(
            encounter_count,
            SUM(encounter_count) OVER ()
        ),
        2
    ) AS encounter_pct

FROM acuity_classified
ORDER BY acuity NULLS LAST;
