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
-- 03/08/2026 mir0n personal custom parameter test case

PROMPT Inital organizations
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (2, 20, '1.2.');
	INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_full_name,   org_org_pk,     org_desc)
       VALUES                (2,        20,    'Company', 'Inital company',            1,         NULL);
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (3, 20, '1.2.3.');
	INSERT INTO esq_org (org_pk, org_et_pk,     org_name, org_full_name,   org_org_pk,      org_desc)
       VALUES                (3,        20, 'Department', 'Inital department',           2,          NULL);
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (2,         'Example',     20,            'Example for Company Esquire');
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (3,         'Example',     20,            'Example for Company Esquire');
	COMMIT;


PROMPT SysAdmin
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (4, 30, '1.');
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (4,        30,        'System Administrator',           'na',          1,             'N',    NULL);
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
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (5, 32, '1.');
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (5,        32,        'Super Vizor',           'na',          1,             'N',    NULL);
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
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (6, 32, '1.2.');
  INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (6,        32,           'Sup Port',           'na',         2,             'N',     NULL);
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
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (7, 32, '1.2.');
  INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (7,        32,      'Office Manager',           'na',          2,             'N',     NULL);
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
DECLARE
    v_ad1 NUMBER;
    v_ad2 NUMBER;
BEGIN
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (8, 36, '1.2.8.');
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (8,        36,          'Mer Chant',           'na',          2,             'N',     NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(8, 'Y', 'N',       'merchant', 'mir0n.the.programmer.8@gmail.com');
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES(ESQ_REF_SEQ.NEXTVAL, 'Street', 'City','Country', 'Postal address') RETURNING ad_pk INTO v_ad1;
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES(ESQ_REF_SEQ.NEXTVAL, 'Street', 'City','Country', 'Biz address') RETURNING ad_pk INTO v_ad2;
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email, pe_ad_pk, pe_ad_pk_biz)
       VALUES( 8, 992, 'Mer','Chant', 'mir0n.the.programmer.8@gmail.com', v_ad1, v_ad2);
    -- MERCHANT
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK)
           VALUES            (        8,  7);
    -- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK)
           VALUES            (        8,  8);
	COMMIT;
END;
/

PROMPT Department Manager
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (9, 32, '1.2.3.');
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
       VALUES                 (9,        32, 'Department Manager',           'na',          3,             'N',     NULL);
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
DECLARE
    v_ad1 NUMBER;
    v_ad2 NUMBER;
BEGIN
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (10, 34, '1.2.3.10.');
	INSERT INTO esq_user (usr_pk, usr_et_pk,             usr_name, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc)
                       VALUES(10,        34,            'Cli Ent',           'na',          3,             'N',     NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method, au_login_id, au_email)
       VALUES(10, 'N', 'N',        'client', 'mir0n.the.programmer.10@gmail.com');
	INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value)
       VALUES           (10,         'Example',     34,           'Non-personal example');
	INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value)
       VALUES           (10,         'P_Example',     34,           'Personal example');

	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES(ESQ_REF_SEQ.NEXTVAL, 'Street', 'City','Country', 'Postal address') RETURNING ad_pk INTO v_ad1;
	INSERT INTO esq_address (ad_pk, ad_addr, ad_city, ad_country, ad_desc)
       VALUES(ESQ_REF_SEQ.NEXTVAL, 'Street', 'City','Country', 'Biz address') RETURNING ad_pk INTO v_ad2;
	INSERT INTO esq_person (pe_usr_pk, pe_kind, pe_first_name, pe_last_name, pe_email, pe_ad_pk, pe_ad_pk_biz)
       VALUES(10, 992, 'Cli','Ent', 'mir0n.the.programmer.10@gmail.com', v_ad1, v_ad2);
    -- CLIENT
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK)
           VALUES            (        10,  6);
    -- TREE
    INSERT INTO esq_usr_role (UR_USR_PK, UR_ROLE_PK)
           VALUES            (        10,  8);
	COMMIT;
END;
/

PROMPT Accounts
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (11, 52, '1.2.8.');
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc)
                          VALUES(11,        52,  '10011',        0.00,   'EUR',        'O',          8, 'Merchant account');
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (12, 50, '1.2.3.10.');
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc)
                          VALUES(12,        50,  '10012',        0.00,   'USD',         'O',         10,   'Client account');
	INSERT INTO esq_entity_path (ep_pk, ep_et_pk, ep_path) VALUES (13, 54, '1.2.3.10.');
	INSERT INTO esq_account (acc_pk, acc_et_pk,   acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk,           acc_desc)
                          VALUES(13,        54,  '10013',        0.00,   'USD',         'O',         10,   'Paper Client account');
	COMMIT;

