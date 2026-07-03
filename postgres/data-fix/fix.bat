@echo off
rem === fix.bat -- recompute + UPDATE ESQ_ENTITY_PATH.EP_PATH to the canonical FK-derived value. ===
rem Connection from PG* env vars (override as needed); PGPASSWORD defaults to the local seed password.
cd /d "%~dp0"
if "%PGHOST%"==""     set PGHOST=localhost
if "%PGPORT%"==""     set PGPORT=5432
if "%PGDATABASE%"=="" set PGDATABASE=esq2025
if "%PGUSER%"==""     set PGUSER=esq2025
if "%PGPASSWORD%"=="" set PGPASSWORD=q
psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -v ON_ERROR_STOP=1 -v apply=on -f fix-path.sql
