
-- P5.4.2.2 Pyxis mapping integration and temporal audit
-- No encounter-level outcome generated at this stage.

WITH cohort AS (
  SELECT stay_id
  FROM `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup`
),

pyxis_scoped AS (
  SELECT
    p.stay_id,
    p.name,
    p.gsn,
    p.charttime,
    e.intime,
    e.outtime
  FROM `physionet-data.mimiciv_ed.pyxis` AS p
  INNER JOIN cohort AS c
    ON p.stay_id = c.stay_id
  INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
    ON p.stay_id = e.stay_id
),

mapped AS (
  SELECT
    p.*,
    m.is_cumulus_opioid
  FROM pyxis_scoped AS p
  LEFT JOIN
    `healthcare-hrp-lbp.lbp_study.p5_opioid_mapping_lookup` AS m
    ON p.name = m.pyxis_name
   AND p.gsn IS NOT DISTINCT FROM m.pyxis_gsn
),

classified AS (
  SELECT
    *,
    CASE
      WHEN charttime IS NULL
        OR intime IS NULL
        OR outtime IS NULL
        THEN 'missing_time'
      WHEN charttime < intime
        THEN 'before_ed'
      WHEN charttime > outtime
        THEN 'after_ed'
      ELSE 'within_ed'
    END AS timing_category
  FROM mapped
)

SELECT
  COUNT(*) AS total_joined_rows,

  COUNTIF(is_cumulus_opioid IS NULL)
    AS unmapped_rows,

  COUNTIF(is_cumulus_opioid = 1)
    AS opioid_source_rows,

  COUNTIF(is_cumulus_opioid = 0)
    AS nonopioid_source_rows,

  COUNT(DISTINCT IF(
    is_cumulus_opioid = 1,
    stay_id,
    NULL
  )) AS encounters_with_any_opioid_record,

  COUNTIF(
    is_cumulus_opioid = 1
    AND timing_category = 'within_ed'
  ) AS opioid_rows_within_ed,

  COUNTIF(
    is_cumulus_opioid = 1
    AND timing_category = 'before_ed'
  ) AS opioid_rows_before_ed,

  COUNTIF(
    is_cumulus_opioid = 1
    AND timing_category = 'after_ed'
  ) AS opioid_rows_after_ed,

  COUNTIF(
    is_cumulus_opioid = 1
    AND timing_category = 'missing_time'
  ) AS opioid_rows_missing_time,

  COUNT(DISTINCT IF(
    is_cumulus_opioid = 1
    AND timing_category = 'within_ed',
    stay_id,
    NULL
  )) AS encounters_within_ed,

  COUNT(DISTINCT IF(
    is_cumulus_opioid = 1
    AND timing_category = 'before_ed',
    stay_id,
    NULL
  )) AS encounters_before_ed,

  COUNT(DISTINCT IF(
    is_cumulus_opioid = 1
    AND timing_category = 'after_ed',
    stay_id,
    NULL
  )) AS encounters_after_ed

FROM classified;
