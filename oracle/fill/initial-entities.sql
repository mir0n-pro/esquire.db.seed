-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2025
--
-- file :	fill/esq_permission_type.sql
-- desc:	Fills esq_permission_type table
--
-----------------------------------
-- History:
-- 01/14/2026 mir0n follow up to ERD modifications

PROMPT Inital organizations
INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_path,       org_full_name, org_org_pk, org_desc) 
       VALUES       (     2,        10,    'Company',   '1.2.',    'Inital company',          1,     NULL)
/
INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_path,       org_full_name, org_org_pk, org_desc) 
       VALUES       (     3,        10, 'Department', '1.2.3.', 'Inital department',          2,     NULL)
/
INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (2,         'Example',     10,            'Example for Company Esquire')
/
INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (3,         'Example',     10,            'Example for Company Esquire')
/

COMMIT
/

PROMPT Supervizor
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(             4,        16,        'Super Vizor',       '1.',           'na',          1,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(4, 'Y', 'N',      'supervizor',  'mir0n.the.programmer@gmail.com')
/
-- SUPERVIZOR
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        4,  1)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        4,  6)
/
COMMIT
/

PROMPT Support
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(             5,        16,           'Sup Port',     '1.2.',           'na',          2,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(5, 'Y', 'N',         'support',  'mir0n.the.programmer.5@gmail.com')
/
-- SUPPORT
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        5,  4)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        5,  6)
/
COMMIT
/


PROMPT Office Manager
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(             6,        16,     'Office Manager',     '1.2.',           'na',          2,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(6, 'Y', 'N',     'officeadmin',  'mir0n.the.programmer.6@gmail.com')
/
-- MANAGER
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        6,  2)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        6,  6)
/
COMMIT
/



PROMPT Merchant
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES             (7,        14,          'Mer Chant',   '1.2.7.',           'na',          2,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(7, 'Y', 'N',        'merchant',  'mir0n.the.programmer.7@gmail.com')
/
-- ENDUSER
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        7,  5)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        7,  6)
/
COMMIT
/

PROMPT Department Manager
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(             8,        16, 'Department Manager',   '1.2.3.',           'na',          3,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(8, 'Y', 'N', 'departmentadmin',  'mir0n.the.programmer.8@gmail.com')
/
-- MANAGER
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        8,  2)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        8,  6)
/
COMMIT
/

PROMPT Client
INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,   usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(             9,        12,            'Cli Ent', '1.2.3.9.',           'na',          3,             'N',     NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email) 
       VALUES(9, 'N', 'N',          'client',  'mir0n.the.programmer.9@gmail.com')
/
INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value) 
       VALUES           (9,         'Example',     12,            'Example for Esquire')
/

-- ENDUSER
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        9,  5)
/
-- TREE
INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
       VALUES            (        9,  6)
/
COMMIT
/

PROMPT Accounts
INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
       VALUES(               10,        20,   '1.2.7.', '10010',       0.00,   'EUR',        'O',          7, 'Merchant account') 
/
INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
       VALUES(               11,        18, '1.2.3.9.', '10011',       0.00,   'USD',        'O',          9,   'Client account') 
/
INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
       VALUES(               12,        22, '1.2.3.9.', '10012',       0.00,   'USD',        'O',          9,   'Paper Client account') 
/
COMMIT
/

