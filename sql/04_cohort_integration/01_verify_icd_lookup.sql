-- P4 2.2.3: Verify uploaded ICD lookup table

WITH icd_mapping AS (
    SELECT
        icd_version,
        icd_code,
        c1_include,
        c2_include
    FROM `healthcare-hrp-lbp.lbp_study.icd_lbp_codebook_v1`
),

unique_pairs AS (
    SELECT DISTINCT
        icd_version,
        icd_code
    FROM icd_mapping
)

SELECT
    COUNT(*) AS total_codes,
    (SELECT COUNT(*) FROM unique_pairs) AS unique_code_pairs,
    COUNTIF(c1_include = 1) AS c1_codes,
    COUNTIF(c2_include = 1) AS c2_codes,
    COUNTIF(c1_include = 1 AND c2_include != 1)
        AS nesting_violations,
    COUNTIF(
        icd_version IS NULL OR icd_code IS NULL
        OR c1_include IS NULL OR c2_include IS NULL
    ) AS missing_mapping_rows
FROM icd_mapping;