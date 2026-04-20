-----------------------------------
-- project:	Esquire
-- version:	1.0
-- Copyright (c) Miron 2000
--
-- file :	fill/all.sql
-- desc:	Fills out the tables
--
-----------------------------------
-- History:
--  
-- 01.08.2000			Created
-- 06.20.2000			Reviewed
-- 01/14/2026 mir0n Roles added

SPOOL esq2025-fill.log
-----------------------------------
PROMPT Delete Types
@@delete.sql
-----------------------------------
PROMPT Entity Types
@@esq_entity_type.sql
-----------------------------------
PROMPT Parameters
@@esq_parameter.sql
-----------------------------------
PROMPT Permission types
@@esq_permission_type.sql
-----------------------------------
PROMPT Permissions
@@esq_permission.sql
-----------------------------------
PROMPT Activity types
@@esq_activity_type.sql
-----------------------------------
PROMPT Roles
@@esq_role.sql
-----------------------------------
PROMPT Root
@@root.sql

PROMPT Initial entities
@@initial-entities.sql

SPOOL OFF