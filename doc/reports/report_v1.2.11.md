# Release Report: v1.2.10 → v1.2.11

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `918051f`

---

## Release Notes

### doc/release_notes.txt


**07/23/2026** v1.2.11 schema-definition corrections  
&nbsp;- ESQ_ACCT_TRANSACTION.ATR_TS gains a server-side "now (UTC)" default -- a ledger row is stamped even when the caller omits it  
&nbsp;- ESQ_PARAMETER.PAR_TYPE default corrected to lower-case 'string' so it matches its own allowed-values check  
&nbsp;- the ESQ_USR_ROLE foreign-key index renamed to the intended UR_ROLE_FK_I (a double-_FK name typo)  
&nbsp;- a Postgres forward-migration patch applies the above to an already-seeded database and bumps DB_VERSION to 1.2.11  
&nbsp;- both Oracle and Postgres branches (the forward-migration patch is Postgres-only)  

---

## Code Changes

### oracle/changes.txt


**07/23/2026** v1.2.11 ATR_TS + PAR_TYPE defaults; UR_ROLE_FK_I index rename; DB_VERSION -> 1.2.11  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION.ATR_TS TIMESTAMP DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) (server-side default)  
&nbsp;- ESQ_PARAMETER.PAR_TYPE default 'STRING' -> 'string' (matches the ESQ_PAR_TYPE_CC check)  
**create\tables.pfi**  
&nbsp;- FK index on ESQ_USR_ROLE(UR_ROLE_PK) renamed UR_ROLE_FK_FK_I -> UR_ROLE_FK_I (double-_FK typo)  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.10 -> 1.2.11  

### postgres/changes.txt


**07/23/2026** v1.2.11 ATR_TS + PAR_TYPE defaults; UR_ROLE_FK_I index rename; DB_VERSION -> 1.2.11  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION.ATR_TS TIMESTAMP DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'UTC') (server-side default)  
&nbsp;- ESQ_PARAMETER.PAR_TYPE default 'STRING' -> 'string' (matches the ESQ_PAR_TYPE_CC check)  
**create\tables.pfi**  
&nbsp;- FK index on ESQ_USR_ROLE(UR_ROLE_PK) renamed UR_ROLE_FK_FK_I -> UR_ROLE_FK_I (double-_FK typo)  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.10 -> 1.2.11  
**patch\v1.2.11\forward.sql  (new)**  
&nbsp;- forward migration for an already-seeded DB: ATR_TS default, PAR_TYPE default, UR_ROLE_FK_I rename, DB_VERSION 1.2.10 -> 1.2.11  

---

## Commits

```

-- 2026-07-26 | commit: 918051f | mir0n.the.programmer | v1.2.11 schema-definition corrections --
M	README.md
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/create/tables.pfi
M	oracle/create/tables.tab
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
M	postgres/fill/root.sql
A	postgres/patch/v1.2.11/forward.sql
 11 files changed, 108 insertions(+), 12 deletions(-)

-- 2026-07-05 | commit: 486fa09 | mir0n.the.programmer | Create report_v1.2.10.md --
A	doc/reports/report_v1.2.10.md
 1 file changed, 107 insertions(+)

```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.10.md
M	oracle/changes.txt
M	oracle/create/tables.pfi
M	oracle/create/tables.tab
M	oracle/fill/root.sql
M	postgres/changes.txt
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
M	postgres/fill/root.sql
A	postgres/patch/v1.2.11/forward.sql
 12 files changed, 215 insertions(+), 12 deletions(-)
```

---

*From `v1.2.10` till `v1.2.11`*
