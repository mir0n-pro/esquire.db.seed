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
--  

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

	temp_permission_type ( 0,      'Other', 'General permissions');
	temp_permission_type ( 1,'Supervizor', 'System level functions');
	temp_permission_type ( 2,   'Creation', 'Creates a new system object');
	temp_permission_type ( 3,   'Deletion', 'Deletes a system object');
	temp_permission_type ( 4,'Maintenance', 'Edit properties of object');
	temp_permission_type ( 5,'Permissions', 'Edit logon information and permissions');
	temp_permission_type ( 6,       'Tool', 'Runs a tool');
--	temp_permission_type ( 7,	     'Report', 'Creates a report');
--	temp_permission_type ( 8,  'Accounting', 'Makes account operations');

END;
/
drop procedure temp_permission_type;
