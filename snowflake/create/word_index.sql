-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2026
--
-- file :	create/word_index.sql
-- desc:	Word index tables and search function (Snowflake)
--
-- NOTE: Snowflake does not support triggers. Word indexing is done via
--       the stored procedure ESQ_WORD_INDEX_REINDEX() which must be called
--       manually or scheduled via a Snowflake Task.
-----------------------------------
-- History:
-- 03/08/2026 Snowflake version created

-- =====================================================================
-- 1. Tables
-- =====================================================================

SELECT 'Creating Table ESQ_WORD_INDEX' AS status;
CREATE TABLE ESQ_WORD_INDEX
 (WI_PK       VARCHAR(36) DEFAULT UUID_STRING() NOT NULL
 ,WI_WORD     VARCHAR(256) NOT NULL
);

COMMENT ON TABLE ESQ_WORD_INDEX IS 'Unique word dictionary for full-text search';
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_PK IS 'Primary key (UUID)';
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_WORD IS 'Lowercase indexed word (unique)';

ALTER TABLE ESQ_WORD_INDEX
 ADD CONSTRAINT ESQ_WI_PK PRIMARY KEY (WI_PK);

CREATE UNIQUE INDEX ESQ_WI_WORD_UX ON ESQ_WORD_INDEX (WI_WORD);


SELECT 'Creating Table ESQ_WORD_INDEX_REF' AS status;
CREATE TABLE ESQ_WORD_INDEX_REF
 (WIR_PK          VARCHAR(36) DEFAULT UUID_STRING() NOT NULL
 ,WIR_WI_PK       VARCHAR(36) NOT NULL
 ,WIR_TABLE_NAME  VARCHAR(128) NOT NULL
 ,WIR_TABLE_ID    NUMBER(16,0) NOT NULL
 ,WIR_ID_NAME     VARCHAR(128) NOT NULL
 ,WIR_ID_PK       NUMBER(16,0) NOT NULL
 ,WIR_ET_NAME     VARCHAR(128) NOT NULL
 ,WIR_ET_PK       NUMBER(10,0) NOT NULL
);

COMMENT ON TABLE ESQ_WORD_INDEX_REF IS 'Links indexed words to source table rows';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_PK IS 'Primary key (UUID)';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_WI_PK IS 'Reference to ESQ_WORD_INDEX';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_TABLE_NAME IS 'Source table name (uppercase)';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_TABLE_ID IS 'Primary key value in source table (legacy, same as WIR_ID_PK)';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ID_NAME IS 'PK column name in source table (e.g. USR_PK)';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ID_PK IS 'PK value from source table';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ET_NAME IS 'Entity type column name (e.g. USR_ET_PK)';
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ET_PK IS 'Entity type value from source table';

ALTER TABLE ESQ_WORD_INDEX_REF
 ADD CONSTRAINT ESQ_WIR_PK PRIMARY KEY (WIR_PK);

ALTER TABLE ESQ_WORD_INDEX_REF
 ADD CONSTRAINT ESQ_WIR_WI_FK FOREIGN KEY (WIR_WI_PK)
 REFERENCES ESQ_WORD_INDEX (WI_PK);

-- =====================================================================
-- 2. Reindex stored procedure
--    Call manually: CALL ESQ_WORD_INDEX_REINDEX();
--    Or schedule via Snowflake Task for periodic re-indexing.
-- =====================================================================

CREATE OR REPLACE PROCEDURE ESQ_WORD_INDEX_REINDEX()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    -- Clear existing index
    DELETE FROM ESQ_WORD_INDEX_REF;
    DELETE FROM ESQ_WORD_INDEX;

    -- Index ESQ_USER (text columns with entity type)
    INSERT INTO ESQ_WORD_INDEX (WI_WORD)
    SELECT DISTINCT LOWER(w.VALUE::VARCHAR)
      FROM ESQ_USER,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(USR_NAME,'') || ' ' || COALESCE(USR_DESC,'') || ' ' || COALESCE(USR_PATH,''),
             ' '
           ) w
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2
       AND LOWER(w.VALUE::VARCHAR) NOT IN (SELECT WI_WORD FROM ESQ_WORD_INDEX);

    INSERT INTO ESQ_WORD_INDEX_REF (WIR_WI_PK, WIR_TABLE_NAME, WIR_TABLE_ID, WIR_ID_NAME, WIR_ID_PK, WIR_ET_NAME, WIR_ET_PK)
    SELECT wi.WI_PK, 'ESQ_USER', u.USR_PK, 'USR_PK', u.USR_PK, 'USR_ET_PK', u.USR_ET_PK
      FROM ESQ_USER u,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(u.USR_NAME,'') || ' ' || COALESCE(u.USR_DESC,'') || ' ' || COALESCE(u.USR_PATH,''),
             ' '
           ) w
      JOIN ESQ_WORD_INDEX wi ON wi.WI_WORD = LOWER(w.VALUE::VARCHAR)
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2;

    -- Index ESQ_ORG (text columns with entity type)
    INSERT INTO ESQ_WORD_INDEX (WI_WORD)
    SELECT DISTINCT LOWER(w.VALUE::VARCHAR)
      FROM ESQ_ORG,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(ORG_NAME,'') || ' ' || COALESCE(ORG_FULL_NAME,'') || ' ' || COALESCE(ORG_DESC,''),
             ' '
           ) w
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2
       AND LOWER(w.VALUE::VARCHAR) NOT IN (SELECT WI_WORD FROM ESQ_WORD_INDEX);

    INSERT INTO ESQ_WORD_INDEX_REF (WIR_WI_PK, WIR_TABLE_NAME, WIR_TABLE_ID, WIR_ID_NAME, WIR_ID_PK, WIR_ET_NAME, WIR_ET_PK)
    SELECT wi.WI_PK, 'ESQ_ORG', o.ORG_PK, 'ORG_PK', o.ORG_PK, 'ORG_ET_PK', o.ORG_ET_PK
      FROM ESQ_ORG o,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(o.ORG_NAME,'') || ' ' || COALESCE(o.ORG_FULL_NAME,'') || ' ' || COALESCE(o.ORG_DESC,''),
             ' '
           ) w
      JOIN ESQ_WORD_INDEX wi ON wi.WI_WORD = LOWER(w.VALUE::VARCHAR)
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2;

    -- Index ESQ_ACCOUNT (text columns with entity type)
    INSERT INTO ESQ_WORD_INDEX (WI_WORD)
    SELECT DISTINCT LOWER(w.VALUE::VARCHAR)
      FROM ESQ_ACCOUNT,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(ACC_ID,'') || ' ' || COALESCE(ACC_DESC,'') || ' ' || COALESCE(ACC_CCY,''),
             ' '
           ) w
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2
       AND LOWER(w.VALUE::VARCHAR) NOT IN (SELECT WI_WORD FROM ESQ_WORD_INDEX);

    INSERT INTO ESQ_WORD_INDEX_REF (WIR_WI_PK, WIR_TABLE_NAME, WIR_TABLE_ID, WIR_ID_NAME, WIR_ID_PK, WIR_ET_NAME, WIR_ET_PK)
    SELECT wi.WI_PK, 'ESQ_ACCOUNT', a.ACC_PK, 'ACC_PK', a.ACC_PK, 'ACC_ET_PK', a.ACC_ET_PK
      FROM ESQ_ACCOUNT a,
           LATERAL SPLIT_TO_TABLE(
             COALESCE(a.ACC_ID,'') || ' ' || COALESCE(a.ACC_DESC,'') || ' ' || COALESCE(a.ACC_CCY,''),
             ' '
           ) w
      JOIN ESQ_WORD_INDEX wi ON wi.WI_WORD = LOWER(w.VALUE::VARCHAR)
     WHERE LENGTH(TRIM(w.VALUE::VARCHAR)) >= 2;

    RETURN 'Word index rebuilt successfully';
END;
$$;

COMMENT ON PROCEDURE ESQ_WORD_INDEX_REINDEX() IS 'Rebuilds the word index for full-text search. Call manually or schedule via Task.';


-- =====================================================================
-- 3. Search function — find records matching a word prefix
-- =====================================================================

CREATE OR REPLACE FUNCTION ESQ_WORD_SEARCH(P_QUERY VARCHAR)
RETURNS TABLE (
    TABLE_NAME   VARCHAR,
    ID_NAME      VARCHAR,
    ID_PK        NUMBER(16,0),
    ET_NAME      VARCHAR,
    ET_PK        NUMBER(10,0),
    MATCHED_WORD VARCHAR
)
AS
$$
    SELECT wir.WIR_TABLE_NAME,
           wir.WIR_ID_NAME,
           wir.WIR_ID_PK,
           wir.WIR_ET_NAME,
           wir.WIR_ET_PK,
           wi.WI_WORD
      FROM ESQ_WORD_INDEX wi
      JOIN ESQ_WORD_INDEX_REF wir ON wir.WIR_WI_PK = wi.WI_PK
     WHERE wi.WI_WORD LIKE LOWER(P_QUERY) || '%'
     ORDER BY wi.WI_WORD, wir.WIR_TABLE_NAME, wir.WIR_ID_PK
$$;

COMMENT ON FUNCTION ESQ_WORD_SEARCH(VARCHAR) IS 'Search word index by prefix. Usage: SELECT * FROM TABLE(ESQ_WORD_SEARCH(''john''))';
