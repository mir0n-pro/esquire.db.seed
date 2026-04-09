---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_bank_info_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_bank_info_log (
          bil_action
         ,bil_pk
         ,bil_name
         ,bil_bank_name
         ,bil_bank_ccy
         ,bil_aba
         ,bil_swift
         ,bil_acct
         ,bil_addr
         ,bil_city
         ,bil_province
         ,bil_postal_code
         ,bil_country
         ,bil_spec_instr
         ,bil_ben_name
         ,bil_ben_bank_name
         ,bil_ben_branch_name
         ,bil_bank_name_i
         ,bil_aba_i
         ,bil_swift_i
         ,bil_city_i
         ,bil_country_i
         ,bil_ben_name_i
         ,bil_ben_bank_name_i
         ,bil_ben_branch_name_i
         ,bil_crl_id
         ,bil_req_id
         ,bil_uid
        ) VALUES (
          oper
         ,OLD.bi_pk
         ,OLD.bi_name
         ,OLD.bi_bank_name
         ,OLD.bi_bank_ccy
         ,OLD.bi_aba
         ,OLD.bi_swift
         ,OLD.bi_acct
         ,OLD.bi_addr
         ,OLD.bi_city
         ,OLD.bi_province
         ,OLD.bi_postal_code
         ,OLD.bi_country
         ,OLD.bi_spec_instr
         ,OLD.bi_ben_name
         ,OLD.bi_ben_bank_name
         ,OLD.bi_ben_branch_name
         ,OLD.bi_bank_name_i
         ,OLD.bi_aba_i
         ,OLD.bi_swift_i
         ,OLD.bi_city_i
         ,OLD.bi_country_i
         ,OLD.bi_ben_name_i
         ,OLD.bi_ben_bank_name_i
         ,OLD.bi_ben_branch_name_i
         ,OLD.bi_crl_id
         ,OLD.bi_req_id
         ,OLD.bi_uid
        );
        RETURN OLD;
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_bank_info_log (
          bil_action
         ,bil_pk
         ,bil_name
         ,bil_bank_name
         ,bil_bank_ccy
         ,bil_aba
         ,bil_swift
         ,bil_acct
         ,bil_addr
         ,bil_city
         ,bil_province
         ,bil_postal_code
         ,bil_country
         ,bil_spec_instr
         ,bil_ben_name
         ,bil_ben_bank_name
         ,bil_ben_branch_name
         ,bil_bank_name_i
         ,bil_aba_i
         ,bil_swift_i
         ,bil_city_i
         ,bil_country_i
         ,bil_ben_name_i
         ,bil_ben_bank_name_i
         ,bil_ben_branch_name_i
         ,bil_crl_id
         ,bil_req_id
         ,bil_uid
        ) VALUES (
          oper
         ,NEW.bi_pk
         ,NEW.bi_name
         ,NEW.bi_bank_name
         ,NEW.bi_bank_ccy
         ,NEW.bi_aba
         ,NEW.bi_swift
         ,NEW.bi_acct
         ,NEW.bi_addr
         ,NEW.bi_city
         ,NEW.bi_province
         ,NEW.bi_postal_code
         ,NEW.bi_country
         ,NEW.bi_spec_instr
         ,NEW.bi_ben_name
         ,NEW.bi_ben_bank_name
         ,NEW.bi_ben_branch_name
         ,NEW.bi_bank_name_i
         ,NEW.bi_aba_i
         ,NEW.bi_swift_i
         ,NEW.bi_city_i
         ,NEW.bi_country_i
         ,NEW.bi_ben_name_i
         ,NEW.bi_ben_bank_name_i
         ,NEW.bi_ben_branch_name_i
         ,NEW.bi_crl_id
         ,NEW.bi_req_id
         ,NEW.bi_uid
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_bank_info_briud
BEFORE INSERT OR UPDATE OR DELETE ON ESQ_BANK_INFO
FOR EACH ROW EXECUTE FUNCTION esq_bank_info_briud();
