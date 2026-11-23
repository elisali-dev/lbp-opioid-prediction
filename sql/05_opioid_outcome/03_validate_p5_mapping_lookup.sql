
-- P5.4.2.1 Validate uploaded medication mapping lookup

WITH mapping AS (
  SELECT
    pyxis_name,
    pyxis_gsn,
    is_cumulus_opioid
  FROM `healthcare-hrp-lbp.lbp_study.p5_opioid_mapping_lookup`
),

unique_pairs AS (
  SELECT
    pyxis_name,
    pyxis_gsn
  FROM mapping
  GROUP BY pyxis_name, pyxis_gsn
)

SELECT
  (SELECT COUNT(*) FROM mapping)
    AS total_combinations,

  (SELECT COUNT(*) FROM unique_pairs)
    AS unique_name_gsn_pairs,

  COUNTIF(is_cumulus_opioid = 1)
    AS opioid_combinations,

  COUNTIF(is_cumulus_opioid = 0)
    AS nonopioid_combinations,

  COUNTIF(is_cumulus_opioid IS NULL)
    AS missing_classification,

  COUNTIF(pyxis_name IS NULL OR TRIM(pyxis_name) = '')
    AS missing_medication_name,

  COUNTIF(pyxis_gsn IS NULL OR TRIM(pyxis_gsn) = '')
    AS missing_gsn,

  COUNTIF(
    is_cumulus_opioid = 1
    AND (pyxis_gsn IS NULL OR TRIM(pyxis_gsn) = '')
  ) AS missing_gsn_opioid,

  COUNTIF(
    pyxis_gsn IS NOT NULL
    AND STARTS_WITH(pyxis_gsn, '0')
  ) AS gsn_with_leading_zero

FROM mapping;
