-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000,2001,2026
--
-- file :	create/word_index.sql
-- desc:	Word index tables, triggers, and auto-attach function
--
-----------------------------------
-- History:
-- 03/07/2026 claude  Created
-- 03/07/2026 claude  Only index tables with *_et_pk; add id/et columns to ref

-- ═══════════════════════════════════════════════════════════════════════════
-- 1. Tables
-- ═══════════════════════════════════════════════════════════════════════════

\echo -n Creating Table 'ESQ_WORD_INDEX\n'
CREATE TABLE ESQ_WORD_INDEX
 (WI_PK       UUID DEFAULT gen_random_uuid() NOT NULL
 ,WI_WORD     VARCHAR(256) NOT NULL
);

COMMENT ON TABLE ESQ_WORD_INDEX IS 'Unique word dictionary for full-text search';
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_PK IS 'Primary key (UUID)';
COMMENT ON COLUMN ESQ_WORD_INDEX.WI_WORD IS 'Lowercase indexed word (unique)';

ALTER TABLE ESQ_WORD_INDEX
 ADD CONSTRAINT ESQ_WI_PK PRIMARY KEY (WI_PK);

CREATE UNIQUE INDEX ESQ_WI_WORD_UX ON ESQ_WORD_INDEX (WI_WORD);


\echo -n Creating Table 'ESQ_WORD_INDEX_REF\n'
CREATE TABLE ESQ_WORD_INDEX_REF
 (WIR_PK          UUID DEFAULT gen_random_uuid() NOT NULL
 ,WIR_WI_PK       UUID NOT NULL
 ,WIR_TABLE_NAME  VARCHAR(128) NOT NULL
 ,WIR_TABLE_ID    BIGINT NOT NULL
 ,WIR_ID_NAME     VARCHAR(128) NOT NULL
 ,WIR_ID_PK       BIGINT NOT NULL
 ,WIR_ET_NAME     VARCHAR(128) NOT NULL
 ,WIR_ET_PK       INT NOT NULL
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
 REFERENCES ESQ_WORD_INDEX (WI_PK) ON DELETE CASCADE;

CREATE INDEX ESQ_WIR_WI_IX ON ESQ_WORD_INDEX_REF (WIR_WI_PK);
CREATE INDEX ESQ_WIR_TBL_IX ON ESQ_WORD_INDEX_REF (WIR_TABLE_NAME, WIR_TABLE_ID);
CREATE INDEX ESQ_WIR_ET_IX ON ESQ_WORD_INDEX_REF (WIR_ET_NAME, WIR_ET_PK);


-- ═══════════════════════════════════════════════════════════════════════════
-- 2. Core indexing function — called by per-table triggers
--    Only fires on tables that have a *_et_pk column.
--    Populates WIR_ID_NAME/WIR_ID_PK with the row PK,
--    and WIR_ET_NAME/WIR_ET_PK with the entity-type column value.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION esq_word_index_fn()
RETURNS TRIGGER AS $$
DECLARE
    v_table    VARCHAR := upper(TG_TABLE_NAME);
    v_pk_col   VARCHAR;
    v_pk_val   BIGINT;
    v_et_col   VARCHAR;
    v_et_val   INT;
    v_col      RECORD;
    v_text     TEXT;
    v_word     VARCHAR;
    v_wi_pk    UUID;
    v_words    TEXT[];
BEGIN
    -- ── Find the PK column (first column of the primary key) ────────────
    SELECT a.attname INTO v_pk_col
      FROM pg_index i
      JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
     WHERE i.indrelid = TG_RELID
       AND i.indisprimary
     ORDER BY array_position(i.indkey, a.attnum)
     LIMIT 1;

    IF v_pk_col IS NULL THEN
        RETURN NULL;  -- no PK, skip
    END IF;

    -- ── Find the *_et_pk column ─────────────────────────────────────────
    SELECT column_name INTO v_et_col
      FROM information_schema.columns
     WHERE table_schema = TG_TABLE_SCHEMA
       AND upper(table_name) = v_table
       AND upper(column_name) LIKE '%\_ET\_PK' ESCAPE '\'
     LIMIT 1;

    IF v_et_col IS NULL THEN
        RETURN NULL;  -- no entity type column, skip
    END IF;

    -- ── DELETE / UPDATE: remove old refs, then clean orphan words ────────
    IF TG_OP IN ('DELETE', 'UPDATE') THEN
        EXECUTE format('SELECT ($1).%I::bigint', v_pk_col) INTO v_pk_val USING OLD;

        DELETE FROM ESQ_WORD_INDEX_REF
         WHERE WIR_TABLE_NAME = v_table
           AND WIR_ID_PK     = v_pk_val;

        -- Remove orphan words (no refs left)
        DELETE FROM ESQ_WORD_INDEX wi
         WHERE NOT EXISTS (
             SELECT 1 FROM ESQ_WORD_INDEX_REF wir WHERE wir.WIR_WI_PK = wi.WI_PK
         );
    END IF;

    -- ── INSERT / UPDATE: index all text columns ─────────────────────────
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        EXECUTE format('SELECT ($1).%I::bigint', v_pk_col) INTO v_pk_val USING NEW;
        EXECUTE format('SELECT ($1).%I::int',    v_et_col) INTO v_et_val USING NEW;

        FOR v_col IN
            SELECT column_name, data_type
              FROM information_schema.columns
             WHERE table_schema = TG_TABLE_SCHEMA
               AND upper(table_name) = v_table
               AND data_type IN ('character varying', 'text', 'character')
               AND upper(column_name) <> upper(v_pk_col)
             ORDER BY ordinal_position
        LOOP
            EXECUTE format('SELECT ($1).%I::text', v_col.column_name) INTO v_text USING NEW;

            IF v_text IS NOT NULL AND length(trim(v_text)) > 0 THEN
                -- Split into words: strip non-alphanumeric, lowercase, unique
                v_words := ARRAY(
                    SELECT DISTINCT lower(w)
                      FROM unnest(regexp_split_to_array(v_text, '[^a-zA-Z0-9\u0400-\u04FF]+')) w
                     WHERE length(w) >= 2
                );

                FOREACH v_word IN ARRAY v_words LOOP
                    -- Upsert word
                    INSERT INTO ESQ_WORD_INDEX (WI_WORD)
                    VALUES (v_word)
                    ON CONFLICT (WI_WORD) DO NOTHING;

                    SELECT WI_PK INTO v_wi_pk
                      FROM ESQ_WORD_INDEX
                     WHERE WI_WORD = v_word;

                    -- Avoid duplicate refs
                    INSERT INTO ESQ_WORD_INDEX_REF
                        (WIR_WI_PK, WIR_TABLE_NAME, WIR_TABLE_ID,
                         WIR_ID_NAME, WIR_ID_PK, WIR_ET_NAME, WIR_ET_PK)
                    SELECT v_wi_pk, v_table, v_pk_val,
                           upper(v_pk_col), v_pk_val, upper(v_et_col), v_et_val
                     WHERE NOT EXISTS (
                         SELECT 1 FROM ESQ_WORD_INDEX_REF
                          WHERE WIR_WI_PK     = v_wi_pk
                            AND WIR_TABLE_NAME = v_table
                            AND WIR_ID_PK     = v_pk_val
                     );
                END LOOP;
            END IF;
        END LOOP;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- ═══════════════════════════════════════════════════════════════════════════
-- 3. Auto-attach trigger to ESQ_ tables that have a *_et_pk column
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION esq_word_index_attach_triggers()
RETURNS VOID AS $$
DECLARE
    v_tbl RECORD;
BEGIN
    FOR v_tbl IN
        SELECT DISTINCT t.tablename
          FROM pg_tables t
          JOIN information_schema.columns c
            ON c.table_schema = t.schemaname
           AND upper(c.table_name) = upper(t.tablename)
         WHERE t.schemaname = 'public'
           AND upper(t.tablename) LIKE 'ESQ_%'
           AND upper(t.tablename) NOT IN (
               'ESQ_WORD_INDEX',
               'ESQ_WORD_INDEX_REF'
           )
           AND upper(t.tablename) NOT LIKE '%\_LOG' ESCAPE '\'
           AND upper(c.column_name) LIKE '%\_ET\_PK' ESCAPE '\'
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS esq_wi_%I ON %I',
            v_tbl.tablename, v_tbl.tablename
        );
        EXECUTE format(
            'CREATE TRIGGER esq_wi_%I '
            'AFTER INSERT OR UPDATE OR DELETE ON %I '
            'FOR EACH ROW EXECUTE FUNCTION esq_word_index_fn()',
            v_tbl.tablename, v_tbl.tablename
        );
        RAISE INFO 'Word index trigger attached to %', v_tbl.tablename;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Run it now
SELECT esq_word_index_attach_triggers();


-- ═══════════════════════════════════════════════════════════════════════════
-- 4. Search helper — find records matching a word prefix
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION esq_word_search(p_query VARCHAR)
RETURNS TABLE (
    table_name   VARCHAR,
    id_name      VARCHAR,
    id_pk        BIGINT,
    et_name      VARCHAR,
    et_pk        INT,
    matched_word VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT wir.WIR_TABLE_NAME,
           wir.WIR_ID_NAME,
           wir.WIR_ID_PK,
           wir.WIR_ET_NAME,
           wir.WIR_ET_PK,
           wi.WI_WORD
      FROM ESQ_WORD_INDEX wi
      JOIN ESQ_WORD_INDEX_REF wir ON wir.WIR_WI_PK = wi.WI_PK
     WHERE wi.WI_WORD LIKE lower(p_query) || '%'
     ORDER BY wi.WI_WORD, wir.WIR_TABLE_NAME, wir.WIR_ID_PK;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION esq_word_search IS 'Search word index by prefix. Usage: SELECT * FROM esq_word_search(''john'')';
