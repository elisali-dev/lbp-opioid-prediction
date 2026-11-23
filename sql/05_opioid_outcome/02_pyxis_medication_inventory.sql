
-- P5 5.2.2: P4-Linked Pyxis Medication Inventory
-- Source: MIMIC-IV-ED v2.2
-- Population: Frozen P4 adult LBP cohort
-- Unit of output: Unique (name, gsn) combination
-- No medication classification applied

WITH cohort_pyxis AS (
    SELECT
        p.stay_id,
        p.name,
        p.gsn,
        p.charttime,
        e.intime,
        e.outtime

    FROM `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup` AS c

    INNER JOIN `physionet-data.mimiciv_ed.pyxis` AS p
        ON c.stay_id = p.stay_id

    INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
        ON c.stay_id = e.stay_id
)

SELECT
    name AS pyxis_name,
    gsn AS pyxis_gsn,

    COUNT(*) AS record_count,
    COUNT(DISTINCT stay_id) AS encounter_count,

    COUNTIF(name IS NULL OR TRIM(name) = '')
        AS missing_name_records,

    COUNTIF(gsn IS NULL)
        AS missing_gsn_records,

    COUNTIF(charttime IS NULL)
        AS missing_charttime_records,

    COUNTIF(
        charttime >= intime
        AND charttime <= outtime
    ) AS within_ed_records,

    COUNTIF(charttime < intime)
        AS before_ed_records,

    COUNTIF(charttime > outtime)
        AS after_ed_records,

    COUNTIF(
        charttime IS NOT NULL
        AND (intime IS NULL OR outtime IS NULL)
    ) AS unclassified_time_records

FROM cohort_pyxis

GROUP BY pyxis_name, pyxis_gsn

ORDER BY record_count DESC, pyxis_name;
