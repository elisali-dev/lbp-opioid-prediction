
-- EDA 08: Triage vital sign distributions
-- Percentiles exclude NULL values

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
           temperature AS value FROM vitals
    UNION ALL
    SELECT 'heartrate', heartrate FROM vitals
    UNION ALL
    SELECT 'resprate', resprate FROM vitals
    UNION ALL
    SELECT 'o2sat', o2sat FROM vitals
    UNION ALL
    SELECT 'sbp', sbp FROM vitals
    UNION ALL
    SELECT 'dbp', dbp FROM vitals
)

SELECT
    variable_name,
    COUNT(*) AS total_count,
    COUNT(value) AS non_missing_count,
    COUNTIF(value IS NULL) AS missing_count,
    ROUND(MIN(value), 2) AS min_value,
    ROUND(AVG(value), 2) AS mean_value,
    ROUND(STDDEV(value), 2) AS std_value,
    ROUND(
        APPROX_QUANTILES(value, 100)[OFFSET(1)], 2
    ) AS p01,
    ROUND(
        APPROX_QUANTILES(value, 100)[OFFSET(25)], 2
    ) AS p25,
    ROUND(
        APPROX_QUANTILES(value, 100)[OFFSET(50)], 2
    ) AS median,
    ROUND(
        APPROX_QUANTILES(value, 100)[OFFSET(75)], 2
    ) AS p75,
    ROUND(
        APPROX_QUANTILES(value, 100)[OFFSET(99)], 2
    ) AS p99,
    ROUND(MAX(value), 2) AS max_value
FROM long_format
GROUP BY variable_name
ORDER BY variable_name;
