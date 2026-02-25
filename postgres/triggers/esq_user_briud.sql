---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_user_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_user_log (
          usrl_action
         ,usrl_pk
         ,usrl_et_pk
         ,usrl_name
         ,usrl_path
         ,usrl_reg_option
         ,usrl_org_pk
         ,usrl_deleted_flg
         ,usrl_desc
         ,usrl_crl_id
         ,usrl_req_id
         ,usrl_uid
        ) VALUES (
          oper
         ,OLD.usr_pk
         ,OLD.usr_et_pk
         ,OLD.usr_name
         ,OLD.usr_path
         ,OLD.usr_reg_option
         ,OLD.usr_org_pk
         ,OLD.usr_deleted_flg
         ,OLD.usr_desc
         ,OLD.usr_crl_id
         ,OLD.usr_req_id
         ,OLD.usr_uid
        );
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_user_log (
          usrl_action
         ,usrl_pk
         ,usrl_et_pk
         ,usrl_name
         ,usrl_path
         ,usrl_reg_option
         ,usrl_org_pk
         ,usrl_deleted_flg
         ,usrl_desc
         ,usrl_crl_id
         ,usrl_req_id
         ,usrl_uid
        ) VALUES (
          oper
         ,NEW.usr_pk
         ,NEW.usr_et_pk
         ,NEW.usr_name
         ,NEW.usr_path
         ,NEW.usr_reg_option
         ,NEW.usr_org_pk
         ,NEW.usr_deleted_flg
         ,NEW.usr_desc
         ,NEW.usr_crl_id
         ,NEW.usr_req_id
         ,NEW.usr_uid
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_user_briud
AFTER INSERT OR UPDATE OR DELETE ON ESQ_USER
FOR EACH ROW EXECUTE FUNCTION esq_user_briud();
