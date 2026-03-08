-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   tree/build-tree.sql
-- desc:    Fills esq_tree table (Snowflake)
--
-- NOTE: Snowflake supports recursive CTEs and stored procedures
--       with Snowflake Scripting (SQL) language.
-----------------------------------

CREATE OR REPLACE PROCEDURE BUILD_TREE()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    v_folder_type NUMBER(10,0);
    c_org CURSOR FOR
        WITH RECURSIVE org_tree AS (
            SELECT org_et_pk, org_pk, org_org_pk, 1 AS level, org_name, org_desc, org_path
              FROM esq_org WHERE org_pk = 1
            UNION ALL
            SELECT child.org_et_pk, child.org_pk, child.org_org_pk, parent.level + 1, child.org_name, child.org_desc, child.org_path
              FROM esq_org child
              JOIN org_tree parent ON child.org_org_pk = parent.org_pk
        )
        SELECT * FROM org_tree ORDER BY level;
    c_usr CURSOR FOR
        SELECT usr_et_pk, usr_pk, usr_org_pk, usr_name, usr_desc, usr_path FROM esq_user ORDER BY usr_pk;
    c_acc CURSOR FOR
        SELECT acc_et_pk, acc_pk, acc_usr_pk, acc_id, usr_org_pk, acc_desc, acc_path
          FROM esq_account, esq_user WHERE acc_usr_pk = usr_pk ORDER BY acc_pk;
    c_path CURSOR FOR
        WITH RECURSIVE tree_cte AS (
            SELECT tree_pk, 1 AS level, ''::VARCHAR AS path, tree_tree_pk_parent
              FROM esq_tree WHERE tree_tree_pk_parent IS NULL
            UNION ALL
            SELECT child.tree_pk, parent.level + 1,
                   (parent.path || '.' || child.tree_tree_pk_parent)::VARCHAR,
                   child.tree_tree_pk_parent
              FROM esq_tree child
              JOIN tree_cte parent ON child.tree_tree_pk_parent = parent.tree_pk
        )
        SELECT tree_pk, level,
               CASE WHEN path = '' THEN '' ELSE LTRIM(REPLACE(path, '..', '.'), '.') || '.' END AS path
          FROM tree_cte ORDER BY level;
BEGIN
    DELETE FROM ESQ_TREE;

    -- Build org tree
    FOR o IN c_org DO
        INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
        VALUES (o.ORG_PK, o.ORG_ET_PK, o.ORG_NAME, o.ORG_DESC, o.ORG_ORG_PK, NULL, NULL, NULL, o.ORG_PK, o.ORG_PK, o.ORG_PATH);

        IF (o.ORG_ET_PK > 1) THEN
            INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
            VALUES (o.ORG_PK || '~4', 4, 'All admin-s', 'Admin-s folder', o.ORG_PK, NULL, NULL, NULL, NULL, NULL, o.ORG_PATH);
            INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
            VALUES (o.ORG_PK || '~6', 6, 'All accounts', 'Accounts folder', o.ORG_PK, NULL, NULL, NULL, NULL, NULL, o.ORG_PATH);
            INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
            VALUES (o.ORG_PK || '~8', 8, 'All clients', 'Clients folder', o.ORG_PK, NULL, NULL, NULL, NULL, NULL, o.ORG_PATH);
            INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
            VALUES (o.ORG_PK || '~10', 10, 'All merchants', 'Merchants folder', o.ORG_PK, NULL, NULL, NULL, NULL, NULL, o.ORG_PATH);
        ELSE
            INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
            VALUES (o.ORG_PK || '~2', 2, 'Sys admin-s', 'Sys admin-s folder', o.ORG_PK, NULL, NULL, NULL, NULL, NULL, o.ORG_PATH);
        END IF;
    END FOR;

    -- Add users
    FOR u IN c_usr DO
        IF (u.USR_ORG_PK = 1) THEN
            v_folder_type := 2;
        ELSEIF (u.USR_ET_PK = 34) THEN
            v_folder_type := 8;
        ELSEIF (u.USR_ET_PK = 36) THEN
            v_folder_type := 10;
        ELSE
            v_folder_type := 4;
        END IF;

        INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
        VALUES (u.USR_PK, u.USR_ET_PK, u.USR_NAME, u.USR_DESC, u.USR_ORG_PK || '~' || v_folder_type, NULL, NULL, u.USR_PK, NULL, u.USR_PK, u.USR_PATH);
    END FOR;

    -- Add accounts
    FOR a IN c_acc DO
        INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
        VALUES (a.ACC_PK, a.ACC_ET_PK, a.ACC_ID, a.ACC_DESC, a.ACC_USR_PK, NULL, a.ACC_PK, NULL, NULL, a.ACC_PK, a.ACC_PATH);

        v_folder_type := 6;
        INSERT INTO ESQ_TREE (TREE_PK, TREE_ET_PK, TREE_NAME, TREE_DESC, TREE_TREE_PK_PARENT, TREE_TREE_PK_LINK, TREE_ACC_PK, TREE_USR_PK, TREE_ORG_PK, TREE_ENTITY_PK, TREE_ENTITY_PATH)
        VALUES (a.USR_ORG_PK || '~' || a.ACC_PK, a.ACC_ET_PK + 1, a.ACC_ID, a.ACC_DESC, a.USR_ORG_PK || '~' || v_folder_type, a.ACC_PK, a.ACC_PK, NULL, NULL, a.ACC_PK, a.ACC_PATH);
    END FOR;

    -- Fill path and level
    FOR p IN c_path DO
        UPDATE ESQ_TREE SET TREE_PATH = p.PATH || p.TREE_PK || '.', TREE_LEVEL = p.LEVEL - 1
         WHERE TREE_PK = p.TREE_PK;
    END FOR;

    RETURN 'Tree built successfully';
END;
$$;

SELECT 'Make the tree' AS status;
CALL BUILD_TREE();

DROP PROCEDURE IF EXISTS BUILD_TREE();

-- Display tree
WITH RECURSIVE tree_hierarchy AS (
    SELECT
        tree_pk,
        tree_name,
        1 AS level,
        tree_level,
        tree_path,
        tree_entity_path
    FROM esq_tree
    WHERE tree_tree_pk_parent IS NULL
    UNION ALL
    SELECT
        child.tree_pk,
        child.tree_name,
        parent.level + 1,
        child.tree_level,
        child.tree_path,
        child.tree_entity_path
    FROM esq_tree child
    JOIN tree_hierarchy parent ON child.tree_tree_pk_parent = parent.tree_pk
) SELECT
    tree_pk,
    LEFT(REPEAT('|', level - 1) || '-' || tree_name, 50) AS name,
    level,
    tree_path,
    tree_entity_path
FROM tree_hierarchy
ORDER BY tree_path;
