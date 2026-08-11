-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.12/forward.1st.sql
-- desc:	Forward migration to v1.2.12, PART 1 of 2 -- ADDITIVE ONLY
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives new create/ DDL on its own).
--
--		!! RUN THIS WHILE THE PREVIOUS RELEASE IS STILL SERVING !!
--		Nothing here is visible to code that does not ask for it: every column is
--		NEW, nothing is dropped, no trigger and no index is touched. A v1.2.11
--		service keeps running against this database exactly as before -- its
--		INSERTs never name these columns, and the defaults fill them.
--
--		THE ORDER, and why it is two files:
--		  1. run forward.1st.sql   -- the columns appear; the old release keeps serving
--		  2. deploy the v1.2.12 services and let them take over
--		  3. run forward.2nd.sql   -- the dead columns go, triggers and dedup indexes
--		                              are refreshed, DB_VERSION moves to 1.2.12
--		Run as ONE script against a live deployment and the old release breaks the
--		moment it is applied: the log column becomes NOT NULL while the running
--		audit writer does not supply it, ESQ_PERSON.PE_BI_PK disappears while the
--		running person statements still name it, and the log path columns disappear
--		while the installed triggers still write them.
--
--		What this part adds:
--		  1. *_CHANGE_NO BIGINT NOT NULL DEFAULT 1 on the eight entity / sub-entity
--		     tables and on ESQ_ENTITY_PATH. Adding a NOT NULL column WITH a default
--		     is a metadata-only operation in Postgres -- no table rewrite, existing
--		     rows read back as 1.
--		  2. ESQ_ACCT_TRANSACTION.ATR_ACC_CHANGE_NO, nullable.
--		  3. *_CHANGE_NO on the eight *_log tables, NULLABLE HERE ON PURPOSE. The
--		     running release writes log rows without it; those rows are back-filled
--		     and the column is tightened to NOT NULL in part 2, once the release
--		     that fills it is the one serving.
--
--		DB_VERSION is NOT moved here. The schema is only v1.2.12 after part 2, and
--		a deploy check that asserts the version must not pass in between.
--
--		Idempotent and re-runnable (every statement is IF EXISTS / IF NOT EXISTS).
--		Mirrors the fresh-seed DDL (create/tables.tab, create.log/tables.tab).
--
--		NOTE -- there is deliberately NO Oracle twin of this patch. We ship Oracle
--		the seed only: verifying against Oracle re-seeds the esq2025 schema from
--		scratch, so there is nothing to migrate.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.12/forward.1st.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 08/11/2026 mir0n v1.2.12 created: part 1 of the v1.2.12 migration -- the additive
--                  half, safe to run under the previous release
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n 'Adding *_CHANGE_NO to the entity tables\n'
-- ESQ_ENTITY_PATH gets its OWN counter, separate from the entity rows: a move rewrites every descendant
-- path row here while leaving those descendants' ESQ_ORG / ESQ_USER / ESQ_ACCOUNT rows untouched, so the
-- path is the only place a descendant's move can be counted.
ALTER TABLE IF EXISTS ESQ_ENTITY_PATH ADD COLUMN IF NOT EXISTS EP_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_ORG      ADD COLUMN IF NOT EXISTS ORG_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_USER     ADD COLUMN IF NOT EXISTS USR_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_ACCOUNT  ADD COLUMN IF NOT EXISTS ACC_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_AUTH     ADD COLUMN IF NOT EXISTS AU_CHANGE_NO  BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_PERSON   ADD COLUMN IF NOT EXISTS PE_CHANGE_NO  BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_ADDRESS  ADD COLUMN IF NOT EXISTS AD_CHANGE_NO  BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_USR_PAR  ADD COLUMN IF NOT EXISTS UPR_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;
ALTER TABLE IF EXISTS ESQ_ORG_PAR  ADD COLUMN IF NOT EXISTS OPR_CHANGE_NO BIGINT DEFAULT 1 NOT NULL;

-- ESQ_ACCT_TRANSACTION is the one place the number is a REFERENCE, not the row's own counter: it records
-- WHICH account history record this ledger line produced, so the two can be reconciled by number instead
-- of by time. The transaction row itself is written once and never updated, so it has no counter of its
-- own. Nullable with no default on purpose: it is informative rather than functional, and a row written
-- before this column existed has no honest value to carry.
ALTER TABLE IF EXISTS ESQ_ACCT_TRANSACTION ADD COLUMN IF NOT EXISTS ATR_ACC_CHANGE_NO BIGINT;

COMMENT ON COLUMN ESQ_ENTITY_PATH.EP_CHANGE_NO IS 'Change number of the path, raised on every path write. Its own counter, separate from the entity row: a move rewrites every descendant path here while leaving their entity rows untouched';
COMMENT ON COLUMN ESQ_ORG.ORG_CHANGE_NO      IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_USER.USR_CHANGE_NO     IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_ACCOUNT.ACC_CHANGE_NO  IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_AUTH.AU_CHANGE_NO      IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_PERSON.PE_CHANGE_NO    IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_ADDRESS.AD_CHANGE_NO   IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_USR_PAR.UPR_CHANGE_NO  IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_ORG_PAR.OPR_CHANGE_NO  IS 'Change number, raised on every update';
COMMENT ON COLUMN ESQ_ACCT_TRANSACTION.ATR_ACC_CHANGE_NO IS 'The ACCOUNT change number this transaction produced, so a ledger line points at the account history record it caused. Not a number of the transaction itself, which is written once and never changes. Informative, not functional: nullable, and empty on rows written before the column existed';

-- ---------------------------------------------------------------------------
-- The audit-log columns, NULLABLE here.
--
-- The release still serving writes its log rows without them, through the bus
-- writer or through the installed triggers -- either way the column has to
-- accept nothing. Part 2 back-fills those rows and sets NOT NULL, once the
-- release that supplies a number is the one running.
-- ---------------------------------------------------------------------------
\echo -n 'Adding *_CHANGE_NO to the audit-log tables (nullable in this part)\n'
ALTER TABLE IF EXISTS ESQ_ORG_LOG      ADD COLUMN IF NOT EXISTS ORGL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_USER_LOG     ADD COLUMN IF NOT EXISTS USRL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_ACCOUNT_LOG  ADD COLUMN IF NOT EXISTS ACCL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_AUTH_LOG     ADD COLUMN IF NOT EXISTS AUL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_PERSON_LOG   ADD COLUMN IF NOT EXISTS PEL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_ADDRESS_LOG  ADD COLUMN IF NOT EXISTS ADL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_USR_PAR_LOG  ADD COLUMN IF NOT EXISTS UPRL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_ORG_PAR_LOG  ADD COLUMN IF NOT EXISTS OPRL_CHANGE_NO BIGINT;

COMMENT ON COLUMN ESQ_ORG_LOG.ORGL_CHANGE_NO      IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_USER_LOG.USRL_CHANGE_NO     IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ACCOUNT_LOG.ACCL_CHANGE_NO  IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_AUTH_LOG.AUL_CHANGE_NO      IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_PERSON_LOG.PEL_CHANGE_NO    IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ADDRESS_LOG.ADL_CHANGE_NO   IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_USR_PAR_LOG.UPRL_CHANGE_NO  IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ORG_PAR_LOG.OPRL_CHANGE_NO  IS 'Change number of the logged row';

COMMIT;

\echo -n 'Part 1 done -- the columns are in place. Deploy v1.2.12, then run forward.2nd.sql\n'
