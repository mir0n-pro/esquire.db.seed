# Release Report: v1.2.15 → HEAD

**Repo:** `esquire.db.seed/develop2`  
**Top commit:** `057a6be`

---

## Release Notes

### doc/release_notes.txt


**11/22/2026** v2.0.2 login ids in lower case  
&nbsp;- the 2.0 line of the seed begins; Esquire 2.0 builds read it, and 1.2 keeps its own  
&nbsp;- every login id is kept in lower case, the way the sign-in server keeps its user names; the two load-test users are seeded that way  
&nbsp;- a Postgres forward migration lower-cases the login ids of a database that is already seeded  
&nbsp;- the recorded database version moves to 2.0.2  
&nbsp;- doc: the README carries one note for this release in place of the 1.2 release notes, which stay with the 1.2 line, and a Release History section; its schema-and-migrations link goes to the 2.0 services  
&nbsp;- both Oracle and Postgres branches (the forward-migration patch is Postgres-only)  

---

## Code Changes

### oracle/changes.txt


**11/22/2026** v2.0.2 login ids in lower case; DB_VERSION -> 2.0.2  
**fill\initial-entities.sql**  
&nbsp;- Test Drivers S and M (usr_pk=16,17) au_login_id in lower case: esq-hauberk-s, esq-hauberk-m  
**fill\root.sql**  
&nbsp;- DB_VERSION 1.2.15 -> 2.0.2  

### postgres/changes.txt


**11/22/2026** v2.0.2 login ids in lower case; DB_VERSION -> 2.0.2  
**fill\initial-entities.sql**  
&nbsp;- Test Drivers S and M (usr_pk=16,17) au_login_id in lower case: esq-hauberk-s, esq-hauberk-m  
**fill\root.sql**  
&nbsp;- DB_VERSION 1.2.15 -> 2.0.2  
**patch\v2.0.2\forward.sql  (new)**  
&nbsp;- created: AU_LOGIN_ID lower case; DB_VERSION 1.2.15 -> 2.0.2  

---

## Commits

```

-- 2026-11-22 | commit: 057a6be | mir0n.the.programmer | v2.0.2 login ids in lower case --
M	README.md
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
A	postgres/patch/v2.0.2/forward.sql
 9 files changed, 90 insertions(+), 58 deletions(-)

-- 2026-09-07 | commit: 890de34 | mir0n.the.programmer | Create report_v1.2.15.md --
A	doc/reports/report_v1.2.15.md
 1 file changed, 89 insertions(+)
```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.15.md
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
A	postgres/patch/v2.0.2/forward.sql
 10 files changed, 179 insertions(+), 58 deletions(-)
```

---

*From `v1.2.15` till `HEAD`*
