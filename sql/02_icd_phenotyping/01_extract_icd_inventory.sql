-- Step 1: Extract ICD inventory from MIMIC-IV-ED
SELECT
    icd_version,
    icd_code,
    ANY_VALUE(icd_title) AS ed_description,
    COUNT(*) AS diagnosis_count,
    COUNT(DISTINCT stay_id) AS visit_count,
    COUNT(DISTINCT subject_id) AS patient_count
FROM `physionet-data.mimiciv_ed.diagnosis`
WHERE icd_code IS NOT NULL
GROUP BY
    icd_version,
    icd_code
ORDER BY
    icd_version,
    icd_code;