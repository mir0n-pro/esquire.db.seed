-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	oracle/patch/v1.2.10/forward.sql
-- desc:	Forward migration to v1.2.10 for an ALREADY-CREATED Oracle database
--		(the baked seed runs only on a fresh schema, so an existing DB never
--		receives new create/ DDL on its own).
--		v1.2.10 makes NO schema or seed-data change to an existing DB: the all.sql
--		change is Postgres fresh-seed-only, and the EP_PATH validate/recover script
--		(data-fix/fix-path.sql) is an on-demand utility, not a migration.
--		So this patch is ONLY the DB_VERSION bump. Idempotent, re-runnable, never
--		drops, never recreates the schema.
--
--		Apply on demand against the live DB (SQL*Plus):
--		  sqlplus esq2025/<pwd>@<tns> @oracle/patch/v1.2.10/forward.sql
--
-- 07/03/2026 mir0n v1.2.10 created: DB_VERSION 1.2.9 -> 1.2.10 (no schema change this release)
-----------------------------------

WHENEVER SQLERROR EXIT FAILURE

PROMPT Updating 'DB_VERSION -> 1.2.10'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.10'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0
/

COMMIT
/

PROMPT Done
