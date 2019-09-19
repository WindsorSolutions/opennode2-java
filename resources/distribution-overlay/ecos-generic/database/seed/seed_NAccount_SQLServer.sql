-- prime the db with admin and runtime accounts-- prime the db with admin and runtime accounts
-- update the email addresses to match your admin and runtime email addresses
-- Update the ORGANIZATION_CODE to your agency's code, such as MA or MADEP.

insert into NAccount
(
    Id ,
    NAASAccount ,
    IsActive ,
    SystemRole ,
    Affiliation ,
    ModifiedBy ,
    ModifiedOn
)
values('0000-0000-0000-0000-0000', 
    'node_admin@myagency.gov',
    'Y',
    'Admin',
    'ORGANIZATION_CODE',
    '0000-0000-0000-0000-0000',
    getdate());

insert into NAccount
(
    Id ,
    NAASAccount ,
    IsActive ,
    SystemRole ,
    Affiliation ,
    ModifiedBy ,
    ModifiedOn
)
values('0000-0000-0000-0000-0001', 
    'node_runtime@myagency.gov',
    'Y',
    'Authed',
    'ORGANIZATION_CODE',
    '0000-0000-0000-0000-0000',
    getdate());
