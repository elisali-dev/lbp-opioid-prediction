
-- EDA 09: Triage vital signs plausibility assessment
-- Exploratory thresholds only; no records are removed.

WITH vitals AS (
    SELECT
        temperature,
        heartrate,
        resprate,
        o2sat,
        sbp,
        dbp
    FROM `physionet-data.mimiciv_ed.triage`
),

long_format AS (
    SELECT 'temperature' AS variable_name,
           temperature AS value,
           85 AS lower_bound, 110 AS upper_bound
    FROM vitals

    UNION ALL
    SELECT 'heartrate', heartrate, 20, 250 FROM vitals

    UNION ALL
    SELECT 'resprate', resprate, 4, 80 FROM vitals

    UNION ALL
    SELECT 'o2sat', o2sat, 50, 100 FROM vitals

    UNION ALL
    SELECT 'sbp', sbp, 40, 300 FROM vitals

    UNION ALL
    SELECT 'dbp', dbp, 20, 200 FROM vitals
)

SELECT
    variable_name,
    COUNT(*) AS total_rows,
    COUNTIF(value IS NULL) AS missing_count,
    COUNTIF(value < lower_bound) AS below_range,
    COUNTIF(value > upper_bound) AS above_range,
    COUNTIF(
        value < lower_bound OR value > upper_bound
    ) AS flagged_count,

    ROUND(
        100.0 * SAFE_DIVIDE(
            COUNTIF(value < lower_bound OR value > upper_bound),
            COUNTIF(value IS NOT NULL)
        ), 3
    ) AS flagged_pct_non_missing

FROM long_format
GROUP BY variable_name
ORDER BY variable_name;
