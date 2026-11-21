
-- P3: Encounter-level chief complaint extraction
-- Source: MIMIC-IV-ED triage
-- Purpose: Triage-time chief complaint feature engineering
--
-- Preserve original chief complaint text.
-- Do not filter by ICD diagnoses or symptom keywords.

SELECT
    stay_id,
    chiefcomplaint
FROM `physionet-data.mimiciv_ed.triage`
ORDER BY stay_id;
