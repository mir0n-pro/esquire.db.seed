# <img src="./favicon.ico" alt="Esquire logo" valign="middle" width="64" height="64"> Esquire Application Frameworks(tm) 2.0

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

## v1.2.8 — complete (06/19/2026)

The seed-side change for the v1.2.8 sprint is a **system-entity flag** (anti-deletion): the framework's own
foundational entities are marked at the database level so they cannot be deleted through the application.
Across both the Oracle and Postgres branches:

- **`ORG_SYSTEM_FLG` / `USR_SYSTEM_FLG` columns** -- a one-character `Y`/`N` flag (default `'N'`, NOT NULL) added to `ESQ_ORG` and `ESQ_USER`; `'Y'` marks a system entity protected from deletion, with matching column comments
- **seeded on the core entities** -- set `'Y'` on the root and Test House orgs (`org_pk` 1, 14) and the system / admin / test-harness users (`usr_pk` 4, 5, 15, 16, 17), so a fresh seed comes up already protected
- **DB-set only** -- the flag is set in the seed and never written through the app or shown on the GUI; it is a database-level guard enforced underneath the service tier

## v1.2.7 — complete (06/10/2026)

The seed-side **audit-logging** sprint: the audit schema is fully decoupled from the base seed — a trigger-free base, the nine `esq_*_log` tables isolated into an opt-in `create.log/` overlay, nullable log columns, and a dedup unique index per `*_log` table backing the bus path's idempotent fan-out — across both Oracle and Postgres.<br>
[More Details: v1.2.7 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.7?tab=readme-ov-file)

## v1.2.4 — complete (05/14/2026)

Seeds the **Test House** subtree for the hauberk load harness — a Test House org under root with three admin users, one per non-browser gateway auth pattern (Plain JWT, Vanilla Token Relay, Phantom Token Relay), backing the matching Keycloak service accounts.<br>
[More Details: v1.2.4 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.4?tab=readme-ov-file)

## v1.2.2 — complete (04/20/2026)

Aligns the schema and seed data with the first complete backend milestone — audit columns and BRIUD triggers across all entity tables, a dedicated entity-path satellite, the expanded accounting / transaction schema, the role-permission FK rework, and tightened referential integrity — on both Oracle and Postgres.<br>
[More Details: v1.2.2 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.2?tab=readme-ov-file)
