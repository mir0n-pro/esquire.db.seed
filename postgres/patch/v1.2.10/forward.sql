-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.10/forward.sql
-- desc:	Forward migration to v1.2.10 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives new create/ DDL on its own).
--		v1.2.10 makes NO schema or seed-data change to an existing DB: the all.sql
--		aggregator rewrite is fresh-seed-only, and the EP_PATH validate/recover
--		script (data-fix/fix-path.sql) is an on-demand utility, not a migration.
--		So this patch is ONLY the DB_VERSION bump. Idempotent, re-runnable, never
--		drops, never reseeds.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.10/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 07/03/2026 mir0n v1.2.10 created: DB_VERSION 1.2.9 -> 1.2.10 (no schema change this release)
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n Updating 'DB_VERSION -> 1.2.10\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.10'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
