-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2025
--
-- file :	fill/initial-entities.sql
-- desc:	Seed users, orgs, accounts (Snowflake)
-----------------------------------

-- Inital organizations
SELECT 'Inital organizations' AS status;
INSERT INTO ESQ_ORG (ORG_PK, ORG_ET_PK, ORG_NAME, ORG_PATH, ORG_FULL_NAME, ORG_ORG_PK, ORG_DESC)
       VALUES       (2,      20,        'Company', '1.2.',   'Inital company', 1,          NULL);
INSERT INTO ESQ_ORG (ORG_PK, ORG_ET_PK, ORG_NAME, ORG_PATH, ORG_FULL_NAME, ORG_ORG_PK, ORG_DESC)
       VALUES       (3,      20,        'Department', '1.2.3.', 'Inital department', 2,     NULL);
INSERT INTO ESQ_ORG_PAR (OPR_ORG_PK, OPR_PAR_NAME, OPR_PAR_ET_PK, OPR_VALUE)
       VALUES           (2,          'Example',     20,            'Example for Company Esquire');
INSERT INTO ESQ_ORG_PAR (OPR_ORG_PK, OPR_PAR_NAME, OPR_PAR_ET_PK, OPR_VALUE)
       VALUES           (3,          'Example',     20,            'Example for Company Esquire');

-- Sysadmin
SELECT 'Sysadmin' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (4,      30,        'System Administrator', '1.', 'na', 1, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (4,         'Y',            'N',           'system',    'mir0n.the.programmer4@gmail.com');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL)
       VALUES          (4,         992,     'System',       'Administrator', 'mir0n.the.programmer4@gmail.com');
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (4, 1);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (4, 8);

-- Supervizor
SELECT 'Supervizor' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (5,      32,        'Super Vizor', '1.', 'na', 1, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (5,         'Y',            'N',           'mainadmin', 'mir0n.the.programmer.5@gmail.com');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL)
       VALUES          (5,         992,     'Super',        'Vizor',       'mir0n.the.programmer.5@gmail.com');
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (5, 2);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (5, 8);

-- Support
SELECT 'Support' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (6,      32,        'Sup Port', '1.2.', 'na', 2, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (6,         'Y',            'N',           'support',   'mir0n.the.programmer.6@gmail.com');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL)
       VALUES          (6,         992,     'Sup',          'Port',        'mir0n.the.programmer.6@gmail.com');
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (6, 5);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (6, 8);

-- Office Manager
SELECT 'Office Manager' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (7,      32,        'Office Manager', '1.2.', 'na', 2, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (7,         'Y',            'N',           'officeadmin', 'mir0n.the.programmer.7@gmail.com');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL)
       VALUES          (7,         992,     'Office',       'Manager',      'mir0n.the.programmer.7@gmail.com');
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (7, 3);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (7, 8);

-- Merchant
SELECT 'Merchant' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (8,      36,        'Mer Chant', '1.2.8.', 'na', 2, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (8,         'Y',            'N',           'merchant',  'mir0n.the.programmer.8@gmail.com');
INSERT INTO ESQ_ADDRESS (AD_PK, AD_ADDR, AD_CITY, AD_COUNTRY, AD_DESC)
       VALUES           (1,     'Street', 'City', 'Country',   'Postal address');
INSERT INTO ESQ_ADDRESS (AD_PK, AD_ADDR, AD_CITY, AD_COUNTRY, AD_DESC)
       VALUES           (2,     'Street', 'City', 'Country',   'Biz address');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL, PE_AD_PK, PE_AD_PK_BIZ)
       VALUES          (8,         992,     'Mer',          'Chant',       'mir0n.the.programmer.8@gmail.com', 1, 2);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (8, 7);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (8, 8);

-- Department Manager
SELECT 'Department Manager' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (9,      32,        'Department Manager', '1.2.3.', 'na', 3, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (9,         'Y',            'N',           'departmentadmin', 'mir0n.the.programmer.9@gmail.com');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL)
       VALUES          (9,         992,     'Department',   'Manager',      'mir0n.the.programmer.9@gmail.com');
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (9, 3);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (9, 8);

-- Client
SELECT 'Client' AS status;
INSERT INTO ESQ_USER (USR_PK, USR_ET_PK, USR_NAME, USR_PATH, USR_REG_OPTION, USR_ORG_PK, USR_DELETED_FLG, USR_DESC)
       VALUES        (10,     34,        'Cli Ent', '1.2.3.10.', 'na', 3, 'N', NULL);
INSERT INTO ESQ_AUTH (AU_USR_PK, AU_CONNECT_FLG, AU_TFA_METHOD, AU_LOGIN_ID, AU_EMAIL)
       VALUES        (10,        'N',            'N',           'client',    'mir0n.the.programmer.10@gmail.com');
INSERT INTO ESQ_USR_PAR (UPR_USR_PK, UPR_PAR_NAME, UPR_PAR_ET_PK, UPR_VALUE)
       VALUES           (10,         'Example',     34,            'Example for Esquire');
INSERT INTO ESQ_ADDRESS (AD_PK, AD_ADDR, AD_CITY, AD_COUNTRY, AD_DESC)
       VALUES           (3,     'Street', 'City', 'Country',   'Postal address');
INSERT INTO ESQ_ADDRESS (AD_PK, AD_ADDR, AD_CITY, AD_COUNTRY, AD_DESC)
       VALUES           (4,     'Street', 'City', 'Country',   'Biz address');
INSERT INTO ESQ_PERSON (PE_USR_PK, PE_KIND, PE_FIRST_NAME, PE_LAST_NAME, PE_EMAIL, PE_AD_PK, PE_AD_PK_BIZ)
       VALUES          (10,        992,     'Cli',          'Ent',         'mir0n.the.programmer.10@gmail.com', 3, 4);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (10, 6);
INSERT INTO ESQ_USR_ROLE (UR_USR_PK, UR_ROLE_PK) VALUES (10, 8);

-- Accounts
SELECT 'Accounts' AS status;
INSERT INTO ESQ_ACCOUNT (ACC_PK, ACC_ET_PK, ACC_PATH, ACC_ID, ACC_BALANCE, ACC_CCY, ACC_STATUS, ACC_USR_PK, ACC_DESC)
       VALUES           (11,     52,        '1.2.8.',  '10011', 0.00,       'EUR',   'O',        8,          'Merchant account');
INSERT INTO ESQ_ACCOUNT (ACC_PK, ACC_ET_PK, ACC_PATH, ACC_ID, ACC_BALANCE, ACC_CCY, ACC_STATUS, ACC_USR_PK, ACC_DESC)
       VALUES           (12,     50,        '1.2.3.10.', '10012', 0.00,    'USD',   'O',        10,         'Client account');
INSERT INTO ESQ_ACCOUNT (ACC_PK, ACC_ET_PK, ACC_PATH, ACC_ID, ACC_BALANCE, ACC_CCY, ACC_STATUS, ACC_USR_PK, ACC_DESC)
       VALUES           (13,     54,        '1.2.3.10.', '10013', 0.00,    'USD',   'O',        10,         'Paper Client account');

SELECT 'Done' AS status;
