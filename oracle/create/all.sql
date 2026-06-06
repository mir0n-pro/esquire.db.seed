-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create/all.sql
-- desc:	Creation of DB objects
--
-----------------------------------
-- History:
-- 02/28/2026 mir0n Triggers creation section added
-- 06/03/2026 mir0n Triggers include removed -- base seed trigger-free (opt-in triggers/all.sql, opt-out triggers/drop.sql)

SPOOL esq2025-create.log
-- Deletion
@@delete.sql
-- Tables creation
@@tables.tab
-- Primary, foreign key indeces
@@tables.pfi
-- Check constraints
@@tables.cc
-- Sequencies creation
@@tables.sqs
-- Audit-log schema (create.log)
@@../create.log/all.sql
-- Views creation
-- @@views.sql
-- Triggers: OPTIONAL overlay -- base seed is trigger-free (audit logging is a pluggable concern).
-- To opt into in-database audit triggers (option a), run AFTER this seed:  @@../triggers/all.sql
-- To remove them again:                                                    @@../triggers/drop.sql

SPOOL OFF