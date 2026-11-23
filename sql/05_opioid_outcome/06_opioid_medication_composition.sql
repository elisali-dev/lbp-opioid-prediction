
-- P5.5.2 Medication Composition Audit
-- Includes Cumulus-related records within the ED stay.
-- Aggregation: original Pyxis medication name + GSN.

WITH cohort AS (
  SELECT stay_id
  FROM `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup`
),

qualifying_pyxis AS (
  SELECT
    p.stay_id,
    p.name AS pyxis_name,
    p.gsn AS pyxis_gsn

  FROM `physionet-data.mimiciv_ed.pyxis` AS p

  INNER JOIN cohort AS c
    ON p.stay_id = c.stay_id

  INNER JOIN `physionet-data.mimiciv_ed.edstays` AS e
    ON p.stay_id = e.stay_id

  INNER JOIN
    `healthcare-hrp-lbp.lbp_study.p5_opioid_mapping_lookup` AS m
    ON p.name = m.pyxis_name
   AND p.gsn IS NOT DISTINCT FROM m.pyxis_gsn

  WHERE m.is_cumulus_opioid = 1
    AND p.charttime BETWEEN e.intime AND e.outtime
)

SELECT
  pyxis_name,
  pyxis_gsn,
  COUNT(*) AS source_records,
  COUNT(DISTINCT stay_id) AS distinct_encounters

FROM qualifying_pyxis

GROUP BY pyxis_name, pyxis_gsn
ORDER BY source_records DESC, pyxis_name;
