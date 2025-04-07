SELECT s.spid,
       DB_NAME(s.dbid) AS DB,  
       s.hostname,
	   s.program_name,
	   s.cmd
FROM SYS.SYSPROCESSES S 
WHERE  open_tran > 0
