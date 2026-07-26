-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.11/forward.sql
-- desc:	Forward migration to v1.2.11 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives new create/ DDL on its own).
--		v1.2.11 makes three small schema-DEFINITION changes, each mirroring the
--		create/ DDL and all NON-DESTRUCTIVE (no data change, no reseed):
--		  1. ESQ_ACCT_TRANSACTION.ATR_TS gains a server-side default
--		     (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') -- a new ledger row is stamped
--		     even when the caller omits ATR_TS. Existing rows are UNTOUCHED
--		     (SET DEFAULT affects only future inserts, never a backfill).
--		  2. ESQ_PARAMETER.PAR_TYPE default corrected 'STRING' -> 'string' so it
--		     matches the ESQ_PAR_TYPE_CC check (the old upper-case default would
--		     fail the check on any insert that omitted the column).
--		  3. FK index UR_ROLE_FK_FK_I renamed to UR_ROLE_FK_I (naming typo; the
--		     index + its data are unchanged, only the object name).
--		Idempotent, re-runnable, never drops, never reseeds. Mirrors the fresh-seed
--		DDL (create/tables.tab, create/tables.pfi) and the DB_VERSION in fill/root.sql.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.11/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 07/23/2026 mir0n v1.2.11 created: DB_VERSION 1.2.10 -> 1.2.11; ATR_TS server-side
--                  default, PAR_TYPE default 'STRING'->'string', UR_ROLE_FK_I index rename
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n 'Setting default ESQ_ACCT_TRANSACTION.ATR_TS -> CURRENT_TIMESTAMP (UTC)\n'
ALTER TABLE ESQ_ACCT_TRANSACTION
  ALTER COLUMN ATR_TS SET DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

\echo -n 'Correcting default ESQ_PARAMETER.PAR_TYPE -> ''string''\n'
ALTER TABLE ESQ_PARAMETER
  ALTER COLUMN PAR_TYPE SET DEFAULT 'string';

\echo -n 'Renaming index UR_ROLE_FK_FK_I -> UR_ROLE_FK_I (if present)\n'
ALTER INDEX IF EXISTS UR_ROLE_FK_FK_I RENAME TO UR_ROLE_FK_I;

\echo -n 'Updating DB_VERSION -> 1.2.11\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.11'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
