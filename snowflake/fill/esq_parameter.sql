-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_parameter.sql
-- desc:    Fills esq_parameter table (Snowflake)
-----------------------------------

DELETE FROM ESQ_PARAMETER;

-- par_et_pk, par_name, par_desc, par_type, par_label, par_readwrite, par_layer, par_sort, par_tooltip, par_nullmeaning, par_nullable_flg, par_validation, par_listvalues, par_format, par_personal_flg
INSERT INTO ESQ_PARAMETER (PAR_ET_PK, PAR_NAME, PAR_DESC, PAR_TYPE, PAR_LABEL, PAR_READWRITE, PAR_LAYER, PAR_SORT, PAR_TOOLTIP, PAR_NULLMEANING, PAR_NULLABLE_FLG, PAR_VALIDATION, PAR_LISTVALUES, PAR_FORMAT, PAR_PERSONAL_FLG)
VALUES
 (0,  'DB_NAME',    'Database name',                         'string', 'DB Name',    1, 2, 1, 'Database name',    NULL, 'N', NULL, NULL, NULL, NULL),
 (0,  'DB_VERSION', 'Database version',                      'string', 'DB Version', 1, 2, 2, 'Database version', NULL, 'N', NULL, NULL, NULL, NULL),
 (20, 'Example',    'Custom organization parameter example', 'string', 'Example',    3, 2, 1, 'An example',       NULL, 'Y', NULL, NULL, NULL, NULL),
 (34, 'Example',    'Custom client parameter example',       'string', 'Example',    3, 3, 1, 'An example',       NULL, 'N', NULL, NULL, NULL, 'Y');

SELECT 'Done' AS status;
