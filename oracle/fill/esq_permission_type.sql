-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2025
--
-- file :	fill/esq_permission_type.sql
-- desc:	Fills esq_permission_type table
--
-----------------------------------
-- History:
-- 01/14/2026 mir0n generalized format of permission type

CREATE OR REPLACE PROCEDURE temp_permission_type (aID			IN NUMBER,
    aName		IN VARCHAR2,
    aDesc		IN VARCHAR2) IS

BEGIN
	INSERT INTO ESQ_PERMISSION_TYPE (
		PT_PK,
		PT_NAME,
		PT_DESC
	) VALUES (
		aID,					
		aName,					
		aDesc					
	);
	commit;
END;																										
/
show errors;											
DELETE FROM ESQ_PERMISSION_TYPE;
COMMIT;
BEGIN

	temp_permission_type ( 0,      'Admin', 'Entity functions');
	temp_permission_type ( 1,     'Tools',  'Tools avialable'); 
	temp_permission_type ( 2,      'Apps', 'Applications permitted');
--	temp_permission_type ( 3,	'Reports',  'Report avialable');

END;
/
drop procedure temp_permission_type;
