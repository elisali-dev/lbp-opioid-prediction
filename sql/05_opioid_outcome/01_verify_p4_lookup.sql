
-- P5 5.2.2: Validate frozen P4 cohort lookup
-- Expected: 14,293 encounters, 9,571 C1,
--           4,722 C2-only, no duplicate stay_id

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT stay_id) AS unique_stays,
    COUNT(DISTINCT subject_id) AS unique_patients,
    COUNTIF(stay_id IS NULL) AS missing_stay_id,
    COUNTIF(estimated_age < 18 OR estimated_age IS NULL)
        AS invalid_age,
    COUNTIF(c1_flag = 1) AS c1_encounters,
    COUNTIF(c2_only_flag = 1) AS c2_only_encounters,
    COUNTIF(c2_flag = 1) AS c2_encounters

FROM `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup`;
