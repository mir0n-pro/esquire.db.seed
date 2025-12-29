

\echo -n 'Inital organizations\n'
\qecho -n 'Inital organizations\n'

DO $$
BEGIN
	INSERT INTO esq_org (org_pk, org_et_pk, org_name, org_path, org_full_name,   org_org_pk, org_desc) 
       VALUES       (2,      10,       'Company', '1',      'Inital company', 1,         NULL);
	INSERT INTO esq_org (org_pk, org_et_pk, org_name,     org_path ,org_full_name,      org_org_pk, org_desc) 
       VALUES       (3,             10, 'Department', '1.2',   'Inital department', 2,          NULL);
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (2,         'Example',     10,            'Example for Company Esquire');
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (3,         'Example',     10,            'Example for Company Esquire');
	COMMIT;
END $$;

\echo -n 'Supervizor\n'
\qecho -n 'Supervizor\n'
DO $$
BEGIN
	INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(4, 16, 'Supervizor', '1','SUPERVIZOR', 'na', 1, 'N', NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(4, 'N', 'N');
	-- INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
  --     VALUES(4, 1, 'Y');
	INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 4, prm_pk, 'Y' FROM esq_permission WHERE prm_et_pk_usr = 16;
	COMMIT;
END $$;

\echo -n 'Support\n'
\qecho -n 'Support\n'
DO $$
BEGIN
	INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(5, 16, 'Support', '1.2','SUPPORT', 'na', 2, 'N', NULL);
  INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(5, 'N', 'N');
	INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 5, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 16;
	UPDATE esq_usr_prm SET upm_allowed_flg = 'Y' WHERE upm_usr_pk = 5 AND upm_prm_pk = 23;
	COMMIT;
END $$;

\echo -n 'Merchant\n'
\qecho -n 'Merchant\n'
DO $$
BEGIN
	INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(6, 14, 'Merchant', '1.2','MERCHANT', 'na', 2, 'N', NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(6, 'N', 'N');
	INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 6, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 14;
	COMMIT;
END $$;

\echo -n 'Client\n'
\qecho -n 'Client\n'
DO $$
BEGIN
	INSERT INTO esq_user (usr_pk, usr_et_pk, usr_name, usr_path, usr_login_id, usr_reg_option, usr_org_pk, usr_deleted_flg, usr_desc) 
       VALUES(7, 12, 'Client', '1.2.3','CLIENT', 'na', 3, 'N', NULL);
	INSERT INTO esq_auth (au_usr_pk, au_connect_flg, au_tfa_method) 
       VALUES(7, 'N', 'N');
	INSERT INTO esq_usr_prm (upm_usr_pk, upm_prm_pk, upm_allowed_flg) 
       SELECT 7, prm_pk, 'N' FROM esq_permission WHERE prm_et_pk_usr = 12;
	INSERT INTO esq_usr_par (upr_usr_pk, upr_par_name, upr_par_et_pk, upr_value) 
       VALUES           (7,         'Example',     12,            'Example for Esquire');
	COMMIT;
END $$;

\echo -n 'Accounts\n'
\qecho -n 'Accounts\n'
DO $$
BEGIN
	INSERT INTO esq_account (acc_pk, acc_et_pk, acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk, acc_desc) 
       VALUES(8, 20, '1.2.6', '10008', 0.00, 'EUR', 'O', 6, 'Merchant account');
	INSERT INTO esq_account (acc_pk, acc_et_pk, acc_path, acc_id, acc_balance, acc_ccy, acc_status, acc_usr_pk, acc_desc) 
       VALUES(9, 18, '1.2.3.7', '10009', 0.00, 'USD', 'O', 7, 'Client account');
	COMMIT;
END $$;

\echo -n 'Done\n'
\qecho -n 'Done\n'

