Declare @tablevar table(principal_id integer, principal_name varchar(100),
                        profile_id integer, profile_name varchar(100), is_default integer) 
SET NOCOUNT ON 
insert into @tablevar exec msdb..sysmail_help_principalprofile_sp
SELECT profile_name FROM @tablevar
GO
