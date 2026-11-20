
-- EDA 10: Blood pressure consistency (SBP > DBP)

SELECT
    COUNT(*) AS total_encounters,

    COUNTIF(
        sbp IS NOT NULL AND dbp IS NOT NULL
    ) AS complete_bp_pairs,

    COUNTIF(
        sbp < dbp
    ) AS sbp_below_dbp,

    COUNTIF(
        sbp = dbp
    ) AS sbp_equal_dbp,

    ROUND(
        100.0 * SAFE_DIVIDE(
            COUNTIF(sbp <= dbp),
            COUNTIF(sbp IS NOT NULL AND dbp IS NOT NULL)
        ), 3
    ) AS inconsistent_bp_pct

FROM `physionet-data.mimiciv_ed.triage`;
