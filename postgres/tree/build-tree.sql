-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/build-tree.sql
-- desc:    Fills esq_tree table
--
-----------------------------------
-- History:
--


\set QUIET 1
\set VERBOSITY terse
\o tree-fill.lst


CREATE OR REPLACE PROCEDURE build_tree ()
LANGUAGE plpgsql
AS $$ DECLARE
   folder_type integer;
   o record;
   u record;
   a record;
BEGIN

    -- build org tree
    FOR o IN (WITH RECURSIVE org_tree AS (
              SELECT  org_et_pk, org_pk, org_org_pk, 1 AS level, org_name, org_desc, org_path
                FROM esq_org WHERE org_pk = 1
              UNION ALL 
              SELECT child.org_et_pk, child.org_pk, child.org_org_pk, parent.level + 1, child.org_name, child.org_desc, child.org_path
                FROM esq_org child
             JOIN org_tree parent ON child.org_org_pk = parent.org_pk) 
             SELECT * FROM org_tree ORDER BY level 
     ) LOOP
	       RAISE INFO E'org : % % % % %\n', o.org_et_pk, o.org_pk, o.org_org_pk, o.level, o.org_name;
        -- org itself
         INSERT INTO esq_tree (tree_pk, tree_et_pk,  tree_name,  tree_desc,  tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path  )
         VALUES              (o.org_pk, o.org_et_pk, o.org_name, o.org_desc, o.org_org_pk,        NULL,              NULL,        NULL,        o.org_pk,    o.org_pk,       o.org_path);
         IF o.org_et_pk > 1 THEN
            -- all admin-s
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path  )
            VALUES               (o.org_pk || '~4', 4,          'All admin-s', 'Admin-s folder', o.org_pk,            NULL,              NULL,        NULL,        NULL,        NULL,           o.org_path);
            -- all accounts
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path )
            VALUES               (o.org_pk || '~6', 6,         'All accounts', 'Accounts folder', o.org_pk,           NULL,              NULL,        NULL,        NULL,        NULL,           o.org_path);
            -- all clients
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path )
            VALUES               (o.org_pk || '~8', 8,          'All clients', 'Clients folder', o.org_pk,            NULL,              NULL,        NULL,        NULL,        NULL,           o.org_path);
            -- all merchants
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,       tree_desc,         tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path  )
            VALUES               (o.org_pk ||'~10', 10,         'All merchants', 'Merchants folder', o.org_pk,           NULL,              NULL,        NULL,        NULL,        NULL,           o.org_path);
         ELSE   
            -- sys admin-s
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path  )
            VALUES               (o.org_pk || '~2', 2,          'Sys admin-s', 'Sys admin-s folder', o.org_pk,            NULL,              NULL,        NULL,        NULL,        NULL,           o.org_path);
         END IF;
    END LOOP;
    -- add users
    FOR u IN (SELECT usr_et_pk, usr_pk, usr_org_pk, usr_name, usr_desc, usr_path  FROM esq_user ORDER BY usr_pk) LOOP
       RAISE INFO E'user: % % % %\n', u.usr_et_pk, u.usr_pk, u.usr_org_pk, u.usr_name;
        -- direct
        --INSERT INTO esq_tree (tree_pk,tree_et_pk,tree_name,tree_desc,tree_tree_pk_parent,tree_tree_pk_link,tree_acc_pk,tree_usr_pk,tree_org_pk )
        -- VALUES(u.usr_pk * 100, u.usr_et_pk, u.usr_name, u.usr_desc, u.usr_org_pk * 100, NULL, NULL, u.usr_pk, NULL);
        -- shorcut in user folder
        IF u.usr_org_pk = 1 THEN -- system level users
            folder_type := 2;
        ELSIF u.usr_et_pk = 34 THEN -- client
            folder_type := 8;
        ELSIF u.usr_et_pk = 36 THEN -- merchant
            folder_type := 10;
        ELSE -- IF u.usr_et_pk = 32 THEN -- admin
            folder_type := 4;
        END IF;    

        INSERT INTO esq_tree (tree_pk,  tree_et_pk,  tree_name,  tree_desc,  tree_tree_pk_parent,            tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path )
        VALUES               (u.usr_pk, u.usr_et_pk, u.usr_name, u.usr_desc, u.usr_org_pk|| '~'||folder_type, NULL,             NULL,        u.usr_pk,    NULL,         u.usr_pk,      u.usr_path);

    END LOOP;

    -- add accounts
    FOR a IN (SELECT acc_et_pk, acc_pk, acc_usr_pk, acc_id, usr_org_pk, acc_desc, acc_path  FROM esq_account, esq_user WHERE acc_usr_pk = usr_pk ORDER BY acc_pk) LOOP
       RAISE INFO E'acct: % % % % %\n', a.acc_et_pk, a.acc_pk, a.acc_usr_pk, a.usr_org_pk, a.acc_id;
        -- direct
        INSERT INTO esq_tree (tree_pk,  tree_et_pk,  tree_name, tree_desc,  tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path)
        VALUES               (a.acc_pk, a.acc_et_pk, a.acc_id,  a.acc_desc, a.acc_usr_pk,        NULL,              a.acc_pk,    NULL,        NULL,        a.acc_pk,       a.acc_path);
        -- shorcut in acct folder
        folder_type := 6;
        INSERT INTO esq_tree (tree_pk,                     tree_et_pk,      tree_name, tree_desc,  tree_tree_pk_parent,            tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk, tree_entity_path)
        VALUES               (a.usr_org_pk||'~'||a.acc_pk, a.acc_et_pk + 1, a.acc_id,  a.acc_desc, a.usr_org_pk||'~'||folder_type, a.acc_pk,          a.acc_pk,    NULL,        NULL,        a.acc_pk,       a.acc_path);

    END LOOP;
    
    -- fill path and level
    FOR a IN (WITH RECURSIVE tree_cte AS (SELECT tree_pk, 1 AS level, ''::text AS path, tree_tree_pk_parent
    				 FROM esq_tree WHERE tree_tree_pk_parent IS NULL
             UNION ALL
             SELECT child.tree_pk, parent.level + 1, (parent.path || '.' || child.tree_tree_pk_parent)::text, child.tree_tree_pk_parent
             FROM esq_tree child
             JOIN tree_cte parent ON child.tree_tree_pk_parent = parent.tree_pk
		      ) SELECT tree_pk, level, 
		              CASE WHEN path = '' THEN '' ELSE LTRIM(REPLACE(path, '..', '.'), '.')||'.' END AS path
             FROM tree_cte ORDER BY level) LOOP
    	UPDATE esq_tree SET tree_path = a.path || a.tree_pk || '.', tree_level = a.level - 1
    	WHERE tree_pk = a.tree_pk;
    END LOOP;
    
END $$;

\echo -n 'Make the tree\n'
\qecho -n 'Make the tree\n'

DO $$ BEGIN
	DELETE FROM ESQ_TREE;
  CALL build_tree();
  COMMIT;
END $$;

DROP PROCEDURE build_tree;


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
    LEFT(REPEAT('|', level - 1) || '-' || tree_name, 50)::varchar(50) AS name, 
    level, 
    tree_path,
    tree_entity_path
FROM tree_hierarchy
ORDER BY tree_path;

\set QUIET 0
\set VERBOSITY verbose
\o
-- run the query to screen
\g

