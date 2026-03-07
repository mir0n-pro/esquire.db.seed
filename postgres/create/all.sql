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
-- 02/24/2026 mir0n Triggers creation section added

\set QUIET 1
\set VERBOSITY terse
--SHOW client_min_messages;
--SHOW log_min_messages;
SET client_min_messages = 'info';
-- SET log_min_messages = 'log';

\o create.lst
--\r
\echo -n '----- Deletion -----\n'
\qecho -n '----- Deletion -----\n'
\i delete.sql

\echo -n '----- Tables creation ----- \n'
\qecho -n '----- Tables creation ----- \n'
\i tables.tab

\echo -n '----- Primary, foreign key indeces ----- \n'
\qecho -n '----- Primary, foreign key indeces ----- \n'
\i tables.pfi

\echo -n '----- Check constraints ----- \n'
\qecho -n '----- Check constraints ----- \n'
\i tables.cc

\echo -n '----- Sequencies creation ----- \n'
\qecho -n '----- Sequencies creation ----- \n'
\i tables.sqs

\echo -n '----- Triggers creation ----- \n'
\qecho -n '----- Triggers creation ----- \n'
\i ../triggers/all.sql

\echo -n '----- Word index ----- \n'
\qecho -n '----- Word index ----- \n'
\i word_index.sql

--\w buffer.list
\o
\set QUIET 0

--\q