# Release Report: v1.2.7 → v1.2.8

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `9c32335`

---

## Release Notes

### doc/release_notes.txt


**06/12/2026** v1.2.8 system entity flag (anti-deletion) on ESQ_ORG / ESQ_USER  
&nbsp;- ORG_SYSTEM_FLG / USR_SYSTEM_FLG VARCHAR(1) DEFAULT 'N' NOT NULL + Y/N check; DB-set only, not GUI-visible  
&nbsp;- seed flags the protected set 'Y': org 1 (root) + 14 (Test House); users 4, 5, 15, 16, 17  
&nbsp;- both Oracle and Postgres branches  

---

## Code Changes

### oracle/changes.txt


**06/12/2026** v1.2.8 system entity flag (anti-deletion)  
**create\tables.tab**  
&nbsp;- ESQ_ORG.ORG_SYSTEM_FLG, ESQ_USER.USR_SYSTEM_FLG VARCHAR2(1) DEFAULT 'N' NOT NULL + column comments  
**create\tables.cc**  
&nbsp;- ESQ_ORG_SYSTEM_FLG_CC / ESQ_USR_SYSTEM_FLG_CC CHECK (... IN ('Y','N'))  
**fill\initial-entities.sql**  
&nbsp;- System entity flags block sets 'Y' on org_pk (1,14) and usr_pk (4,5,15,16,17); DB-set only  

### postgres/changes.txt


**06/12/2026** v1.2.8 system entity flag (anti-deletion)  
**create\tables.tab**  
&nbsp;- ESQ_ORG.ORG_SYSTEM_FLG, ESQ_USER.USR_SYSTEM_FLG VARCHAR(1) DEFAULT 'N' NOT NULL + column comments  
**create\tables.cc**  
&nbsp;- ESQ_ORG_SYSTEM_FLG_CC / ESQ_USR_SYSTEM_FLG_CC CHECK (... IN ('Y','N'))  
**fill\initial-entities.sql**  
&nbsp;- System entity flags block sets 'Y' on org_pk (1,14) and usr_pk (4,5,15,16,17); DB-set only  

---

## Commits

```

-- 2026-06-20 | commit: 9c32335 | mir0n.the.programmer | v1.2.8 -- finalizing the version --
M	README.md
M	favicon.ico
M	oracle/create.log/tables.pfi
A	oracle/dedup/all.sql
A	oracle/dedup/drop.sql
M	postgres/create.log/tables.pfi
A	postgres/dedup/all.sql
A	postgres/dedup/drop.sql
 8 files changed, 168 insertions(+), 92 deletions(-)

-- 2026-06-12 | commit: 395b601 | mir0n.the.programmer | v1.2.8 system entity flag (anti-deletion) on ESQ_ORG / ESQ_USER --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.cc
M	oracle/create/tables.tab
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/create/tables.cc
M	postgres/create/tables.tab
M	postgres/fill/initial-entities.sql
 10 files changed, 75 insertions(+), 3 deletions(-)

-- 2026-06-10 | commit: 6c85cac | mir0n.the.programmer | Create report_v1.2.7.md --
A	doc/reports/report_v1.2.7.md
 1 file changed, 172 insertions(+)
```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.7.md
M	erd/ESQ.2026.ERD.vsdx
M	favicon.ico
M	oracle/changes.txt
M	oracle/create.log/tables.pfi
M	oracle/create/tables.cc
M	oracle/create/tables.tab
A	oracle/dedup/all.sql
A	oracle/dedup/drop.sql
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/create.log/tables.pfi
M	postgres/create/tables.cc
M	postgres/create/tables.tab
A	postgres/dedup/all.sql
A	postgres/dedup/drop.sql
M	postgres/fill/initial-entities.sql
 19 files changed, 415 insertions(+), 95 deletions(-)
```

---

*From `v1.2.7` till `v1.2.8`*
