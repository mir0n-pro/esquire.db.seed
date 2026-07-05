# Release Report: v1.2.9 → v1.2.10

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `3b65eaa`

---

## Release Notes

### doc/release_notes.txt


**07/03/2026** v1.2.10 collected-backlog fixes  
&nbsp;- ESQ_ENTITY_PATH.EP_PATH validate/recover utility (data-fix; validate + optional fix)  
&nbsp;- postgres seed aggregator all.sql corrected to psql-native (was Oracle SQL*Plus @@/PROMPT)  
&nbsp;- DB_VERSION parameter bumped to 1.2.10 (both branches)  
&nbsp;- the recover utility lands on both Oracle and Postgres branches; the all.sql fix is Postgres-only  

---

## Code Changes

### oracle/changes.txt


**07/03/2026** v1.2.10 EP_PATH validate/recover utility; DB_VERSION -> 1.2.10  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.9 -> 1.2.10  
**patch\v1.2.10\forward.sql  (new)**  
&nbsp;- forward migration for an already-created DB: DB_VERSION 1.2.9 -> 1.2.10 only (no schema change this release)  
**data-fix\fix-path.sql  (new)**  
&nbsp;- validate/recover ESQ_ENTITY_PATH.EP_PATH from the FK hierarchy (office/user/account) via a PL/SQL loop; DBMS_OUTPUT report, 'fix' mode UPDATEs to the canonical path  

### postgres/changes.txt


**07/03/2026** v1.2.10 EP_PATH validate/recover utility; all.sql aggregator rewritten psql-native; DB_VERSION -> 1.2.10  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.9 -> 1.2.10  
**patch\v1.2.10\forward.sql  (new)**  
&nbsp;- forward migration for an already-seeded DB: DB_VERSION 1.2.9 -> 1.2.10 only (no schema change this release)  
**data-fix\fix-path.sql  (new)**  
&nbsp;- validate/recover ESQ_ENTITY_PATH.EP_PATH from the FK hierarchy (office/user/account); reports mismatches + orphans; apply=on UPDATEs to the canonical path  
**all.sql**  
&nbsp;- rewritten psql-native (\cd + \i, mirroring services/postgres/initdb/init.sh: create/all.sql then fill/all.sql); was Oracle SQL*Plus @@/PROMPT  

---

## Commits

```

-- 2026-07-04 | commit: 3b65eaa | mir0n.the.programmer | v1.2.10 -- version finalizing --
M	README.md
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 2026-07-03 | commit: 25bf9dc | mir0n.the.programmer | v1.2.10 collected-backlog fixes --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
A	oracle/data-fix/fix-path.sql
A	oracle/data-fix/fix.bat
A	oracle/data-fix/validate.bat
M	oracle/fill/root.sql
A	oracle/patch/v1.2.10/forward.sql
M	postgres/all.sql
M	postgres/changes.txt
A	postgres/data-fix/fix-path.sql
A	postgres/data-fix/fix.bat
A	postgres/data-fix/validate.bat
M	postgres/fill/root.sql
A	postgres/patch/v1.2.10/forward.sql
 15 files changed, 293 insertions(+), 15 deletions(-)

-- 2026-06-25 | commit: 75a444b | mir0n.the.programmer | Create report_v1.2.9.md --
A	doc/reports/report_v1.2.9.md
 1 file changed, 116 insertions(+)
```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.9.md
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
A	oracle/data-fix/fix-path.sql
A	oracle/data-fix/fix.bat
A	oracle/data-fix/validate.bat
M	oracle/fill/root.sql
A	oracle/patch/v1.2.10/forward.sql
M	postgres/all.sql
M	postgres/changes.txt
A	postgres/data-fix/fix-path.sql
A	postgres/data-fix/fix.bat
A	postgres/data-fix/validate.bat
M	postgres/fill/root.sql
A	postgres/patch/v1.2.10/forward.sql
 17 files changed, 418 insertions(+), 21 deletions(-)
```

---

*From `v1.2.9` till `v1.2.10`*
