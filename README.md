# <img src="./favicon.ico" alt="Esquire logo" valign="middle" width="64" height="64"> Esquire Application Frameworks(tm) 2.0

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

## v1.2.9 — complete (06/24/2026)

The seed-side change for the v1.2.9 **hardening** sprint brings the Postgres branch in line with Oracle and
speeds up the most common tree reads. Across both the Oracle and Postgres branches:

- **entity created-timestamps on Postgres** -- the three "when this entity was created" columns Oracle already carried are added to offices, users and accounts, filled automatically the moment the row is created
- **entity-path index** -- an index on the entity path, so moving a branch of the tree and reading a user's own scoped area no longer scan the whole path table
- **optional audit time-range index** -- an off-by-default index for date-range audit-log queries, one per audit-log table, applied by hand when wanted and never loaded by the seed

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
