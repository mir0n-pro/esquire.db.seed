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
--  

SPOOL create.list
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
-- Views creation
-- @@views.sql

SPOOL OFF