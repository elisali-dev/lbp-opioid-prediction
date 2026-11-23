
-- P5.4.3 Encounter-level opioid dispensing outcome
-- Primary time window: intime <= charttime <= outtime

WITH cohort AS (
  SELECT stay_id
  FROM `healthcare-hrp-lbp.lbp_study.p4_adult_cohort_lookup`
),

qualifying_records AS (
  SELECT
    p.stay_id
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

  GROUP BY p.stay_id
)

SELECT
  c.stay_id,

  IF(q.stay_id IS NOT NULL, 1, 0)
    AS opioid_dispensed

FROM cohort AS c

LEFT JOIN qualifying_records AS q
  ON c.stay_id = q.stay_id

ORDER BY c.stay_id;
