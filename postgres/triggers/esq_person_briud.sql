---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_person_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    -- Deleting an address unlinks it here through the FK's ON DELETE SET NULL, which the DATABASE issues
    -- as an UPDATE on this row. That is not a business change to the person -- nothing raised the change
    -- number -- so it is not logged. Without this skip the row would be logged again under the SAME
    -- change number and collide with the dedup unique index.
    IF (TG_OP = 'UPDATE'
        AND NEW.pe_change_no = OLD.pe_change_no
        AND ((OLD.pe_ad_pk     IS NOT NULL AND NEW.pe_ad_pk     IS NULL)
          OR (OLD.pe_ad_pk_biz IS NOT NULL AND NEW.pe_ad_pk_biz IS NULL))) THEN
        RETURN NEW;
    END IF;

    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_person_log (
          pel_action
         ,pel_usr_pk
         ,pel_kind
         ,pel_first_name
         ,pel_middle_name
         ,pel_last_name
         ,pel_title
         ,pel_dob
         ,pel_birth_place
         ,pel_sex
         ,pel_tax_id
         ,pel_citizenship
         ,pel_mar_status
         ,pel_person_id_type
         ,pel_person_id_number
         ,pel_email
         ,pel_phone
         ,pel_phone2
         ,pel_ad_pk
         ,pel_ad_pk_biz
         ,pel_change_no
         ,pel_crl_id
         ,pel_req_id
         ,pel_uid
        ) VALUES (
          oper
         ,OLD.pe_usr_pk
         ,OLD.pe_kind
         ,OLD.pe_first_name
         ,OLD.pe_middle_name
         ,OLD.pe_last_name
         ,OLD.pe_title
         ,OLD.pe_dob
         ,OLD.pe_birth_place
         ,OLD.pe_sex
         ,OLD.pe_tax_id
         ,OLD.pe_citizenship
         ,OLD.pe_mar_status
         ,OLD.pe_person_id_type
         ,OLD.pe_person_id_number
         ,OLD.pe_email
         ,OLD.pe_phone
         ,OLD.pe_phone2
         ,OLD.pe_ad_pk
         ,OLD.pe_ad_pk_biz
         ,OLD.pe_change_no + 1
         ,OLD.pe_crl_id
         ,OLD.pe_req_id
         ,OLD.pe_uid
        );
        RETURN OLD;
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_person_log (
          pel_action
         ,pel_usr_pk
         ,pel_kind
         ,pel_first_name
         ,pel_middle_name
         ,pel_last_name
         ,pel_title
         ,pel_dob
         ,pel_birth_place
         ,pel_sex
         ,pel_tax_id
         ,pel_citizenship
         ,pel_mar_status
         ,pel_person_id_type
         ,pel_person_id_number
         ,pel_email
         ,pel_phone
         ,pel_phone2
         ,pel_ad_pk
         ,pel_ad_pk_biz
         ,pel_change_no
         ,pel_crl_id
         ,pel_req_id
         ,pel_uid
        ) VALUES (
          oper
         ,NEW.pe_usr_pk
         ,NEW.pe_kind
         ,NEW.pe_first_name
         ,NEW.pe_middle_name
         ,NEW.pe_last_name
         ,NEW.pe_title
         ,NEW.pe_dob
         ,NEW.pe_birth_place
         ,NEW.pe_sex
         ,NEW.pe_tax_id
         ,NEW.pe_citizenship
         ,NEW.pe_mar_status
         ,NEW.pe_person_id_type
         ,NEW.pe_person_id_number
         ,NEW.pe_email
         ,NEW.pe_phone
         ,NEW.pe_phone2
         ,NEW.pe_ad_pk
         ,NEW.pe_ad_pk_biz
         ,NEW.pe_change_no
         ,NEW.pe_crl_id
         ,NEW.pe_req_id
         ,NEW.pe_uid
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_person_briud
BEFORE INSERT OR UPDATE OR DELETE ON ESQ_PERSON
FOR EACH ROW EXECUTE FUNCTION esq_person_briud();
