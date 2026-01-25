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

CREATE OR REPLACE PROCEDURE temp_entity_type (aID IN NUMBER,
    aAccFlag    IN VARCHAR2,
    aUserFlag   IN VARCHAR2,
    aOrgFlag    IN VARCHAR2,
    aLinkFlag   IN VARCHAR2,
    aTreeFlags  IN VARCHAR2,
    aName       IN VARCHAR2,
    aDesc       IN VARCHAR2) IS
BEGIN

  INSERT INTO ESQ_ENTITY_TYPE (
    ET_PK,
    ET_NAME,
    ET_DESC,
    ET_ACC_FLG,
    ET_USR_FLG,
    ET_ORG_FLG,
    ET_LINK_FLG,
    ET_TREE_FLGS
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
  commit;
END;                                                    
/
show errors;                      
DELETE FROM ESQ_ENTITY_TYPE;
COMMIT;
BEGIN

--                  aID,  aAcc,aUser,aOrg,aLink,   aTree,             aName, aDesc)
  temp_entity_type (  0,   'N', 'N',  'N',  'N',    'BT',          'System', 'System root');
  temp_entity_type (  2,   'N', 'N',  'N',  'N',    'BTb',    'All accounts',  'Accounts folder');
  temp_entity_type (  3,   'N', 'N',  'N',  'Y',     'b',    'All accounts',  'Shortcut to accounts folder');
  temp_entity_type (  4,   'N', 'N',  'N',  'N',    'BTb',     'All admin-s', 'Admin-s folder');
  temp_entity_type (  5,   'N', 'N',  'N',  'Y',     'b',     'All admin-s',  'Shortcut to system folder');
  temp_entity_type (  6,   'N', 'N',  'N',  'N',  'BTb',     'All clients',  'Clients folder');
  temp_entity_type (  7,   'N', 'N',  'N',  'Y',    'b',     'All clients',  'Shortcut to clients folder');
  temp_entity_type (  8,   'N', 'N',  'N',  'N',  'BTb',   'All merchants',  'Merchants folder');
  temp_entity_type (  9,   'N', 'N',  'N',  'Y',  'BTb',   'All merchants',  'Shortcut to merchants folder');

  temp_entity_type ( 10,   'N', 'N',  'Y',  'N',  'BTb',    'Organization',  'Organization unit');
  temp_entity_type ( 11,   'N', 'N',  'N',  'Y',  'BTb',    'Organization',  'Shortcut to Organization unit');

  temp_entity_type ( 12,   'N', 'Y',  'N',  'N',   'BTb',          'Client', 'Client profile');
  temp_entity_type ( 13,   'N', 'N',  'N',  'Y',    'b',          'Client', 'Shortcut to client profile');
  temp_entity_type ( 14,   'N', 'Y',  'N',  'N',   'BTb',        'Merchant',  'Merchant profile');
  temp_entity_type ( 15,   'N', 'N',  'N',  'Y',    'b',        'Merchant', 'Shortcut to merchant profile');
  temp_entity_type ( 16,   'N', 'Y',  'N',  'N',     'b',           'Admin', 'Administrator profile');
  temp_entity_type ( 17,   'N', 'N',  'N',  'Y',     'b',           'Admin', 'Shortcut to Administrator profile');

  temp_entity_type ( 18,   'Y', 'N',  'N',  'N',     'b',  'Client Account', 'Client Account');
  temp_entity_type ( 19,   'N', 'N',  'N',  'Y',     'b',  'Client Account',  'Shortcut to client account');
  temp_entity_type ( 20,   'Y', 'N',  'N',  'N',     'b', 'Merchant Account', 'Merchant Account');
  temp_entity_type ( 21,   'N', 'N',  'N',  'Y',     'b', 'Merchant Account', 'Shortcut to merchant account');
  temp_entity_type ( 22,   'Y', 'N',  'N',  'N',     'b', 'Paper Client Account', 'Paper Client Account');
  temp_entity_type ( 23,   'N', 'N',  'N',  'Y',     'b', 'Paper Client Account', 'Shortcut to Paper Client Account');
END;
/
drop procedure temp_entity_type;
