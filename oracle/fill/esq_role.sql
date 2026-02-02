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
PROMPT SYSADMIN
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      1,  'SYSADMIN', 'Y', 'System administrator role');
           
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         1,        30);
    
    -- update, create, delete, security,accounting
    -- System
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,         0, 'N,Y,');

    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        20, 'Y,Y,Y,');

    -- SysAdmin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        30, 'Y,Y,Y,Y,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        32, 'Y,Y,Y,Y,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        34, 'Y,Y,Y,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        36, 'Y,Y,Y,Y,');

    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        50, 'Y,Y,Y,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        52, 'Y,Y,Y,N,Y,');
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         1,        54, 'Y,Y,Y,N,Y,');
    COMMIT;

-----------------------------------
PROMPT SUPERVIZOR 
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      2,  'SUPERVIZOR', 'Y', 'Supervizor role');
           
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         2,        32);
    
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        20, 'Y,Y,Y,');

    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        32, 'Y,Y,Y,Y,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        34, 'Y,Y,Y,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        36, 'Y,Y,Y,Y,');

    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        50, 'Y,Y,Y,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        52, 'Y,Y,Y,N,Y,');
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         2,        54, 'Y,Y,Y,N,Y,');
    COMMIT;


-----------------------------------
PROMPT MANAGER
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES        (      3,    'MANAGER', 'Y', 'Office manager role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         3,        32);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        20, 'Y,Y,Y,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        32, 'Y,Y,Y,Y,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        34, 'Y,Y,Y,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        36, 'Y,Y,Y,Y,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        50, 'Y,Y,Y,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        52, 'Y,Y,Y,N,Y,');
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         3,        54, 'Y,Y,Y,N,Y,');
    COMMIT;

-----------------------------------
PROMPT OPERATOR
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES        (      4,    'OPERATOR', 'Y', 'Office operator role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         4,        32);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        20, 'N,N,N,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        32, 'N,N,N,N,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        34, 'N,Y,N,N,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        36, 'N,Y,N,N,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        50, 'N,Y,N,N,Y,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        52, 'N,Y,N,N,Y,');
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         4,        54, 'Y,Y,Y,N,Y,');
    COMMIT;

-----------------------------------
PROMPT SUPPORT
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      5,     'SUPPORT', 'Y', 'Customer support role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         5,        32);
    -- update, create, delete, security,accounting
    -- Orgranization
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        20, 'N,N,N,');
    -- Admin
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        30, 'N,N,N,N,');
    -- Client
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        32, 'N,Y,N,Y,');
    -- Merchant
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        34, 'N,Y,N,Y,');
    -- Client Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        50, 'N,Y,N,N,N,');
    -- Merchant Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        52, 'N,Y,N,N,N,');
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         5,        54, 'Y,Y,Y,N,Y,');
    COMMIT;

-----------------------------------
PROMPT CLIENT
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      6,     'CLIENT', 'Y', 'Client role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         6,        34);
    -- Paper Clinet Account
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES           (         6,        54, 'N,N,N,N,Y,');
    COMMIT;

-----------------------------------
PROMPT MERCHANT
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      7,     'MERCHANT', 'Y', 'Merchant role');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         7,        36);
    -- Paper Account
    -- INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
    --       VALUES           (         7,        54, 'N,N,N,N,N,');
    COMMIT;

-----------------------------------
PROMPT TREE
-----------------------------------
    INSERT INTO esq_role (role_pk,    role_name, role_admin_flg, role_desc) 
           VALUES       (      8,        'TREE', 'N', 'Use of Esquire api');
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         8,        30);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         8,        32);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         8,        34);
    INSERT INTO esq_role_et (rt_role_pk,  rt_et_pk) 
           VALUES           (         8,        36);
    -- Esqurie API
    INSERT INTO esq_role_prm (rp_role_pk, rp_prm_pk, rp_allowed_flgs) 
           VALUES            (         8,       100, 'Y,');
    COMMIT;


