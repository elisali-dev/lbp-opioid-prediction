
-- P4 3.1.3: Audit unmatched patient linkage
-- Reuse the verified ICD mapping and source tables.

WITH matched_diagnoses AS (
    SELECT
        d.stay_id,
        MAX(m.c1_include) AS c1_flag,
        MAX(m.c2_include) AS c2_flag
    FROM `physionet-data.mimiciv_ed.diagnosis` AS d
    INNER JOIN `healthcare-hrp-lbp.lbp_study.icd_lbp_codebook_v1` AS m
        ON CAST(d.icd_version AS STRING) = m.icd_version
       AND d.icd_code = m.icd_code
    GROUP BY d.stay_id
),

unmatched AS (
    SELECT
        e.stay_id,
        e.subject_id,
        f.c1_flag,
        f.c2_flag
    FROM matched_diagnoses AS f
    INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
        ON f.stay_id = e.stay_id
    LEFT JOIN `physionet-data.mimiciv_3_1_hosp.patients` AS p
        ON e.subject_id = p.subject_id
    WHERE f.c2_flag = 1
      AND p.subject_id IS NULL
)

SELECT
    COUNT(*) AS unmatched_encounters,
    COUNT(DISTINCT stay_id) AS unique_stays,
    COUNT(DISTINCT subject_id) AS unique_patients,
    COUNTIF(c1_flag = 1) AS c1_encounters,
    COUNTIF(c1_flag = 0 AND c2_flag = 1)
        AS c2_only_encounters
FROM unmatched;
