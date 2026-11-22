-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v2.0.2/forward.sql
-- desc:	Forward migration to v2.0.2 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives a fill/ change on its own).
--		v2.0.2 keeps every login id in lower case, as KeyCloak keeps its user
--		names: a lookup by login id is an exact match on the unique key.
--		  1. ESQ_AUTH.AU_LOGIN_ID lower-cased on every row not in lower case yet;
--		     each such row gets its change number raised, as any write does (the
--		     audit trigger logs it, and the dedup index is keyed on that number).
--		     Two login ids that differ only in case stop the patch on the unique
--		     key ESQ_AUTH_LOGIN_ID_UK, and nothing is changed.
--		  2. DB_VERSION -> 2.0.2.
--		Idempotent, re-runnable, never drops, never reseeds. Mirrors the fresh-seed
--		data (fill/initial-entities.sql) and the DB_VERSION in fill/root.sql.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v2.0.2/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 11/21/2026 mir0n v2.0.2 created: AU_LOGIN_ID lower case; DB_VERSION 1.2.15 -> 2.0.2
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n 'Lower-casing ESQ_AUTH.AU_LOGIN_ID\n'
UPDATE ESQ_AUTH
   SET AU_LOGIN_ID  = LOWER(AU_LOGIN_ID)
      ,AU_CHANGE_NO = AU_CHANGE_NO + 1
 WHERE AU_LOGIN_ID <> LOWER(AU_LOGIN_ID);

\echo -n 'Updating DB_VERSION -> 2.0.2\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '2.0.2'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
