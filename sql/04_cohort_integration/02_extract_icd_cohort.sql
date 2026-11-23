
-- P4 2.3.1: Encounter-Level ICD Cohort Extraction
-- Source: MIMIC-IV-ED v2.2
-- Unit of analysis: stay_id
-- Eligibility: ICD-defined C2 cohort, all ages

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
)

SELECT
    e.stay_id,
    e.subject_id,
    f.c1_flag,
    f.c2_flag,
    IF(
        f.c2_flag = 1 AND f.c1_flag = 0,
        1, 0
    ) AS c2_only_flag

FROM encounter_flags AS f
INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
    ON f.stay_id = e.stay_id

WHERE f.c2_flag = 1

ORDER BY e.stay_id;
