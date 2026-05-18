# Release Report: v1.2.2 → v1.2.4

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `f75c253`

---

## Release Notes

### doc/release_notes.txt


**05/14/2026** v1.2.4 hauberk harness identity: Test House + 3 Test Drivers (one per non-browser auth pattern)  
&nbsp;- erd/ESQ.2026.ERD.vsdx up-to-date  

---

## Code Changes

### oracle/changes.txt


**05/14/2026** v1.2.4 hauberk harness identity: Test House + Test Drivers  
**fill\initial-entities.sql**  
&nbsp;- Test House org (org_pk=14, ep_path='1.14.') under root  
&nbsp;- Test Driver (usr_pk=15) admin USR (kind=32) -- Plain JWT, backs esq-hauberk KC service account  
&nbsp;- Test Driver S (usr_pk=16) admin USR (kind=32) -- Vanilla Token Relay, backs esq-hauberk-S  
&nbsp;- Test Driver M (usr_pk=17) admin USR (kind=32) -- Phantom Token Relay (RFC 8693), backs esq-hauberk-M  
&nbsp;- all three under Test House with SUPERVIZOR + TREE realm roles; auth + person rows added  

### postgres/changes.txt


**05/14/2026** v1.2.4 hauberk harness identity: Test House + three Test Drivers (one per non-browser auth pattern)  
**fill\initial-entities.sql**  
&nbsp;- Test House org (org_pk=14, ep_path='1.14.') under root  
&nbsp;- Test Driver (usr_pk=15) admin USR (kind=32) -- Plain JWT, backs esq-hauberk KC service account  
&nbsp;- Test Driver S (usr_pk=16) admin USR (kind=32) -- Vanilla Token Relay, backs esq-hauberk-S  
&nbsp;- Test Driver M (usr_pk=17) admin USR (kind=32) -- Phantom Token Relay (RFC 8693), backs esq-hauberk-M  
&nbsp;- all three under Test House with SUPERVIZOR + TREE realm roles; auth + person rows added  

---

## Commits

```

-- 2026-05-17 | commit: f75c253 | mir0n.the.programmer |  v1.2.4 hauberk harness identity: Test House + 3 Test Drivers --
M	README.md
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
 7 files changed, 158 insertions(+)

-- 2026-05-03 | commit: 441f4ba | mir0n.the.programmer | Update report_v1.2.2.md --
M	doc/reports/report_v1.2.2.md
 1 file changed, 6 insertions(+), 6 deletions(-)
```

---

## Files Modified

```
M	README.md
M	doc/release_notes.txt
M	doc/reports/report_v1.2.2.md
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/fill/initial-entities.sql
 8 files changed, 164 insertions(+), 6 deletions(-)
```

---

*From `v1.2.2` till `v1.2.4`*
