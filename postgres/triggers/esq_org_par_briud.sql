---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_org_par_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_org_par_log (
          oprl_action
         ,oprl_org_pk
         ,oprl_par_name
         ,oprl_par_et_pk
         ,oprl_value
         ,oprl_crl_id
         ,oprl_req_id
         ,oprl_uid
        ) VALUES (
          oper
         ,OLD.opr_org_pk
         ,OLD.opr_par_name
         ,OLD.opr_par_et_pk
         ,OLD.opr_value
         ,OLD.opr_crl_id
         ,OLD.opr_req_id
         ,OLD.opr_uid
        );
        RETURN OLD;
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_org_par_log (
          oprl_action
         ,oprl_org_pk
         ,oprl_par_name
         ,oprl_par_et_pk
         ,oprl_value
         ,oprl_crl_id
         ,oprl_req_id
         ,oprl_uid
        ) VALUES (
          oper
         ,NEW.opr_org_pk
         ,NEW.opr_par_name
         ,NEW.opr_par_et_pk
         ,NEW.opr_value
         ,NEW.opr_crl_id
         ,NEW.opr_req_id
         ,NEW.opr_uid
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_org_par_briud
BEFORE INSERT OR UPDATE OR DELETE ON ESQ_ORG_PAR
FOR EACH ROW EXECUTE FUNCTION esq_org_par_briud();
