
-- P4 3.2.1: Adult ICD-Defined LBP Cohort
-- Dataset: MIMIC-IV-ED v2.2 + linked MIMIC-IV
-- Unit: one row per stay_id
-- Eligibility: C2-positive and estimated age >= 18

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

cohort_with_age AS (
    SELECT
        e.stay_id,
        e.subject_id,
        p.anchor_age
            + EXTRACT(YEAR FROM e.intime)
            - p.anchor_year AS estimated_age,
        f.c1_flag,
        f.c2_flag
    FROM encounter_flags AS f
    INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
        ON f.stay_id = e.stay_id
    LEFT JOIN `physionet-data.mimiciv_3_1_hosp.patients` AS p
        ON e.subject_id = p.subject_id
    WHERE f.c2_flag = 1
)

SELECT
    stay_id,
    subject_id,
    estimated_age,
    c1_flag,
    c2_flag,
    IF(c1_flag = 0 AND c2_flag = 1, 1, 0)
        AS c2_only_flag

FROM cohort_with_age

WHERE estimated_age >= 18

ORDER BY stay_id;
