-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/patch/v2.0.4/forward.sql
-- desc:	Forward migration to v2.0.4 for an ALREADY-SEEDED Postgres database
--		(the baked seed runs only on an empty data dir, so an existing DB --
--		e.g. OKE production -- never receives a fill/ change on its own).
--		v2.0.4 adds the socket face, blinky, which lets in only a user with
--		the BLINKY role:
--		  1. Permission 110 'Esquire Socket' (type 984, Apps).
--		  2. Role BLINKY (role_pk=11, type 984), for the same user kinds as
--		     TREE (30, 32, 34, 36), with permission 110.
--		  3. BLINKY given to mainadmin (usr_pk=5) and the Test Driver (usr_pk=15).
--		  4. DB_VERSION -> 2.0.4.
--		Idempotent, re-runnable, never drops, never reseeds. Mirrors the fresh-seed
--		data (fill/esq_permission.sql, fill/esq_role.sql, fill/initial-entities.sql)
--		and the DB_VERSION in fill/root.sql.
--
--		Apply on demand against the live DB:
--		  psql -h <host> -p <port> -U esq2025 -d esq2025 -v ON_ERROR_STOP=1 \
--		       -f postgres/patch/v2.0.4/forward.sql
--		For OKE prod, tunnel first with k8s-oci/oke-pg-forward.bat (localhost:25432).
--
-- 11/26/2026 mir0n v2.0.4 created: permission 110 and role BLINKY (role_pk=11, type 984); BLINKY for usr_pk 5 and 15; DB_VERSION 2.0.3 -> 2.0.4
-----------------------------------

\set ON_ERROR_STOP on
BEGIN;

\echo -n 'Permission 110 (Esquire Socket)\n'
INSERT INTO ESQ_PERMISSION (PRM_PK, PRM_NAME, PRM_DESC, PRM_PT_PK, PRM_ET_PK)
SELECT 110, 'Esquire Socket', 'Runs Esquire socket interface', 984, NULL
 WHERE NOT EXISTS (SELECT 1 FROM ESQ_PERMISSION WHERE PRM_PK = 110);

\echo -n 'Role BLINKY (role_pk=11)\n'
INSERT INTO ESQ_ROLE (ROLE_PK, ROLE_NAME, ROLE_PT_PK, ROLE_DESC)
SELECT 11, 'BLINKY', 984, 'Use of Esquire socket interface'
 WHERE NOT EXISTS (SELECT 1 FROM ESQ_ROLE WHERE ROLE_PK = 11);

INSERT INTO ESQ_ROLE_ET (RT_ROLE_PK, RT_ET_PK)
SELECT 11, et.ET_PK
  FROM (VALUES (30), (32), (34), (36)) AS et (ET_PK)
 WHERE NOT EXISTS (SELECT 1 FROM ESQ_ROLE_ET WHERE RT_ROLE_PK = 11 AND RT_ET_PK = et.ET_PK);

INSERT INTO ESQ_ROLE_PRM (RP_ROLE_PK, RP_PRM_PK, RP_ALLOWED_FLGS)
SELECT 11, 110, 'Y,'
 WHERE NOT EXISTS (SELECT 1 FROM ESQ_ROLE_PRM WHERE RP_ROLE_PK = 11 AND RP_PRM_PK = 110);

\echo -n 'BLINKY for mainadmin (usr_pk=5) and the Test Driver (usr_pk=15)\n'
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK)
SELECT u.USR_PK, 11
  FROM (VALUES (5), (15)) AS u (USR_PK)
 WHERE NOT EXISTS (SELECT 1 FROM ESQ_USR_ROLE WHERE UR_USR_PK = u.USR_PK AND UR_ROLE_PK = 11);

\echo -n 'Updating DB_VERSION -> 2.0.4\n'
UPDATE ESQ_ORG_PAR SET OPR_VALUE = '2.0.4'
 WHERE OPR_ORG_PK = 1 AND OPR_PAR_NAME = 'DB_VERSION' AND OPR_PAR_ET_PK = 0;

COMMIT;

\echo -n 'Done\n'
