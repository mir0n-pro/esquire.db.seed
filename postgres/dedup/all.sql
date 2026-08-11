-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) mir0n 2000, 2001, 2025
--
-- file :	dedup/all.sql
-- desc:	Creation of the audit-log dedup unique indexes (OPTIONAL overlay)
--
-----------------------------------
-- History:
-- 06/19/2026 mir0n Created: the dedup unique indexes moved OUT of the base seed (create.log/tables.pfi)
--                  into this optional overlay -- like the triggers overlay, applied only when wanted.
-- 08/11/2026 mir0n v1.2.12 the eight dedup unique indexes rekeyed to the row plus its *_CHANGE_NO,
--                  with the correlation id out of the key

-- Audit-log dedup unique indexes: the (sub)entity identity plus its CHANGE NUMBER --
--   entity-id + kind + (optional) sub-entity-id, and *_CHANGE_NO.
-- They make the BUS audit (option c/ck) idempotent under at-least-once redelivery: a replayed message
-- carries the SAME change number, collides on this key, and the apply's INSERT .. ON CONFLICT DO NOTHING
-- leaves exactly one log row per change.
--
-- The key used to be (crl_id + the row's own pk[, kind, sub_id]) -- the correlation id was the
-- per-operation discriminator. The change number belongs to the ROW rather than to a request, so it
-- replaces crl_id: two real changes carry different numbers and both are kept, while a redelivery carries
-- the same number and is dropped.
--
-- NO LONGER mutually exclusive with the DB-trigger audit (option a) -- v1.2.12 removed that limitation.
-- EVERY physical write raises the row's change number, so no two log rows for the same row can ever share
-- one. A request that INSERTs then UPDATEs writes change numbers 1 and 2: the trigger emits two log rows
-- with two distinct keys instead of colliding on one. The auth flag settle (confirmPendingFlags) raises
-- inline in its own UPDATE for the same reason, so it collides with nothing either.
-- The two audit paths simply record at different grains, and both are internally consistent: the TRIGGER
-- path writes one row per physical write (complete sequence), the BUS path one row per transaction
-- carrying the last state (so its sequence has gaps -- expected, and harmless to a receiver that applies
-- on "higher", never on "exactly previous + 1").
\echo -n Creating unique index 'ESQ_ACCOUNT_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_account_log_dedup_uk ON esq_account_log (accl_pk, accl_change_no);

\echo -n Creating unique index 'ESQ_ORG_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_org_log_dedup_uk ON esq_org_log (orgl_pk, orgl_change_no);

\echo -n Creating unique index 'ESQ_USER_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_user_log_dedup_uk ON esq_user_log (usrl_pk, usrl_change_no);

\echo -n Creating unique index 'ESQ_ORG_PAR_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_org_par_log_dedup_uk ON esq_org_par_log (oprl_org_pk, oprl_par_name, oprl_change_no);

\echo -n Creating unique index 'ESQ_USR_PAR_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_usr_par_log_dedup_uk ON esq_usr_par_log (uprl_usr_pk, uprl_par_name, uprl_change_no);

\echo -n Creating unique index 'ESQ_PERSON_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_person_log_dedup_uk ON esq_person_log (pel_usr_pk, pel_kind, pel_change_no);

\echo -n Creating unique index 'ESQ_ADDRESS_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_address_log_dedup_uk ON esq_address_log (adl_pk, adl_change_no);

\echo -n Creating unique index 'ESQ_AUTH_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_auth_log_dedup_uk ON esq_auth_log (aul_usr_pk, aul_change_no);
