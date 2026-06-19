-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2025
--
-- file :	dedup/drop.sql
-- desc:	Drop of the audit-log dedup unique indexes (overlay opt-out; base seed is dedup-free)
--
-----------------------------------
-- History:
-- 06/19/2026 mir0n Created

-- Idempotent: drops every ESQ_*_LOG_DEDUP_UK index by NAME MASK -- no strict list, so an index added
-- later is covered without editing this file.
BEGIN
  FOR i IN (SELECT index_name FROM user_indexes
            WHERE index_name LIKE 'ESQ\_%\_LOG\_DEDUP\_UK' ESCAPE '\') LOOP
    EXECUTE IMMEDIATE 'DROP INDEX ' || i.index_name;
  END LOOP;
END;
/
