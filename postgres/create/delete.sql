-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create/delete.sql
-- desc:	Deletion of DB objects
--
-----------------------------------
-- History:
--  
-- 01.08.2000			Created
-- 03.03.2001			Removes all objects


--\set QUIET 1
--\set VERBOSITY terse

\echo -n 'Drop tables\n'
\qecho -n 'Drop tables\n'

DO $$ DECLARE
    r record;
BEGIN
    -- only tables 
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        -- RAISE INFO E'drop table : %\n', r.tablename;
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;

\echo -n 'Drop sequences\n'
\qecho -n 'Drop sequences\n'
DO $$ DECLARE
    r record;
BEGIN
    -- only sequences
    FOR r IN (SELECT sequencename FROM pg_sequences WHERE schemaname = 'public') LOOP
        -- RAISE INFO E'drop sequence: %\n', r.sequencename;
        EXECUTE 'DROP SEQUENCE IF EXISTS ' || quote_ident(r.sequencename) ;
    END LOOP;
END $$;
--\set QUIET 0
 