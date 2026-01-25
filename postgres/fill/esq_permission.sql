-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_permission.sql
-- desc:    Fills esq_permission table
--
-----------------------------------
-- History:
--
-- 01/14/2026 mir0n ESQ_PERMISSION.PRM_ET_PK_USR removed
--                  generalized format of permission id

CREATE OR REPLACE PROCEDURE temp_permission (
		aID 				IN integer,
    aType       IN integer,
    aEntityType IN integer,
    aName       IN varchar,
    aDesc       IN varchar
) LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO esq_permission (
        prm_pk,
        prm_name,
        prm_desc,
        prm_pt_pk,
        prm_et_pk
    ) VALUES (
        aID,
        aName,
        aDesc,
        aType,
        aEntityType
    );
END $$;

DO $$
BEGIN
    DELETE FROM esq_permission;
--                       aID, aType, aEntityType,  aName,                          aDesc)
    CALL temp_permission (   0,   0,           0,  'System',                       'Admin: System functions');
    CALL temp_permission (  10,   0,          10,  'Orgranization',                'Admin: Organization unit functions');
    CALL temp_permission (  12,   0,          12,  'Client',                       'Admin: Client functions');
    CALL temp_permission (  14,   0,          14,  'Merchant',                     'Admin: Merchant functions');
    CALL temp_permission (  16,   0,          16,  'Admin',                        'Admin: Admin functions');
    CALL temp_permission (  18,   0,          18,  'Client Account',               'Admin: Client Account functions');
    CALL temp_permission (  20,   0,          20,  'Merchant Account',             'Admin: Merchant Account functions');
    CALL temp_permission (  22,   0,          22,  'Paper Client Account',         'Admin: Paper Client Account functions');
    CALL temp_permission ( 100,   1,        NULL,  'Esquire Tree',                  'Runs Esquire tree interface');

    
    
	COMMIT;
END $$;

DROP PROCEDURE temp_permission;

\echo -n 'Done\n'
\qecho -n 'Done\n'

