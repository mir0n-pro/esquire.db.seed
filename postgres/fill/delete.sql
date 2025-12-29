\echo -n 'DROP TABLE ESQ_TREE\n'
\qecho -n 'DROP TABLE ESQ_TREE\n'
DROP TABLE IF EXISTS esq_tree;

\echo -n 'Delete all data\n'
\qecho -n 'Delete all data\n'
DO $$
BEGIN
  DELETE FROM esq_usr_prm;
  DELETE FROM esq_usr_par;
  DELETE FROM esq_org_par;
  DELETE FROM esq_permission;
  DELETE FROM esq_auth;
  DELETE FROM esq_account;
  DELETE FROM esq_user;
  DELETE FROM esq_org;
  DELETE FROM esq_permission_type;
  DELETE FROM esq_parameter;
  DELETE FROM esq_entity_type;
  DELETE FROM esq_activity_type;
  COMMIT;
END $$;

\echo -n 'Done\n'
\qecho -n 'Done\n'
