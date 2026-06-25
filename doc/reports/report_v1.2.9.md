# Release Report: v1.2.8 → v1.2.9

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `451587f`

---

## Release Notes

### doc/release_notes.txt


**06/21/2026** v1.2.9 entity created-timestamp columns (Postgres); path + optional audit time-range indexes  
&nbsp;- Postgres gains the three "entity created" timestamps Oracle already had (offices, users, accounts),  
&nbsp;    filled automatically the moment the row is created  
&nbsp;- both branches get an index on the entity path so moving a branch of the tree, and reading a user's  
&nbsp;    own scoped area, no longer scan the whole path table  
&nbsp;- an optional, off-by-default index for date-range audit queries -- one per audit-log table, applied by  
&nbsp;    hand when wanted, never loaded by the seed (create.log/recommended.pfi)  
&nbsp;- both Oracle and Postgres branches  

---

## Code Changes

### oracle/changes.txt


**06/21/2026** v1.2.9 ep_path + optional audit-log time-range indexes  
**create\tables.pfi**  
&nbsp;- ESQ_EP_PATH_I index on ESQ_ENTITY_PATH (EP_PATH)  
**create.log\recommended.pfi (new)**  
&nbsp;- optional overlay (NOT included by create.log/all.sql): one index per ESQ_*_LOG on its  
&nbsp;* _ACTION_TS (ADL_/BIL_/PEL_/USRL_/AUL_/ORGL_/ACCL_/UPRL_/OPRL_ACTION_TS; named _ACTION_TS_I)  
**create.log\tables.pfi**  
&nbsp;- pointer to the optional ./recommended.pfi overlay added (no DDL change)  

### postgres/changes.txt


**06/21/2026** v1.2.9 entity created-timestamp columns; ep_path + optional audit-log time-range indexes  
**create\tables.tab**  
&nbsp;- ESQ_USER.USR_CREATED_TS, ESQ_ORG.ORG_CREATED_TS, ESQ_ACCOUNT.ACC_CREATED_TS  
&nbsp;    TIMESTAMP DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') + column comments  
**create\tables.pfi**  
&nbsp;- ESQ_EP_PATH_I index on ESQ_ENTITY_PATH (EP_PATH text_pattern_ops)  
**create.log\recommended.pfi (new)**  
&nbsp;- optional overlay (NOT included by create.log/all.sql): one btree index per ESQ_*_LOG on its  
&nbsp;* _ACTION_TS (ADL_/BIL_/PEL_/USRL_/AUL_/ORGL_/ACCL_/UPRL_/OPRL_ACTION_TS; named _ACTION_TS_I)  
**create.log\tables.pfi**  
&nbsp;- pointer to the optional ./recommended.pfi overlay added (no DDL change)  

---

## Commits

```

-- 2026-06-25 | commit: 451587f | mir0n.the.programmer | v1.2.9 -- version finalization --
M	README.md
A	oracle/patch/v1.2.9/forward.sql
A	postgres/patch/v1.2.9/forward.sql
 3 files changed, 134 insertions(+), 7 deletions(-)


-- 2026-06-21 | commit: a72361f | mir0n.the.programmer | v1.2.9 entity created-timestamp columns (Postgres); path + optional audit time-range indexes --
M	doc/release_notes.txt
M	oracle/changes.txt
A	oracle/create.log/recommended.pfi
M	oracle/create.log/tables.pfi
M	oracle/create/tables.pfi
M	postgres/changes.txt
A	postgres/create.log/recommended.pfi
M	postgres/create.log/tables.pfi
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
 10 files changed, 147 insertions(+), 2 deletions(-)

-- 2026-06-20 | commit: b3c9913 | mir0n.the.programmer | v1.2.9 -- version bump --
M	oracle/fill/root.sql
M	postgres/fill/root.sql
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 2026-06-20 | commit: 44afe17 | mir0n.the.programmer | Create report_v1.2.8.md --
A	doc/reports/report_v1.2.8.md
 1 file changed, 108 insertions(+)

```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.8.md
M	oracle/changes.txt
A	oracle/create.log/recommended.pfi
M	oracle/create.log/tables.pfi
M	oracle/create/tables.pfi
M	oracle/fill/root.sql
A	oracle/patch/v1.2.9/forward.sql
M	postgres/changes.txt
A	postgres/create.log/recommended.pfi
M	postgres/create.log/tables.pfi
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
M	postgres/fill/root.sql
A	postgres/patch/v1.2.9/forward.sql
 16 files changed, 391 insertions(+), 11 deletions(-)
```

---

*From `v1.2.8` till `v1.2.9`*
