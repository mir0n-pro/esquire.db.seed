-----------------------------------
-- project: Esquire
-- version: 2.0
-- Copyright (c) Miron 2000,2026
--
-- file :   fill/esq_role.sql
-- desc:    Fills sq_role table
--
-----------------------------------
-- History:
--

-----------------------------------
\echo -n 'SUPERVIZOR \n'
\qecho -n 'SUPERVIZOR \n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name, role_desc) 
           VALUES       (      1,  'SUPERVIZOR', 'System administrator role');
           
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         1,        16);
    
    -- update, create, delete, security,accounting
    -- System
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,         0, 'Y,');
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        10, 'Y,Y,Y,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        12, 'Y,Y,Y,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        14, 'Y,Y,Y,Y,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        16, 'Y,Y,Y,Y,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        18, 'Y,Y,Y,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        20, 'Y,Y,Y,N,Y,');
    COMMIT;
END $$;

-----------------------------------
\echo -n 'MANAGER\n'
\qecho -n 'MANAGER\n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name,  role_desc) 
           VALUES        (      2,    'MANAGER', 'Office manager role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         2,        16);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        10, 'Y,Y,Y,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        12, 'Y,Y,Y,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        14, 'Y,Y,Y,Y,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        16, 'Y,Y,Y,Y,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        18, 'Y,Y,Y,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        20, 'Y,Y,Y,N,Y,');
    COMMIT;
END $$;

-----------------------------------
\echo -n 'OPERATOR\n'
\qecho -n 'OPERATOR\n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name, role_desc) 
           VALUES        (      3,    'OPERATOR', 'Office operator role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         3,        16);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        10, 'N,N,N,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        12, 'Y,N,N,N,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        14, 'Y,N,N,N,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        16, 'N,N,N,N,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        18, 'Y,N,N,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        20, 'Y,N,N,N,Y,');
    COMMIT;
END $$;

-----------------------------------
\echo -n 'SUPPORT\n'
\qecho -n 'SUPPORT\n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name, role_desc) 
           VALUES       (      4,     'SUPPORT', 'Customer support role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         4,        16);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        10, 'N,N,N,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        12, 'Y,N,N,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        14, 'Y,N,N,Y,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        16, 'N,N,N,N,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        18, 'Y,N,N,N,N,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        20, 'Y,N,N,N,N,');
    COMMIT;
END $$;

-----------------------------------
\echo -n 'ENDUSER\n'
\qecho -n 'ENDUSER\n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name, role_desc) 
           VALUES       (      5,     'ENDUSER', 'End-user, non-admin, role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         5,        12);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         5,        14);
    COMMIT;
END $$;

-----------------------------------
\echo -n 'TREE\n'
\qecho -n 'TREE\n'
-----------------------------------
DO $$
BEGIN
    INSERT INTO esq_role (role_pk,    role_name, role_desc) 
           VALUES       (      6,        'TREE', 'Use of Esquire api');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         6,        12);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         6,        14);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         6,        16);
    -- Esqurie API
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         6,       100, 'Y,');
    COMMIT;
END $$;

