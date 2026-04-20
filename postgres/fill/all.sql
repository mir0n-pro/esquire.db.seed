-----------------------------------
-- project:	Esquire
-- version:	1.0
-- Copyright (c) Miron 2000
--
-- file :	fill/all.sql
-- desc:	Fills out the tables
--
-----------------------------------
-- History:
--  
-- 01.08.2000			Created
-- 06.20.2000			Reviewed
-- 01/14/2026 mir0n Roles added

--\set QUIET 1
--\set VERBOSITY terse
\o esq2025-fill.log
-----------------------------------
\echo -n '----- Delete -----\n'
\qecho -n '----- Delete -----\n'
\i delete.sql
-----------------------------------
\echo -n '----- Entity Types -----\n'
\qecho -n '----- Entity Types -----\n'
\i esq_entity_type.sql
-----------------------------------
\echo -n '----- Parameters -----\n'
\qecho -n '-----  Parameters -----\n'
\i esq_parameter.sql
-----------------------------------
\echo -n '----- Permission types -----\n'
\qecho -n '----- Permission types -----\n'
\i esq_permission_type.sql
-----------------------------------
\echo -n '----- Permissions -----\n'
\qecho -n '----- Permissions -----\n'
\i esq_permission.sql
-----------------------------------
\echo -n '----- Activity types -----\n'
\qecho -n '----- Activity types -----\n'
\i esq_activity_type.sql
-----------------------------------
\echo -n '----- Roles -----\n'
\qecho -n '----- Roles -----\n'
\i esq_role.sql
-----------------------------------
\echo -n '----- Root -----\n'
\qecho -n '----- Root -----\n'
\i root.sql

\echo -n '----- Initial entities -----\n'
\qecho -n '----- Initial entities -----\n'
\i initial-entities.sql

\o
\set QUIET 0
