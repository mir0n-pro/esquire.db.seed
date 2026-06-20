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

-- Audit-log dedup unique indexes: the (crl_id + the row's own pk[, kind, sub_id]) identity. They make the
-- BUS audit (option c/ck) idempotent under at-least-once redelivery -- a replayed message collides on this
-- key and the apply's INSERT .. ON CONFLICT DO NOTHING drops it -> exactly one log row per (op, row).
--
-- They are OPTIONAL and mutually exclusive with the DB-trigger audit (option a): a trigger fires per
-- physical DML op, so one request that does INSERT then UPDATE on a row writes TWO log rows with the SAME
-- dedup key -> a unique-violation that rolls the business write back. Apply this overlay for bus-audit
-- idempotency; leave it off (or drop it) when running the DB triggers.
\echo -n Creating unique index 'ESQ_ACCOUNT_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_account_log_dedup_uk ON esq_account_log (accl_crl_id, accl_pk);

\echo -n Creating unique index 'ESQ_ORG_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_org_log_dedup_uk ON esq_org_log (orgl_crl_id, orgl_pk);

\echo -n Creating unique index 'ESQ_USER_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_user_log_dedup_uk ON esq_user_log (usrl_crl_id, usrl_pk);

\echo -n Creating unique index 'ESQ_ORG_PAR_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_org_par_log_dedup_uk ON esq_org_par_log (oprl_crl_id, oprl_org_pk, oprl_par_name);

\echo -n Creating unique index 'ESQ_USR_PAR_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_usr_par_log_dedup_uk ON esq_usr_par_log (uprl_crl_id, uprl_usr_pk, uprl_par_name);

\echo -n Creating unique index 'ESQ_PERSON_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_person_log_dedup_uk ON esq_person_log (pel_crl_id, pel_usr_pk, pel_kind);

\echo -n Creating unique index 'ESQ_ADDRESS_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_address_log_dedup_uk ON esq_address_log (adl_crl_id, adl_pk);

\echo -n Creating unique index 'ESQ_AUTH_LOG_DEDUP_UK\n'
CREATE UNIQUE INDEX esq_auth_log_dedup_uk ON esq_auth_log (aul_crl_id, aul_usr_pk);
