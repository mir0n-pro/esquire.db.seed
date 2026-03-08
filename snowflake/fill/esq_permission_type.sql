-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2025
--
-- file :	fill/esq_permission_type.sql
-- desc:	Fills esq_permission_type table (Snowflake)
-----------------------------------

DELETE FROM ESQ_PERMISSION_TYPE;

INSERT INTO ESQ_PERMISSION_TYPE (PT_PK, PT_NAME, PT_DESC) VALUES
 (980, 'Admin', 'Entity functions'),
 (982, 'Tools', 'Tools avialable');
--  (984, 'Apps',    'Applications permitted');
--  (986, 'Reports', 'Report avialable');

SELECT 'Done' AS status;
