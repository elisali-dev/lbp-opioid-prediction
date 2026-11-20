
-- EDA 12: ED stay duration and timestamp validation
-- Unit: hours

WITH ed_duration AS (
    SELECT
        stay_id,
        intime,
        outtime,
        TIMESTAMP_DIFF(
            outtime,
            intime,
            SECOND
        ) / 3600.0 AS los_hours
    FROM `physionet-data.mimiciv_ed.edstays`
)

SELECT
    COUNT(*) AS total_encounters,

    COUNTIF(intime IS NULL) AS missing_intime,
    COUNTIF(outtime IS NULL) AS missing_outtime,

    COUNTIF(los_hours < 0) AS negative_duration,
    COUNTIF(los_hours = 0) AS zero_duration,

    COUNTIF(los_hours > 24) AS over_24h,
    COUNTIF(los_hours > 48) AS over_48h,
    COUNTIF(los_hours > 72) AS over_72h,

    ROUND(MIN(los_hours), 2) AS min_hours,
    ROUND(AVG(los_hours), 2) AS mean_hours,
    ROUND(STDDEV(los_hours), 2) AS std_hours,

    ROUND(
        APPROX_QUANTILES(los_hours, 100)[OFFSET(25)], 2
    ) AS p25_hours,

    ROUND(
        APPROX_QUANTILES(los_hours, 100)[OFFSET(50)], 2
    ) AS median_hours,

    ROUND(
        APPROX_QUANTILES(los_hours, 100)[OFFSET(75)], 2
    ) AS p75_hours,

    ROUND(
        APPROX_QUANTILES(los_hours, 100)[OFFSET(95)], 2
    ) AS p95_hours,

    ROUND(
        APPROX_QUANTILES(los_hours, 100)[OFFSET(99)], 2
    ) AS p99_hours,

    ROUND(MAX(los_hours), 2) AS max_hours

FROM ed_duration;
