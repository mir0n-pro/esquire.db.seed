

DO $$
BEGIN
	INSERT INTO esq_entity_path (ep_pk, ep_path) VALUES (1, '1.');
	INSERT INTO esq_org (org_pk, org_et_pk,  org_name,          org_full_name,  org_org_pk,  org_desc)
       VALUES                (1,         0, 'Esquire',     'Esquire System',        NULL,      NULL);

	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (1,         'DB_NAME',     0,            'Esquire');
       
	INSERT INTO esq_org_par (opr_org_pk, opr_par_name, opr_par_et_pk, opr_value) 
       VALUES           (1,          'DB_VERSION', 0,             '1.2.10');

	COMMIT;
END $$;
	
\echo -n 'Done\n'
\qecho -n 'Done\n'

