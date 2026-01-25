-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file : fill/esq_entity_type.sql
-- desc:  Fills esq_entity_type table
--
-----------------------------------
-- History:
--  

CREATE OR REPLACE PROCEDURE temp_entity_type (
    aID IN 			integer,
    aAccFlag    varchar,
    aUserFlag   varchar,
    aOrgFlag    varchar,
    aLinkFlag   varchar,
    aTreeFlags  varchar,
    aName       varchar,
    aDesc       varchar
) LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO esq_entity_type (
    et_pk,
    et_name,
    et_desc,
    et_acc_flg,
    et_usr_flg,
    et_org_flg,
    et_link_flg,
    et_tree_flgs
  ) VALUES (
    aID,          -- ET_PK,
    aName,        -- ET_NAME,
    aDesc,        -- ET_DESC,
    aAccFlag,     -- ET_ACC_FLG,
    aUserFlag,    -- ET_USR_FLG,
    aOrgFlag,     -- ET_ORG_FLG,
    aLinkFlag,    -- ET_LINK_FLG,
    aTreeFlags    -- ET_TREE_FLGS,
  );
END $$;

DO $$
BEGIN
	DELETE FROM esq_entity_type;
--                  aID,  aAcc,aUser,aOrg,aLink,   aTree,             aName, aDesc)
  CALL temp_entity_type (  0,   'N', 'N',  'N',  'N',    'BT',          'System', 'System root');
  CALL temp_entity_type (  2,   'N', 'N',  'N',  'N',    'BTb',    'All accounts',  'Accounts folder');
  CALL temp_entity_type (  3,   'N', 'N',  'N',  'Y',     'b',    'All accounts',  'Shortcut to accounts folder');
  CALL temp_entity_type (  4,   'N', 'N',  'N',  'N',    'BTb',     'All admin-s', 'Admin-s folder');
  CALL temp_entity_type (  5,   'N', 'N',  'N',  'Y',     'b',     'All admin-s',  'Shortcut to system folder');
  CALL temp_entity_type (  6,   'N', 'N',  'N',  'N',  'BTb',     'All clients',  'Clients folder');
  CALL temp_entity_type (  7,   'N', 'N',  'N',  'Y',    'b',     'All clients',  'Shortcut to clients folder');
  CALL temp_entity_type (  8,   'N', 'N',  'N',  'N',  'BTb',   'All merchants',  'Merchants folder');
  CALL temp_entity_type (  9,   'N', 'N',  'N',  'Y',  'BTb',   'All merchants',  'Shortcut to merchants folder');

  CALL temp_entity_type ( 10,   'N', 'N',  'Y',  'N',  'BTb',    'Organization',  'Organization unit');
  CALL temp_entity_type ( 11,   'N', 'N',  'N',  'Y',  'BTb',    'Organization',  'Shortcut to Organization unit');

  CALL temp_entity_type ( 12,   'N', 'Y',  'N',  'N',   'BTb',          'Client', 'Client profile');
  CALL temp_entity_type ( 13,   'N', 'N',  'N',  'Y',    'b',          'Client', 'Shortcut to client profile');
  CALL temp_entity_type ( 14,   'N', 'Y',  'N',  'N',   'BTb',        'Merchant',  'Merchant profile');
  CALL temp_entity_type ( 15,   'N', 'N',  'N',  'Y',    'b',        'Merchant', 'Shortcut to merchant profile');
  CALL temp_entity_type ( 16,   'N', 'Y',  'N',  'N',     'b',           'Admin', 'Administrator profile');
  CALL temp_entity_type ( 17,   'N', 'N',  'N',  'Y',     'b',           'Admin', 'Shortcut to Administrator profile');

  CALL temp_entity_type ( 18,   'Y', 'N',  'N',  'N',     'b',  'Client Account', 'Client Account');
  CALL temp_entity_type ( 19,   'N', 'N',  'N',  'Y',     'b',  'Client Account',  'Shortcut to client account');
  CALL temp_entity_type ( 20,   'Y', 'N',  'N',  'N',     'b', 'Merchant Account', 'Merchant Account');
  CALL temp_entity_type ( 21,   'N', 'N',  'N',  'Y',     'b', 'Merchant Account', 'Shortcut to merchant account');
  CALL temp_entity_type ( 22,   'Y', 'N',  'N',  'N',     'b', 'Paper Client Account', 'Paper Client Account');
  CALL temp_entity_type ( 23,   'N', 'N',  'N',  'Y',     'b', 'Paper Client Account', 'Shortcut to Paper Client Account');
  COMMIT;
END $$;

DROP PROCEDURE temp_entity_type;

\echo -n 'Done\n'
\qecho -n 'Done\n'
