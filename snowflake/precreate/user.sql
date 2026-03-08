-----------------------------------
-- project:	Esquire
-- version:	2.0
-- Copyright (c) Miron 2000, 2001, 2025
--
-- file :	precreate/user.sql
-- desc:	Snowflake warehouse, database, schema, and role setup
--
-----------------------------------
-- History:
-- 03/08/2026 Snowflake version created

-- Create warehouse
CREATE WAREHOUSE IF NOT EXISTS ESQ_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Create database
CREATE DATABASE IF NOT EXISTS ESQ2025;

-- Use the database
USE DATABASE ESQ2025;

-- Create schema
CREATE SCHEMA IF NOT EXISTS PUBLIC;

-- Create role
CREATE ROLE IF NOT EXISTS ESQ_ROLE;

-- Grant privileges
GRANT USAGE ON WAREHOUSE ESQ_WH TO ROLE ESQ_ROLE;
GRANT ALL PRIVILEGES ON DATABASE ESQ2025 TO ROLE ESQ_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA ESQ2025.PUBLIC TO ROLE ESQ_ROLE;

-- Create user
CREATE USER IF NOT EXISTS ESQ2025
  PASSWORD = 'q'
  DEFAULT_ROLE = ESQ_ROLE
  DEFAULT_WAREHOUSE = ESQ_WH
  DEFAULT_NAMESPACE = ESQ2025.PUBLIC;

-- Grant role to user
GRANT ROLE ESQ_ROLE TO USER ESQ2025;
