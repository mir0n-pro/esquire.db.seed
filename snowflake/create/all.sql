-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create/all.sql
-- desc:	Creation of DB objects (Snowflake)
--
-- Run with SnowSQL:
--   snowsql -a <account> -u esq2025 -d esq2025 -s public -f create/all.sql
-- Or from SnowSQL prompt:
--   !source create/all.sql
-----------------------------------
-- History:
-- 03/08/2026 Snowflake version created

USE WAREHOUSE ESQ_WH;
USE DATABASE ESQ2025;
USE SCHEMA PUBLIC;

-----------------------------------
SELECT '----- Deletion -----' AS status;
!source create/delete.sql

SELECT '----- Tables creation -----' AS status;
!source create/tables.tab

SELECT '----- Primary, foreign key constraints -----' AS status;
!source create/tables.pfi

SELECT '----- Check constraints -----' AS status;
!source create/tables.cc

SELECT '----- Sequences creation -----' AS status;
!source create/tables.sqs

SELECT '----- Streams and Tasks (audit logging) -----' AS status;
!source streams/all.sql

SELECT '----- Word index -----' AS status;
!source create/word_index.sql

SELECT '===== CREATION COMPLETE =====' AS status;
