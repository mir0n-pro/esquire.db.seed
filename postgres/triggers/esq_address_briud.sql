---------------------------------------
--
---------------------------------------
CREATE OR REPLACE FUNCTION esq_address_briud()
RETURNS TRIGGER AS $$
DECLARE
    oper CHAR(1) := 'D';
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO esq_address_log (
          adl_action
         ,adl_pk
         ,adl_addr
         ,adl_addr2
         ,adl_city
         ,adl_company
         ,adl_country
         ,adl_department
         ,adl_desc
         ,adl_fax
         ,adl_postal_code
         ,adl_province
         ,adl_title
         ,adl_url
         ,adl_crl_id
         ,adl_req_id
         ,adl_uid
        ) VALUES (
          oper
         ,OLD.ad_pk
         ,OLD.ad_addr
         ,OLD.ad_addr2
         ,OLD.ad_city
         ,OLD.ad_company
         ,OLD.ad_country
         ,OLD.ad_department
         ,OLD.ad_desc
         ,OLD.ad_fax
         ,OLD.ad_postal_code
         ,OLD.ad_province
         ,OLD.ad_title
         ,OLD.ad_url
         ,OLD.ad_crl_id
         ,OLD.ad_req_id
         ,OLD.ad_uid
        );
    ELSE
        IF (TG_OP = 'INSERT') THEN
            oper := 'I';
        ELSE
            oper := 'U';
        END IF;
        INSERT INTO esq_address_log (
          adl_action
         ,adl_pk
         ,adl_addr
         ,adl_addr2
         ,adl_city
         ,adl_company
         ,adl_country
         ,adl_department
         ,adl_desc
         ,adl_fax
         ,adl_postal_code
         ,adl_province
         ,adl_title
         ,adl_url
         ,adl_crl_id
         ,adl_req_id
         ,adl_uid
        ) VALUES (
          oper
         ,NEW.ad_pk
         ,NEW.ad_addr
         ,NEW.ad_addr2
         ,NEW.ad_city
         ,NEW.ad_company
         ,NEW.ad_country
         ,NEW.ad_department
         ,NEW.ad_desc
         ,NEW.ad_fax
         ,NEW.ad_postal_code
         ,NEW.ad_province
         ,NEW.ad_title
         ,NEW.ad_url
         ,NEW.ad_crl_id
         ,NEW.ad_req_id
         ,NEW.ad_uid
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER esq_address_briud
AFTER INSERT OR UPDATE OR DELETE ON ESQ_ADDRESS
FOR EACH ROW EXECUTE FUNCTION esq_address_briud();
