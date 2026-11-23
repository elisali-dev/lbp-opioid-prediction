
-- P5.5.3 Broad-scope medication impact
-- Descriptive audit only; primary outcome remains unchanged.

WITH qualifying AS (
  SELECT
    p.stay_id,
    p.name,
    CASE
      WHEN REGEXP_CONTAINS(
        LOWER(p.name),
        r'nalox|loperam|methadon|buprenorph'
      )
      THEN 1 ELSE 0
    END AS broad_scope_flag

  FROM `physionet-data.mimiciv_ed.pyxis` AS p

  JOIN `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup` AS c
    ON p.stay_id = c.stay_id

  JOIN `physionet-data.mimiciv_ed.edstays` AS e
    ON p.stay_id = e.stay_id

  JOIN `healthcare-hrp-lbp.lbp_study.p5_opioid_mapping_lookup` AS m
    ON p.name = m.pyxis_name
   AND p.gsn IS NOT DISTINCT FROM m.pyxis_gsn

  WHERE m.is_cumulus_opioid = 1
    AND p.charttime BETWEEN e.intime AND e.outtime
),

encounter_summary AS (
  SELECT
    stay_id,
    MAX(broad_scope_flag) AS has_broad_scope,
    MAX(1 - broad_scope_flag) AS has_other_opioid
  FROM qualifying
  GROUP BY stay_id
)

SELECT
  COUNT(*) AS positive_encounters,

  COUNTIF(has_broad_scope = 1)
    AS encounters_with_broad_scope_medication,

  COUNTIF(
    has_broad_scope = 1
    AND has_other_opioid = 0
  ) AS broad_scope_only_encounters,

  COUNTIF(has_other_opioid = 1)
    AS encounters_with_other_opioid

FROM encounter_summary;
