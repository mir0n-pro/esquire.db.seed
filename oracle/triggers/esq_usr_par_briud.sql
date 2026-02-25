CREATE OR REPLACE TRIGGER esq_usr_par_briud BEFORE INSERT OR DELETE OR UPDATE ON ESQ_USR_PAR
FOR EACH ROW
---------------------------------------
--
---------------------------------------
DECLARE
    oper VARCHAR2(1) := 'D';
BEGIN
    IF DELETING THEN
        INSERT INTO esq_usr_par_log (
          uprl_action
         ,uprl_usr_pk
         ,uprl_par_name
         ,uprl_par_et_pk
         ,uprl_value
         ,uprl_crl_id
         ,uprl_req_id
         ,uprl_uid
        ) VALUES (
          oper
         ,:OLD.upr_usr_pk
         ,:OLD.upr_par_name
         ,:OLD.upr_par_et_pk
         ,:OLD.upr_value
         ,:OLD.upr_crl_id
         ,:OLD.upr_req_id
         ,:OLD.upr_uid
        );
    ELSE
        oper := 'U';
        IF INSERTING THEN
            oper := 'I';
        END IF;

        INSERT INTO esq_usr_par_log (
          uprl_action
         ,uprl_usr_pk
         ,uprl_par_name
         ,uprl_par_et_pk
         ,uprl_value
         ,uprl_crl_id
         ,uprl_req_id
         ,uprl_uid
        ) VALUES (
          oper
         ,:NEW.upr_usr_pk
         ,:NEW.upr_par_name
         ,:NEW.upr_par_et_pk
         ,:NEW.upr_value
         ,:NEW.upr_crl_id
         ,:NEW.upr_req_id
         ,:NEW.upr_uid
        );
	   END IF;
END;
/
SHOW ERRORS
/



