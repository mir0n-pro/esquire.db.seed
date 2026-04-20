# Release Report: v1.2.1 → HEAD

**Repo:** `esquire.db.seed/develop`  
**Top commit:** `5ecdbab`

---

## Release Notes

### doc/release_notes.txt


**04/20/2026** ESQ_ACCT_TRANSACTION — transfer PK and conversion rate columns; log filename updates  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- up-to-date erd\ESQ.2026.ERD.vsdx  

**04/10/2026** Permission types and activity types are extended with reserved codes  

**04/09/2026** ESQ_ACCOUNT — funded date and negative balance flag, more fields in ESQ_ACCT_TRANSACTION  
&nbsp;- All Postgres triggers converted to BEFORE pattern (RETURN OLD/NEW); consistent with Oracle  
&nbsp;- Postgres esq_account_briud: NEW.acc_funded_dt set before log INSERT — eliminates double logging; accl_funded_dt correct in log  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ESQ.2026.ERD.vsdx up-to-date  
&nbsp;- ESQ_ACCT_TRANSACTION — reference code and memo columns added  
&nbsp;- Applies to both Oracle and Postgres branches  

**03/31/2026** ESQ_ENTITY_PATH EP_ET_PK — entity kind column added  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ESQ.2026.ERD.vsdx up-to-date  

**03/28/2026** ESQ_ENTITY_PATH — path columns extracted to satellite table; trigger path resolution updated  
&nbsp;- Applies to both Oracle and Postgres branches  

**03/28/2026** ESQ_PARAMETER PAR_DEFAULT — default value for custom field metadata  
&nbsp;- ESQ_PARAMETER: PAR_DEFAULT column added (VARCHAR2/VARCHAR 4000)  
&nbsp;- esq_parameter.sql: aDefault parameter; PAR_DEFAULT in INSERT; defaults for DB_NAME, DB_VERSION, Example fields  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ESQ.2026.ERD.vsdx up-to-date  

**03/28/2026** ON DELETE CASCADE on usr/org FKs; address PKs from sequence in seed data; tree removed  
&nbsp;- ESQ_AU_USR_FK, ESQ_PE_USR_FK, ESQ_UPR_USR_FK, UR_USR_FK: ON DELETE CASCADE  
&nbsp;    (esq_auth, esq_person, esq_usr_par, esq_usr_role cascade on esq_user delete)  
&nbsp;- ESQ_OPR_ORG_FK: ON DELETE CASCADE (esq_org_par cascades on esq_org delete)  
&nbsp;- initial-entities.sql: address PKs use sequence (ESQ_REF_SEQ) instead of hardcoded values  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- tree removed (now biz tree exists as a in-memory cache within bizTree service)  
&nbsp;- added doc/foreingKeys.md  

**03/16/2026** TOTP pending-disable state  

**03/06/2026** Account balance precision fix; custom field validation  

**03/03/2026** ESQ_ROLE: ROLE_ADMIN_FLG replaced by ROLE_PT_PK; permission type IDs aligned  
&nbsp;          Param types: "integer" removed, "text" and "date" added  
&nbsp;- ESQ_ROLE.ROLE_ADMIN_FLG VARCHAR(1) Y/N replaced by ROLE_PT_PK INT (FK to ESQ_PERMISSION_TYPE)  
&nbsp;- Permission type IDs aligned with esq-object-kinds: 0->980 (Admin), 1->982 (Tools)  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ERD doc updated  

**02/28/2026** ESQ_PERSON.PE_KIND numeric type; address and person seed data  
&nbsp;- ESQ_PERSON.PE_KIND changed from character ('P','S','J') to numeric (992, 994, 996)  
&nbsp;- ESQ_ADDRESS and ESQ_PERSON seed data added for all initial users  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ERD doc updated  

**02/24/2026** Audit log tables and triggers  
&nbsp;- Applies to both Oracle and Postgres branches  
&nbsp;- ERD doc updated  

**02/19/2026** Audit columns and schema refactoring  
&nbsp;- Audit columns (*_CRL_ID, *_REQ_ID, *_UID) added to all major tables  
&nbsp;    to support correlation/request tracking on every write operation  
&nbsp;- Contact fields (email, phone, phone2) moved from ESQ_ADDRESS to ESQ_PERSON  
&nbsp;- ERD doc updated  

**02/02/2026** Refactoring: added sysadmin  
&nbsp;- added sysadmin, Sys admins  
&nbsp;- reserved places in entity type enumeration for easy expanding  
&nbsp;- added ESQ_ROLE.ROLE_ADMIN_FLG: to help Access Profile dialog with user roles management  
&nbsp;- ERD doc updated  

---

## Code Changes

### oracle/changes.txt


**04/20/2026** ESQ_ACCT_TRANSACTION — transfer PK and conversion rate columns; log filename updates  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_PK VARCHAR2(64) (was NUMBER(16,0)); string ID from generateTransId()  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_PK_TX VARCHAR2(64) added (links both legs of a transfer)  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_AMT_INCOMING NUMBER(16,3) (was NUMBER(16,0))  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_CONV_RATE NUMBER(12,6) (was NUMBER)  
**create\tables.sqs**  
&nbsp;- ESQ_ATR_SEQ removed (PK is now a string, no sequence needed)  
**create\all.sql**  
&nbsp;- SPOOL filename renamed to esq2025-create.log  
**fill\all.sql**  
&nbsp;- SPOOL filename renamed to esq2025-fill.log  

**04/09/2026** ESQ_ACCT_TRANSACTION — reference code and memo columns added  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_REF_CODE, ATR_REF_CODE2, ATR_REF_CODE3, ATR_REF_CODE4, ATR_MEMO VARCHAR2(512) nullable added  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_CRL_ID, ATR_REQ_ID VARCHAR2(64), ATR_UID added  

**04/09/2026** ESQ_ACCT_TRANSACTION.ATR_DT renamed to ATR_TS  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_DT → ATR_TS (column + comment)  

**04/09/2026** ESQ_ACCOUNT — funded date and negative balance flag added  
**create\tables.tab**  
&nbsp;- ESQ_ACCOUNT: ACC_FUNDED_DT DATE (nullable) added; ACCT_NEG_ALLOWED_FLG VARCHAR2(1) DEFAULT 'N' NOT NULL added  
&nbsp;- ESQ_ACCOUNT_LOG: ACCL_FUNDED_DT DATE (nullable) added; ACCL_NEG_ALLOWED_FLG VARCHAR2(1) DEFAULT 'N' NOT NULL added  
&nbsp;- column comments added for both tables  
**triggers\esq_account_briud.sql**  
&nbsp;- UPDATE branch (BEFORE trigger): :NEW.acc_funded_dt := SYSDATE when NULL and acc_balance changed  

**03/31/2026** EP_ET_PK — entity kind column added to ESQ_ENTITY_PATH  
**create\tables.tab**  
&nbsp;- ESQ_ENTITY_PATH: EP_ET_PK NUMBER(5,0) DEFAULT 0 NOT NULL added; column comment added  
**fill\initial-entities.sql**  
&nbsp;- all esq_entity_path INSERTs: ep_et_pk value added (13 rows, kind from corresponding entity row)  

**03/28/2026** ESQ_ENTITY_PATH — path column extracted to satellite table  
**create\tables.tab**  
&nbsp;- ESQ_ENTITY_PATH(EP_PK NUMBER(16,0), EP_PATH VARCHAR2(4000)) table added before ESQ_USER  
&nbsp;- ESQ_ORG.ORG_PATH, ESQ_USER.USR_PATH, ESQ_ACCOUNT.ACC_PATH columns removed  
**create\tables.pfi**  
&nbsp;- ESQ_EP_PK primary key added  
&nbsp;- ESQ_ORG_EP_FK, ESQ_USR_EP_FK, ESQ_ACC_EP_FK foreign keys added (entity.PK → ESQ_ENTITY_PATH.EP_PK, RESTRICTED)  
**fill\root.sql**  
&nbsp;- root org INSERT split: INSERT esq_entity_path(pk=1) first, then INSERT esq_org (without path column)  
**fill\initial-entities.sql**  
&nbsp;- all entity INSERTs split: INSERT esq_entity_path first, then entity row (without path column)  
**fill\delete.sql**  
&nbsp;- DELETE FROM esq_entity_path added after entity DELETE statements  
**triggers\esq_org_briud.sql**  
&nbsp;- :OLD/:NEW.org_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = :OLD/:NEW.org_pk)  
**triggers\esq_user_briud.sql**  
&nbsp;- :OLD/:NEW.usr_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = :OLD/:NEW.usr_pk)  
**triggers\esq_account_briud.sql**  
&nbsp;- :OLD/:NEW.acc_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = :OLD/:NEW.acc_pk)  

**03/28/2026** ON DELETE CASCADE on usr/org FKs; address PKs from sequence in seed data  
**create\tables.pfi**  
&nbsp;- ON DELETE CASCADE added to ESQ_AU_USR_FK, ESQ_PE_USR_FK, ESQ_UPR_USR_FK, UR_USR_FK  
&nbsp;    (esq_auth, esq_person, esq_usr_par, esq_usr_role cascade on esq_user delete)  
&nbsp;- ON DELETE CASCADE added to ESQ_OPR_ORG_FK (esq_org_par cascades on esq_org delete)  
**fill\initial-entities.sql**  
&nbsp;- address PKs use ESQ_REF_SEQ.NEXTVAL with RETURNING INTO variable; no hardcoded IDs  
"tree" folder removed  

**03/16/2026** ESQ_AU_TFA_METHOD_CC: 'n' added for TOTP pending-disable state  
**create\tables.cc**  
&nbsp;- ESQ_AU_TFA_METHOD_CC: allowed values extended ('N','G','g') -> ('N','n','G','g')  

**03/08/2026** personal custom parameter test case  

**03/03/2026** ESQ_ROLE.ROLE_ADMIN_FLG replaced by ROLE_PT_PK; permission type IDs aligned  
**create\tables.tab**  
&nbsp;- ESQ_ROLE: ROLE_ADMIN_FLG VARCHAR2(1) replaced by ROLE_PT_PK NUMBER NOT NULL  
&nbsp;    (FK reference to ESQ_PERMISSION_TYPE; 980: Admin, 982: Tools)  
**create\tables.cc**  
&nbsp;- ESQ_PAR_TYPE_CC: 'integer' removed; 'text', 'date' added  
**create\tables.pfi**  
&nbsp;- ESQ_ROLE_PT_FK added (ROLE_PT_PK -> ESQ_PERMISSION_TYPE)  
&nbsp;- ESQ_ROLE_PT_FK_I index added  
**fill\esq_role.sql**  
&nbsp;- role_admin_flg -> role_pt_pk (980: Admin, 982: Tools)  
**fill\esq_permission_type.sql**  
&nbsp;- IDs aligned with esq-object-kinds: 0->980 (Admin), 1->982 (Tools)  
**fill\esq_permission.sql**  
&nbsp;- permission type refs updated: 0->980 (Admin), 1->982 (Tools)  

**02/28/2026** ESQ_PERSON.PE_KIND numeric type + address/person seed data  
**create\all.sql**  
&nbsp;- Triggers creation section added  
**create\tables.tab**  
&nbsp;- ESQ_PERSON.PE_KIND: VARCHAR2(1) DEFAULT 'P' -> NUMBER(5,0) DEFAULT 992  
&nbsp;- ESQ_PERSON_LOG.PEL_KIND: VARCHAR2(1) -> NUMBER(5,0)  
**create\tables.cc**  
&nbsp;- ESQ_PE_KIND_CC check constraint on ESQ_PERSON commented out  
**fill\delete.sql**  
&nbsp;- esq_address and esq_person deletes added  
**fill\esq_parameter.sql**  
&nbsp;- PAR_LAYER corrected for entity type 34 'Example' parameter  
**fill\initial-entities.sql**  
&nbsp;- esq_person inserts added for all seed users  
&nbsp;- esq_address inserts added for merchant and client  

**02/24/2026** Audit log tables and BRIUD triggers added  
**create\tables.tab**  
&nbsp;- ESQ_USER: USR_REG_OPTION made nullable  
&nbsp;- Audit log tables added: ESQ_USER_LOG, ESQ_ADDRESS_LOG, ESQ_BANK_INFO_LOG,  
&nbsp;      ESQ_PERSON_LOG, ESQ_AUTH_LOG, ESQ_ORG_LOG, ESQ_ACCOUNT_LOG,  
&nbsp;      ESQ_USR_PAR_LOG, ESQ_ORG_PAR_LOG  
added triggers\all.sql  
added triggers\esq_user_briud.sql  
added triggers\esq_address_briud.sql  
added triggers\esq_bank_info_briud.sql  
added triggers\esq_person_briud.sql  
added triggers\esq_auth_briud.sql  
added triggers\esq_org_briud.sql  
added triggers\esq_account_briud.sql  
added triggers\esq_usr_par_briud.sql  
added triggers\esq_org_par_briud.sql  

**02/19/2026** Audit columns and schema refactoring  
**create\tables.tab**  
&nbsp;- ESQ_ADDRESS: AD_EMAIL, AD_PHONE, AD_PHONE2 moved to ESQ_PERSON  
&nbsp;- ESQ_PERSON: PE_EMAIL, PE_PHONE, PE_PHONE2 added (moved from ESQ_ADDRESS)  
&nbsp;- Audit columns (*_CRL_ID, *_REQ_ID, *_UID) added to:  
&nbsp;      ESQ_ADDRESS, ESQ_BANK_INFO, ESQ_PERSON, ESQ_USER, ESQ_AUTH,  
&nbsp;      ESQ_ORG, ESQ_ACCOUNT, ESQ_USR_PAR, ESQ_ORG_PAR  

**02/02/2026** Refactoring  
&nbsp;- added sysadmin, Sys admins  
&nbsp;- reserved places in entity type enumeration for easy expanding  
&nbsp;- added ESQ_ROLE.ROLE_ADMIN_FLG: to help Access Profile dialog with user roles management  

### postgres/changes.txt

postgres seed changes  

**04/20/2026** ESQ_ACCT_TRANSACTION — transfer PK and conversion rate columns; log filename updates  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_PK VARCHAR(64) (was BIGINT); string ID from generateTransId()  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_PK_TX VARCHAR(64) added (links both legs of a transfer)  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_AMT_INCOMING NUMERIC(16,3) (was BIGINT)  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_CONV_RATE NUMERIC(12,6) (was NUMERIC(8))  
**create\tables.sqs**  
&nbsp;- ESQ_ATR_SEQ removed (PK is now a string, no sequence needed)  
**create\all.sql**  
&nbsp;- output filename renamed to esq2025-create.log  
**fill\all.sql**  
&nbsp;- output filename renamed to esq2025-fill.log  

**04/09/2026** ESQ_ACCT_TRANSACTION — audit columns added  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_CRL_ID VARCHAR(64), ATR_REQ_ID VARCHAR(64), ATR_UID VARCHAR(16) nullable added; column comments added  

**04/09/2026** ESQ_ACCT_TRANSACTION — reference code and memo columns added  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_REF_CODE, ATR_REF_CODE2, ATR_REF_CODE3, ATR_REF_CODE4, ATR_MEMO VARCHAR(512) nullable added  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_CRL_ID, ATR_REQ_ID VARCHAR2(64), ATR_UID added  

**04/09/2026** ESQ_ACCT_TRANSACTION.ATR_DT renamed to ATR_TS  
**create\tables.tab**  
&nbsp;- ESQ_ACCT_TRANSACTION: ATR_DT → ATR_TS (column + comment)  

**04/09/2026** all triggers converted to BEFORE pattern; ESQ_ACCOUNT - funded date and negative balance flag added  
**triggers\esq_org_briud.sql**  
**triggers\esq_user_briud.sql**  
**triggers\esq_address_briud.sql**  
**triggers\esq_person_briud.sql**  
**triggers\esq_auth_briud.sql**  
**triggers\esq_bank_info_briud.sql**  
**triggers\esq_usr_par_briud.sql**  
**triggers\esq_org_par_briud.sql**  
&nbsp;- AFTER BEFORE trigger; RETURN NULL replaced with RETURN OLD (DELETE) / RETURN NEW (INSERT/UPDATE)  
**create\tables.tab**  
&nbsp;- ESQ_ACCOUNT: ACC_FUNDED_DT DATE (nullable) added; ACCT_NEG_ALLOWED_FLG VARCHAR(1) DEFAULT 'N' NOT NULL added  
&nbsp;- ESQ_ACCOUNT_LOG: ACCL_FUNDED_DT DATE (nullable) added; ACCL_NEG_ALLOWED_FLG VARCHAR(1) DEFAULT 'N' NOT NULL added  
&nbsp;- column comments added for both tables  
**triggers\esq_account_briud.sql**  
&nbsp;- changed from AFTER to BEFORE trigger: NEW.acc_funded_dt set directly, eliminating follow-up UPDATE and double logging  
&nbsp;- UPDATE branch: NEW.acc_funded_dt := CURRENT_TIMESTAMP when NULL and acc_balance changed (before log INSERT)  
&nbsp;- RETURN NEW (INSERT/UPDATE) / RETURN OLD (DELETE) replacing RETURN NULL  

**03/31/2026** EP_ET_PK — entity kind column added to ESQ_ENTITY_PATH  
**create\tables.tab**  
&nbsp;- ESQ_ENTITY_PATH: EP_ET_PK INT DEFAULT 0 NOT NULL added; column comment added  
**fill\initial-entities.sql**  
&nbsp;- all esq_entity_path INSERTs: ep_et_pk value added (13 rows, kind from corresponding entity row)  

**03/28/2026** ESQ_ENTITY_PATH — path column extracted to satellite table  
**create\tables.tab**  
&nbsp;- ESQ_ENTITY_PATH(EP_PK BIGINT, EP_PATH VARCHAR(4000)) table added before ESQ_USER  
&nbsp;- ESQ_ORG.ORG_PATH, ESQ_USER.USR_PATH, ESQ_ACCOUNT.ACC_PATH columns removed  
**create\tables.pfi**  
&nbsp;- ESQ_EP_PK primary key added  
&nbsp;- ESQ_ORG_EP_FK, ESQ_USR_EP_FK, ESQ_ACC_EP_FK foreign keys added (entity.PK → ESQ_ENTITY_PATH.EP_PK, RESTRICTED)  
**fill\root.sql**  
&nbsp;- root org INSERT split: INSERT esq_entity_path(pk=1) first, then INSERT esq_org (without path column)  
**fill\initial-entities.sql**  
&nbsp;- all entity INSERTs split: INSERT esq_entity_path first, then entity row (without path column)  
**fill\delete.sql**  
&nbsp;- DELETE FROM esq_entity_path added after entity DELETE statements  
**triggers\esq_org_briud.sql**  
&nbsp;- OLD/NEW.org_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = OLD/NEW.org_pk)  
**triggers\esq_user_briud.sql**  
&nbsp;- OLD/NEW.usr_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = OLD/NEW.usr_pk)  
**triggers\esq_account_briud.sql**  
&nbsp;- OLD/NEW.acc_path replaced with subquery (SELECT ep_path FROM esq_entity_path WHERE ep_pk = OLD/NEW.acc_pk)  

**03/28/2026** ESQ_PARAMETER PAR_DEFAULT — default value for custom field metadata  
**create\tables.tab**  
&nbsp;- ESQ_PARAMETER: PAR_DEFAULT VARCHAR(4000) added  
**fill\esq_parameter.sql**  
&nbsp;- aDefault parameter added; PAR_DEFAULT included in INSERT column list and VALUES  
&nbsp;- default values set: DB_NAME='esquire', DB_VERSION='1.0', Example(et34)='default', P_Example(et34)='default'  

**03/28/2026** ON DELETE CASCADE on usr/org FKs; address PKs from sequence in seed data  
**create\tables.pfi**  
&nbsp;- ON DELETE CASCADE added to ESQ_AU_USR_FK, ESQ_PE_USR_FK, ESQ_UPR_USR_FK, UR_USR_FK  
&nbsp;    (esq_auth, esq_person, esq_usr_par, esq_usr_role cascade on esq_user delete)  
&nbsp;- ON DELETE CASCADE added to ESQ_OPR_ORG_FK (esq_org_par cascades on esq_org delete)  
**fill\initial-entities.sql**  
&nbsp;- address PKs use NEXTVAL('ESQ_REF_SEQ') with RETURNING INTO variable; no hardcoded IDs  
"tree" folder removed  

**03/16/2026** AUTH permission update flags corrected in esq_role  
**fill\esq_role.sql**  
&nbsp;- AUTH update flag (position 2) corrected from 'Y' to 'N'  

**03/16/2026** ESQ_AU_TFA_METHOD_CC: 'n' added for TOTP pending-disable state  
**create\tables.cc**  
&nbsp;- ESQ_AU_TFA_METHOD_CC: allowed values extended ('N','G','g') -> ('N','n','G','g')  
&nbsp;    'n' = pending TOTP disable (transitional state; confirmed to 'N' on next login)  

**03/08/2026** personal custom parameter test case  

**03/06/2026** Balance precision fix; Example custom field made required  
**create\tables.tab**  
&nbsp;- ESQ_ACCOUNT.ACC_BALANCE: NUMERIC(3) -> NUMERIC(16,3)  
&nbsp;- ESQ_ACCOUNT_LOG.ACCL_BALANCE: NUMERIC(3) -> NUMERIC(16,3)  
**fill\esq_parameter.sql**  
&nbsp;- Example custom field (entity kind 34): PAR_NULLABLE 'Y' -> 'N' (field is required)  

**03/03/2026** ESQ_ROLE.ROLE_ADMIN_FLG replaced by ROLE_PT_PK; permission type IDs aligned  
**create\tables.tab**  
&nbsp;- ESQ_ROLE: ROLE_ADMIN_FLG VARCHAR(1) replaced by ROLE_PT_PK INT NOT NULL  
&nbsp;- (FK reference to ESQ_PERMISSION_TYPE; 980: Admin, 982: Tools)  
**create\tables.cc**  
&nbsp;- ESQ_PAR_TYPE_CC: 'integer' removed; 'text', 'date' added  
**create\tables.pfi**  
&nbsp;- ESQ_ROLE_PT_FK added (ROLE_PT_PK -> ESQ_PERMISSION_TYPE)  
&nbsp;- ESQ_ROLE_PT_FK_I index added  
**fill\esq_role.sql**  
&nbsp;- role_admin_flg -> role_pt_pk (980: Admin, 982: Tools)  
**fill\esq_permission_type.sql**  
&nbsp;- IDs aligned with esq-object-kinds: 0->980 (Admin), 1->982 (Tools)  
**fill\esq_permission.sql**  
&nbsp;- permission type refs updated: 0->980 (Admin), 1->982 (Tools)  
**fill\esq_parameter.sql**  
&nbsp;- PAR_LAYER corrected for entity type 34 (Client example param: 2->3)  

**02/28/2026** ESQ_PERSON.PE_KIND numeric type + address/person seed data  
**create\tables.tab**  
&nbsp;- ESQ_PERSON.PE_KIND: VARCHAR(1) DEFAULT 'P' -> INT DEFAULT 992  
&nbsp;- ESQ_PERSON_LOG.PEL_KIND: VARCHAR(1) -> INT  
**create\tables.cc**  
&nbsp;- ESQ_PE_KIND_CC check constraint on ESQ_PERSON commented out  
**fill\delete.sql**  
&nbsp;- esq_address and esq_person deletes added  
**fill\initial-entities.sql**  
&nbsp;- esq_person inserts added for all seed users  
&nbsp;- esq_address inserts added for merchant and client  

**02/24/2026** Audit log tables and BRIUD triggers added  
**create\tables.tab**  
&nbsp;- ESQ_USER: USR_REG_OPTION made nullable  
&nbsp;- Audit log tables added: ESQ_USER_LOG, ESQ_ADDRESS_LOG, ESQ_BANK_INFO_LOG,  
&nbsp;      ESQ_PERSON_LOG, ESQ_AUTH_LOG, ESQ_ORG_LOG, ESQ_ACCOUNT_LOG,  
&nbsp;      ESQ_USR_PAR_LOG, ESQ_ORG_PAR_LOG  
**create\all.sql**  
&nbsp;- Triggers creation section added  
added triggers\all.sql  
added triggers\esq_user_briud.sql  
added triggers\esq_address_briud.sql  
added triggers\esq_bank_info_briud.sql  
added triggers\esq_person_briud.sql  
added triggers\esq_auth_briud.sql  
added triggers\esq_org_briud.sql  
added triggers\esq_account_briud.sql  
added triggers\esq_usr_par_briud.sql  
added triggers\esq_org_par_briud.sql  

**02/19/2026** Audit columns and schema refactoring  
**create\tables.tab**  
&nbsp;- ESQ_ADDRESS: AD_EMAIL, AD_PHONE, AD_PHONE2 moved to ESQ_PERSON  
&nbsp;- ESQ_PERSON: PE_EMAIL, PE_PHONE, PE_PHONE2 added (moved from ESQ_ADDRESS)  
&nbsp;- Audit columns (*_CRL_ID, *_REQ_ID, *_UID) added to:  
&nbsp;      ESQ_ADDRESS, ESQ_BANK_INFO, ESQ_PERSON, ESQ_USER, ESQ_AUTH,  
&nbsp;      ESQ_ORG, ESQ_ACCOUNT, ESQ_USR_PAR, ESQ_ORG_PAR  

**02/02/2026** Refactoring  
&nbsp;- added sysadmin, Sys admins  
&nbsp;- reserved places in entity type enumeration for easy expanding  
&nbsp;- added ESQ_ROLE.ROLE_ADMIN_FLG: to help Access Profile dialog with user roles management  

---

## Commits

```

-- 2026-04-20 | commit: 5ecdbab | mir0n.the.programmer | v1.2.2 Finalization --
M	README.md
A	doc/reports/report_v1.2.2.md
 2 files changed, 702 insertions(+), 1 deletion(-)

-- 2026-04-20 | commit: 8913a5f | mir0n.the.programmer | ESQ_ACCT_TRANSACTION — transfer PK and conversion rate columns; log filename updates --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/all.sql
M	oracle/create/tables.sqs
M	oracle/create/tables.tab
M	oracle/fill/all.sql
M	postgres/changes.txt
M	postgres/create/all.sql
M	postgres/create/tables.sqs
M	postgres/create/tables.tab
M	postgres/fill/all.sql
 12 files changed, 53 insertions(+), 30 deletions(-)

-- 2026-04-10 | commit: b0078f9 | mir0n.the.programmer | Permission types and activity types are extended with reserved codes --
M	doc/release_notes.txt
M	oracle/fill/esq_activity_type.sql
M	oracle/fill/esq_permission_type.sql
M	postgres/fill/esq_activity_type.sql
M	postgres/fill/esq_permission_type.sql
 5 files changed, 15 insertions(+), 10 deletions(-)

-- 2026-04-09 | commit: a682922 | mir0n.the.programmer |  ESQ_ACCOUNT — funded date and negative balance flag --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.tab
M	oracle/triggers/esq_account_briud.sql
M	postgres/changes.txt
M	postgres/create/tables.tab
M	postgres/triggers/esq_account_briud.sql
M	postgres/triggers/esq_address_briud.sql
M	postgres/triggers/esq_auth_briud.sql
M	postgres/triggers/esq_bank_info_briud.sql
M	postgres/triggers/esq_org_briud.sql
M	postgres/triggers/esq_org_par_briud.sql
M	postgres/triggers/esq_person_briud.sql
M	postgres/triggers/esq_user_briud.sql
M	postgres/triggers/esq_usr_par_briud.sql
 16 files changed, 173 insertions(+), 24 deletions(-)

-- 2026-03-31 | commit: f46cdb0 | mir0n.the.programmer | ESQ_ENTITY_PATH EP_ET_PK — entity kind column added --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.tab
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/create/tables.tab
M	postgres/fill/initial-entities.sql
 8 files changed, 45 insertions(+), 24 deletions(-)

-- 2026-03-29 | commit: d4857d2 | mir0n.the.programmer | ESQ_ENTITY_PATH — path columns extracted to satellite table; trigger path resolution updated --
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/create/tables.pfi
M	oracle/create/tables.tab
M	oracle/fill/delete.sql
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
M	oracle/triggers/esq_account_briud.sql
M	oracle/triggers/esq_org_briud.sql
M	oracle/triggers/esq_user_briud.sql
M	postgres/changes.txt
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
M	postgres/fill/delete.sql
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
M	postgres/triggers/esq_account_briud.sql
M	postgres/triggers/esq_org_briud.sql
M	postgres/triggers/esq_user_briud.sql
 19 files changed, 217 insertions(+), 87 deletions(-)

-- 2026-03-28 | commit: 343ba82 | mir0n.the.programmer | ESQ_PARAMETER PAR_DEFAULT — default value for custom field metadata --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/create/tables.tab
M	oracle/fill/delete.sql
M	oracle/fill/esq_parameter.sql
M	postgres/changes.txt
M	postgres/create/tables.tab
M	postgres/fill/delete.sql
M	postgres/fill/esq_parameter.sql
 9 files changed, 44 insertions(+), 20 deletions(-)

-- 2026-03-28 | commit: eb96783 | mir0n.the.programmer |  ON DELETE CASCADE on usr/org FKs; address PKs from sequence in seed data; tree removed --
A	doc/foreignKeys.md
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/create/tables.pfi
M	oracle/fill/initial-entities.sql
D	oracle/tree/build-tree.sql
D	oracle/tree/create-tree.sql
M	postgres/changes.txt
M	postgres/create/tables.pfi
M	postgres/fill/initial-entities.sql
D	postgres/tree/build-tree.sql
D	postgres/tree/create-tree.sql
 12 files changed, 251 insertions(+), 551 deletions(-)

-- 2026-03-16 | commit: 05af2e7 | mir0n.the.programmer | TOTP pending-disable state --
M	doc/release_notes.txt
M	oracle/changes.txt
M	oracle/create/tables.cc
M	postgres/changes.txt
M	postgres/create/tables.cc
 5 files changed, 17 insertions(+), 2 deletions(-)

-- 2026-03-08 | commit: d2fa13a | mir0n.the.programmer | Personal custom parameter test case --
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/fill/esq_parameter.sql
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/fill/esq_parameter.sql
M	postgres/fill/initial-entities.sql
 7 files changed, 22 insertions(+), 5 deletions(-)

-- 2026-03-06 | commit: 136e72c | mir0n.the.programmer | Account balance precision fix; custom field validation --
M	doc/release_notes.txt
M	postgres/changes.txt
M	postgres/create/tables.tab
M	postgres/fill/esq_parameter.sql
 4 files changed, 14 insertions(+), 3 deletions(-)

-- 2026-03-03 | commit: d7c4114 | mir0n.the.programmer | ESQ_ROLE: ROLE_ADMIN_FLG replaced by ROLE_PT_PK; permission type IDs aligned --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.cc
M	oracle/create/tables.pfi
M	oracle/create/tables.tab
M	oracle/fill/esq_permission.sql
M	oracle/fill/esq_permission_type.sql
M	oracle/fill/esq_role.sql
M	postgres/changes.txt
M	postgres/create/tables.cc
M	postgres/create/tables.pfi
M	postgres/create/tables.tab
M	postgres/fill/esq_parameter.sql
M	postgres/fill/esq_permission.sql
M	postgres/fill/esq_permission_type.sql
M	postgres/fill/esq_role.sql
 17 files changed, 172 insertions(+), 73 deletions(-)

-- 2026-02-28 | commit: f8bdeb1 | mir0n.the.programmer | ESQ_PERSON.PE_KIND numeric type; address and person seed data --
M	README.md
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/all.sql
M	oracle/create/tables.cc
M	oracle/create/tables.tab
M	oracle/fill/delete.sql
M	oracle/fill/esq_parameter.sql
M	oracle/fill/initial-entities.sql
M	postgres/changes.txt
M	postgres/create/tables.cc
M	postgres/create/tables.tab
M	postgres/fill/delete.sql
M	postgres/fill/initial-entities.sql
 15 files changed, 155 insertions(+), 32 deletions(-)

-- 2026-02-24 | commit: 2606338 | mir0n.the.programmer | Audit log tables and triggers --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
D	oracle/all.sql
M	oracle/changes.txt
M	oracle/create/tables.tab
A	oracle/triggers/all.sql
A	oracle/triggers/esq_account_briud.sql
A	oracle/triggers/esq_address_briud.sql
A	oracle/triggers/esq_auth_briud.sql
A	oracle/triggers/esq_bank_info_briud.sql
A	oracle/triggers/esq_org_briud.sql
A	oracle/triggers/esq_org_par_briud.sql
A	oracle/triggers/esq_person_briud.sql
A	oracle/triggers/esq_user_briud.sql
A	oracle/triggers/esq_usr_par_briud.sql
M	postgres/changes.txt
M	postgres/create/all.sql
M	postgres/create/tables.tab
A	postgres/triggers/all.sql
A	postgres/triggers/esq_account_briud.sql
A	postgres/triggers/esq_address_briud.sql
A	postgres/triggers/esq_auth_briud.sql
A	postgres/triggers/esq_bank_info_briud.sql
A	postgres/triggers/esq_org_briud.sql
A	postgres/triggers/esq_org_par_briud.sql
A	postgres/triggers/esq_person_briud.sql
A	postgres/triggers/esq_user_briud.sql
A	postgres/triggers/esq_usr_par_briud.sql
 28 files changed, 2580 insertions(+), 35 deletions(-)

-- 2026-02-19 | commit: cfb608c | mir0n.the.programmer | Audit columns and schema refactoring --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.tab
M	postgres/changes.txt
M	postgres/create/tables.tab
 6 files changed, 199 insertions(+), 35 deletions(-)

-- 2026-02-02 | commit: 241733b | mir0n.the.programmer | Added sysadmin, Sys admins --
M	doc/release_notes.txt
M	erd/ESQ.2026.ERD.vsdx
M	oracle/changes.txt
M	oracle/create/tables.tab
M	oracle/fill/esq_entity_type.sql
M	oracle/fill/esq_parameter.sql
M	oracle/fill/esq_permission.sql
M	oracle/fill/esq_role.sql
M	oracle/fill/initial-entities.sql
M	oracle/tree/build-tree.sql
M	postgres/changes.txt
M	postgres/create/tables.tab
M	postgres/fill/esq_entity_type.sql
M	postgres/fill/esq_parameter.sql
M	postgres/fill/esq_permission.sql
M	postgres/fill/esq_role.sql
M	postgres/fill/initial-entities.sql
M	postgres/tree/build-tree.sql
 18 files changed, 596 insertions(+), 505 deletions(-)
```

---

## Files Modified

```
M	README.md
A	doc/foreignKeys.md
M	doc/release_notes.txt
A	doc/reports/report_v1.2.2.md
M	erd/ESQ.2026.ERD.vsdx
D	oracle/all.sql
M	oracle/changes.txt
M	oracle/create/all.sql
M	oracle/create/tables.cc
M	oracle/create/tables.pfi
M	oracle/create/tables.sqs
M	oracle/create/tables.tab
M	oracle/fill/all.sql
M	oracle/fill/delete.sql
M	oracle/fill/esq_activity_type.sql
M	oracle/fill/esq_entity_type.sql
M	oracle/fill/esq_parameter.sql
M	oracle/fill/esq_permission.sql
M	oracle/fill/esq_permission_type.sql
M	oracle/fill/esq_role.sql
M	oracle/fill/initial-entities.sql
M	oracle/fill/root.sql
D	oracle/tree/build-tree.sql
D	oracle/tree/create-tree.sql
A	oracle/triggers/all.sql
A	oracle/triggers/esq_account_briud.sql
A	oracle/triggers/esq_address_briud.sql
A	oracle/triggers/esq_auth_briud.sql
A	oracle/triggers/esq_bank_info_briud.sql
A	oracle/triggers/esq_org_briud.sql
A	oracle/triggers/esq_org_par_briud.sql
A	oracle/triggers/esq_person_briud.sql
A	oracle/triggers/esq_user_briud.sql
A	oracle/triggers/esq_usr_par_briud.sql
M	postgres/changes.txt
M	postgres/create/all.sql
M	postgres/create/tables.cc
M	postgres/create/tables.pfi
M	postgres/create/tables.sqs
M	postgres/create/tables.tab
M	postgres/fill/all.sql
M	postgres/fill/delete.sql
M	postgres/fill/esq_activity_type.sql
M	postgres/fill/esq_entity_type.sql
M	postgres/fill/esq_parameter.sql
M	postgres/fill/esq_permission.sql
M	postgres/fill/esq_permission_type.sql
M	postgres/fill/esq_role.sql
M	postgres/fill/initial-entities.sql
M	postgres/fill/root.sql
D	postgres/tree/build-tree.sql
D	postgres/tree/create-tree.sql
A	postgres/triggers/all.sql
A	postgres/triggers/esq_account_briud.sql
A	postgres/triggers/esq_address_briud.sql
A	postgres/triggers/esq_auth_briud.sql
A	postgres/triggers/esq_bank_info_briud.sql
A	postgres/triggers/esq_org_briud.sql
A	postgres/triggers/esq_org_par_briud.sql
A	postgres/triggers/esq_person_briud.sql
A	postgres/triggers/esq_user_briud.sql
A	postgres/triggers/esq_usr_par_briud.sql
 62 files changed, 4990 insertions(+), 1172 deletions(-)
```

---

*From `v1.2.1` till `HEAD`*
