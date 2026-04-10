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
CREATE OR REPLACE PROCEDURE temp_activity_type (aID         IN NUMBER,
    aName       IN VARCHAR2,
    aDesc       IN VARCHAR2) IS

BEGIN
    INSERT INTO ESQ_ACTIVITY_TYPE (
        AT_PK,
        AT_NAME,
        AT_DESC
    ) VALUES (
        aID,                    
        aName,                  
        aDesc                   
    );
    commit;
END;                                                                                                        
/
show errors;                                            
DELETE FROM ESQ_ACTIVITY_TYPE;
COMMIT;
BEGIN
    temp_activity_type ( 1,   'Deposit', 'Deposit');
    temp_activity_type ( 2,   'Withdrawal', 'Withdrawal');
    temp_activity_type ( 3,   'Transfer', 'Transfer funds');
    temp_activity_type ( 4,   'Adj', 'Balance adjustment');
    temp_activity_type ( 5,   'Comm', 'Commission');

END;
/
drop procedure temp_activity_type;
