CREATE OR REPLACE TRIGGER esq_org_par_briud BEFORE INSERT OR DELETE OR UPDATE ON ESQ_ORG_PAR
FOR EACH ROW
---------------------------------------
--
---------------------------------------
DECLARE
    oper VARCHAR2(1) := 'D';
BEGIN
    IF DELETING THEN
        INSERT INTO esq_org_par_log (
          oprl_action
         ,oprl_org_pk
         ,oprl_par_name
         ,oprl_par_et_pk
         ,oprl_value
         ,oprl_change_no
         ,oprl_crl_id
         ,oprl_req_id
         ,oprl_uid
        ) VALUES (
          oper
         ,:OLD.opr_org_pk
         ,:OLD.opr_par_name
         ,:OLD.opr_par_et_pk
         ,:OLD.opr_value
         ,:OLD.opr_change_no + 1
         ,:OLD.opr_crl_id
         ,:OLD.opr_req_id
         ,:OLD.opr_uid
        );
    ELSE
        oper := 'U';
        IF INSERTING THEN
            oper := 'I';
        END IF;

        INSERT INTO esq_org_par_log (
          oprl_action
         ,oprl_org_pk
         ,oprl_par_name
         ,oprl_par_et_pk
         ,oprl_value
         ,oprl_change_no
         ,oprl_crl_id
         ,oprl_req_id
         ,oprl_uid
        ) VALUES (
          oper
         ,:NEW.opr_org_pk
         ,:NEW.opr_par_name
         ,:NEW.opr_par_et_pk
         ,:NEW.opr_value
         ,:NEW.opr_change_no
         ,:NEW.opr_crl_id
         ,:NEW.opr_req_id
         ,:NEW.opr_uid
        );
	   END IF;
END;
/
SHOW ERRORS
/



