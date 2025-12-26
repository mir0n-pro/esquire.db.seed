-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2025
--
-- file :	create/delete.sql
-- desc:	Deletion of DB objects
--
-----------------------------------
-- History:
--  
-- 01.08.2000			Created
-- 03.03.2001			Removes all objects

SET SERVEROUTPUT ON SIZE 200000
declare
  s_command VARCHAR2(500);
  CURSOR c_obj IS 
  SELECT DISTINCT OBJECT_NAME objname,
         OBJECT_TYPE objtype
  FROM USER_OBJECTS 
  WHERE OBJECT_TYPE NOT IN ('INDEX')
  ORDER BY OBJECT_TYPE DESC;
BEGIN
	FOR r IN c_obj LOOP
    IF INSTR(r.objname,'ESQ_') = 1 THEN
		  BEGIN 
  			s_command := 'drop '||r.objtype||' '||r.objname;
  			IF r.objtype = 'TABLE' THEN
  				s_command := s_command || ' CASCADE CONSTRAINTS';
  			END IF;
  			dbms_output.put_line(s_command);
  			EXECUTE IMMEDIATE s_command;
  		EXCEPTION WHEN OTHERS THEN
  			dbms_output.put_line(sqlerrm);
  		END;
    END IF;
	END LOOP;
end;
/




