|![Alt text](./favicon.ico)|Esquire Frameworks(tm) 2.0|
|:-|:-|

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

## v1.2.2 — complete (04/20/2026)

Schema and seed data aligned with the v1.2.2 backend milestone.

Key changes:
- **Audit infrastructure**: audit columns (*_CRL_ID, *_REQ_ID, *_UID) added to all major tables; BRIUD triggers introduced for all entity tables (Oracle and Postgres)
- **ESQ_ENTITY_PATH**: entity path extracted to a dedicated satellite table; EP_ET_PK (entity kind) column added
- **Accounting**: ESQ_ACCT_TRANSACTION expanded with string PK, transfer-link column (ATR_PK_TX), conversion rate (NUMERIC(12,6)), reference/memo fields; ESQ_ACCOUNT gains funded-date and negative-balance flag
- **Roles and permissions**: ROLE_ADMIN_FLG replaced by ROLE_PT_PK (FK to ESQ_PERMISSION_TYPE); permission type IDs aligned with esq-object-kinds
- **Referential integrity**: ON DELETE CASCADE added to user and org FK chains; address PKs use sequences
- **TOTP**: pending-disable state ('n') added to TFA method constraint
- **Postgres**: all triggers converted to BEFORE pattern (RETURN OLD/NEW)

