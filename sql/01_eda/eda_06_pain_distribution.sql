
-- EDA 06: Pain score distribution and validity

WITH pain_values AS (
    SELECT
        TRIM(pain) AS pain_value,
        SAFE_CAST(TRIM(pain) AS FLOAT64) AS pain_numeric
    FROM `physionet-data.mimiciv_ed.triage`
),

pain_classified AS (
    SELECT
        pain_value,
        CASE
            WHEN pain_value IS NULL OR pain_value = ''
                THEN 'Missing'
            WHEN pain_numeric BETWEEN 0 AND 10
                THEN 'Valid numeric'
            WHEN pain_numeric IS NOT NULL
                THEN 'Out of range'
            ELSE 'Non-numeric'
        END AS pain_category
    FROM pain_values
),

pain_counts AS (
    SELECT
        COALESCE(pain_value, '<NULL>') AS pain_value,
        pain_category,
        COUNT(*) AS record_count
    FROM pain_classified
    GROUP BY pain_value, pain_category
)

SELECT
    pain_value,
    pain_category,
    record_count,
    ROUND(
        100.0 * SAFE_DIVIDE(
            record_count,
            SUM(record_count) OVER ()
        ),
        2
    ) AS percentage
FROM pain_counts
ORDER BY record_count DESC;
