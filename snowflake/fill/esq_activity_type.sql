-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_activity_type.sql
-- desc:    Fills esq_activity_type table (Snowflake)
-----------------------------------

DELETE FROM ESQ_ACTIVITY_TYPE;

INSERT INTO ESQ_ACTIVITY_TYPE (AT_PK, AT_NAME, AT_DESC) VALUES
 (1, 'Deposit',    'Deposit'),
 (2, 'Withdrawal', 'Withdrawal'),
 (3, 'Transfer',   'Transfer funds');

SELECT 'Done' AS status;
