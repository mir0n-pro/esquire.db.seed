-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_permission.sql
-- desc:    Fills esq_permission table (Snowflake)
-----------------------------------

DELETE FROM ESQ_PERMISSION;

-- prm_pk, prm_pt_pk, prm_et_pk, prm_name, prm_desc
INSERT INTO ESQ_PERMISSION (PRM_PK, PRM_PT_PK, PRM_ET_PK, PRM_NAME, PRM_DESC) VALUES
 (  0, 980,    0, 'System',                'Admin: System functions'),
 ( 20, 980,   20, 'Orgranization',         'Admin: Organization unit functions'),
 ( 30, 980,   30, 'SysAdmin',              'SysAdmin: Admin functions'),
 ( 32, 980,   32, 'Admin',                 'Admin: Admin functions'),
 ( 34, 980,   34, 'Client',                'Admin: Client functions'),
 ( 36, 980,   36, 'Merchant',              'Admin: Merchant functions'),
 ( 50, 980,   50, 'Client Account',        'Admin: Client Account functions'),
 ( 52, 980,   52, 'Merchant Account',      'Admin: Merchant Account functions'),
 ( 54, 980,   54, 'Paper Client Account',  'Admin: Paper Client Account functions'),
 (100, 982, NULL, 'Esquire Tree',          'Runs Esquire tree interface');

SELECT 'Done' AS status;
