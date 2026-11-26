# Release Report: v2.0.2 → HEAD

**Repo:** `esquire.db.seed/develop2`  
**Top commit:** `9d547e7`

---

## Release Notes

### doc/release_notes.txt


**11/24/2026** v2.0.3 the token relay test drivers removed  
&nbsp;- the two load-test users kept only for the retired token relay sign-ins are no longer seeded  
&nbsp;- a Postgres forward migration removes them from a database that is already seeded  
&nbsp;- the recorded database version moves to 2.0.3  
&nbsp;- both Oracle and Postgres branches (the forward-migration patch is Postgres-only)  

---

## Code Changes

### oracle/changes.txt


**11/24/2026** v2.0.3 the token relay test drivers removed; DB_VERSION -> 2.0.3  
**fill\initial-entities.sql**  
&nbsp;- Test Drivers S and M (usr_pk=16,17) removed; system entity flags usr_pk (4,5,15)  
**fill\root.sql**  
&nbsp;- DB_VERSION 2.0.2 -> 2.0.3  

### postgres/changes.txt


**11/24/2026** v2.0.3 the token relay test drivers removed; DB_VERSION -> 2.0.3  
**fill\initial-entities.sql**  
&nbsp;- Test Drivers S and M (usr_pk=16,17) removed; system entity flags usr_pk (4,5,15)  
**fill\root.sql**  
&nbsp;- DB_VERSION 2.0.2 -> 2.0.3  
**patch\v2.0.3\forward.sql  (new)**  
&nbsp;- created: Test Drivers S and M (usr_pk=16,17) removed; DB_VERSION 2.0.2 -> 2.0.3  

---

## Commits

```

-- 2026-11-26 | commit: 9d547e7 | mir0n.the.programmer | v2.0.3 -- finalization --
M	README.md
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 2026-11-24 | commit: 1bf5d87 | mir0n.the.programmer | v2.0.3 the token relay test drivers removed --
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
A	postgres/patch/v2.0.3/forward.sql
 8 files changed, 71 insertions(+), 64 deletions(-)
```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
A	postgres/patch/v2.0.3/forward.sql
 9 files changed, 76 insertions(+), 68 deletions(-)
```

---

*From `v2.0.2` till `HEAD`*
