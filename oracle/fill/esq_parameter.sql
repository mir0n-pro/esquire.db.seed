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
--

CREATE OR REPLACE PROCEDURE temp_parameter  (
    aName  IN VARCHAR2,
    aDesc   IN VARCHAR2,
    aEntityType IN NUMBER,
    aType IN VARCHAR2,
    aLabel  IN VARCHAR2,
    aReadwrite IN NUMBER,
    aLayer  IN NUMBER,
    aSort  IN NUMBER,
    aTooltip IN VARCHAR2,
    aNullmeaning  IN VARCHAR2,
    aNullable IN VARCHAR2,
    aValidation IN VARCHAR2,
    aListvalues IN VARCHAR2,
    aFormat IN VARCHAR2, 
    aPersonal IN VARCHAR2) IS
BEGIN

    INSERT INTO ESQ_PARAMETER   (
         PAR_ET_PK
        ,PAR_NAME
        ,PAR_DESC
        ,PAR_TYPE
        ,PAR_LABEL
        ,PAR_READWRITE
        ,PAR_LAYER
        ,PAR_SORT
        ,PAR_TOOLTIP
        ,PAR_NULLMEANING
        ,PAR_NULLABLE_FLG
        ,PAR_VALIDATION
        ,PAR_LISTVALUES
        ,PAR_FORMAT
        ,PAR_PERSONAL_FLG
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
        ,aValidation
        ,aListvalues
        ,aFormat
        ,aPersonal
    );
    COMMIT;
END;
/
show errors;

DELETE FROM ESQ_PARAMETER;
COMMIT;
BEGIN

    --              aName,        aDesc,             aEntityType,  aType,    aLabel,      aReadwrite,  aLayer, aSort, aTolltip,    aNullmeaning, aNullable, aValidation, aListvalues, aFormat,  aPersonal
    temp_parameter( 'DB_NAME',    'Database name',   0,           'string',  'DB Name',   1,           2,       1,       'Database name'
                                                                                                                                        , NULL,         'N',      NULL,        NULL,        NULL,   NULL);
    temp_parameter( 'DB_VERSION', 'Database version',0,           'string',  'DB Version',1,           2,       2,       'Database version'
                                                                                                                                        , NULL,         'N',      NULL,        NULL,        NULL,   NULL);
    temp_parameter( 'Example', 'Custom organization parameter example'
                                                    ,10,           'string', 'Example',   3,           2,       1,       'An example'   , NULL,         'Y',      NULL,        NULL,        NULL,   NULL);
    temp_parameter( 'Example', 'Custom client parameter example'
                                                    ,12,           'string', 'Example',   3,           2,       1,       'An example'   , NULL,         'Y',      NULL,        NULL,        NULL,    'Y');

END;
/
DROP PROCEDURE temp_parameter;
