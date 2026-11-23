
-- P4 3.1.1: Patient Linkage and Age Eligibility Audit
-- Population: ICD-defined C2 encounters, all ages

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

cohort AS (
    SELECT
        e.stay_id,
        e.subject_id,
        e.intime,
        f.c1_flag,
        f.c2_flag
    FROM encounter_flags AS f
    INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
        ON f.stay_id = e.stay_id
    WHERE f.c2_flag = 1
),

age_linkage AS (
    SELECT
        c.*,
        p.subject_id AS matched_patient_id,
        p.anchor_age,
        p.anchor_year,
        CASE
            WHEN c.intime IS NOT NULL
             AND p.anchor_age IS NOT NULL
             AND p.anchor_year IS NOT NULL
            THEN
                p.anchor_age
                + EXTRACT(YEAR FROM c.intime)
                - p.anchor_year
        END AS estimated_age
    FROM cohort AS c
    LEFT JOIN `physionet-data.mimiciv_3_1_hosp.patients` AS p
        ON c.subject_id = p.subject_id
)

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT stay_id) AS unique_stays,
    COUNT(DISTINCT subject_id) AS unique_patients,

    COUNTIF(matched_patient_id IS NULL)
        AS unmatched_patient_rows,

    COUNTIF(intime IS NULL)
        AS missing_intime,

    COUNTIF(
        matched_patient_id IS NOT NULL
        AND (anchor_age IS NULL OR anchor_year IS NULL)
    ) AS missing_age_anchors,

    COUNTIF(estimated_age IS NULL)
        AS missing_estimated_age,

    COUNTIF(estimated_age < 0)
        AS negative_age,

    COUNTIF(estimated_age < 18)
        AS under_18,

    COUNTIF(estimated_age = 18)
        AS age_18,

    COUNTIF(estimated_age >= 18)
        AS age_18_or_older,

    COUNTIF(anchor_age = 91)
        AS anchor_age_91,

    MIN(estimated_age) AS min_estimated_age,
    MAX(estimated_age) AS max_estimated_age,
    ROUND(AVG(estimated_age), 2) AS mean_estimated_age

FROM age_linkage;
