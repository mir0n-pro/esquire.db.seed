# Release Report: v1.2.12 → v1.2.15

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `56032e2`

---

## Release Notes

### doc/release_notes.txt


**09/06/2026** v1.2.15 the seeded client is an activated login  
&nbsp;- the seeded client can sign in, matching the account the sign-in server's realm import already carries for it  
&nbsp;- two unused practice roles dropped from the Postgres branch, which the Oracle branch never had, so the two now seed the same set  
&nbsp;- the recorded database version moves to 1.2.15  
&nbsp;- both Oracle and Postgres branches (the practice roles existed only in Postgres)  

---

## Code Changes

### oracle/changes.txt


**09/06/2026** v1.2.15 the seeded client is an activated login  
**fill\initial-entities.sql**  
&nbsp;- client (usr_pk=10) au_connect_flg 'N' -> 'Y'  
**fill\root.sql**  
&nbsp;- DB_VERSION 1.2.12 -> 1.2.15  

### postgres/changes.txt


**09/06/2026** v1.2.15 the seeded client is an activated login  
**fill\initial-entities.sql**  
&nbsp;- client (usr_pk=10) au_connect_flg 'N' -> 'Y'  
**fill\esq_role.sql**  
&nbsp;- VAS-VAS (role_pk=9) and SAV-SAV (role_pk=10) removed  
**fill\root.sql**  
&nbsp;- DB_VERSION 1.2.12 -> 1.2.15  

---

## Commits

```

-- 2026-09-06 | commit: 56032e2 | mir0n.the.programmer | v1.2.15 the seeded client is an activated login --
M	README.md
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/fill/esq_role.sql
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/esq_role.sql
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
 10 files changed, 51 insertions(+), 64 deletions(-)

-- 2026-08-11 | commit: 42d780e | mir0n.the.programmer | Create report_v1.2.12.md --
A	doc/reports/report_v1.2.12.md
 1 file changed, 254 insertions(+)

```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.12.md
M	oracle/changes.txt
M	oracle/fill/esq_role.sql
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/esq_role.sql
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
 11 files changed, 305 insertions(+), 64 deletions(-)
```

---

*From `v1.2.12` till `v1.2.15`*
