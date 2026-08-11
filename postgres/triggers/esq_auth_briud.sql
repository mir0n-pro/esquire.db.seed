---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_auth_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_auth_log (
          aul_action
         ,aul_usr_pk
         ,aul_connect_flg
         ,aul_login_id
         ,aul_email
         ,aul_tfa_method
         ,aul_force_change_flg
         ,aul_security_question
         ,aul_security_answer
         ,aul_change_no
         ,aul_crl_id
         ,aul_req_id
         ,aul_uid
        ) VALUES (
          oper
         ,OLD.au_usr_pk
         ,OLD.au_connect_flg
         ,OLD.au_login_id
         ,OLD.au_email
         ,OLD.au_tfa_method
         ,OLD.au_force_change_flg
         ,OLD.au_security_question
         ,OLD.au_security_answer
         ,OLD.au_change_no + 1
         ,OLD.au_crl_id
         ,OLD.au_req_id
         ,OLD.au_uid
        );
        RETURN OLD;
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_auth_log (
          aul_action
         ,aul_usr_pk
         ,aul_connect_flg
         ,aul_login_id
         ,aul_email
         ,aul_tfa_method
         ,aul_force_change_flg
         ,aul_security_question
         ,aul_security_answer
         ,aul_change_no
         ,aul_crl_id
         ,aul_req_id
         ,aul_uid
        ) VALUES (
          oper
         ,NEW.au_usr_pk
         ,NEW.au_connect_flg
         ,NEW.au_login_id
         ,NEW.au_email
         ,NEW.au_tfa_method
         ,NEW.au_force_change_flg
         ,NEW.au_security_question
         ,NEW.au_security_answer
         ,NEW.au_change_no
         ,NEW.au_crl_id
         ,NEW.au_req_id
         ,NEW.au_uid
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_auth_briud
BEFORE INSERT OR UPDATE OR DELETE ON ESQ_AUTH
FOR EACH ROW EXECUTE FUNCTION esq_auth_briud();
