USE BDJEDI
--SELECT * FROM modules WHERE NAME LIKE 'NFE%'


/*
SELECT *
FROM modules
WHERE PATH = 'p:\sisinfor.final\sisprod\progprod\'
*/

DECLARE @modulo varchar(30)  = 'PesqNFVD.pas',
        @moduloID integer,  
        --@path   varchar(200) = 'p:\sisinfor.final\faturam\progfatu\',
        @path   varchar(200) = 'p:\sisinfor.final\generico\',
        @user   varchar(30)  = 'versaoXE2',
        @userid integer  ,
        @nameuser varchar(30),
        @prjid  integer  ,
        @data   datetime     = getutcdate()

SELECT @userid   = USERID
FROM users WHERE login = @user

SELECT @moduloID = MODULEID
FROM modules
WHERE NAME = @modulo
  AND PATH = @path

SELECT @prjid = PROJECTID
FROM pjmodule
WHERE MODULEID = @moduloID

select @nameuser =u.login
FROM modules m
LEFT JOIN users u on u.USERID = m.USERID
WHERE m.MODULEID = @moduloID

IF @nameuser <> 'ronaldo'
BEGIN
   PRINT '
* * * 
*
* Atenção, módulo foi alterado por outra pessoa! --> ' + @nameuser + '
*
* * *'
END


UPDATE modules SET
 READONLY   = '1',
 USERID     = (SELECT USERID FROM users WHERE login = @user),
 TSTAMP     = @data,
 LOCKTSTAMP = @data
WHERE MODULEID = @moduloID

UPDATE projects
 SET LASTUSER   = (SELECT USERID FROM users WHERE login = @user),
     LASTACCESS = @data
where projectid = (select projectid from pjmodule where MODULEID = @moduloID)  

INSERT INTO vcslog
VALUES (
(select projectid from pjmodule where MODULEID = @moduloID),
(SELECT USERID FROM users WHERE login = @user),
@moduloID, @data, 'o',
'Check out module: ' + (select PATH+NAME from modules WHERE MODULEID = @moduloID) 
)

UPDATE revision
SET comment_o = 
--'conversão para o XE2'
'removido na conversão'
WHERE revisionid = (SELECT MAX(revisionid) FROM revision
                    WHERE moduleid = @moduloID)


-- retorno a quantidade de módulos que falta converter
with cte as (
select count(p.RECORDID) as tudo,
       sum(case m.userid when 47 then 1 else 0 end) as xe 
from pjmodule p,
     modules  m,
     users u
where m.MODULEID = P.MODULEID
  and u.USERID   = m.USERID
  and PROJECTID  = @prjid
) select *, 
         tudo - xe as falta,
         round(cast(xe as float) / cast(tudo as float) * 100, 2) AS PROGRESSAO
 from cte 




--select * from vcslog order by TSTAMP desc





