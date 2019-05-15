alter table NFLOW add AUTODELETEFILES char(1);
update NFLOW set AUTODELETEFILES = 'N' where AUTODELETEFILES is null;
alter table NFLOW add AUTODELETEFILEAGE number;
