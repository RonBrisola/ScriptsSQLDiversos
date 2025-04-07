
if exists (select 1 from sysobjects where name = 'sp_datetime_formats')
  drop procedure sp_datetime_formats
go
create procedure sp_datetime_formats
as
begin
/*******************************************************************************************
sp_datetime_formats

Written By:    Doug Deneau, FinServ Technology Services, PLC (Fettan)
Company Desc:  Payment services technology company in Ethoipia
Date Written:  March, 2009
Website:       www.GoFettan.com

This stored procedure is used to generate all datetime formats when using the
CONVERT(varchar(30),@MyDate,<style>) function.  It shows sample formats of each
variation in style parameter.  The output also shows samples for the various
date arguments within the date functions.

INPUT PARAMTERS
---------------
  <none>

OUTPUT DATA
-----------
  WO_Century          - Style argument value without the century in the year (2-digit year)
  WO_Cent_No_Offset   - Sample output without the century in the year and no offset
  WO_Cent_With_Offset - Sample output without the century in the year and offset
  W_Century           - Style argument value with the century in the year (4-digit year)
  W_Cent_No_Offset    - Sample output with the century in the year and no offset
  W_Cent_With_Offset  - Sample output with the century in the year and offset
  DateName_Parm       - Date Part argument name for use in various date functions
  DateName_Example    - Sample data from using the corresponding Date Part argument

MODIFICATION LOG
----------------
  <name> - <datetime> - <description of change>

********************************************************************************************/
set nocount on
declare @Fmt     int,
        @More    char(1),
        @Today   datetime,
        @TodayO  datetimeoffset

select @Today  = GETDATE()
select @TodayO = SYSDATETIMEOFFSET()

create table #data
  (WO_Century           varchar(5)  null,
   WO_Cent_No_Offset    varchar(50) null,
   WO_Cent_With_Offset  varchar(50) null,
   W_Century            int         not null,
   W_Cent_No_Offset     varchar(50) null,
   W_Cent_With_Offset   varchar(50) null,
   DateName_Parm        varchar(50) null,
   DateName_Example     varchar(50) null)

select @More = 'Y', @Fmt = 0
while @More = 'Y' begin
  insert into #data (WO_Century, WO_Cent_No_Offset, WO_Cent_With_Offset, W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select @Fmt,       Convert(varchar(50),@Today,@Fmt),       Convert(varchar(50),@TodayO,@Fmt),
         @Fmt + 100, Convert(varchar(50),@Today,@Fmt + 100), Convert(varchar(50),@TodayO,@Fmt + 100)
  select @Fmt = @Fmt + 1
  if @Fmt > 14 select @More = 'N'
end -- of loop
insert into #data (WO_Century, WO_Cent_No_Offset, WO_Cent_With_Offset, W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 20, Convert(varchar(50),@Today,20), Convert(varchar(50),@TodayO,20), 120, Convert(varchar(50),@Today,120), Convert(varchar(50),@TodayO,120)
insert into #data (WO_Century, WO_Cent_No_Offset, WO_Cent_With_Offset, W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 21, Convert(varchar(50),@Today,21), Convert(varchar(50),@TodayO,21), 121, Convert(varchar(50),@Today,121), Convert(varchar(50),@TodayO,121)
insert into #data (W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 126, Convert(varchar(50),@Today,126), Convert(varchar(50),@TodayO,126)
insert into #data (W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 127, Convert(varchar(50),@Today,127), Convert(varchar(50),@TodayO,127)
insert into #data (W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 130, Convert(varchar(50),@Today,130), Convert(varchar(50),@TodayO,130)
insert into #data (W_Century, W_Cent_No_Offset, W_Cent_With_Offset)
  select 131, Convert(varchar(50),@Today,131), Convert(varchar(50),@TodayO,131)

update #data set WO_Century = '<def>' where WO_Century = '0'

-- datepart formats

update #data set DateName_Parm = 'year,yyyy,yy',    DateName_Example = DATENAME(year,@Today)        where WO_Century = '0'
update #data set DateName_Parm = 'quarter,qq,q',    DateName_Example = DATENAME(quarter,@Today)     where WO_Century = '1'
update #data set DateName_Parm = 'month,mm,m',      DateName_Example = DATENAME(month,@Today)       where WO_Century = '2'
update #data set DateName_Parm = 'dayofyear,dy,y',  DateName_Example = DATENAME(dayofyear,@Today)   where WO_Century = '3'
update #data set DateName_Parm = 'day,dd,d',        DateName_Example = DATENAME(day,@Today)         where WO_Century = '4'
update #data set DateName_Parm = 'week,wk,ww',      DateName_Example = DATENAME(week,@Today)        where WO_Century = '5'
update #data set DateName_Parm = 'weekday,dw',      DateName_Example = DATENAME(weekday,@Today)     where WO_Century = '6'
update #data set DateName_Parm = 'hour,hh',         DateName_Example = DATENAME(hour,@Today)        where WO_Century = '7'
update #data set DateName_Parm = 'minute,mi,mn',    DateName_Example = DATENAME(minute,@Today)      where WO_Century = '8'
update #data set DateName_Parm = 'second,ss,s',     DateName_Example = DATENAME(second,@Today)      where WO_Century = '9'
update #data set DateName_Parm = 'millisecond,ms',  DateName_Example = DATENAME(millisecond,@Today) where WO_Century = '10'
update #data set DateName_Parm = 'microsecond,mcs', DateName_Example = DATENAME(microsecond,@Today) where WO_Century = '11'
update #data set DateName_Parm = 'nanosecond,ns',   DateName_Example = DATENAME(nanosecond,@Today)  where WO_Century = '12'
update #data set DateName_Parm = 'TZoffset,tz',     DateName_Example = DATENAME(TZOFFSET,@TodayO)   where WO_Century = '13'

select * from #data

drop table #data

end -- of procedure
go

EXEC sp_datetime_formats
