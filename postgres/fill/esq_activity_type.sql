-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2025
--
-- file :   fill/esq_activity_type.sql
-- desc:    Fills esq_activity_type table
--
-----------------------------------
-- History:
--  

CREATE OR REPLACE PROCEDURE temp_activity_type (
    aID integer,
    aName varchar,
    aDesc varchar
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO esq_activity_type (
        at_pk,
        at_name,
        at_desc
    ) VALUES (
        aID,
        aName,
        aDesc
    );
END $$;

DO $$
BEGIN
		DELETE FROM esq_activity_type;
    CALL temp_activity_type(1, 'Deposit', 'Deposit');
    CALL temp_activity_type(2, 'Withdrawal', 'Withdrawal');
    CALL temp_activity_type(3, 'Transfer', 'Transfer funds');
		COMMIT;
END $$;
   

DROP PROCEDURE temp_activity_type;

\echo -n 'Done\n'
\qecho -n 'Done\n'
