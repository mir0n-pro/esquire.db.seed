-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	triggers/drop.sql
-- desc:	Drop of audit-log triggers (option-a opt-out; base seed is trigger-free)
--
-----------------------------------
-- History:
-- 06/03/2026 mir0n Created

-- Idempotent: drops every ESQ_ trigger (and its function) by NAME MASK -- no strict list,
-- so triggers added later are covered without editing this file.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT t.tgname AS trg, c.relname AS tbl, t.tgfoid::regprocedure::text AS fnsig
    FROM pg_trigger t
    JOIN pg_class c ON c.oid = t.tgrelid
    WHERE NOT t.tgisinternal
      AND t.tgname ILIKE 'ESQ\_%'
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I', r.trg, r.tbl);
    EXECUTE 'DROP FUNCTION IF EXISTS ' || r.fnsig;
  END LOOP;
END $$;
