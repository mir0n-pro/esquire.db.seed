-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create.log/delete.sql
-- desc:	Deletion of audit-log DB objects
--
-----------------------------------
-- History:
-- 06/04/2026 mir0n created: drops the *_log audit tables
-- 08/11/2026 mir0n v1.2.12 ESQ_BANK_INFO_LOG dropped from the drop list

\echo -n 'Drop audit-log tables\n'
\qecho -n 'Drop audit-log tables\n'

DROP TABLE IF EXISTS ESQ_ADDRESS_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_PERSON_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_USER_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_AUTH_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_ORG_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_ACCOUNT_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_USR_PAR_LOG CASCADE;
DROP TABLE IF EXISTS ESQ_ORG_PAR_LOG CASCADE;
