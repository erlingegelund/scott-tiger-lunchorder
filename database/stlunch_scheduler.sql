BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'send_frokost_bestilling',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'st_lunch.stlunch_mails.send_daily_mails',
   repeat_interval    =>  'FREQ=weekly;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=10;BYMINUTE=5', /* Every working day */
   comments           =>  'Job der sender frokost bestilling til leverandører 10:05 mandag-fredag');
END;
/


BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'send_maaneds_oversigt',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'st_lunch.stlunch_mails.send_month_report',
   repeat_interval    =>  'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=7;BYMINUTE=0', /* First day in month */
   comments           =>  'Job der sender maanedsrapport foerste dag i maaneden');
END;
/

