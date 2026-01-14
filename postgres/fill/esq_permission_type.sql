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

    CALL temp_permission_type ( 0,      'Admin', 'Entity functions');
    CALL temp_permission_type ( 1,     'Tools',  'Tools avialable'); 
    CALL temp_permission_type ( 2,      'Apps', 'Applications permitted');
--	CALL temp_permission_type ( 3,	'Reports',  'Report avialable');
	COMMIT;
END $$;

DROP PROCEDURE temp_permission_type;

\echo -n 'Done\n'
\qecho -n 'Done\n'
