-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create.log/delete.sql
-- desc:	Deletion of audit-log DB objects
--
-----------------------------------
-- History:
-- 06/04/2026 mir0n created: drops the *_log audit tables
-- 08/11/2026 mir0n v1.2.12 ESQ_BANK_INFO_LOG dropped from the drop list

SET SERVEROUTPUT ON SIZE 200000
declare
  s_command VARCHAR2(500);
  TYPE t_names IS TABLE OF VARCHAR2(30);
  c_obj t_names := t_names(
     'ESQ_ADDRESS_LOG'
    ,'ESQ_PERSON_LOG'
    ,'ESQ_USER_LOG'
    ,'ESQ_AUTH_LOG'
    ,'ESQ_ORG_LOG'
    ,'ESQ_ACCOUNT_LOG'
    ,'ESQ_USR_PAR_LOG'
    ,'ESQ_ORG_PAR_LOG'
  );
BEGIN
	FOR i IN c_obj.FIRST .. c_obj.LAST LOOP
	  BEGIN
			s_command := 'drop table '||c_obj(i)||' CASCADE CONSTRAINTS';
			dbms_output.put_line(s_command);
			EXECUTE IMMEDIATE s_command;
		EXCEPTION WHEN OTHERS THEN
			dbms_output.put_line(sqlerrm);
		END;
	END LOOP;
end;
/
