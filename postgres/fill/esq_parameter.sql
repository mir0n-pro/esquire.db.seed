-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_parameter.sql
-- desc:    Fills esq_parameter table
--
-----------------------------------
-- History:
-- 03/03/2026 mir0n PAR_LAYER corrected for entity type 34 (Client example param: 2->3)
-- 03/06/2026 mir0n Example param (entity kind 34): PAR_NULLABLE 'Y' -> 'N' (field is required)
-- 03/08/2026 mir0n personal custom parameter test case
-- 03/28/2026 mir0n aDefault parameter added; PAR_DEFAULT in INSERT; defaults for DB_NAME, DB_VERSION, example params

CREATE OR REPLACE PROCEDURE temp_parameter  (
    aName  varchar,
    aDesc   varchar,
    aEntityType integer,
    aType varchar,
    aLabel  varchar,
    aReadwrite integer,
    aLayer  integer,
    aSort  integer,
    aTooltip varchar,
    aNullmeaning  varchar,
    aNullable varchar,
    aDefault varchar,
    aValidation varchar,
    aListvalues varchar,
    aFormat varchar,
    aPersonal IN varchar
) LANGUAGE plpgsql
AS $$
BEGIN

	 INSERT INTO esq_parameter (
         par_et_pk
        ,par_name
        ,par_desc
        ,par_type
        ,par_label
        ,par_readwrite
        ,par_layer
        ,par_sort
        ,par_tooltip
        ,par_nullmeaning
        ,par_nullable_flg
        ,par_default
        ,par_validation
        ,par_listvalues
        ,par_format
        ,par_personal_flg
    ) VALUES (
         aEntityType
        ,aName
        ,aDesc
        ,aType
        ,aLabel
        ,aReadwrite
        ,aLayer
        ,aSort
        ,aTooltip
        ,aNullmeaning
        ,aNullable
        ,aDefault
        ,aValidation
        ,aListvalues
        ,aFormat
        ,aPersonal
    );

END $$;

DO $$
BEGIN
    DELETE FROM esq_parameter;
    --              aName,        aDesc,             aEntityType,  aType,    aLabel,      aReadwrite, aLayer, aSort, aTolltip,    aNullmeaning, aNullable, aDefault,    aValidation, aListvalues, aFormat, aPersonal
    CALL temp_parameter( 'DB_NAME',    'Database name',   0,           'string',  'DB Name',   1,     2,       1,       'Database name'
                                                                                                                                     , NULL,     'N',      'esquire',   NULL,        NULL,        NULL,        NULL);
    CALL temp_parameter( 'DB_VERSION', 'Database version',0,           'string',  'DB Version',1,     2,       2,       'Database version'
                                                                                                                                     , NULL,     'N',      '1.0',       NULL,        NULL,        NULL,        NULL);
    CALL temp_parameter( 'Example', 'Custom organization parameter example'
                                                         ,20,           'string', 'Example',   3,     2,       1,       'An example' , NULL,     'Y',      NULL,        NULL,        NULL,        NULL,        NULL);
    CALL temp_parameter( 'Example', 'Custom client parameter example'
                                                    ,34,                'string', 'Example',   3,     3,      1,       'An example'  , NULL,     'N',      'default',   NULL,        NULL,        NULL,         'N');
    CALL temp_parameter( 'P_Example', 'Custom personal client parameter example'
                                                    ,34,                'string', 'Example(P)',   3,     3,      2,       'A personal example'  , NULL,     'N',      'default',   NULL,        NULL,        NULL,         'Y');
		COMMIT;
END $$;

DROP PROCEDURE temp_parameter;

\echo -n 'Done\n'
\qecho -n 'Done\n'
