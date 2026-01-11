-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000, 2001, 2025
--
-- file :	create/tree.all
-- desc:	biz Tree table
--
-----------------------------------

\set QUIET 1
\set VERBOSITY terse
\o tree-create.lst

\echo -n 'Drop Table ESQ_TREE\n'
\qecho -n 'Drop Table ESQ_TREE\n'
DROP TABLE ESQ_TREE;

\echo -n 'Creating Table ESQ_TREE\n'
\qecho -n 'Creating Table ESQ_TREE\n'

CREATE TABLE esq_tree(
  tree_pk             VARCHAR(33) DEFAULT 0 NOT NULL
 ,tree_et_pk          INTEGER DEFAULT 0 NOT NULL
 ,tree_name           VARCHAR(50) NOT NULL
 ,tree_desc           VARCHAR(1024)
 ,tree_tree_pk_parent VARCHAR(33)
 ,tree_tree_pk_link   VARCHAR(33)
 ,tree_acc_pk         BIGINT
 ,tree_usr_pk         BIGINT
 ,tree_org_pk         BIGINT
 ,tree_level          INTEGER
 ,tree_path           VARCHAR(2000)
 ,tree_entity_pk      INTEGER
 ,TREE_ENTITY_PATH    VARCHAR(2000)
);

COMMENT ON TABLE  ESQ_TREE IS 'Business tree';
COMMENT ON COLUMN ESQ_TREE.TREE_PK IS 'Node primary key entityPk||entityType';
COMMENT ON COLUMN ESQ_TREE.TREE_ET_PK IS 'Entity type, reference to ESQ_ENTITY_TYPE';
COMMENT ON COLUMN ESQ_TREE.TREE_NAME IS 'Node name';
COMMENT ON COLUMN ESQ_TREE.TREE_DESC IS 'Node description';
COMMENT ON COLUMN ESQ_TREE.TREE_TREE_PK_PARENT IS 'Reference to parent node';
COMMENT ON COLUMN ESQ_TREE.TREE_TREE_PK_PARENT IS 'Reference to linked node';
COMMENT ON COLUMN ESQ_TREE.TREE_ACC_PK IS 'Reference to account (ESQ_ACCOUNT)';
COMMENT ON COLUMN ESQ_TREE.TREE_USR_PK IS 'Reference to user ((ESQ_USER)';
COMMENT ON COLUMN ESQ_TREE.TREE_ORG_PK IS 'Reference to organization unit  ((ESQ_ORG)';
COMMENT ON COLUMN ESQ_TREE.TREE_ENTITY_PK IS 'Entity PK represenging by node';
COMMENT ON COLUMN ESQ_TREE.TREE_ORG_PK IS 'location of the node as a path of parent';
COMMENT ON COLUMN ESQ_TREE.TREE_LEVEL IS 'Level node on tree starting with 0';
COMMENT ON COLUMN ESQ_TREE.TREE_ENTITY_PATH IS 'Entity Path represenging by node';

\echo -n 'Creating Primary Key on ESQ_TREE\n'
\qecho -n 'Creating Primary Key on ESQ_TREE\n'
ALTER TABLE ESQ_TREE
 ADD CONSTRAINT ESQ_TREE_PK PRIMARY KEY 
  (TREE_PK);

\echo -n 'Creating Foreign Keys on ESQ_TREE\n'
\qecho -n 'Creating Foreign Keys on ESQ_TREE\n'
ALTER TABLE ESQ_TREE ADD CONSTRAINT
 ESQ_TREE_TREE_PARENT_FK FOREIGN KEY 
  (TREE_TREE_PK_PARENT) REFERENCES ESQ_TREE
  (TREE_PK);
ALTER TABLE ESQ_TREE ADD CONSTRAINT
 ESQ_TREE_TREE_LINK_FK FOREIGN KEY 
  (TREE_TREE_PK_LINK) REFERENCES ESQ_TREE
  (TREE_PK);
ALTER TABLE ESQ_TREE ADD CONSTRAINT
 ESQ_TREE_ACC_FK FOREIGN KEY 
  (TREE_ACC_PK) REFERENCES ESQ_ACCOUNT
  (ACC_PK);
ALTER TABLE ESQ_TREE ADD CONSTRAINT
 ESQ_TREE_USR_FK FOREIGN KEY 
  (TREE_USR_PK) REFERENCES ESQ_USER
  (USR_PK);
ALTER TABLE ESQ_TREE ADD CONSTRAINT
 ESQ_TREE_ORG_FK FOREIGN KEY 
  (TREE_ORG_PK) REFERENCES ESQ_ORG
  (ORG_PK);

\echo -n 'Creating Index ESQ_TREE_TREE_PARENT_FK_I\n'
\qecho -n 'Creating Index ESQ_TREE_TREE_PARENT_FK_I\n'
CREATE INDEX ESQ_TREE_TREE_PARENT_FK_I ON ESQ_TREE
  (TREE_TREE_PK_PARENT);

\echo -n 'Creating Index ESQ_TREE_TREE_LINK_FK_I\n'
\qecho -n 'Creating Index ESQ_TREE_TREE_LINK_FK_I\n'
CREATE INDEX ESQ_TREE_TREE_LINK_FK_I ON ESQ_TREE
  (TREE_TREE_PK_LINK);

\echo -n 'Creating Index ESQ_TREE_ACC_FK_I\n'
\qecho -n 'Creating Index ESQ_TREE_ACC_FK_I\n'
CREATE INDEX ESQ_TREE_ACC_FK_I ON ESQ_TREE
  (TREE_ACC_PK);

\echo -n 'Creating Index ESQ_TREE_USR_FK_I\n'
\qecho -n 'Creating Index ESQ_TREE_USR_FK_I\n'
CREATE INDEX ESQ_TREE_USR_FK_I ON ESQ_TREE
  (TREE_USR_PK);
  
\echo -n 'Creating Index ESQ_TREE_ORG_FK_I\n'
\qecho -n 'Creating Index ESQ_TREE_ORG_FK_I\n'
CREATE INDEX ESQ_TREE_ORG_FK_I ON ESQ_TREE
  (TREE_ORG_PK);
  
\echo -n 'Done\n'
\qecho -n 'Done\n'

\o
\set QUIET 0
