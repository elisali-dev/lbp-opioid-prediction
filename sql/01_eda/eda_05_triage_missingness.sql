
-- EDA 05: Triage field-level missingness
-- Missingness defined as SQL NULL only

WITH field_counts AS (
    SELECT
        COUNT(*) AS total_rows,
        COUNTIF(chiefcomplaint IS NULL) AS chiefcomplaint_missing,
        COUNTIF(pain IS NULL) AS pain_missing,
        COUNTIF(acuity IS NULL) AS acuity_missing,
        COUNTIF(temperature IS NULL) AS temperature_missing,
        COUNTIF(heartrate IS NULL) AS heartrate_missing,
        COUNTIF(resprate IS NULL) AS resprate_missing,
        COUNTIF(o2sat IS NULL) AS o2sat_missing,
        COUNTIF(sbp IS NULL) AS sbp_missing,
        COUNTIF(dbp IS NULL) AS dbp_missing
    FROM `physionet-data.mimiciv_ed.triage`
)

SELECT
    variable_name,
    total_rows,
    missing_count,
    total_rows - missing_count AS non_missing_count,
    ROUND(
        SAFE_DIVIDE(missing_count, total_rows) * 100,
        2
    ) AS missing_pct
FROM field_counts
UNPIVOT (
    missing_count FOR variable_name IN (
        chiefcomplaint_missing,
        pain_missing,
        acuity_missing,
        temperature_missing,
        heartrate_missing,
        resprate_missing,
        o2sat_missing,
        sbp_missing,
        dbp_missing
    )
)
ORDER BY missing_pct DESC;
