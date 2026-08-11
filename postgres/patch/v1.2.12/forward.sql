-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.12/forward.sql
-- desc:	Forward migration to v1.2.12 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives new create/ DDL on its own).
--
--		v1.2.12 adds the per-entity CHANGE NUMBER and removes two dead objects:
--		  1. *_CHANGE_NO BIGINT NOT NULL DEFAULT 1 on the eight entity /
--		     sub-entity tables. Adding a NOT NULL column WITH a default is a
--		     metadata-only operation in Postgres -- no table rewrite, existing
--		     rows read back as 1.
--		  2. *_CHANGE_NO BIGINT NOT NULL on the eight *_log tables. Unlike every
--		     other log column this one is NOT nullable: a log record with no change
--		     number carries no order and cannot be deduplicated, which is the whole
--		     reason the column exists. Existing log rows are back-filled first --
--		     see the note above the back-fill for what the numbers mean.
--		  3. ESQ_BANK_INFO and ESQ_BANK_INFO_LOG dropped, with the ESQ_PERSON
--		     PE_BI_PK column, its foreign key and its index, and ESQ_PERSON_LOG
--		     PEL_BI_PK. Nothing in the framework ever read or wrote these.
--		  4. ESQ_ENTITY_SEQ dropped -- unused since v1.2.6, when entity keys moved
--		     to the application (time + instance + counter). ESQ_REF_SEQ STAYS:
--		     it is live, minting address keys.
--		  5. The audit triggers are re-created **only if this database already has
--		     them installed**. Where they are present this is REQUIRED, not a nicety:
--		     the old person trigger references PE_BI_PK (dropped in step 3), so every
--		     later ESQ_PERSON write would fail; and the old bodies do not carry
--		     *_CHANGE_NO, so the log would silently record NULL. Where they are NOT
--		     installed the database stays trigger-free: that deployment records its
--		     audit through the bus, and a patch refreshes the shape a database
--		     already has -- it does not move it onto another audit path.
--
--		!! UNLIKE v1.2.11 THIS PATCH IS NOT PURELY NON-DESTRUCTIVE !!
--		Step 3 and step 4 DROP objects. They are safe because nothing has ever
--		written to ESQ_BANK_INFO and nothing has read ESQ_ENTITY_SEQ since v1.2.6
--		-- but the drops are real, so read them before running this on a live DB.
--		Steps 1 and 2 are additive and never touch existing data.
--
--		Idempotent and re-runnable (every statement is IF EXISTS / IF NOT EXISTS).
--		Mirrors the fresh-seed DDL (create/tables.tab, create/tables.pfi,
--		create/tables.sqs, create.log/tables.tab) and DB_VERSION in fill/root.sql.
--
--		NOTE -- there is deliberately NO Oracle twin of this patch. Oracle is not a
--		production target: we ship Oracle the seed only, and verifying against
--		Oracle means re-seeding the esq2025 schema, so there is nothing to migrate.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.12/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 08/09/2026 mir0n v1.2.12 created: DB_VERSION 1.2.11 -> 1.2.12; *_CHANGE_NO on the
--                  eight entity tables and their *_log twins; ESQ_BANK_INFO /
--                  ESQ_BANK_INFO_LOG / PE_BI_PK / PEL_BI_PK / ESQ_ENTITY_SEQ removed
-- 08/10/2026 mir0n EP_CHANGE_NO on ESQ_ENTITY_PATH; ATR_ACC_CHANGE_NO on
--                  ESQ_ACCT_TRANSACTION (nullable -- a reference, not a counter);
--                  USRL_PATH / ORGL_PATH / ACCL_PATH dropped from the audit log
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

\echo -n 'Adding *_CHANGE_NO to the audit-log tables\n'
ALTER TABLE IF EXISTS ESQ_ORG_LOG      ADD COLUMN IF NOT EXISTS ORGL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_USER_LOG     ADD COLUMN IF NOT EXISTS USRL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_ACCOUNT_LOG  ADD COLUMN IF NOT EXISTS ACCL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_AUTH_LOG     ADD COLUMN IF NOT EXISTS AUL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_PERSON_LOG   ADD COLUMN IF NOT EXISTS PEL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_ADDRESS_LOG  ADD COLUMN IF NOT EXISTS ADL_CHANGE_NO  BIGINT;
ALTER TABLE IF EXISTS ESQ_USR_PAR_LOG  ADD COLUMN IF NOT EXISTS UPRL_CHANGE_NO BIGINT;
ALTER TABLE IF EXISTS ESQ_ORG_PAR_LOG  ADD COLUMN IF NOT EXISTS OPRL_CHANGE_NO BIGINT;

-- ---------------------------------------------------------------------------
-- Back-fill the log rows that already exist, then make the column NOT NULL.
--
-- The number given to an old row is its POSITION in that one row's own logged
-- history, oldest first: the first record of an entity gets 1, the next 2, and
-- so on. That is exactly what the column means from here on, so the old records
-- read the same way as the new ones -- but be clear about what it is: these
-- numbers are RECONSTRUCTED from the log's own order, not the numbers the rows
-- actually carried at the time (there were none). They are per entity, so two
-- different entities both start at 1.
--
-- A constant (every old row 0, say) would have been simpler but unusable: the
-- dedup overlay puts a UNIQUE index on (row, change number), and a constant
-- makes every entity with more than one logged record collide.
--
-- Ordered by the action timestamp, with ctid breaking exact ties so the result
-- is stable. Only rows with no number are touched, so a re-run changes nothing.
-- ---------------------------------------------------------------------------
\echo -n 'Back-filling *_CHANGE_NO on existing log rows\n'

UPDATE ESQ_ORG_LOG l SET ORGL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY ORGL_PK
                                                   ORDER BY ORGL_ACTION_TS, ctid) AS n
          FROM ESQ_ORG_LOG) r
 WHERE l.ctid = r.tid AND l.ORGL_CHANGE_NO IS NULL;

UPDATE ESQ_USER_LOG l SET USRL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY USRL_PK
                                                   ORDER BY USRL_ACTION_TS, ctid) AS n
          FROM ESQ_USER_LOG) r
 WHERE l.ctid = r.tid AND l.USRL_CHANGE_NO IS NULL;

UPDATE ESQ_ACCOUNT_LOG l SET ACCL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY ACCL_PK
                                                   ORDER BY ACCL_ACTION_TS, ctid) AS n
          FROM ESQ_ACCOUNT_LOG) r
 WHERE l.ctid = r.tid AND l.ACCL_CHANGE_NO IS NULL;

UPDATE ESQ_AUTH_LOG l SET AUL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY AUL_USR_PK
                                                   ORDER BY AUL_ACTION_TS, ctid) AS n
          FROM ESQ_AUTH_LOG) r
 WHERE l.ctid = r.tid AND l.AUL_CHANGE_NO IS NULL;

UPDATE ESQ_PERSON_LOG l SET PEL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY PEL_USR_PK, PEL_KIND
                                                   ORDER BY PEL_ACTION_TS, ctid) AS n
          FROM ESQ_PERSON_LOG) r
 WHERE l.ctid = r.tid AND l.PEL_CHANGE_NO IS NULL;

UPDATE ESQ_ADDRESS_LOG l SET ADL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY ADL_PK
                                                   ORDER BY ADL_ACTION_TS, ctid) AS n
          FROM ESQ_ADDRESS_LOG) r
 WHERE l.ctid = r.tid AND l.ADL_CHANGE_NO IS NULL;

UPDATE ESQ_USR_PAR_LOG l SET UPRL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY UPRL_USR_PK, UPRL_PAR_NAME
                                                   ORDER BY UPRL_ACTION_TS, ctid) AS n
          FROM ESQ_USR_PAR_LOG) r
 WHERE l.ctid = r.tid AND l.UPRL_CHANGE_NO IS NULL;

UPDATE ESQ_ORG_PAR_LOG l SET OPRL_CHANGE_NO = r.n
  FROM (SELECT ctid AS tid, row_number() OVER (PARTITION BY OPRL_ORG_PK, OPRL_PAR_NAME
                                                   ORDER BY OPRL_ACTION_TS, ctid) AS n
          FROM ESQ_ORG_PAR_LOG) r
 WHERE l.ctid = r.tid AND l.OPRL_CHANGE_NO IS NULL;

\echo -n 'Making the log *_CHANGE_NO columns NOT NULL\n'
ALTER TABLE IF EXISTS ESQ_ORG_LOG      ALTER COLUMN ORGL_CHANGE_NO SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_USER_LOG     ALTER COLUMN USRL_CHANGE_NO SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_ACCOUNT_LOG  ALTER COLUMN ACCL_CHANGE_NO SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_AUTH_LOG     ALTER COLUMN AUL_CHANGE_NO  SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_PERSON_LOG   ALTER COLUMN PEL_CHANGE_NO  SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_ADDRESS_LOG  ALTER COLUMN ADL_CHANGE_NO  SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_USR_PAR_LOG  ALTER COLUMN UPRL_CHANGE_NO SET NOT NULL;
ALTER TABLE IF EXISTS ESQ_ORG_PAR_LOG  ALTER COLUMN OPRL_CHANGE_NO SET NOT NULL;

COMMENT ON COLUMN ESQ_ORG_LOG.ORGL_CHANGE_NO      IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_USER_LOG.USRL_CHANGE_NO     IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ACCOUNT_LOG.ACCL_CHANGE_NO  IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_AUTH_LOG.AUL_CHANGE_NO      IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_PERSON_LOG.PEL_CHANGE_NO    IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ADDRESS_LOG.ADL_CHANGE_NO   IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_USR_PAR_LOG.UPRL_CHANGE_NO  IS 'Change number of the logged row';
COMMENT ON COLUMN ESQ_ORG_PAR_LOG.OPRL_CHANGE_NO  IS 'Change number of the logged row';

-- ---------------------------------------------------------------------------
-- Removing the entity path from the audit log.
--
-- A path is a POINT OF VIEW on the data, not the data itself: it says where a
-- row sits in the tree at the moment you look, and the tree is a separate thing
-- that changes on its own. An audit record of a row should hold what the row
-- was, not where it happened to be standing.
--
-- It was also unsupportable in practice. Only the DB-trigger path could fill it,
-- by sub-selecting ESQ_ENTITY_PATH inside the trigger. The bus audit paths are
-- ASYNCHRONOUS -- they write from a message, minutes later if a queue is deep,
-- and the message carries no path; a lookup at write time would read the path as
-- it is THEN, not as it was, so it would record a plausible falsehood. In the
-- default (bus) deployment the column was simply always NULL.
-- ---------------------------------------------------------------------------
\echo -n 'Removing the entity path from the audit log (a path is a view of the data, not the data)\n'
ALTER TABLE IF EXISTS ESQ_USER_LOG    DROP COLUMN IF EXISTS USRL_PATH;
ALTER TABLE IF EXISTS ESQ_ORG_LOG     DROP COLUMN IF EXISTS ORGL_PATH;
ALTER TABLE IF EXISTS ESQ_ACCOUNT_LOG DROP COLUMN IF EXISTS ACCL_PATH;

\echo -n 'Removing the bank-info objects (DROP -- see the header)\n'
ALTER TABLE IF EXISTS ESQ_PERSON DROP CONSTRAINT IF EXISTS ESQ_PE_BI_FK;
DROP INDEX IF EXISTS ESQ_PE_BI_FK_I;
ALTER TABLE IF EXISTS ESQ_PERSON     DROP COLUMN IF EXISTS PE_BI_PK;
ALTER TABLE IF EXISTS ESQ_PERSON_LOG DROP COLUMN IF EXISTS PEL_BI_PK;
DROP TABLE IF EXISTS ESQ_BANK_INFO_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_BANK_INFO CASCADE;

DROP FUNCTION IF EXISTS esq_bank_info_briud() CASCADE;

\echo -n 'Removing the unused ESQ_ENTITY_SEQ (ESQ_REF_SEQ stays -- it is live)\n'
DROP SEQUENCE IF EXISTS ESQ_ENTITY_SEQ;

-- ---------------------------------------------------------------------------
-- Audit triggers -- refreshed ONLY IF this database actually has them installed.
--
-- Two reasons this is not optional where they ARE present:
--   1. The OLD person trigger still references PE_BI_PK, which the step above just
--      dropped -- every later write to ESQ_PERSON would fail with
--      "record NEW has no field pe_bi_pk".
--   2. The old bodies do not carry *_CHANGE_NO, so the log rows would silently
--      come back NULL and the whole point of the change number would be lost.
--
-- Where they are NOT installed we leave the database trigger-free: that deployment
-- records its audit through the bus. Installing triggers here would start a second
-- recorder writing at a different grain, which is a change of audit strategy and not
-- a migration -- so this patch refreshes what is there and adds nothing.
-- ---------------------------------------------------------------------------
SELECT EXISTS (SELECT 1 FROM information_schema.triggers
                WHERE trigger_name LIKE 'esq%briud') AS has_triggers \gset

\if :has_triggers
\echo -n 'Audit triggers ARE installed -- re-creating all eight with the v1.2.12 bodies\n'
\ir ../../triggers/esq_address_briud.sql
\ir ../../triggers/esq_person_briud.sql
\ir ../../triggers/esq_user_briud.sql
\ir ../../triggers/esq_auth_briud.sql
\ir ../../triggers/esq_org_briud.sql
\ir ../../triggers/esq_account_briud.sql
\ir ../../triggers/esq_usr_par_briud.sql
\ir ../../triggers/esq_org_par_briud.sql
\else
\echo -n 'No audit triggers installed -- skipping the refresh (this database uses the bus audit path)\n'
\endif

\echo -n 'Updating DB_VERSION -> 1.2.12\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.12'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
