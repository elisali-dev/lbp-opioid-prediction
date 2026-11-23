
-- P4 4.1.1: Structured Triage Extraction
-- Population: Adult ICD-defined C2 cohort
-- Unit: One row per stay_id

WITH matched_diagnoses AS (
    SELECT
        d.stay_id,
        m.c1_include,
        m.c2_include
    FROM `physionet-data.mimiciv_ed.diagnosis` AS d
    INNER JOIN `healthcare-hrp-lbp.lbp_study.icd_lbp_codebook_v1` AS m
        ON CAST(d.icd_version AS STRING) = m.icd_version
       AND d.icd_code = m.icd_code
),

encounter_flags AS (
    SELECT
        stay_id,
        MAX(c1_include) AS c1_flag,
        MAX(c2_include) AS c2_flag
    FROM matched_diagnoses
    GROUP BY stay_id
),

adult_cohort AS (
    SELECT
        e.stay_id,
        e.subject_id,
        e.gender,
        e.arrival_transport,
        p.anchor_age
            + EXTRACT(YEAR FROM e.intime)
            - p.anchor_year AS estimated_age
    FROM encounter_flags AS f
    INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
        ON f.stay_id = e.stay_id
    LEFT JOIN `physionet-data.mimiciv_3_1_hosp.patients` AS p
        ON e.subject_id = p.subject_id
    WHERE f.c2_flag = 1
),

eligible_adults AS (
    SELECT *
    FROM adult_cohort
    WHERE estimated_age >= 18
)

SELECT
    a.stay_id,
    a.subject_id,
    a.gender,
    a.arrival_transport,

    -- Triage join completeness
    IF(t.stay_id IS NOT NULL, 1, 0)
        AS triage_matched,

    -- Core clinical measurements
    t.acuity,
    t.pain,

    -- Extended triage measurements
    t.heartrate,
    t.sbp,
    t.dbp,
    t.resprate,
    t.temperature,
    t.o2sat

FROM eligible_adults AS a
LEFT JOIN `physionet-data.mimiciv_ed.triage` AS t
    ON a.stay_id = t.stay_id

ORDER BY a.stay_id;
