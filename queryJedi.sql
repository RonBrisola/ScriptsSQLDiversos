use BDJEDI

DECLARE @login   VarChar(30),
        @dataIni DATETIME,
		@dataFim DATETIME,
		@obs     VarChar(100)

SET @login   = <_Login, VarChar(30), null>       --filtro por programador
SET @dataIni = <_dataIni, Datetime, null>        --filtro por data
SET @dataFim = <_dataFim, Datetime, null>
SET @obs     = <_obs, VarChar(100), null>        --filtro pela obs. colocada no checkIn ou checkOut
                                                 --pode ser a DEF ou número do chamada   
SELECT u.LOGIN     AS 'Usuário',
       v.TSTAMP    AS 'Data', 
       p.NAME      AS 'Projeto', 
	   m.NAME      AS 'Modulo', 
	   r.REVISION  AS 'Versão', 
	   r.COMMENT_O AS 'Obs_CheckOut',
	   r.COMMENT_I AS 'Obs_CheckIn'
FROM logcomm l, 
     modules m, 
	 projects p, 
	 revision r, 
	 users u, 
	 vcslog v
WHERE (@login IS NULL OR u.LOGIN= @login) 
  AND (v.USERID=u.userid) 
  AND (@dataIni IS NULL OR v.TSTAMP >= @dataIni) 
  AND (@dataFim IS NULL OR v.TSTAMP <= @dataFim) 
  AND (m.MODULEID=v.moduleid) 
  AND (p.PROJECTID=v.projectid) 
  AND (l.LOGID=v.logid) 
  AND (r.REVISIONID=l.revisionid) 
  AND (r.MODULEID=v.moduleid) 
  AND (r.USERID=v.userid)
  AND (@obs IS NULL OR r.COMMENT_I LIKE @obs OR r.COMMENT_O LIKE @obs)  
ORDER BY 2, 3, 1