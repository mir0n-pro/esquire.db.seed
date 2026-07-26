# <img src="./favicon.ico" alt="Esquire logo" valign="middle" width="64" height="64"> Esquire Application Frameworks(tm) 2.0

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

## v1.2.11 — complete (07/25/2026)

The seed-side change for the v1.2.11 **Observability** sprint is a set of schema-definition corrections, on both Oracle and Postgres:

- **ledger timestamp default** -- `ESQ_ACCT_TRANSACTION.ATR_TS` gains a server-side "now (UTC)" default, so a ledger row is stamped even when the caller omits the time
- **parameter-type default corrected** -- `ESQ_PARAMETER.PAR_TYPE` now defaults to lower-case `string`, matching its own allowed-values check
- **index name fixed** -- the `ESQ_USR_ROLE` foreign-key index renamed to the intended `UR_ROLE_FK_I` (a double-`_FK` typo)
- **forward-migration patch** -- a Postgres patch applies the above to an already-seeded database and bumps `DB_VERSION` to 1.2.11 (Postgres only; the base seed carries the corrections on both branches)

## v1.2.10 — complete (07/04/2026)

The seed-side change for the v1.2.10 **Resilience / Durability** sprint: a hand-run entity-path validate / recover utility (finds and, on request, repairs a stored path that has drifted out of step with the tree; both branches), and the Postgres all-in-one seed runner rewritten in native Postgres form (Postgres only).<br>
[More Details: v1.2.10 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.10?tab=readme-ov-file)

## v1.2.9 — complete (06/24/2026)

The seed-side change for the v1.2.9 **hardening** sprint: the entity created-timestamp columns added to Postgres to match Oracle, an entity-path index that speeds tree moves and scoped reads, and an optional off-by-default audit time-range index -- across both Oracle and Postgres.<br>
[More Details: v1.2.9 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.9?tab=readme-ov-file)

## v1.2.8 — complete (06/19/2026)

The seed-side **system-entity flag** (anti-deletion): a one-character `Y`/`N` column (default `'N'`, NOT NULL)
on `ESQ_ORG` and `ESQ_USER`, seeded `'Y'` on the root / Test House orgs and the core users so the framework's
foundational entities cannot be deleted through the app -- DB-set only, across both Oracle and Postgres.<br>
[More Details: v1.2.8 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.8?tab=readme-ov-file)

## v1.2.7 — complete (06/10/2026)

The seed-side **audit-logging** sprint: the audit schema is fully decoupled from the base seed — a trigger-free base, the nine `esq_*_log` tables isolated into an opt-in `create.log/` overlay, nullable log columns, and a dedup unique index per `*_log` table backing the bus path's idempotent fan-out — across both Oracle and Postgres.<br>
[More Details: v1.2.7 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.7?tab=readme-ov-file)

## v1.2.4 — complete (05/14/2026)

Seeds the **Test House** subtree for the hauberk load harness — a Test House org under root with three admin users, one per non-browser gateway auth pattern (Plain JWT, Vanilla Token Relay, Phantom Token Relay), backing the matching Keycloak service accounts.<br>
[More Details: v1.2.4 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.4?tab=readme-ov-file)

## v1.2.2 — complete (04/20/2026)

Aligns the schema and seed data with the first complete backend milestone — audit columns and BRIUD triggers across all entity tables, a dedicated entity-path satellite, the expanded accounting / transaction schema, the role-permission FK rework, and tightened referential integrity — on both Oracle and Postgres.<br>
[More Details: v1.2.2 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.2?tab=readme-ov-file)
