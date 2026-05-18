|![Alt text](./favicon.ico)|Esquire Frameworks(tm) 2.0|
|:-|:-|

The frameworks to organize business entities in a tree, any kind of business or activity. 
The framework is targeting to cover traditional functionality for a Backoffice (sub)system: onboarding,
user profile maintenance, permissions, authorization, accounting.

## esquire.db.seed
Part of Esquire frameworks. Set of database seed scripts

## v1.2.4 — complete (05/14/2026)

Test House subtree seeded for the v1.2.4 hauberk harness: Test House org (pk=14, ep_path='1.14.') under root, with three admin USRs (kind=32) -- one per non-browser auth pattern in the gateway:

- **Test Driver** (usr_pk=15) -- Plain JWT, backs `esq-hauberk` KC service account
- **Test Driver S** (usr_pk=16) -- Vanilla Token Relay, backs `esq-hauberk-S`
- **Test Driver M** (usr_pk=17) -- Phantom Token Relay (RFC 8693 token-exchange), backs `esq-hauberk-M` *

The `usr_pk` values back the `esq_uid` attribute on the corresponding KC service-account users. Test House + Test Driver/Driver S apply to both Oracle and Postgres branches; Test Driver M lives only in the Postgres seed.

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

