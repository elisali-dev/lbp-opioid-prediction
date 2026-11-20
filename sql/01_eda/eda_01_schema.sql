-- EDA 01: Inspect MIMIC-IV-ED table schemas
-- Source: PhysioNet MIMIC-IV-ED on BigQuery

SELECT
    table_name,
    ordinal_position,
    column_name,
    data_type,
    is_nullable
FROM
    `physionet-data.mimiciv_ed.INFORMATION_SCHEMA.COLUMNS`
ORDER BY
    table_name,
    ordinal_position;
