-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file : fill/esq_entity_type.sql
-- desc:  Fills esq_entity_type table (Snowflake)
-----------------------------------

DELETE FROM ESQ_ENTITY_TYPE;

INSERT INTO ESQ_ENTITY_TYPE (ET_PK, ET_ACC_FLG, ET_USR_FLG, ET_ORG_FLG, ET_LINK_FLG, ET_TREE_FLGS, ET_NAME, ET_DESC) VALUES
 (  0, 'N', 'N', 'N', 'N', 'BT',                'System', 'System root'),
 (  2, 'N', 'N', 'N', 'N', 'BTb',          'Sys admin-s', 'Admin-s folder'),
 (  4, 'N', 'N', 'N', 'N', 'BTb',          'All admin-s', 'Admin-s folder'),
 (  6, 'N', 'N', 'N', 'N', 'BTb',         'All accounts', 'Accounts folder'),
 (  8, 'N', 'N', 'N', 'N', 'BTb',          'All clients', 'Clients folder'),
 ( 10, 'N', 'N', 'N', 'N', 'BTb',        'All merchants', 'Merchants folder'),
 ( 20, 'N', 'N', 'Y', 'N', 'BTb',         'Organization', 'Organization unit'),
 ( 21, 'N', 'N', 'N', 'Y', 'BTb',         'Organization', 'Shortcut to Organization unit'),
 ( 30, 'N', 'Y', 'N', 'N',   'b',             'SysAdmin', 'System Administrator profile'),
 ( 31, 'N', 'N', 'N', 'Y',   'b',             'SysAdmin', 'Shortcut to System Administrator profile'),
 ( 32, 'N', 'Y', 'N', 'N',   'b',                'Admin', 'Administrator profile'),
 ( 33, 'N', 'N', 'N', 'Y',   'b',                'Admin', 'Shortcut to Administrator profile'),
 ( 34, 'N', 'Y', 'N', 'N', 'BTb',               'Client', 'Client profile'),
 ( 35, 'N', 'N', 'N', 'Y',   'b',               'Client', 'Shortcut to client profile'),
 ( 36, 'N', 'Y', 'N', 'N', 'BTb',             'Merchant', 'Merchant profile'),
 ( 37, 'N', 'N', 'N', 'Y',   'b',             'Merchant', 'Shortcut to merchant profile'),
 ( 50, 'Y', 'N', 'N', 'N',   'b',       'Client Account', 'Client Account'),
 ( 51, 'N', 'N', 'N', 'Y',   'b',       'Client Account', 'Shortcut to client account'),
 ( 52, 'Y', 'N', 'N', 'N',   'b',     'Merchant Account', 'Merchant Account'),
 ( 53, 'N', 'N', 'N', 'Y',   'b',     'Merchant Account', 'Shortcut to merchant account'),
 ( 54, 'Y', 'N', 'N', 'N',   'b', 'Paper Client Account', 'Paper Client Account'),
 ( 55, 'N', 'N', 'N', 'Y',   'b', 'Paper Client Account', 'Shortcut to Paper Client Account');

SELECT 'Done' AS status;
