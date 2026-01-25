-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2026
--
-- file :   fill/esq_permission.sql
-- desc:    Fills esq_permission table
--
-----------------------------------
-- History:
--
-- 01/14/2026 mir0n ESQ_PERMISSION.PRM_ET_PK_USR removed
--                  generalized format of permission id

CREATE OR REPLACE PROCEDURE temp_permission (aID IN NUMBER,
    aType       IN NUMBER,
    aEntityType IN NUMBER,
    aName       IN VARCHAR2,
    aDesc       IN VARCHAR2) IS
BEGIN
    INSERT INTO ESQ_PERMISSION (
        PRM_PK,
        PRM_NAME,
        PRM_DESC,
        PRM_PT_PK,
        PRM_ET_PK
    ) VALUES (
        aID,
        aName,
        aDesc,
        aType,
        aEntityType
    );
    commit;
END;
/
show errors;
DELETE FROM ESQ_PERMISSION;
COMMIT;
BEGIN


--                  aID, aType, aEntityType,  aName,                          aDesc)
    temp_permission (   0,   0,           0,  'System',                       'Admin: System functions');
    temp_permission (  10,   0,          10,  'Orgranization',                'Admin: Organization unit functions');
    temp_permission (  12,   0,          12,  'Client',                       'Admin: Client functions');
    temp_permission (  14,   0,          14,  'Merchant',                     'Admin: Merchant functions');
    temp_permission (  16,   0,          16,  'Admin',                        'Admin: Admin functions');
    temp_permission (  18,   0,          18,  'Client Account',               'Admin: Client Account functions');
    temp_permission (  20,   0,          20,  'Merchant Account',             'Admin: Merchant Account functions');
    temp_permission (  22,   0,          22,  'Paper Client Account',         'Admin: Paper Client Account functions');
    temp_permission ( 100,   1,        NULL,  'Esquire Tree',                  'Runs Esquire tree interface');


END;
/
drop procedure temp_permission;
