-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2026
--
-- file :	create/word_index.sql
-- desc:	Word index tables, triggers, and auto-attach procedure
--
-----------------------------------
-- History:
-- 03/07/2026 claude  Created

-- ═══════════════════════════════════════════════════════════════════════════
-- 1. Sequences
-- ═══════════════════════════════════════════════════════════════════════════

PROMPT Creating Sequence 'ESQ_WI_SEQ'
CREATE SEQUENCE ESQ_WI_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

PROMPT Creating Sequence 'ESQ_WIR_SEQ'
CREATE SEQUENCE ESQ_WIR_SEQ START WITH 1 INCREMENT BY 1 NOCACHE
/

-- ═══════════════════════════════════════════════════════════════════════════
-- 2. Tables
-- ═══════════════════════════════════════════════════════════════════════════

PROMPT Creating Table 'ESQ_WORD_INDEX'
CREATE TABLE ESQ_WORD_INDEX
 (WI_PK       NUMBER(16,0) NOT NULL
 ,WI_WORD     VARCHAR2(256) NOT NULL
 )
/

COMMENT ON TABLE ESQ_WORD_INDEX IS 'Unique word dictionary for full-text search'
/
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_PK IS 'Primary key'
/
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_WORD IS 'Lowercase indexed word (unique)'
/

ALTER TABLE ESQ_WORD_INDEX
 ADD CONSTRAINT ESQ_WI_PK PRIMARY KEY (WI_PK)
/

CREATE UNIQUE INDEX ESQ_WI_WORD_UX ON ESQ_WORD_INDEX (WI_WORD)
/


PROMPT Creating Table 'ESQ_WORD_INDEX_REF'
CREATE TABLE ESQ_WORD_INDEX_REF
 (WIR_PK          NUMBER(16,0) NOT NULL
 ,WIR_WI_PK       NUMBER(16,0) NOT NULL
 ,WIR_TABLE_NAME  VARCHAR2(128) NOT NULL
 ,WIR_TABLE_ID    NUMBER(16,0) NOT NULL
 ,WIR_ID_NAME     VARCHAR2(128) NOT NULL
 ,WIR_ID_PK       NUMBER(16,0) NOT NULL
 ,WIR_ET_NAME     VARCHAR2(128) NOT NULL
 ,WIR_ET_PK       INT NOT NULL
 )
/

COMMENT ON TABLE ESQ_WORD_INDEX_REF IS 'Links indexed words to source table rows'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_PK IS 'Primary key'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_WI_PK IS 'Reference to ESQ_WORD_INDEX'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_TABLE_NAME IS 'Source table name (uppercase)'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_TABLE_ID IS 'Primary key value in source table (legacy, same as WIR_ID_PK)'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ID_NAME IS 'PK column name in source table (e.g. USR_PK)'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ID_PK IS 'PK value from source table'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ET_NAME IS 'Entity type column name (e.g. USR_ET_PK)'
/
COMMENT ON COLUMN ESQ_WORD_INDEX_REF.WIR_ET_PK IS 'Entity type value from source table'
/

ALTER TABLE ESQ_WORD_INDEX_REF
 ADD CONSTRAINT ESQ_WIR_PK PRIMARY KEY (WIR_PK)
/

ALTER TABLE ESQ_WORD_INDEX_REF
 ADD CONSTRAINT ESQ_WIR_WI_FK FOREIGN KEY (WIR_WI_PK)
 REFERENCES ESQ_WORD_INDEX (WI_PK) ON DELETE CASCADE
/

CREATE INDEX ESQ_WIR_WI_IX ON ESQ_WORD_INDEX_REF (WIR_WI_PK)
/
CREATE INDEX ESQ_WIR_TBL_IX ON ESQ_WORD_INDEX_REF (WIR_TABLE_NAME, WIR_TABLE_ID)
/
CREATE INDEX ESQ_WIR_ET_IX ON ESQ_WORD_INDEX_REF (WIR_ET_NAME, WIR_ET_PK)
/


-- ═══════════════════════════════════════════════════════════════════════════
-- 3. Core indexing procedure — called by per-table triggers
--    Only processes tables that have a *_ET_PK column.
--    Populates WIR_ID_NAME/WIR_ID_PK with the row PK,
--    and WIR_ET_NAME/WIR_ET_PK with the entity-type column value.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE PROCEDURE esq_word_index_proc(
    p_table_name  IN VARCHAR2,
    p_pk_col      IN VARCHAR2,
    p_et_col      IN VARCHAR2,
    p_pk_val      IN NUMBER,
    p_et_val      IN NUMBER,
    p_operation   IN VARCHAR2    -- 'INSERT', 'UPDATE', 'DELETE'
) AS
    v_table     VARCHAR2(128) := UPPER(p_table_name);
    v_sql       VARCHAR2(4000);
    v_text      VARCHAR2(4000);
    v_word      VARCHAR2(256);
    v_wi_pk     NUMBER(16,0);
    v_cnt       NUMBER;
    v_pos       NUMBER;
    v_end       NUMBER;
    v_len       NUMBER;
    v_raw       VARCHAR2(4000);
    v_ch        VARCHAR2(1);

    CURSOR c_text_cols IS
        SELECT COLUMN_NAME
          FROM USER_TAB_COLUMNS
         WHERE TABLE_NAME = v_table
           AND DATA_TYPE IN ('VARCHAR2', 'CHAR', 'CLOB')
           AND UPPER(COLUMN_NAME) <> UPPER(p_pk_col)
         ORDER BY COLUMN_ID;
BEGIN
    -- ── DELETE / UPDATE: remove old refs, then clean orphan words ────────
    IF p_operation IN ('DELETE', 'UPDATE') THEN
        DELETE FROM ESQ_WORD_INDEX_REF
         WHERE WIR_TABLE_NAME = v_table
           AND WIR_ID_PK     = p_pk_val;

        -- Remove orphan words (no refs left)
        DELETE FROM ESQ_WORD_INDEX wi
         WHERE NOT EXISTS (
             SELECT 1 FROM ESQ_WORD_INDEX_REF wir WHERE wir.WIR_WI_PK = wi.WI_PK
         );
    END IF;

    -- ── INSERT / UPDATE: index all text columns ─────────────────────────
    IF p_operation IN ('INSERT', 'UPDATE') THEN
        FOR col_rec IN c_text_cols LOOP
            v_sql := 'SELECT ' || col_rec.COLUMN_NAME
                  || ' FROM ' || v_table
                  || ' WHERE ' || p_pk_col || ' = :pk';
            BEGIN
                EXECUTE IMMEDIATE v_sql INTO v_text USING p_pk_val;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN v_text := NULL;
            END;

            IF v_text IS NOT NULL AND LENGTH(TRIM(v_text)) > 0 THEN
                -- Replace non-alphanumeric with spaces, then split
                v_raw := LOWER(TRIM(v_text));
                v_raw := REGEXP_REPLACE(v_raw, '[^a-zA-Z0-9' || UNISTR('\0400') || '-' || UNISTR('\04FF') || ']+', ' ');
                v_raw := TRIM(v_raw);

                IF v_raw IS NOT NULL AND LENGTH(v_raw) > 0 THEN
                    -- Parse space-separated words
                    v_raw := v_raw || ' ';  -- trailing sentinel
                    v_pos := 1;
                    v_len := LENGTH(v_raw);

                    WHILE v_pos <= v_len LOOP
                        v_end := INSTR(v_raw, ' ', v_pos);
                        IF v_end = 0 THEN
                            EXIT;
                        END IF;
                        v_word := SUBSTR(v_raw, v_pos, v_end - v_pos);
                        v_pos  := v_end + 1;

                        -- Skip short words
                        IF v_word IS NOT NULL AND LENGTH(v_word) >= 2 THEN
                            -- Upsert word into dictionary
                            SELECT COUNT(*) INTO v_cnt
                              FROM ESQ_WORD_INDEX
                             WHERE WI_WORD = v_word;

                            IF v_cnt = 0 THEN
                                INSERT INTO ESQ_WORD_INDEX (WI_PK, WI_WORD)
                                VALUES (ESQ_WI_SEQ.NEXTVAL, v_word);
                            END IF;

                            SELECT WI_PK INTO v_wi_pk
                              FROM ESQ_WORD_INDEX
                             WHERE WI_WORD = v_word;

                            -- Avoid duplicate refs
                            SELECT COUNT(*) INTO v_cnt
                              FROM ESQ_WORD_INDEX_REF
                             WHERE WIR_WI_PK     = v_wi_pk
                               AND WIR_TABLE_NAME = v_table
                               AND WIR_ID_PK     = p_pk_val;

                            IF v_cnt = 0 THEN
                                INSERT INTO ESQ_WORD_INDEX_REF
                                    (WIR_PK, WIR_WI_PK, WIR_TABLE_NAME, WIR_TABLE_ID,
                                     WIR_ID_NAME, WIR_ID_PK, WIR_ET_NAME, WIR_ET_PK)
                                VALUES
                                    (ESQ_WIR_SEQ.NEXTVAL, v_wi_pk, v_table, p_pk_val,
                                     UPPER(p_pk_col), p_pk_val, UPPER(p_et_col), p_et_val);
                            END IF;
                        END IF;
                    END LOOP;
                END IF;
            END IF;
        END LOOP;
    END IF;
END;
/
SHOW ERRORS
/


-- ═══════════════════════════════════════════════════════════════════════════
-- 4. Auto-attach triggers to ESQ_ tables that have a *_ET_PK column
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE PROCEDURE esq_word_index_attach_triggers AS
    v_tbl       VARCHAR2(128);
    v_pk_col    VARCHAR2(128);
    v_et_col    VARCHAR2(128);
    v_sql       VARCHAR2(4000);

    CURSOR c_tables IS
        SELECT DISTINCT t.TABLE_NAME, c.COLUMN_NAME AS ET_COL
          FROM USER_TABLES t
          JOIN USER_TAB_COLUMNS c
            ON c.TABLE_NAME = t.TABLE_NAME
         WHERE t.TABLE_NAME LIKE 'ESQ_%'
           AND t.TABLE_NAME NOT IN ('ESQ_WORD_INDEX', 'ESQ_WORD_INDEX_REF')
           AND t.TABLE_NAME NOT LIKE '%\_LOG' ESCAPE '\'
           AND c.COLUMN_NAME LIKE '%\_ET\_PK' ESCAPE '\';
BEGIN
    FOR tbl_rec IN c_tables LOOP
        v_tbl    := tbl_rec.TABLE_NAME;
        v_et_col := tbl_rec.ET_COL;

        -- Find PK column (first column of primary key constraint)
        BEGIN
            SELECT cc.COLUMN_NAME INTO v_pk_col
              FROM USER_CONS_COLUMNS cc
              JOIN USER_CONSTRAINTS con
                ON con.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
             WHERE con.TABLE_NAME       = v_tbl
               AND con.CONSTRAINT_TYPE  = 'P'
               AND cc.POSITION          = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No PK found for ' || v_tbl || ', skipping');
                CONTINUE;
        END;

        -- Drop existing trigger if any
        BEGIN
            EXECUTE IMMEDIATE 'DROP TRIGGER ESQ_WI_' || v_tbl;
        EXCEPTION
            WHEN OTHERS THEN NULL;  -- ignore if doesn't exist
        END;

        -- Create AFTER trigger
        v_sql :=
            'CREATE OR REPLACE TRIGGER ESQ_WI_' || v_tbl || ' '
         || 'AFTER INSERT OR UPDATE OR DELETE ON ' || v_tbl || ' '
         || 'FOR EACH ROW '
         || 'BEGIN '
         ||   'IF DELETING THEN '
         ||     'esq_word_index_proc('
         ||       '''' || v_tbl || ''','
         ||       '''' || v_pk_col || ''','
         ||       '''' || v_et_col || ''','
         ||       ':OLD.' || v_pk_col || ','
         ||       ':OLD.' || v_et_col || ','
         ||       '''DELETE'''
         ||     '); '
         ||   'ELSIF INSERTING THEN '
         ||     'esq_word_index_proc('
         ||       '''' || v_tbl || ''','
         ||       '''' || v_pk_col || ''','
         ||       '''' || v_et_col || ''','
         ||       ':NEW.' || v_pk_col || ','
         ||       ':NEW.' || v_et_col || ','
         ||       '''INSERT'''
         ||     '); '
         ||   'ELSE '
         ||     'esq_word_index_proc('
         ||       '''' || v_tbl || ''','
         ||       '''' || v_pk_col || ''','
         ||       '''' || v_et_col || ''','
         ||       ':NEW.' || v_pk_col || ','
         ||       ':NEW.' || v_et_col || ','
         ||       '''UPDATE'''
         ||     '); '
         ||   'END IF; '
         || 'END;';

        EXECUTE IMMEDIATE v_sql;
        DBMS_OUTPUT.PUT_LINE('Word index trigger attached to ' || v_tbl);
    END LOOP;
END;
/
SHOW ERRORS
/

-- Run it now
SET SERVEROUTPUT ON
BEGIN
    esq_word_index_attach_triggers;
END;
/


-- ═══════════════════════════════════════════════════════════════════════════
-- 5. Search helper — find records matching a word prefix
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION esq_word_search(p_query IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    v_cur SYS_REFCURSOR;
BEGIN
    OPEN v_cur FOR
    SELECT wir.WIR_TABLE_NAME  AS TABLE_NAME,
           wir.WIR_ID_NAME     AS ID_NAME,
           wir.WIR_ID_PK       AS ID_PK,
           wir.WIR_ET_NAME     AS ET_NAME,
           wir.WIR_ET_PK       AS ET_PK,
           wi.WI_WORD           AS MATCHED_WORD
      FROM ESQ_WORD_INDEX wi
      JOIN ESQ_WORD_INDEX_REF wir ON wir.WIR_WI_PK = wi.WI_PK
     WHERE wi.WI_WORD LIKE LOWER(p_query) || '%'
     ORDER BY wi.WI_WORD, wir.WIR_TABLE_NAME, wir.WIR_ID_PK;
    RETURN v_cur;
END;
/
SHOW ERRORS
/

COMMENT ON FUNCTION ESQ_WORD_SEARCH IS 'Search word index by prefix. Returns SYS_REFCURSOR.'
/
