---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_org_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
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
         ,OLD.org_pk
         ,OLD.org_et_pk
         ,OLD.org_name
         ,OLD.org_path
         ,OLD.org_full_name
         ,OLD.org_org_pk
         ,OLD.org_desc
         ,OLD.org_crl_id
         ,OLD.org_req_id
         ,OLD.org_uid
        );
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
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
         ,NEW.org_pk
         ,NEW.org_et_pk
         ,NEW.org_name
         ,NEW.org_path
         ,NEW.org_full_name
         ,NEW.org_org_pk
         ,NEW.org_desc
         ,NEW.org_crl_id
         ,NEW.org_req_id
         ,NEW.org_uid
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_org_briud
AFTER INSERT OR UPDATE OR DELETE ON ESQ_ORG
FOR EACH ROW EXECUTE FUNCTION esq_org_briud();
