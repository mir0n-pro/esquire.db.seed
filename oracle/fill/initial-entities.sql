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
-- 02/28/2026 mir0n esq_person inserts added for all seed users
--                  esq_address inserts added for merchant and client

PROMPT Inital organizations
	INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_path,         org_full_name,   org_org_pk,     org_desc) 
       VALUES                (2,        20,    'Company',     '1.2.',      'Inital company',            1,         NULL);
	INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_path,         org_full_name,   org_org_pk,      org_desc) 
       VALUES                (3,        20, 'Department',   '1.2.3.',    'Inital department',           2,          NULL);
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (2,         'Example',     20,            'Example for Company Esquire');
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (3,         'Example',     20,            'Example for Company Esquire');
	COMMIT;


PROMPT SysAdmin
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (4,        30,        'System Administrator',      '1.',           'na',          1,             'N',    NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(4, 'Y', 'N',      'system',   'mir0n.the.programmer4@gmail.com');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email)
       VALUES( 4, 992, 'System','Administrator', 'mir0n.the.programmer4@gmail.com');
    -- SYSADMIN
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        4,  1);
-- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        4,  8);
	COMMIT;


PROMPT Supervizor
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (5,        32,        'Super Vizor',      '1.',           'na',          1,             'N',    NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(5, 'Y', 'N',      'mainadmin',   'mir0n.the.programmer.5@gmail.com');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email)
       VALUES( 5, 992, 'Super','Vizor', 'mir0n.the.programmer.5@gmail.com');
    -- SUPERVIZOR
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        5,  2);
-- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        5,  8);
	COMMIT;

PROMPT Support
  INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (6,        32,           'Sup Port',    '1.2.',           'na',         2,             'N',     NULL);
  INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(6, 'Y', 'N',        'support', 'mir0n.the.programmer.6@gmail.com');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email)
       VALUES( 6, 992, 'Sup','Port', 'mir0n.the.programmer.6@gmail.com');
  -- SUPPORT
  INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
         VALUES            (        6,  5);
  -- TREE
  INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
         VALUES            (        6,  8);
  COMMIT;


PROMPT Office Manager
  INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (7,        32,      'Office Manager',   '1.2.',           'na',          2,             'N',     NULL);
  INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(7, 'Y', 'N',     'officeadmin', 'mir0n.the.programmer.7@gmail.com');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email)
       VALUES( 7, 992, 'Office','Manager', 'mir0n.the.programmer.7@gmail.com');
  -- MANAGER
  INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
         VALUES            (        7,  3);
  -- TREE
  INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
         VALUES            (        7,  8);
  COMMIT;


PROMPT Merchant
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (8,        36,          'Mer Chant',  '1.2.8.',           'na',          2,             'N',     NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(8, 'Y', 'N',       'merchant', 'mir0n.the.programmer.8@gmail.com');
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES( 1, 'Street', 'City','Country', 'Postal address');
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES( 2, 'Street', 'City','Country', 'Biz address');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email, pe_ad_pk, pe_ad_pk_biz)
       VALUES( 8, 992, 'Mer','Chant', 'mir0n.the.programmer.8@gmail.com', 1, 2);
    -- MERCHANT
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        8,  7);
    -- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        8,  8);
	COMMIT;

PROMPT Department Manager
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (9,        32, 'Department Manager',  '1.2.3.',           'na',          3,             'N',     NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(9, 'Y', 'N','departmentadmin', 'mir0n.the.programmer.9@gmail.com');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email)
       VALUES( 9, 992, 'Department','Manager', 'mir0n.the.programmer.9@gmail.com');
    -- MANAGER
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        9,  3);
    -- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        9,  8);
	COMMIT;

PROMPT Client
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name,  usr_path, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
                       VALUES(10,        34,            'Cli Ent', '1.2.3.10.',           'na',          3,             'N',     NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(10, 'N', 'N',        'client', 'mir0n.the.programmer.10@gmail.com');
	INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value)
       VALUES           (10,         'Example',     34,           'Example for Esquire');
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES( 3, 'Street', 'City','Country', 'Postal address');
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES( 4, 'Street', 'City','Country', 'Biz address');
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email, pe_ad_pk, pe_ad_pk_biz)
       VALUES(10, 992, 'Cli','Ent', 'mir0n.the.programmer.10@gmail.com', 3, 4);
    -- CLIENT
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        10,  6);
    -- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK) 
           VALUES            (        10,  8);
	COMMIT;

PROMPT Accounts
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path,  acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
                          VALUES(11,        52,   '1.2.8.', '10011',        0.00,   'EUR',        'O',          8, 'Merchant account');
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path,  acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
                          VALUES(12,        50, '1.2.3.10.', '10012',        0.00,   'USD',         'O',         10,   'Client account');
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_path,  acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc) 
                          VALUES(13,        54, '1.2.3.10.', '10013',        0.00,   'USD',         'O',         10,   'Paper Client account');
	COMMIT;

