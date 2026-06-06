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

-- @@ includes are script-relative, so this runs both standalone (from create.log/) and when
-- invoked from create/all.sql for the single-DB demo seed (no own SPOOL: inherits the caller's).

-- Audit-log: Deletion
@@delete.sql
-- Audit-log: Tables creation
@@tables.tab
-- Audit-log: Primary, foreign key indeces
@@tables.pfi
