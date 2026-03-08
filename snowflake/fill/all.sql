-----------------------------------
-- project:	Esquire
-- version:	1.0
-- Copyright (c) Miron 2000
--
-- file :	fill/all.sql
-- desc:	Fills out the tables (Snowflake)
--
-- Run with SnowSQL: !source fill/all.sql
-----------------------------------

-----------------------------------
SELECT '----- Delete -----' AS status;
!source fill/delete.sql
-----------------------------------
SELECT '----- Entity Types -----' AS status;
!source fill/esq_entity_type.sql
-----------------------------------
SELECT '----- Parameters -----' AS status;
!source fill/esq_parameter.sql
-----------------------------------
SELECT '----- Permission types -----' AS status;
!source fill/esq_permission_type.sql
-----------------------------------
SELECT '----- Permissions -----' AS status;
!source fill/esq_permission.sql
-----------------------------------
SELECT '----- Activity types -----' AS status;
!source fill/esq_activity_type.sql
-----------------------------------
SELECT '----- Roles -----' AS status;
!source fill/esq_role.sql
-----------------------------------
SELECT '----- Root -----' AS status;
!source fill/root.sql

SELECT '----- Initial entities -----' AS status;
!source fill/initial-entities.sql
