CREATE OR REPLACE TRIGGER esq_org_briud BEFORE INSERT OR DELETE OR UPDATE ON ESQ_ORG
FOR EACH ROW
---------------------------------------
--
---------------------------------------
DECLARE
    oper VARCHAR2(1) := 'D';
BEGIN
    IF DELETING THEN
        INSERT INTO esq_org_log (
          orgl_action
         ,orgl_pk
         ,orgl_et_pk
         ,orgl_name
         ,orgl_path
         ,orgl_full_name
         ,orgl_org_pk
         ,orgl_desc
         ,orgl_crl_id
         ,orgl_req_id
         ,orgl_uid
        ) VALUES (
          oper
         ,:OLD.org_pk
         ,:OLD.org_et_pk
         ,:OLD.org_name
         ,(SELECT ep_path FROM esq_entity_path WHERE ep_pk = :OLD.org_pk)
         ,:OLD.org_full_name
         ,:OLD.org_org_pk
         ,:OLD.org_desc
         ,:OLD.org_crl_id
         ,:OLD.org_req_id
         ,:OLD.org_uid
        );
    ELSE
        oper := 'U';
        IF INSERTING THEN
            oper := 'I';
        END IF;

        INSERT INTO esq_org_log (
          orgl_action
         ,orgl_pk
         ,orgl_et_pk
         ,orgl_name
         ,orgl_path
         ,orgl_full_name
         ,orgl_org_pk
         ,orgl_desc
         ,orgl_crl_id
         ,orgl_req_id
         ,orgl_uid
        ) VALUES (
          oper
         ,:NEW.org_pk
         ,:NEW.org_et_pk
         ,:NEW.org_name
         ,(SELECT ep_path FROM esq_entity_path WHERE ep_pk = :NEW.org_pk)
         ,:NEW.org_full_name
         ,:NEW.org_org_pk
         ,:NEW.org_desc
         ,:NEW.org_crl_id
         ,:NEW.org_req_id
         ,:NEW.org_uid
        );
	   END IF;
END;
/
SHOW ERRORS
/



