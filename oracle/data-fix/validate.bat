@echo off
rem === validate.bat -- report ESQ_ENTITY_PATH.EP_PATH mismatches vs the FK hierarchy. NO changes. ===
rem Connection from ORA_* env vars (override as needed); defaults to the local seed account.
cd /d "%~dp0"
if "%ORA_USER%"=="" set ORA_USER=esq2025
if "%ORA_PASS%"=="" set ORA_PASS=q
if "%ORA_CONN%"=="" set ORA_CONN=//localhost:1521/MIR0N
sqlplus -S -L %ORA_USER%/%ORA_PASS%@%ORA_CONN% @fix-path.sql validate
