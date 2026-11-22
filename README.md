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

---
> 
> **v2.0.2 -- login ids in lower case.** The first release of the seed's 2.0 line, the one Esquire 2.0
> builds read. Every login id is kept in lower case, the way the sign-in server keeps its user names, and
> a Postgres patch lower-cases the login ids of a database that is already seeded.
> 
> The 1.2 line goes on in parallel. Its last release is
> [v1.2.15](https://github.com/mir0n-pro/esquire.db.seed/tree/release/v1.2.15?tab=readme-ov-file).
> See [Release History](#release-history).

---

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
is written out in [Database schema and migrations](https://github.com/mir0n-pro/esquire.services/blob/develop2/doc/Esquire.Q%26A.md#database-schema-and-migrations).

## Release History

**[release_notes.txt](doc/release_notes.txt)** -- the release notes, newest first.

**[report_v2.0.2.md](doc/reports/report_v2.0.2.md)** -- the report of this release.
