CREATE OR REPLACE TRIGGER esq_account_briud BEFORE INSERT OR DELETE OR UPDATE ON ESQ_ACCOUNT
FOR EACH ROW
---------------------------------------
--
---------------------------------------
DECLARE
    oper VARCHAR2(1) := 'D';
BEGIN
    IF DELETING THEN
        INSERT INTO esq_account_log (
          accl_action
         ,accl_pk
         ,accl_et_pk
         ,accl_path
         ,accl_id
         ,accl_balance
         ,accl_ccy
         ,accl_status
         ,accl_usr_pk
         ,accl_desc
         ,accl_crl_id
         ,accl_req_id
         ,accl_uid
        ) VALUES (
          oper
         ,:OLD.acc_pk
         ,:OLD.acc_et_pk
         ,:OLD.acc_path
         ,:OLD.acc_id
         ,:OLD.acc_balance
         ,:OLD.acc_ccy
         ,:OLD.acc_status
         ,:OLD.acc_usr_pk
         ,:OLD.acc_desc
         ,:OLD.acc_crl_id
         ,:OLD.acc_req_id
         ,:OLD.acc_uid
        );
    ELSE
        oper := 'U';
        IF INSERTING THEN
            oper := 'I';
        END IF;

        INSERT INTO esq_account_log (
          accl_action
         ,accl_pk
         ,accl_et_pk
         ,accl_path
         ,accl_id
         ,accl_balance
         ,accl_ccy
         ,accl_status
         ,accl_usr_pk
         ,accl_desc
         ,accl_crl_id
         ,accl_req_id
         ,accl_uid
        ) VALUES (
          oper
         ,:NEW.acc_pk
         ,:NEW.acc_et_pk
         ,:NEW.acc_path
         ,:NEW.acc_id
         ,:NEW.acc_balance
         ,:NEW.acc_ccy
         ,:NEW.acc_status
         ,:NEW.acc_usr_pk
         ,:NEW.acc_desc
         ,:NEW.acc_crl_id
         ,:NEW.acc_req_id
         ,:NEW.acc_uid
        );
	   END IF;
END;
/
SHOW ERRORS
/



