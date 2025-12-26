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

set serverout on size 500000
set linesize 1000
CREATE OR REPLACE PROCEDURE build_tree IS
folder_type NUMBER;
BEGIN
    -- build org tree
    FOR o IN (SELECT org_et_pk, org_pk, org_org_pk, LEVEL, org_name, org_desc
    FROM esq_org
    CONNECT BY PRIOR org_pk = org_org_pk 
    START WITH org_pk = 1
    ORDER BY LEVEL) LOOP
	    DBMS_OUTPUT.PUT_LINE('org '||o.org_et_pk ||' '|| o.org_pk||' '||o.org_org_pk ||' '||o.level||' '||o.org_name);
        -- org itself
         INSERT INTO esq_tree (tree_pk, tree_et_pk,  tree_name,  tree_desc,  tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk )
         VALUES              (o.org_pk, o.org_et_pk, o.org_name, o.org_desc, o.org_org_pk,        NULL,              NULL,        NULL,        o.org_pk,    o.org_pk);
         IF o.org_et_pk > 1 THEN
            -- all accounts
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk)
            VALUES               (o.org_pk || '~2', 2,         'All accounts', 'Accounts folder', o.org_pk,           NULL,              NULL,        NULL,        NULL,        NULL);
            -- all clients
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk)
            VALUES               (o.org_pk || '~6', 6,          'All clients', 'Clients folder', o.org_pk,            NULL,              NULL,        NULL,        NULL,        NULL);
            -- all merchants
            INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,       tree_desc,         tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk )
            VALUES               (o.org_pk || '~8', 8,          'All merchants', 'Merchants folder', o.org_pk,           NULL,              NULL,        NULL,        NULL,        NULL);
         END IF;
        -- all admin-s
        INSERT INTO esq_tree (tree_pk,          tree_et_pk, tree_name,     tree_desc,        tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk )
        VALUES               (o.org_pk || '~4', 4,          'All admin-s', 'Admin-s folder', o.org_pk,            NULL,              NULL,        NULL,        NULL,        NULL);
    END LOOP;

    -- add users
    FOR u IN (SELECT usr_et_pk, usr_pk, usr_org_pk, usr_name, usr_desc FROM esq_user ORDER BY usr_pk) LOOP
	    DBMS_OUTPUT.PUT_LINE('user '||u.usr_et_pk ||' '|| u.usr_pk||' '||u.usr_org_pk ||' '||u.usr_name);
        -- direct
        --INSERT INTO esq_tree (tree_pk,tree_et_pk,tree_name,tree_desc,tree_tree_pk_parent,tree_tree_pk_link,tree_acc_pk,tree_usr_pk,tree_org_pk )
        -- VALUES(u.usr_pk * 100, u.usr_et_pk, u.usr_name, u.usr_desc, u.usr_org_pk * 100, NULL, NULL, u.usr_pk, NULL);
        -- shorcut in user folder
        IF u.usr_et_pk = 12 THEN -- client
            folder_type := 6;
        ELSIF u.usr_et_pk = 14 THEN -- merchant
            folder_type := 8;
        ELSE -- IF u.usr_et_pk = 16 THEN -- admin
            folder_type := 4;
        END IF;    

        INSERT INTO esq_tree (tree_pk,  tree_et_pk,  tree_name,  tree_desc,  tree_tree_pk_parent,            tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk )
        VALUES               (u.usr_pk, u.usr_et_pk, u.usr_name, u.usr_desc, u.usr_org_pk|| '~'||folder_type, NULL,             NULL,        u.usr_pk,    NULL,         u.usr_pk);

    END LOOP;


    -- add accounts
    FOR a IN (SELECT acc_et_pk, acc_pk, acc_usr_pk, acc_id, usr_org_pk, acc_desc FROM esq_account, esq_user WHERE acc_usr_pk = usr_pk ORDER BY acc_pk) LOOP
	    DBMS_OUTPUT.PUT_LINE('acct '||a.acc_et_pk ||' '|| a.acc_pk||' '||a.acc_usr_pk ||' '||a.usr_org_pk||' '||a.acc_id);
        -- direct
        INSERT INTO esq_tree (tree_pk,  tree_et_pk,  tree_name, tree_desc,  tree_tree_pk_parent, tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk  )
        VALUES               (a.acc_pk, a.acc_et_pk, a.acc_id,  a.acc_desc, a.acc_usr_pk,        NULL,              a.acc_pk,    NULL,        NULL,        a.acc_pk);
        -- shorcut in acct folder
        folder_type := 2;
        INSERT INTO esq_tree (tree_pk,                     tree_et_pk,      tree_name, tree_desc,  tree_tree_pk_parent,            tree_tree_pk_link, tree_acc_pk, tree_usr_pk, tree_org_pk, tree_entity_pk  )
        VALUES               (a.usr_org_pk||'-'||a.acc_pk, a.acc_et_pk + 1, a.acc_id,  a.acc_desc, a.usr_org_pk||'~'||folder_type, a.acc_pk,          a.acc_pk,    NULL,        NULL,        a.acc_pk);

    END LOOP;
    -- fill path 
    FOR a IN (SELECT tree_pk, LEVEL, DECODE(tree_tree_pk_parent, NULL,'', (REPLACE(SYS_CONNECT_BY_PATH(tree_tree_pk_parent, '/'),'//',''))) AS path 
              FROM esq_tree START WITH tree_tree_pk_parent IS NULL CONNECT BY PRIOR  tree_pk = tree_tree_pk_parent ) LOOP
    	UPDATE esq_tree SET tree_path = a.path, tree_level = a.level - 1
    	WHERE tree_pk = a.tree_pk;
    END LOOP;
END;
/
show errors;

DELETE FROM ESQ_TREE;
COMMIT;

BEGIN
    build_tree;
END;
/
DROP PROCEDURE build_tree;

SELECT tree_pk, CAST(SUBSTR(RPAD(' ', LEVEL, '|')||'-'||tree_name, 1,50) AS VARCHAR2(50)) name, LEVEL, TREE_LEVEL, CAST(tree_path AS VARCHAR2(50)) path 
FROM esq_tree
CONNECT BY PRIOR tree_pk = tree_tree_pk_parent
START WITH tree_tree_pk_parent is NULL
/     
