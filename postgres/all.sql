-----------------------------------
-- project:	Esquire
-- version:	1.0
-- Copyright (c) Miron 2000
--
-- file :	all.sql
-- desc:	Database creation script
--
-----------------------------------
-- History:
--  
-- 01.08.2000			Created
-- 06.20.2000			Reviewed
-- 07/03/2026 mir0n v1.2.10 all.sql rewritten psql-native (\cd + \i, mirroring init.sh: create/all.sql then fill/all.sql) -- was Oracle SQL*Plus @@/PROMPT

-- Full Postgres seed: schema creation, then data fill. Mirrors
-- services/postgres/initdb/init.sh, which runs create/all.sql then fill/all.sql,
-- each from within its own directory so the children's relative \i includes resolve.
-- Run from this directory:  psql -v ON_ERROR_STOP=1 -U esq2025 -d esq2025 -f all.sql

\echo ========================================================
\echo = CREATION
\cd create
\i all.sql
\cd ..

\echo = FILL OUT
\cd fill
\i all.sql
\cd ..

\echo THE END
\echo ========================================================


