# Release Report: v1.2.4 → v1.2.7

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `187968c`

---

## Release Notes

### doc/release_notes.txt


**06/06/2026** v1.2.7 audit-log dedup unique indexes added (x-Rod option c)  
&nbsp;- the 9 ESQ_*_LOG tables get a UNIQUE index on their dedup key (crl_id + the row's own pk [, kind / sub])  
&nbsp;- both Oracle and Postgres branches  

**06/05/2026** v1.2.7 audit-log schema isolated (create.log) + *_log data columns nullable  
&nbsp;- *_log tables moved to a separate audit-log schema (create.log), deployable standalone or included from create/  
&nbsp;- *_log data columns made nullable so empty-body DELETE audit rows insert  
&nbsp;- Applies to both Oracle and Postgres branches  

**06/03/2026** v1.2.7 audit-log triggers made OPTIONAL -- base seed is trigger-free  
&nbsp;- Applies to both Oracle and Postgres branches  

---

## Code Changes

### oracle/changes.txt


**06/06/2026** v1.2.7 audit-log dedup unique indexes (x-Rod option c)  
**create.log\tables.pfi**  
&nbsp;- UNIQUE indexes on the 9 ESQ_*_LOG dedup keys (account / org / user / address on (*_crl_id, *_pk),  
&nbsp;    org_par (oprl_crl_id, oprl_org_pk, oprl_par_name), usr_par, person (pel_crl_id, pel_usr_pk, pel_kind),  
&nbsp;    auth (aul_crl_id, aul_usr_pk)); the consumer MERGE dedups redelivered bus messages on this key  

**06/05/2026** v1.2.7 audit-log schema isolated into create.log/; *_log data columns nullable  
**create.log\all.sql, delete.sql, tables.tab, tables.pfi (new)**  
&nbsp;- the 9 ESQ_*_LOG tables (+ indexes) moved out of create/ into a separate audit-log schema,  
&nbsp;    deployable standalone (esquire_log) or included from create/all.sql for the single-DB demo  
**create\tables.tab**  
&nbsp;- the ESQ_*_LOG CREATE TABLE statements removed (relocated to create.log/tables.tab)  
**create\all.sql**  
&nbsp;- includes `@@../create.log/all.sql` after the base schema  
**create.log\tables.tab**  
&nbsp;- *_log data columns made nullable (kept DEFAULTs) so an empty-body DELETE audit row inserts  
&nbsp;    (DELETE writes only action + pk + et_pk + crl/req/uid + action_ts)  

**06/03/2026** v1.2.7 audit-log triggers made OPTIONAL -- base seed is trigger-free  
**create\all.sql**  
&nbsp;- removed the `@@../triggers/all.sql` include from the create sequence; the base seed now  
&nbsp;    creates NO audit triggers (default). triggers/all.sql kept as the opt-in overlay (option a).  
**triggers\drop.sql (new)**  
&nbsp;- opt-out: drops every ESQ_ trigger by name mask (PL/SQL loop over user_triggers,  
&nbsp;    LIKE 'ESQ\_%' ESCAPE '\'); idempotent. Doubles as the drop-on-existing-DBs migration.  

### postgres/changes.txt


**06/06/2026** v1.2.7 audit-log dedup unique indexes (x-Rod option c)  
**create.log\tables.pfi**  
&nbsp;- UNIQUE indexes on the 9 ESQ_*_LOG dedup keys (esq_account_log (accl_crl_id, accl_pk),  
&nbsp;    esq_org_log / esq_user_log / esq_address_log on (*_crl_id, *_pk), esq_org_par_log  
&nbsp;    (oprl_crl_id, oprl_org_pk, oprl_par_name), esq_usr_par_log, esq_person_log  
&nbsp;    (pel_crl_id, pel_usr_pk, pel_kind), esq_auth_log (aul_crl_id, aul_usr_pk)) so  
&nbsp;    INSERT .. ON CONFLICT DO NOTHING dedups redelivered bus messages (was a placeholder)  

**06/05/2026** v1.2.7 audit-log schema isolated into create.log/; *_log data columns nullable  
**create.log\all.sql, delete.sql, tables.tab, tables.pfi (new)**  
&nbsp;- the 9 ESQ_*_LOG tables (+ indexes) moved out of create/ into a separate audit-log schema,  
&nbsp;    deployable standalone (esquire_log) or included from create/all.sql for the single-DB demo  
**create\tables.tab**  
&nbsp;- the ESQ_*_LOG CREATE TABLE statements removed (relocated to create.log/tables.tab)  
**create\all.sql**  
&nbsp;- includes `\i ../create.log/all.sql` after the base schema  
**create.log\tables.tab**  
&nbsp;- *_log data columns made nullable (kept DEFAULTs) so an empty-body DELETE audit row inserts  
&nbsp;    (DELETE writes only action + pk + et_pk + crl/req/uid + action_ts)  

**06/03/2026** v1.2.7 audit-log triggers made OPTIONAL -- base seed is trigger-free  
**create\all.sql**  
&nbsp;- removed the `\i ../triggers/all.sql` include from the create sequence; the base seed now  
&nbsp;    creates NO audit triggers (default). triggers/all.sql kept as the opt-in overlay (option a).  
**triggers\drop.sql (new)**  
&nbsp;- opt-out: drops every ESQ_ trigger and its function by name mask (DO block over pg_trigger,  
&nbsp;    ILIKE 'ESQ\_%'); idempotent. Doubles as the drop-on-existing-DBs migration.  

---

## Commits

```

-- 2026-06-10 | commit: 187968c | mir0n.the.programmer | Update README.md --
M	README.md
 1 file changed, 12 insertions(+)

-- 2026-06-07 | commit: 9d001aa | mir0n.the.programmer | v1.2.7 audit-log dedup unique indexes added (x-Rod option c) --
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/create.log/tables.pfi
M	postgres/changes.txt
M	postgres/create.log/tables.pfi
 5 files changed, 82 insertions(+), 8 deletions(-)

-- 2026-06-06 | commit: 217a50b | mir0n.the.programmer | v1.2.7 audit-log schema isolated (create.log) + *_log data columns nullable --
M	doc/release_notes.txt
M	oracle/changes.txt
A	oracle/create.log/all.sql
A	oracle/create.log/delete.sql
A	oracle/create.log/tables.pfi
A	oracle/create.log/tables.tab
M	oracle/create/all.sql
M	oracle/create/tables.tab
M	postgres/changes.txt
A	postgres/create.log/all.sql
A	postgres/create.log/delete.sql
A	postgres/create.log/tables.pfi
A	postgres/create.log/tables.tab
M	postgres/create/all.sql
M	postgres/create/tables.tab
 15 files changed, 1069 insertions(+), 872 deletions(-)

-- 2026-06-03 | commit: 3c274c2 | mir0n.the.programmer | v1.2.7 audit-log triggers made OPTIONAL -- base seed is trigger-free --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/all.sql
A	oracle/triggers/drop.sql
M	postgres/changes.txt
M	postgres/create/all.sql
A	postgres/triggers/drop.sql
 8 files changed, 76 insertions(+), 5 deletions(-)

-- 2026-05-18 | commit: 6dc63a8 | mir0n.the.programmer | Create report_v1.2.4.md --
A	doc/reports/report_v1.2.4.md
 1 file changed, 81 insertions(+)

```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.4.md
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
A	oracle/create.log/all.sql
A	oracle/create.log/delete.sql
A	oracle/create.log/tables.pfi
A	oracle/create.log/tables.tab
M	oracle/create/all.sql
M	oracle/create/tables.tab
A	oracle/triggers/drop.sql
M	postgres/changes.txt
A	postgres/create.log/all.sql
A	postgres/create.log/delete.sql
A	postgres/create.log/tables.pfi
A	postgres/create.log/tables.tab
M	postgres/create/all.sql
M	postgres/create/tables.tab
A	postgres/triggers/drop.sql
 20 files changed, 1312 insertions(+), 877 deletions(-)
```

---

*From `v1.2.4` till `v1.2.7`*
