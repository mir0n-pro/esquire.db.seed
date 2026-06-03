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

-- Idempotent: drops every ESQ_ trigger by NAME MASK -- no strict list,
-- so triggers added later are covered without editing this file.
BEGIN
  FOR t IN (SELECT trigger_name FROM user_triggers
            WHERE trigger_name LIKE 'ESQ\_%' ESCAPE '\') LOOP
    EXECUTE IMMEDIATE 'DROP TRIGGER ' || t.trigger_name;
  END LOOP;
END;
/
