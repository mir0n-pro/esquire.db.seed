-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000, 2001, 2025
--
-- file :	fill/delete.sql
-- desc:	Delete fill data
--
-- History:
-- 02/28/2026 mir0n esq_address and esq_person deletes added
-----------------------------------
\echo -n 'DROP TABLE ESQ_TREE\n'
\qecho -n 'DROP TABLE ESQ_TREE\n'
DROP TABLE IF EXISTS esq_tree;

\echo -n 'Delete all data\n'
\qecho -n 'Delete all data\n'
DO $$
BEGIN
  DELETE FROM esq_usr_par;
  DELETE FROM esq_org_par;
  DELETE FROM esq_usr_role;
  DELETE FROM esq_auth;
  DELETE FROM esq_account;
  DELETE FROM esq_address;
  DELETE FROM esq_person;
  DELETE FROM esq_user;
  DELETE FROM esq_org;
  DELETE FROM esq_role_et;
  DELETE FROM esq_role_prm;
  DELETE FROM esq_role;
  DELETE FROM esq_permission;
  DELETE FROM esq_permission_type;
  DELETE FROM esq_parameter;
  DELETE FROM esq_entity_type;
  DELETE FROM esq_activity_type;
  COMMIT;
END $$;

\echo -n 'Done\n'
\qecho -n 'Done\n'
