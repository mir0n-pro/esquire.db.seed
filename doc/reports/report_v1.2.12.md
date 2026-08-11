# Release Report: v1.2.11 → v1.2.12

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `69bb77b`

---

## Release Notes

### doc/release_notes.txt


**08/11/2026** v1.2.12 entity change number  
&nbsp;- every entity and sub-entity table gains a change number that goes up by one each time the row is written -- offices, users, accounts, sign-in details, personal details, addresses and the custom-parameter rows  
&nbsp;- the table that records where each entity sits in the tree gets a counter of its own, because moving a branch rewrites where everything under it sits without changing any of those records  
&nbsp;- every change-log table records the number alongside the change, so one record's history reads back in the order it really happened  
&nbsp;- the ledger records which version of the account a money movement produced  
&nbsp;- the optional repeat-protection rule on the change-log tables is keyed on the record and its change number instead of on the request that caused the change, so that rule and the database's own change-recording triggers can be used together  
&nbsp;- the stored path dropped from the change log -- it was filled by the trigger route alone  
&nbsp;- the bank-details table removed, with the person column and foreign key that pointed at it  
&nbsp;- the entity-key sequence removed; the one that hands out address keys stays  
&nbsp;- the Postgres forward migration comes in two parts, so a running deployment is never left with a database the code cannot use: part 1 only adds the new columns and is applied while the previous release is still serving; part 2 removes the dead columns and refreshes the triggers and the dedup indexes, and is applied once the new release has taken over. DB_VERSION moves to 1.2.12 in part 2  
&nbsp;- doc: the entity-relationship diagram redrawn; the foreign-key list corrected (the bank-details link removed, the three entity-path links added); the README gains a Deployment section -- how a database is brought up, that patches are written for Postgres and Oracle is seeded fresh, and that no schema-migration tool takes part  
&nbsp;- both Oracle and Postgres branches (the forward-migration patch is Postgres-only)  

---

## Code Changes

### oracle/changes.txt


**08/11/2026** v1.2.12 entity change number; bank info + ESQ_ENTITY_SEQ removed; DB_VERSION -> 1.2.12  
**create\tables.tab**  
&nbsp;- *_CHANGE_NO NUMBER(16,0) DEFAULT 1 NOT NULL on ESQ_ORG, ESQ_USER, ESQ_ACCOUNT, ESQ_AUTH, ESQ_PERSON,  
&nbsp;    ESQ_ADDRESS, ESQ_USR_PAR, ESQ_ORG_PAR and ESQ_ENTITY_PATH  
&nbsp;- ESQ_ACCT_TRANSACTION.ATR_ACC_CHANGE_NO NUMBER(16,0) (nullable) -- the account change number the  
&nbsp;    transaction produced  
&nbsp;- ESQ_BANK_INFO removed, with ESQ_PERSON.PE_BI_PK  
**create\tables.pfi**  
&nbsp;- ESQ_BI_PK, ESQ_PE_BI_FK and ESQ_PE_BI_FK_I removed with the bank-info table  
**create\tables.sqs**  
&nbsp;- ESQ_ENTITY_SEQ removed (entity keys are minted by the application); ESQ_REF_SEQ stays  
**create.log\tables.tab**  
&nbsp;- *_CHANGE_NO NUMBER(16,0) NOT NULL on the eight *_log tables  
&nbsp;- ESQ_BANK_INFO_LOG removed; ACCL_PATH, ORGL_PATH and USRL_PATH removed  
**create.log\delete.sql**  
&nbsp;- ESQ_BANK_INFO_LOG dropped from the drop list  
**create.log\recommended.pfi**  
&nbsp;- BIL_ACTION_TS_I removed with the bank-info log table  
**triggers\all.sql**  
&nbsp;- esq_bank_info_briud removed from the include list  
**triggers\esq_org_briud.sql**  
&nbsp;- the log insert carries ORGL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete  
**triggers\esq_user_briud.sql**  
&nbsp;- the log insert carries USRL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete; USRL_PATH dropped  
**triggers\esq_account_briud.sql**  
&nbsp;- the log insert carries ACCL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete; ACCL_PATH dropped  
**triggers\esq_auth_briud.sql**  
&nbsp;- the log insert carries AUL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete  
**triggers\esq_person_briud.sql**  
&nbsp;- the log insert carries PEL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete; PEL_BI_PK dropped  
**triggers\esq_address_briud.sql**  
&nbsp;- the log insert carries ADL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete  
**triggers\esq_usr_par_briud.sql**  
&nbsp;- the log insert carries UPRL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete  
**triggers\esq_org_par_briud.sql**  
&nbsp;- the log insert carries OPRL_CHANGE_NO: :NEW on insert/update, :OLD + 1 on delete  
**triggers\esq_bank_info_briud.sql  (removed)**  
&nbsp;- removed with the bank-info table  
**dedup\all.sql**  
&nbsp;- the eight dedup unique indexes rekeyed to the row plus its *_CHANGE_NO, with the correlation id out of  
&nbsp;    the key  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.11 -> 1.2.12  

### postgres/changes.txt


**08/11/2026** v1.2.12 entity change number; bank info + ESQ_ENTITY_SEQ removed; DB_VERSION -> 1.2.12  
**create\tables.tab**  
&nbsp;- *_CHANGE_NO BIGINT NOT NULL DEFAULT 1 on ESQ_ORG, ESQ_USER, ESQ_ACCOUNT, ESQ_AUTH, ESQ_PERSON,  
&nbsp;    ESQ_ADDRESS, ESQ_USR_PAR, ESQ_ORG_PAR and ESQ_ENTITY_PATH  
&nbsp;- ESQ_ACCT_TRANSACTION.ATR_ACC_CHANGE_NO BIGINT (nullable) -- the account change number the transaction  
&nbsp;    produced  
&nbsp;- ESQ_BANK_INFO removed, with ESQ_PERSON.PE_BI_PK  
**create\tables.pfi**  
&nbsp;- ESQ_BI_PK, ESQ_PE_BI_FK and ESQ_PE_BI_FK_I removed with the bank-info table  
**create\tables.sqs**  
&nbsp;- ESQ_ENTITY_SEQ removed (entity keys are minted by the application); ESQ_REF_SEQ stays  
**create.log\tables.tab**  
&nbsp;- *_CHANGE_NO BIGINT NOT NULL on the eight *_log tables  
&nbsp;- ESQ_BANK_INFO_LOG removed; ACCL_PATH, ORGL_PATH and USRL_PATH removed  
**create.log\delete.sql**  
&nbsp;- ESQ_BANK_INFO_LOG dropped from the drop list  
**create.log\recommended.pfi**  
&nbsp;- BIL_ACTION_TS_I removed with the bank-info log table  
**triggers\all.sql**  
&nbsp;- esq_bank_info_briud removed from the include list  
**triggers\esq_org_briud.sql**  
&nbsp;- the log insert carries ORGL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete  
**triggers\esq_user_briud.sql**  
&nbsp;- the log insert carries USRL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete; USRL_PATH dropped  
**triggers\esq_account_briud.sql**  
&nbsp;- the log insert carries ACCL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete; ACCL_PATH dropped  
**triggers\esq_auth_briud.sql**  
&nbsp;- the log insert carries AUL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete  
**triggers\esq_person_briud.sql**  
&nbsp;- the log insert carries PEL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete; PEL_BI_PK dropped  
**triggers\esq_address_briud.sql**  
&nbsp;- the log insert carries ADL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete  
**triggers\esq_usr_par_briud.sql**  
&nbsp;- the log insert carries UPRL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete  
**triggers\esq_org_par_briud.sql**  
&nbsp;- the log insert carries OPRL_CHANGE_NO: NEW on insert/update, OLD + 1 on delete  
**triggers\esq_bank_info_briud.sql  (removed)**  
&nbsp;- removed with the bank-info table  
**dedup\all.sql**  
&nbsp;- the eight dedup unique indexes rekeyed to the row plus its *_CHANGE_NO, with the correlation id out of  
&nbsp;    the key  
**fill\root.sql**  
&nbsp;- DB_VERSION parameter bumped 1.2.11 -> 1.2.12  
**patch\v1.2.12\forward.1st.sql  (new)**  
&nbsp;- forward migration for an already-seeded DB, part 1 of 2, ADDITIVE ONLY -- run while the previous release  
&nbsp;    is still serving: the *_CHANGE_NO columns added (nullable on the *_log tables) plus ATR_ACC_CHANGE_NO.  
&nbsp;    Nothing dropped, no trigger and no index touched, DB_VERSION left at 1.2.11  
**patch\v1.2.12\forward.2nd.sql  (new)**  
&nbsp;- part 2 of 2, run once the v1.2.12 services are serving: the *_log change numbers back-filled and set  
&nbsp;    NOT NULL, USRL_PATH / ORGL_PATH / ACCL_PATH dropped, ESQ_BANK_INFO / ESQ_BANK_INFO_LOG / PE_BI_PK /  
&nbsp;    PEL_BI_PK / ESQ_ENTITY_SEQ dropped, the audit triggers and the dedup indexes each re-created only where  
&nbsp;    they are already installed, DB_VERSION 1.2.11 -> 1.2.12  

---

## Commits

```

-- 2026-08-11 | commit: 69bb77b | mir0n.the.programmer | v1.2.12 : patch with 2 parts --
M	README.md
M	doc/release_notes.txt
M	postgres/changes.txt
A	postgres/patch/v1.2.12/forward.1st.sql
R051	postgres/patch/v1.2.12/forward.sql	postgres/patch/v1.2.12/forward.2nd.sql
 5 files changed, 214 insertions(+), 112 deletions(-)

-- 2026-08-11 | commit: 9099dbb | mir0n.the.programmer | v1.2.12 entity change number --
M	README.md
M	doc/foreignKeys.md
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create.log/delete.sql
M	oracle/create.log/recommended.pfi
M	oracle/create.log/tables.tab
M	oracle/create/tables.pfi
M	oracle/create/tables.sqs
M	oracle/create/tables.tab
M	oracle/dedup/all.sql
M	oracle/fill/root.sql
M	oracle/triggers/all.sql
M	oracle/triggers/esq_account_briud.sql
M	oracle/triggers/esq_address_briud.sql
M	oracle/triggers/esq_auth_briud.sql
D	oracle/triggers/esq_bank_info_briud.sql
M	oracle/triggers/esq_org_briud.sql
M	oracle/triggers/esq_org_par_briud.sql
M	oracle/triggers/esq_person_briud.sql
M	oracle/triggers/esq_user_briud.sql
M	oracle/triggers/esq_usr_par_briud.sql
M	postgres/changes.txt
M	postgres/create.log/delete.sql
M	postgres/create.log/recommended.pfi
M	postgres/create.log/tables.tab
M	postgres/create/tables.pfi
M	postgres/create/tables.sqs
M	postgres/create/tables.tab
M	postgres/dedup/all.sql
M	postgres/fill/root.sql
A	postgres/patch/v1.2.12/forward.sql
M	postgres/triggers/all.sql
M	postgres/triggers/esq_account_briud.sql
M	postgres/triggers/esq_address_briud.sql
M	postgres/triggers/esq_auth_briud.sql
D	postgres/triggers/esq_bank_info_briud.sql
M	postgres/triggers/esq_org_briud.sql
M	postgres/triggers/esq_org_par_briud.sql
M	postgres/triggers/esq_person_briud.sql
M	postgres/triggers/esq_user_briud.sql
M	postgres/triggers/esq_usr_par_briud.sql
 43 files changed, 712 insertions(+), 759 deletions(-)

-- 2026-07-26 | commit: 3e8a461 | mir0n.the.programmer | Create report_v1.2.11.md --
A	doc/reports/report_v1.2.11.md
 1 file changed, 98 insertions(+)

```

---

## Files Modified

```
M	README.md
M	doc/foreignKeys.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.11.md
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create.log/delete.sql
M	oracle/create.log/recommended.pfi
M	oracle/create.log/tables.tab
M	oracle/create/tables.pfi
M	oracle/create/tables.sqs
M	oracle/create/tables.tab
M	oracle/dedup/all.sql
M	oracle/fill/root.sql
M	oracle/triggers/all.sql
M	oracle/triggers/esq_account_briud.sql
M	oracle/triggers/esq_address_briud.sql
M	oracle/triggers/esq_auth_briud.sql
D	oracle/triggers/esq_bank_info_briud.sql
M	oracle/triggers/esq_org_briud.sql
M	oracle/triggers/esq_org_par_briud.sql
M	oracle/triggers/esq_person_briud.sql
M	oracle/triggers/esq_user_briud.sql
M	oracle/triggers/esq_usr_par_briud.sql
M	postgres/changes.txt
M	postgres/create.log/delete.sql
M	postgres/create.log/recommended.pfi
M	postgres/create.log/tables.tab
M	postgres/create/tables.pfi
M	postgres/create/tables.sqs
M	postgres/create/tables.tab
M	postgres/dedup/all.sql
M	postgres/fill/root.sql
A	postgres/patch/v1.2.12/forward.1st.sql
A	postgres/patch/v1.2.12/forward.2nd.sql
M	postgres/triggers/all.sql
M	postgres/triggers/esq_account_briud.sql
M	postgres/triggers/esq_address_briud.sql
M	postgres/triggers/esq_auth_briud.sql
D	postgres/triggers/esq_bank_info_briud.sql
M	postgres/triggers/esq_org_briud.sql
M	postgres/triggers/esq_org_par_briud.sql
M	postgres/triggers/esq_person_briud.sql
M	postgres/triggers/esq_user_briud.sql
M	postgres/triggers/esq_usr_par_briud.sql
 45 files changed, 912 insertions(+), 759 deletions(-)
```

---

*From `v1.2.11` till `v1.2.12`*
