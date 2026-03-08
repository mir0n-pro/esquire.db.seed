-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000, 2001, 2025
--
-- file :	create/tables.cc
-- desc:	Check constraints (Snowflake)
--
-- NOTE: Snowflake supports CHECK constraints but does NOT enforce them.
--       They serve as documentation/metadata only.
-- 03/08/2026 Snowflake version created
-----------------------------------

SELECT 'Creating Check Constraint on ESQ_USER' AS status;
ALTER TABLE ESQ_USER
 ADD CONSTRAINT ESQ_USR_DELETED_FLG_CC CHECK (USR_DELETED_FLG IN ('Y','N'));

SELECT 'Creating Check Constraint on ESQ_AUTH' AS status;
ALTER TABLE ESQ_AUTH
 ADD CONSTRAINT ESQ_AU_CONNECT_FLG_CC CHECK (AU_CONNECT_FLG IN ('Y','N'));
ALTER TABLE ESQ_AUTH
 ADD CONSTRAINT ESQ_AU_TFA_METHOD_CC CHECK (AU_TFA_METHOD IN ('N','G','g'));

SELECT 'Creating Check Constraint on ESQ_ACCOUNT' AS status;
ALTER TABLE ESQ_ACCOUNT
 ADD CONSTRAINT ESQ_ACC_STATUS_CC CHECK (ACC_STATUS IN ('O','L','C'));

SELECT 'Creating Check Constraint on ESQ_ENTITY_TYPE' AS status;
ALTER TABLE ESQ_ENTITY_TYPE
 ADD CONSTRAINT ESQ_ET_ACC_FLG_CC CHECK (ET_ACC_FLG IN ('Y','N'));
ALTER TABLE ESQ_ENTITY_TYPE
 ADD CONSTRAINT ESQ_ET_USR_FLG_CC CHECK (ET_USR_FLG IN ('Y','N'));
ALTER TABLE ESQ_ENTITY_TYPE
 ADD CONSTRAINT ESQ_ET_ORG_FLG_CC CHECK (ET_ORG_FLG IN ('Y','N'));
ALTER TABLE ESQ_ENTITY_TYPE
 ADD CONSTRAINT ESQ_ET_LINK_FLG_CC CHECK (ET_LINK_FLG IN ('Y','N'));

SELECT 'Creating Check Constraint on ESQ_PARAMETER' AS status;
ALTER TABLE ESQ_PARAMETER
 ADD CONSTRAINT ESQ_PAR_READWRITE_CC CHECK (PAR_READWRITE IN (0,1,3));
ALTER TABLE ESQ_PARAMETER
 ADD CONSTRAINT ESQ_PAR_TYPE_CC CHECK (PAR_TYPE IN ('string','text','flag','number','date', 'datetime', 'tablist', 'tabstring', 'href', 'image' ));
ALTER TABLE ESQ_PARAMETER
 ADD CONSTRAINT PAR_NULLABLE_FLG_CC CHECK (PAR_NULLABLE_FLG IN ('Y','N'));
