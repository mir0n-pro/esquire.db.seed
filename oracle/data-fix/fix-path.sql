-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2026
--
-- file :	oracle/data-fix/fix-path.sql
-- desc:	Validate / recover ESQ_ENTITY_PATH.EP_PATH -- the artificial materialized-path key that is
--		COMPUTED from the FK parent hierarchy (org.ORG_ORG_PK -> user.USR_ORG_PK -> account.ACC_USR_PK).
--		It can drift from the true hierarchy (a move that did not re-path all descendants, a lost sync).
--		A simple loop over office / user / account recomputes the canonical path straight from the FK tree
--		(so a wrong intermediate path never poisons a child), reports every mismatch, and -- in 'fix' mode --
--		UPDATEs esq_entity_path to the canonical value.
--
--		Path rule (mirrors enyMan PathRule / EsqObjectKind.isPathParentOnly):
--		  org   -> parent_org(ORG_ORG_PK).path + org_pk + '.'      (root org, ORG_ORG_PK IS NULL -> '<pk>.')
--		  user  -> parent-only for ADMIN kinds 30/32: parent_org(USR_ORG_PK).path ; else + usr_pk + '.'
--		  acct  -> parent-only: parent_user(ACC_USR_PK).path
--
--		Run via the sibling bat files -- validate.bat (report only) / fix.bat (apply).
--		Direct:  sqlplus -S user/pass@//host:1521/SVC @fix-path.sql validate   (or ... fix)
--
-- History:
-- 07/02/2026 mir0n created: EP_PATH validate/recover from the FK hierarchy; validate + optional fix.
-----------------------------------

SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
SET VERIFY OFF

DECLARE
    v_mode  VARCHAR2(20) := LOWER('&1');
    v_bad   PLS_INTEGER := 0;
    v_fixed PLS_INTEGER := 0;
BEGIN
    FOR r IN (
        WITH org_path(pk, path) AS (
                SELECT org_pk, TO_CHAR(org_pk) || '.'
                FROM esq_org WHERE org_org_pk IS NULL
            UNION ALL
                SELECT o.org_pk, op.path || TO_CHAR(o.org_pk) || '.'
                FROM esq_org o JOIN org_path op ON o.org_org_pk = op.pk
        ),
        user_path(pk, path) AS (
            SELECT u.usr_pk,
                   CASE WHEN u.usr_et_pk IN (30, 32) THEN op.path
                        ELSE op.path || TO_CHAR(u.usr_pk) || '.' END
            FROM esq_user u JOIN org_path op ON u.usr_org_pk = op.pk
        ),
        canon(pk, path) AS (
                SELECT pk, path FROM org_path
            UNION ALL SELECT pk, path FROM user_path
            UNION ALL SELECT a.acc_pk, up.path
                      FROM esq_account a JOIN user_path up ON a.acc_usr_pk = up.pk
        )
        SELECT ep.ep_pk AS ep_pk, ep.ep_path AS stored, c.path AS expected
        FROM canon c JOIN esq_entity_path ep ON ep.ep_pk = c.pk
        WHERE NVL(ep.ep_path, '~') <> NVL(c.path, '~')
        ORDER BY ep.ep_pk
    ) LOOP
        v_bad := v_bad + 1;
        DBMS_OUTPUT.PUT_LINE('MISMATCH ep_pk=' || r.ep_pk
            || ' stored=' || r.stored || ' expected=' || r.expected);
        IF v_mode = 'fix' THEN
            UPDATE esq_entity_path SET ep_path = r.expected WHERE ep_pk = r.ep_pk;
            v_fixed := v_fixed + 1;
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('EP_PATH mismatches=' || v_bad
        || CASE WHEN v_mode = 'fix' THEN ', fixed=' || v_fixed
                ELSE ' (validate only -- run fix.bat to apply)' END);

    IF v_mode = 'fix' THEN
        COMMIT;
    END IF;
END;
/

EXIT
