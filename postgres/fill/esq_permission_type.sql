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

CREATE OR REPLACE PROCEDURE temp_permission_type (
    aID     IN integer,
    aName		IN varchar,
    aDesc		IN varchar
) LANGUAGE plpgsql
AS $$
BEGIN

	INSERT INTO esq_permission_type (
		pt_pk,
		pt_name,
		pt_desc
	) VALUES (
		aID,					
		aName,					
		aDesc					
	);

END $$;																										

DO $$
BEGIN
	DELETE FROM esq_permission_type;
	CALL temp_permission_type ( 0,      'Other', 'General permissions');
	CALL temp_permission_type ( 1, 'Supervizor', 'System level functions');
	CALL temp_permission_type ( 2,   'Creation', 'Creates a new system object');
	CALL temp_permission_type ( 3,   'Deletion', 'Deletes a system object');
	CALL temp_permission_type ( 4,'Maintenance', 'Edit properties of object');
	CALL temp_permission_type ( 5,'Permissions', 'Edit logon information and permissions');
	CALL temp_permission_type ( 6,       'Tool', 'Runs a tool');
--	temp_permission_type ( 7,	     'Report', 'Creates a report');
--	temp_permission_type ( 8,  'Accounting', 'Makes account operations');
	COMMIT;
END $$;

DROP PROCEDURE temp_permission_type;

\echo -n 'Done\n'
\qecho -n 'Done\n'
