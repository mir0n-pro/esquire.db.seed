# Esquire Database — Foreign Key Reference

All foreign key constraints defined in `oracle/create/tables.pfi` and `postgres/create/tables.pfi`.
Both files are kept in sync. ON DELETE behavior is identical across both vendors.

---

## ON DELETE behavior legend

| Behavior | Meaning |
|---|---|
| RESTRICT | Default (no clause). Parent row cannot be deleted while child rows exist. |
| CASCADE | Child rows are automatically deleted when the parent row is deleted. |
| SET NULL | FK column is set to NULL when the parent row is deleted (column must be nullable). |

---

## Core entity hierarchy (RESTRICT)

| Constraint | Child table | Child column(s) | Parent table | Parent column |
|---|---|---|---|---|
| ESQ_ORG_ORG_FK | ESQ_ORG | ORG_ORG_PK | ESQ_ORG | ORG_PK |
| ESQ_USR_ORG_FK | ESQ_USER | USR_ORG_PK | ESQ_ORG | ORG_PK |
| ESQ_ACCT_USR_FK | ESQ_ACCOUNT | ACC_USR_PK | ESQ_USER | USR_PK |

Self-referential org hierarchy and the three main entity tiers are all RESTRICT: a parent org, org, or user cannot be deleted while child records exist.

---

## Path satellite (RESTRICT)

| Constraint | Child table | Child column(s) | Parent table | Parent column |
|---|---|---|---|---|
| ESQ_ORG_EP_FK | ESQ_ORG | ORG_PK | ESQ_ENTITY_PATH | EP_PK |
| ESQ_USR_EP_FK | ESQ_USER | USR_PK | ESQ_ENTITY_PATH | EP_PK |
| ESQ_ACC_EP_FK | ESQ_ACCOUNT | ACC_PK | ESQ_ENTITY_PATH | EP_PK |

Each entity shares its key with a row in `ESQ_ENTITY_PATH`, which records where that entity sits in the
tree. The key is the same value on both sides, and entity keys are unique across all three tables, so one
key is enough to find the path without knowing which table the entity is in.

---

## Auth (CASCADE from user)

| Constraint | Child table | Child column(s) | Parent table | Parent column | ON DELETE |
|---|---|---|---|---|---|
| ESQ_AU_USR_FK | ESQ_AUTH | AU_USR_PK | ESQ_USER | USR_PK | CASCADE |

---

## Person — cascade from user, nullable links to address

| Constraint | Child table | Child column(s) | Parent table | Parent column | ON DELETE |
|---|---|---|---|---|---|
| ESQ_PE_USR_FK | ESQ_PERSON | PE_USR_PK | ESQ_USER | USR_PK | CASCADE |
| ESQ_PE_AD_FK | ESQ_PERSON | PE_AD_PK | ESQ_ADDRESS | AD_PK | SET NULL |
| ESQ_PE_AD_BIZ_FK | ESQ_PERSON | PE_AD_PK_BIZ | ESQ_ADDRESS | AD_PK | SET NULL |

Person record is owned by the user — deleted automatically with the user.
Address is a shared reference — unlinked (SET NULL) when the referenced record is deleted.

---

## User parameters (CASCADE from user)

| Constraint | Child table | Child column(s) | Parent table | Parent column | ON DELETE |
|---|---|---|---|---|---|
| ESQ_UPR_USR_FK | ESQ_USR_PAR | UPR_USR_PK | ESQ_USER | USR_PK | CASCADE |
| ESQ_UPR_PAR_FK | ESQ_USR_PAR | UPR_PAR_NAME, UPR_PAR_ET_PK | ESQ_PARAMETER | PAR_NAME, PAR_ET_PK | RESTRICT |

---

## Org parameters (CASCADE from org)

| Constraint | Child table | Child column(s) | Parent table | Parent column | ON DELETE |
|---|---|---|---|---|---|
| ESQ_OPR_ORG_FK | ESQ_ORG_PAR | OPR_ORG_PK | ESQ_ORG | ORG_PK | CASCADE |
| ESQ_OPR_PAR_FK | ESQ_ORG_PAR | OPR_PAR_NAME, OPR_PAR_ET_PK | ESQ_PARAMETER | PAR_NAME, PAR_ET_PK | RESTRICT |

---

## User roles (CASCADE from user)

| Constraint | Child table | Child column(s) | Parent table | Parent column | ON DELETE |
|---|---|---|---|---|---|
| UR_USR_FK | ESQ_USR_ROLE | UR_USR_PK | ESQ_USER | USR_PK | CASCADE |
| UR_ROLE_FK | ESQ_USR_ROLE | UR_ROLE_PK | ESQ_ROLE | ROLE_PK | RESTRICT |

---

## Roles and permissions (RESTRICT)

| Constraint | Child table | Child column(s) | Parent table | Parent column |
|---|---|---|---|---|
| ESQ_ROLE_PT_FK | ESQ_ROLE | ROLE_PT_PK | ESQ_PERMISSION_TYPE | PT_PK |
| RP_ROLE_FK | ESQ_ROLE_PRM | RP_ROLE_PK | ESQ_ROLE | ROLE_PK |
| RP_PRM_FK | ESQ_ROLE_PRM | RP_PRM_PK | ESQ_PERMISSION | PRM_PK |
| RT_ROLE_FK | ESQ_ROLE_ET | RT_ROLE_PK | ESQ_ROLE | ROLE_PK |
| RT_ET_FK | ESQ_ROLE_ET | RT_ET_PK | ESQ_ENTITY_TYPE | ET_PK |
| ESQ_PRM_ET_FK | ESQ_PERMISSION | PRM_ET_PK | ESQ_ENTITY_TYPE | ET_PK |
| ESQ_PRM_PT_FK | ESQ_PERMISSION | PRM_PT_PK | ESQ_PERMISSION_TYPE | PT_PK |

---

## Parameters (RESTRICT)

| Constraint | Child table | Child column(s) | Parent table | Parent column |
|---|---|---|---|---|
| ESQ_PAR_ET_FK | ESQ_PARAMETER | PAR_ET_PK | ESQ_ENTITY_TYPE | ET_PK |

---

## Transactions (RESTRICT)

| Constraint | Child table | Child column(s) | Parent table | Parent column |
|---|---|---|---|---|
| ESQ_ATR_ACC_FK | ESQ_ACCT_TRANSACTION | ATR_ACC_PK | ESQ_ACCOUNT | ACC_PK |
| ESQ_ATR_AT_FK | ESQ_ACCT_TRANSACTION | ATR_AT_PK | ESQ_ACTIVITY_TYPE | AT_PK |

---

## Delete sequence (application-managed)

### User delete

Pre-condition check (application level — `deleteUsr()` in `UsrService`):
- Lock the user row with `SELECT FOR UPDATE` (joins `ESQ_USER`, `ESQ_AUTH`).
- Read `au_connect_flg`. If `'Y'` → throw `DeleteRestrictedException` (409). Login must be disabled before the user can be deleted.

Explicit deletes (must run before the user row is removed, while `ESQ_PERSON` still exists):
1. `ESQ_ADDRESS` — delete rows referenced by `pe_ad_pk` and `pe_ad_pk_biz` in `ESQ_PERSON` (subquery on `pe_usr_pk`).
2. `ESQ_AUTH` — explicit delete (redundant with CASCADE but kept for clarity).

Cascaded automatically on `DELETE FROM ESQ_USER`:
3. `ESQ_AUTH` — CASCADE (`ESQ_AU_USR_FK`)
4. `ESQ_USR_ROLE` — CASCADE (`UR_USR_FK`)
5. `ESQ_USR_PAR` — CASCADE (`ESQ_UPR_USR_FK`)
6. `ESQ_PERSON` — CASCADE (`ESQ_PE_USR_FK`) — the address FKs on person are SET NULL (irrelevant, person row is being deleted)

### Org delete

Pre-condition check (DB level — RESTRICT FKs):
- `ESQ_USER.USR_ORG_PK` → `ESQ_ORG.ORG_PK` (RESTRICT) — no child users may exist.
- `ESQ_ORG.ORG_ORG_PK` → `ESQ_ORG.ORG_PK` (RESTRICT) — no child orgs may exist.

No application-level restriction. Cascaded automatically on `DELETE FROM ESQ_ORG`:
1. `ESQ_ORG_PAR` — CASCADE (`ESQ_OPR_ORG_FK`)

### Account delete

Pre-condition check (application level — `deleteAcct()` in `PacManService`):
- Lock the account row with `SELECT FOR UPDATE`.
- Read `acc_status`. If not `'C'` (closed) → throw `DeleteRestrictedException` (409). Account must be closed before it can be deleted.

Pre-condition check (DB level — RESTRICT FKs):
- `ESQ_ACCT_TRANSACTION.ATR_ACC_PK` → `ESQ_ACCOUNT.ACC_PK` (RESTRICT) — no transactions may exist.

No cascaded children — account has no owned child tables.

---

_Last updated: 2026-03-27_
