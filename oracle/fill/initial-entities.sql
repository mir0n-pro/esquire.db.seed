PROMPT Inital organizations
INSERT INTO esq_org (org_pk, org_et_pk, org_name, org_path, org_full_name,   org_org_pk, org_desc) 
       VALUES       (2,      10,       'Company', '1',      'Inital company', 1,         NULL)
/
INSERT INTO esq_org (org_pk, org_et_pk, org_name,     org_path ,org_full_name,      org_org_pk, org_desc) 
       VALUES       (3,             10, 'Department', '1.2',   'Inital department', 2,          NULL)
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
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(4, 16, 'Supervizor', '1','supervizor', 'na', 1, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(4, 'Y', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       VALUES(4, 1, 'Y')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 4, prm_pk, 'Y' FROM esq_permission WHERE prm_et_pk_usr = 16
/
COMMIT
/

PROMPT Support
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(5, 16, 'Support', '1.2','support', 'na', 2, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(5, 'Y', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 5, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 16
/
UPDATE esq_usr_prm SET upm_allowed_flg = 'Y' WHERE upm_usr_pk = 5 AND upm_prm_pk = 23
/
COMMIT
/


PROMPT Office Manager
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(6, 16, 'Office Manager', '1.2','officeadmin', 'na', 2, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(6, 'Y', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 6, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 16
/
UPDATE esq_usr_prm SET upm_allowed_flg = 'Y' WHERE upm_usr_pk = 6 AND upm_prm_pk = 23
/
COMMIT
/



PROMPT Merchant
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(7, 14, 'Merchant', '1.2','merchant', 'na', 2, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(7, 'Y', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 7, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 14
/
COMMIT
/

PROMPT Department Manager
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(8, 16, 'Department Manager', '1.2','officeadmin', 'na', 3, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(8, 'Y', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 8, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 16
/
UPDATE esq_usr_prm SET upm_allowed_flg = 'Y' WHERE upm_usr_pk = 8 AND upm_prm_pk = 23
/
COMMIT
/

PROMPT Client
INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(9, 12, 'Client', '1.2.3','client', 'na', 3, 'N', NULL)
/
INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(9, 'N', 'N')
/
INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 9, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 12
/
INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value) 
       VALUES           (9,         'Example',     12,            'Example for Esquire')
/

COMMIT
/

PROMPT Accounts
INSERT INTO esq_account (acc_pk, acc_et_pk, acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk, acc_desc) 
       VALUES(10, 20, '1.2.6', '10008', 0.00, 'EUR', 'O', 7, 'Merchant account') 
/
INSERT INTO esq_account (acc_pk, acc_et_pk, acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk, acc_desc) 
       VALUES(11, 18, '1.2.3.7', '10009', 0.00, 'USD', 'O', 9, 'Client account') 
/
COMMIT
/

