Dbcc opentran


select    Distinct
          'Blocking SPID' = b.blocking_session_id,
          'Blocking Host' = bs.hostname,
          'Wait Duration' = b.wait_duration_ms,
          'Wait SPID' = b.session_id,
          'Wait Host' = s.hostname,
          'Program'   = s.program_name
from sys.dm_os_waiting_tasks b
          join master.dbo.sysprocesses bs
                    on b.blocking_session_id = bs.spid
          join master.dbo.sysprocesses s
                    on b.session_id = s.spid
where
          blocking_session_id is not null
