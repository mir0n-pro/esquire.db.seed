-----------------------------------
-- Root organization (Snowflake)
-----------------------------------

INSERT INTO ESQ_ORG (ORG_PK, ORG_ET_PK, ORG_NAME, ORG_PATH, ORG_FULL_NAME, ORG_ORG_PK, ORG_DESC)
       VALUES       (1,      0,         'Esquire', '1.',     'Esquire System', NULL,       NULL);

INSERT INTO ESQ_ORG_PAR (OPR_ORG_PK, OPR_PAR_NAME, OPR_PAR_ET_PK, OPR_VALUE)
       VALUES           (1,          'DB_NAME',     0,             'Esquire');

INSERT INTO ESQ_ORG_PAR (OPR_ORG_PK, OPR_PAR_NAME, OPR_PAR_ET_PK, OPR_VALUE)
       VALUES           (1,          'DB_VERSION',  0,             '2.0.0');

SELECT 'Done' AS status;
