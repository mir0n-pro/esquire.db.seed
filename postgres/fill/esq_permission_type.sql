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
-- 03/03/2026 mir0n IDs aligned with esq-object-kinds: 0->980 (Admin), 1->982 (Tools)

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

    CALL temp_permission_type ( 980,    'Admin', 'Entity functions');
    CALL temp_permission_type ( 982,    'Tools',  'Tools avialable'); 
    CALL temp_permission_type ( 984,    'Apps', 'Applications permitted');
    CALL temp_permission_type ( 986,	'Reports',  'Report avialable');
    COMMIT;
END $$;

DROP PROCEDURE temp_permission_type;

\echo -n 'Done\n'
\qecho -n 'Done\n'
