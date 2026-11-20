
-- EDA 03: Primary key uniqueness and null validation

WITH key_validation AS (

    SELECT
        'edstays' AS table_name,
        COUNT(*) AS total_rows,
        COUNT(DISTINCT stay_id) AS unique_stays,
        COUNTIF(stay_id IS NULL) AS null_stay_ids
    FROM `physionet-data.mimiciv_ed.edstays`

    UNION ALL

    SELECT
        'triage',
        COUNT(*),
        COUNT(DISTINCT stay_id),
        COUNTIF(stay_id IS NULL)
    FROM `physionet-data.mimiciv_ed.triage`
)

SELECT
    *,
    total_rows - unique_stays - null_stay_ids
        AS duplicate_rows
FROM key_validation;
