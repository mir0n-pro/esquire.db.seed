<table style="width: 100%; table-layout: fixed;">
  <tr>
    <td style="width: 12%"><img src="./favicon.ico" alt="Esquire logo" align="right" valign="middle" width="64"></td>
    <td style="width: 88%;">
       <h1>Esquire Application Frameworks(tm) 2.0</h1>
    </td>
  </tr>
</table>

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

The seed builds the same schema on **Postgres** and **Oracle**, and every release is written for both.

## Deployment

A new database is created by running the seed -- a developer's stack, a test run, a new environment. The
Postgres container image carries the seed inside it.

A database that is already live and holding data is moved forward by a patch instead: a script that changes
the schema in place and leaves the data where it is. It is run on demand against that database, and each
patch file carries its exact command in its own header. **Patches are written for Postgres.** An Oracle
database is created from the seed whenever a new version is wanted, so it starts with that version already
in it and has nothing to migrate.

A release that both adds and removes comes as **two patches, run either side of the deployment**. The first
one only adds -- new columns the running release does not know about and does not have to. The services are
then updated, and the second patch removes what the old release needed and refreshes anything built on top of
the old shape. Splitting it this way is what lets the database move forward while the site stays up: a single
script would take away, from a release still serving, something it is still using.

No schema-migration tool takes part in any of this, and the framework does not impose one. Esquire ships a
foundation schema that an adopter extends with their own domain, so that choice stays theirs. The reasoning
is written out in [Database schema and migrations](https://github.com/mir0n-pro/esquire.services/blob/develop/doc/Esquire.Q%26A.md#database-schema-and-migrations).

## v1.2.15 — complete (09/06/2026)

The seed-side change for the v1.2.15 **user activation** sprint. A fresh install now starts with the seed
and the sign-in server saying the same thing about the same people:

- **the demonstration client can sign in** -- the seeded client is marked as an activated login, matching
  the account the sign-in server has always carried for it. The two sides of a fresh install agree from the
  start, and the check that compares them reports nothing to fix
- **the two branches seed the same roles** -- two practice roles that existed only in the Postgres branch
  are gone, so Oracle and Postgres now hand out the same set
- **the recorded database version reads 1.2.15**

## v1.2.12 — complete (08/11/2026)

The seed-side work for the v1.2.12 **entity change number** sprint: a change number on every entity and sub-entity, a counter of its own on the table that records where each entity sits, the change history and the ledger both carrying that number, repeat protection rekeyed on the record and its number, the unused bank-details table and the old entity-key generator removed, and a Postgres patch that applies all of it to an already-seeded database. Across both Oracle and Postgres.<br>
[More Details: v1.2.12 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.12?tab=readme-ov-file)

## v1.2.11 — complete (07/25/2026)

The seed-side change for the v1.2.11 **Observability** sprint: a set of schema-definition corrections -- a server-side "now (UTC)" default on the ledger timestamp, the parameter-type default corrected to lower-case so it matches its own allowed-values check, and a foreign-key index name typo fixed -- plus a Postgres forward-migration patch for an already-seeded database. Across both Oracle and Postgres.<br>
[More Details: v1.2.11 README](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.11?tab=readme-ov-file)

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
