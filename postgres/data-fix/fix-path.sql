-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	postgres/data-fix/fix-path.sql
-- desc:	Validate / recover ESQ_ENTITY_PATH.EP_PATH -- the artificial materialized-path key that is
--		COMPUTED from the FK parent hierarchy (org.ORG_ORG_PK -> user.USR_ORG_PK -> account.ACC_USR_PK).
--		It can drift from the true hierarchy (a move that did not re-path all descendants, a lost sync).
--		This recomputes the canonical path for every office / user / account straight from the FK tree
--		(so a wrong intermediate path never poisons a child) and reports every mismatch; with apply=on it
--		UPDATEs esq_entity_path to the canonical value.
--
--		Path rule (mirrors enyMan PathRule / EsqObjectKind.isPathParentOnly):
--		  org   -> parent_org(ORG_ORG_PK).path + org_pk + '.'      (root org, ORG_ORG_PK IS NULL -> '<pk>.')
--		  user  -> parent-only for ADMIN kinds 30/32: parent_org(USR_ORG_PK).path ; else + usr_pk + '.'
--		  acct  -> parent-only: parent_user(ACC_USR_PK).path
--
--		Run via the sibling bat files -- validate.bat (apply=off, report only) / fix.bat (apply=on).
--		Direct:  psql ... -v ON_ERROR_STOP=1 -v apply=off -f fix-path.sql
--
-- History:
-- 07/02/2026 mir0n created: EP_PATH validate/recover from the FK hierarchy; validate + optional fix.
-----------------------------------

\set ON_ERROR_STOP on

-- Canonical path per entity, recomputed top-down from the FK tree.
CREATE TEMP TABLE _canon AS
WITH RECURSIVE org_path(pk, path) AS (
        SELECT org_pk, org_pk::text || '.'
        FROM esq_org WHERE org_org_pk IS NULL
    UNION ALL
        SELECT o.org_pk, op.path || o.org_pk::text || '.'
        FROM esq_org o JOIN org_path op ON o.org_org_pk = op.pk
),
user_path(pk, path) AS (
    SELECT u.usr_pk,
           CASE WHEN u.usr_et_pk IN (30, 32) THEN op.path
                ELSE op.path || u.usr_pk::text || '.' END
    FROM esq_user u JOIN org_path op ON u.usr_org_pk = op.pk
)
SELECT pk, path FROM org_path
UNION ALL SELECT pk, path FROM user_path
UNION ALL SELECT a.acc_pk, up.path FROM esq_account a JOIN user_path up ON a.acc_usr_pk = up.pk;

\echo '=== EP_PATH mismatches (ep_pk | stored | expected) ==='
SELECT ep.ep_pk, ep.ep_path AS stored, c.path AS expected
FROM _canon c JOIN esq_entity_path ep ON ep.ep_pk = c.pk
WHERE ep.ep_path IS DISTINCT FROM c.path
ORDER BY ep.ep_pk;

\echo '=== entity_path rows NOT reachable from the root (orphan FK -- reported, NOT auto-fixed) ==='
SELECT ep.ep_pk, ep.ep_path
FROM esq_entity_path ep
WHERE NOT EXISTS (SELECT 1 FROM _canon c WHERE c.pk = ep.ep_pk)
ORDER BY ep.ep_pk;

\if :apply
    \echo '=== APPLYING EP_PATH fixes ==='
    BEGIN;
    UPDATE esq_entity_path ep SET ep_path = c.path
    FROM _canon c
    WHERE ep.ep_pk = c.pk AND ep.ep_path IS DISTINCT FROM c.path;
    COMMIT;
    \echo 'EP_PATH fixes committed.'
\else
    \echo '(validate only -- run fix.bat to apply the corrections listed above)'
\endif

DROP TABLE _canon;
