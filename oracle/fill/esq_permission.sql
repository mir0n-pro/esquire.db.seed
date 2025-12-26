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

CREATE OR REPLACE PROCEDURE temp_permission (aID IN NUMBER,
    aType       IN NUMBER,
    aEntityType IN NUMBER,
    aUserType   IN NUMBER,
    aName       IN VARCHAR2,
    aDesc       IN VARCHAR2) IS
BEGIN
    INSERT INTO ESQ_PERMISSION (
        PRM_PK,
        PRM_NAME,
        PRM_DESC,
        PRM_PT_PK,
        PRM_ET_PK,
        PRM_ET_PK_USR
    ) VALUES (
        aID,
        aName,
        aDesc,
        aType,
        aEntityType,
        aUserType
    );
    commit;
END;
/
show errors;
DELETE FROM ESQ_PERMISSION;
COMMIT;
BEGIN


--                  aID, aType, aEntityType, aUserType,        aName,                          aDesc)
    temp_permission (  1,    1,          0,         1,         'System',                       'Update system parameters');
    temp_permission (  2,    2,          10,        16,        'Orgranization.Creation',       'Creates a new orgnanization unit');
    temp_permission (  3,    3,          10,        16,        'Organization.Deletion',        'Deletes an orgnanization unit');
    temp_permission (  4,    4,          10,        16,        'Organization.Maintenance',     'Edits an orgnanization unit');
 
    temp_permission (  5,    2,          12,        16,        'Client.Creation',              'Creates a client profile');
    temp_permission (  6,    3,          12,        16,        'Client.Deletion',              'Deletes a client profile');
    temp_permission (  7,    4,          12,        16,        'Client.Maintenance',           'Edits a client profile');

    temp_permission (  8,    2,          14,        16,        'Merchant.Creation',            'Creates a salesman profile');
    temp_permission (  9,    3,          14,        16,        'Merchant.Deletion',            'Deletes a salesman profile');
    temp_permission ( 10,    4,          14,        16,        'Merchant.Maintenance',         'Edits a salesman profile');

    temp_permission ( 11,    2,          16,        16,        'Admin.Creation',               'Creates an administrator profile');
    temp_permission ( 12,    3,          16,        16,        'Admin.Deletion',               'Deletes an administrator profile');
    temp_permission ( 13,    4,          16,        16,        'Admin.Maintenance',            'Edits an administrator profile');

    temp_permission ( 14,    2,          18,        16,        'Client Account.Creation',     'Creates a client account');
    temp_permission ( 15,    3,          18,        16,        'Client Account.Deletion',     'Deletes a client account');
    temp_permission ( 16,    4,          18,        16,        'Client Account.Maintenance',  'Edits a client account');

    temp_permission ( 17,    2,          20,        16,        'Merchant Account.Creation',     'Creates a Merchant account');
    temp_permission ( 18,    3,          20,        16,        'Merchant Account.Deletion',     'Deletes a Merchant account');
    temp_permission ( 19,    4,          20,        16,        'Merchant Account.Maintenance',  'Edits a Merchant account');
    
    temp_permission ( 20,    5,          16,        16,        'Admin.Permissions',              'Setups an admin logon parameters and permissions');
    temp_permission ( 21,    5,          18,        16,        'Client.Permissions',             'Setups a client logon parameters and permissions');
    temp_permission ( 22,    5,          20,        16,        'Merchant.Permissions',           'Setups a merchant logon parameters and permissions');

    temp_permission ( 23,    6,         NULL,       16,        'Business explorer',              'Runs business explorer window');
    temp_permission ( 24,    6,         NULL,       16,        'Security explorer',              'Runs security explorer window');


END;
/
drop procedure temp_permission;
