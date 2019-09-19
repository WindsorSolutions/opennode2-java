-- prime the db with admin and runtime accounts
-- update the email addresses to match your admin and runtime email addresses
-- Update the ORGANIZATION_CODE to your agency's code, such as MA or MADEP.

INSERT
INTO
	NAccount 
	(
		Id ,
		NAASAccount ,
		IsActive ,
		SystemRole ,
		Affiliation ,
		ModifiedBy ,
		ModifiedOn
	)
VALUES
	(
		'00000000-0000-0000-0000-000000000000',
        'node_admin@myagency.gov',
        'Y',
        'Admin',
        'ORGANIZATION_CODE',
		'00000000-0000-0000-0000-000000000000',
		current_timestamp
	)
;
INSERT
INTO
    NAccount 
    (
        Id ,
        NAASAccount ,
        IsActive ,
        SystemRole ,
        Affiliation ,
        ModifiedBy ,
        ModifiedOn
    )
VALUES
    (
        '00000000-0000-0000-0000-000000000001',
		'node_runtime@myagency.gov',
        'Y',
        'Authed',
        'ORGANIZATION_CODE',
        '00000000-0000-0000-0000-000000000000',
        current_timestamp
    )
;
COMMIT
;
