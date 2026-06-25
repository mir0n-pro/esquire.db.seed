-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v1.2.9/forward.sql
-- desc:	Forward migration to v1.2.9 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives new create/ DDL on its own).
--		Additive only, idempotent, re-runnable. Never reseeds, never drops.
--		Mirrors the v1.2.9 seed DDL: create/tables.tab (the *_CREATED_TS
--		columns), create/tables.pfi (the ESQ_EP_PATH_I index), fill/root.sql
--		(the DB_VERSION value).
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v1.2.9/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
--		The optional audit time-range overlay (create.log/recommended.pfi,
--		the per-*_log *_ACTION_TS indexes) is NOT part of this patch -- apply
--		it separately, on demand, where audit range queries matter at scale.
--
-- 06/25/2026 mir0n v1.2.9 created: *_CREATED_TS columns + ESQ_EP_PATH_I index + DB_VERSION 1.2.9
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n Adding Column 'ESQ_USER.USR_CREATED_TS\n'
ALTER TABLE ESQ_USER    ADD COLUMN IF NOT EXISTS USR_CREATED_TS TIMESTAMP DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
\echo -n Adding Column 'ESQ_ORG.ORG_CREATED_TS\n'
ALTER TABLE ESQ_ORG     ADD COLUMN IF NOT EXISTS ORG_CREATED_TS TIMESTAMP DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
\echo -n Adding Column 'ESQ_ACCOUNT.ACC_CREATED_TS\n'
ALTER TABLE ESQ_ACCOUNT ADD COLUMN IF NOT EXISTS ACC_CREATED_TS TIMESTAMP DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC');

COMMENT ON COLUMN ESQ_USER.USR_CREATED_TS    IS 'Entity created timestamp';
COMMENT ON COLUMN ESQ_ORG.ORG_CREATED_TS     IS 'Entity created timestamp';
COMMENT ON COLUMN ESQ_ACCOUNT.ACC_CREATED_TS IS 'Entity created timestamp';

\echo -n Creating Index 'ESQ_EP_PATH_I\n'
CREATE INDEX IF NOT EXISTS ESQ_EP_PATH_I ON ESQ_ENTITY_PATH (EP_PATH text_pattern_ops);

\echo -n Updating 'DB_VERSION -> 1.2.9\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '1.2.9'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
