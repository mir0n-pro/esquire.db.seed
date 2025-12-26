SPOOL create_user.log

create user esq2025 identified by q;

GRANT 
   CONNECT,
   RESOURCE, 
   UNLIMITED TABLESPACE, 
   alter any role,
   alter user,
   create session,
   CREATE ANY SYNONYM,
   create role,
   create user,
   drop user,
   create view,
   grant any role
TO esq2025;

SPOOL OFF 
