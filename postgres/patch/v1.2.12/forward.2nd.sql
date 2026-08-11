-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.12/forward.2nd.sql
-- desc:	Forward migration to v1.2.12, PART 2 of 2 -- REMOVALS AND REFRESHES
--
--		!! RUN THIS ONLY ONCE THE v1.2.12 SERVICES ARE SERVING !!
--		Everything here assumes the release that supplies a change number is the
--		one writing. Run it under v1.2.11 and that release breaks immediately:
--		  - the log column becomes NOT NULL, and the v1.2.11 audit writer never
--		    names it -- every audit write fails
--		  - ESQ_PERSON.PE_BI_PK goes, and the v1.2.11 person statements name it
--		  - the log path columns go, and the v1.2.11 triggers write them
--
--		THE ORDER:
--		  1. run forward.1st.sql   -- the columns appear; the old release keeps serving
--		  2. deploy the v1.2.12 services and let them take over
--		  3. run forward.2nd.sql   -- this file
--
--		What this part does:
--		  1. Back-fills *_CHANGE_NO on the log rows written before the number
--		     existed (and on anything the previous release wrote between part 1 and
--		     now), then makes the column NOT NULL. A log record with no change
--		     number carries no order and cannot be deduplicated, which is the whole
--		     reason the column exists.
--		  2. Drops USRL_PATH / ORGL_PATH / ACCL_PATH from the audit log.
--		  3. Drops ESQ_BANK_INFO and ESQ_BANK_INFO_LOG, with ESQ_PERSON.PE_BI_PK,
--		     its foreign key and its index, and ESQ_PERSON_LOG.PEL_BI_PK. Nothing in
--		     the framework ever read or wrote these.
--		  4. Drops ESQ_ENTITY_SEQ -- unused since v1.2.6, when entity keys moved to
--		     the application (time + instance + counter). ESQ_REF_SEQ STAYS: it is
--		     live, minting address keys.
--		  5. Re-creates the audit triggers, and re-creates the dedup unique indexes,
--		     EACH ONLY IF this database already has them installed. Refreshing what
--		     is there is a migration; adding what is not there would be a change of
--		     audit strategy, which a patch has no business making.
--		  6. Moves DB_VERSION to 1.2.12. The schema is only v1.2.12 from here.
--
--		!! THIS PART DROPS OBJECTS !! Steps 2-4 are real removals. They are safe --
--		nothing has ever written to ESQ_BANK_INFO, nothing has read ESQ_ENTITY_SEQ
--		since v1.2.6, and the path columns were only ever filled by the trigger
--		route -- but read them before running this on a live DB.
--
--		Idempotent and re-runnable (every statement is IF EXISTS / IF NOT EXISTS,
--		and the back-fill touches only rows that still have no number).
--		Mirrors the fresh-seed DDL (create/tables.tab, create/tables.pfi,
--		create/tables.sqs, create.log/tables.tab) and DB_VERSION in fill/root.sql.
--
--		NOTE -- there is deliberately NO Oracle twin of this patch. We ship Oracle
--		the seed only: verifying against Oracle re-seeds the esq2025 schema from
--		scratch, so there is nothing to migrate.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.12/forward.2nd.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 08/11/2026 mir0n v1.2.12 created: part 2 of the v1.2.12 migration -- the removals,
--                  the trigger and dedup-index refresh, and DB_VERSION 1.2.11 -> 1.2.12
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

-- ---------------------------------------------------------------------------
-- Back-fill the log rows written without a number, then make the column NOT NULL.
--
-- The number given to such a row is its POSITION in that one row's own logged
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
\echo -n 'Back-filling *_CHANGE_NO on log rows written without one\n'

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
-- it is THEN, not as it was, so it would record a plausible falsehood.
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
--   2. The old bodies do not carry *_CHANGE_NO, so the log rows would come back
--      NULL against a column this file just made NOT NULL.
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

-- ---------------------------------------------------------------------------
-- Dedup indexes -- rebuilt ONLY IF this database already has the overlay installed.
--
-- The key is the ROW plus its CHANGE NUMBER, so an index built on the old key
-- would go on deduplicating by the request that caused the change: two real
-- changes made under one request would collide and the second would be dropped.
-- The index can only be built now, after the back-fill above -- a NULL change
-- number cannot take part in the key.
-- ---------------------------------------------------------------------------
SELECT EXISTS (SELECT 1 FROM pg_indexes
                WHERE indexname ILIKE 'esq\_%\_log\_dedup\_uk') AS has_dedup \gset

\if :has_dedup
\echo -n 'Dedup overlay IS installed -- rebuilding the eight indexes on the new key\n'
\ir ../../dedup/drop.sql
\ir ../../dedup/all.sql
\else
\echo -n 'No dedup overlay installed -- skipping the rebuild\n'
\endif

\echo -n 'Updating DB_VERSION -> 1.2.12\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.12'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Part 2 done -- the schema is v1.2.12\n'
