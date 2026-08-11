-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	triggers/all.sql
-- desc:	Creation of audit log triggers
--
-----------------------------------
-- History:
-- 02/24/2026 mir0n Created
-- 08/11/2026 mir0n v1.2.12 esq_bank_info_briud removed from the include list

SPOOL triggers.list
-- ESQ_ADDRESS
@@esq_address_briud.sql
-- ESQ_PERSON
@@esq_person_briud.sql
-- ESQ_USR
@@esq_user_briud.sql
-- ESQ_AUTH
@@esq_auth_briud.sql
-- ESQ_ORG
@@esq_org_briud.sql
-- ESQ_ACCOUNT
@@esq_account_briud.sql
-- ESQ_USR_PAR
@@esq_usr_par_briud.sql
-- ESQ_ORG_PAR
@@esq_org_par_briud.sql

SPOOL OFF
