---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_account_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_account_log (
          accl_action
         ,accl_pk
         ,accl_et_pk
         ,accl_id
         ,accl_balance
         ,accl_ccy
         ,accl_status
         ,accl_usr_pk
         ,accl_desc
         ,accl_funded_dt
         ,accl_neg_allowed_flg
         ,accl_change_no
         ,accl_crl_id
         ,accl_req_id
         ,accl_uid
        ) VALUES (
          oper
         ,OLD.acc_pk
         ,OLD.acc_et_pk
         ,OLD.acc_id
         ,OLD.acc_balance
         ,OLD.acc_ccy
         ,OLD.acc_status
         ,OLD.acc_usr_pk
         ,OLD.acc_desc
         ,OLD.acc_funded_dt
         ,OLD.acct_neg_allowed_flg
         ,OLD.acc_change_no + 1
         ,OLD.acc_crl_id
         ,OLD.acc_req_id
         ,OLD.acc_uid
        );
        RETURN OLD;
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
            IF NEW.acc_funded_dt IS NULL AND NEW.acc_balance <> OLD.acc_balance THEN
                NEW.acc_funded_dt := CURRENT_TIMESTAMP;
            END IF;
        END IF;
        INSERT INTO esq_account_log (
          accl_action
         ,accl_pk
         ,accl_et_pk
         ,accl_id
         ,accl_balance
         ,accl_ccy
         ,accl_status
         ,accl_usr_pk
         ,accl_desc
         ,accl_funded_dt
         ,accl_neg_allowed_flg
         ,accl_change_no
         ,accl_crl_id
         ,accl_req_id
         ,accl_uid
        ) VALUES (
          oper
         ,NEW.acc_pk
         ,NEW.acc_et_pk
         ,NEW.acc_id
         ,NEW.acc_balance
         ,NEW.acc_ccy
         ,NEW.acc_status
         ,NEW.acc_usr_pk
         ,NEW.acc_desc
         ,NEW.acc_funded_dt
         ,NEW.acct_neg_allowed_flg
         ,NEW.acc_change_no
         ,NEW.acc_crl_id
         ,NEW.acc_req_id
         ,NEW.acc_uid
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_account_briud
BEFORE INSERT OR UPDATE OR DELETE ON ESQ_ACCOUNT
FOR EACH ROW EXECUTE FUNCTION esq_account_briud();
