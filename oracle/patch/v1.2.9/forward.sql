-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	oracle/patch/v1.2.9/forward.sql
-- desc:	Forward migration to v1.2.9 for an ALREADY-CREATED Oracle database
--		(the baked seed runs only on a fresh schema, so an existing DB never
--		receives new create/ DDL on its own). Additive only, idempotent,
--		re-runnable. Never drops, never recreates the schema.
--		Mirrors the v1.2.9 seed DDL: create/tables.tab (the *_CREATED_TS
--		columns -- already present on Oracle since before v1.2.9, guarded here
--		so the patch is safe on any baseline), create/tables.pfi (the
--		ESQ_EP_PATH_I index), fill/root.sql (the DB_VERSION value).
--		Oracle has no ADD ... IF NOT EXISTS, so each step is wrapped in a
--		PL/SQL block that swallows "already exists" (ORA-01430 / ORA-00955).
--
--		Apply on demand against the live DB (SQL*Plus):
--		  sqlplus esq2025/<pwd>@<tns> @oracle/patch/v1.2.9/forward.sql
--
--		The optional audit time-range overlay (create.log/recommended.pfi,
--		the per-*_log *_ACTION_TS indexes) is NOT part of this patch -- apply
--		it separately, on demand, where audit range queries matter at scale.
--
-- 06/25/2026 mir0n v1.2.9 created: *_CREATED_TS columns + ESQ_EP_PATH_I index + DB_VERSION 1.2.9
-----------------------------------

WHENEVER SQLERROR EXIT FAILURE

PROMPT Adding Column 'ESQ_USER.USR_CREATED_TS'
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE ESQ_USER ADD (USR_CREATED_TS TIMESTAMP DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- ORA-01430: column already exists
END;
/
PROMPT Adding Column 'ESQ_ORG.ORG_CREATED_TS'
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE ESQ_ORG ADD (ORG_CREATED_TS TIMESTAMP DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- ORA-01430: column already exists
END;
/
PROMPT Adding Column 'ESQ_ACCOUNT.ACC_CREATED_TS'
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE ESQ_ACCOUNT ADD (ACC_CREATED_TS TIMESTAMP DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP))';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1430 THEN RAISE; END IF;  -- ORA-01430: column already exists
END;
/

COMMENT ON COLUMN ESQ_USER.USR_CREATED_TS    IS 'Entity created timestamp'
/
COMMENT ON COLUMN ESQ_ORG.ORG_CREATED_TS     IS 'Entity created timestamp'
/
COMMENT ON COLUMN ESQ_ACCOUNT.ACC_CREATED_TS IS 'Entity created timestamp'
/

PROMPT Creating Index 'ESQ_EP_PATH_I'
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX ESQ_EP_PATH_I ON ESQ_ENTITY_PATH (EP_PATH)';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;  -- ORA-00955: name already used
END;
/

PROMPT Updating 'DB_VERSION -> 1.2.9'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.9'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0
/

COMMIT
/

PROMPT Done
