-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v2.0.3/forward.sql
-- desc:	Forward migration to v2.0.3 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives a fill/ change on its own).
--		v2.0.3 runs one kind of sign-in, OAuth, so the two token relay test
--		drivers have no client left in KeyCloak:
--		  1. Test Driver S (usr_pk=16) and Test Driver M (usr_pk=17) removed:
--		     their roles, parameters, person, auth, user and entity path rows.
--		     An account or a sub-entity still held by either one stops the patch
--		     on its foreign key, and nothing is changed.
--		  2. DB_VERSION -> 2.0.3.
--		Idempotent, re-runnable, never drops, never reseeds. Mirrors the fresh-seed
--		data (fill/initial-entities.sql) and the DB_VERSION in fill/root.sql.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v2.0.3/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 11/24/2026 mir0n v2.0.3 created: Test Drivers S and M (usr_pk=16,17) removed; DB_VERSION 2.0.2 -> 2.0.3
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n 'Removing Test Drivers S and M (usr_pk=16,17)\n'
DELETE FROM ESQ_USR_ROLE    WHERE UR_USR_PK  IN (16, 17);
DELETE FROM ESQ_USR_PAR     WHERE UPR_USR_PK IN (16, 17);
DELETE FROM ESQ_PERSON      WHERE PE_USR_PK  IN (16, 17);
DELETE FROM ESQ_AUTH        WHERE AU_USR_PK  IN (16, 17);
DELETE FROM ESQ_USER        WHERE USR_PK     IN (16, 17);
DELETE FROM ESQ_ENTITY_PATH WHERE EP_PK      IN (16, 17);

\echo -n 'Updating DB_VERSION -> 2.0.3\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '2.0.3'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
