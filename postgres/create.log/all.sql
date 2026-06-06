-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create.log/all.sql
-- desc:	Creation of audit-log DB objects (separate audit-log schema)
--
-----------------------------------
-- History:
-- 06/04/2026 mir0n created: audit-log schema isolated from create/ (deployable to esquire_log)

-- Includes are script-relative (\ir) so this runs correctly both standalone (from create.log/)
-- and when invoked from create/all.sql for the single-DB demo seed.

\echo -n '----- Audit-log: Deletion -----\n'
\qecho -n '----- Audit-log: Deletion -----\n'
\ir delete.sql

\echo -n '----- Audit-log: Tables creation ----- \n'
\qecho -n '----- Audit-log: Tables creation ----- \n'
\ir tables.tab

\echo -n '----- Audit-log: Primary, foreign key indeces ----- \n'
\qecho -n '----- Audit-log: Primary, foreign key indeces ----- \n'
\ir tables.pfi
